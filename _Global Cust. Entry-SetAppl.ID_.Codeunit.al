codeunit 50127 "Global Cust. Entry-SetAppl.ID"
{
    Permissions = TableData "Global Cust. Ledger entry"=rimd,
        Tabledata "Cust. Ledger Entry"=rimd;

    trigger OnRun()
    begin
    end;
    var CustEntryApplID: Code[50];
    procedure SetApplId(var CustLedgEntry: Record "Global Cust. Ledger entry"; ApplyingCustLedgEntry: Record "Global Cust. Ledger entry"; AppliesToID: Code[50]; BankDocNo: code[20])
    var
        TempCustLedgEntry: Record "Global Cust. Ledger entry" temporary;
    begin
        CustLedgEntry.LockTable();
        if CustLedgEntry.FindSet()then begin
            // Make Applies-to ID
            if CustLedgEntry."Applies-to ID" <> '' then CustEntryApplID:=''
            else
            begin
                CustEntryApplID:=AppliesToID;
                if CustEntryApplID = '' then begin
                    CustEntryApplID:=UserId;
                    if CustEntryApplID = '' then CustEntryApplID:='***';
                end;
            end;
            repeat TempCustLedgEntry:=CustLedgEntry;
                TempCustLedgEntry.Insert();
            until CustLedgEntry.Next() = 0;
        end;
        SetBankDocNo(BankDocNo); //TEC.VJ 06MAR2025
        if TempCustLedgEntry.FindSet()then repeat UpdateCustLedgerEntry(TempCustLedgEntry, ApplyingCustLedgEntry, AppliesToID);
            until TempCustLedgEntry.Next() = 0;
        SetBankDocNo(''); //TEC.VJ 06MAR2025
    end;
    local procedure UpdateCustLedgerEntry(var TempCustLedgerEntry: Record "Global Cust. Ledger entry" temporary; ApplyingCustLedgerEntry: Record "Global Cust. Ledger entry"; AppliesToID: Code[50])
    var
        CustLedgerEntry: Record "Global Cust. Ledger entry";
        CustLedgerEntry2: Record "Cust. Ledger entry";
        IsHandled: Boolean;
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlBatch: Record "Gen. Journal Batch";
    begin
        IsHandled:=false;
        OnBeforeUpdateCustLedgerEntry(TempCustLedgerEntry, ApplyingCustLedgerEntry, AppliesToID, IsHandled, CustEntryApplID);
        if IsHandled then exit;
        //TEC.VJ 06MAR2025>>
        //Check Applied entries are used by another batch start
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Document No.", TempCustLedgerEntry."Applies-to ID");
        GenJnlLine.SetRange("Bank Document No.", TempCustLedgerEntry."Bank Document No. Applied");
        if GenJnlLine.FindFirst()then begin
            GenJnlBatch.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
            if GenJnlBatch."Review Status" <> GenJnlBatch."Review Status"::" " then Error('Entries are already used by another batch %1. Bank Document No. %2', GenJnlBatch.Name, GenJnlLine."Bank Document No.");
        end;
        //Check Applied entries are used by another batch End;
        //TEC.VJ 06MAR2025<<
        CustLedgerEntry.Copy(TempCustLedgerEntry);
        CustLedgerEntry.TestField(Open, true);
        CustLedgerEntry."Applies-to ID":=CustEntryApplID;
        if CustLedgerEntry."Applies-to ID" = '' then begin
            CustLedgerEntry."Accepted Pmt. Disc. Tolerance":=false;
            CustLedgerEntry."Accepted Payment Tolerance":=0;
            if CustLedgerEntry."Document Type" <> CustLedgerEntry."Document Type"::Payment then CustLedgerEntry."Over Receipt Amount":=0;
            CustLedgerEntry."Bank Charges Amount":=0;
            CustLedgerEntry."Bank Document No. Applied":=''; //TEC.VJ 06MAR2025
        end;
        if((CustLedgerEntry."Amount to Apply" <> 0) and (CustEntryApplID = '')) or (CustEntryApplID = '')then CustLedgerEntry."Amount to Apply":=0
        else if CustLedgerEntry."Amount to Apply" = 0 then begin
                CustLedgerEntry.CalcFields("Remaining Amount");
                CustLedgerEntry."Amount to Apply":=CustLedgerEntry."Remaining Amount" end;
        if CustLedgerEntry."Entry No." = ApplyingCustLedgerEntry."Entry No." then CustLedgerEntry."Applying Entry":=ApplyingCustLedgerEntry."Applying Entry";
        //TEC.VJ 06MAR2025>>
        IF CustEntryApplID <> '' THEN CustLedgerEntry."Bank Document No. Applied":=GetBankDocNo()
        ELSE
            CustLedgerEntry."Bank Document No. Applied":='';
        //TEC.VJ 06MAR2025<<
        OnUpdateCustLedgerEntryOnBeforeCustLedgerEntryModify(CustLedgerEntry, TempCustLedgerEntry, ApplyingCustLedgerEntry, AppliesToID);
        CustLedgerEntry.Modify();
        if UpperCase(CustLedgerEntry."Company Name") = UpperCase(CompanyName)then begin
            CustLedgerEntry2.Get(CustLedgerEntry."Entry No.");
            CustLedgerEntry2."Applies-to ID":=CustLedgerEntry."Applies-to ID";
            CustLedgerEntry2."Accepted Pmt. Disc. Tolerance":=CustLedgerEntry."Accepted Pmt. Disc. Tolerance";
            CustLedgerEntry2."Accepted Payment Tolerance":=CustLedgerEntry."Accepted Payment Tolerance";
            CustLedgerEntry2."Amount to Apply":=CustLedgerEntry."Amount to Apply";
            CustLedgerEntry2."Applying Entry":=CustLedgerEntry."Applying Entry";
            CustLedgerEntry2."Over Receipt Amount":=CustLedgerEntry."Over Receipt Amount";
            CustLedgerEntry2."Bank Charges Amount":=CustLedgerEntry."Bank Charges Amount";
            CustLedgerEntry2."Bank Document No. Applied":=CustLedgerEntry."Bank Document No. Applied"; //TEC.VJ 06MAR2025<<
            CustLedgerEntry2.Modify();
            OnAfterUpdateCustLedgerEntry(CustLedgerEntry, TempCustLedgerEntry, ApplyingCustLedgerEntry, AppliesToID);
        end;
    end;
    procedure RemoveApplId(var CustLedgerEntry: Record "Global Cust. Ledger entry"; AppliestoID: Code[50])
    begin
        if CustLedgerEntry.FindSet()then repeat if CustLedgerEntry."Applies-to ID" = AppliestoID then begin
                    CustLedgerEntry."Applies-to ID":='';
                    CustLedgerEntry."Accepted Pmt. Disc. Tolerance":=false;
                    CustLedgerEntry."Accepted Payment Tolerance":=0;
                    CustLedgerEntry."Amount to Apply":=0;
                    CustLedgerEntry.Modify();
                end;
            until CustLedgerEntry.Next() = 0;
    end;
    //TEC.VJ 06MAR2025>>
    LOCAL procedure SetBankDocNo(BankDoc: Code[20])
    begin
        BankDocumentNo:=BankDoc;
    end;
    LOCAL procedure GetBankDocNo(): Code[20]begin
        exit(BankDocumentNo);
    end;
    //TEC.VJ 06MAR2025<<
    var BankDocumentNo: Code[20];
    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateCustLedgerEntry(var TempCustLedgerEntry: Record "Global Cust. Ledger entry" temporary; ApplyingCustLedgerEntry: Record "Global Cust. Ledger entry"; AppliesToID: Code[50]; var IsHandled: Boolean; var CustEntryApplID: Code[50]);
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateCustLedgerEntry(var CustLedgerEntry: Record "Global Cust. Ledger entry"; var TempCustLedgerEntry: Record "Global Cust. Ledger entry" temporary; ApplyingCustLedgerEntry: Record "Global Cust. Ledger entry"; AppliesToID: Code[50]);
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnUpdateCustLedgerEntryOnBeforeCustLedgerEntryModify(var CustLedgerEntry: Record "Global Cust. Ledger entry"; var TempCustLedgerEntry: Record "Global Cust. Ledger entry" temporary; ApplyingCustLedgerEntry: Record "Global Cust. Ledger entry"; AppliesToID: Code[50]);
    begin
    end;
}
