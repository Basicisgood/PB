table 50134 "PB Crew Member Inbound"
{
    Caption = 'Crew Member Inbound';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(2; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(5; "No."; Code[50])
        {
        }
        field(8; "Last Name"; Text[255])
        {
        }
        field(10; "First Name"; Text[255])
        {
        }
        field(12; "Middle Name"; Text[255])
        {
        }
        field(14; "Address"; Text[250])
        {
        }
        field(16; "Address 2"; Text[250])
        {
        }
        field(18; "City"; Text[255])
        {
        }
        field(20; "Post Code"; Code[30])
        {
        }
        field(22; "Area"; Text[255])
        {
        }
        field(24; "Country/Region Code"; Code[2])
        {
        }
        field(26; "E-Mail"; Text[255])
        {
        }
        field(28; "Phone No."; Text[50])
        {
        }
        field(33; "Mobile Phone No."; Text[100])
        {
        }
        field(35; "Nationality"; Text[100])
        {
        }
        field(34; "Status"; Option)
        {
            OptionMembers = "Active", "InActive", "Terminated";
        }
        field(36; "Termination Date"; Date)
        {
        }
        field(29; "API Status";Enum EnumStatus)
        {
        // Editable = false;
        }
        field(30; "Error Description"; Text[250])
        {
            Caption = 'Error Description';
            Editable = false;
        }
        field(31; "Cancelled by User"; Code[50])
        {
            Editable = false;
        }
        field(32; "Cancelled Date time"; DateTime)
        {
            Editable = false;
        }
        field(40; "IFSC Code"; Code[20])
        {
            Caption = 'IFSC Code';
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
