table 50212 "Concur Outbound Log"
{ //PS004
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Table No."; Integer)
        {
        }
        field(3; "Table Name"; Text[100])
        {
        }
        field(4; "Primary key"; Text[20])
        {
        }
        field(5; "Entry Type"; Option)
        {
            OptionMembers = "Insert", "Update";
        }
        field(6; "Sent Date Time"; DateTime)
        {
        }
        field(7; "Status"; Option)
        {
            OptionMembers = "Pending", "Success", "Error", "Cancel";
        }
        field(8; "Overall Status"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9; Message; text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Status Code"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Status Message"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Error ID"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Error Message"; text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Path"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Error Timestamp"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Validation Error Message"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Validation Error Source"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Company Name"; Text[30])
        {
            TableRelation = Company;
        }
        field(19; "Primary key 2"; text[20]) //DNV Integration
        {
        }
        //PS005 Start
        field(20; "Status URL"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Privision ID"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Concur ID"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        //PS005 End
        field(23; "Request Body"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Error Reason"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }
}
