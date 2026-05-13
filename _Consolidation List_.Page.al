page 50141 "Consolidation List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Consolidate;
    CardPageId = Consolidation;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("From Account"; Rec."From Account")
                {
                    ToolTip = 'Specifies the value of the From Account field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("To Account"; Rec."To Account")
                {
                    ToolTip = 'Specifies the value of the To Account field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("From Period"; Rec."From Period")
                {
                    ToolTip = 'Specifies the value of the From Period field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("To Period"; Rec."To Period")
                {
                    ToolTip = 'Specifies the value of the To Period field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("G/L Posting Date"; Rec."G/L Posting Date")
                {
                    ToolTip = 'Specifies the value of the G/L Posting Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Release Date"; Rec."Release Date")
                {
                    ToolTip = 'Specifies the value of the Release Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Include Actual Amounts"; Rec."Include Actual Amounts")
                {
                    ToolTip = 'Specifies the value of the Include Actual Amounts field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Proposal Options"; Rec."Proposal Options")
                {
                    ToolTip = 'Specifies the value of the Proposal Options field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ToolTip = 'Specifies the value of the Reason Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Reason Comment"; Rec."Reason Comment")
                {
                    ToolTip = 'Specifies the value of the Reason Comment field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Rebuild Bal. during Con. Proc."; Rec."Rebuild Bal. during Con. Proc.")
                {
                    ToolTip = 'Specifies the value of the Rebuild Balances during Consolidation Process field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
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
