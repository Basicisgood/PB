table 50154 "Regional"
{
    Caption = 'Regional';
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
        field(5; proxyId; Text[34])
        {
            Caption = 'proxyId';
            DataClassification = ToBeClassified;
        }
        field(6; txId; Text[35])
        {
            Caption = 'txId';
            DataClassification = ToBeClassified;
        }
        field(7; sendingID; Text[11])
        {
            Caption = 'sendingID';
            DataClassification = ToBeClassified;
        }
        field(8; termID; Text[16])
        {
            Caption = 'termID';
            DataClassification = ToBeClassified;
        }
        field(9; billRef; Text[35])
        {
            Caption = 'billRef';
            DataClassification = ToBeClassified;
        }
        field(10; billRef2; Text[35])
        {
            Caption = 'billRef2';
            DataClassification = ToBeClassified;
        }
        field(11; billRef3; Text[32])
        {
            Caption = 'billRef3';
            DataClassification = ToBeClassified;
        }
        field(12; dupPmt; Text[1])
        {
            Caption = 'dupPmt';
            DataClassification = ToBeClassified;
        }
        field(13; txAmt; Decimal)
        {
            Caption = 'txAmt';
            DataClassification = ToBeClassified;
        }
        field(14; oriTxDate; Date)
        {
            Caption = 'oriTxDate';
            DataClassification = ToBeClassified;
        }
        field(15; payPurpose; Text[6])
        {
            Caption = 'payPurpose';
            DataClassification = ToBeClassified;
        }
        field(16; txTime; DateTime)
        {
            Caption = 'txTime';
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
