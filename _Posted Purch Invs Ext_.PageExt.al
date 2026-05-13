pageextension 50124 "Posted Purch Invs Ext" extends "Posted Purchase Invoices"
{
    layout
    {
        addlast(Control1)
        {
            field("Invoice Link"; Rec."Invoice Link")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Invoice Link field.';
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the SystemCreatedAt field.';
            }
            field(SystemCreatedBy; Rec.SystemCreatedBy)
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the SystemCreatedBy field.';
            }
        }
    }
}
