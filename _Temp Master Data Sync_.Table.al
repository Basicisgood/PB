table 50168 "Temp Master Data Sync"
{
    Caption = 'Temp Master Data Sync';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; No; Code[20])
        {
            Caption = 'No';
        }
        field(2; "Company Code"; Text[50])
        {
            Caption = 'Company Code';
        }
    }
    keys
    {
        key(PK; No, "Company Code")
        {
            Clustered = true;
        }
    }
}
