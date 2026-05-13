codeunit 50122 ExternalDocUpdate
{
    Permissions = TableData "G/L Entry"=m,
        tabledata "VAT Entry"=m,
        TableData "Purch. Inv. Header"=m;

    trigger OnRun()
    begin
    end;
    procedure OnBeforeVendLedgEntryModify(FromVendLedgEntry: Record "Vendor Ledger Entry"; var VendLedgEntry: Record "Vendor Ledger Entry")
    var
        GLE: Record "G/L Entry";
        PostedPurchaseInvocie: Record "Purch. Inv. Header";
        VatEntry: Record "VAT Entry";
    begin
        GLE.Reset();
        GLE.SetCurrentKey("Document No.", "External Document No.");
        GLE.SetRange("Document No.", FromVendLedgEntry."Document No.");
        GLE.SetRange("External Document No.", FromVendLedgEntry."External Document No.");
        if GLE.FindSet()then gle.ModifyAll("External Document No.", VendLedgEntry."External Document No.");
        PostedPurchaseInvocie.Reset();
        if PostedPurchaseInvocie.get(gle."Document No.")then begin
            PostedPurchaseInvocie."Vendor Invoice No.":=VendLedgEntry."External Document No.";
            PostedPurchaseInvocie.Modify();
        end;
        VatEntry.Reset();
        VatEntry.SetCurrentKey("Document No.", "External Document No.");
        VatEntry.SetRange("Document No.", FromVendLedgEntry."Document No.");
        VatEntry.SetRange("External Document No.", FromVendLedgEntry."External Document No.");
        if VatEntry.FindSet()then VatEntry.ModifyAll("External Document No.", VendLedgEntry."External Document No.");
    end;
}
