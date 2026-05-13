table 50186 "IMOS Json"
{
    Caption = 'IMOS Json';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; JSONFile; Blob)
        {
            Caption = 'JSONFile';
            Subtype = Json;
        }
        field(3; data; Text[2000])
        {
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
