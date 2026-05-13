pageextension 50118 "IC General Jnl Ext." extends "IC General Journal"
{
    layout
    {
        addafter(CurrentJnlBatchName)
        {
            field(ReviewStatus; GenJnlbatch_."Review Status")
            {
                Caption = 'Review Status';
                ApplicationArea = All;
                Editable = false;
            }
            //TEC.VJ 19DEC2024>>
            field("Bypass API"; GenBatchBypassAPI)
            {
                ApplicationArea = All;
                Editable = EnableBypass;
                ToolTip = 'Specifies the value of the Bypass API field.', Comment = '%';

                trigger OnValidate()
                var
                    GenJnlLine: Record "Gen. Journal Line";
                    GenJnlBatch: Record "Gen. Journal Batch";
                begin
                    //#226 TEC.VJ 21FEB2025>>
                    GenJnlBatch.Get(GenJnlbatch_."Journal Template Name", GenJnlbatch_.Name);
                    GenJnlBatch."Bypass API":=GenBatchBypassAPI;
                    GenJnlBatch.Modify();
                    GenJnlLine.Reset();
                    GenJnlLine.SetRange("Journal Template Name", GenJnlbatch_."Journal Template Name");
                    GenJnlLine.SetRange("Journal Batch Name", GenJnlbatch_.Name);
                    if GenJnlLine.FindSet()then GenJnlLine.ModifyAll("Bypass API", GenBatchBypassAPI);
                    //#226 TEC.VJ 21FEB2025<<
                    CurrPage.Update();
                end;
            }
            //TEC.VJ 19DEC2024<<
            //#76 TEC.VJ>>
            field(PaymentMethod; GenJnlbatch_."Payment Method Code")
            {
                Caption = 'Payment Method Code';
                ApplicationArea = All;
                Editable = false;
            }
        //#76 TEC.VJ<<
        }
        addafter(ShortcutDimCode8)
        {
            field("Shortcut Dimension 9 Code"; Rec."Shortcut Dimension 9 Code")
            {
                ApplicationArea = Dimensions;
                ToolTip = 'Specifies the code for Shortcut Dimension 9, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                Visible = ShortcutDim9Visible;
            }
            field("Shortcut Dimension 10 Code"; Rec."Shortcut Dimension 10 Code")
            {
                ApplicationArea = Dimensions;
                ToolTip = 'Specifies the code for Shortcut Dimension 10, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                Visible = ShortcutDim10Visible;
            }
            /*
            field("Shortcut Dimension 11 Code"; Rec."Shortcut Dimension 11 Code")
            {
                ApplicationArea = Dimensions;
                ToolTip = 'Specifies the code for Shortcut Dimension 11, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                Visible = ShortcutDim11Visible;
            }
            field("Shortcut Dimension 12 Code"; Rec."Shortcut Dimension 12 Code")
            {
                ApplicationArea = Dimensions;
                ToolTip = 'Specifies the code for Shortcut Dimension 12, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                Visible = ShortcutDim12Visible;
            }
            field("Shortcut Dimension 13 Code"; Rec."Shortcut Dimension 13 Code")
            {
                ApplicationArea = Dimensions;
                ToolTip = 'Specifies the code for Shortcut Dimension 13, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                Visible = ShortcutDim13Visible;
            }
            field("Shortcut Dimension 14 Code"; Rec."Shortcut Dimension 14 Code")
            {
                ApplicationArea = Dimensions;
                ToolTip = 'Specifies the code for Shortcut Dimension 14, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                Visible = ShortcutDim14Visible;
            }
            field("Shortcut Dimension 15 Code"; Rec."Shortcut Dimension 15 Code")
            {
                ApplicationArea = Dimensions;
                ToolTip = 'Specifies the code for Shortcut Dimension 15, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                Visible = ShortcutDim15Visible;
            }
            */
            field("Alloc. Rule"; REc."Alloc. Rule")
            {
                ApplicationArea = All;
            }
        }
        modify(Control1)
        {
            Editable = RepeaterEnable;
        }
        addafter(Amount)
        {
            field("Amount (LCY)"; Rec."Amount (LCY)")
            {
                ApplicationArea = All;
            }
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Gen. Posting Type")
        {
            Visible = false;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = false;
        }
        modify("Bal. Gen. Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Bal. Gen. Posting Type")
        {
            Visible = false;
        }
        modify("Bal. Gen. Prod. Posting Group")
        {
            Visible = false;
        }
        modify("Bal. Account Type")
        {
            Visible = false;
        }
        modify("Bal. Account No.")
        {
            Visible = false;
        }
        //#77 TEC.VJ>>
        addafter("Document No.")
        {
            field("Bank Document No."; Rec."Bank Document No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bank Document No. field.', Comment = '%';
            }
        }
        addafter(Amount)
        {
            field("Batch Type"; Rec."Batch Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Batch Type field.', Comment = '%';
            }
        }
        addafter("VAT Prod. Posting Group")
        {
            field("Payment Method Code"; Rec."Payment Method Code")
            {
                ApplicationArea = all;
                ShowMandatory = true;
                ToolTip = 'Specifies how to make payment, such as with bank transfer, cash, or check.';
            }
        }
        //#77 TEC.VJ>>
        //PS003 Start
        modify(ICAccountType)
        {
            Visible = false;
        }
        modify(ICAccountNo)
        {
            Visible = false;
        }
        modify("Account No.")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                if rec."Account Type" = rec."Account Type"::"G/L Account" then begin
                    rec."IC Account No.":=rec."Account No.";
                    rec.Modify();
                end;
            end;
        }
        //PS003 End
        addafter(ICAccountNo)
        {
            field("PB IC Account Type"; Rec."PB IC Account Type")
            {
                ApplicationArea = all;
            }
            //#293>>
            // field("PB Txf Bank Account"; Rec."PB Txf Bank Account")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the value of the PB Txf IC Account field.', Comment = '%';
            // }
            //#293<<
            field("PB IC Account"; Rec."PB IC Account")
            {
                ApplicationArea = all;
            }
            //#293 TEC.VJ 02APR2025>>
            field("API Bank Account Indicator"; Rec."API Bank Account Indicator")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the API Bank Account Indicator field.', Comment = '%';
            }
            //NT 20250729 >>
            field("API Information"; g_txt_APIInformation)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(TxSts; g_txt_TxSts)
            {
                ApplicationArea = All;
                Editable = false;
            }
            //NT 20250729 <<
            //#293 TEC.VJ 02APR2025<<
            field("PB IC Journal Template Name"; Rec."PB IC Journal Template Name")
            {
                ApplicationArea = all;
            }
            field("PB IC Journal Batch Name"; Rec."PB IC Journal Batch Name")
            {
                ApplicationArea = all;
            }
            //PS003 Start
            field("IC Dimension 1"; Rec."IC Dimension 1")
            {
                ApplicationArea = all;
            }
            field("IC Dimension 2"; Rec."IC Dimension 2")
            {
                ApplicationArea = all;
            }
            field("IC Dimension 3"; Rec."IC Dimension 3")
            {
                ApplicationArea = all;
            }
            field("IC Dimension 4"; Rec."IC Dimension 4")
            {
                ApplicationArea = all;
            }
            field("IC Dimension 5"; Rec."IC Dimension 5")
            {
                ApplicationArea = all;
            }
            field("IC Dimension 6"; Rec."IC Dimension 6")
            {
                ApplicationArea = all;
            }
            field("IC Dimension 7"; Rec."IC Dimension 7")
            {
                ApplicationArea = all;
            }
            field("IC Dimension 8"; Rec."IC Dimension 8")
            {
                ApplicationArea = all;
            }
            field("IC Dimension 9"; Rec."IC Dimension 9")
            {
                ApplicationArea = all;
            }
            field("IC Dimension 10"; Rec."IC Dimension 10")
            {
                ApplicationArea = all;
            }
            field("IC Dimension 11"; Rec."IC Dimension 11")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the IC Dimension 11 field.', Comment = '%';
            }
            field("IC Dimension 12"; Rec."IC Dimension 12")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the IC Dimension 12 field.', Comment = '%';
            }
            //PS003 End
            //#302 TEC.VJ>>
            field("Message to Recipient"; Rec."Message to Recipient")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the message exported to the payment file when you use the Export Payments to File function in the Payment Journal window.';
            }
            field("Payment Purpose"; Rec."Payment Purpose")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Payment Purpose field.', Comment = '%';
            }
            field("Charges Bearer"; Rec."Charges Bearer")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Charges Bearer field.', Comment = '%';
            }
        //#302 TEC.VJ<<
        }
    }
    actions
    {
        modify("Request Approval")
        {
            Visible = false;
        }
        addafter("Request Approval")
        {
            group("Request Review")
            {
                Caption = 'Request Review';

                action(SendForReview)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send For Review';
                    Enabled = SendForReviewEnable;
                    Image = SendApprovalRequest;
                    ToolTip = 'Send For Review';

                    trigger OnAction()
                    var
                        ReviewGenJnl: Codeunit "Review Gen Jnl";
                        GJB: Record "Gen. Journal Batch";
                    begin
                        UpdateICAccDetails(); //#134 TEC.VJ 
                        ReviewGenJnl.RunCheckBeforeReviewForIC(Rec); //TEC.VJ 27MAR2025
                        ReviewGenJnl.SendForReview(Rec);
                        GetGenJnlBatch();
                        UpdateReviewActions();
                        //TEC-Sgarg >>
                        // BatchRead := false;
                        //TEC-Sgarg >>
                        CurrPage.Update(false);
                    end;
                }
                action(ConfirmReview)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Confirm Review';
                    Enabled = ConfirmReviewEnable;
                    Image = ConfirmAndPrint;
                    ToolTip = 'Confirm Review';

                    trigger OnAction()
                    var
                        ReviewGenJnl: Codeunit "Review Gen Jnl";
                    begin
                        ReviewGenJnl.ConfirmReview(Rec);
                        GetGenJnlBatch();
                        UpdateReviewActions();
                        //TEC-Sgarg >>
                        // Commit();
                        // BatchRead := false;
                        //TEC-Sgarg >>
                        CurrPage.Update(false);
                    end;
                }
                action(RejectReview)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Reject Review';
                    Enabled = RejectReviewEnable;
                    Image = SendApprovalRequest;
                    ToolTip = 'Reject Review';

                    trigger OnAction()
                    var
                        ReviewGenJnl: Codeunit "Review Gen Jnl";
                    begin
                        ReviewGenJnl.RejectReview(Rec);
                        GetGenJnlBatch();
                        UpdateReviewActions();
                        //TEC-Sgarg >>
                        // Commit();
                        // BatchRead := false;
                        //TEC-Sgarg >>
                        CurrPage.Update(false);
                    end;
                }
                action(CancelReview)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Send for Review';
                    Enabled = CancelReviewEnable;
                    Image = SendApprovalRequest;
                    ToolTip = 'Cancel Send for Review';

                    trigger OnAction()
                    var
                        ReviewGenJnl: Codeunit "Review Gen Jnl";
                    begin
                        ReviewGenJnl.CancelReview(Rec);
                        GetGenJnlBatch();
                        UpdateReviewActions();
                        //TEC-Sgarg >>
                        // Commit();
                        // BatchRead := false;
                        //TEC-Sgarg >>
                        CurrPage.Update(false);
                    end;
                }
                action(UndoApproval)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Undo Approval';
                    Enabled = UndoApprovalEnable;
                    Image = Undo;
                    ToolTip = 'Undo Approval';

                    trigger OnAction()
                    var
                        CommFunc: Codeunit "Common Functions";
                    begin
                        //#323 TEC.VJ 30APR2025>>
                        if not Confirm('Do you want to Undo Approval?', false)then exit;
                        CommFunc.UndoApproval(Rec);
                        //#323 TEC.VJ 30APR2025>>
                        CurrPage.Update(false);
                    end;
                }
                //#265 TEC.VJ>>
                action(CreateOutbound)
                {
                    ApplicationArea = ALL;
                    Visible = TectEnable;

                    trigger OnAction()
                    var
                        HSBCOutboundCodeunit: Codeunit HSBCOutboundCodeunit;
                    begin
                        HSBCOutboundCodeunit.InsertStagingData(Rec."Journal Template Name", Rec."Journal Batch Name");
                    end;
                }
                //#265 TEC.VJ<<
                //#307 TECT.VT >>
                action("HSBC Payment Review")
                {
                    ApplicationArea = all;
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Exportifile: Report "HSBC Payment Review";
                    begin
                        PrintGenJnlLineHSBC(Rec)end;
                }
                action("Citibank Payment Review")
                {
                    ApplicationArea = all;
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Exportifile: Report "citibank Payment Review";
                    begin
                        PrintGenJnlLineCiti(Rec)end;
                }
                //#307 TEC.VT <<
                action("Reject Lines")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        CU50119: Codeunit "Review Gen Jnl";
                        GenJnlLine: Record "Gen. Journal Line";
                        GenJnlBatch_New: Record "Gen. Journal Batch";
                        UserSetup: Record "User Setup";
                        CreateRejBatchLines: codeunit "Create Rejection Batch Lines";
                    begin
                        GenJnlBatch_New.Get(Rec."Journal Template Name", Rec."Journal Batch Name");
                        //<<VJ06DEC2024
                        CurrPage.SetSelectionFilter(GenJnlLine);
                        Clear(CU50119);
                        IF GenJnlLine.FindSet()then CreateRejBatchLines.Run(GenJnlLine);
                    end;
                }
            }
        }
        modify("P&ost")
        {
            Enabled = EnablePostBool;
        }
        modify("Post and &Print")
        {
            Enabled = EnablePostBool;
        }
    }
    trigger OnOpenPage()
    var
        GLSetup: Record "General Ledger Setup";
    begin
        ContrlPageEditableonReviewStatus();
        UpdateReviewActions();
        EnableByPass_(); //TEC.VJ19DEC2024
        EnableButton(); //#265 TEC.VJ
        GLSetup.Get();
        ShortcutDim9Visible:=GLSetup."Shortcut Dimension 9 Code" <> '';
        ShortcutDim10Visible:=GLSetup."Shortcut Dimension 10 Code" <> '';
        ShortcutDim11Visible:=GLSetup."Shortcut Dimension 11 Code" <> '';
        ShortcutDim12Visible:=GLSetup."Shortcut Dimension 12 Code" <> '';
        ShortcutDim13Visible:=GLSetup."Shortcut Dimension 13 Code" <> '';
        ShortcutDim14Visible:=GLSetup."Shortcut Dimension 14 Code" <> '';
        ShortcutDim15Visible:=GLSetup."Shortcut Dimension 15 Code" <> '';
    end;
    trigger OnAfterGetRecord()
    begin
        EnableByPass_(); //TEC.VJ19DEC2024
        GetAPIStatus(); //NT_ 20250729
    end;
    trigger OnAfterGetCurrRecord()
    begin
        ContrlPageEditableonReviewStatus();
        UpdateReviewActions();
        EnableByPass_(); //TEC.VJ19DEC2024
    end;
    trigger OnDeleteRecord(): Boolean var
        CommonFunction: Codeunit "Common Functions";
    begin
        CommonFunction."Gen. Journal Line_OnAfterClearCustVendApplnEntry"(Rec); //#194 10Feb2025
    end;
    local procedure ContrlPageEditableonReviewStatus()
    begin
        GetGenJnlBatch();
    end;
    local procedure GetGenJnlBatch()
    begin
        GenJnlbatch_.Reset();
        if GenJnlbatch_.Get(Rec.GetRangeMax("Journal Template Name"), Rec."Journal Batch Name")then; //TEC.VJ 12112024
        GenBatchBypassAPI:=GenJnlbatch_."Bypass API";
    end;
    local procedure EnableByPass_()
    begin
        EnableBypass:=true;
        if GenJnlbatch_.Get(Rec."Journal Template Name", Rec."Journal Batch Name")then begin
            if GenJnlbatch_."Review Status" = GenJnlbatch_."Review Status"::" " then EnableBypass:=true
            else
                EnableBypass:=false;
        end;
    end;
    local procedure UpdateReviewActions()
    var
        UserSetup: Record "User Setup";
    begin
        EnabledGenJnlBatchWorkflowsExist:=WorkflowManagement.EnabledWorkflowExist(DATABASE::"Gen. Journal Batch", WorkflowEventHandling.RunWorkflowOnSendGeneralJournalBatchForApprovalCode());
        ApprovalMgmt.GetGenJnlBatchApprovalStatus(Rec, GenJnlBatchApprovalStatus, EnabledGenJnlBatchWorkflowsExist);
        // GenJnlbatch_."Review Status" := GenJnlbatch_."Review Status";
        EnablePostBool:=TRUE; //08Apr2025
        IF(GenJnlbatch_."Bank Transfer" = TRUE) AND (GenJnlbatch_."Bypass API" = false)THEN //08Apr2025
 IF(GenJnlbatch_."Prepare User" = '') or (UserId = GenJnlbatch_."Prepare User")then begin
                case GenJnlbatch_."Review Status" of GenJnlbatch_."Review Status"::" ": begin
                    CancelReviewEnable:=false;
                    SendForReviewEnable:=true;
                    ConfirmReviewEnable:=false;
                    RejectReviewEnable:=false;
                    EnablePostBool:=false;
                end;
                GenJnlbatch_."Review Status"::Approved: begin
                    CancelReviewEnable:=false;
                    SendForReviewEnable:=false;
                    ConfirmReviewEnable:=false;
                    RejectReviewEnable:=false;
                    EnablePostBool:=true;
                end;
                GenJnlbatch_."Review Status"::"Pending for Review": begin
                    CancelReviewEnable:=true;
                    SendForReviewEnable:=false;
                    ConfirmReviewEnable:=false;
                    RejectReviewEnable:=false;
                    EnablePostBool:=false;
                end;
                GenJnlbatch_."Review Status"::Rejected: begin
                    CancelReviewEnable:=false;
                    SendForReviewEnable:=true;
                    ConfirmReviewEnable:=false;
                    RejectReviewEnable:=false;
                    EnablePostBool:=false;
                end;
                GenJnlbatch_."Review Status"::Reviewed: begin
                    CancelReviewEnable:=false;
                    SendForReviewEnable:=false;
                    ConfirmReviewEnable:=false;
                    RejectReviewEnable:=false;
                    EnablePostBool:=false;
                end;
                GenJnlbatch_."Review Status"::"Approval Created": begin
                    CancelReviewEnable:=false;
                    SendForReviewEnable:=false;
                    ConfirmReviewEnable:=false;
                    RejectReviewEnable:=false;
                    EnablePostBool:=false;
                end;
                GenJnlbatch_."Review Status"::"Approval Canceled": begin
                    CancelReviewEnable:=false;
                    SendForReviewEnable:=true;
                    ConfirmReviewEnable:=false;
                    RejectReviewEnable:=false;
                    EnablePostBool:=false;
                end;
                GenJnlbatch_."Review Status"::"Approval Open": begin
                    CancelReviewEnable:=false;
                    SendForReviewEnable:=false;
                    ConfirmReviewEnable:=false;
                    RejectReviewEnable:=false;
                    EnablePostBool:=false;
                end;
                GenJnlbatch_."Review Status"::"Approval Rejected": begin
                    CancelReviewEnable:=false;
                    SendForReviewEnable:=true;
                    ConfirmReviewEnable:=false;
                    RejectReviewEnable:=false;
                    EnablePostBool:=false;
                end;
                end end
            Else IF(UserId = GenJnlbatch_."Reviewer User")then begin
                    case GenJnlbatch_."Review Status" of GenJnlbatch_."Review Status"::" ": begin
                        CancelReviewEnable:=false;
                        SendForReviewEnable:=false;
                        ConfirmReviewEnable:=false;
                        RejectReviewEnable:=false;
                        EnablePostBool:=false;
                    end;
                    GenJnlbatch_."Review Status"::Approved: begin
                        CancelReviewEnable:=false;
                        SendForReviewEnable:=false;
                        ConfirmReviewEnable:=false;
                        RejectReviewEnable:=false;
                        EnablePostBool:=false;
                    end;
                    GenJnlbatch_."Review Status"::"Pending for Review": begin
                        CancelReviewEnable:=false;
                        SendForReviewEnable:=false;
                        ConfirmReviewEnable:=true;
                        RejectReviewEnable:=true;
                    end;
                    GenJnlbatch_."Review Status"::Rejected: begin
                        CancelReviewEnable:=false;
                        SendForReviewEnable:=false;
                        ConfirmReviewEnable:=false;
                        RejectReviewEnable:=false;
                        EnablePostBool:=false;
                    end;
                    GenJnlbatch_."Review Status"::Reviewed: begin
                        CancelReviewEnable:=false;
                        SendForReviewEnable:=false;
                        ConfirmReviewEnable:=false;
                        RejectReviewEnable:=false;
                        EnablePostBool:=false;
                    end;
                    GenJnlbatch_."Review Status"::"Approval Created": begin
                        CancelReviewEnable:=false;
                        SendForReviewEnable:=false;
                        ConfirmReviewEnable:=false;
                        RejectReviewEnable:=false;
                        EnablePostBool:=false;
                    end;
                    GenJnlbatch_."Review Status"::"Approval Canceled": begin
                        CancelReviewEnable:=false;
                        SendForReviewEnable:=false;
                        ConfirmReviewEnable:=false;
                        RejectReviewEnable:=false;
                        EnablePostBool:=false;
                    end;
                    GenJnlbatch_."Review Status"::"Approval Open": begin
                        CancelReviewEnable:=false;
                        SendForReviewEnable:=false;
                        ConfirmReviewEnable:=false;
                        RejectReviewEnable:=false;
                        EnablePostBool:=false;
                    end;
                    GenJnlbatch_."Review Status"::"Approval Rejected": begin
                        CancelReviewEnable:=false;
                        SendForReviewEnable:=false;
                        ConfirmReviewEnable:=false;
                        RejectReviewEnable:=false;
                        EnablePostBool:=false;
                    end;
                    end end
                Else
                begin
                    case GenJnlbatch_."Review Status" of GenJnlbatch_."Review Status"::" ": begin
                        CancelReviewEnable:=false;
                        SendForReviewEnable:=false;
                        ConfirmReviewEnable:=false;
                        RejectReviewEnable:=false;
                        EnablePostBool:=false;
                    end;
                    GenJnlbatch_."Review Status"::Approved: begin
                        CancelReviewEnable:=false;
                        SendForReviewEnable:=false;
                        ConfirmReviewEnable:=false;
                        RejectReviewEnable:=false;
                        EnablePostBool:=false;
                    end;
                    GenJnlbatch_."Review Status"::"Pending for Review": begin
                        CancelReviewEnable:=false;
                        SendForReviewEnable:=false;
                        ConfirmReviewEnable:=false;
                        RejectReviewEnable:=false;
                        EnablePostBool:=false;
                    end;
                    GenJnlbatch_."Review Status"::Rejected: begin
                        CancelReviewEnable:=false;
                        SendForReviewEnable:=false;
                        ConfirmReviewEnable:=false;
                        RejectReviewEnable:=false;
                        EnablePostBool:=false;
                    end;
                    GenJnlbatch_."Review Status"::Reviewed: begin
                        CancelReviewEnable:=false;
                        SendForReviewEnable:=false;
                        ConfirmReviewEnable:=false;
                        RejectReviewEnable:=false;
                        EnablePostBool:=false;
                    end;
                    GenJnlbatch_."Review Status"::"Approval Created": begin
                        CancelReviewEnable:=false;
                        SendForReviewEnable:=false;
                        ConfirmReviewEnable:=false;
                        RejectReviewEnable:=false;
                        EnablePostBool:=false;
                    end;
                    GenJnlbatch_."Review Status"::"Approval Canceled": begin
                        CancelReviewEnable:=false;
                        SendForReviewEnable:=false;
                        ConfirmReviewEnable:=false;
                        RejectReviewEnable:=false;
                        EnablePostBool:=false;
                    end;
                    GenJnlbatch_."Review Status"::"Approval Open": begin
                        CancelReviewEnable:=false;
                        SendForReviewEnable:=false;
                        ConfirmReviewEnable:=false;
                        RejectReviewEnable:=false;
                        EnablePostBool:=false;
                    end;
                    GenJnlbatch_."Review Status"::"Approval Rejected": begin
                        CancelReviewEnable:=false;
                        SendForReviewEnable:=false;
                        ConfirmReviewEnable:=false;
                        RejectReviewEnable:=false;
                        EnablePostBool:=false;
                    end;
                    end end;
        if Rec."Bypass API" then begin
            CancelReviewEnable:=false;
            SendForReviewEnable:=false;
            ConfirmReviewEnable:=false;
            RejectReviewEnable:=false;
        //  EnablePostBool := true;//#297 TEC.VJ 07APR2025
        end;
        if(SendForReviewEnable = false) and (Rec."Bypass API")then RepeaterEnable:=true
        else if SendForReviewEnable then RepeaterEnable:=true
            else
                RepeaterEnable:=false;
        //#297 TEC.VJ 07APR2025>>
        UndoApprovalEnable:=false;
        if UserSetup.Get(UserId)then begin
            UndoApprovalEnable:=UserSetup."Allow Undo Approval";
        end;
        /*
         if (GenJnlbatch_."Bank Transfer")  and (GenJnlbatch_."Bypass API" = false) then
            EnablePostBool := false;
        else
            if (GenJnlbatch_."Bank Transfer") and (GenJnlbatch_."Bypass API") then
                EnablePostBool := true;*/
        //#297 TEC.VJ 07APR2025<<
        //#DC 09APR2025 <<
        IF GenJnlbatch_."Bank Transfer" = false THEN begin
            RepeaterEnable:=true;
        end;
    //#DC 09APR2025 >>
    end;
    //#134 TEC.VJ>>
    local procedure UpdateICAccDetails()
    var
        GenJnlLine: Record "Gen. Journal Line";
        BankAPISetup: Record "Bank API Setup";
    begin
        BankAPISetup.Get();
        BankAPISetup.TestField("Dummy GL Account");
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        GenJnlLine.SetRange("Account Type", GenJnlLine."Account Type"::"Bank Account");
        GenJnlLine.SetFilter("IC Account No.", '<>%1', ''); //VG 06FEB2025 Also update IC Account no. to dummy on account no. selection if accoutn type is bank account for IC
        GenJnlLine.SetRange("IC Partner Transaction No.", 0); //#291 VJ 27MAR2025 added condtion
        if GenJnlLine.FindSet(TRUE)then begin
            repeat GenJnlLine.Validate("IC Account Type", GenJnlLine."IC Account Type"::"G/L Account");
                GenJnlLine.Validate("IC Account No.", BankAPISetup."Dummy GL Account");
                GenJnlLine.Modify();
            until GenJnlLine.Next() = 0;
            Commit();
        end;
    end;
    //#134 TEC.VJ<<
    local procedure EnableButton()
    var
        tmp: Text;
    begin
        TectEnable:=false;
        tmp:=UserId;
        tmp:=tmp.ToUpper();
        if tmp.Contains('TECTURA')then TectEnable:=true;
    end;
    //#307 TEC.VT >>
    procedure PrintGenJnlLineHSBC(var NewGenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        // GenJnlLine.Copy(NewGenJnlLine);
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", NewGenJnlLine."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", NewGenJnlLine."Journal Batch Name");
        if GenJnlLine.FindSet()then //GenJnlTemplate.Get(GenJnlLine."Journal Template Name");
            // GenJnlTemplate.TestField("Test Report ID");
            REPORT.Run(50117, false, false, GenJnlLine);
    end;
    procedure PrintGenJnlLineCiti(var NewGenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        // GenJnlLine.Copy(NewGenJnlLine);
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", NewGenJnlLine."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", NewGenJnlLine."Journal Batch Name");
        if GenJnlLine.FindSet()then //GenJnlTemplate.Get(GenJnlLine."Journal Template Name");
            // GenJnlTemplate.TestField("Test Report ID");
            REPORT.Run(50118, false, false, GenJnlLine);
    end;
    //#307 TEC.VT <<
    procedure GetAPIStatus()
    var
        BankAccount: Record "Bank Account";
        HSBCOutbound: Record "HSBC Outbound Staging Table";
        CitiOutbound: Record "Citi Outbound Staging Table";
    begin
        //NT_ 20250729 >>
        Clear(g_txt_APIInformation);
        Clear(g_txt_TxSts);
        //NT_ 20250729 <<
        if Rec."Bal. Account Type" = Rec."Bal. Account Type"::"Bank Account" then begin
            if BankAccount.Get(Rec."Bal. Account No.") and (BankAccount."Bank Integration Type" = BankAccount."Bank Integration Type"::HSBC)then begin
                HSBCOutbound.Reset();
                HSBCOutbound.SetRange("Journal Template Name", rec."Journal Template Name");
                HSBCOutbound.SetRange("Journal Batch Name", rec."Journal Batch Name");
                HSBCOutbound.SetRange("Bank Document No.", rec."Bank Document No.");
                if HSBCOutbound.FindFirst()then begin
                    //NT_ 20250729 >>
                    g_txt_APIInformation:=HSBCOutbound."API Information";
                    g_txt_TxSts:=HSBCOutbound.TxSts;
                //NT_ 20250729 <<
                end;
            end
            else if BankAccount.Get(Rec."Bal. Account No.") and (BankAccount."Bank Integration Type" = BankAccount."Bank Integration Type"::Citi)then begin
                    CitiOutbound.Reset();
                    CitiOutbound.SetRange("Journal Template Name", rec."Journal Template Name");
                    CitiOutbound.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    CitiOutbound.SetRange("Bank Document No.", rec."Bank Document No.");
                    if CitiOutbound.FindFirst()then begin
                        //NT_ 20250729 >>
                        g_txt_APIInformation:=CitiOutbound."API Information";
                        g_txt_TxSts:=CitiOutbound.TxSts;
                    //NT_ 20250729 <<
                    end;
                end end;
    end;
    var EnablePostBool: Boolean;
    CancelReviewEnable: Boolean;
    EnableBypass: Boolean;
    SendForReviewEnable: Boolean;
    UndoApprovalEnable: Boolean;
    ConfirmReviewEnable: Boolean;
    RejectReviewEnable: Boolean;
    GenJnlbatch_: Record "Gen. Journal Batch";
    GenJnlBatchApprovalStatus: Text[20];
    ApprovalMgmt: Codeunit "Approvals Mgmt.";
    EnabledGenJnlBatchWorkflowsExist: Boolean;
    RepeaterEnable: Boolean;
    WorkflowManagement: Codeunit "Workflow Management";
    WorkflowEventHandling: Codeunit "Workflow Event Handling";
    ShortcutDim9Visible: Boolean;
    ShortcutDim10Visible: Boolean;
    ShortcutDim11Visible: Boolean;
    ShortcutDim12Visible: Boolean;
    ShortcutDim13Visible: Boolean;
    ShortcutDim14Visible: Boolean;
    ShortcutDim15Visible: Boolean;
    TectEnable: Boolean;
    GenBatchBypassAPI: Boolean;
    g_txt_APIInformation: Text;
    g_txt_TxSts: Text;
}
