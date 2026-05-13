table 50167 "Citi Inbound Statement Id"
{
    Caption = 'Citi Inbound Statement Id';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Statement Id"; Code[30])
        {
            Caption = 'Statement Id';
        }
        field(2; "Format Name"; Code[30])
        {
            Caption = 'Format Name';
        }
        field(3; Retrieved; Boolean)
        {
            Caption = 'Retrieved';
        }
        field(4; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Success, Error;
            InitValue = Success;
        }
        field(5; "Error Msg"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Bank Account No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Statement Date From"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Statement Id")
        {
            Clustered = true;
        }
    }
}
