table 50204 "Allocation Entry Log"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Rule No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
        }
        field(4; "Run Date"; Date)
        {
        }
        field(5; "Posting Date"; Date)
        {
        }
        field(6; "Data From Date"; Date)
        {
        }
        field(7; "Data To Date"; Date)
        {
        }
        field(8; "Journal Template Name"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Journal Batch Name"; Code[20])
        {
        }
        field(10; "Document No."; Code[20])
        {
        }
        field(11; "Execute Run System Date"; Date)
        {
        }
        field(12; "Exeucted by"; Text[50])
        {
        }
    }
    keys
    {
        key(Key1; "Rule No.", "Line No.")
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
    var
        l_Rec_AllocationEntryLogDEtail: record "Allocation Entry Log Detail";
    begin
        l_Rec_AllocationEntryLogDEtail.RESET;
        l_Rec_AllocationEntryLogDEtail.seTRANGE("Rule No.", "Rule No.");
        l_Rec_AllocationEntryLogDEtail.SETRANGE("Line No.", "Line No.");
        IF l_Rec_AllocationEntryLogDEtail.FINDSET then l_Rec_AllocationEntryLogDEtail.DELETEALL;
    end;
    trigger OnRename()
    begin
    end;
}
