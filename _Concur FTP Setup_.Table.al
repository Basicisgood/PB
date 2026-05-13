table 50199 "Concur FTP Setup"
{
    Caption = 'Concur FTP Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "FTP host"; Text[100])
        {
            Caption = 'FTP host';
        }
        field(3; Username; Text[50])
        {
            Caption = 'Username';
        }
        field(4; "Private Key"; Blob)
        {
            Caption = 'Private Key';
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
