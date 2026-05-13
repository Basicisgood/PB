table 50121 "IMOS API Log"
{
    Caption = 'IMOS API Log';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(2; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(5; "Table No."; Integer)
        {
        }
        field(8; "Primary key";Enum "Company Type")
        {
        }
        field(9; "Primary key 2"; text[20]) //IMOS Integration
        {
        }
        field(10; "Primary key 3"; text[20]) //IMOS Integration
        {
        }
        field(11; "Primary key 4"; text[20]) //IMOS Integration
        {
        }
        field(12; "Entry Type"; Option)
        {
            OptionMembers = "Insert", "Update";
        }
        field(20; "Sent Date Time"; DateTime)
        {
        }
        field(25; "Status"; Option)
        {
            OptionMembers = "Pending", "Success", "Error";
        }
        field(26; "XML Data"; Text[2048])
        {
            Editable = false;
        }
        field(30; "Response"; Text[1000])
        {
        }
        field(40; "Company Code"; Text[50])
        {
        }
        field(45; "Payment Amount"; Decimal)
        {
        //Editable = false;
        }
        field(46; "Payment Amount LCY"; Decimal)
        {
            Caption = 'Payment Amount LCY';
        }
        field(47; "Currency Factor"; Decimal)
        {
            DecimalPlaces = 2: 15;
        }
        field(48; "Bank Document No."; Code[20])
        {
            Caption = 'Bank Document No';
        }
        field(50; "Over Receipt Amount"; Decimal)
        {
        //Editable = false;
        }
        field(55; "Bank Charge Amount"; Decimal)
        {
        // Editable = false;
        }
        field(60; "Bank ID"; Text[30])
        {
        //Editable = false;
        }
        field(65; "Invoice List"; Boolean)
        {
            Editable = false;
        }
        field(70; "Push to IMOS"; Boolean)
        {
            Caption = 'Push to IMOS';
        }
        field(72; "IMOS Transaction No"; Code[20])
        {
            Caption = 'IMOS Transaction No';
        }
        field(73; "Document No Suffix"; Code[5])
        {
            Caption = 'Document No Suffix';
        }
        field(74; "Currency Exch Start Date"; Date)
        {
            Caption = 'Currency Exch Start Date';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Table No.", "Primary key", "Primary key 2", "Primary key 3", "Primary key 4", Status)
        {
        }
    }
}
