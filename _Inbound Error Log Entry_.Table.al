table 50116 "Inbound Error Log Entry"
{
    Caption = 'Inbound Error Log Entry';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Inbound Entry No."; Integer)
        {
            Caption = 'Inbound Entry No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Error Text"; Text[250])
        {
            Caption = 'Error Text';
            DataClassification = ToBeClassified;
        }
        field(4; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Inbound Table"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Inbound Table", "Inbound Entry No.")
        {
        }
    }
}
