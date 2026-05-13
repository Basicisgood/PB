table 50139 "HSBC Batch Setup"
{
    Caption = 'HSBC Batch Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Batch Type";Enum "Batch Type")
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Batch No."; Text[35])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "HSBC No. of Records"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("HSBC Outbound Staging Table" where("Batch Type"=field("Batch Type"), "Batch Id"=field("Batch No.")));
        }
        field(10; "CITI No. of Records"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("CITI Outbound Staging Table" where("Batch Type"=field("Batch Type"), "Batch Id"=field("Batch No.")));
        }
        field(4; Processed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Value Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Bank Log Entry No."; Integer) //TEC#001
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Bank Integration Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ", HSBC, BOC, Citi, "Non API";
        }
        field(8; "Country/Region Code"; Code[20]) //TEC#001
        {
            TableRelation = "Country/Region";
            DataClassification = ToBeClassified;
        }
        field(9; "Bal. Account No."; Code[20]) //TEC#001
        {
            TableRelation = "Bank Account";
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Batch Type", "Batch No.")
        {
            Clustered = true;
        }
        key(PK2; "Batch Type", "Value Date", "Batch No.")
        {
        }
    }
}
