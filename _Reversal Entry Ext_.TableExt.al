tableextension 50130 "Reversal Entry Ext" extends "Reversal Entry"
{
    fields
    {
        field(50000; "Original Currency PB"; Code[20])
        {
            Caption = 'Original Currency';
            TableRelation = Currency;
        }
        field(50001; "Original Amount PB"; decimal)
        {
            Caption = 'Original Amount';
        }
    }
}
