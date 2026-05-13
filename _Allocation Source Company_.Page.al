page 50209 "Allocation Source Company"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Allocation Source Company";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = All;
                }
                field("Last Source Amount get"; Rec."Last Source Amount get")
                {
                    ApplicationArea = All;
                }
                field("Last Get From Date"; Rec."Last Get From Date")
                {
                    ApplicationArea = All;
                }
                field("Last Get To Date"; Rec."Last Get To Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    var myInt: Integer;
}
