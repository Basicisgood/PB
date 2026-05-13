page 50267 "DBase Setup"
{
    ApplicationArea = All;
    Caption = 'DBase Setup';
    PageType = List;
    SourceTable = "DBase Setup";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(DBase; Rec.DBase)
                {
                    ToolTip = 'Specifies the value of the DBase field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
