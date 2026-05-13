page 50191 "Payment Journal After Split"
{
    AdditionalSearchTerms = 'print check,payment file export,electronic payment';
    // ApplicationArea = Basic, Suite;
    AutoSplitKey = true;
    Caption = 'Payment Journals After Split';
    // DataCaptionExpression = Rec.DataCaption();
    DelayedInsert = true;
    PageType = List;
    SaveValues = true;
    SourceTable = "GJL Split";
    //UsageCategory = Tasks;
    Editable = false;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;

                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Style = Attention;
                    StyleExpr = HasPmtFileErr;
                    ToolTip = 'Specifies the posting date for the entry.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic, Suite;
                    Style = Attention;
                    StyleExpr = HasPmtFileErr;
                    ToolTip = 'Specifies the date when the related document was created.';
                    Visible = false;
                }
                field("Invoice Received Date"; Rec."Invoice Received Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date when the related document was received.';
                    Visible = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    Style = Attention;
                    StyleExpr = HasPmtFileErr;
                    ToolTip = 'Specifies the type of document that the entry on the journal line is.';
                }
                field("Company Code"; Rec."Company Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Company Code field.';
                }
                field("Applied Company Code"; Rec."Applied Company Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Applied Company Code field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Style = Attention;
                    StyleExpr = HasPmtFileErr;
                    ToolTip = 'Specifies a document number for the journal line.';
                    ShowMandatory = true;
                }
                field("Bank Document No."; Rec."Bank Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Document No. field.';
                }
                field("Incoming Document Entry No."; Rec."Incoming Document Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the incoming document that this general journal line is created for.';
                    Visible = false;

                    trigger OnAssistEdit()
                    begin
                    //if Rec."Incoming Document Entry No." > 0 then
                    //    HyperLink(Rec.GetIncomingDocumentURL());
                    end;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                }
                field("Applies-to Ext. Doc. No."; Rec."Applies-to Ext. Doc. No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the external document number that will be exported in the payment file.';
                    Visible = false;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of account that the entry on the journal line will be posted to.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ShowMandatory = true;
                    Style = Attention;
                    StyleExpr = HasPmtFileErr;
                    ToolTip = 'Specifies the account number that the entry on the journal line will be posted to.';
                }
                field("Recipient Bank Account"; Rec."Recipient Bank Account")
                {
                    ApplicationArea = Basic, Suite;
                    ShowMandatory = RecipientBankAccountMandatory;
                    ToolTip = 'Specifies the bank account that the amount will be transferred to after it has been exported from the payment journal.';
                }
                field("Message to Recipient"; Rec."Message to Recipient")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the message exported to the payment file when you use the Export Payments to File function in the Payment Journal window.';
                }
                field(GenJnlLineApprovalStatus; GenJnlLineApprovalStatus)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Approval Status';
                    Editable = false;
                    Visible = EnabledGenJnlLineWorkflowsExist;
                    ToolTip = 'Specifies the approval status for general journal line.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Style = Attention;
                    StyleExpr = HasPmtFileErr;
                    ToolTip = 'Specifies a description of the entry.';
                }
                field("Salespers./Purch. Code"; Rec."Salespers./Purch. Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the salesperson or purchaser who is linked to the journal line.';
                    Visible = false;
                }
                field("Campaign No."; Rec."Campaign No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of the campaign that the journal line is linked to.';
                    Visible = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                    AssistEdit = true;
                    ToolTip = 'Specifies the code of the currency for the amounts on the journal line.';

                    trigger OnAssistEdit()
                    begin
                        ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", Rec."Posting Date");
                        if ChangeExchangeRate.RunModal() = ACTION::OK then Rec.Validate("Currency Factor", ChangeExchangeRate.GetParameter());
                        Clear(ChangeExchangeRate);
                    end;
                }
                field("Invoice Currency Code"; Rec."Invoice Currency Code")
                {
                    ToolTip = 'Specifies the value of the Invoice Currency Code field.';
                    ApplicationArea = All;
                }
                field("Gen. Posting Type"; Rec."Gen. Posting Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of transaction.';
                    Visible = false;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the vendor''s or customer''s trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.';
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
                    Visible = false;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                    Visible = false;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                    Visible = false;
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = IsPostingGroupEditable;
                    ToolTip = 'Specifies the posting group that will be used in posting the journal line.The field is used only if the account type is either customer or vendor.';
                    Visible = IsPostingGroupEditable;
                }
                field("Allocation Account No."; Rec."Selected Alloc. Account No.")
                {
                    ApplicationArea = All;
                    Caption = 'Allocation Account No.';
                    ToolTip = 'Specifies the allocation account number that will be used to distribute the amounts during the posting process.';
                    Visible = UseAllocationAccountNumber;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = Basic, Suite;
                    ShowMandatory = true;
                    ToolTip = 'Specifies how to make payment, such as with bank transfer, cash, or check.';
                }
                field("Payment Reference"; Rec."Payment Reference")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the payment of the purchase invoice.';
                }
                field("Creditor No."; Rec."Creditor No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the vendor who sent the purchase invoice.';
                }
                field(Amount; Rec.Amount)
                {
                    Caption = 'Payment Amount';
                    ApplicationArea = Basic, Suite;
                    ShowMandatory = true;
                    Style = Attention;
                    StyleExpr = HasPmtFileErr;
                    ToolTip = 'Specifies the total amount (including VAT) that the journal line consists of.';
                // Visible = AmountVisible;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total amount in local currency (including VAT) that the journal line consists of.';
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total of the ledger entries that represent debits.';
                    visible = false;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total of the ledger entries that represent credits.';
                    visible = false;
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the amount of VAT that is included in the total amount.';
                    Visible = false;
                }
                field("VAT Difference"; Rec."VAT Difference")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the difference between the calculated VAT amount and a VAT amount that you have entered manually.';
                    Visible = false;
                }
                field("Bal. VAT Amount"; Rec."Bal. VAT Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the amount of Bal. VAT included in the total amount.';
                    Visible = false;
                }
                field("Bal. VAT Difference"; Rec."Bal. VAT Difference")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the difference between the calculate VAT amount and the VAT amount that you have entered manually.';
                    Visible = false;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of account that a balancing entry is posted to, such as BANK for a cash account.';
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the general ledger, customer, vendor, or bank account that the balancing entry is posted to, such as a cash account for cash purchases.';
                }
                field("Bal. Gen. Posting Type"; Rec."Bal. Gen. Posting Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the general posting type associated with the balancing account that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("Bal. Gen. Bus. Posting Group"; Rec."Bal. Gen. Bus. Posting Group")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the general business posting group code associated with the balancing account that will be used when you post the entry.';
                    Visible = false;
                }
                field("Bal. Gen. Prod. Posting Group"; Rec."Bal. Gen. Prod. Posting Group")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the general product posting group code associated with the balancing account that will be used when you post the entry.';
                    Visible = false;
                }
                field("Bal. VAT Bus. Posting Group"; Rec."Bal. VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the code of the VAT business posting group that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("Bal. VAT Prod. Posting Group"; Rec."Bal. VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the code of the VAT product posting group that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                // field("Applied (Yes/No)"; Rec.IsApplied())
                // {
                //     ApplicationArea = Basic, Suite;
                //     Caption = 'Applied (Yes/No)';
                //     ToolTip = 'Specifies if the payment has been applied.';
                // }
                field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
                }
                field(AppliesToDocNo; Rec."Applies-to Doc. No.")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
                }
                field("IMOS Transaction No"; Rec."IMOS Transaction No")
                {
                    ApplicationArea = basic, suite;
                    ToolTip = 'Specifies the value of the IMOS Transaction No. field.';
                }
                field("Applies-to ID"; Rec."Applies-to ID")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the ID of entries that will be applied to when you choose the Apply Entries action.';
                    Visible = false;
                }
                // field(GetAppliesToDocDueDate; Rec.GetAppliesToDocDueDate())
                // {
                //     ApplicationArea = Basic, Suite;
                //     Caption = 'Applies-to Doc. Due Date';
                //     StyleExpr = StyleTxt;
                //     ToolTip = 'Specifies the due date from the Applies-to Doc. on the journal line.';
                // }
                field("Bank Payment Type"; Rec."Bank Payment Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the code for the payment type to be used for the entry on the journal line.';
                }
                field("Check Printed"; Rec."Check Printed")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether a check has been printed for the amount on the payment journal line.';
                    Visible = false;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the entry.';
                    Visible = false;
                }
                field(Correction; Rec.Correction)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the entry as a corrective entry. You can use the field if you need to post a corrective entry to an account.';
                }
                field(CommentField; Rec.Comment)
                {
                    ApplicationArea = Comments;
                    ToolTip = 'Specifies a comment about the activity on the journal line. Note that the comment is not carried forward to posted entries.';
                    Visible = false;
                }
                field("Invoice Link"; Rec."Invoice Link")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Invoice Link field.', Comment = '%';
                }
                field("Receipt image ID"; Rec."Receipt image ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Receipt image ID field.';
                }
                field("Exported to Payment File"; Rec."Exported to Payment File")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies that the payment journal line was exported to a payment file.';
                }
                // field(TotalExportedAmount; Rec.TotalExportedAmount())
                // {
                //     ApplicationArea = Basic, Suite;
                //     Caption = 'Total Exported Amount';
                //     DrillDown = true;
                //     ToolTip = 'Specifies the amount for the payment journal line that has been exported to payment files that are not canceled.';
                //     trigger OnDrillDown()
                //     begin
                //         Rec.DrillDownExportedAmount();
                //     end;
                // }
                field("Has Payment Export Error"; Rec."Has Payment Export Error")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies that an error occurred when you used the Export Payments to File function in the Payment Journal window.';
                }
                field("Job Queue Status"; Rec."Job Queue Status")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the status of a job queue entry or task that handles the posting of general journals.';
                    Visible = JobQueuesUsed;

                    trigger OnDrillDown()
                    var
                        JobQueueEntry: Record "Job Queue Entry";
                    begin
                        if Rec."Job Queue Status" = Rec."Job Queue Status"::" " then exit;
                        JobQueueEntry.ShowStatusMsg(Rec."Job Queue Entry ID");
                    end;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = DimVisible1;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = DimVisible2;
                }
                field(ShortcutDimCode3; ShortcutDimCode[3])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code where("Global Dimension No."=const(3), "Dimension Value Type"=const(Standard), Blocked=const(false));
                    Visible = DimVisible3;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[3] field.';

                    trigger OnValidate()
                    begin
                    //   Rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field(ShortcutDimCode4; ShortcutDimCode[4])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code where("Global Dimension No."=const(4), "Dimension Value Type"=const(Standard), Blocked=const(false));
                    Visible = DimVisible4;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[4] field.';

                    trigger OnValidate()
                    begin
                    //    Rec.ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                field(ShortcutDimCode5; ShortcutDimCode[5])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code where("Global Dimension No."=const(5), "Dimension Value Type"=const(Standard), Blocked=const(false));
                    Visible = DimVisible5;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[5] field.';

                    trigger OnValidate()
                    begin
                    //   Rec.ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field(ShortcutDimCode6; ShortcutDimCode[6])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code where("Global Dimension No."=const(6), "Dimension Value Type"=const(Standard), Blocked=const(false));
                    Visible = DimVisible6;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[6] field.';

                    trigger OnValidate()
                    begin
                    //     Rec.ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field(ShortcutDimCode7; ShortcutDimCode[7])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code where("Global Dimension No."=const(7), "Dimension Value Type"=const(Standard), Blocked=const(false));
                    Visible = DimVisible7;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[7] field.';

                    trigger OnValidate()
                    begin
                    //   Rec.ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field(ShortcutDimCode8; ShortcutDimCode[8])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code where("Global Dimension No."=const(8), "Dimension Value Type"=const(Standard), Blocked=const(false));
                    Visible = DimVisible8;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[8] field.';

                    trigger OnValidate()
                    begin
                    //  Rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
                field("Remit-to Code"; Rec."Remit-to Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the address for the remit-to code.';
                    Visible = true;
                    TableRelation = "Remit Address".Code where("Vendor No."=field("Account No."));
                }
            }
            group(Control24)
            {
                ShowCaption = false;

                // Visible = false;
                fixed(Control1903561801)
                {
                    ShowCaption = false;

                    group("Number of Lines")
                    {
                        Caption = 'Number of Lines';

                        field(NumberOfJournalRecords; NumberOfRecords)
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            ShowCaption = false;
                            Editable = false;
                            ToolTip = 'Specifies the number of lines in the current journal batch.';
                        }
                    }
                    group("Account Name")
                    {
                        Caption = 'Account Name';
                        Visible = false;

                        field(AccName; AccName)
                        {
                            ApplicationArea = Basic, Suite;
                            Editable = false;
                            ShowCaption = false;
                            ToolTip = 'Specifies the name of the account.';
                        }
                    }
                    group("Bal. Account Name")
                    {
                        Caption = 'Bal. Account Name';
                        Visible = false;

                        field(BalAccName; BalAccName)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Bal. Account Name';
                            Editable = false;
                            ToolTip = 'Specifies the name of the balancing account that has been entered on the journal line.';
                        }
                    }
                    group(Control1900545401)
                    {
                        Caption = 'Balance';
                        Visible = false;

                        field(Balance; Balance)
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Caption = 'Balance';
                            Editable = false;
                            ToolTip = 'Specifies the balance that has accumulated in the payment journal on the line where the cursor is.';
                            Visible = BalanceVisible;
                        }
                    }
                    group("Total Balance")
                    {
                        Caption = 'Total Balance';
                        Visible = false;

                        field(TotalBalance; TotalBalance)
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Caption = 'Total Balance';
                            Editable = false;
                            ToolTip = 'Specifies the total balance in the payment journal.';
                            Visible = TotalBalanceVisible;
                        }
                    }
                }
            }
        }
    }
    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;

                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Alt+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions();
                        CurrPage.SaveRecord();
                    end;
                }
                action(IncomingDoc)
                {
                    AccessByPermission = TableData "Incoming Document"=R;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Incoming Document';
                    Image = Document;
                    Scope = Repeater;
                    ToolTip = 'View or create an incoming document record that is linked to the entry or document.';

                    trigger OnAction()
                    var
                        IncomingDocument: Record "Incoming Document";
                    begin
                        Rec.Validate("Incoming Document Entry No.", IncomingDocument.SelectIncomingDocument(Rec."Incoming Document Entry No.", Rec.RecordId()));
                    end;
                }
            }
            group("&Payments")
            {
                Caption = '&Payments';
                Image = Payment;
            }
            action(OpenImage)
            {
                ApplicationArea = all;
                Image = Confirm;
                Caption = 'Open Image';
                ToolTip = 'Executes the Open Image action.';

                trigger OnAction()
                var
                    l_cdu_ConcurImageAPI: Codeunit "Concur Image API";
                begin
                    Clear(l_cdu_ConcurImageAPI);
                    l_cdu_ConcurImageAPI.GetExpenseImageUrl(Rec."Receipt image ID");
                end;
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean begin
    // CurrPage.IncomingDocAttachFactBox.PAGE.SetCurrentRecordID(Rec.RecordId);
    end;
    trigger OnAfterGetRecord()
    begin
        GetIMOSTransactionNo();
    end;
    trigger OnAfterGetCurrRecord()
    begin
        UpdateBalance();
    end;
    procedure UpdateBalance()
    var
        IsHandled: Boolean;
        TempGenJnlLine: Record "GJL Split";
        rr: Report 511;
    begin
        TempGenJnlLine.CopyFilters(Rec);
        if CurrentClientType in[CLIENTTYPE::SOAP, CLIENTTYPE::OData, CLIENTTYPE::ODataV4, CLIENTTYPE::Api]then ShowTotalBalance:=false
        else
            ShowTotalBalance:=TempGenJnlLine.CalcSums("Balance (LCY)");
        if ShowTotalBalance then begin
            TotalBalance:=TempGenJnlLine."Balance (LCY)";
        end;
        if CurrentClientType in[CLIENTTYPE::SOAP, CLIENTTYPE::OData, CLIENTTYPE::ODataV4, CLIENTTYPE::Api]then ShowBalance:=false;
        BalanceVisible:=ShowBalance;
        TotalBalanceVisible:=ShowTotalBalance;
        if ShowTotalBalance then NumberOfRecords:=Rec.Count();
    end;
    var //IMOSTransactionNo: Text[50];
    PurchasesPayablesSetup: Record "Purchases & Payables Setup";
    GeneralLedgerSetup: Record "General Ledger Setup";
    CheckManagement: Codeunit CheckManagement;
    JournalErrorsMgt: Codeunit "Journal Errors Mgt.";
    BackgroundErrorHandlingMgt: Codeunit "Background Error Handling Mgt.";
    ApprovalMgmt: Codeunit "Approvals Mgmt.";
    ClientTypeManagement: Codeunit "Client Type Management";
    ChangeExchangeRate: Page "Change Exchange Rate";
    GenJnlBatchApprovalStatus: Text[20];
    GenJnlLineApprovalStatus: Text[20];
    Balance: Decimal;
    TotalBalance: Decimal;
    NumberOfRecords: Integer;
    ShowBalance: Boolean;
    ShowTotalBalance: Boolean;
    HasPmtFileErr: Boolean;
    BalanceVisible: Boolean;
    TotalBalanceVisible: Boolean;
    IsPostingGroupEditable: Boolean;
    StyleTxt: Text;
    OverdueWarningText: Text;
    EventFilter: Text;
    IsPowerAutomatePrivacyNoticeApproved: Boolean;
    OpenApprovalEntriesExistForCurrUser: Boolean;
    OpenApprovalEntriesExistForCurrUserBatch: Boolean;
    OpenApprovalEntriesOnJnlBatchExist: Boolean;
    OpenApprovalEntriesOnJnlLineExist: Boolean;
    OpenApprovalEntriesOnBatchOrCurrJnlLineExist: Boolean;
    OpenApprovalEntriesOnBatchOrAnyJnlLineExist: Boolean;
    ShowWorkflowStatusOnBatch: Boolean;
    ShowWorkflowStatusOnLine: Boolean;
    CanCancelApprovalForJnlBatch: Boolean;
    CanCancelApprovalForJnlLine: Boolean;
    EnabledApprovalWorkflowsExist: Boolean;
    IsAllowPaymentExport: Boolean;
    IsSaaSExcelAddinEnabled: Boolean;
    RecipientBankAccountMandatory: Boolean;
    CanRequestFlowApprovalForBatch: Boolean;
    CanRequestFlowApprovalForBatchAndAllLines: Boolean;
    CanRequestFlowApprovalForBatchAndCurrentLine: Boolean;
    CanCancelFlowApprovalForBatch: Boolean;
    CanCancelFlowApprovalForLine: Boolean;
    AmountVisible: Boolean;
    IsSaaS: Boolean;
    DebitCreditVisible: Boolean;
    JobQueuesUsed: Boolean;
    JobQueueVisible: Boolean;
    BackgroundErrorCheck: Boolean;
    ShowAllLinesEnabled: Boolean;
    EnabledGenJnlLineWorkflowsExist: Boolean;
    EnabledGenJnlBatchWorkflowsExist: Boolean;
    ApprovalEntriesExistSentByCurrentUser: Boolean;
    UseAllocationAccountNumber: Boolean;
    ActionOnlyAllowedForAllocationAccountsErr: Label 'This action is only available for lines that have Allocation Account set as Account Type or Balancing Account Type.';
    VoidCheckQst: Label 'Void Check %1?', Comment = '%1 - check number';
    VoidAllPrintedChecksQst: Label 'Void all printed checks?';
    GeneratingPaymentsMsg: Label 'Generating Payment file...';
    AmountToApplyMissMatchMsg: Label 'Amount assigned on Apply Entries (%1) is bigger then the amount on the line (%2). System will remove all related Applies-to ID. Do you want to proceed?', Comment = '%1 - Amount to apply, %2 - Amount on the line';
    protected var GenJnlManagement: Codeunit GenJnlManagement;
    ShortcutDimCode: array[8]of Code[20];
    CurrentJnlBatchName: Code[10];
    DimVisible1: Boolean;
    DimVisible2: Boolean;
    DimVisible3: Boolean;
    DimVisible4: Boolean;
    DimVisible5: Boolean;
    DimVisible6: Boolean;
    DimVisible7: Boolean;
    DimVisible8: Boolean;
    ApplyEntriesActionEnabled: Boolean;
    AccName: Text[100];
    BalAccName: Text[100];
    local procedure GetIMOSTransactionNo()
    var
        l_rec_GVLE: Record "Global Vendor Ledger Entry";
    begin
    /*
        Clear(IMOSTransactionNo);
        l_rec_GVLE.Reset();
        l_rec_GVLE.SetRange("Document No.", Rec."Applies-to Doc. No.");
        if l_rec_GVLE.FindFirst() then
            IMOSTransactionNo := l_rec_GVLE."IMOS Transaction No";
            */
    end;
}
