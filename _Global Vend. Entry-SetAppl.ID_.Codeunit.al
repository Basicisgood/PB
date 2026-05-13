codeunit 50129 "Global Vend. Entry-SetAppl.ID"
{
    Permissions = TableData "Global Vendor Ledger Entry"=rimd;

    trigger OnRun()
    begin
    end;
    var VendEntryApplID: Code[50];
    procedure SetApplId(var VendLedgEntry: Record "Global Vendor Ledger Entry"; ApplyingVendLedgEntry: Record "Global Vendor Ledger Entry"; AppliesToID: Code[50]; BankDocNo: code[20])
    var
        TempVendLedgEntry: Record "Global Vendor Ledger Entry" temporary;
    begin
        VendLedgEntry.LockTable();
        if VendLedgEntry.FindSet()then begin
            // Make Applies-to ID
            if VendLedgEntry."Applies-to ID" <> '' then VendEntryApplID:=''
            else
            begin
                VendEntryApplID:=AppliesToID;
                if VendEntryApplID = '' then begin
                    VendEntryApplID:=UserId;
                    if VendEntryApplID = '' then VendEntryApplID:='***';
                end;
            end;
            OnAfterSetVendEntryApplID(VendLedgEntry, ApplyingVendLedgEntry, VendEntryApplID);
            repeat TempVendLedgEntry:=VendLedgEntry;
                TempVendLedgEntry.Insert();
            until VendLedgEntry.Next() = 0;
        end;
        SetBankDocNo(BankDocNo); //#3 TEC.VJ 20012025
        if TempVendLedgEntry.FindSet()then repeat UpdateVendLedgerEntry(TempVendLedgEntry, ApplyingVendLedgEntry, AppliesToID);
            until TempVendLedgEntry.Next() = 0;
        SetBankDocNo(''); //#3 TEC.VJ 20012025
    end;
    local procedure UpdateVendLedgerEntry(var TempVendLedgEntry: Record "Global Vendor Ledger Entry" temporary; ApplyingVendLedgEntry: Record "Global Vendor Ledger Entry"; AppliesToID: Code[50])
    var
        VendorLedgerEntry: Record "Global Vendor Ledger Entry";
        VendorLedgerEntry2: Record "Vendor Ledger Entry";
        IsHandled: Boolean;
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlBatch: Record "Gen. Journal Batch";
    begin
        IsHandled:=false;
        OnBeforeUpdateVendLedgerEntry(TempVendLedgEntry, ApplyingVendLedgEntry, AppliesToID, VendEntryApplID, IsHandled);
        if IsHandled then exit;
        //Check Applied entries are used by another batch start //VJ 06Feb2025
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Document No.", TempVendLedgEntry."Applies-to ID");
        GenJnlLine.SetRange("Bank Document No.", TempVendLedgEntry."Bank Document No. Applied");
        if GenJnlLine.FindFirst()then begin
            GenJnlBatch.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
            //if GenJnlBatch."Review Status" = GenJnlBatch."Review Status"::"Pending for Review" then
            if GenJnlBatch."Review Status" <> GenJnlBatch."Review Status"::" " then //VJ 27FEB2025
 Error('Entries are already used by another batch %1. Bank Document No. %2', GenJnlBatch.Name, GenJnlLine."Bank Document No.");
        end;
        //Check Applied entries are used by another batch End;
        VendorLedgerEntry.Copy(TempVendLedgEntry);
        VendorLedgerEntry.TestField(Open, true);
        VendorLedgerEntry."Applies-to ID":=VendEntryApplID;
        if VendorLedgerEntry."Applies-to ID" = '' then begin
            VendorLedgerEntry."Accepted Pmt. Disc. Tolerance":=false;
            VendorLedgerEntry."Accepted Payment Tolerance":=0;
            VendorLedgerEntry."Bank Document No. Applied":=''; //VJ 04Feb2025
        end;
        if((VendorLedgerEntry."Amount to Apply" <> 0) and (VendEntryApplID = '')) or (VendEntryApplID = '')then VendorLedgerEntry."Amount to Apply":=0
        else if VendorLedgerEntry."Amount to Apply" = 0 then begin
                VendorLedgerEntry.CalcFields("Remaining Amount");
                if VendorLedgerEntry."Remaining Amount" <> 0 then VendorLedgerEntry."Amount to Apply":=VendorLedgerEntry."Remaining Amount";
            end;
        if VendorLedgerEntry."Entry No." = ApplyingVendLedgEntry."Entry No." then VendorLedgerEntry."Applying Entry":=ApplyingVendLedgEntry."Applying Entry";
        //TEC.VJ 20012025>>
        IF VendEntryApplID <> '' THEN VendorLedgerEntry."Bank Document No. Applied":=GetBankDocNo()
        ELSE
            VendorLedgerEntry."Bank Document No. Applied":='';
        //TEC.VJ 20012025<<
        VendorLedgerEntry.Modify();
        if UpperCase(VendorLedgerEntry."Company Name") = UpperCase(CompanyName)then begin
            VendorLedgerEntry2.Get(VendorLedgerEntry."Entry No.");
            VendorLedgerEntry2."Applies-to ID":=VendorLedgerEntry."Applies-to ID";
            VendorLedgerEntry2."Accepted Pmt. Disc. Tolerance":=VendorLedgerEntry."Accepted Pmt. Disc. Tolerance";
            VendorLedgerEntry2."Accepted Payment Tolerance":=VendorLedgerEntry."Accepted Payment Tolerance";
            VendorLedgerEntry2."Amount to Apply":=VendorLedgerEntry."Amount to Apply";
            VendorLedgerEntry2."Applying Entry":=VendorLedgerEntry."Applying Entry";
            VendorLedgerEntry2."Bank Document No. Applied":=VendorLedgerEntry."Bank Document No. Applied"; //TEC.VJ 20012025
            VendorLedgerEntry2.Modify();
        END;
        OnAfterUpdateVendLedgerEntry(VendorLedgerEntry, TempVendLedgEntry, ApplyingVendLedgEntry, AppliesToID);
    end;
    procedure RemoveApplId(var VendorLedgerEntry: Record "Global Vendor Ledger Entry"; AppliestoID: Code[50])
    begin
        if VendorLedgerEntry.FindSet()then repeat if VendorLedgerEntry."Applies-to ID" = AppliestoID then begin
                    VendorLedgerEntry."Applies-to ID":='';
                    VendorLedgerEntry."Accepted Pmt. Disc. Tolerance":=false;
                    VendorLedgerEntry."Accepted Payment Tolerance":=0;
                    VendorLedgerEntry."Amount to Apply":=0;
                    VendorLedgerEntry.Modify();
                end;
            until VendorLedgerEntry.Next() = 0;
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateVendLedgerEntry(var TempVendLedgEntry: Record "Global Vendor Ledger Entry" temporary; ApplyingVendLedgEntry: Record "Global Vendor Ledger Entry"; AppliesToID: Code[50]; VendEntryApplID: Code[50]; var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterSetVendEntryApplID(VendLedgEntry: Record "Global Vendor Ledger Entry"; ApplyingVendLedgEntry: Record "Global Vendor Ledger Entry"; VendEntryApplID: Code[50])
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateVendLedgerEntry(var VendorLedgerEntry: Record "Global Vendor Ledger Entry"; var TempVendLedgEntry: Record "Global Vendor Ledger Entry" temporary; ApplyingVendLedgEntry: Record "Global Vendor Ledger Entry"; AppliesToID: Code[50])
    begin
    end;
    //#3 TEC.VJ 20012025>>
    LOCAL procedure SetBankDocNo(BankDoc: Code[20])
    begin
        BankDocumentNo:=BankDoc;
    end;
    LOCAL procedure GetBankDocNo(): Code[20]begin
        exit(BankDocumentNo);
    end;
    //#3 TEC.VJ 20012025<<
    var C19: Codeunit 19;
    CU111: Codeunit 111;
    rec81: Record 81;
    CU112: Codeunit 112;
    BankDocumentNo: Code[20];
}
