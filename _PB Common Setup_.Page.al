page 50247 "PB Common Setup"
{
    ApplicationArea = All;
    Caption = 'PB Common Setup';
    PageType = Card;
    SourceTable = "PB Common Setup";
    UsageCategory = Administration;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Central Payment Template Name"; Rec."Central Payment Template Name")
                {
                    ToolTip = 'Specifies the value of the Central Payment Template Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Central Payment Batch Name"; Rec."Central Payment Batch Name")
                {
                    ToolTip = 'Specifies the value of the Central Payment Batch Name field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ProcessLine)
            {
                ApplicationArea = All;
                Caption = 'Table Information';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                RunObject = page 8700;

                trigger OnAction()
                var
                begin
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        if not rec.get then rec.Insert();
    end;
}
