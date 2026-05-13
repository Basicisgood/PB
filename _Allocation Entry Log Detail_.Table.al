table 50203 "Allocation Entry Log Detail"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Rule No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Entry No."; Integer)
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
        field(11; "Journal Line No."; Integer)
        {
        }
        field(12; "Currency Code"; Code[20])
        {
        }
        Field(13; "Sum Amount"; DEcimal)
        {
        }
        field(14; "Account NO."; Code[20])
        {
        }
        field(20; "Shortcut Dimension 1 Code"; Code[20])
        {
        }
        field(21; "Shortcut Dimension 2 Code"; Code[20])
        {
        }
        field(22; "Shortcut Dimension 3 Code"; Code[20])
        {
        }
        field(23; "Shortcut Dimension 4 Code"; Code[20])
        {
        }
        field(24; "Shortcut Dimension 5 Code"; Code[20])
        {
        }
        field(25; "Shortcut Dimension 6 Code"; Code[20])
        {
        }
        field(26; "Shortcut Dimension 7 Code"; Code[20])
        {
        }
        field(27; "Shortcut Dimension 8 Code"; Code[20])
        {
        }
        field(28; "Shortcut Dimension 9 Code"; Code[20])
        {
        }
        field(29; "Shortcut Dimension 10 Code"; Code[20])
        {
        }
        field(30; "Shortcut Dimension 11 Code"; Code[20])
        {
        }
        field(31; "Shortcut Dimension 12 Code"; Code[20])
        {
        }
        field(32; "Shortcut Dimension 13 Code"; Code[20])
        {
        }
        field(33; "Shortcut Dimension 14 Code"; Code[20])
        {
        }
        field(34; "Shortcut Dimension 15 Code"; Code[20])
        {
        }
        field(35; "Source Company"; Text[50])
        {
        }
        field(36; "Target Company"; Text[50])
        {
        }
        field(37; "Destination Source Account No."; Code[20])
        {
        }
        field(38; "Destination Offset Account No."; Code[20])
        {
        }
    }
    keys
    {
        key(Key1; "RUle No.", "Line No.", "Entry No.")
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
