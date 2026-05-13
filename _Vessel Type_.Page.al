page 50117 "Vessel Type"
{
    ApplicationArea = All;
    Caption = 'Vessel Type';
    PageType = List;
    SourceTable = "Vessel Type";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Vessel Type"; Rec."Vessel Type")
                {
                    ToolTip = 'Specifies the value of the Vessel Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
