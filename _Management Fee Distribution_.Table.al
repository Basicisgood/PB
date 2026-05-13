table 50208 "Management Fee Distribution"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(6; "Document No."; Code[20])
        {
        }
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Company Name"; Text[50])
        {
        }
        field(3; "Period"; Code[10])
        {
        }
        field(4; "Days Type"; Text[25])
        {
            Caption = 'Days Type';
            DataClassification = CustomerContent;
        }
        field(5; "Source Date"; Date)
        {
            Caption = 'Source Date';
            DataClassification = CustomerContent;
        }
        field(7; "IC Partner No."; Code[20])
        {
        }
        field(8; T1; Text[50])
        {
        }
        field(10; "Calc. Days"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("DAYSOURCE".Days WHERE("Company Name"=field("Company Name"), Period=field(Period), "Days Type"=CONST('Operating Days')));
        //CalcFormula = sum("Allocation Destination"."Fixed Weight" where(Rule = field(Rule)));
        }
    }
    keys
    {
        key(Key1; "Document No.", "Entry No.")
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
