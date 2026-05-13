table 50211 "Concur inbound Attende Staging"
{
    //VJ 24092025 Incresed field length from 30 to 50 field(27; Title; text[50])
    Caption = 'Concur inbound Attende Staging';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry no."; Integer)
        {
            Caption = 'Entry no.';
            AutoIncrement = true;
        }
        field(2; "Transaction Amount"; Decimal)
        {
            Caption = 'Transaction Amount';
        }
        field(3; "Approved Amount"; Decimal)
        {
            Caption = 'Approved Amount';
        }
        field(4; AssociatedAttendeeCount; Text[50])
        {
            Caption = 'AssociatedAttendeeCount';
        }
        field(5; AttendeeID; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Custom1"; Text[50])
        {
            Caption = 'Custom1';
        }
        field(7; "Custom2"; Text[50])
        {
            Caption = 'Custom2';
        }
        field(8; "Custom3"; Text[50])
        {
            Caption = 'Custom3';
        }
        field(9; "Custom4"; Text[50])
        {
            Caption = 'Custom4';
        }
        field(10; "Custom5"; Text[50])
        {
            Caption = 'Custom5';
        }
        field(11; EntryID; Text[50])
        {
            Caption = 'EntryID';
        }
        field(12; ID; Text[50])
        {
            Caption = 'ID';
        }
        field(13; URI; Text[50])
        {
            Caption = 'URI';
        }
        field(14; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Pending, Success, Fail;
        }
        field(15; "Description (Error message)"; Text[2048])
        {
            Caption = 'Description (Error message)';
        }
        field(16; "Creation date/time"; Date)
        {
            Caption = 'Creation date/time';
        }
        field(17; "Processed date/time"; Date)
        {
            Caption = 'Processed date/time';
        }
        field(18; "Process status"; Option)
        {
            Caption = 'Process status';
            OptionMembers = Pending, Success, Fail;
        }
        field(19; "Process error message"; Text[2048])
        {
            Caption = 'Process error message';
        }
        field(20; "API Log Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        //PS009 Start
        field(21; AttendeeTypeCode; text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(22; FirstName; text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(23; LastName; text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(24; MiddleInitial; text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(25; Suffix; text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(26; Company; text[100]) //VJ increased length from 30 to 50 25mar2025
        {
            DataClassification = ToBeClassified;
        }
        field(27; Title; text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(28; ExternalId; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(29; HasExceptionsPrevYear; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(30; HasExceptionsYtd; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(31; TotalAmountPrevYear; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(32; TotalAmountYtd; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(33; VersionNumber; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(34; OwnerName; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(35; OwnerUserId; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(36; CurrencyCode; code[10])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Entry no.")
        {
            Clustered = true;
        }
    }
}
