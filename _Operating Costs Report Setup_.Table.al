table 50216 "Operating Costs Report Setup"
{ //PS015
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Table Name"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "RMT List"; text[100])
        {
            DataClassification = ToBeClassified;
        //Caption = 'Row Label';
        }
        field(3; Header; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Sub Header"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Account Group"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Account Group";
        }
        field(7; FD10; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(10), Blocked=const(false));
        }
    }
    keys
    {
        key(Key1; "Table Name", "RMT List", Header, "Sub Header", "Account Group")
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
