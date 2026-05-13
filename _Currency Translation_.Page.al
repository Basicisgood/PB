page 50145 "Currency Translation"
{
    DelayedInsert = true;
    LinksAllowed = false;
    //MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Currency Translation";
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
                field("Source Accounting Currency"; Rec."Source Accounting Currency")
                {
                    ApplicationArea = All;
                }
                field("From Account"; Rec."From Account")
                {
                    ApplicationArea = All;
                }
                field("To Account"; Rec."To Account")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
