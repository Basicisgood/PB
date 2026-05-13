table 50185 "IMOS Payment Reversal Line"
{
    Caption = 'IMOS Payment Reversal Line';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Reverse Entry No."; Integer)
        {
            Caption = 'Reverse Entry No.';
        }
        field(2; "Line No"; Integer)
        {
            Caption = 'Line No';
        }
        field(3; "Payment Transaction No"; Code[20])
        {
            Caption = 'Payment Transaction No';
        }
        field(4; "Transaction No"; Code[20])
        {
            Caption = 'Transaction No';
        }
        field(5; "Transaction type"; Integer)
        {
            Caption = 'Transaction type';
        }
        field(6; "Trasaction Sequence"; Text[10])
        {
            Caption = 'Trasaction Sequence';
        }
        field(7; "Company Code"; Code[10])
        {
            Caption = 'Company Code';
        }
        field(8; "Vessel Code"; Text[20])
        {
            Caption = 'Vessel Code';
        }
        field(9; "Vessel Name"; Text[100])
        {
            Caption = 'Vessel Name';
        }
        field(10; "Bank Code"; Code[20])
        {
            Caption = 'Bank Code';
        }
        field(11; Lob; Text[100])
        {
            Caption = 'Lob';
        }
        field(12; Aparcode; Text[100])
        {
            Caption = 'Aparcode';
        }
        field(13; "Entry Datetime"; DateTime)
        {
            Caption = 'Entry Datetime';
        }
        field(14; "Act Date"; Date)
        {
            Caption = 'Act Date';
        }
        field(15; Memo; Text[100])
        {
            Caption = 'Memo';
        }
        field(16; "Currency Amount"; Decimal)
        {
            Caption = 'Currency Amount';
        }
        field(17; Currency; Code[10])
        {
            Caption = 'Currency';
        }
        field(18; "Base Currency Amount"; Decimal)
        {
            Caption = 'Base Currency Amount';
        }
        field(19; "Exchange Rate"; Decimal)
        {
            Caption = 'Exchange Rate';
        }
        field(20; "Last User ID"; Text[100])
        {
            Caption = 'Last User ID';
        }
        field(21; "Opr Type"; Text[10])
        {
            Caption = 'Opr Type';
        }
        field(22; "COA No."; Code[20])
        {
            Caption = 'COA No.';
        }
        field(23; "Port Name"; Text[100])
        {
            Caption = 'Port Name';
        }
        field(24; "Port No"; Integer)
        {
            Caption = 'Port No';
        }
        field(25; "Port UN Code"; Text[100])
        {
            Caption = 'Port UN Code';
        }
        field(26; "Port Country code"; Code[10])
        {
            Caption = 'Port Country code';
        }
        field(27; "Voyage No"; Code[10])
        {
            Caption = 'Voyage No';
        }
        field(28; "Invoice No"; Code[50])
        {
            Caption = 'Invoice No';
        }
        field(29; "Invoice Date"; Date)
        {
            Caption = 'Invoice Date';
        }
        field(30; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(31; "Company External reference No"; Text[20])
        {
            Caption = 'Company External reference No';
        }
        field(32; "Vessel External Reference No"; Text[20])
        {
            Caption = 'Vessel External Reference No';
        }
        field(33; "Vessel Cross Reference No"; Text[20])
        {
            Caption = 'Vessel Cross Reference No';
        }
        field(34; "Voyege Reference"; Text[20])
        {
            Caption = 'Voyege Reference';
        }
        field(35; "Vendor External Reference No"; Code[30])
        {
            Caption = 'Vendor External Reference No';
        }
        field(36; Status;Enum Enum_IMOSRevStatus)
        {
            Caption = 'Status';
        }
        field(37; "Posted Document No."; Code[20])
        {
            Caption = 'Posted Document No.';
        }
    }
    keys
    {
        key(PK; "Reverse Entry No.", "Line No")
        {
            Clustered = true;
        }
    }
}
