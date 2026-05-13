page 50284 "Concur Date Dialog Page"
{
    ApplicationArea = All;
    Caption = 'Concur Date Dialog Page';
    PageType = StandardDialog;

    layout
    {
        area(Content)
        {
            field(g_dat_Date; g_dat_Date)
            {
                Caption = 'Posting Date';
                ApplicationArea = All;
            }
        }
    }
    var g_dat_Date: Date;
    procedure GetData(): Date begin
        exit(g_dat_Date);
    end;
}
