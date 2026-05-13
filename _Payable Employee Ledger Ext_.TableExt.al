tableextension 50141 "Payable Employee Ledger Ext" extends "Payable Employee Ledger Entry"
{
    fields
    {
        field(50100; "Company Code"; Code[30])
        {
            Caption = 'Company Code';
            DataClassification = ToBeClassified;
        }
    }
}
