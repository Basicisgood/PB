page 50219 "Worldlink Spot Rate"
{
    ApplicationArea = All;
    Caption = 'Worldlink Guarantee Rate';
    PageType = List;
    SourceTable = "Worldlink Spot Rate";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("From Currency"; Rec."From Currency")
                {
                    ToolTip = 'Specifies the value of the From Currency field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("To Currency"; Rec."To Currency")
                {
                    ToolTip = 'Specifies the value of the To Currency field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Rate; Rec.Rate)
                {
                    ToolTip = 'Specifies the value of the Rate field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Spot Rate")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Codeunit.Run(Codeunit::"Worldlink Spot Rate Job");
                end;
            }
            action("Clear table")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.DeleteAll();
                end;
            }
        }
    }
}
