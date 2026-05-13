pageextension 50112 "UserSetup_Ext" extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field("Allow Force Reject Pmt Journal"; Rec."Allow Force Reject Pmt Journal")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Allow Force Reject Pmt Journal field.', Comment = '%';
            }
            field("Allow Inbound Edit/Delete"; Rec."Allow Inbound Edit/Delete")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Allow Inbound Edit/Delete field.', Comment = '%';

                TRIGGER OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
            //#323 TEC.VJ 30APR2025>>
            field("Allow Approval Undo"; Rec."Allow Undo Approval")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Allow Approval Undo field.', Comment = '%';

                TRIGGER OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
        //#323 TEC.VJ 30APR2025<<
        }
    }
    Procedure GetSelectedRecords(var UserSetup_p: Record "User Setup")
    var
        myInt: Integer;
    begin
        CurrPage.SetSelectionFilter(Rec);
        UserSetup_p.Copy(Rec);
        If UserSetup_p.Count = 0 then begin
            UserSetup_p.Copy(Rec);
            UserSetup_p.Mark(true);
        end;
    end;
}
