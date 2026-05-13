pageextension 50149 "PE_AppyVendorEnteries" extends "Apply Vendor Entries"
{
    layout
    {
        addafter("External Document No.")
        {
            field("IMOS Transaction No"; Rec."IMOS Transaction No")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Ship Manager Id"; Rec."Ship Manager Id")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }
}
