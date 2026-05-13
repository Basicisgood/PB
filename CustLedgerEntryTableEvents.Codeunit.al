codeunit 50110 CustLedgerEntryTableEvents
{
    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertEvent(var Rec: Record "Cust. Ledger Entry")
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
    //10032024>>
    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", OnAfterCopyCustLedgerEntryFromGenJnlLine, '', false, false)]
    local procedure "Cust. Ledger Entry_OnAfterCopyCustLedgerEntryFromGenJnlLine"(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        CustLedgerEntry."Over Receipt Amount":=GenJournalLine."Over Receipt";
        CustLedgerEntry."Over Receipt":=GenJournalLine."CP Over Receipt";
        CustLedgerEntry."Bank Charges Amount":=GenJournalLine."Bank Charges";
        CustLedgerEntry."IMOS Transaction":=GenJournalLine."IMOS invoice";
        CustLedgerEntry."IMOS Transaction No":=GenJournalLine."IMOS Transaction No";
        CustLedgerEntry."Remittance Company No":=GenJournalLine."Remittance Company No";
        CustLedgerEntry."Remittance Account No":=GenJournalLine."Remittance Account No";
        CustLedgerEntry."Remittance Full Name":=GenJournalLine."Remittance Full Name";
        CustLedgerEntry."IMOS Bank ID":=GenJournalLine."IMOS Bank ID";
        CustLedgerEntry."Bank Document No.":=GenJournalLine."Bank Document No.";
        CustLedgerEntry."CP External Document No":=GenJournalLine."CP External Document No";
    end;
//10032024<<
}
