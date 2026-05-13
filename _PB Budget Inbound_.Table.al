table 50133 "PB Budget Inbound"
{
    Caption = 'Budget Inbound';
    DataClassification = ToBeClassified;

    fields
    {
        field(2; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(5; "No."; Text[10])
        {
        }
        field(8; "Currency Code"; Code[10])
        {
        }
        field(10; "Posting Date"; Date)
        {
        }
        field(12; "Amount"; Decimal)
        {
        }
        field(14; "Dimension"; Code[20])
        {
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
