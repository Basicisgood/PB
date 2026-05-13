page 50185 "Global Vendor Ledger Entries"
{
    ApplicationArea = All;
    Caption = 'Global Vendor Ledger Entries';
    PageType = List;
    SourceTable = "Global Vendor Ledger Entry";
    UsageCategory = Lists;
    // Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;

    //ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Company Code"; Rec."Company Code")
                {
                    ToolTip = 'Specifies the value of the Company Name field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ToolTip = 'Specifies the value of the Vendor No. field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ToolTip = 'Specifies the value of the Vendor Name field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Recipient Bank Account"; Rec."Recipient Bank Account")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Bank Document No."; Rec."Bank Document No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Bank Document No. Applied"; Rec."Bank Document No. Applied")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("CP External Document No"; Rec."CP External Document No")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ToolTip = 'Specifies the value of the Due Date field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ToolTip = 'Specifies the value of the Amount (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Closed at Date"; Rec."Closed at Date")
                {
                    ToolTip = 'Specifies the value of the Closed at Date field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Closed by Amount"; Rec."Closed by Amount")
                {
                    ToolTip = 'Specifies the value of the Closed by Amount field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Closed by Amount (LCY)"; Rec."Closed by Amount (LCY)")
                {
                    ToolTip = 'Specifies the value of the Closed by Amount (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Exported to DNV"; Rec."Exported to DNV")
                {
                    ToolTip = 'Specifies the value of the Exported to DNV field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ToolTip = 'Specifies the value of the External Document No. field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Invoice Link"; Rec."Invoice Link")
                {
                    ToolTip = 'Specifies the value of the Invoice Link field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Message to Recipient"; Rec."Message to Recipient")
                {
                    ToolTip = 'Specifies the value of the Message to Recipient field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("On Hold"; Rec."On Hold")
                {
                    ToolTip = 'Specifies the value of the On Hold field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Open; Rec.Open)
                {
                    ToolTip = 'Specifies the value of the Open field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Original Amount"; Rec."Original Amount")
                {
                    ToolTip = 'Specifies the value of the Original Amount field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Original Amt. (LCY)"; Rec."Original Amt. (LCY)")
                {
                    ToolTip = 'Specifies the value of the Original Amt. (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Payment Date"; Rec."Payment Date")
                {
                    ToolTip = 'Specifies the value of the Payment Date field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ToolTip = 'Specifies the value of the Payment Method Code field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ToolTip = 'Specifies the value of the Reason Code field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ToolTip = 'Specifies the value of the Remaining Amount field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Remaining Amt. (LCY)"; Rec."Remaining Amt. (LCY)")
                {
                    ToolTip = 'Specifies the value of the Remaining Amt. (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Reversed; Rec.Reversed)
                {
                    ToolTip = 'Specifies the value of the Reversed field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Ship Manager Id"; Rec."Ship Manager Id")
                {
                    ToolTip = 'Specifies the value of the Ship Manager Id field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shortcut Dimension 10 Code_PB"; Rec."Shortcut Dimension 10 Code_PB")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 10 Code_pb field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shortcut Dimension 3 Code_PB"; Rec."Shortcut Dimension 3 Code_PB")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code_pb field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shortcut Dimension 4 Code_PB"; Rec."Shortcut Dimension 4 Code_PB")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code_pb field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shortcut Dimension 5 Code_PB"; Rec."Shortcut Dimension 5 Code_PB")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 5 Code_pb field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shortcut Dimension 6 Code_PB"; Rec."Shortcut Dimension 6 Code_PB")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 6 Code_pb field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shortcut Dimension 7 Code_PB"; Rec."Shortcut Dimension 7 Code_PB")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 7 Code_pb field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shortcut Dimension 8 Code_PB"; Rec."Shortcut Dimension 8 Code_PB")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 8 Code_pb field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shortcut Dimension 9 Code_PB"; Rec."Shortcut Dimension 9 Code_PB")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 9 Code_pb field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the value of the User ID field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                //>>VJ 15Jan2025
                field("IMOS Transaction"; Rec."IMOS Transaction")
                {
                    ToolTip = 'Specifies the value of the IMOS Transaction field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("IMOS Transaction No"; Rec."IMOS Transaction No")
                {
                    ToolTip = 'Specifies the value of the IMOS Transaction No field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("IMOS Bank ID"; Rec."IMOS Bank ID")
                {
                    ToolTip = 'Specifies the value of the IMOS Bank ID field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
            //<<VJ 15Jan2025
            }
        }
    }
    actions
    {
        area(navigation)
        {
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                Image = Entry;

                action(AppliedEntries)
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Applied E&ntries';
                    Image = Approve;
                    RunObject = Page "GB Applied Vendor Entries";
                    RunPageOnRec = true;
                    Scope = Repeater;
                    ToolTip = 'View the ledger entries that have been applied to this record.';
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Scope = Repeater;
                    ShortCutKey = 'Alt+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions();
                    end;
                }
                action("Detailed &Ledger Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Detailed &Ledger Entries';
                    Image = View;
                    RunObject = Page "Global Detailed Vendor Ledg En";
                    RunPageLink = "Vendor Ledger Entry No."=field("Entry No."), "Vendor No."=field("Vendor No."), "Company Name"=field("Company Name");
                    RunPageView = sorting("Vendor Ledger Entry No.", "Posting Date");
                    Scope = Repeater;
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View a summary of the all posted entries and adjustments related to a specific vendor ledger entry';
                }
            }
        }
        area(Promoted)
        {
            group(Category_Category4)
            {
                Caption = 'Entry', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref(Dimensions_Promoted; Dimensions)
                {
                }
                actionref(AppliedEntries_Promoted; AppliedEntries)
                {
                }
                actionref("Detailed &Ledger Entries_Promoted"; "Detailed &Ledger Entries")
                {
                }
            }
        }
    }
}
