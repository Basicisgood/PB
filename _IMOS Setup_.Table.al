table 50119 "IMOS Setup"
{
    Caption = 'IMOS Setup';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "Token URL"; Text[2048])
        {
            Caption = 'Token URL';
        }
        field(3; "API Token"; Text[2048])
        {
            Caption = 'API Token';
        }
        field(4; "Is Enable"; Boolean)
        {
        }
        field(5; "Vendor Type Dimension"; code[20])
        {
            TableRelation = Dimension;
            DataClassification = ToBeClassified;
            Caption = 'Vendor/Counter Party Dimension';
        }
        field(6; "FD4 Default VAlue"; code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(4));
            DataClassification = ToBeClassified;
            Caption = 'FD4 Default Value';
        }
        field(9; "FD9 Default Value"; code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(9));
            DataClassification = ToBeClassified;
        }
        field(10; "Bank Charge GL Code"; code[20])
        {
            TableRelation = "G/L Account"."No." where("Direct Posting"=const(true));
            DataClassification = ToBeClassified;
        }
        field(11; "Default Cash Receipt Batch"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template".Name;
        }
        field(12; "Default Payment Reversal Batch"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template".Name;
            Caption = 'Payment Reversal Template';
        }
        field(13; "Push IMOS Transaction"; Boolean)
        {
            Caption = 'Push Selected AR/AP to IMOS';
        }
        field(14; "Exch Gain/Loss Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(15; "Payment Reversal Batch"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name"=field("Default Payment Reversal Batch"));
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
