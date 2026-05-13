table 50224 "Port Payable Staging"
{
    Caption = 'Port Payable Staging';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
        }
        field(3; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(4; "BC Bank Code"; Code[20])
        {
            Caption = 'BC Bank Code';
        }
        field(5; "IMOS Bank ID"; Text[20])
        {
            Caption = 'IMOS Bank ID';
        }
        field(6; "Line No"; Text[100])
        {
            Caption = 'Line No';
        }
        field(7; "Account Type";Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
        }
        field(8; "Account No."; Code[20])
        {
            Caption = 'Account No.';
        }
        field(9; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(10; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(11; "Document Type";Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
        }
        field(12; "Bank Document No."; Code[20])
        {
            Caption = 'Bank Document No.';
        }
        field(13; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(14; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(15; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(16; "Amount (Lcy)"; Decimal)
        {
            Caption = 'Amount (Lcy)';
        }
        field(17; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
        }
        field(18; "Applies-to Doc. Type";Enum "Gen. Journal Document Type")
        {
            Caption = 'Applies-to Doc. Type';
        }
        field(19; "IMOS Transaction No"; Code[20])
        {
            Caption = 'IMOS Transaction No';
        }
        field(20; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';
        }
        field(21; "External Document No."; Text[35])
        {
            Caption = 'External Document No.';
        }
        field(22; "Company Code"; Code[50])
        {
            Caption = 'Company Code';
        }
        field(23; FD1_Subsegment; Code[20])
        {
            Caption = 'FD1_Subsegment';
        }
        field(24; FD2_VesselName; Code[20])
        {
            Caption = 'FD2_VesselName';
        }
        field(25; FD3_VoyageNumber; Code[20])
        {
            Caption = 'FD3_VoyageNumber';
        }
        field(26; FD4_CharterIn; Code[20])
        {
            Caption = 'FD4_CharterIn';
        }
        field(27; FD5_Department; Code[20])
        {
            Caption = 'FD5_Department';
        }
        field(28; FD6_Employee; Code[20])
        {
            Caption = 'FD6_Employee';
        }
        field(29; FD7_Location; Code[20])
        {
            Caption = 'FD7_Location';
        }
        field(30; FD8_Company; Code[20])
        {
            Caption = 'FD8_Company';
        }
        field(31; FD9_CounterParty; Code[20])
        {
            Caption = 'FD9_CounterParty';
        }
        field(32; FD10_JType; Code[20])
        {
            Caption = 'FD10_JType';
        }
        field(33; "DNV Ship Manager ID"; Text[250])
        {
            Caption = 'DNV Ship Manager ID';
        }
        field(34; "File Name"; Text[500])
        {
            Caption = 'File Name';
        }
        field(35; "Imported By"; Code[50])
        {
            Caption = 'Imported By';
        }
        field(36; "Import Date n Time"; DateTime)
        {
            Caption = 'Import Date n Time';
        }
        field(37; Status;Enum EnumStatus)
        {
            Caption = 'Status';
        }
        field(38; "Posted Document No."; Code[20])
        {
            Caption = 'Posted Document No.';
        }
        field(39; "CP Entry No"; Integer)
        {
            Caption = 'CP Entry No.';
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
