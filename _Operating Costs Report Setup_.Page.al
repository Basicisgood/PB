page 50285 "Operating Costs Report Setup"
{ //PS015
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Operating Costs Report Setup";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Table Name"; Rec."Table Name")
                {
                    ToolTip = 'Specifies the value of the Table Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("RMT List"; Rec."RMT List")
                {
                    ToolTip = 'Specifies the value of the RMT List field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Header; Rec.Header)
                {
                    ToolTip = 'Specifies the value of the Header field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Sub Header"; Rec."Sub Header")
                {
                    ToolTip = 'Specifies the value of the Sub Header field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Account Group"; Rec."Account Group")
                {
                    ToolTip = 'Specifies the value of the Account Group field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(FD10; Rec.FD10)
                {
                    ToolTip = 'Specifies the value of the FD10 field.', Comment = '%';
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
