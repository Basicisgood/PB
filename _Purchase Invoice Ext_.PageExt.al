pageextension 50110 "Purchase Invoice Ext" extends "Purchase Invoice"
{
    layout
    {
        addlast(General)
        {
            field("Invoice Link"; Rec."Invoice Link")
            {
                ApplicationArea = All;
                Caption = 'Invoice Link';
                ToolTip = 'Specifies the value of the Invoice Link field.';
            }
            field("PB DNV invoice"; Rec."PB DNV invoice")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PB DNV invoice field.', Comment = '%';
            }
            field("DNV Approved At"; Rec."DNV Approved At")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the DNV Approved At field.', Comment = '%';
            }
            field("DNV Approved By"; Rec."DNV Approved By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the DNV Approved By field.', Comment = '%';
            }
            field("PB Ship Manager ID"; Rec."PB Ship Manager ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PB Ship Manager ID field.', Comment = '%';
            }
        // field("Sharepoint Link"; Rec."Sharepoint Link")
        // {
        //     ApplicationArea = All;
        //     ToolTip = 'Specifies the value of the Sharepoint Link field.';
        // }
        }
    }
}
