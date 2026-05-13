pageextension 50153 PurchaseCreditMemo extends "Purchase Credit Memo"
{
    layout
    {
        addlast(General)
        {
            field("Invoice Link"; Rec."Invoice Link")
            {
                ApplicationArea = all;
            }
        }
    }
}
