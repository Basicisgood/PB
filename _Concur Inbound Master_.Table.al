table 50173 "Concur Inbound Master"
{
    Caption = 'Concur Inbound Master';
    DataClassification = ToBeClassified;
    DataPerCompany = false;
    LookupPageId = "Concur inbound Master";

    fields
    {
        field(2; "Entry No."; Integer)
        {
        //not using this field
        }
        field(4; "Report ID"; Text[100])
        {
        }
        field(6; "External Doc No."; Text[100])
        {
        }
        field(10; "Emp Id"; Code[20])
        {
        }
        field(11; "Payment Date"; Date)
        {
        }
        field(12; "Fin Company Code"; Text[50])
        {
        }
        field(13; "Ship Company Code"; Text[50])
        {
        }
        field(14; "Create DateTime"; DateTime)
        {
            Editable = false;
        }
        field(15; "Report Currency"; Code[10])
        {
        }
        field(16; "Cash Ledger"; Boolean)
        {
        }
        field(17; "Posted Doc No. Fin Company"; code[20])
        {
            Caption = 'UnPosted Doc No. Fin Company';
        // Editable = false;
        }
        field(18; "Posted Doc No. Ship Company"; code[20])
        {
            Caption = 'UnPosted Doc No. Ship Company';
        //Editable = false;
        }
        field(21; "Fin Company Posted Doc No."; code[20])
        {
            Editable = false;
        }
        field(22; "Ship Company Posted Doc No."; code[20])
        {
            Editable = false;
        }
        field(25; "Fin Status"; Text[100])
        {
        }
        field(27; "Ship Status"; Text[100])
        {
        }
        field(30; "Error Description"; Text[1000])
        {
            Caption = 'Error Description';
        //Editable = false;
        }
        field(31; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Pending, Error, Cancel, Processed, "Finance Company Processed", "Vessel Company Processed";
        }
    }
    keys
    {
        key(PK; "Report ID", "External Doc No.", "Ship Company Code")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        "Create DateTime":=CurrentDateTime;
    end;
}
