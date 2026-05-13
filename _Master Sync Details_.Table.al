table 50169 "Master Sync Details"
{
    Caption = 'Master Sync Details';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(3; "Sync DateTime"; DateTime)
        {
            Caption = 'Sync DateTime';
        }
        field(4; "User ID"; Text[50])
        {
            Caption = 'User Id';
        }
        field(5; "Company Name"; Text[50])
        {
            Caption = 'Company Name';
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
