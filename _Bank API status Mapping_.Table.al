table 50311 "Bank API status Mapping"
{
    Caption = 'Bank Payment Enquiry API status Mapping ';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Bank Code"; Code[10])
        {
            Caption = 'Bank Code';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "API Status (BC)";Enum "Bank Paym Enquiry API Status")
        {
            Caption = 'API Status (BC)';
        }
        //#219 TEC.VJ 13022025>>
        field(4; "Trigger API"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Bank Code")
        {
            Clustered = true;
        }
    }
}
