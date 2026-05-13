table 50200 "PB Common Setup"
{
    Caption = 'PB Common Setup';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Primary Key"; Text[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Central Payment Template Name"; code[10])
        {
            Caption = 'Central Payment Template Name';
            TableRelation = "Gen. Journal Template";
        }
        field(3; "Central Payment Batch Name"; code[10])
        {
            Caption = 'Central Payment Batch Name';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name"=field("Central Payment Template Name"));
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
