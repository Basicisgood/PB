table 50217 "HSBC API Inbound Error Log"
{
    Caption = 'HSBC API Inbound Error Log';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Bank Account No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Statement Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Error Msg"; Text[300])
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
    }
}
