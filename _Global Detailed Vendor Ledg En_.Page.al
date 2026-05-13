page 50186 "Global Detailed Vendor Ledg En"
{
    Caption = 'Global Detailed Vendor Ledg En';
    PageType = List;
    SourceTable = "GB Detailed Vendor Ledg. Entry";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ApplicationArea = all;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ToolTip = 'Specifies the value of the Amount (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Application No."; Rec."Application No.")
                {
                    ToolTip = 'Specifies the value of the Application No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Applied Vend. Ledger Entry No."; Rec."Applied Vend. Ledger Entry No.")
                {
                    ToolTip = 'Specifies the value of the Applied Vend. Ledger Entry No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Company Name"; Rec."Company Name")
                {
                    ToolTip = 'Specifies the value of the Company Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ToolTip = 'Specifies the value of the Credit Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Credit Amount (LCY)"; Rec."Credit Amount (LCY)")
                {
                    ToolTip = 'Specifies the value of the Credit Amount (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ToolTip = 'Specifies the value of the Debit Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debit Amount (LCY)"; Rec."Debit Amount (LCY)")
                {
                    ToolTip = 'Specifies the value of the Debit Amount (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ToolTip = 'Specifies the value of the Entry Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Exch. Rate Adjmt. Reg. No."; Rec."Exch. Rate Adjmt. Reg. No.")
                {
                    ToolTip = 'Specifies the value of the Exch. Rate Adjmt. Reg. No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Initial Document Type"; Rec."Initial Document Type")
                {
                    ToolTip = 'Specifies the value of the Initial Document Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Initial Entry Due Date"; Rec."Initial Entry Due Date")
                {
                    ToolTip = 'Specifies the value of the Initial Entry Due Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Initial Entry Global Dim. 1"; Rec."Initial Entry Global Dim. 1")
                {
                    ToolTip = 'Specifies the value of the Initial Entry Global Dim. 1 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Initial Entry Global Dim. 2"; Rec."Initial Entry Global Dim. 2")
                {
                    ToolTip = 'Specifies the value of the Initial Entry Global Dim. 2 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ToolTip = 'Specifies the value of the Journal Batch Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Ledger Entry Amount"; Rec."Ledger Entry Amount")
                {
                    ToolTip = 'Specifies the value of the Ledger Entry Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Max. Payment Tolerance"; Rec."Max. Payment Tolerance")
                {
                    ToolTip = 'Specifies the value of the Max. Payment Tolerance field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    ToolTip = 'Specifies the value of the Vendor Posting Group field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ToolTip = 'Specifies the value of the Reason Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Remaining Pmt. Disc. Possible"; Rec."Remaining Pmt. Disc. Possible")
                {
                    ToolTip = 'Specifies the value of the Remaining Pmt. Disc. Possible field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ToolTip = 'Specifies the value of the Source Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Tax Jurisdiction Code"; Rec."Tax Jurisdiction Code")
                {
                    ToolTip = 'Specifies the value of the Tax Jurisdiction Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    ToolTip = 'Specifies the value of the Transaction No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Unapplied; Rec.Unapplied)
                {
                    ToolTip = 'Specifies the value of the Unapplied field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Unapplied by Entry No."; Rec."Unapplied by Entry No.")
                {
                    ToolTip = 'Specifies the value of the Unapplied by Entry No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Use Tax"; Rec."Use Tax")
                {
                    ToolTip = 'Specifies the value of the Use Tax field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the value of the User ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ToolTip = 'Specifies the value of the VAT Bus. Posting Group field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ToolTip = 'Specifies the value of the VAT Prod. Posting Group field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Vendor Ledger Entry No."; Rec."Vendor Ledger Entry No.")
                {
                    ToolTip = 'Specifies the value of the Vendor Ledger Entry No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ToolTip = 'Specifies the value of the Vendor No. field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
