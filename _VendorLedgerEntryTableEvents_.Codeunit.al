codeunit 50109 "VendorLedgerEntryTableEvents"
{
    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertEvent(var Rec: Record "Vendor Ledger Entry")
    var
        DimensionSetEntry_l: Record "Dimension Set Entry";
        DimensionVal: Record "Dimension Value";
    begin
        If Rec."Dimension Set ID" = 0 then exit;
        DimensionSetEntry_l.Reset();
        DimensionSetEntry_l.SetRange("Dimension Set ID", Rec."Dimension Set ID");
        IF DimensionSetEntry_l.FindSet()then repeat DimensionVal.Reset();
                IF DimensionVal.Get(DimensionSetEntry_l."Dimension Code", DimensionSetEntry_l."Dimension Value Code")then begin
                    case DimensionVal."Global Dimension No." of 3: Rec."Shortcut Dimension 3 Code_PB":=DimensionSetEntry_l."Dimension Value Code";
                    4: Rec."Shortcut Dimension 4 Code_PB":=DimensionSetEntry_l."Dimension Value Code";
                    5: Rec."Shortcut Dimension 5 Code_PB":=DimensionSetEntry_l."Dimension Value Code";
                    6: Rec."Shortcut Dimension 6 Code_PB":=DimensionSetEntry_l."Dimension Value Code";
                    7: Rec."Shortcut Dimension 7 Code_PB":=DimensionSetEntry_l."Dimension Value Code";
                    8: Rec."Shortcut Dimension 8 Code_PB":=DimensionSetEntry_l."Dimension Value Code";
                    9: Rec."Shortcut Dimension 9 Code_PB":=DimensionSetEntry_l."Dimension Value Code";
                    10: Rec."Shortcut Dimension 10 Code_PB":=DimensionSetEntry_l."Dimension Value Code";
                    11: Rec."Shortcut Dimension 11 Code_PB":=DimensionSetEntry_l."Dimension Value Code";
                    12: Rec."Shortcut Dimension 12 Code_PB":=DimensionSetEntry_l."Dimension Value Code";
                    13: Rec."Shortcut Dimension 13 Code_PB":=DimensionSetEntry_l."Dimension Value Code";
                    14: Rec."Shortcut Dimension 14 Code_PB":=DimensionSetEntry_l."Dimension Value Code";
                    15: Rec."Shortcut Dimension 15 Code_PB":=DimensionSetEntry_l."Dimension Value Code";
                    end;
                end;
            Until DimensionSetEntry_l.Next() = 0;
    end;
}
