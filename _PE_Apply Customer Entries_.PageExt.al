pageextension 50148 "PE_Apply Customer Entries" extends "Apply Customer Entries"
{
    layout
    {
        addbefore("Due Date")
        {
            field("Over Receipt Amount"; Rec."Over Receipt Amount")
            {
                ApplicationArea = all;
                Editable = true;
            }
            field("Bank Charges Amount"; Rec."Bank Charges Amount")
            {
                ApplicationArea = all;
                Editable = true;
            }
            field("IMOS Transaction No"; Rec."IMOS Transaction No")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }
}
