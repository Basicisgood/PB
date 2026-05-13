codeunit 50193 "Global Empl. Entry-SetAppl.ID"
{
    Permissions = TableData "Global Employee Ledger Entry"=rimd,
        TableData "Employee Ledger Entry"=rim;

    trigger OnRun()
    begin
    end;
    var EmplEntryApplID: Code[50];
    g_BankCode: Code[20];
    procedure SetApplId(var EmplLedgEntry: Record "Global Employee Ledger Entry"; ApplyingEmplLedgEntry: Record "Global Employee Ledger Entry"; AppliesToID: Code[50]; BankCode: Code[20])
    var
        TempEmplLedgEntry: Record "Global Employee Ledger Entry" temporary;
        EmplLedgEntryToUpdate: Record "Global Employee Ledger Entry";
        ELE: Record "Employee Ledger Entry"; //Sgarg-Added
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlBatch: Record "Gen. Journal Batch";
    begin
        g_BankCode:=BankCode; //VJ 25MAR2025
        EmplLedgEntry.LockTable();
        if EmplLedgEntry.FindSet()then begin
            // Make Applies-to ID
            if EmplLedgEntry."Applies-to ID" <> '' then EmplEntryApplID:=''
            else
            begin
                EmplEntryApplID:=AppliesToID;
                if EmplEntryApplID = '' then begin
                    EmplEntryApplID:=CopyStr(UserId(), 1, 50);
                    if EmplEntryApplID = '' then EmplEntryApplID:='***';
                end;
            end;
            /*
            if EmplEntryApplID = '' then begin
                EmplLedgEntry."Bank Document No. Applied" := '';
                BankCode := '';
            end else
                EmplLedgEntry."Bank Document No. Applied" := BankCode;
*/
            //VJ 25MAR2025 COMMENTED because the error was showing showing for employee 'Entries are already used by another batch %1. Bank Document No'
            repeat TempEmplLedgEntry:=EmplLedgEntry;
                TempEmplLedgEntry.Insert();
            until EmplLedgEntry.Next() = 0;
        end;
        if TempEmplLedgEntry.FindSet()then repeat //TEC.VJ 26MAR2025>>
                //Check Applied entries are used by another batch start
                GenJnlLine.Reset();
                GenJnlLine.SetRange("Document No.", TempEmplLedgEntry."Applies-to ID");
                GenJnlLine.SetRange("Bank Document No.", TempEmplLedgEntry."Bank Document No. Applied");
                if GenJnlLine.FindFirst()then begin
                    GenJnlBatch.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
                    if GenJnlBatch."Review Status" <> GenJnlBatch."Review Status"::" " then Error('Entries are already used by another batch %1. Bank Document No. %2', GenJnlBatch.Name, GenJnlLine."Bank Document No.");
                end;
                //Check Applied entries are used by another batch End;
                //TEC.VJ 26MAR2025<<
                EmplLedgEntryToUpdate.Copy(TempEmplLedgEntry);
                EmplLedgEntryToUpdate.TestField(Open, true);
                EmplLedgEntryToUpdate."Applies-to ID":=EmplEntryApplID;
                EmplLedgEntryToUpdate."Bank Document No. Applied":=BankCode;
                if((EmplLedgEntryToUpdate."Amount to Apply" <> 0) and (EmplEntryApplID = '')) or (EmplEntryApplID = '')then EmplLedgEntryToUpdate."Amount to Apply":=0
                else if EmplLedgEntryToUpdate."Amount to Apply" = 0 then begin
                        EmplLedgEntryToUpdate.CalcFields("Remaining Amount");
                        if EmplLedgEntryToUpdate."Remaining Amount" <> 0 then EmplLedgEntryToUpdate."Amount to Apply":=EmplLedgEntryToUpdate."Remaining Amount";
                    end;
                if EmplLedgEntryToUpdate."Entry No." = ApplyingEmplLedgEntry."Entry No." then EmplLedgEntryToUpdate."Applying Entry":=ApplyingEmplLedgEntry."Applying Entry";
                //VJ 25mar2025 added
                if EmplEntryApplID = '' then begin
                    EmplLedgEntryToUpdate."Bank Document No. Applied":='';
                    BankCode:='';
                end
                else
                    EmplLedgEntryToUpdate."Bank Document No. Applied":=g_BankCode;
                //VJ 25mar2025 added
                EmplLedgEntryToUpdate.Modify();
                //TEC-Sgarg >>
                if UpperCase(EmplLedgEntryToUpdate."Company Code") = UpperCase(CompanyName)then begin
                    ELE.GET(EmplLedgEntryToUpdate."Entry No.");
                    ELE."Applies-to ID":=EmplLedgEntryToUpdate."Applies-to ID";
                    ELE."Bank Document No. Applied":=EmplLedgEntryToUpdate."Bank Document No. Applied";
                    //ELE."Accepted Pmt. Disc. Tolerance" := EmplLedgEntryToUpdate."Accepted Pmt. Disc. Tolerance";
                    //ELE."Accepted Payment Tolerance" := EmplLedgEntryToUpdate."Accepted Payment Tolerance";
                    ELE."Amount to Apply":=EmplLedgEntryToUpdate."Amount to Apply";
                    ELE."Applying Entry":=EmplLedgEntryToUpdate."Applying Entry";
                    ELE.Modify();
                END;
                //TEC-Sgarg<<
                OnSetApplIdOnAfterEmplLedgEntryToUpdateModify(EmplLedgEntryToUpdate, TempEmplLedgEntry, ApplyingEmplLedgEntry, AppliesToID);
            until TempEmplLedgEntry.Next() = 0;
    end;
    [IntegrationEvent(false, false)]
    local procedure OnSetApplIdOnAfterEmplLedgEntryToUpdateModify(var EmplLedgerEntry: Record "Global Employee Ledger Entry"; var TempEmplLedgEntry: Record "Global Employee Ledger Entry" temporary; ApplyingEmplLedgEntry: Record "Global Employee Ledger Entry"; AppliesToID: Code[50])
    begin
    end;
}
