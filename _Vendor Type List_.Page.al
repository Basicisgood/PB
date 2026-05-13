page 50250 "Vendor Type List"
{
    ApplicationArea = All;
    Caption = 'Vendor Type List';
    PageType = List;
    SourceTable = "Vendor Type Mapping";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Vendor/Customer No."; Rec."Vendor/Customer No.")
                {
                    ToolTip = 'Specifies the value of the Vendor/Customer No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(VendorName; VendorName)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Vendor Type Dimension"; Rec."Vendor Type Dimension")
                {
                    ToolTip = 'Specifies the value of the Vendor Type Dimension field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Vendor Type"; Rec."Vendor Type")
                {
                    ToolTip = 'Specifies the value of the Company Dimension Value field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Company Type"; Rec."Company Type")
                {
                    ToolTip = 'Specifies the value of the Company Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("DAX No"; Rec."DAX No")
                {
                    ToolTip = 'Specifies the value of the DAX No field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("IMOS Company No"; Rec."IMOS Company No")
                {
                    ToolTip = 'Specifies the value of the IMOS Company No field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(DNVVendorNo; DNVVendorNo)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        DNVVendorNo:='';
        VendorName:='';
        if rec.Type = rec.Type::Vendor then begin
            if vendor.Get(rec."Vendor/Customer No.")then begin
                DNVVendorNo:=vendor."DNV Vendor No.";
                VendorName:=vendor.Name;
            end;
        end;
    end;
    var vendor: Record Vendor;
    DNVVendorNo: Text;
    VendorName: Text;
}
