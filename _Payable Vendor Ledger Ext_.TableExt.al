tableextension 50129 "Payable Vendor Ledger Ext" extends "Payable Vendor Ledger Entry"
{
    fields
    {
        field(50100; "Company Code"; Code[20])
        {
            Caption = 'Company Code';
            DataClassification = ToBeClassified;
        }
    }
}
