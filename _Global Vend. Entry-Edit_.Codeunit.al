codeunit 50133 "Global Vend. Entry-Edit"
{
    Permissions = TableData "Global Vendor Ledger Entry"=m,
        TableData "GB Detailed Vendor Ledg. Entry"=m,
        tabledata "Vendor Ledger Entry"=m;
    TableNo = "Global Vendor Ledger Entry";

    trigger OnRun()
    var
        LedgEntryTrackChanges: Codeunit "Ledg. Entry-Track Changes";
        IndVLE: Record "Vendor Ledger Entry";
    begin
        VendLedgEntry:=Rec;
        VendLedgEntry.LockTable();
        VendLedgEntry.Find();
        VendLedgEntry."On Hold":=Rec."On Hold";
        if LogFieldChanged(VendLedgEntry, Rec)then BindSubscription(LedgEntryTrackChanges);
        VendLedgEntry."On Hold":=Rec."On Hold";
        if VendLedgEntry.Open then begin
            VendLedgEntry."Due Date":=Rec."Due Date";
            DtldVendLedgEntry.SetCurrentKey("Vendor Ledger Entry No.");
            DtldVendLedgEntry.SetRange("Vendor Ledger Entry No.", VendLedgEntry."Entry No.");
            OnRunOnBeforeDtldVendLedgEntryModifyAll(Rec, DtldVendLedgEntry, VendLedgEntry);
            DtldVendLedgEntry.ModifyAll("Initial Entry Due Date", Rec."Due Date");
            VendLedgEntry."Pmt. Discount Date":=Rec."Pmt. Discount Date";
            VendLedgEntry."Applies-to ID":=Rec."Applies-to ID";
            VendLedgEntry.Validate("Payment Method Code", Rec."Payment Method Code");
            VendLedgEntry.Validate("Payment Reference", Rec."Payment Reference");
            VendLedgEntry.Validate("Remaining Pmt. Disc. Possible", Rec."Remaining Pmt. Disc. Possible");
            VendLedgEntry."Pmt. Disc. Tolerance Date":=Rec."Pmt. Disc. Tolerance Date";
            VendLedgEntry.Validate("Max. Payment Tolerance", Rec."Max. Payment Tolerance");
            VendLedgEntry.Validate("Accepted Payment Tolerance", Rec."Accepted Payment Tolerance");
            VendLedgEntry.Validate("Accepted Pmt. Disc. Tolerance", Rec."Accepted Pmt. Disc. Tolerance");
            VendLedgEntry.Validate("Amount to Apply", Rec."Amount to Apply");
            VendLedgEntry.Validate("Applying Entry", Rec."Applying Entry");
            VendLedgEntry.Validate("Applies-to Ext. Doc. No.", Rec."Applies-to Ext. Doc. No.");
            VendLedgEntry.Validate("Message to Recipient", Rec."Message to Recipient");
            VendLedgEntry.Validate("Recipient Bank Account", Rec."Recipient Bank Account");
            VendLedgEntry.Validate("Remit-to Code", Rec."Remit-to Code");
            VendLedgEntry."Bank Document No. Applied":=Rec."Bank Document No. Applied"; //#179 VJ 22Jan2025
        end;
        VendLedgEntry.Description:=Rec.Description;
        VendLedgEntry.Validate("Exported to Payment File", Rec."Exported to Payment File");
        VendLedgEntry.Validate("Creditor No.", Rec."Creditor No.");
        OnBeforeVendLedgEntryModify(VendLedgEntry, Rec);
        VendLedgEntry.TestField("Entry No.", Rec."Entry No.");
        // Update Individual VLE
        if VendLedgEntry."Company Name" = CompanyName then begin
            IndVLE.Reset();
            IndVLE.Get(VendLedgEntry."Entry No.");
            IndVLE."Amount to Apply":=VendLedgEntry."Amount to Apply";
            IndVLE.Modify();
        end;
        VendLedgEntry.Modify();
        OnRunOnAfterVendLedgEntryMofidy(VendLedgEntry);
        Rec:=VendLedgEntry;
    end;
    var VendLedgEntry: Record "Global Vendor Ledger Entry";
    DtldVendLedgEntry: Record "GB Detailed Vendor Ledg. Entry";
    procedure SetOnHold(var VendorLedgerEntry: Record "Global Vendor Ledger Entry"; NewOnHold: Code[3])
    var
        LedgEntryTrackChanges: Codeunit "Ledg. Entry-Track Changes";
        xOnHold: Code[3];
    begin
        BindSubscription(LedgEntryTrackChanges);
        xOnHold:=VendorLedgerEntry."On Hold";
        VendorLedgerEntry."On Hold":=NewOnHold;
        if xOnHold <> VendorLedgerEntry."On Hold" then VendorLedgerEntry.Modify();
    end;
    local procedure LogFieldChanged(CurrVendorLedgerEntry: Record "Global Vendor Ledger Entry"; NewVendorLedgerEntry: Record "Global Vendor Ledger Entry"): Boolean var
        Changed: Boolean;
    begin
        Changed:=(CurrVendorLedgerEntry.Description <> NewVendorLedgerEntry.Description) or (CurrVendorLedgerEntry."Due Date" <> NewVendorLedgerEntry."Due Date") or (CurrVendorLedgerEntry."Payment Method Code" <> NewVendorLedgerEntry."Payment Method Code") or (CurrVendorLedgerEntry."Message to Recipient" <> NewVendorLedgerEntry."Message to Recipient") or (CurrVendorLedgerEntry."Recipient Bank Account" <> NewVendorLedgerEntry."Recipient Bank Account") or (CurrVendorLedgerEntry."On Hold" <> NewVendorLedgerEntry."On Hold");
        OnAfterLogFieldChanged(CurrVendorLedgerEntry, NewVendorLedgerEntry, Changed);
        exit(Changed);
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeVendLedgEntryModify(var VendLedgEntry: Record "Global Vendor Ledger Entry"; FromVendLedgEntry: Record "Global Vendor Ledger Entry")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnRunOnBeforeDtldVendLedgEntryModifyAll(FromVendLedgEntry: Record "Global Vendor Ledger Entry"; var DtldVendLedgEntry: Record "GB Detailed Vendor Ledg. Entry"; var VendLedgEntry: Record "Global Vendor Ledger Entry")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnRunOnAfterVendLedgEntryMofidy(var VendorLedgerEntry: Record "Global Vendor Ledger Entry")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterLogFieldChanged(CurrVendorLedgerEntry: Record "Global Vendor Ledger Entry"; NewVendorLedgerEntry: Record "Global Vendor Ledger Entry"; var Changed: Boolean)
    begin
    end;
}
