table 50191 "Concur VAT Setup"
{
    Caption = 'Concur VAT Setup';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(2; "BC Company"; Text[30])
        {
            TableRelation = Company;
        }
        field(5; "Ledger Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(8; "Tax Code"; Code[10])
        {
        }
    }
    keys
    {
        key(PK; "BC Company", "Ledger Account")
        {
            Clustered = true;
        }
    }
}
