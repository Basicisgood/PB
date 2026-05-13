pageextension 50133 "Purchase Order" extends "Purchase Order"
{
    layout
    {
        addafter("Purchaser Code")
        {
            field("Invoice Link"; Rec."Invoice Link")
            {
                Editable = true;
                ApplicationArea = All;
                Caption = 'Invoice Link';
                ToolTip = 'Specifies the value of the Invoice Link field.';
            }
        }
    }
}
