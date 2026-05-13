table 50143 "PB Purchase Invoice Line Inb"
{
    Caption = 'Purchase Invoice Line Inbound';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(2; "Purch Inv Entry No."; Integer)
        {
        }
        field(5; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(6; "Header Id"; Guid)
        {
            TableRelation = "PB Purchase Invoice Inbound".SystemId;
        }
        field(30; "Discount"; Decimal)
        {
        }
        field(32; "Account Code"; Text[15])
        {
        }
        field(34; "Ship Code"; Text[10])
        {
        }
        field(36; "Invoiced Quantity"; Decimal)
        {
        }
        field(38; "Order Item Number"; Text[22])
        {
        }
        field(40; "Single Price"; Decimal)
        {
        }
        field(42; "Total Amount"; Decimal)
        {
        }
        field(43; "Total Price"; Decimal)
        {
        }
        field(44; "Tax Amount"; Text[22])
        {
        }
        field(46; "Tax Rate"; Decimal)
        {
        }
    }
    keys
    {
        key(PK; "Purch Inv Entry No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
