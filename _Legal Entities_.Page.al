page 50144 "Legal Entities"
{
    DelayedInsert = true;
    LinksAllowed = false;
    //MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Legal Entity";
    ApplicationArea = all;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Source Legal Entity"; Rec."Source Legal Entity")
                {
                    ApplicationArea = All;
                }
                field(Share; Rec.Share)
                {
                    ApplicationArea = All;
                }
                field("Acc. Type of Conversion Diff."; Rec."Acc. Type of Conversion Diff.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
