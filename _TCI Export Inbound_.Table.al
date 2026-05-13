table 50194 "TCI Export Inbound"
{
    Caption = 'TCI Export Inbound';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Datetime"; Text[50])
        {
            Caption = 'Datetime';
        }
        field(3; Data; Blob)
        {
            Caption = 'Data';
        }
        field(4; "Vessel Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Vessel Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Synched"; Boolean)
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
