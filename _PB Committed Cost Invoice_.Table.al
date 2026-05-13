table 50164 "PB Committed Cost Invoice"
{
    Caption = 'PB Committed Cost Invoice';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; ShipID; Text[10])
        {
            Caption = 'ShipID';
        }
        field(2; "Invoiced Amount"; Decimal)
        {
            Caption = 'Invoiced Amount';
        }
        field(3; "Invoiced Account code"; Text[20])
        {
            Caption = 'Invoiced Account code';
        }
        field(4; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(5; pBInvoiceByCostCenterID; guid)
        {
        }
        field(6; "Entry No"; Integer)
        {
        }
    }
    keys
    {
        key(PK; "Entry No", "Line No")
        {
            Clustered = true;
        }
    }
}
