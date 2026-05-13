table 50214 "ATX Report Setup"
{ //PS012
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; Header; text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Sub Header"; text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Row Level"; text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Row Label';
        }
        field(4; "Account Group"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Account Group";
        }
    }
    keys
    {
        key(Key1; Header, "Sub Header", "Row Level", "Account Group")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    // Add changes to field groups here
    }
    var myInt: Integer;
    trigger OnInsert()
    begin
    end;
    trigger OnModify()
    begin
    end;
    trigger OnDelete()
    begin
    end;
    trigger OnRename()
    begin
    end;
}
