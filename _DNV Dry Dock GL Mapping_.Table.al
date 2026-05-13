table 50109 "DNV Dry Dock GL Mapping"
{
    Caption = 'DNV Dry Dock GL Mapping';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "GL Account From"; Code[20])
        {
            Caption = 'GL Account From';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF("GL Account From" <> '') and ("GL Account To" <> '')then begin
                    If "GL Account From" = "GL Account To" then Error(Error001, FieldCaption("GL Account From"), FieldCaption("GL Account To"));
                end;
            end;
        }
        field(5; "GL Account To"; Code[20])
        {
            Caption = 'GL Account To';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF("GL Account From" <> '') and ("GL Account To" <> '')then begin
                    If "GL Account From" = "GL Account To" then Error(Error001, FieldCaption("GL Account From"), FieldCaption("GL Account To"));
                end;
            end;
        }
        field(10; "Allocation %"; Integer)
        {
            Caption = 'Allocation %';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "GL Account From")
        {
            Clustered = true;
        }
    }
    var Error001: Label '%1 can not be same as %2';
}
