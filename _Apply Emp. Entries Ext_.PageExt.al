pageextension 50146 "Apply Emp. Entries Ext" extends "Apply Employee Entries"
{
    layout
    {
        addafter("Payment Reference")
        {
            field("Receipt image ID"; Rec."Receipt image ID")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Receipt image ID field.', Comment = '%';
            }
        }
    }
    actions
    {
        addlast("&Application")
        {
            action(OpenImage)
            {
                ApplicationArea = all;
                Image = Confirm;
                Caption = 'Open Image';

                trigger OnAction()
                var
                    l_cdu_ConcurImageAPI: Codeunit "Concur Image API";
                begin
                    Clear(l_cdu_ConcurImageAPI);
                    l_cdu_ConcurImageAPI.GetExpenseImageUrl(Rec."Receipt image ID");
                end;
            }
        }
    }
}
