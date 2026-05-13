page 50168 "IMOS Vessel Type FD1 Mapping"
{
    ApplicationArea = All;
    Caption = 'IMOS Vessel Type FD1 Mapping';
    PageType = List;
    SourceTable = "IMOS Vessel type FD1 Linkage";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Vessel Type"; Rec."Vessel Type")
                {
                    ToolTip = 'Specifies the value of the Vessel Type field.', Comment = '%';
                }
                field("FD1 Dimension Value"; Rec."FD1 Dimension Value")
                {
                    ToolTip = 'Specifies the value of the FD1 Dimension Value field.', Comment = '%';
                }
            }
        }
    }
}
