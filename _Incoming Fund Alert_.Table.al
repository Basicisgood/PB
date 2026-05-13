table 50149 "Incoming Fund Alert"
{
    Caption = 'Incoming Fund Alert';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; EntryNo; Integer)
        {
            Caption = 'EntryNo';
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(17; platformAc; Text[14])
        {
            Caption = 'platformAc';
            DataClassification = ToBeClassified;
        }
        field(2; keyName; Text[30])
        {
            Caption = 'keyName';
            DataClassification = ToBeClassified;
        }
        field(3; messageId; Text[17])
        {
            Caption = 'messageId';
            DataClassification = ToBeClassified;
        }
        field(4; requestTime; Text[29])
        {
            Caption = 'requestTime';
            DataClassification = ToBeClassified;
        }
        field(5; notificationType; Text[40])
        {
            Caption = 'notificationType';
            DataClassification = ToBeClassified;
        }
        field(6; acctNo; Text[35])
        {
            Caption = 'acctNo';
            DataClassification = ToBeClassified;
        }
        field(7; acctName; Text[140])
        {
            Caption = 'acctName';
            DataClassification = ToBeClassified;
        }
        field(8; acctRegion; Text[18])
        {
            Caption = 'acctRegion';
            DataClassification = ToBeClassified;
        }
        field(9; payerAcctNo; Text[35])
        {
            Caption = 'payerAcctNo';
            DataClassification = ToBeClassified;
        }
        field(10; payerName; Text[600])
        {
            Caption = 'payerName';
            DataClassification = ToBeClassified;
        }
        field(11; txTime; DateTime)
        {
            Caption = 'txTime';
            DataClassification = ToBeClassified;
        }
        field(12; crCur; Text[10])
        {
            Caption = 'crCur';
            DataClassification = ToBeClassified;
        }
        field(13; crAmt; Text[20])
        {
            Caption = 'crAmt';
            DataClassification = ToBeClassified;
        }
        field(14; txType; Text[75])
        {
            Caption = 'txType';
            DataClassification = ToBeClassified;
        }
        field(15; particular; Text[400])
        {
            Caption = 'particular';
            DataClassification = ToBeClassified;
        }
        field(16; messageBase64; Text[2048])
        {
            Caption = 'messageBase64';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; EntryNo)
        {
            Clustered = true;
        }
    }
}
