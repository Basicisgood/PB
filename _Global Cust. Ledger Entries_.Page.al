page 50189 "Global Cust. Ledger Entries"
{
    ApplicationArea = All;
    Caption = 'Global Cust. Ledger Entries';
    PageType = List;
    SourceTable = "Global Cust. Ledger entry";
    UsageCategory = Lists;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Company Code"; Rec."Company Code")
                {
                    ToolTip = 'Specifies the value of the Company Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                //TEC.VJ 06MAR2025>>
                field("Bank Document No."; Rec."Bank Document No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("IMOS Transaction No"; Rec."IMOS Transaction No")
                {
                    ApplicationArea = all;
                }
                field("CP External Document No"; Rec."CP External Document No")
                {
                    ApplicationArea = all;
                }
                field("Bank Document No. Applied"; Rec."Bank Document No. Applied")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                //TEC.VJ 06MAR2025<<
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Your Reference"; Rec."Your Reference")
                {
                    ToolTip = 'Specifies the value of the Your Reference field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ToolTip = 'Specifies the value of the Remaining Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Original Amt. (LCY)"; Rec."Original Amt. (LCY)")
                {
                    ToolTip = 'Specifies the value of the Original Amt. (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Remaining Amt. (LCY)"; Rec."Remaining Amt. (LCY)")
                {
                    ToolTip = 'Specifies the value of the Remaining Amt. (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ToolTip = 'Specifies the value of the Amount (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Sales (LCY)"; Rec."Sales (LCY)")
                {
                    ToolTip = 'Specifies the value of the Sales (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Profit (LCY)"; Rec."Profit (LCY)")
                {
                    ToolTip = 'Specifies the value of the Profit (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Inv. Discount (LCY)"; Rec."Inv. Discount (LCY)")
                {
                    ToolTip = 'Specifies the value of the Inv. Discount (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ToolTip = 'Specifies the value of the Sell-to Customer No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    ToolTip = 'Specifies the value of the Customer Posting Group field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ToolTip = 'Specifies the value of the Salesperson Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the value of the User ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ToolTip = 'Specifies the value of the Source Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("On Hold"; Rec."On Hold")
                {
                    ToolTip = 'Specifies the value of the On Hold field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
                {
                    ToolTip = 'Specifies the value of the Applies-to Doc. Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
                {
                    ToolTip = 'Specifies the value of the Applies-to Doc. No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Open; Rec.Open)
                {
                    ToolTip = 'Specifies the value of the Open field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ToolTip = 'Specifies the value of the Due Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Pmt. Discount Date"; Rec."Pmt. Discount Date")
                {
                    ToolTip = 'Specifies the value of the Pmt. Discount Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Original Pmt. Disc. Possible"; Rec."Original Pmt. Disc. Possible")
                {
                    ToolTip = 'Specifies the value of the Original Pmt. Disc. Possible field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Pmt. Disc. Given (LCY)"; Rec."Pmt. Disc. Given (LCY)")
                {
                    ToolTip = 'Specifies the value of the Pmt. Disc. Given (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Orig. Pmt. Disc. Possible(LCY)"; Rec."Orig. Pmt. Disc. Possible(LCY)")
                {
                    ToolTip = 'Specifies the value of the Orig. Pmt. Disc. Possible (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Positive; Rec.Positive)
                {
                    ToolTip = 'Specifies the value of the Positive field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Closed by Entry No."; Rec."Closed by Entry No.")
                {
                    ToolTip = 'Specifies the value of the Closed by Entry No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Closed at Date"; Rec."Closed at Date")
                {
                    ToolTip = 'Specifies the value of the Closed at Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Closed by Amount"; Rec."Closed by Amount")
                {
                    ToolTip = 'Specifies the value of the Closed by Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Applies-to ID"; Rec."Applies-to ID")
                {
                    ToolTip = 'Specifies the value of the Applies-to ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Journal Templ. Name"; Rec."Journal Templ. Name")
                {
                    ToolTip = 'Specifies the value of the Journal Template Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ToolTip = 'Specifies the value of the Journal Batch Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ToolTip = 'Specifies the value of the Reason Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ToolTip = 'Specifies the value of the Bal. Account Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ToolTip = 'Specifies the value of the Bal. Account No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    ToolTip = 'Specifies the value of the Transaction No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Closed by Amount (LCY)"; Rec."Closed by Amount (LCY)")
                {
                    ToolTip = 'Specifies the value of the Closed by Amount (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ToolTip = 'Specifies the value of the Debit Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ToolTip = 'Specifies the value of the Credit Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debit Amount (LCY)"; Rec."Debit Amount (LCY)")
                {
                    ToolTip = 'Specifies the value of the Debit Amount (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Credit Amount (LCY)"; Rec."Credit Amount (LCY)")
                {
                    ToolTip = 'Specifies the value of the Credit Amount (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ToolTip = 'Specifies the value of the External Document No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Calculate Interest"; Rec."Calculate Interest")
                {
                    ToolTip = 'Specifies the value of the Calculate Interest field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Closing Interest Calculated"; Rec."Closing Interest Calculated")
                {
                    ToolTip = 'Specifies the value of the Closing Interest Calculated field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ToolTip = 'Specifies the value of the No. Series field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Closed by Currency Code"; Rec."Closed by Currency Code")
                {
                    ToolTip = 'Specifies the value of the Closed by Currency Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Closed by Currency Amount"; Rec."Closed by Currency Amount")
                {
                    ToolTip = 'Specifies the value of the Closed by Currency Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Adjusted Currency Factor"; Rec."Adjusted Currency Factor")
                {
                    ToolTip = 'Specifies the value of the Adjusted Currency Factor field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Original Currency Factor"; Rec."Original Currency Factor")
                {
                    ToolTip = 'Specifies the value of the Original Currency Factor field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Original Amount"; Rec."Original Amount")
                {
                    ToolTip = 'Specifies the value of the Original Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Remaining Pmt. Disc. Possible"; Rec."Remaining Pmt. Disc. Possible")
                {
                    ToolTip = 'Specifies the value of the Remaining Pmt. Disc. Possible field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Pmt. Disc. Tolerance Date"; Rec."Pmt. Disc. Tolerance Date")
                {
                    ToolTip = 'Specifies the value of the Pmt. Disc. Tolerance Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Max. Payment Tolerance"; Rec."Max. Payment Tolerance")
                {
                    ToolTip = 'Specifies the value of the Max. Payment Tolerance field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Last Issued Reminder Level"; Rec."Last Issued Reminder Level")
                {
                    ToolTip = 'Specifies the value of the Last Issued Reminder Level field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Accepted Payment Tolerance"; Rec."Accepted Payment Tolerance")
                {
                    ToolTip = 'Specifies the value of the Accepted Payment Tolerance field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Accepted Pmt. Disc. Tolerance"; Rec."Accepted Pmt. Disc. Tolerance")
                {
                    ToolTip = 'Specifies the value of the Accepted Pmt. Disc. Tolerance field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Pmt. Tolerance (LCY)"; Rec."Pmt. Tolerance (LCY)")
                {
                    ToolTip = 'Specifies the value of the Pmt. Tolerance (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Amount to Apply"; Rec."Amount to Apply")
                {
                    ToolTip = 'Specifies the value of the Amount to Apply field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("IC Partner Code"; Rec."IC Partner Code")
                {
                    ToolTip = 'Specifies the value of the IC Partner Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Applying Entry"; Rec."Applying Entry")
                {
                    ToolTip = 'Specifies the value of the Applying Entry field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Reversed; Rec.Reversed)
                {
                    ToolTip = 'Specifies the value of the Reversed field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Reversed by Entry No."; Rec."Reversed by Entry No.")
                {
                    ToolTip = 'Specifies the value of the Reversed by Entry No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Reversed Entry No."; Rec."Reversed Entry No.")
                {
                    ToolTip = 'Specifies the value of the Reversed Entry No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Prepayment; Rec.Prepayment)
                {
                    ToolTip = 'Specifies the value of the Prepayment field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Payment Reference"; Rec."Payment Reference")
                {
                    ToolTip = 'Specifies the value of the Payment Reference field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ToolTip = 'Specifies the value of the Payment Method Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Applies-to Ext. Doc. No."; Rec."Applies-to Ext. Doc. No.")
                {
                    ToolTip = 'Specifies the value of the Applies-to Ext. Doc. No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Recipient Bank Account"; Rec."Recipient Bank Account")
                {
                    ToolTip = 'Specifies the value of the Recipient Bank Account field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Message to Recipient"; Rec."Message to Recipient")
                {
                    ToolTip = 'Specifies the value of the Message to Recipient field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Exported to Payment File"; Rec."Exported to Payment File")
                {
                    ToolTip = 'Specifies the value of the Exported to Payment File field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ToolTip = 'Specifies the value of the Dimension Set ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 5 Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 6 Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 7 Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 8 Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Direct Debit Mandate ID"; Rec."Direct Debit Mandate ID")
                {
                    ToolTip = 'Specifies the value of the Direct Debit Mandate ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Dispute Status"; Rec."Dispute Status")
                {
                    ToolTip = 'Specifies the value of the Dispute Status field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Promised Pay Date"; Rec."Promised Pay Date")
                {
                    ToolTip = 'Specifies the value of the Promised Pay Date field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(navigation)
        {
            action(AppliedEntries)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Applied E&ntries';
                Image = Approve;
                RunObject = Page "GB Applied Customer Entries";
                RunPageOnRec = true;
                Scope = Repeater;
                ToolTip = 'View the ledger entries that have been applied to this record.';
            }
        }
    }
}
