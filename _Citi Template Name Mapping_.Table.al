table 50201 "Citi Template Name Mapping"
{
    Caption = 'Citi Template Name Mapping';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Account No."; Code[20])
        {
            Caption = 'Account No.';
        }
        field(2; "CAMT52 Template Name"; Text[100])
        {
            Caption = 'CAMT52 Template Name';
        }
        field(3; "CAMT53 Template Name"; Text[100])
        {
            Caption = 'CAMT53 Template Name';
        }
    }
    keys
    {
        key(PK; "Account No.")
        {
            Clustered = true;
        }
    }
}
