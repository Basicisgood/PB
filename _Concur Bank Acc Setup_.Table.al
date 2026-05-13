table 50190 "Concur Bank Acc Setup"
{
    Caption = 'Concur Bank Account Setup';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(2; "BC Company"; Text[30])
        {
            TableRelation = Company;
        }
        field(5; "Bank Account"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(8; "Report Name"; Text[250])
        {
        }
        field(10; "Currency Code"; Code[10])
        {
            TableRelation = Currency;
        }
        field(15; "Bank Account Name"; Text[50])
        {
        }
        field(18; "Bank Account No."; Code[20])
        {
        }
        field(20; "Cash Advance Bank Account"; Boolean)
        {
        }
        field(22; "Concur LCY Bank"; Boolean)
        {
        }
    }
    keys
    {
        key(PK; "BC Company", "Bank Account")
        {
            Clustered = true;
        }
    }
}
