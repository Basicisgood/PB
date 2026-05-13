table 50112 "DNV Mapping"
{
    Caption = 'DNV Company Mapping ';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Dimension code"; Code[20])
        {
            Caption = 'Dimension code';
            DataClassification = CustomerContent;
        }
        field(2; "Dimension name"; Text[150])
        {
            Caption = 'Dimension name';
            DataClassification = CustomerContent;
        }
        field(3; "Is Cadet"; Boolean)
        {
            Caption = 'Is Cadet';
            DataClassification = CustomerContent;
        }
        field(4; Company; Code[20])
        {
            Caption = 'Company';
            DataClassification = CustomerContent;
        }
        field(5; "Wage Accounting Area Code"; Code[20])
        {
            Caption = 'Wage Accounting Area Code';
            DataClassification = CustomerContent;
        }
        field(6; "Main account"; Code[20])
        {
            Caption = 'Main account';
            DataClassification = CustomerContent;
        }
        field(7; "Main account Name"; Text[150])
        {
            Caption = 'Main account Name';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Dimension code", Company, "Is Cadet", "Wage Accounting Area Code")
        {
            Clustered = true;
        }
    }
}
