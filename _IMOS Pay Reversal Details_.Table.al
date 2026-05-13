table 50220 "IMOS Pay Reversal Details"
{
    Caption = 'IMOS Pay Reversal Details';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; "Type"; Code[20])
        {
            Caption = 'Type';
        }
        field(4; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(5; "Vessal Code"; Code[100])
        {
            Caption = 'Vessal Code';
        }
        field(6; "Currency code"; Code[10])
        {
            Editable = false;
        }
        field(7; "Amount LCY"; Decimal)
        {
            Editable = false;
        }
        field(8; "COA No"; Code[20])
        {
            Editable = false;
        }
        field(9; "Account Type"; Option)
        {
            OptionMembers = Customer, Vendor;
        }
        field(10; "Exchange Rate"; Decimal)
        {
            DecimalPlaces = 2: 15;
        }
    }
    keys
    {
        key(PK; "Entry No.", "No.", "Type", "Vessal Code", "Currency code", "COA No")
        {
            Clustered = true;
        }
    }
}
