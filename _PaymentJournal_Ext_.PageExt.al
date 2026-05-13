pageextension 50101 "PaymentJournal_Ext" extends "Payment Journal"
{
    layout
    {
        addafter("Amount (LCY)")
        {
            field(Rec; Rec."Currency Factor")
            {
                ApplicationArea = all;
            }
        }
        addafter("Account No.")
        {
            field("Txf Account No."; Rec."Txf Account No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Txf Account No. field.', Comment = '%';
            }
        }
        modify("Document No.")
        {
            Editable = false;
        }
        modify(ShortcutDimCode3)
        {
            Visible = false;
        }
        modify(ShortcutDimCode4)
        {
            Visible = false;
        }
        modify(ShortcutDimCode5)
        {
            Visible = false;
        }
        modify(ShortcutDimCode6)
        {
            Visible = false;
        }
        modify(ShortcutDimCode7)
        {
            Visible = false;
        }
        modify(ShortcutDimCode8)
        {
            Visible = false;
        }
        modify("Applies-to Doc. Type")
        {
            Visible = false;
        }
        modify("Applies-to Ext. Doc. No.")
        {
            Visible = false;
        }
        modify("Applies-to ID")
        {
            Visible = false;
        }
        modify(AppliesToDocNo)
        {
            Visible = false;
        }
        addafter("Document No.")
        {
            field("Bank Document No."; Rec."Bank Document No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bank Document No. field.', Comment = '%';
                StyleExpr = StyleExprtxt;
                Editable = false;
            }
        }
        addafter("Posting Date")
        {
        //TEC.VJ 17DEC2024>>
        //field("Payment Status"; Rec."Payment Status")
        //{
        //ApplicationArea = All;
        //ToolTip = 'Specifies the value of the Payment Status field.', Comment = '%';
        //}
        //TEC.VJ 17DEC2024<<
        }
        modify(Control1)
        {
            Editable = RepeaterEnable;
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
        // modify("Account No.")
        // {
        // trigger OnAfterValidate()
        // var
        //     Customer: Record Customer;
        //     Vendor: Record Vendor; // New record variable for Vendor
        //     GenJrBatch: Record "Gen. Journal Batch";
        // begin
        //     // Check if the account type is Customer
        //     if Rec."Account Type" = Rec."Account Type"::Customer then begin
        //         // Find the journal batch
        //         GenJrBatch.SetRange("Journal Template Name", Rec."Journal Template Name");
        //         GenJrBatch.SetRange(Name, Rec."Journal Batch Name");
        //         if GenJrBatch.FindFirst() then begin
        //             // Check if the payment method code is set for the journal batch
        //             if GenJrBatch."Payment Method Code" = '' then
        //                 Error('Payment Method Code is required for this journal batch.');
        //             Customer.SetRange("No.", Rec."Account No.");
        //             if Customer.FindFirst() then begin
        //                 if Customer."Payment Method Code" = '' then
        //                     Error('Payment Method Code is required for this customer.');
        //                 // Validate that the payment method codes match
        //                 if Customer."Payment Method Code" <> GenJrBatch."Payment Method Code" then
        //                     Error('Payment Method Code does not match with customer payment method.');
        //             end;
        //         end;
        //     end
        //     // Check if the account type is Vendor
        //     else if Rec."Account Type" = Rec."Account Type"::Vendor then begin
        //         // Find the journal batch
        //         GenJrBatch.SetRange("Journal Template Name", Rec."Journal Template Name");
        //         GenJrBatch.SetRange(Name, Rec."Journal Batch Name");
        //         if GenJrBatch.FindFirst() then begin
        //             // Check if the payment method code is set for the journal batch
        //             if GenJrBatch."Payment Method Code" = '' then
        //                 Error('Payment Method Code is required for this journal batch.');
        //             Vendor.SetRange("No.", Rec."Account No.");
        //             if Vendor.FindFirst() then begin
        //                 if Vendor."Payment Method Code" = '' then
        //                     Error('Payment Method Code is required for this vendor.');
        //                 // Validate that the payment method codes match
        //                 if Vendor."Payment Method Code" <> GenJrBatch."Payment Method Code" then
        //                     Error('Payment Method Code does not match with vendor payment method.');
        //             end;
        //         end;
        //     end;
        // end;
        //}
        //VJ 30072025 Start
        addbefore(CurrentJnlBatchName)
        {
            field("Journal Template Name"; Rec."Journal Template Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        //VJ 30072025 end
        addafter(CurrentJnlBatchName)
        {
            field(ReviewStatus; GenJnlbatch_."Review Status")
            {
                Caption = 'Review Status';
                ApplicationArea = All;
                Editable = false;
            }
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
            field(PaymentMethod; GenJnlbatch_."Payment Method Code")
            {
                Caption = 'Payment Method Code';
                ApplicationArea = All;
                Editable = false;
            }
        }
        //TEC.VJ 25112024>>
        modify(Amount)
        {
            trigger OnAfterValidate()
            var
                VendorLedgEntr: Record "Global Vendor Ledger Entry";
                CustomerLedgEntr: Record "Global Cust. Ledger Entry";
            begin
                //VJ 09Jan2025 Start
                if Rec."Account Type" = Rec."Account Type"::Vendor then begin
                    VendorLedgEntr.Reset();
                    VendorLedgEntr.SetCurrentKey("Applies-to ID");
                    VendorLedgEntr.SetRange("Applies-to ID", Rec."Document No.");
                    VendorLedgEntr.SetRange("Bank Document No. Applied", Rec."Bank Document No."); //TEC.VJ 13FEB2025
                    if VendorLedgEntr.FindFirst()then Error('Amount can not be modified as there are applied entries exist');
                end;
                //TEC.VJ 06MAR2025>>
                if Rec."Account Type" = Rec."Account Type"::Customer then begin
                    CustomerLedgEntr.Reset();
                    CustomerLedgEntr.SetCurrentKey("Applies-to ID");
                    CustomerLedgEntr.SetRange("Applies-to ID", Rec."Document No.");
                    CustomerLedgEntr.SetRange("Bank Document No. Applied", Rec."Bank Document No."); //TEC.VJ 13FEB2025
                    if CustomerLedgEntr.FindFirst()then Error('Amount can not be modified as there are applied entries exist');
                end;
                //TEC.VJ 06MAR2025<<
                //VJ 09Jan2025 End
                Rec.UpdateTransAmount();
                CalMismatch(); //NT_ 13-02-2025
            end;
        }
        //TEC.VJ 25112024<<
        addafter("Amount (LCY)")
        {
            field("Applied Amount"; Rec."Applied Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Applied Amount field.', Comment = '%';

                //NT_ 13-02-2025 >>
                trigger OnValidate()
                begin
                    CalMismatch();
                end;
            //NT_ 13-02-2025 <<
            }
            field("Amount Mismatch"; Rec."Amount Mismatch")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Amount Mismatch field.', Comment = '%';
            }
        }
        addafter(Amount)
        {
            field("Batch Type"; Rec."Batch Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Batch Type field.', Comment = '%';
            }
            field("Payment Method Bank XML"; Rec."Payment Method Bank XML")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Payment Method Bank XML field.', Comment = '%';
            }
            field("Applied Entries to XML"; Rec."Applied Entries to XML")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Applied Entries to XML field.', Comment = '%';
            }
            field(CompanyCode; Rec."Company Code")
            {
                ApplicationArea = All;
                Caption = 'Company Code';
            }
            field("Invoice Link"; Rec."Invoice Link")
            {
                ApplicationArea = All;
            }
            field("Word Link"; Rec."World Link")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Word Link field.', Comment = '%';
            }
            field("Booking Method"; Rec."Booking Method")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Booking Method field.', Comment = '%';
            }
            field("Ship Manager Id"; Rec."Ship Manager Id")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Ship Manager Id field.', Comment = '%';
            }
            //#001>>
            /* 
                        field("Prepared by"; Rec."Prepared by")
                        {
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Certified Correct by"; Rec."Certified Correct by")
                        {
                            ApplicationArea = All;
                        }
                        field("Approved by"; Rec."Approved by")
                        {
                            ApplicationArea = All;
                        } */
            field("Over Receipt"; Rec."Over Receipt")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Over Receipt field.', Comment = '%';
            }
            field("Exchange Rate"; Rec."Exchange Rate")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Exchange Rate field.', Comment = '%';

                trigger OnValidate()
                begin
                    Rec.UpdateTransAmount(); //TEC.VJ 25112024
                end;
            }
            field("Trans. Amt."; Rec."Trans. Amt.")
            {
                ToolTip = 'Specifies the value of the Trans. Amt. field.', Comment = '%';
                ApplicationArea = All;
            }
            field("Trans. Currency"; Rec."Trans. Currency")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Trans. Currency field.', Comment = '%';

                trigger OnValidate()
                begin
                    Rec.UpdateTransAmount(); //TEC.VJ 25112024
                end;
            }
            field("IFSC Code"; Rec."IFSC Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the IFSC Code field.', Comment = '%';
            }
            field("Purpose Code"; Rec."Purpose Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Purpose Code field.', Comment = '%';
            }
            field("Charges Bearer"; Rec."Charges Bearer")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Charges Bearer field.', Comment = '%';
            }
            field("Instruction to Bank"; Rec."Instruction to Bank")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Instruction to Bank field.', Comment = '%';
            }
            field("FPS Type"; Rec."FPS Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the FPS Type field.', Comment = '%';
            }
            field("FPS No."; Rec."FPS No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the FPS No. field.', Comment = '%';
            }
            field("Remittance Email 1"; Rec."Remittance Email 1")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Remittance Email 1 field.', Comment = '%';
            }
            field("Remittance Email 2"; Rec."Remittance Email 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Remittance Email 2 field.', Comment = '%';
            }
            field("Remittance Email 3"; Rec."Remittance Email 3")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Remittance Email 3 field.', Comment = '%';
            }
            field("Remittance Email 4"; Rec."Remittance Email 4")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Remittance Email 4 field.', Comment = '%';
            }
            field("Remittance Email 5"; Rec."Remittance Email 5")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Remittance Email 5 field.', Comment = '%';
                Caption = 'Remittance Email 5(HSBC)';
            }
            field("Remittance Email 6"; Rec."Remittance Email 6")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Remittance Email 6 field.', Comment = '%';
                Caption = 'Remittance Email 6(HSBC)';
            }
            //PS006 Start
            field("PB Concur invoice"; Rec."PB Concur invoice")
            {
                ApplicationArea = all;
            }
            //PS006 End
            //PS008 Start
            field("Bank Charge Debit Pymnt. Amt."; Rec."Bank Charge Debit Pymnt. Amt.")
            {
                ApplicationArea = all;
            }
            field("Correspon. Bank Charges Method"; Rec."Correspon. Bank Charges Method")
            {
                ApplicationArea = all;
            }
            field("RMB Remittance Trans. Type"; Rec."RMB Remittance Trans. Type")
            {
                ApplicationArea = all;
            }
        //PS008 End
        //#001<<
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.', Comment = '%';
            }
            field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.', Comment = '%';
            }
            field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shortcut Dimension 5 Code field.', Comment = '%';
            }
            field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shortcut Dimension 6 Code field.', Comment = '%';
            }
            field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shortcut Dimension 7 Code field.', Comment = '%';
            }
            field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shortcut Dimension 8 Code field.', Comment = '%';
            }
            field("Shortcut Dimension 9 Code"; Rec."Shortcut Dimension 9 Code")
            {
                ApplicationArea = Dimensions;
                ToolTip = 'Specifies the code for Shortcut Dimension 9, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
            //Visible = false;
            }
            field("Shortcut Dimension 10 Code"; Rec."Shortcut Dimension 10 Code")
            {
                ApplicationArea = Dimensions;
                ToolTip = 'Specifies the code for Shortcut Dimension 10, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
            //Visible = false;
            }
        /*
            field("Shortcut Dimension 11 Code"; Rec."Shortcut Dimension 11 Code")
            {
                ApplicationArea = Dimensions;
                ToolTip = 'Specifies the code for Shortcut Dimension 11, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                Visible = false;
            }
            field("Shortcut Dimension 12 Code"; Rec."Shortcut Dimension 12 Code")
            {
                ApplicationArea = Dimensions;
                ToolTip = 'Specifies the code for Shortcut Dimension 12, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                Visible = false;
            }
            field("Shortcut Dimension 13 Code"; Rec."Shortcut Dimension 13 Code")
            {
                ApplicationArea = Dimensions;
                ToolTip = 'Specifies the code for Shortcut Dimension 13, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                Visible = false;
            }
            field("Shortcut Dimension 14 Code"; Rec."Shortcut Dimension 14 Code")
            {
                ApplicationArea = Dimensions;
                ToolTip = 'Specifies the code for Shortcut Dimension 14, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                Visible = false;
            }
            field("Shortcut Dimension 15 Code"; Rec."Shortcut Dimension 15 Code")
            {
                ApplicationArea = Dimensions;
                ToolTip = 'Specifies the code for Shortcut Dimension 15, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                Visible = false;
            }
            */
        }
        addafter("Document Type")
        {
            field("Payment Reference1"; Rec."Payment Reference")
            {
                Caption = 'Payment Reference';
                ApplicationArea = all;
            }
        }
        modify(CurrentJnlBatchName)
        {
            trigger OnAfterValidate()
            begin
                ContrlPageEditableonReviewStatus();
                UpdateReviewActions();
                CurrPage.Update(true);
            end;
        }
        modify("Payment Method Code")
        {
            trigger OnAfterValidate()
            var
                PaymentMethod: Record "Payment Method";
            begin
                if PaymentMethod.Get(Rec."Payment Method Code")then Rec."Trans. Currency":=PaymentMethod."Trans. Currency";
                Rec.UpdateTransAmount();
            end;
        }
        addafter("Recipient Bank Account")
        {
            field("Employee Bank Account"; Rec."Employee Bank Account")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Employee Bank Account field.', Comment = '%';
            }
            field("Payment Purpose"; Rec."Payment Purpose")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Payment Purpose field.', Comment = '%';
            }
            //>>#132
            field("Purpose Code Preflix"; Rec."Purpose Code Preflix")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Purpose Code Preflix field.', Comment = '%';
            }
            //<<#132
            field("Payment Set Code"; Rec."Payment Set Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Payment Set Code field.', Comment = '%';

                //Visible = isACHPaymentMethod;//VJ 12DEC2024 Walter removed
                trigger OnValidate()
                var
                    PaymentSetCode: Record "Payment Set Code";
                begin
                    //>>VJ06DEC2024
                    if PaymentSetCode.Get(Rec."Payment Set Code") and (PaymentSetCode."Last Used Date" = Today)then Error('Payment Set Code is already used for today.');
                //<<VJ06DEC2024
                end;
            }
            field("Bank Transaction Code"; Rec."Bank Transaction Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bank Transaction Code field.', Comment = '%';
            }
            field("No Corresponding Bank for Pmt"; Rec."No Corresponding Bank for Pmt")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the "No Corresponding Bank For Payment field.', Comment = '%';
            }
            field("Additional Entry Information"; Rec."Additional Entry Information")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Additional Entry Information field.', Comment = '%';
            }
            field("Creditor Name"; Rec."Creditor Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Creditor Name field.', Comment = '%';
            }
            //TEC.VJ 09DEC2024>>
            field(APIStatus; APIStatus)
            {
                Caption = 'Bank Payment Status';
                ApplicationArea = All;
                Editable = false;
            }
            //TEC.VJ 09EC2024>>
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
        }
        //TEC.VJ 01APR2025>>
        modify(GenJnlBatchApprovalStatus)
        {
            Visible = false;
        }
        addafter(GenJnlBatchApprovalStatus)
        {
            field(GenJnlBatchApprovalStatus2; GenJnlBatchApprovalStatus)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Approval Status';
                Editable = false;
                Visible = EnabledGenJnlBatchWorkflowsExist;
                ToolTip = 'Specifies the approval status for general journal batch.';
            }
        }
        //TEC.VJ 01APR2025<<
        addafter("Account No.")
        {
            //#294 TEC.VJ>>
            field("API Bank Account Indicator"; Rec."API Bank Account Indicator")
            {
                ApplicationArea = ALL;
            }
        //#294 TEC.VJ<<
        }
    }
    actions
    {
        modify(ApplyEntries)
        {
            Visible = false;
        }
        addafter(SuggestVendorPayments)
        {
            action("Suggest Vendor Payment Global")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Enabled = ActionsEnable; //#118 TEC.VJ
                PromotedCategory = Category5;

                trigger OnAction()
                var
                    SuggestVendorPayments: Report "Suggest Vendor Payments Dim";
                begin
                    CLEAR(SuggestVendorPayments);
                    SuggestVendorPayments.SetGenJnlLine(Rec);
                    SuggestVendorPayments.RUNMODAL;
                end;
            }
        }
        addafter(SuggestEmployeePayments)
        {
            action("Suggest Employee Payment Global")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category5;
                Enabled = ActionsEnable; //#118 TEC.VJ

                trigger OnAction()
                var
                    SuggestEmployeePayments: Report "Suggest Employee Payments PB";
                begin
                    Clear(SuggestEmployeePayments);
                    SuggestEmployeePayments.SetGenJnlLine(Rec);
                    SuggestEmployeePayments.RunModal();
                end;
            }
        }
        addlast("&Payments")
        {
            action(SplitApplicationGnlLine)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Split Line Application Wise';
                Ellipsis = true;
                Image = Splitlines;
                ToolTip = 'Split payment Lines as per Venodor application.';

                trigger OnAction()
                var
                    SplitPaymentJournal: Codeunit SplitPaymentJournal;
                    GJLSplit: Record "GJL Split";
                    PageSplitGJL: Page "Payment Journal After Split";
                    L_GJL: Record "Gen. Journal Line";
                    L_Open: Boolean;
                    ReviewGenJnl: Codeunit "Review Gen Jnl";
                begin
                    ReviewGenJnl.RunCheckBeforePost(Rec); //TEC.VJ 08MAY2025
                    clear(SplitPaymentJournal);
                    SplitPaymentJournal.Run(Rec);
                    L_Open:=true;
                    L_GJL.Reset();
                    L_GJL.SetRange("Journal Template Name", Rec."Journal Template Name");
                    L_GJL.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    L_GJL.Setfilter("Account Type", '%1|%2|%3', L_GJL."Account Type"::Vendor, L_GJL."Account Type"::Employee, L_GJL."Account Type"::Customer);
                    L_GJL.setfilter("Applies-to ID", '<>%1', '');
                    IF NOT L_GJL.FINDFIRST then begin
                        IF Confirm('There is no Apply entries,Do you still want to open Split page', false)then L_Open:=true
                        else
                            L_Open:=false;
                    end;
                    IF L_Open then begin
                        GJLSplit.reset;
                        GJLSplit.SetRange("Journal Template Name", Rec."Journal Template Name");
                        GJLSplit.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                        PageSplitGJL.SetTableView(GJLSplit);
                        PageSplitGJL.RunModal();
                    end;
                end;
            }
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
                        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
                    begin
                        GenJnlCheckLine.Run(Rec); //VJ 27052025 Add checking before send for review to show error before
                        EmailLengthCheck(); //NT_ 17-03-2025
                        ReviewGenJnl.RunCheckBeforeReview(Rec);
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
                        //#002>>
                        Clear(g_cdu_EmailNoti);
                        g_cdu_EmailNoti.SetRecord(Rec);
                        g_cdu_EmailNoti.SendApproveANotification();
                        //#002<<
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
                    Visible = false; //#389 VJ 04082025

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
                        //#002>>
                        Clear(g_cdu_EmailNoti);
                        g_cdu_EmailNoti.SetRecord(Rec);
                        g_cdu_EmailNoti.RejectNotification();
                        //#002<<
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
                action(CreateOutbound)
                {
                    ApplicationArea = ALL;
                    Visible = TectEnable; //NT_ 03-12-2025

                    trigger OnAction()
                    var
                        HSBCOutboundCodeunit: Codeunit HSBCOutboundCodeunit;
                    begin
                        HSBCOutboundCodeunit.InsertStagingData(Rec."Journal Template Name", Rec."Journal Batch Name");
                    end;
                }
            /*  action(email)
                 {
                     ApplicationArea = all;
                     trigger OnAction()
                     var
                         EmailCU: Codeunit "Email Notifications";
                     begin
                         Clear(EmailCU);
                         EmailCU.SetRecord(Rec);
                         EmailCU.TEST();
                     end;
                 } */
            }
        }
        modify(Approve)
        {
            trigger OnAfterAction()
            begin
                Clear(g_cdu_EmailNoti);
                g_cdu_EmailNoti.SetRecord(Rec);
                g_cdu_EmailNoti.SendApproveBNotification();
            end;
        }
        addafter(Reconcile)
        {
            action("Reject Lines")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Enabled = RejecLine;

                trigger OnAction()
                var
                    CU50119: Codeunit "Review Gen Jnl";
                    GenJnlLine: Record "Gen. Journal Line";
                    GenJnlBatch_New: Record "Gen. Journal Batch";
                    UserSetup: Record "User Setup";
                    CreateRejBatchLines: codeunit "Create Rejection Batch Lines";
                begin
                    GenJnlBatch_New.Get(Rec."Journal Template Name", Rec."Journal Batch Name");
                    if GenJnlBatch_New."Review Status" = GenJnlBatch_New."Review Status"::Approved then Error('You can not reject lines when the approval status is approved');
                    //>>VJ06DEC2024
                    UserSetup.Get(UserId);
                    if UserSetup."User Type" = UserSetup."User Type"::Preparer then Error('Preparer can not reject lines');
                    //<<VJ06DEC2024
                    CurrPage.SetSelectionFilter(GenJnlLine);
                    Clear(CU50119);
                    IF GenJnlLine.FindSet()then //CreateRejBatchLines.Run(GenJnlLine);//#389 30072025 to move all payment journal lines
                        CreateRejBatchLines.MoveToRejectedJournal(GenJnlLine); //#389 30072025 to move all payment journal lines
                    //#002>>
                    if(UserId = Rec."Approver A Grp User")then begin
                        Clear(g_cdu_EmailNoti);
                        g_cdu_EmailNoti.SetRecord(Rec);
                        g_cdu_EmailNoti.RejectLineNotification();
                    end;
                    if(UserId = Rec."Approver B Grp User")then begin
                        Clear(g_cdu_EmailNoti);
                        g_cdu_EmailNoti.SetRecord(Rec);
                        g_cdu_EmailNoti.RejectLineNotificationB();
                    end;
                //#002<<
                end;
            }
            action("Force Reject Lines")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Enabled = ForceRejecLine;

                trigger OnAction()
                var
                    CU50119: Codeunit "Review Gen Jnl";
                    GenJnlLine: Record "Gen. Journal Line";
                    GenJnlBatch_New: Record "Gen. Journal Batch";
                    UserSetup: Record "User Setup";
                    CreateRejBatchLines: codeunit "Create Rejection Batch Lines";
                begin
                    GenJnlBatch_New.Get(Rec."Journal Template Name", Rec."Journal Batch Name");
                    //if GenJnlBatch_New."Review Status" = GenJnlBatch_New."Review Status"::Approved then
                    //   Error('You can not reject lines when the approval status is approved');
                    //>>VJ06DEC2024
                    UserSetup.Get(UserId);
                    // if UserSetup."User Type" = UserSetup."User Type"::Preparer then
                    //    Error('Preparer can not reject lines');
                    //<<VJ06DEC2024
                    CurrPage.SetSelectionFilter(GenJnlLine);
                    Clear(CU50119);
                    IF GenJnlLine.FindSet()then //CreateRejBatchLines.Run(GenJnlLine);//#389 30072025 to move all payment journal lines
                        CreateRejBatchLines.MoveToRejectedJournal(GenJnlLine); //#389 30072025 to move all payment journal lines
                    //#002>>
                    if(UserId = Rec."Approver A Grp User")then begin
                        Clear(g_cdu_EmailNoti);
                        g_cdu_EmailNoti.SetRecord(Rec);
                        g_cdu_EmailNoti.RejectLineNotification();
                    end;
                    if(UserId = Rec."Approver B Grp User")then begin
                        Clear(g_cdu_EmailNoti);
                        g_cdu_EmailNoti.SetRecord(Rec);
                        g_cdu_EmailNoti.RejectLineNotificationB();
                    end;
                    //Rec.Delete(false);
                    CurrPage.Update(false);
                //#002<<
                end;
            }
        }
        modify(Post)
        {
            Enabled = EnablePostBool;

            //>>VJ 05MARC2025
            trigger OnBeforeAction()
            var
                ReviewGenJnl: Codeunit "Review Gen Jnl";
            begin
                ReviewGenJnl.RunCheckBeforePost(Rec);
            end;
        //<<VJ 05MARC2025
        }
        modify("Post and &Print")
        {
            Enabled = EnablePostBool;

            //>>VJ 05MARC2025
            trigger OnBeforeAction()
            var
                ReviewGenJnl: Codeunit "Review Gen Jnl";
            begin
                ReviewGenJnl.RunCheckBeforePost(Rec);
            end;
        //<<VJ 05MARC2025
        }
        modify("Request Approval")
        {
            Visible = false;
        }
        modify(SuggestVendorPayments)
        {
            Enabled = ActionsEnable; //#118 TEC.VJ
        }
        modify(SuggestEmployeePayments)
        {
            Enabled = ActionsEnable; //#118 TEC.VJ
        }
        addafter(ApplyEntries)
        {
            action(GlobalApplyEntries)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Global Apply Entries';
                Ellipsis = true;
                Enabled = ApplyEntriesActionEnabled and ActionsEnable; //#118 TEC.VJ
                Image = ApplyEntries;
                RunObject = Codeunit "Global Gen. Jnl.-Apply";
                ShortCutKey = 'Shift+F11';
                ToolTip = 'Apply the payment amount on a journal line to a sales or purchase document that was already posted for a customer or vendor. This updates the amount on the posted document, and the document can either be partially paid, or closed as paid or refunded.';
            }
            action(ReCalculate)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'ReApply Entries';
                Ellipsis = true;
                Enabled = ApplyEntriesActionEnabled;
                Image = ApplyEntries;
                ToolTip = 'Apply the payment amount on a journal line to a sales or purchase document that was already posted for a customer or vendor. This updates the amount on the posted document, and the document can either be partially paid, or closed as paid or refunded.';

                trigger OnAction()
                var
                    GlobalGenJnl: Codeunit "Global Gen. Jnl.-Apply";
                begin
                    GlobalGenJnl.Recalculate(Rec);
                end;
            }
            action(ReAssginApplyId)
            {
                ApplicationArea = all;
                Caption = 'ReAssign Apply Id';
                Image = ApplyEntries;

                trigger OnAction()
                var
                    GVLE: Record "Global Vendor Ledger Entry";
                    GcLE: Record "Global Cust. Ledger Entry";
                begin
                    GVLE.Reset();
                    GVLE.SetRange("Vendor No.", Rec."Account No.");
                    GVLE.SetRange(Open, true);
                    GVLE.SetRange("Bank Document No. Applied", Rec."Bank Document No.");
                    if GVLE.FindFirst()then repeat GVLE."Applies-to ID":=Rec."Document No.";
                            GVLE.Modify();
                        until GVLE.Next() = 0;
                    GCLE.Reset();
                    GCLE.SetRange("Customer No.", Rec."Account No.");
                    GCLE.SetRange(Open, true);
                    GCLE.SetRange("Bank Document No. Applied", Rec."Bank Document No.");
                    if GCLE.FindFirst()then repeat GCLE."Applies-to ID":=Rec."Document No.";
                            GCLE.Modify();
                        until GCLE.Next() = 0;
                end;
            }
            action(UpdatePostingNoSeries)
            {
                Caption = 'Update Posting No. Series';
                ToolTip = 'Update Posting No. Series from template';
                ApplicationArea = All;

                trigger OnAction()
                var
                    CommonFunctions: Codeunit "Common Functions";
                begin
                    //Codeunit.Run(Codeunit::"Citi Inbound Codeunit V2_new");
                    CommonFunctions.UpdatePostingNoSeries(Rec);
                    Clear(CommonFunctions);
                    CurrPage.Update(false);
                end;
            }
        }
        //PS008 Start
        addlast("F&unctions")
        {
            action("Export BOC")
            {
                ApplicationArea = all;
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Exportifile: Codeunit "Export ifile";
                begin
                    Exportifile.Exportifile(Rec);
                end;
            }
        }
        //PS008 End
        addafter(CreditTransferRegisters)
        {
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
        }
    }
    var TectEnable: Boolean;
    APIStatus: text[20];
    EnablePostBool: Boolean;
    CancelReviewEnable: Boolean;
    SendForReviewEnable: Boolean;
    RepeaterEnable: Boolean;
    ConfirmReviewEnable: Boolean;
    RejectReviewEnable: Boolean;
    GenJnlbatch_: Record "Gen. Journal Batch";
    GenJnlManagement: Codeunit GenJnlManagement;
    JournalModifyError: Label 'Journal can not be modified when Review Status is %1';
    JournalApprovalStatusError: Label 'Journal can not be modified when Approval Status is %1';
    JournalDeleteError: Label 'Journal can not be inserted when suggest vendor lines exist.';
    LastGenJnlBatch: Code[10];
    ApprovalMgmt: Codeunit "Approvals Mgmt.";
    GenJnlBatchApprovalStatus: Text[20];
    EnabledGenJnlBatchWorkflowsExist: Boolean;
    WorkflowManagement: Codeunit "Workflow Management";
    WorkflowEventHandling: Codeunit "Workflow Event Handling";
    EnableBypass: Boolean;
    GnlJnlBatch: Record "Gen. Journal Batch";
    isACHPaymentMethod: Boolean;
    g_cdu_EmailNoti: Codeunit "Email Notifications";
    RejecLine: Boolean;
    ForceRejecLine: Boolean;
    ActionsEnable: Boolean;
    GenBatchBypassAPI: Boolean;
    StyleExprtxt: Text[100];
    g_txt_APIInformation: Text;
    g_txt_TxSts: Text;
    trigger OnOpenPage()
    begin
        EnableByPass_();
        ContrlPageEditableonReviewStatus();
        UpdateReviewActions();
        EnableRejectLines();
        EnableButton(); //NT_ 12-03-2025
    end;
    local procedure EnableButton()
    var
        tmp: Text;
    begin
        TectEnable:=false;
        tmp:=UserId;
        tmp:=tmp.ToUpper();
        if tmp.Contains('TECTURA')then TectEnable:=true;
    end;
    trigger OnAfterGetRecord()
    begin
        EnableByPass_();
        VisiblePaymentSetCode();
        GetAPIStatus(); //VJ09DEC2024
        // Rec.CalcFields("No Corresponding Bank for Pmt");
        if Rec."Amount Mismatch" then StyleExprtxt:='unfavorable'
        else
            StyleExprtxt:='standard';
    end;
    trigger OnAfterGetCurrRecord()
    begin
        ContrlPageEditableonReviewStatus();
        UpdateReviewActions();
        EnableByPass_();
    end;
    trigger OnModifyRecord(): Boolean begin
        VerifyIfGenLineInMoDelallowed();
        GetAPIStatus(); //NT_ 14-03-2025 
    end;
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean begin
        VerifyIfGenLineInMoDelallowed();
        //  InsertAllowed();//TEC.VJ 17DEC2024   -- Sgarg - commented for time being
        GetAPIStatus(); //NT_ 14-03-2025 
    end;
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
    //  InsertAllowed();//TEC.VJ 17DEC2024    -- Sgarg - commented for time being
    end;
    trigger OnDeleteRecord(): Boolean var
        CommonFunction: Codeunit "Common Functions";
    begin
        VerifyIfGenLineInMoDelallowed();
        //TEC.VJ 17DEC2024>>
        EnabledGenJnlBatchWorkflowsExist:=WorkflowManagement.EnabledWorkflowExist(DATABASE::"Gen. Journal Batch", WorkflowEventHandling.RunWorkflowOnSendGeneralJournalBatchForApprovalCode());
        ApprovalMgmt.GetGenJnlBatchApprovalStatus(Rec, GenJnlBatchApprovalStatus, EnabledGenJnlBatchWorkflowsExist);
        if GenJnlBatchApprovalStatus = 'Approved' then error(JournalApprovalStatusError, GenJnlBatchApprovalStatus);
        //TEC.VJ 17DEC2024<<
        CommonFunction."Gen. Journal Line_OnAfterClearCustVendApplnEntry"(Rec); //#194 10Feb2025
    end;
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
    local procedure GetCurrentReviewStatus()RvStatus: Enum "Review Status";
    var
        myInt: Integer;
    begin
        GetGenJnlBatch();
        IF EnabledGenJnlBatchWorkflowsExist then begin
            case GenJnlBatchApprovalStatus of '': begin
            End;
            'Created': begin
                GenJnlbatch_."Review Status":=GenJnlbatch_."Review Status"::"Approval Created";
                GenJnlbatch_.Modify();
            end;
            'Open': begin
                GenJnlbatch_."Review Status":=GenJnlbatch_."Review Status"::"Approval Open";
                GenJnlbatch_.Modify();
            End;
            'Canceled': begin
                GenJnlbatch_."Review Status":=GenJnlbatch_."Review Status"::" ";
                GenJnlbatch_."Prepare User":='';
                GenJnlbatch_."Reviewer User":='';
                GenJnlbatch_."Review Comments":='';
                GenJnlbatch_."Approver A Grp User":='';
                GenJnlbatch_."Approver B Grp User":='';
                GenJnlbatch_.Modify();
            End;
            'Rejected': begin
                GenJnlbatch_."Review Status":=GenJnlbatch_."Review Status"::" ";
                GenJnlbatch_."Prepare User":='';
                GenJnlbatch_."Reviewer User":='';
                GenJnlbatch_."Review Comments":='';
                GenJnlbatch_."Approver A Grp User":='';
                GenJnlbatch_."Approver B Grp User":='';
                GenJnlbatch_.Modify();
            End;
            'Approved': begin
                GenJnlbatch_."Review Status":=GenJnlbatch_."Review Status"::Approved;
                GenJnlbatch_.Modify();
            End;
            end;
        end;
        RvStatus:=GenJnlbatch_."Review Status";
        exit(RvStatus);
    end;
    local procedure GetGenJnlBatch()
    begin
        GenJnlbatch_.Reset();
        if GenJnlbatch_.Get(Rec.GetRangeMax("Journal Template Name"), CurrentJnlBatchName)then;
        GenBatchBypassAPI:=GenJnlbatch_."Bypass API";
    end;
    local procedure ContrlPageEditableonReviewStatus()
    begin
        GetGenJnlBatch();
    end;
    local procedure UpdateReviewActions()
    var
        UserSetup: Record "User Setup";
    begin
        EnabledGenJnlBatchWorkflowsExist:=WorkflowManagement.EnabledWorkflowExist(DATABASE::"Gen. Journal Batch", WorkflowEventHandling.RunWorkflowOnSendGeneralJournalBatchForApprovalCode());
        ApprovalMgmt.GetGenJnlBatchApprovalStatus(Rec, GenJnlBatchApprovalStatus, EnabledGenJnlBatchWorkflowsExist);
        if(GenJnlBatchApprovalStatus = '') and (GenJnlbatch_."Partially Posted")then //TEC.VJ 01042025
 GenJnlBatchApprovalStatus:='Approved';
        if GenJnlBatchApprovalStatus = 'Approved' then ActionsEnable:=false
        else
            ActionsEnable:=true;
        // GenJnlbatch_."Review Status" := GenJnlbatch_."Review Status";
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
            EnablePostBool:=true;
        end;
        if(SendForReviewEnable = false) and (Rec."Bypass API")then RepeaterEnable:=true
        else if SendForReviewEnable then RepeaterEnable:=true
            else
                RepeaterEnable:=false;
        //NT_ 10022025 >>
        if UserSetup.Get(UserId)then begin
            if(UserSetup."User Type" = UserSetup."User Type"::Preparer) and (GenJnlbatch_."Review Status" = GenJnlbatch_."Review Status"::" ") and (UserId <> GenJnlbatch_."Prepare User")then begin
                CancelReviewEnable:=false;
                SendForReviewEnable:=true;
                ConfirmReviewEnable:=false;
                RejectReviewEnable:=false;
                //EnablePostBool := false;
                RepeaterEnable:=true;
            end;
        end;
    //NT_ 10022025 <<
    end;
    local procedure VerifyIfGenLineInMoDelallowed()
    var
        Usersetup_l: Record "User Setup";
    begin
        Usersetup_l.Get(UserId);
        Usersetup_l.TestField("User Type", Usersetup_l."User Type"::Preparer);
        // ReviewStatus_var := GenJnlbatch_."Review Status";
        case GenJnlbatch_."Review Status" of GenJnlbatch_."Review Status"::" ": ;
        GenJnlbatch_."Review Status"::Approved: Error(JournalModifyError, GenJnlbatch_."Review Status");
        GenJnlbatch_."Review Status"::"Pending for Review": Error(JournalModifyError, GenJnlbatch_."Review Status");
        GenJnlbatch_."Review Status"::Rejected: ;
        GenJnlbatch_."Review Status"::Reviewed: Error(JournalModifyError, GenJnlbatch_."Review Status");
        GenJnlbatch_."Review Status"::"Approval Created": Error(JournalModifyError, GenJnlbatch_."Review Status");
        GenJnlbatch_."Review Status"::"Approval Canceled": ;
        GenJnlbatch_."Review Status"::"Approval Open": Error(JournalModifyError, GenJnlbatch_."Review Status");
        GenJnlbatch_."Review Status"::"Approval Rejected": ;
        end;
        if(GenJnlBatchApprovalStatus = '') and (GenJnlbatch_."Partially Posted")then GenJnlBatchApprovalStatus:='Approved';
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
    //>>VJ06DEC2024
    local procedure EnableRejectLines()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        if UserSetup."User Type" = UserSetup."User Type"::Preparer then RejecLine:=false
        else
            RejecLine:=true;
        if UserSetup."Allow Force Reject Pmt Journal" then ForceRejecLine:=true
        else
            ForceRejecLine:=false;
    end;
    //<<VJ06DEC2024
    //TEC.VJ 17DEC2024>>
    local procedure InsertAllowed()
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        GenJnlLine.SetRange("Suggest Vendor Line", true);
        if GenJnlLine.FindFirst()then Error(JournalDeleteError);
    end;
    //TEC.VJ 17DEC2024<<
    procedure VisiblePaymentSetCode()
    begin
        if Rec."Payment Method Code" = 'ACH' then isACHPaymentMethod:=true
        ELSE
            isACHPaymentMethod:=false;
    end;
    procedure GetAPIStatus()
    var
        BankAccount: Record "Bank Account";
        HSBCOutbound: Record "HSBC Outbound Staging Table";
        CitiOutbound: Record "Citi Outbound Staging Table";
    begin
        Clear(APIStatus);
        //NT_ 20250729 >>
        Clear(g_txt_APIInformation);
        Clear(g_txt_TxSts);
        if Rec."Account No." = '' then exit;
        //NT_ 20250729 <<
        if Rec."Bal. Account Type" = Rec."Bal. Account Type"::"Bank Account" then begin
            if BankAccount.Get(Rec."Bal. Account No.") and (BankAccount."Bank Integration Type" = BankAccount."Bank Integration Type"::HSBC)then begin
                HSBCOutbound.Reset();
                HSBCOutbound.SetRange("Journal Template Name", rec."Journal Template Name");
                HSBCOutbound.SetRange("Journal Batch Name", rec."Journal Batch Name");
                HSBCOutbound.SetRange("Bank Document No.", rec."Bank Document No.");
                if HSBCOutbound.FindFirst()then begin
                    APIStatus:=format(HSBCOutbound.Status);
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
                        APIStatus:=format(CitiOutbound.Status);
                        //NT_ 20250729 >>
                        g_txt_APIInformation:=CitiOutbound."API Information";
                        g_txt_TxSts:=CitiOutbound.TxSts;
                    //NT_ 20250729 <<
                    end;
                end end;
    end;
    //NT_ 13-02-2025 >>
    local procedure CalMismatch()
    begin
        Rec.Validate("Amount Mismatch", Rec."Amount (LCY)" <> Rec."Applied Amount");
        Rec.Modify();
    end;
    //NT_ 13-02-2025 <<
    procedure EmailLengthCheck()
    var
        BankAccount: Record "Bank Account";
        l_rec_GJL: Record "Gen. Journal Line";
    begin
        if BankAccount.get(Rec."Bal. Account No.")then begin
            if BankAccount."Bank Integration Type" = BankAccount."Bank Integration Type"::Citi then begin
                l_rec_GJL.Reset();
                l_rec_GJL.SetRange("Journal Template Name", Rec."Journal Template Name");
                l_rec_GJL.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                if l_rec_GJL.FindFirst()then repeat if StrLen(l_rec_GJL."Remittance Email 1") > 35 then Error('Remittance Email 1 length cannot exceed 35');
                        if StrLen(l_rec_GJL."Remittance Email 2") > 35 then Error('Remittance Email 2 length cannot exceed 35');
                        if StrLen(l_rec_GJL."Remittance Email 3") > 35 then Error('Remittance Email 3 length cannot exceed 35');
                        if StrLen(l_rec_GJL."Remittance Email 4") > 35 then Error('Remittance Email 4 length cannot exceed 35');
                    until l_rec_GJL.Next() = 0;
            end;
        end;
    end;
}
