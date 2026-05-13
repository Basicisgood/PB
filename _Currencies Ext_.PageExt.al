pageextension 50123 "Currencies Ext" extends Currencies
{
    layout
    {
        addfirst(Control1)
        {
            field("Need to calculate"; Rec."Need to calculate")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action(UpdateAllCompanies)
            {
                Caption = 'Update All Companies';
                ApplicationArea = all;

                trigger OnAction()
                begin
                    Codeunit.Run(Codeunit::"Upd. ExchRates All Companies");
                    Message('Currencies updated');
                end;
            }
        }
        addlast(Category_Category4)
        {
            actionref(UpdateAllCompanies_Promoted; UpdateAllCompanies)
            {
            }
        }
    }
}
