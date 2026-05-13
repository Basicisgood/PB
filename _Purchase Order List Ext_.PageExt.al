pageextension 50131 "Purchase Order List Ext" extends "Purchase Order List"
{
    layout
    {
        addlast(Control1)
        {
            field("Invoice Link"; Rec."Invoice Link")
            {
                ApplicationArea = all;
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = all;
            }
            field(SystemCreatedBy; Rec.SystemCreatedBy)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("Delete Invoiced")
        {
            action(Import)
            {
                Caption = 'Import From Excel';
                Image = ImportExcel;
                //PromotedCategory = Category20;
                RunObject = report "Import PO from Excel";
                ApplicationArea = all;

                trigger OnAction()
                begin
                end;
            }
        }
        addlast(Category_New)
        {
            actionref(Import_Promoted; Import)
            {
            }
        }
    }
}
