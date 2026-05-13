table 50113 VMT
{
    Caption = 'VMT';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; DBASE; Code[10])
        {
            Caption = 'DBASE';
            DataClassification = CustomerContent;
        }
        field(3; DBASENAME; Text[150])
        {
            Caption = 'DBASENAME';
            DataClassification = CustomerContent;
        }
        field(17; DBASEGROUP; Text[150])
        {
            Caption = 'DBASEGROUP';
            DataClassification = CustomerContent;
        }
        field(4; COSTCTR; Code[20])
        {
            Caption = 'COSTCTR';
            DataClassification = CustomerContent;
        }
        field(5; SEGMENT; Code[20])
        {
            Caption = 'SEGMENT';
            DataClassification = CustomerContent;
        }
        field(6; VESSELCODE; Code[20])
        {
            Caption = 'VESSELCODE';
            DataClassification = CustomerContent;
        }
        field(7; VESSEL; Text[150])
        {
            Caption = 'VESSEL';
            DataClassification = CustomerContent;
        }
        field(8; SHIPSIGN; Integer)
        {
            Caption = 'SHIPSIGN';
            DataClassification = CustomerContent;
        }
        field(9; "MFEE FACTOR"; Decimal)
        {
            Caption = 'MFEE FACTOR';
            DataClassification = CustomerContent;
            DecimalPlaces = 2: 10;
        }
        field(10; "MARKUP FACTOR"; Decimal)
        {
            Caption = 'MARKUP FACTOR';
            DecimalPlaces = 2: 10;
            DataClassification = CustomerContent;
        }
        field(11; TAXRATE; Decimal)
        {
            DecimalPlaces = 2: 10;
            Caption = 'TAXRATE';
            DataClassification = CustomerContent;
        }
        field(12; TINTYPE; Text[100])
        {
            Caption = 'TINTYPE';
            DataClassification = CustomerContent;
        }
        field(13; "TAX JURISDICTION"; Text[100])
        {
            Caption = 'TAX JURISDICTION';
            DataClassification = CustomerContent;
        }
        field(14; "INCORP PLACE"; Text[100])
        {
            Caption = 'INCORP PLACE';
            DataClassification = CustomerContent;
        }
        field(15; "DATE OF INCORPORATION"; Date)
        {
            Caption = 'DATE OF INCORPORATION';
            DataClassification = CustomerContent;
        }
        field(16; "DISSOLVED DATE"; Text[100])
        {
            Caption = 'DISSOLVED DATE';
            DataClassification = CustomerContent;
        }
        field(18; "Head Company"; Code[20])
        {
            Caption = 'Head Company';
            DataClassification = CustomerContent;
        }
        field(19; "Use FD1 Mapping"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(20; "DNV Finance Comapny"; Code[50])
        {
            DataClassification = CustomerContent;
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
