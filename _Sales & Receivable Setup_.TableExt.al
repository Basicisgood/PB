tableextension 50127 "Sales & Receivable Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50100; "HSBC Connect CustomerID"; Text[35])
        {
            Caption = 'HSBC Connect CustomerID';
            DataClassification = ToBeClassified;
        }
        field(50101; "Citi Connect CustomerID"; Text[35])
        {
            Caption = 'Citi Connect CustomerID';
            DataClassification = ToBeClassified;
        }
        field(50102; "Word Link"; Text[1024])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = URL;
        }
    }
}
