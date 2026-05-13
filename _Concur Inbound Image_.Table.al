table 51014 "Concur Inbound Image"
{
    Caption = 'Concur Inbound Image';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry no"; Integer)
        {
            Caption = 'Entry no';
            AutoIncrement = true;
        }
        field(2; "Image ID"; Text[100])
        {
            Caption = 'Image ID';
        }
        field(3; "Image URL "; Text[1024])
        {
            Caption = 'Image URL';
        }
        field(4; "Status "; Option)
        {
            Caption = 'Status';
            OptionMembers = Pending, Success, Fail;
        }
        field(5; "Description (Error message)"; Text[100])
        {
            Caption = 'Description (Error message)';
        }
        field(6; "Creation date/time "; Date)
        {
            Caption = 'Creation date/time';
        }
        field(7; "Processed date/time "; Date)
        {
            Caption = 'Processed date/time';
        }
        field(8; "Process status "; Option)
        {
            Caption = 'Process status';
            OptionMembers = Pending, Success, Fail;
        }
        field(9; "Process error message "; Text[100])
        {
            Caption = 'Process error message';
        }
        field(10; "API Log Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Entry no")
        {
            Clustered = true;
        }
    }
}
