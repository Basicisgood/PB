codeunit 50119 "Review Gen Jnl"
{
    trigger OnRun()
    begin
    end;
    Procedure SendForReview(GenJournalLine_p: Record "Gen. Journal Line")
    var
        UserSetup: Record "User Setup";
        ReviewerID: Code[50];
        GenJournalBatch: Record "Gen. Journal Batch";
        SingleIn: Codeunit "Single Instance Codeunit";
    begin
        Commit();
        UserSetup.Reset();
        UserSetup.Get(UserId);
        UserSetup.TestField("User Type", UserSetup."User Type"::Preparer);
        UserSetup.Reset();
        UserSetup.SetRange("User Type", UserSetup."User Type"::Reviewer);
        GenJournalBatch.Reset();
        GenJournalBatch.Get(GenJournalLine_p."Journal Template Name", GenJournalLine_p."Journal Batch Name");
        ReviewerID:=GenJournalBatch."Reviewer User";
        if ReviewerID = '' then begin
            If Page.RunModal(Page::"User Setup", UserSetup) = Action::LookupOK then ReviewerID:=UserSetup."User ID";
        end;
        ;
        If ReviewerID = '' then exit;
        //SingleIn.Preview(GenJournalLine_p);//#338 //#339 TEC.VJ 21MAY2025
        GenJournalBatch.Reset();
        GenJournalBatch.Get(GenJournalLine_p."Journal Template Name", GenJournalLine_p."Journal Batch Name");
        GenJournalBatch."Reviewer User":=ReviewerID;
        GenJournalBatch."Review Status":=GenJournalBatch."Review Status"::"Pending for Review";
        GenJournalBatch."Prepare User":=UserId;
        GenJournalBatch.Modify();
    end;
    Procedure ConfirmReview(GenJournalLine_p: Record "Gen. Journal Line")
    var
        UserSetup: Record "User Setup";
        // TempUserSetup: Record "User Setup" temporary;
        GenJournalBatch: Record "Gen. Journal Batch";
        GLSetup: record "General Ledger Setup";
        TotalBatchAmount: Decimal;
        BatchCurrency: Code[10];
        WFUserGrp: Code[20];
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        GenLine: Record "Gen. Journal Line";
    begin
        GLSetup.Get();
        GLSetup.TestField("Payment Jnl Approver1 Limit");
        GenJournalBatch.Reset();
        GenJournalBatch.Get(GenJournalLine_p."Journal Template Name", GenJournalLine_p."Journal Batch Name");
        GenJournalBatch.TestField("Review Status", GenJournalBatch."Review Status"::"Pending for Review");
        GenJournalBatch.TestField("Reviewer User");
        UserSetup.Reset();
        UserSetup.Get(UserId);
        UserSetup.TestField("User Type", UserSetup."User Type"::Reviewer);
        GenLine.Reset();
        GenLine.SetRange("Journal Template Name", GenJournalBatch."Journal Template Name");
        GenLine.SetRange("Journal Batch Name", GenJournalBatch.Name);
        GenLine.FindSet();
        repeat if GenLine."Amount (LCY)" > GLSetup."Payment Jnl Approver1 Limit" then begin
                GenJournalBatch.TestField("Approver A Grp User");
                GenJournalBatch.TestField("Approver B Grp User");
            end
            else
                GenJournalBatch.TestField("Approver A Grp User");
        until GenLine.Next() = 0;
        //TotalBatchAmount := GetTotalBatchAmount(GenJournalLine_p);
        //BatchCurrency := GetBatchCurrency(GenJournalLine_p);
        // PBApprovalThresholdLimit.Reset();
        // PBApprovalThresholdLimit.SetCurrentKey("Currency Code", "Threshold Limit");
        // PBApprovalThresholdLimit.SetRange("Currency Code", BatchCurrency);
        // PBApprovalThresholdLimit.SetFilter("Threshold Limit", '>=%1', TotalBatchAmount);
        // PBApprovalThresholdLimit.FindFirst();
        //GetApprovalABusers(GenJournalBatch, PBApprovalThresholdLimit);
        // Message(GenJournalBatch."Approver A Grp User");
        // Message(GenJournalBatch."Approver B Grp User");
        //IF (GenJournalBatch."Approver A Grp User" = '') and (GenJournalBatch."Approver B Grp User" = '') then
        //  Error(ApprovalABblankError);
        WFUserGrp:=CheckandCreateWorkflowUserGroup(GenJournalBatch);
        FindandCreateWorkFlowforApproval(GenJournalBatch, WFUserGrp);
        ApprovalsMgmt.TrySendJournalBatchApprovalRequest(GenJournalLine_p);
    end;
    Procedure RejectReview(GenJournalLine_p: Record "Gen. Journal Line")
    var
        UserSetup: Record "User Setup";
        ReviewerID: Code[50];
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        GenJournalBatch.Reset();
        GenJournalBatch.Get(GenJournalLine_p."Journal Template Name", GenJournalLine_p."Journal Batch Name");
        IF(GenJournalBatch."Review Status" = GenJournalBatch."Review Status"::" ") OR (GenJournalBatch."Review Status" = GenJournalBatch."Review Status"::Rejected)then Error(RejectReviewStatusError);
        GenJournalBatch.TestField("Reviewer User");
        UserSetup.Reset();
        UserSetup.Get(UserId);
        UserSetup.TestField("User Type", UserSetup."User Type"::Reviewer);
        GenJournalBatch."Review Status":=GenJournalBatch."Review Status"::Rejected;
        GenJournalBatch."Prepare User":='';
        GenJournalBatch."Reviewer User":='';
        GenJournalBatch."Review Comments":='';
        GenJournalBatch."Approver A Grp User":='';
        GenJournalBatch."Approver B Grp User":='';
        GenJournalBatch.Modify();
    end;
    Procedure CancelReview(GenJournalLine_p: Record "Gen. Journal Line")
    var
        UserSetup: Record "User Setup";
        ReviewerID: Code[50];
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        GenJournalBatch.Reset();
        GenJournalBatch.Get(GenJournalLine_p."Journal Template Name", GenJournalLine_p."Journal Batch Name");
        IF(GenJournalBatch."Review Status" <> GenJournalBatch."Review Status"::"Pending for Review")then Error(CancelReviewStatusError);
        UserSetup.Reset();
        UserSetup.Get(UserId);
        UserSetup.TestField("User Type", UserSetup."User Type"::Preparer);
        GenJournalBatch."Review Status":=GenJournalBatch."Review Status"::" ";
        GenJournalBatch."Prepare User":='';
        GenJournalBatch."Reviewer User":='';
        // GenJournalBatch."Review Comments" := '';
        GenJournalBatch."Approver A Grp User":='';
        GenJournalBatch."Approver B Grp User":='';
        GenJournalBatch.Modify();
    end;
    local procedure GetTotalBatchAmount(GenJournalLine_p: Record "Gen. Journal Line"): Decimal var
        GenJournalLine_l: Record "Gen. Journal Line";
    begin
        GenJournalLine_l.Reset();
        GenJournalLine_l.SetRange("Journal Template Name", GenJournalLine_p."Journal Template Name");
        GenJournalLine_l.SetRange("Journal Batch Name", GenJournalLine_p."Journal Batch Name");
        GenJournalLine_l.CalcSums(Amount);
        exit(GenJournalLine_l.Amount);
    end;
    local procedure GetBatchCurrency(GenJournalLine_p: Record "Gen. Journal Line"): Code[10]var
        GenJournalLine_l: Record "Gen. Journal Line";
    begin
        GenJournalLine_l.Reset();
        GenJournalLine_l.SetRange("Journal Template Name", GenJournalLine_p."Journal Template Name");
        GenJournalLine_l.SetRange("Journal Batch Name", GenJournalLine_p."Journal Batch Name");
        GenJournalLine_l.SetFilter("Currency Code", '<>%1', '');
        IF GenJournalLine_l.FindFirst()then exit(GenJournalLine_l."Currency Code")
        Else
            exit('');
    end;
    // local procedure GetApprovalABusers(var GenJournalBatch_p: Record "Gen. Journal Batch"; PBApprovalThresholdLimit_p: Record "PB Approval Threshold Limit")
    // var
    //     UserSetup: Record "User Setup";
    //     ApprovalAfound: Boolean;
    //     ApprovalBfound: Boolean;
    //     PageUserSetup: Page "User Setup";
    // begin
    //     UserSetup.Reset();
    //     UserSetup.SetRange("User Type", UserSetup."User Type"::"Approver A group", UserSetup."User Type"::"Approver B group");
    //     Clear(PageUserSetup);
    //     PageUserSetup.SetTableView(UserSetup);
    //     PageUserSetup.Editable(false);
    //     PageUserSetup.LookupMode(true);
    //     If PageUserSetup.RunModal = Action::LookupOK then begin
    //         PageUserSetup.GetSelectedRecords(UserSetup);
    //         IF UserSetup.Count > 2 then
    //             Error(TwoApprovalSelectionError);
    //         IF PBApprovalThresholdLimit_p."No of Apprval users" = PBApprovalThresholdLimit_p."No of Apprval users"::Multiple then begin
    //             UserSetup.FindSet();
    //             repeat
    //                 IF UserSetup."User Type" = UserSetup."User Type"::"Approver A group" then
    //                     ApprovalAfound := true;
    //                 IF UserSetup."User Type" = UserSetup."User Type"::"Approver B group" then
    //                     ApprovalBfound := true;
    //             until UserSetup.Next() = 0;
    //             IF (ApprovalAfound = false) Or (ApprovalBfound = false) then
    //                 Error(ApprovalABMustError);
    //         end
    //         Else IF PBApprovalThresholdLimit_p."No of Apprval users" = PBApprovalThresholdLimit_p."No of Apprval users"::Single then begin
    //             IF UserSetup.Count > 1 then
    //                 Error(OneApprovalSelectionError);
    //             UserSetup.FindSet();
    //             repeat
    //                 IF UserSetup."User Type" = UserSetup."User Type"::"Approver A group" then
    //                     ApprovalAfound := true;
    //                 IF UserSetup."User Type" = UserSetup."User Type"::"Approver B group" then
    //                     ApprovalBfound := true;
    //             until UserSetup.Next() = 0;
    //             IF (ApprovalAfound = True) AND (ApprovalBfound = true) then
    //                 Error(ApprovalAorBError);
    //             IF (ApprovalAfound = false) and (ApprovalBfound = false) then
    //                 Error(ApprovalAorBError);
    //         End;
    //         UserSetup.FindSet();
    //         repeat
    //             IF UserSetup."User Type" = UserSetup."User Type"::"Approver A group" then
    //                 GenJournalBatch_p."Approver A Grp User" := UserSetup."User ID";
    //             IF UserSetup."User Type" = UserSetup."User Type"::"Approver B group" then
    //                 GenJournalBatch_p."Approver B Grp User" := UserSetup."User ID";
    //         until UserSetup.Next() = 0;
    //         // GenJournalBatch_p."Review Status" := GenJournalBatch_p."Review Status"::"Sent for Approval";
    //         GenJournalBatch_p.modify();
    //     end;
    // end;
    local procedure CheckandCreateWorkflowUserGroup(GenJournalBatch: Record "Gen. Journal Batch"): Code[20]var
        A_WorkflowUserGroupMem: Record "Workflow User Group Member";
        B_WorkflowUserGroupMem_2: Record "Workflow User Group Member";
        WUGM_Total: Record "Workflow User Group Member";
        WorkflowUserGroup_1: Record "Workflow User Group";
        WorkFlowUGfound: Boolean;
        WorkFlowUG: Code[20];
        MaxNo: Integer;
    begin
        IF(GenJournalBatch."Approver A Grp User" <> '') AND (GenJournalBatch."Approver B Grp User" <> '')then begin
            A_WorkflowUserGroupMem.Reset();
            A_WorkflowUserGroupMem.SetRange("User Name", GenJournalBatch."Approver A Grp User");
            IF A_WorkflowUserGroupMem.FindSet()then repeat WorkFlowUG:='';
                    WorkFlowUGfound:=false;
                    B_WorkflowUserGroupMem_2.Reset();
                    B_WorkflowUserGroupMem_2.SetRange("Workflow User Group Code", A_WorkflowUserGroupMem."Workflow User Group Code");
                    B_WorkflowUserGroupMem_2.SetRange("User Name", GenJournalBatch."Approver B Grp User");
                    If B_WorkflowUserGroupMem_2.FindFirst()then begin
                        WUGM_Total.Reset();
                        WUGM_Total.SetRange("Workflow User Group Code", B_WorkflowUserGroupMem_2."Workflow User Group Code");
                        IF WUGM_Total.Count() = 2 then begin
                            WorkFlowUG:=B_WorkflowUserGroupMem_2."Workflow User Group Code";
                            WorkFlowUGfound:=true;
                        end;
                    end;
                Until(A_WorkflowUserGroupMem.Next() = 0) or WorkFlowUGfound;
        End;
        IF(GenJournalBatch."Approver A Grp User" <> '') AND (GenJournalBatch."Approver B Grp User" = '')then begin
            A_WorkflowUserGroupMem.Reset();
            A_WorkflowUserGroupMem.SetRange("User Name", GenJournalBatch."Approver A Grp User");
            IF A_WorkflowUserGroupMem.FindSet()then repeat WorkFlowUG:='';
                    WorkFlowUGfound:=false;
                    WUGM_Total.Reset();
                    WUGM_Total.SetRange("Workflow User Group Code", A_WorkflowUserGroupMem."Workflow User Group Code");
                    IF WUGM_Total.Count() = 1 then begin
                        WorkFlowUG:=A_WorkflowUserGroupMem."Workflow User Group Code";
                        WorkFlowUGfound:=true;
                    end;
                Until(A_WorkflowUserGroupMem.Next() = 0) or WorkFlowUGfound;
        end;
        IF(GenJournalBatch."Approver A Grp User" = '') AND (GenJournalBatch."Approver B Grp User" <> '')then begin
            B_WorkflowUserGroupMem_2.Reset();
            B_WorkflowUserGroupMem_2.SetRange("User Name", GenJournalBatch."Approver B Grp User");
            IF B_WorkflowUserGroupMem_2.FindSet()then repeat WorkFlowUG:='';
                    WorkFlowUGfound:=false;
                    WUGM_Total.Reset();
                    WUGM_Total.SetRange("Workflow User Group Code", B_WorkflowUserGroupMem_2."Workflow User Group Code");
                    IF WUGM_Total.Count() = 1 then begin
                        WorkFlowUG:=B_WorkflowUserGroupMem_2."Workflow User Group Code";
                        WorkFlowUGfound:=true;
                    end;
                Until(B_WorkflowUserGroupMem_2.Next() = 0) or WorkFlowUGfound;
        end;
        IF WorkFlowUG = '' then begin
            IF(GenJournalBatch."Approver A Grp User" <> '') AND (GenJournalBatch."Approver B Grp User" <> '')then begin
                WorkflowUserGroup_1.Init();
                WorkflowUserGroup_1.Code:=CopyStr(GenJournalBatch."Approver A Grp User", 1, 10) + CopyStr(GenJournalBatch."Approver B Grp User", 1, 10);
                WorkflowUserGroup_1.Description:=GenJournalBatch."Approver A Grp User" + ' ' + GenJournalBatch."Approver B Grp User";
                WorkflowUserGroup_1.Insert();
                A_WorkflowUserGroupMem.Init();
                A_WorkflowUserGroupMem."Workflow User Group Code":=WorkflowUserGroup_1.Code;
                A_WorkflowUserGroupMem."User Name":=GenJournalBatch."Approver A Grp User";
                A_WorkflowUserGroupMem."Sequence No.":=1;
                A_WorkflowUserGroupMem.Insert();
                B_WorkflowUserGroupMem_2.Init();
                B_WorkflowUserGroupMem_2."Workflow User Group Code":=WorkflowUserGroup_1.Code;
                B_WorkflowUserGroupMem_2."User Name":=GenJournalBatch."Approver B Grp User";
                B_WorkflowUserGroupMem_2."Sequence No.":=2;
                B_WorkflowUserGroupMem_2.Insert();
                WorkFlowUG:=WorkflowUserGroup_1.Code;
            end;
            IF(GenJournalBatch."Approver A Grp User" <> '') AND (GenJournalBatch."Approver B Grp User" = '')then begin
                WorkflowUserGroup_1.Init();
                WorkflowUserGroup_1.Code:=CopyStr(GenJournalBatch."Approver A Grp User", 1, 20);
                WorkflowUserGroup_1.Description:=GenJournalBatch."Approver A Grp User";
                WorkflowUserGroup_1.Insert();
                A_WorkflowUserGroupMem.Init();
                A_WorkflowUserGroupMem."Workflow User Group Code":=WorkflowUserGroup_1.Code;
                A_WorkflowUserGroupMem."User Name":=GenJournalBatch."Approver A Grp User";
                A_WorkflowUserGroupMem."Sequence No.":=1;
                A_WorkflowUserGroupMem.Insert();
                WorkFlowUG:=WorkflowUserGroup_1.Code;
            end;
            IF(GenJournalBatch."Approver A Grp User" = '') AND (GenJournalBatch."Approver B Grp User" <> '')then begin
                WorkflowUserGroup_1.Init();
                WorkflowUserGroup_1.Code:=CopyStr(GenJournalBatch."Approver B Grp User", 1, 20);
                WorkflowUserGroup_1.Description:=GenJournalBatch."Approver B Grp User";
                WorkflowUserGroup_1.Insert();
                B_WorkflowUserGroupMem_2.Init();
                B_WorkflowUserGroupMem_2."Workflow User Group Code":=WorkflowUserGroup_1.Code;
                B_WorkflowUserGroupMem_2."User Name":=GenJournalBatch."Approver B Grp User";
                B_WorkflowUserGroupMem_2."Sequence No.":=1;
                B_WorkflowUserGroupMem_2.Insert();
                WorkFlowUG:=WorkflowUserGroup_1.Code;
            end;
        end;
        // Message(WorkFlowUG);
        exit(WorkFlowUG);
    end;
    local procedure FindandCreateWorkFlowforApproval(GenJournalBatch: Record "Gen. Journal Batch"; WFUserGrp_p: code[20])
    var
        FromWorkflow: Record Workflow;
        ToWorkflow: Record Workflow;
        CopyWorkflow: Report "Copy Workflow";
    begin
        FromWorkflow.Reset();
        IF FromWorkflow.Get(GenJournalBatch."Journal Template Name" + GenJournalBatch.Name)then begin
            IF FromWorkflow.Enabled = false then begin
                FromWorkflow.Validate(Enabled, true);
                FromWorkflow.Modify();
            end;
            AttachWFUserGroupFilter(GenJournalBatch, FromWorkflow, WFUserGrp_p);
        //FromWorkflow.Validate(Enabled, true);
        //FromWorkflow.Modify();
        end
        Else
        begin
            if not FromWorkflow.Get('MS-GJBAPW')then Error('');
            ToWorkflow.Code:=GenJournalBatch."Journal Template Name" + GenJournalBatch.Name;
            ToWorkflow.Init();
            ToWorkflow.Insert();
            CopyWorkflow.InitCopyWorkflow(FromWorkflow, ToWorkflow);
            CopyWorkflow.UseRequestPage(false);
            CopyWorkflow.Run();
            ToWorkflow.Reset();
            ToWorkflow.Get(GenJournalBatch."Journal Template Name" + GenJournalBatch.Name);
            ToWorkflow.Description:=ToWorkflow.Description + GenJournalBatch."Journal Template Name" + GenJournalBatch.Name;
            ToWorkflow.Modify();
            AttachWFBatchFilter(GenJournalBatch, ToWorkflow, WFUserGrp_p);
            ToWorkflow.Validate(Enabled, true);
            ToWorkflow.Modify();
            AttachWFUserGroupFilter(GenJournalBatch, ToWorkflow, WFUserGrp_p);
        end;
    end;
    local procedure AttachWFUserGroupFilter(GenJournalBatch: Record "Gen. Journal Batch"; var Workflow_p: Record Workflow; WFUserGrp_p: Code[20])
    var
        Workflow_l: Record Workflow;
        WFStep_l: Record "Workflow Step";
        WFStep_RESTRICTRECORDUSAGE: Record "Workflow Step";
        WFStep_CREATEAPPROVALREQUESTS: Record "Workflow Step";
        WFStepArg_ToModify: Record "Workflow Step Argument";
        WFEvents_l: Record "Workflow Event";
        ReturnFilters: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Table232">VERSION(1) SORTING(Field1,Field2) WHERE(Field1=1(%1),Field2=1(%2))</DataItem></DataItems></ReportParameters>';
    begin
        //Added condition for batch and journal filter.
        IF Workflow_p.Enabled = false then begin
            Workflow_p.Validate(Enabled, true);
            Workflow_p.modify;
        end;
        Workflow_l.Reset();
        Workflow_l.SetFilter(Code, '%1', Workflow_p.Code);
        Workflow_l.SetFilter(Category, '%1', Workflow_p.Category);
        if Workflow_l.FindFirst()then begin
            // IF Workflow_l.Enabled then
            //     exit;
            WFStep_l.Reset();
            WFStep_l.SetFilter("Workflow Code", Workflow_l.Code);
            WFStep_l.SetFilter("Entry Point", '%1', true);
            WFStep_l.SetFilter(Type, '%1', WFStep_l.Type::"Event");
            if WFStep_l.FindFirst()then begin
                WFStep_RESTRICTRECORDUSAGE.Reset();
                WFStep_RESTRICTRECORDUSAGE.SetFilter("Workflow Code", WFStep_l."Workflow Code");
                WFStep_RESTRICTRECORDUSAGE.SetFilter("Entry Point", '%1', false);
                WFStep_RESTRICTRECORDUSAGE.SetFilter("Function Name", '%1', 'RESTRICTRECORDUSAGE');
                if WFStep_RESTRICTRECORDUSAGE.FindFirst()then begin
                    WFStep_CREATEAPPROVALREQUESTS.Reset();
                    WFStep_CREATEAPPROVALREQUESTS.SetFilter("Workflow Code", WFStep_RESTRICTRECORDUSAGE."Workflow Code");
                    WFStep_CREATEAPPROVALREQUESTS.SetFilter("Entry Point", '%1', false);
                    WFStep_CREATEAPPROVALREQUESTS.SetFilter("Function Name", '%1', 'CREATEAPPROVALREQUESTS');
                    if WFStep_CREATEAPPROVALREQUESTS.FindFirst()then begin
                    end;
                    WFStepArg_ToModify.Reset();
                    if WFStepArg_ToModify.Get(WFStep_CREATEAPPROVALREQUESTS.Argument)then begin
                        WFStepArg_ToModify.Validate("Approver Type", WFStepArg_ToModify."Approver Type"::"Workflow User Group");
                        WFStepArg_ToModify.Validate("Workflow User Group Code", WFUserGrp_p);
                        WFStepArg_ToModify.Modify();
                    //Commit();
                    end;
                end;
            end;
        end;
    end;
    local procedure AttachWFBatchFilter(GenJournalBatch: Record "Gen. Journal Batch"; var Workflow_p: Record Workflow; WFUserGrp_p: Code[20])
    var
        Workflow_l: Record Workflow;
        WFStep_l: Record "Workflow Step";
        WFStep_RESTRICTRECORDUSAGE: Record "Workflow Step";
        WFStep_CREATEAPPROVALREQUESTS: Record "Workflow Step";
        WFStepArg_ToModify: Record "Workflow Step Argument";
        WFEvents_l: Record "Workflow Event";
        ReturnFilters: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Table232">VERSION(1) SORTING(Field1,Field2) WHERE(Field1=1(%1),Field2=1(%2))</DataItem></DataItems></ReportParameters>';
    begin
        //Added condition for batch and journal filter.
        WFStep_l.Reset();
        IF WFStep_l.Get(Workflow_p.Code, 419)then begin
            WFStepArg_ToModify.Reset();
            IF WFStepArg_ToModify.Get(WFStep_l.Argument)then begin
                WFStepArg_ToModify.SetEventFilters(StrSubstNo(ReturnFilters, GenJournalBatch."Journal Template Name", GenJournalBatch.Name));
                WFStepArg_ToModify.Modify();
            end;
        end;
    end;
    procedure CheckOutboundIfAlreadyExist(BankDocNo: Code[20])
    var
        HSBCOutbound: Record "HSBC Outbound Staging Table";
        CitiOutbound: Record "Citi Outbound Staging Table";
    begin
        CitiOutbound.Reset();
        CitiOutbound.SetRange("Bank Document No.", BankDocNo);
        if CitiOutbound.FindFirst()then Error('Citi Outbound already exist for Bank Document No.:%1', BankDocNo);
        HSBCOutbound.Reset();
        HSBCOutbound.SetRange("Bank Document No.", BankDocNo);
        if HSBCOutbound.FindFirst()then Error('HSBC Outbound already exist for Bank Document No.:%1', BankDocNo);
    end;
    local procedure TestFieldPurposeCode(l_GenJournalLine: Record "Gen. Journal Line"; LCYCode: code[20]; Isciti: Boolean; IsBypassAPI: Boolean)
    var
        VendBAnkAcc: Record "Vendor Bank Account";
        CustBankAcc: Record "Customer Bank Account";
        EmpBankAcc: Record "Employee Bank Account";
        Country: Record "Country/Region";
        Vendor: Record Vendor;
    begin
        l_GenJournalLine.TestField("Batch Type"); //VJ#47
        if l_GenJournalLine."Account Type" = l_GenJournalLine."Account Type"::Vendor then begin
            if VendBAnkAcc.get(l_GenJournalLine."Account No.", l_GenJournalLine."Recipient Bank Account")then begin
                // if Country.get(VendBAnkAcc."Country/Region Code") then  //NT_ 13-03-2025 >>
                // Country.Reset();
                // Country.SetRange(Code, VendBAnkAcc."Country/Region Code");
                // Country.SetRange("Local Currency Code", l_GenJournalLine."Currency Code");
                if not Isciti then begin
                    if Country.Get(VendBAnkAcc."Country/Region Code")then begin
                        if Country."Purpose Code (HSBC) Mandatory" then l_GenJournalLine.TestField("Purpose Code")
                        else
                        begin
                            if Country."Local Currency Code" = l_GenJournalLine."Currency Code" then l_GenJournalLine.TestField("Purpose Code");
                            //NT_ 11-02-2025 >>
                            if Country."Local Currency Code" <> l_GenJournalLine."Currency Code" then if l_GenJournalLine."Purpose Code" <> '' then Error('Purpose code must be blank');
                        //NT_ 11-02-2025 <<
                        end;
                    end;
                end
                else
                begin
                    if Country.Get(VendBAnkAcc."Country/Region Code")then begin
                        if Country."Purpose Code (Citi) Mandatory" then l_GenJournalLine.TestField("Purpose Code")
                        else
                        begin
                            if Country."Local Currency Code" = l_GenJournalLine."Currency Code" then l_GenJournalLine.TestField("Purpose Code");
                        end;
                    end;
                end;
                //NT_ 21-03-2025 <<
                if(VendBAnkAcc."Country/Region Code" = 'CN') AND (l_GenJournalLine."Currency Code" = 'CNY') AND (l_GenJournalLine."Purpose Code" = '')then l_GenJournalLine.FieldError(l_GenJournalLine."Purpose Code", 'must have value if Country is CN and Currency is CNY');
                if(VendBAnkAcc."Country/Region Code" = 'CN') AND (LCYCode = 'CNY') AND (l_GenJournalLine."Currency Code" = '') AND (l_GenJournalLine."Purpose Code" = '')then l_GenJournalLine.FieldError(l_GenJournalLine."Purpose Code", 'must have value if Country is CN and LCY Currency is CNY');
                if Isciti then IF Vendor.Get(l_GenJournalLine."Account No.")THEN if Country.Get(Vendor."Country/Region Code") and (Country."Add Mandatory for Address")then Vendor.TestField(Address);
            end;
        end
        else //#271 TEC.VJ 17MAR2025>>
            if l_GenJournalLine."Account Type" = l_GenJournalLine."Account Type"::Customer then begin
                if CustBankAcc.get(l_GenJournalLine."Account No.", l_GenJournalLine."Recipient Bank Account")then begin
                    //NT_ 21-03-2025 >>
                    if not Isciti then begin
                        if Country.Get(CustBankAcc."Country/Region Code")then begin
                            if Country."Purpose Code (HSBC) Mandatory" then l_GenJournalLine.TestField("Purpose Code")
                            else
                            begin
                                if Country."Local Currency Code" = l_GenJournalLine."Currency Code" then l_GenJournalLine.TestField("Purpose Code");
                                //NT_ 11-02-2025 >>
                                if Country."Local Currency Code" <> l_GenJournalLine."Currency Code" then if l_GenJournalLine."Purpose Code" <> '' then Error('Purpose code must be blank');
                            //NT_ 11-02-2025 <<
                            end;
                        end;
                    end
                    else
                    begin
                        if Country.Get(CustBankAcc."Country/Region Code")then begin
                            if Country."Purpose Code (Citi) Mandatory" then l_GenJournalLine.TestField("Purpose Code")
                            else
                            begin
                                if Country."Local Currency Code" = l_GenJournalLine."Currency Code" then l_GenJournalLine.TestField("Purpose Code");
                            end;
                        end;
                    end;
                    //NT_ 21-03-2025 <<
                    if(CustBankAcc."Country/Region Code" = 'CN') AND (l_GenJournalLine."Currency Code" = 'CNY') AND (l_GenJournalLine."Purpose Code" = '')then l_GenJournalLine.FieldError(l_GenJournalLine."Purpose Code", 'must have value if Country is CN and Currency is CNY');
                    if(CustBankAcc."Country/Region Code" = 'CN') AND (LCYCode = 'CNY') AND (l_GenJournalLine."Currency Code" = '') AND (l_GenJournalLine."Purpose Code" = '')then l_GenJournalLine.FieldError(l_GenJournalLine."Purpose Code", 'must have value if Country is CN and LCY Currency is CNY');
                end;
            end
            else if l_GenJournalLine."Account Type" = l_GenJournalLine."Account Type"::Employee then begin
                    if EmpBankAcc.get(l_GenJournalLine."Account No.", l_GenJournalLine."Employee Bank Account")then begin
                        //NT_ 21-03-2025>>
                        if not Isciti then begin
                            if Country.Get(EmpBankAcc."Country/Region Code")then begin
                                if Country."Purpose Code (HSBC) Mandatory" then l_GenJournalLine.TestField("Purpose Code")
                                else
                                begin
                                    if Country."Local Currency Code" = l_GenJournalLine."Currency Code" then l_GenJournalLine.TestField("Purpose Code");
                                    //NT_ 11-02-2025 >>
                                    if Country."Local Currency Code" <> l_GenJournalLine."Currency Code" then if l_GenJournalLine."Purpose Code" <> '' then Error('Purpose code must be blank');
                                //NT_ 11-02-2025 <<
                                end;
                            end;
                        end
                        else
                        begin
                            if Country.Get(EmpBankAcc."Country/Region Code")then begin
                                if Country."Purpose Code (Citi) Mandatory" then l_GenJournalLine.TestField("Purpose Code")
                                else
                                begin
                                    if Country."Local Currency Code" = l_GenJournalLine."Currency Code" then l_GenJournalLine.TestField("Purpose Code");
                                end;
                            end;
                        end;
                        //NT_ 21-03-2025<<
                        if(EmpBankAcc."Country/Region Code" = 'CN') AND (l_GenJournalLine."Currency Code" = 'CNY') AND (l_GenJournalLine."Purpose Code" = '')then l_GenJournalLine.FieldError(l_GenJournalLine."Purpose Code", 'must have value if Country is CN and Currency is CNY');
                        if(EmpBankAcc."Country/Region Code" = 'CN') AND (LCYCode = 'CNY') AND (l_GenJournalLine."Currency Code" = '') AND (l_GenJournalLine."Purpose Code" = '')then l_GenJournalLine.FieldError(l_GenJournalLine."Purpose Code", 'must have value if Country is CN and LCY Currency is CNY');
                    end;
                end;
        CheckOutboundIfAlreadyExist(l_GenJournalLine."Bank Document No.");
        //VJ 05March2025 Start
        if not IsBypassAPI then if l_GenJournalLine.Amount <> l_GenJournalLine."Applied Amount" then if not confirm('Amount and Applied Amount are not matched in bank document no. %1. Do you want to continue?', false, l_GenJournalLine."Bank Document No.")then Error('process stopped');
    //VJ 05March2025 End
    //#271 TEC.VJ 17MAR2025<<
    end;
    local procedure StrlengthError(Address: text[100]; Address2: text[100])
    begin
        if StrLen(Address) > 35 then Error(StrSubstNo('The length of the string is %1, but it must be less then 35 characters. Value:%2', StrLen(Address), Address));
        if StrLen(Address2) > 35 then Error(StrSubstNo('The length of the string is %1, but it must be less then 35 characters. Value:%2', StrLen(Address2), Address2));
    end;
    procedure RunCheckBeforeReview(p_Genjnlline: Record "Gen. Journal Line");
    var
        l_GenJournalLine: Record "Gen. Journal Line";
        GLSetup: Record "General Ledger Setup";
        PaymentMethod: Record "Payment Method";
        BankAcc: Record "Bank Account";
        VendorBankAcc: Record "Vendor Bank Account";
        CustomerBankAcc: Record "Customer Bank Account";
        HSBCOutbound: Record "HSBC Outbound Staging Table";
        CitiOutbound: Record "Citi Outbound Staging Table";
        PaymentSetCde: Record "Payment Set Code";
        Vendor: Record Vendor;
        HSBCOutboundCodeunit: Codeunit HSBCOutboundCodeunit;
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        GLSetup.Get();
        GLSetup.TestField("Bank Document Nos."); //VJ#47 12DEC2024
        l_GenJournalLine.Reset();
        l_GenJournalLine.SetRange("Journal Template Name", p_Genjnlline."Journal Template Name");
        l_GenJournalLine.SetRange("Journal Batch Name", p_Genjnlline."Journal Batch Name");
        if l_GenJournalLine.findset then repeat GenJournalBatch.Get(l_GenJournalLine."Journal Template Name", l_GenJournalLine."Journal Batch Name"); //VJ 05Mar2025
                HSBCOutboundCodeunit.VerifyBeforeApprove(l_GenJournalLine); //#185 TEC.VJ 23012025
                if PaymentMethod.Get(l_GenJournalLine."Payment Method Code")then;
                l_GenJournalLine.TestField("Bank Document No."); //VJ 21Jan2025
                CheckifBankDocumentNoExistInOtherBatches(l_GenJournalLine); //VJ 05Feb2025
                /* //#167 COMMENTED 17jan2025
                if (l_GenJournalLine."FPS Type" = l_GenJournalLine."FPS Type"::" ") and (l_GenJournalLine."FPS No." = '') and (l_GenJournalLine."Recipient Bank Account" = '') and (PaymentMethod."FPS/FPP") then
                    l_GenJournalLine.FieldError(l_GenJournalLine."Recipient Bank Account", 'must have value if FPS Type & FPS No. are empty');
*/
                if(l_GenJournalLine."Bal. Account Type" = l_GenJournalLine."Bal. Account Type"::"Bank Account") and (l_GenJournalLine."Bal. Account No." <> '')then begin
                    BankAcc.Get(l_GenJournalLine."Bal. Account No.");
                    if BankAcc."Bank Integration Type" = BankAcc."Bank Integration Type"::HSBC then begin
                        //AssignBankDocumentNo(l_GenJournalLine);
                        TestFieldPurposeCode(l_GenJournalLine, GLSetup."LCY Code", false, GenJournalBatch."Bypass API"); //#271 TEC.V 
                    end
                    else if BankAcc."Bank Integration Type" = BankAcc."Bank Integration Type"::Citi then begin
                            //AssignBankDocumentNo(l_GenJournalLine);
                            TestFieldPurposeCode(l_GenJournalLine, GLSetup."LCY Code", true, GenJournalBatch."Bypass API"); //#271 TEC.VJ
                        end;
                end;
                //#359 TEC.VJ >> Resolve strlen Error on approval
                if(l_GenJournalLine."Account Type" = l_GenJournalLine."Account Type"::"Bank Account") and (l_GenJournalLine."Account No." <> '')then begin
                    BankAcc.Get(l_GenJournalLine."Account No.");
                    StrlengthError(BankAcc.Address, BankAcc."Address 2");
                end;
                if(l_GenJournalLine."Account Type" = l_GenJournalLine."Account Type"::Vendor) and (l_GenJournalLine."Account No." <> '') and (l_GenJournalLine."Recipient Bank Account" <> '')then begin
                    VendorBankAcc.Get(l_GenJournalLine."Account No.", l_GenJournalLine."Recipient Bank Account");
                    StrlengthError(VendorBankAcc.Address, VendorBankAcc."Address 2");
                end;
                if(l_GenJournalLine."Account Type" = l_GenJournalLine."Account Type"::Customer) and (l_GenJournalLine."Account No." <> '') and (l_GenJournalLine."Recipient Bank Account" <> '')then begin
                    CustomerBankAcc.Get(l_GenJournalLine."Account No.", l_GenJournalLine."Recipient Bank Account");
                    StrlengthError(CustomerBankAcc.Address, CustomerBankAcc."Address 2");
                end;
                //#359 TEC.VJ <<
                //>>VJ06DEC2024
                if PaymentSetCde.Get(l_GenJournalLine."Payment Set Code") and (PaymentSetCde."Last Used Date" = Today)then Error('Payment Set Code is already used for today.');
            //<<VJ06DEC2024
            until l_GenJournalLine.Next() = 0;
    end;
    procedure RunCheckBeforeReviewForIC(p_Genjnlline: Record "Gen. Journal Line");
    var
        l_GenJournalLine: Record "Gen. Journal Line";
        ICJournalLine: Record "Gen. Journal Line";
        GLSetup: Record "General Ledger Setup";
        PaymentSetCde: Record "Payment Set Code";
        GenJournalBatch: Record "Gen. Journal Batch";
        HSBCOutboundCodeunit: Codeunit HSBCOutboundCodeunit;
    begin
        GLSetup.Get();
        GLSetup.TestField("Bank Document Nos.");
        l_GenJournalLine.Reset();
        l_GenJournalLine.SetRange("Journal Template Name", p_Genjnlline."Journal Template Name");
        l_GenJournalLine.SetRange("Journal Batch Name", p_Genjnlline."Journal Batch Name");
        if l_GenJournalLine.findset then repeat GenJournalBatch.Get(l_GenJournalLine."Journal Template Name", l_GenJournalLine."Journal Batch Name");
                l_GenJournalLine.TestField("Bank Document No.");
                HSBCOutboundCodeunit.VerifyBeforeApprove(l_GenJournalLine); //#321 TEC.VJ 29APR2025
                CheckifBankDocumentNoExistInOtherBatches(l_GenJournalLine);
                CheckOutboundIfAlreadyExist(l_GenJournalLine."Bank Document No.");
                if PaymentSetCde.Get(l_GenJournalLine."Payment Set Code") and (PaymentSetCde."Last Used Date" = Today)then Error('Payment Set Code is already used for today.');
                //TEC.VJ 25042025>>
                ICJournalLine.Reset();
                ICJournalLine.CopyFilters(l_GenJournalLine);
                ICJournalLine.SetRange("Document No.", l_GenJournalLine."Document No.");
                ICJournalLine.SetLoadFields(Amount);
                if ICJournalLine.FindSet()then begin
                    ICJournalLine.CalcSums(Amount);
                    if ICJournalLine.Amount <> 0 then Error('Document No. %1 is not Balanced.', ICJournalLine."Document No.");
                end;
            //TEC.VJ 25042025<<
            until l_GenJournalLine.Next() = 0;
    end;
    procedure AssignBankDocumentNo(var p_PaymentJournal: Record "Gen. Journal Line")
    var
        l_PaymentJournal: Record "Gen. Journal Line";
        l_GLSetup: Record "General Ledger Setup";
        l_BankDocNo: Code[20];
        NoSeriesMgmt: Codeunit "No. Series";
    begin
        if p_PaymentJournal."Bank Document No." <> '' then exit;
        l_BankDocNo:=NoSeriesMgmt.GetNextNo(l_GLSetup."Bank Document Nos.");
        p_PaymentJournal."Bank Document No.":=l_BankDocNo;
        p_PaymentJournal.Modify();
    end;
    // //#321 TEC.VJ 29APR2025>>
    // procedure VerifyBeforeApprove(var PaymentJournal: record "Gen. Journal Line")
    // var
    //     HSBCOutbound: Record "HSBC Outbound Staging Table";
    // begin
    //     //vj 05March2025 Start 
    //     HSBCOutbound.Reset();
    //     HSBCOutbound.SetRange("Bank Document No.", PaymentJournal."Bank Document No.");
    //     if HSBCOutbound.FindFirst() then
    //         Error('HSBC Outbound already exist for Bank Document No.:%1', PaymentJournal."Bank Document No.");
    //     //vj 05March2025 End
    //     case PaymentJournal."Batch Type" of
    //         "Batch Type"::"HK Upper Value",
    //         "Batch Type"::"US Upper Value",
    //         "Batch Type"::CITI392,
    //         "Batch Type"::CITI391,
    //         "Batch Type"::CITI403,
    //         "Batch Type"::CITI393:
    //             begin
    //                 TestMandotoryFields(PaymentJournal);
    //             end;
    //         "Batch Type"::"HK Lower Value":
    //             begin
    //                 TestMandotoryFields(PaymentJournal);
    //                 PaymentJournal.TestField("Payment Set Code");
    //             end;
    //         "Batch Type"::CITI949:
    //             begin
    //                 TestMandotoryFields(PaymentJournal);
    //                 PaymentJournal.TestField("Purpose Code");
    //                 PaymentJournal.TestField("IFSC Code");
    //             end;
    //     end;
    // end;
    // local procedure TestMandotoryFields(var PaymentJournal: record "Gen. Journal Line")
    // begin
    //     if PaymentJournal."Account Type" <> PaymentJournal."Account Type"::Customer then
    //         PaymentJournal.TestField("Document Type");
    //     PaymentJournal.TestField("Posting Date");
    //     PaymentJournal.TestField("Document No.");
    //     PaymentJournal.TestField("Bank Document No.");
    //     PaymentJournal.TestField("Account Type");
    //     PaymentJournal.TestField("Account No.");
    //     PaymentJournal.TestField("Description");
    //     PaymentJournal.TestField("Payment Method Code");
    //     PaymentJournal.TestField("Amount");
    //     PaymentJournal.TestField("Charges Bearer");
    //     PaymentJournal.TestField("Bal. Account Type");
    //     PaymentJournal.TestField("Bal. Account No.");
    //     PaymentJournal.TestField("Shortcut Dimension 1 Code");
    //     PaymentJournal.TestField("Shortcut Dimension 2 Code");
    //     PaymentJournal.TestField("Shortcut Dimension 8 Code");
    // end;
    // //#321 TEC.VJ 29APR2025<<
    procedure CheckifBankDocumentNoExistInOtherBatches(p_genjnlline: Record "Gen. Journal Line")
    var
        l_genjnlline: Record "Gen. Journal Line";
        Text0001: Label '%1 already exist';
    begin
        //>>#200 VJ 05Feb2025
        l_genjnlline.Reset();
        l_genjnlline.SetFilter("Journal Batch Name", '<>%1', p_genjnlline."Journal Batch Name");
        l_genjnlline.Setrange("Bank Document No.", p_genjnlline."Bank Document No.");
        if l_genjnlline.FindFirst()then //l_genjnlline.FieldError(l_genjnlline."Bank Document No.", 'already exist');
            l_genjnlline.FieldError(l_genjnlline."Bank Document No.", StrSubstNo(Text0001, l_genjnlline."Bank Document No."));
    //<<#200 VJ 05Feb2025
    end;
    procedure RunCheckBeforePost(p_Genjnlline: Record "Gen. Journal Line");
    var
        l_GenJournalLine: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        //VJ 05Mar2025 Created new function for cheecking before posting for non api
        l_GenJournalLine.Reset();
        l_GenJournalLine.SetRange("Journal Template Name", p_Genjnlline."Journal Template Name");
        l_GenJournalLine.SetRange("Journal Batch Name", p_Genjnlline."Journal Batch Name");
        if l_GenJournalLine.findset then repeat GenJournalBatch.Get(l_GenJournalLine."Journal Template Name", l_GenJournalLine."Journal Batch Name");
                //VJ 05March2025 Start
                if GenJournalBatch."Bypass API" then if l_GenJournalLine.Amount <> l_GenJournalLine."Applied Amount" then if not confirm('Amount and Applied Amount are not matched in bank document no. %1. Do you want to continue?', false, l_GenJournalLine."Bank Document No.")then Error('process stopped');
                //VJ 05March2025 End
                if GenJournalBatch."Bypass API" then RunBankDocumentNoChecking(l_GenJournalLine);
            until l_GenJournalLine.Next() = 0;
    end;
    procedure RunBankDocumentNoChecking(var l_GenJournalLine: Record "Gen. Journal Line");
    var
        BankAcc: Record "Bank Account";
        HSBCOutbound: Record "HSBC Outbound Staging Table";
        CitiOutbound: Record "Citi Outbound Staging Table";
        HSBCOutboundCodeunit: Codeunit HSBCOutboundCodeunit;
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        //VJ 05Mar2025 new function
        //>>VJ 11MAR2025
        if l_GenJournalLine."Bank Document No." = '' then exit;
        //<<VJ 11MAR2025
        GenJournalBatch.Get(l_GenJournalLine."Journal Template Name", l_GenJournalLine."Journal Batch Name");
        CheckifBankDocumentNoExistInOtherBatches(l_GenJournalLine);
        CheckOutboundIfAlreadyExist(l_GenJournalLine."Bank Document No.");
    end;
    var RejectReviewStatusError: Label 'Review Status must be "Pending for Review" or "Reviewed"';
    CancelReviewStatusError: Label 'Review Status must be "Pending for Review"';
    TwoApprovalSelectionError: Label 'Only 2 Approval user can be selected max.';
    OneApprovalSelectionError: Label 'Only 1 Approval user can be selected max.';
    ApprovalAorBError: Label 'You must select either "Approval A" Or "Approval B" user.';
    ApprovalABMustError: Label 'You must select One "Approval A" and one "Approval B" user.';
    ApprovalABblankError: Label '"Approval A" and "Approval B" user are blank. Approval did not send.';
}
