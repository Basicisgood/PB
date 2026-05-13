pageextension 50152 AppliedVendorEntries extends "Applied Vendor Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field("Bank Document No."; Rec."Bank Document No.")
            {
                ApplicationArea = all;
            }
        }
    }
}
