pageextension 50100 VendorLedgerEntryExt extends "Vendor Ledger Entries"
{
    layout
    {
        modify("External Document No.")
        {
            Editable = true;
        }
        addafter("Shortcut Dimension 8 Code")
        {
            field("Shortcut Dimension 8 Code_PB"; Rec."Shortcut Dimension 8 Code_PB")
            {
                ApplicationArea = all;
            }
            field("Shortcut Dimension 9 Code_PB"; Rec."Shortcut Dimension 9 Code_PB")
            {
                ApplicationArea = all;
            }
            field("Shortcut Dimension 10 Code_PB"; Rec."Shortcut Dimension 10 Code_PB")
            {
                ApplicationArea = all;
            }
        }
        addafter("Document No.")
        {
            field("Invoice Link"; Rec."Invoice Link")
            {
                ApplicationArea = all;
            }
            field("Bank Document No."; Rec."Bank Document No.")
            {
                ApplicationArea = all;
            }
            field("Bank Document No. Applied"; Rec."Bank Document No. Applied")
            {
                ApplicationArea = all;
            }
        }
        addafter("Due Date")
        {
            field("Original Invoice No"; Rec."Original Invoice No")
            {
                ApplicationArea = All;
            }
            field("Payment Date"; Rec."Payment Date")
            {
                ApplicationArea = All;
            }
            field(Remarks; Rec.Remarks)
            {
                ApplicationArea = All;
            }
            field("Booking Method"; Rec."Booking Method")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Booking Method field.', Comment = '%';
            }
            field("PB DNV invoice"; Rec."PB DNV invoice")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PB DNV invoice field.', Comment = '%';
            }
            field("Exported to DNV"; Rec."Exported to DNV")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Exported to DNV field.', Comment = '%';
            }
            //PS006 Start
            field("Exported to Concur"; Rec."Exported to Concur")
            {
                ApplicationArea = all;
            }
            field("Record Type"; Rec."Record Type")
            {
                ApplicationArea = all;
            }
            field("PB Concur Invoice"; Rec."PB Concur Invoice")
            {
                ApplicationArea = all;
            }
            field("Ship Manager Id"; Rec."Ship Manager Id")
            {
                ApplicationArea = all;
            }
            field("IMOS Transaction"; Rec."IMOS Transaction")
            {
                ApplicationArea = all;
            }
            field("IMOS Transaction No"; Rec."IMOS Transaction No")
            {
                ApplicationArea = all;
            }
        //PS006 End
        }
        moveafter("Vendor Name"; RecipientBankAcc)
    }
    trigger OnModifyRecord(): Boolean var
        GlobalVendLEdgEntry: Record "Global Vendor Ledger Entry";
    begin
        GlobalVendLEdgEntry.Reset();
        GlobalVendLEdgEntry.SetRange("Company Name", CompanyName);
        GlobalVendLEdgEntry.SetRange("Entry No.", rec."Entry No.");
        if GlobalVendLEdgEntry.FindSet()then CODEUNIT.Run(CODEUNIT::"Global Vend. Entry-Edit", GlobalVendLEdgEntry);
        exit(false);
    end;
}
