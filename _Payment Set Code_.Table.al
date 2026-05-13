table 50111 "Payment Set Code"
{
    Caption = 'Payment Set Code';
    DataClassification = ToBeClassified;
    LookupPageId = "Payment Set Code";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(3; "Last Used Date"; Date)
        {
            Caption = 'Last Used Date';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
