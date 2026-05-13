table 50130 "PB Committed Cost Inbound"
{
    Caption = 'Committed Cost Inbound';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(2; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(3; "Company Name"; Code[50])
        {
        }
        field(4; "Posted Document No"; Code[20])
        {
        }
        field(5; "Asset ID"; Text[10])
        {
        }
        field(8; "Account Code"; Text[20])
        {
        }
        field(10; "Order Code"; Text[25])
        {
        }
        field(12; "Order Name"; Text[255])
        {
        }
        field(13; "Order Amount"; Decimal)
        {
        }
        field(15; "Order Net Amount"; Decimal)
        {
        }
        field(16; "Invoiced Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("DNV Commited Cost Details"."Invoiced Amount" where("Entry No."=field("Entry No.")));
            Editable = false;
        }
        field(17; "Received Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("DNV Commited Cost Details"."Received Amount" where("Entry No."=field("Entry No.")));
            Editable = false;
        }
        field(18; "Accrual Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("DNV Commited Cost Details"."Accrual Amount" where("Entry No."=field("Entry No.")));
            Editable = false;
        }
        field(29; "Status";Enum EnumStatus)
        {
            Caption = 'Status';
        // Editable = false;
        }
        field(30; "Error Description"; Text[250])
        {
            Caption = 'Error Description';
        // Editable = false;
        }
        field(31; "Cancelled by User"; Code[50])
        {
        // Editable = false;
        }
        field(32; "Cancelled Date time"; DateTime)
        {
        //  Editable = false;
        }
        field(50; "Line Amount Total"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("PB DNV Committed Cost Line"."Total Line Amount" where("Entry No"=field("Entry No.")));
        }
        field(60; "Net Line Amount Total"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("PB DNV Committed Cost Line"."Total Line Net Amount" where("Entry No"=field("Entry No.")));
        }
        field(61; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(62; "Dont Recalculate"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if SystemCreatedAt <> 0DT then begin
            "Posting Date":=DT2Date(SystemCreatedAt);
            "Posting Date":=CalcDate('<-1M><+CM>', "Posting Date");
        end;
    end;
    procedure GetPostingDate()
    var
    begin
        if "Posting Date" = 0D then begin
            "Posting Date":=DT2Date(SystemCreatedAt);
            "Posting Date":=CalcDate('<-1D><-CM>', "Posting Date");
            rec.Modify()end;
    end;
}
