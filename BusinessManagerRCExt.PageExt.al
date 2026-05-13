pageextension 50154 BusinessManagerRCExt extends "Business Manager Role Center"
{
    layout
    {
        addafter(Control16)
        {
            part(BankAPILogList; BankAPILogList)
            {
                ApplicationArea = all;
            }
        }
    }
}
