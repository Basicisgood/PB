page 50147 "Consolidate Elimination"
{
    DelayedInsert = true;
    LinksAllowed = false;
    //MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Consolidate Elimination";
    ApplicationArea = all;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Rule; Rec.Rule)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Journal Name"; Rec."Journal Name")
                {
                    ApplicationArea = All;
                }
                field("Date Last Run"; Rec."Date Last Run")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
