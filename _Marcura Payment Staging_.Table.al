table 50226 "Marcura Payment Staging"
{
    Caption = 'Marcura Payment Staging';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; DAID; Integer)
        {
            Caption = 'DAID';
        }
        field(3; "Transaction Id"; Integer)
        {
            Caption = 'Transaction Id';
        }
        field(4; "Reference No."; Text[40])
        {
            Caption = 'Reference No.';
        }
        field(5; "Interface Unique Reference No"; Text[40])
        {
            Caption = 'Interface Unique Reference No';
        }
        field(6; "IMOS Reference No."; Text[40])
        {
            Caption = 'IMOS Reference No.';
        }
        field(7; "IMOS Transaction ID"; Text[20])
        {
            Caption = 'IMOS Transaction ID';
        }
        field(8; "Counter Party Reference No."; Text[30])
        {
            Caption = 'Counter Party Reference No.';
        }
        field(9; "Payment Currency"; Code[10])
        {
            Caption = 'Payment Currency';
        }
        field(10; "Payment Amount"; Decimal)
        {
            Caption = 'Payment Amount';
        }
        field(11; "Debit Currency"; Code[10])
        {
            Caption = 'Debit Currency';
        }
        field(12; "Debit Amount"; Decimal)
        {
            Caption = 'Debit Amount';
        }
        field(13; "Debit Account Name"; Text[100])
        {
            Caption = 'Debit Account Name';
        }
        field(14; "Debit Account Familiar Name"; Text[100])
        {
            Caption = 'Debit Account Familiar Name';
        }
        field(15; "Debit Account IBAN"; Text[30])
        {
            Caption = 'Debit Account IBAN';
        }
        field(16; "Debit Account No."; Text[30])
        {
            Caption = 'Debit Account No.';
        }
        field(17; "Bank Statement Date"; DateTime)
        {
            Caption = 'Bank Statement Date';
        }
        field(18; "Payment Execution Date"; DateTime)
        {
            Caption = 'Payment Execution Date';
        }
        field(19; "Value Date"; DateTime)
        {
            Caption = 'Value Date';
        }
        field(20; "Bank Exchange Rate"; Decimal)
        {
            Caption = 'Bank Exchange Rate';
            DecimalPlaces = 2: 15;
        }
        field(21; "Bank Reference"; Text[40])
        {
            Caption = 'Bank Reference';
        }
        field(22; "Payment Type ID"; Integer)
        {
            Caption = 'Payment Type ID';
        }
        field(23; "Payment Type Description"; Text[100])
        {
            Caption = 'Payment Type Description';
        }
        field(24; "Vendor Bank Country Code"; Code[10])
        {
            Caption = 'Vendor Bank Country Code';
            Editable = false;
        }
        field(100; "Status";Enum EnumStatus)
        {
            Editable = false;
        }
        field(101; "Cancelled By"; Code[50])
        {
            Editable = false;
        }
        field(102; "Cancelled Datetime"; DateTime)
        {
            Editable = false;
        }
        field(103; "Error Description"; text[500])
        {
            Editable = false;
        }
        field(104; "BC Company Code"; code[50])
        {
            Editable = false;
        }
        field(105; "Posted Document No"; code[20])
        {
            Editable = false;
        }
        field(106; "BC  Bank Code"; code[20])
        {
            Editable = false;
        }
        field(107; "Central Payment Entry No."; Integer)
        {
            Editable = false;
        }
        field(108; "Target Company Code"; code[50])
        {
            Editable = false;
        }
        field(109; "Customer/Vendor No"; code[20])
        {
            Editable = false;
        }
        field(110; "Vendor Type"; code[20])
        {
            Editable = false;
        }
        Field(111; "Posting Date"; date)
        {
            Editable = false;
        }
        field(112; "Account Type"; Option)
        {
            OptionMembers = Customer, Vendor;
            Caption = 'Account Type';
            Editable = false;
        }
        Field(113; "BC Document No"; code[20])
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
    }
}
