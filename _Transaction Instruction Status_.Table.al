table 50153 "Transaction Instruction Status"
{
    Caption = 'Transaction Instruction Status';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; EntryNo; Integer)
        {
            Caption = 'EntryNo';
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(18; platformAc; Text[14])
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
        field(6; txType; Text[75])
        {
            Caption = 'txType';
            DataClassification = ToBeClassified;
        }
        field(7; cur; Text[10])
        {
            Caption = 'cur';
            DataClassification = ToBeClassified;
        }
        field(8; amt; Text[20])
        {
            Caption = 'amt';
            DataClassification = ToBeClassified;
        }
        field(9; payerAcctNo; Text[35])
        {
            Caption = 'payerAcctNo';
            DataClassification = ToBeClassified;
        }
        field(10; payerAcctName; Text[140])
        {
            Caption = 'payerAcctNo';
            DataClassification = ToBeClassified;
        }
        field(13; effectiveDate; Text[15])
        {
            Caption = 'effectiveDate';
            DataClassification = ToBeClassified;
        }
        field(14; txStatus; Text[25])
        {
            Caption = 'txStatus';
            DataClassification = ToBeClassified;
        }
        field(15; iGTBRef; Text[11])
        {
            Caption = 'iGTBRef';
            DataClassification = ToBeClassified;
        }
        field(16; custRef; Text[35])
        {
            Caption = 'custRef';
            DataClassification = ToBeClassified;
        }
        field(17; messageBase64; Text[2048])
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
