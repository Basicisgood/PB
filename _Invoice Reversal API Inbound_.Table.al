table 50197 "Invoice Reversal API Inbound"
{
    Caption = 'Invoice Reversal API Inbound';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Datetime "; Text[50])
        {
            Caption = 'Datetime ';
        }
        field(3; Data; Blob)
        {
            Caption = 'Data';
        }
        field(4; Filename; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transaction No';
        }
        field(5; Status;Enum EnumStatus)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Cancelled By User"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "Cancelled Datentime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Staging Entry No"; Integer)
        {
            Editable = false;
        }
        field(9; "Error Description"; Text[500])
        {
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
