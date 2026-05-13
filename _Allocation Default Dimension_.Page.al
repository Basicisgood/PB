page 50201 "Allocation Default Dimension"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Allocation Default Dimension";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(Repeater)
            {
                field("Dimension Code"; Rec."Dimension Code")
                {
                    ApplicationArea = All;
                }
                field("Dimension Value Code"; Rec."Dimension Value Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    var myInt: Integer;
}
