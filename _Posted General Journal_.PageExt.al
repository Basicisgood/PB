pageextension 50111 "Posted General Journal" extends "Posted General Journal"
{
    layout
    {
        addafter("Amount (LCY)")
        {
            field("Currency Factor"; Rec."Currency Factor")
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
        addafter("Document No.")
        {
            field("Bank Document No."; Rec."Bank Document No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bank Document No. field.', Comment = '%';
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
        addafter("Amount (LCY)")
        {
            field("Applied Amount"; Rec."Applied Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Applied Amount field.', Comment = '%';
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
            field("Over Receipt"; Rec."Over Receipt")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Over Receipt field.', Comment = '%';
            }
            field("Exchange Rate"; Rec."Exchange Rate")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Exchange Rate field.', Comment = '%';
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
            field("PB Concur invoice"; Rec."PB Concur invoice")
            {
                ApplicationArea = all;
            }
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
        addafter("Account No.")
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
            field("Purpose Code Preflix"; Rec."Purpose Code Preflix")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Purpose Code Preflix field.', Comment = '%';
            }
            field("Payment Set Code"; Rec."Payment Set Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Payment Set Code field.', Comment = '%';
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
        }
        addafter("Account No.")
        {
            field("API Bank Account Indicator"; Rec."API Bank Account Indicator")
            {
                ApplicationArea = ALL;
            }
        }
    }
}
