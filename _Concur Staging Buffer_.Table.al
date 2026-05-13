table 50310 "Concur Staging Buffer"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(2; "Company Code"; Text[50])
        {
        }
        field(4; "Report ID"; Text[100])
        {
        }
        field(5; "External Doc No."; Text[100])
        {
        }
        field(6; "Payment Type"; Text[100])
        {
        }
        field(7; "Tax Code"; Code[10])
        {
        }
        field(8; "Tax Amount"; Decimal)
        {
        }
        field(9; "Emp Code"; Code[20])
        {
        }
        field(10; "Emp Amount"; Decimal)
        {
        }
        field(12; "Concur ID"; text[100])
        {
        }
        field(16; "Cash Ledger"; Boolean)
        {
        }
        field(20; "Payment Date"; Date)
        {
        }
        field(25; "Report Currency"; Code[10])
        {
        }
        field(30; "Is Ship Run"; Boolean)
        {
        }
        field(35; "Fin Company Code"; Text[50])
        {
        }
        field(36; "Ship Company Code"; Text[50])
        {
        }
    }
    keys
    {
        key(Key1; "Company Code", "Report ID", "External Doc No.", "Payment Type")
        {
            Clustered = true;
        }
    }
}
