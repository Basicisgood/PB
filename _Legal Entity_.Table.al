table 50126 "Legal Entity"
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
        field(3; Share; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Acc. Type of Conversion Diff."; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Account Type of Conversion Differences';
            OptionMembers = Balance, "Profit and Loss";
        }
    }
    keys
    {
        key(Key1; "Consolidate No.", "Source Legal Entity")
        {
            Clustered = true;
        }
    }
}
