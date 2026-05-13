pageextension 50120 "Posted Sales Invoice_Ext" extends "Posted Sales Invoice"
{
    actions
    {
        addafter("&Invoice")
        {
            action(ImportFromXMLPort)
            {
                Caption = 'Import From XMLPort';
                ApplicationArea = All;
                RunObject = xmlport "Import Sales Inv";

                trigger OnAction()
                begin
                end;
            }
        }
    }
}
