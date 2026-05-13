table 50223 "PB Deployment Details"
{
    Caption = 'PB Deployment Details';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Deployment Date"; Date)
        {
            Caption = 'Deployment Date';
        }
        field(3; "Deployment Time"; Time)
        {
            Caption = 'Deployment Time';
        }
        field(4; "Recipient List"; Text[250])
        {
            Caption = 'Recipient List';
        }
        field(5; "Recipient CC List"; Text[250])
        {
            Caption = 'Recipient CC List';
        }
        field(6; "Start Processed DatenTime"; DateTime)
        {
            Caption = 'Start Processed DatenTime';
        }
        field(7; "End Processed DatenTime"; DateTime)
        {
            Caption = 'End Processed DatenTime';
        }
        field(8; "Deployment Subject"; text[250])
        {
            Caption = 'Deployment Subject';
        }
        field(9; "Deployment Body"; Text[250])
        {
            Caption = 'Deployment Body';
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
