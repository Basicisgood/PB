table 50131 "PB Purchase Invoice Inbound"
{
    Caption = 'Purchase Invoice Inbound';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(2; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(5; "Code"; Text[35])
        {
        }
        field(8; "Booking Date"; Date)
        {
        }
        field(10; "Approved At"; Date)
        {
        }
        field(12; "Approved By"; Text[100])
        {
        }
        field(14; "Currency Code"; Text[5])
        {
        }
        field(16; "Currency Exchange Rate"; Decimal)
        {
        }
        field(18; "Discount %"; Decimal)
        {
        }
        field(20; "Invoice Date"; Date)
        {
        }
        field(22; "Maturity Date"; Date)
        {
        }
        field(24; "Ship Manager"; Text[255])
        {
        }
        field(25; "Invoice-Status";enum "InvoiceStatus Purch Inv")
        {
        }
        field(26; "Vendor No."; Text[20])
        {
        }
        field(28; "Order Code"; Text[25])
        {
        }
        field(29; "Status";Enum DNVEnumInvStatus)
        {
            Caption = 'Status';
        // Editable = false;
        }
        field(30; "Error Description"; Text[250])
        {
            Caption = 'Error Description';
        //Editable = false;
        }
        field(31; "Cancelled by User"; Code[50])
        {
        //Editable = false;
        }
        field(32; "Cancelled Date time"; DateTime)
        {
        //Editable = false;
        }
        field(33; "Purchase Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Posted Document No Fin Company"; code[20])
        {
            caption = 'Posted Document No Fin Company';
        }
        field(36; "Posted Document No Shp Company"; code[20])
        {
            caption = 'Posted Document No Ship Company';
        }
        field(40; "Finance Company No"; text[50])
        {
            caption = 'Finance Company No';
        }
        field(50; "Ship Sign Company No"; text[50])
        {
            caption = 'Ship Sign Company No';
        }
        field(60; "Original Invoice No"; text[50])
        {
            caption = 'Original Invoice No';
        }
        field(70; "Posted in Ship Company"; Boolean)
        {
            caption = 'Posted in Ship Company';
            Editable = true;
        }
        field(75; "Posted in Fin Company"; Boolean)
        {
            caption = 'Posted in Fin Company';
            Editable = true;
        }
        field(77; "Paid"; Boolean)
        {
            caption = 'Paid';
        }
        field(80; "GL Code"; text[15])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("PB Purchase Invoice Line Inb"."Account Code" where("Purch Inv Entry No."=field("Entry No.")));
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(SP; "Ship Manager")
        {
        }
    }
}
