codeunit 50192 "Global Empl. Entry-Edit"
{
    Permissions = TableData "Global Employee Ledger Entry"=rm,
        TableData "GB Det. Employee Ledger Entry"=rm,
        tabledata "Employee Ledger Entry"=rm;
    TableNo = "Global Employee Ledger Entry";

    trigger OnRun()
    var
        LocEmpLedgEntry: record "Employee Ledger Entry";
    begin
        EmplLedgEntry:=Rec;
        EmplLedgEntry.LockTable();
        EmplLedgEntry.Find();
        if EmplLedgEntry.Open then begin
            EmplLedgEntry."Applies-to ID":=Rec."Applies-to ID";
            EmplLedgEntry."Bank Document No. Applied":=Rec."Bank Document No. Applied"; //#179 TEC.VJ 22012025
            EmplLedgEntry.Validate("Payment Method Code", Rec."Payment Method Code");
            EmplLedgEntry.Validate("Amount to Apply", Rec."Amount to Apply");
            EmplLedgEntry.Validate("Applying Entry", Rec."Applying Entry");
            EmplLedgEntry.Validate("Message to Recipient", Rec."Message to Recipient");
        end;
        EmplLedgEntry.Validate("Exported to Payment File", Rec."Exported to Payment File");
        EmplLedgEntry.Validate("Creditor No.", Rec."Creditor No.");
        EmplLedgEntry.Validate("Payment Reference", Rec."Payment Reference");
        // OnBeforeEmplLedgEntryModify(EmplLedgEntry, Rec);
        EmplLedgEntry.TestField("Entry No.", Rec."Entry No.");
        if EmplLedgEntry."Company Code" = CompanyName then begin
            LocEmpLedgEntry.Reset();
            LocEmpLedgEntry.Get(EmplLedgEntry."Entry No.");
            LocEmpLedgEntry.Amount:=EmplLedgEntry."Amount to Apply";
            LocEmpLedgEntry.Modify();
        end;
        EmplLedgEntry.Modify();
        Rec:=EmplLedgEntry;
    end;
    var EmplLedgEntry: Record "Global Employee Ledger Entry";
    [IntegrationEvent(false, false)]
    local procedure OnBeforeEmplLedgEntryModify(var EmplLedgEntry: Record "Employee Ledger Entry"; FromEmplLedgEntry: Record "Employee Ledger Entry")
    begin
    end;
}
