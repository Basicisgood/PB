table 50156 "HSBC Notification"
{
    Caption = 'HSBC Notification';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; entryNo; Integer)
        {
            Caption = 'entryNo';
            AutoIncrement = true;
        }
        field(2; platformAc; Text[14])
        {
            Caption = 'platformAc';
        }
        field(3; keyName; Text[30])
        {
            Caption = 'keyName';
        }
        field(4; messageId; Text[17])
        {
            Caption = 'messageId';
        }
    }
    keys
    {
        key(PK; entryNo)
        {
            Clustered = true;
        }
    }
}
