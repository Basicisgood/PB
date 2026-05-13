table 50192 "IMOS Bank Mapping"
{
    Caption = 'IMOS Bank Mapping';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "IMOS Bank ID"; Text[30])
        {
            Caption = 'IMOS Bank ID';
        }
        field(2; "BC Bank Code"; Text[30])
        {
            Caption = 'BC Bank Code';
        }
        field(3; "Dummy GL Code"; code[20])
        {
            Caption = 'Dummy GL Code';
        }
        field(4; "IC GL Code"; code[20])
        {
        }
        field(5; Description; Text[100])
        {
        }
    }
    keys
    {
        key(PK; "IMOS Bank ID")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "IMOS Bank ID", "BC Bank Code", Description)
        {
        }
    }
}
