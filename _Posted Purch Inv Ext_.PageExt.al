pageextension 50130 "Posted Purch Inv Ext" extends "Posted Purchase Invoice"
{
    layout
    {
        addlast(General)
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
