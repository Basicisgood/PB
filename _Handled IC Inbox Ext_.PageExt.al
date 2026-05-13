pageextension 50147 "Handled IC Inbox Ext" extends "Handled IC Inbox Transactions"
{
    layout
    {
        addafter("Document Date")
        {
            field("Error Msg"; Rec."Error Msg")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("&Inbox Transaction")
        {
            action("Change to accepted")
            {
                ApplicationArea = All;
                Visible = false;

                trigger OnAction()
                var
                    HIC: Record "Handled IC Inbox Trans.";
                begin
                    Message('hi');
                    HIC.reset;
                    HIC.SetRange(Status, HIC.Status::Posted);
                    IF HIC.Findfirst then repeat HIC.Status:=HIC.Status::Accepted;
                            HIC.Modify();
                        until HIC.Next() = 0;
                end;
            }
        }
    }
}
