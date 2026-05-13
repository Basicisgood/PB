table 50127 "Currency Translation"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Consolidate No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Consolidate;
        }
        field(2; "Source Legal Entity"; Text[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Company;
        }
        field(3; "Source Accounting Currency"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
        field(4; "From Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(5; "To Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
    }
    keys
    {
        key(Key1; "Consolidate No.", "Source Legal Entity", "Source Accounting Currency", "From Account", "To Account")
        {
            Clustered = true;
        }
    }
}
