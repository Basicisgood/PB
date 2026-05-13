page 50135 "Company Dimension Mapping"
{
    ApplicationArea = All;
    Caption = 'Counterparty types';
    PageType = List;
    SourceTable = "Vendor Type Mapping";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Vendor Type"; Rec."Vendor Type")
                {
                    ToolTip = 'Specifies the value of the Company Dimension Value field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Company Type"; Rec."Company Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Company Type field.', Comment = '%';
                }
                field("IMOS Company No"; Rec."IMOS Company No")
                {
                    ApplicationArea = all;
                }
                field("DAX No"; Rec."DAX No")
                {
                    ApplicationArea = all;
                }
                field(Sync; Rec.Sync)
                {
                    ToolTip = 'Specifies the value of the Sync field.', Comment = '%';
                    Editable = false;
                    ApplicationArea = all;
                }
            }
        }
    }
}
