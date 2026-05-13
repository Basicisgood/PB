codeunit 50195 "Create Rejection Batch Lines"
{
    TableNo = "Gen. Journal Line";
    Permissions = tabledata "Employee Ledger Entry"=RM,
        tabledata "Cust. Ledger Entry"=RM,
        tabledata "Vendor Ledger Entry"=RM;

    trigger OnRun()
    begin
        MoveToRejectedJournal(Rec);
    end;
    Procedure MoveToRejectedJournal(var GenJournalLine_p: Record "Gen. Journal Line")
    var
        GenJnlBatch_From: Record "Gen. Journal Batch";
        GenJnlBatch_New: Record "Gen. Journal Batch";
        CurrBatch: Text[10];
        NewBatch: Text[10];
        RejVersion: Integer;
        R_Position: Integer;
        GenJnlLineRejected: Record "Gen. Journal Line";
        HSBCOutbound: Record "HSBC Outbound Staging Table";
        CitiOutbound: Record "Citi Outbound Staging Table";
        UpdateBankDocNo: Boolean;
        BankApiSetup: Record "Bank API Setup";
        NoSMgmt: Codeunit "No. Series";
        GEnJnlLineBatch: Record "Gen. Journal Line";
        ApprovalMgmt: Codeunit "Approvals Mgmt.";
        GenJnlBatchApprovalStatus: Text[20];
    begin
        BankApiSetup.Get();
        GLSetp.Get();
        IF TempDocNo.IsTemporary THEN TempDocNo.DeleteAll();
        CurrBatch:=GenJournalLine_p."Journal Batch Name";
        If CurrBatch.Contains('_R')then begin
            R_Position:=StrPos(CurrBatch, '_R');
            NewBatch:=IncStr(CurrBatch);
        end
        Else
        begin
            //#317 TEC.VJ 23APR2025>>
            GenJnlBatch_From.Reset();
            GenJnlBatch_From.SetRange("Journal Template Name", GenJournalLine_p."Journal Template Name");
            //GenJnlBatch_From.SetFilter(Name, '=%1', CurrBatch + '_R*');
            GenJnlBatch_From.SetFilter(Name, CurrBatch + '_R*'); //VJ 10072025 Fixed not able to get last record
            if GenJnlBatch_From.FindLast()THEN begin
                //22Aug2025 added condition to check if batch no. should increment or not - to combine in same batch R1 unless it is approved/rejected  discussed with Rajan start
                GEnJnlLineBatch.RESET;
                GEnJnlLineBatch.SetRange("Journal Template Name", GenJnlBatch_From."Journal Template Name");
                GEnJnlLineBatch.SetRange("Journal Batch Name", GenJnlBatch_From.Name);
                ApprovalMgmt.GetGenJnlBatchApprovalStatus(GEnJnlLineBatch, GenJnlBatchApprovalStatus, true);
                if(GenJnlBatchApprovalStatus = 'Open') or (GenJnlBatchApprovalStatus = '')then // should increase batch if batch status is approved/reject
 NewBatch:=GenJnlBatch_From.Name
                else
                    //22Aug2025 added end
                    //NewBatch := IncStr(CurrBatch)//#389 31072025 Fixed
                    NewBatch:=IncStr(GenJnlBatch_From.Name) //#389 31072025 Fixed issue of second reject line which is not moving into any rejection batch and deleted from payment journal
            //#317 TEC.VJ 23APR2025<<
            end
            ELSE
                NewBatch:=CurrBatch + '_R1';
        end;
        GenJnlBatch_From.Get(GenJournalLine_p."Journal Template Name", CurrBatch);
        //TEC.VJ 16012025>>
        GenJnlBatch_New.Reset();
        GenJnlBatch_New.SetRange("Journal Template Name", GenJnlBatch_From."Journal Template Name");
        GenJnlBatch_New.SetRange(Name, NewBatch);
        if not GenJnlBatch_New.FindFirst()then begin
            GenJnlBatch_New.Init();
            GenJnlBatch_New:=GenJnlBatch_From; //TEC.VJ 15012025
            GenJnlBatch_New.Name:=NewBatch;
            GenJnlBatch_New."Review Status":=GenJnlBatch_New."Review Status"::" "; //#174 TEC.VJ 24012025 
            GenJnlBatch_New."No. of Approved":=0;
            GenJnlBatch_New."No. of Pending":=0;
            GenJnlBatch_New."No. of Rejected":=0;
            GenJnlBatch_New."Total No.":=0;
            GenJnlBatch_New."No Deletion After Post":=false; //#313 TEC.VJ22APR2025
            GenJnlBatch_New."Partially Posted":=false; //RE: [URGENT] PL1203C_R1 - GLOBAL APPLY ENTRIES  FUNCTION BUTTON CANNOT WORK TEC.VJ06FEB2026
            //if GenJnlBatch_New.Insert(true) then; //#381 VJ 08Jul2025 commented code so it does update no. series from the oninsert logic and added below code
            //#381 VJ 08Jul2025>> so in the newly created batch no. series it takes from bank api setup from it is generating document no.
            if GenJournalLine_p."Source Code" = 'PAYMENTJNL' THEN begin
                BankApiSetup.TestField("Rejection Payment Jnl. NoS.");
                GenJnlBatch_New."No. Series":=BankApiSetup."Rejection Payment Jnl. NoS.";
            end
            else if GenJournalLine_p."Source Code" = 'INTERCOMP' THEN begin
                    BankApiSetup.TestField("Rejection IC Jnl. NoS.");
                    GenJnlBatch_New."No. Series":=BankApiSetup."Rejection IC Jnl. NoS.";
                end;
            if GenJnlBatch_New.Insert()then;
        //#381 VJ 08Jul2025 <<
        //#381 VJ 08Jul2025>> added end else part as well if the batch is alrdady created then also update no. series with bank api setup field
        end
        else
        begin
            if GenJournalLine_p."Source Code" = 'PAYMENTJNL' THEN begin
                BankApiSetup.TestField("Rejection Payment Jnl. NoS.");
                GenJnlBatch_New."No. Series":=BankApiSetup."Rejection Payment Jnl. NoS.";
            end
            else if GenJournalLine_p."Source Code" = 'INTERCOMP' THEN begin
                    BankApiSetup.TestField("Rejection IC Jnl. NoS.");
                    GenJnlBatch_New."No. Series":=BankApiSetup."Rejection IC Jnl. NoS.";
                end;
            GenJnlBatch_New.Modify();
        end;
        //#381 VJ 08Jul2025<< added end else part as well if the batch is alrdady created then also update no. series with bank api setup field
        //TEC.VJ 16012025<<
        IF GenJournalLine_p.FindSet()then repeat UpdateBankDocNo:=false;
                GenJnlLineRejected.get(GenJournalLine_p."Journal Template Name", GenJournalLine_p."Journal Batch Name", GenJournalLine_p."Line No.");
                GenJnlLineRejected.Rename(GenJournalLine_p."Journal Template Name", GenJnlBatch_New.Name, GenJournalLine_p."Line No.");
                //TEC.VJ 12MAR2025>>
                HSBCOutbound.Reset();
                HSBCOutbound.SetRange("Bank Document No.", GenJnlLineRejected."Bank Document No.");
                if HSBCOutbound.FindFirst()then begin
                    UpdateBankDocNo:=true;
                end
                else
                begin
                    CitiOutbound.Reset();
                    CitiOutbound.SetRange("Bank Document No.", GenJnlLineRejected."Bank Document No.");
                    if CitiOutbound.FindFirst()then UpdateBankDocNo:=true;
                end;
                //TEC.VJ 12MAR2025<<
                //10072025VJ Start Added code to update documnt no. assuming it is rejected through approver so outbound not exist but need to generate new docuemnt no. 
                // if (GenJnlLineRejected."Source Code" = 'PAYMENTJNL') AND NOT UpdateBankDocNo THEN begin
                //     BankApiSetup.TestField("Rejection Payment Jnl. NoS.");
                //     GenJnlLineRejected."Document No." := NoSMgmt.GetNextNo(BankApiSetup."Rejection Payment Jnl. NoS.", GenJnlLineRejected."Posting Date", true);
                //     GenJnlLineRejected.Modify();
                // end;
                //10072025VJ End
                //#389 VJ 30072025 Start
                //   if UpdateBankDocNo then begin
                //      UpdateRejectedGenJnl(GenJournalLine_p, GenJnlBatch_New, BankApiSetup);
                // end;
                //#389 VJ 30072025 End
                UpdateRejectedGenJnl(GenJournalLine_p, GenJnlBatch_New, BankApiSetup); //#389 VJ 30072025 Handling for bank document no and appliction when review reject lines using Reject line button on payment journal
            until GenJournalLine_p.Next() = 0;
    end;
    local procedure RefreshUppliedLedgerEntries(GenJournalLine_p: Record "Gen. Journal Line"; var GenJnlLineRejected: Record "Gen. Journal Line")
    var
        GBVendLedgEntry: Record "Global Vendor Ledger Entry";
        GBCustLedgEntry: Record "Global Cust. Ledger entry";
        GBEmpLedgEntry: Record "Global Employee Ledger Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        EmpLedgEntry: Record "Employee Ledger Entry";
    begin
        if GenJournalLine_p."Account Type" = GenJournalLine_p."Account Type"::Vendor then begin
            GBVendLedgEntry.Reset();
            GBVendLedgEntry.SetRange("Applies-to ID", GenJournalLine_p."Document No.");
            GBVendLedgEntry.SetRange("Bank Document No. Applied", GenJournalLine_p."Bank Document No.");
            if GBVendLedgEntry.FindSet(true)then begin
                repeat GBVendLedgEntry."Applies-to ID":=GenJnlLineRejected."Document No.";
                    GBVendLedgEntry."Bank Document No. Applied":=GenJnlLineRejected."Bank Document No.";
                    GBVendLedgEntry.modify();
                until GBVendLedgEntry.Next() = 0;
            end;
            VendLedgEntry.Reset();
            VendLedgEntry.SetRange("Applies-to ID", GenJournalLine_p."Document No.");
            VendLedgEntry.SetRange("Bank Document No. Applied", GenJournalLine_p."Bank Document No.");
            if VendLedgEntry.FindSet(true)then begin
                repeat VendLedgEntry."Applies-to ID":=GenJnlLineRejected."Document No.";
                    VendLedgEntry."Bank Document No. Applied":=GenJnlLineRejected."Bank Document No.";
                    VendLedgEntry.modify();
                until VendLedgEntry.Next() = 0;
            end end
        else if GenJournalLine_p."Account Type" = GenJournalLine_p."Account Type"::Customer then begin
                GBCustLedgEntry.Reset();
                GBCustLedgEntry.SetRange("Applies-to ID", GenJournalLine_p."Document No.");
                GBCustLedgEntry.SetRange("Bank Document No. Applied", GenJournalLine_p."Bank Document No.");
                if GBCustLedgEntry.FindSet(true)then begin
                    repeat GBCustLedgEntry."Applies-to ID":=GenJnlLineRejected."Document No.";
                        GBCustLedgEntry."Bank Document No. Applied":=GenJnlLineRejected."Bank Document No.";
                        GBCustLedgEntry.modify();
                    until GBCustLedgEntry.Next() = 0;
                end;
                CustLedgEntry.Reset();
                CustLedgEntry.SetRange("Applies-to ID", GenJournalLine_p."Document No.");
                CustLedgEntry.SetRange("Bank Document No. Applied", GenJournalLine_p."Bank Document No.");
                if CustLedgEntry.FindSet(true)then begin
                    repeat CustLedgEntry."Applies-to ID":=GenJnlLineRejected."Document No.";
                        CustLedgEntry."Bank Document No. Applied":=GenJnlLineRejected."Bank Document No.";
                        CustLedgEntry.modify();
                    until CustLedgEntry.Next() = 0;
                end;
            end
            else if GenJournalLine_p."Account Type" = GenJournalLine_p."Account Type"::Employee then begin
                    GBEmpLedgEntry.Reset();
                    GBEmpLedgEntry.SetRange("Applies-to ID", GenJournalLine_p."Document No.");
                    GBEmpLedgEntry.SetRange("Bank Document No. Applied", GenJournalLine_p."Bank Document No.");
                    if GBEmpLedgEntry.FindSet(true)then begin
                        repeat GBEmpLedgEntry."Applies-to ID":=GenJnlLineRejected."Document No.";
                            GBEmpLedgEntry."Bank Document No. Applied":=GenJnlLineRejected."Bank Document No.";
                            GBEmpLedgEntry.modify();
                        until GBEmpLedgEntry.Next() = 0;
                    end;
                    EmpLedgEntry.Reset();
                    EmpLedgEntry.SetRange("Applies-to ID", GenJournalLine_p."Document No.");
                    EmpLedgEntry.SetRange("Bank Document No. Applied", GenJournalLine_p."Bank Document No.");
                    if EmpLedgEntry.FindSet(true)then begin
                        repeat EmpLedgEntry."Applies-to ID":=GenJnlLineRejected."Document No.";
                            EmpLedgEntry."Bank Document No. Applied":=GenJnlLineRejected."Bank Document No.";
                            EmpLedgEntry.modify();
                        until EmpLedgEntry.Next() = 0;
                    end;
                end;
    end;
    local procedure UpdateRejectedGenJnl(var GenJournalLine_p: Record "Gen. Journal Line"; var GenJnlBatch_New: Record "Gen. Journal Batch"; var BankApiSetup: Record "Bank API Setup")
    var
        PrevBankDocNo: Code[20];
        PrevCurrency: Code[10];
        PrevAmount: Decimal;
        PrevAmountLCY: Decimal;
        PrevIndcator: Boolean;
        DocumtNo: Code[20];
        NoSMgmt: Codeunit "No. Series";
        GenJnlLine_Var: Record "Gen. Journal Line";
        GenJnlLineRejected: Record "Gen. Journal Line";
        BankDocNo: Code[20];
        CommonFunc: Codeunit "Common Functions";
    begin
        GenJnlLineRejected.get(GenJournalLine_p."Journal Template Name", GenJnlBatch_New.Name, GenJournalLine_p."Line No.");
        //#310 TEC.VJ 16APR2025>>
        if GenJnlLineRejected."Source Code" = 'PAYMENTJNL' THEN begin
            BankApiSetup.TestField("Rejection Payment Jnl. NoS.");
            DocumtNo:=NoSMgmt.GetNextNo(BankApiSetup."Rejection Payment Jnl. NoS.", GenJnlLineRejected."Posting Date", true); //TEC.VJ 17012025
        end
        else if GenJnlLineRejected."Source Code" = 'INTERCOMP' THEN begin
                BankApiSetup.TestField("Rejection IC Jnl. NoS.");
                //#317 TEC.VJ 23APR2025>>
                TempDocNo.Reset();
                TempDocNo.SetRange("Document No.", GenJnlLineRejected."Document No.");
                TempDocNo.SetRange("Bank Document No.", GenJnlLineRejected."Bank Document No.");
                if not TempDocNo.FindFirst()then begin
                    DocumtNo:=NoSMgmt.GetNextNo(BankApiSetup."Rejection IC Jnl. NoS.", GenJnlLineRejected."Posting Date", true);
                    BankDocNo:=NoSMgmt.GetNextNo(GLSetp."Bank Document Nos.", GenJournalLine_p."Posting Date", true);
                    TempDocNo.Init();
                    TempDocNo."Journal Template Name":=GenJnlLineRejected."Journal Template Name";
                    TempDocNo."Journal Batch Name":=GenJnlLineRejected."Journal Batch Name";
                    TempDocNo."Line No.":=GenJnlLineRejected."Line No.";
                    TempDocNo."Document No.":=GenJnlLineRejected."Document No.";
                    TempDocNo."Bank Document No.":=GenJnlLineRejected."Bank Document No.";
                    TempDocNo."Account No.":=DocumtNo;
                    TempDocNo."IC Account No.":=BankDocNo;
                    TempDocNo.Insert();
                //#317 TEC.VJ 23APR2025<<
                end
                else
                begin
                    DocumtNo:=TempDocNo."Account No.";
                    BankDocNo:=TempDocNo."IC Account No.";
                end;
            end
            else
                DocumtNo:=NoSMgmt.GetNextNo(GenJnlBatch_New."No. Series", GenJnlLineRejected."Posting Date", true);
        //#310 TEC.VJ 16APR2025<<
        GenJnlLineRejected."Approver A Grp User":='';
        GenJnlLineRejected."Approver B Grp User":='';
        PrevBankDocNo:=GenJnlLineRejected."Bank Document No.";
        PrevCurrency:=GenJnlLineRejected."Currency Code";
        PrevAmount:=GenJnlLineRejected.Amount;
        PrevAmountLCY:=GenJnlLineRejected."Amount (LCY)";
        PrevIndcator:=GenJnlLineRejected."API Bank Account Indicator";
        GenJnlLineRejected."Document No.":=DocumtNo; //TEC.VJ 14022025
        if GenJnlLineRejected."Source Code" = 'INTERCOMP' THEN begin
            GenJnlLineRejected."Bank Document No.":=BankDocNo; //#317 TEC.VJ 23APR2025<<
        end
        ELSE
        begin
            GenJnlLineRejected."Bank Document No.":=''; //#164 TEC.VJ 17012025
        end;
        GenJnlLineRejected.Validate("Account No."); //#164 TEC.VJ 17012025
        GenJnlLineRejected."Applies-to ID":=DocumtNo;
        GenJnlLineRejected."API Bank Account Indicator":=PrevIndcator; //TEC.VJ 22APR2025
        RefreshUppliedLedgerEntries(GenJournalLine_p, GenJnlLineRejected); //TEC.VJ 12MAR2025
        GenJnlLineRejected.Description+='/' + CopyStr(PrevBankDocNo, 1, 99 - StrLen(GenJnlLineRejected.Description)); //06022025 VJ
        GenJnlLineRejected.Validate("Currency Code", PrevCurrency);
        GenJnlLineRejected.Validate(Amount, PrevAmount);
        GenJnlLineRejected.Validate("Amount (LCY)", PrevAmountLCY);
        GenJnlLineRejected."Message to Recipient":=GenJournalLine_p."Message to Recipient"; //VJ 29042025
        GenJnlLineRejected.Modify();
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnAfterRejectSelectedApprovalRequest, '', false, false)]
    local procedure "Approvals Mgmt._OnAfterRejectSelectedApprovalRequest"(var ApprovalEntry: Record "Approval Entry")
    var
        Recid: RecordId;
        RecordRef: RecordRef;
        BatchName51: FieldRef;
        TemplateName1: FieldRef;
        LineNo: FieldRef;
        GenJnlLine: Record "Gen. Journal Line";
    begin
        if(approvalentry."Document Type" = approvalentry."Document Type"::Payment) and (approvalentry."Table ID" = 81)then begin
            Recid:=ApprovalEntry."Record ID to Approve";
            RecordRef.get(Recid);
            TemplateName1:=RecordRef.Field(1);
            BatchName51:=RecordRef.Field(51);
            LineNo:=RecordRef.Field(2);
            GenJnlLine.Reset();
            GenJnlLine.SetRange("Journal Template Name", TemplateName1.Value);
            GenJnlLine.SetRange("Journal Batch Name", BatchName51.Value);
            GenJnlLine.SetRange("Line No.", LineNo.Value);
            GenJnlLine.SetFilter("Source Code", '=%1', 'PAYMENTJNL');
            if GenJnlLine.FindSet()then MoveToRejectedJournal(GenJnlLine);
        end;
        if ApprovalEntry."Table ID" = 232 then begin
            Recid:=ApprovalEntry."Record ID to Approve";
            RecordRef.get(Recid);
            TemplateName1:=RecordRef.Field(1);
            BatchName51:=RecordRef.Field(2);
            GenJnlLine.Reset();
            GenJnlLine.SetRange("Journal Template Name", TemplateName1.Value);
            GenJnlLine.SetRange("Journal Batch Name", BatchName51.Value);
            GenJnlLine.SetFilter("Source Code", '=%1', 'PAYMENTJNL');
            if GenJnlLine.FindSet()then MoveToRejectedJournal(GenJnlLine);
        end;
    end;
    var TempDocNo: record "Gen. Journal Line" temporary;
    GLSetp: Record "General Ledger Setup";
}
