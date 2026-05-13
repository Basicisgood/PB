table 50198 "PB Central Payment History"
{
    Caption = 'PB Central Payment History';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(3; "Source Company"; Text[50])
        {
            Caption = 'Source Company';
        }
        field(4; "Source Document No"; Code[20])
        {
            Caption = 'Source Document No';
        }
        field(5; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(6; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(7; "Target Company"; Text[50])
        {
            Caption = 'Target Company';
        }
        field(8; "Applied Document No."; Code[20])
        {
            Caption = 'Applied Document No.';
        }
        field(9; Status;Enum Enum_CPStatus)
        {
            Caption = 'Status';
        }
        field(10; "Error Description"; Text[250])
        {
            Caption = 'Error Description';
        }
        field(2; "Creation DatenTime"; DateTime)
        {
            Caption = 'Creation DatenTime';
        }
        field(11; "Processed DatenTime"; DateTime)
        {
            Caption = 'Processed DatenTime';
        }
        field(12; "Source Processed Document No."; Code[20])
        {
            Caption = 'Source Processed Document No.';
        }
        field(13; "Target Processed Document No."; Code[20])
        {
            Caption = 'Target Processed Document No.';
        }
        field(14; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(15; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(16; "Entry Type"; Option)
        {
            OptionMembers = "Vendor", "Employee", "Customer";
        }
        field(18; "Bank ID"; Code[20])
        {
        //Editable = false;
        }
        field(20; "IMOS Transaction No"; Code[20])
        {
        //Editable = false;
        }
        field(22; "Posted in Target Company"; Boolean)
        {
        //Editable = false;
        }
        field(24; "Posted in Source Company"; Boolean)
        {
        //Editable = false;
        }
        field(26; "Source Gl Entry Document No"; Code[20])
        {
        //   Editable = false;
        }
        field(28; "Gen Jnl Line GUIID"; Text[100])
        {
            Editable = false;
        }
        field(30; "Exchange Rate"; Decimal)
        {
            //   Editable = false;
            DecimalPlaces = 2: 15;
        }
        field(32; "Bank Document No."; Code[20])
        {
        // Editable = false;
        }
        field(34; "Invoice External No."; Text[35])
        {
        // Editable = false;
        }
        field(36; "Over Receipt Amount"; Decimal)
        {
        }
        field(38; "Bank Charges"; Decimal)
        {
        }
        field(40; "FD10"; Code[20])
        {
        }
        field(42; "FD3"; Code[20])
        {
        }
        field(44; "FD4"; Code[20])
        {
        }
        field(46; "FD5"; Code[20])
        {
        }
        field(47; "FD1"; Code[20])
        {
        }
        field(48; "Document Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("PB Central Payment History".Amount where("Source Gl Entry Document No"=field("Source Gl Entry Document No"), "Target Company"=field("Target Company")));
            Editable = false;
        }
        field(50; "Document Over Receipt Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("PB Central Payment History"."Over Receipt Amount" where("Source Gl Entry Document No"=field("Source Gl Entry Document No"), "Target Company"=field("Target Company")));
            Editable = false;
        }
        field(52; "Document Bank Charges Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("PB Central Payment History"."Bank Charges" where("Source Gl Entry Document No"=field("Source Gl Entry Document No"), "Target Company"=field("Target Company")));
            Editable = false;
        }
        field(54; "Document Date"; Date)
        {
        }
        field(56; "Parent Entry No."; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = min("PB Central Payment History"."Entry No." where("Source Gl Entry Document No"=field("Source Gl Entry Document No"), "Target Company"=field("Target Company")));
            Editable = false;
        }
        field(58; "Source Entry Closed"; Boolean)
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
