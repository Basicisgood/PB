table 50195 "Vessel Export Inbound"
{
    Caption = 'Vessel Export Inbound';
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
        }
        field(6; "Synch"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
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
