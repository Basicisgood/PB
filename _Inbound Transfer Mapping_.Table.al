table 50142 "Inbound Transfer Mapping"
{
    Caption = 'Inbound Transfer Mapping';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[70])
        {
            Caption = 'Description';
        }
        field(3; "Account Type";Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
        }
        field(4; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = if("Account Type"=const("G/L Account"))"G/L Account" where("Account Type"=const(Posting), Blocked=const(false))
            else if("Account Type"=const(Customer))Customer
            else if("Account Type"=const(Vendor))Vendor
            else if("Account Type"=const("Bank Account"))"Bank Account"
            else if("Account Type"=const("Fixed Asset"))"Fixed Asset"
            else if("Account Type"=const("IC Partner"))"IC Partner"
            else if("Account Type"=const("Allocation Account"))"Allocation Account"
            else if("Account Type"=const(Employee))Employee;
        }
        field(5; "DBIT / CRDT"; Code[4])
        {
            DataClassification = ToBeClassified;
            Description = 'VJ#189 25Jan2025';
        }
        field(6; "Check Duplicate Include Currency"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(7; PBFundTransfer; Boolean)
        {
            DataClassification = ToBeClassified;
        //#354 VJ 17062025
        }
        field(8; "Mark as Cancel"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Code", "Account Type", "DBIT / CRDT")
        {
            Clustered = true;
        }
    }
}
