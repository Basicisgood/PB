table 50118 "Replicate Masters"
{
    Caption = 'Replicate Masters';
    DataClassification = ToBeClassified;

    fields
    {
        field(2; "Table ID"; Integer)
        {
            Caption = 'Table ID';
        }
        field(5; "No."; Code[50])
        {
            Caption = 'No.';
        }
        field(6; "No. 2"; Code[20])
        {
            Caption = 'No. 2';
        }
        field(7; "No. 3"; Code[20])
        {
            Caption = 'No. 3';
        }
        field(10; Company; Text[30])
        {
            Caption = 'Company';
        }
        field(12; "User ID"; Code[50])
        {
            Caption = 'User ID';
        }
        field(15; "Primary Key Field Count"; Integer)
        {
            Caption = 'Primary Key Field Count';
        }
        field(20; "Replicate"; Boolean)
        {
        }
    }
    keys
    {
        key(PK; "Table ID", "No.", "No. 2", "No. 3", Company)
        {
            Clustered = true;
        }
    }
}
