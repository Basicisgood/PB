table 50165 "PB DNV Committed Cost Line"
{
    Caption = 'DNV Committed Cost Line';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; ShipID; Text[10])
        {
            Caption = 'ShipID';
        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(3; "Order Item Number"; Text[22])
        {
            Caption = 'Order Item Number';
        }
        field(4; "Item Name"; Text[255])
        {
            Caption = 'Item Name';
        }
        field(5; "Item Number"; Text[255])
        {
            Caption = 'Item Number';
        }
        field(6; "Item Part Number"; Text[100])
        {
            Caption = 'Item Part Number';
        }
        field(7; "Item Drawing Number"; Text[100])
        {
            Caption = 'Item Drawing Number';
        }
        field(8; "Is Critical"; Boolean)
        {
            Caption = 'Is Critical';
        }
        field(9; "Quantity Ordered"; Decimal)
        {
            Caption = 'Quantity Ordered';
        }
        field(10; "Single Price"; Decimal)
        {
            Caption = 'Single Price';
        }
        field(11; "Line Discount Pct"; Decimal)
        {
            Caption = 'Line Discount Pct';
        }
        field(12; "Order Head Discount"; Decimal)
        {
            Caption = 'Order Head Discount';
        }
        field(13; "Unit Of Measure code"; Text[15])
        {
            Caption = 'Unit Of Measure code';
        }
        field(14; "Currency Code"; Text[5])
        {
            Caption = 'Currency Code';
        }
        field(15; "Account code"; Text[15])
        {
            Caption = 'Account code';
        }
        field(16; "Quantity Received Shipped"; Decimal)
        {
            Caption = 'Quantiy Received Shipped';
        }
        field(17; "Quantity Received Warehouse"; Decimal)
        {
            Caption = 'Quantity Received Warehouse';
        }
        field(18; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
        field(19; "Total Line Amount"; Decimal)
        {
            Caption = 'Total Line Amount';
        }
        field(20; "Total Line Net Amount"; Decimal)
        {
            Caption = 'Total Line Net Amount';
        }
        field(21; PBOrderLineid; Guid)
        {
        }
        field(22; "Entry No"; Integer)
        {
        }
    }
    keys
    {
        key(PK; "Entry No", "Line No.")
        {
            Clustered = true;
        }
    }
}
