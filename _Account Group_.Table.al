table 50213 "Account Group"
{ //PS010
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; Name; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; text[500])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key1; Name)
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
