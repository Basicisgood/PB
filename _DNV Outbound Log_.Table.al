table 50108 "DNV Outbound Log"
{
    Caption = 'DNV Outbound Log';
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
        field(8; "Primary key"; Text[20])
        {
        }
        field(9; "Primary key 2"; text[20]) //DNV Integration
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
        field(30; "Error Reason"; Text[1000])
        {
        }
        field(31; "Company Name"; Text[30])
        {
            TableRelation = Company;
        }
        field(32; "DNV Invoice Entry No."; Integer)
        {
            Caption = 'DNV Invoice Entry No.';
        }
        field(33; "Ship Manager ID"; Text[255])
        {
            Caption = 'Ship Manager ID';
        }
        field(34; "External Document No."; Text[35])
        {
            Caption = 'External Document No.';
        }
        field(35; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
        }
        field(36; "Payment Document No."; Code[20])
        {
            Caption = 'Payment Document No.';
        }
        field(37; "Payment Date"; Date)
        {
            Caption = 'Payment Date';
        }
        field(38; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(39; "Bank Document No."; Code[20])
        {
            Caption = 'Bank Document No.';
        }
        field(40; Response; Text[1000])
        {
            Caption = 'Response';
        }
        field(41; "Invoice Posting Date"; Date)
        {
            Caption = 'Invoice Posting Date';
        }
        field(42; "Request Data"; Text[1000])
        {
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Table No.", "Primary key", Status)
        {
        }
    }
}
