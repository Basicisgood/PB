table 50171 "Relocate account code mapping"
{
    Caption = 'Relocate account code mapping';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; No; Integer)
        {
            Caption = 'No.';
            AutoIncrement = true;
        }
        field(2; "DNV Code"; Code[20])
        {
            Caption = 'DNV Code';
        }
        field(3; "Balance Account No"; Code[20])
        {
            Caption = 'Bal. account no';
        }
        field(4; "Account Name"; Text[50])
        {
            Caption = 'Account Name';
        }
    }
    keys
    {
        key(PK; No)
        {
            Clustered = true;
        }
    }
}
