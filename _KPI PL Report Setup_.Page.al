page 50283 "KPI PL Report Setup"
{ //PS013
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "KPI PL Report Setup";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Header; Rec.Header)
                {
                    ToolTip = 'Specifies the value of the Header field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Row Level"; Rec."Row Level")
                {
                    ToolTip = 'Specifies the value of the Row Level field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Account Group"; Rec."Account Group")
                {
                    ToolTip = 'Specifies the value of the Account Group field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {
        }
    }
    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                end;
            }
        }
    }
}
