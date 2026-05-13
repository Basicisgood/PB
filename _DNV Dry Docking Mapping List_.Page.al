page 50115 "DNV Dry Docking Mapping List"
{
    ApplicationArea = All;
    Caption = 'DNV Dry Docking Mapping List';
    PageType = List;
    SourceTable = "DNV Dry Dock GL Mapping";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("GL Account From"; Rec."GL Account From")
                {
                    ToolTip = 'Specifies the value of the GL Account From field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("GL Mapping To"; Rec."GL Account To")
                {
                    ToolTip = 'Specifies the value of the GL Mapping To field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
