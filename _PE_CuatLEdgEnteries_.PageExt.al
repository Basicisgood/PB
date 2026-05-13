pageextension 50150 "PE_CuatLEdgEnteries" extends "Customer Ledger Entries"
{
    layout
    {
        addbefore("Sales (LCY)")
        {
            field("Over Receipt Amount"; Rec."Over Receipt Amount")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("IMOS Transaction No"; Rec."IMOS Transaction No")
            {
                ApplicationArea = all;
            }
            field("Bank Charges Amount"; Rec."Bank Charges Amount")
            {
                ApplicationArea = all;
            }
        }
        addafter("Shortcut Dimension 8 Code")
        {
            field("Shortcut Dimension 8 Code_PB"; Rec."Shortcut Dimension 8 Code_PB")
            {
                ApplicationArea = all;
            }
            field("Shortcut Dimension 9 Code_PB"; Rec."Shortcut Dimension 9 Code_PB")
            {
                ApplicationArea = all;
            }
            field("Shortcut Dimension 10 Code_PB"; Rec."Shortcut Dimension 10 Code_PB")
            {
                ApplicationArea = all;
            }
        }
    }
}
