table 50129 "Bank API Log"
{
    Caption = 'Bank API Log';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "Request Date Time"; datetime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "API URL"; Text[200])
        {
            Caption = 'API URL';
            Editable = false;
        }
        field(4; "Status Code"; Integer)
        {
            Caption = 'Status Code';
            Editable = false;
        }
        field(5; "Xml String"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Request Json"; Blob)
        {
            Caption = 'Request Json';
        }
        field(7; "Response Json"; Blob)
        {
            Caption = 'Response Json';
        }
        field(8; "Txt Status"; Text[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; "Original End to End Id"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(18; "Bank Integration Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ", HSBC, BOC, Citi, "Non API";
            Editable = false;
        }
        field(19; "Citi Statement Id"; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(20; "Citi Bank Account No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(21; "Citi Status Code"; Code[3])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(22; "HSBC MsgId"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(23; Source; Code[2])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Statement From Date"; Date)
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
        key(S1; "Request Date Time")
        {
        }
    }
    trigger OnInsert()
    begin
        "Request Date Time":=CurrentDateTime;
    end;
}
