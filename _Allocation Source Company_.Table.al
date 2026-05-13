table 50205 "Allocation Source Company"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Rule; Code[20])
        {
            Caption = 'Rule';
            DataClassification = CustomerContent;
            TableRelation = "Allocation Rule";
        }
        field(3; "Line No."; integer)
        {
        }
        field(4; "Company Name"; Text[50])
        {
            Caption = 'Company Name';
            TableRelation = "IC Partner".Code;
        }
        field(34; "Last Source Amount get"; decimal)
        {
        }
        field(35; "Last Get From Date"; Date)
        {
        }
        field(36; "Last Get To Date"; Date)
        {
        }
    }
    keys
    {
        key(PK; Rule, "Line No.", "Company Name")
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
    var
        l_Rec_AllocationSource: Record "Allocation Source";
    begin
        l_Rec_AllocationSource.RESET;
        l_Rec_AllocationSource.SETRANGE(Rule, Rule);
        l_Rec_AllocationSource.SETRANGE("Line No.", "Line No.");
        l_Rec_AllocationSource.SETRANGE("Field Setting", l_Rec_AllocationSource."Field Setting"::"Main Account");
        IF NOT l_Rec_AllocationSource.FINDSET then ERROR('Only Main Account entry allow to enter this');
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
