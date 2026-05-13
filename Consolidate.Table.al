table 50124 Consolidate
{
    DataClassification = ToBeClassified;
    LookupPageId = "Consolidation List";
    DrillDownPageId = "Consolidation List";

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "From Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(3; "To Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(4; "From Period"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "To Period"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Include Actual Amounts"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Rebuild Bal. during Con. Proc."; Blob)
        {
            DataClassification = ToBeClassified;
            Caption = 'Rebuild Balances during Consolidation Process';
        }
        field(8; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Proposal Options"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Proposal Only", "Post Only";
        }
        field(10; "G/L Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Release Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Reason Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Reason Code";
        }
        field(13; "Reason Comment"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Dimension Set ID"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(1), Blocked=const(false));

            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(16; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(2), Blocked=const(false));

            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(17; "Exchange Rate Type"; text[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Exchange Rate Type";
        }
        field(18; "Exchange Rate Date"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Consolidation Date", "Transaction Date";
        }
        field(19; "Exchange Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        IsHandled: Boolean;
    begin
        IsHandled:=false;
        if IsHandled then exit;
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;
    procedure ShowDimensions()IsChanged: Boolean var
        OldDimSetID: Integer;
        IsHandled: Boolean;
    begin
        IsHandled:=false;
        if IsHandled then exit(IsChanged);
        OldDimSetID:="Dimension Set ID";
        "Dimension Set ID":=DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1', "No."));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        IsChanged:=OldDimSetID <> "Dimension Set ID";
    end;
    var DimMgt: Codeunit DimensionManagement;
}
