page 50140 "Citi Inbound Statement Id"
{
    ApplicationArea = All;
    Caption = 'Citi Inbound Statement Id';
    PageType = List;
    SourceTable = "Citi Inbound Statement Id";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Statement Id"; Rec."Statement Id")
                {
                    ToolTip = 'Specifies the value of the Statement Id field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Account No. field.';
                }
                field("Format Name"; Rec."Format Name")
                {
                    ToolTip = 'Specifies the value of the Format Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Retrieved; Rec.Retrieved)
                {
                    ToolTip = 'Specifies the value of the Retrieved field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }
                field("Error Msg"; Rec."Error Msg")
                {
                    ToolTip = 'Specifies the value of the Error Msg field.';
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(InitStatements52)
            {
                ApplicationArea = All;
                ToolTip = 'Executes the InitStatements52 action.';

                trigger OnAction()
                begin
                    Codeunit.Run(Codeunit::"Citi Init Statement 52");
                end;
            }
            action(InitStatements53)
            {
                ApplicationArea = All;
                ToolTip = 'Executes the InitStatements53 action.';

                trigger OnAction()
                begin
                    Codeunit.Run(Codeunit::"Citi Init Statement 53");
                end;
            }
        }
    }
}
