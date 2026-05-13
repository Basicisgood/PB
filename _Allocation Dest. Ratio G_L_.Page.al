page 50210 "Allocation Dest. Ratio G/L"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Allocation Dest. Ratio G/L";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Field Setting"; Rec."Field Setting")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Source Criteria"; Rec."Source Criteria")
                {
                    ApplicationArea = All;
                }
                field(Subtraction; Rec.Subtraction)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    var myInt: Integer;
}
