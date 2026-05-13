table 50172 "Worldlink Spot Rate"
{
    Caption = 'Worldlink Guarantee Rate';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(2; "From Currency"; Text[3])
        {
            Caption = 'From Currency';
        }
        field(3; "To Currency"; Text[3])
        {
            Caption = 'To Currency';
        }
        field(4; Rate; Decimal)
        {
            Caption = 'Rate';
            DecimalPlaces = 1: 6;
            MinValue = 0;
        }
    }
    keys
    {
        key(PK; "Date", "From Currency", "To Currency")
        {
            Clustered = true;
        }
    }
}
