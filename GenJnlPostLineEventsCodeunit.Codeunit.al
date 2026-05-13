codeunit 50117 GenJnlPostLineEventsCodeunit
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnPostVendOnAfterInitVendLedgEntry, '', false, false)]
    local procedure OnPostVendOnAfterInitVendLedgEntry(var GenJnlLine: Record "Gen. Journal Line"; var VendLedgEntry: Record "Vendor Ledger Entry")
    begin
        VendLedgEntry."Invoice Link":=GenJnlLine."Invoice Link";
        //DNV Integration
        if GenJnlLine."Booking Method" <> '' then VendLedgEntry."Booking Method":=GenJnlLine."Booking Method";
        if GenJnlLine."Ship Manager Id" <> '' then VendLedgEntry."Ship Manager Id":=GenJnlLine."Ship Manager Id";
        if VendLedgEntry."Document Type" = VendLedgEntry."Document Type"::Invoice then VendLedgEntry."Payment Date":=VendLedgEntry."Posting Date" + 1;
    end;
}
