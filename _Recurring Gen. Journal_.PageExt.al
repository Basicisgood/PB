pageextension 50114 "Recurring Gen. Journal" extends "Recurring General Journal"
{
    layout
    {
        addafter("Expiration Date")
        {
            field("Bal. Account Type"; Rec."Bal. Account Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the type of account that a balancing entry is posted to, such as BANK for a cash account.';
            }
            field("Bal. Account No."; Rec."Bal. Account No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of the general ledger, customer, vendor, or bank account that the balancing entry is posted to, such as a cash account for cash purchases.';
            }
            field("DNV Staging Entry No."; Rec."DNV Staging Entry No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the DNV Staging Entry No. field.', Comment = '%';
            }
        }
        addafter(ShortcutDimCode8)
        {
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
        }
    }
}
