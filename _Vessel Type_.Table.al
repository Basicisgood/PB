table 50110 "Vessel Type"
{
    Caption = 'Vessel Type';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Vessel Type"; Text[30])
        {
            Caption = 'Vessel Type';
        }
        field(2; Description; Text[60])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; "Vessel Type")
        {
            Clustered = true;
        }
    }
}
