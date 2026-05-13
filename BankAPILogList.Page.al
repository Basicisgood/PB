page 50273 BankAPILogList
{
    ApplicationArea = All;
    Caption = 'BankAPILogList';
    PageType = CardPart;

    layout
    {
        area(Content)
        {
            cuegroup(NoOfErrorRec)
            {
                ShowCaption = false;

                field(NoOfErrors; l_int_CountRecords)
                {
                    ApplicationArea = all;
                    caption = 'API Error';

                    trigger OnDrillDown()
                    begin
                        CLEAR(l_pag_GlobalBankAPILog);
                        l_pag_GlobalBankAPILog.Run();
                    end;
                }
            }
            cuegroup(NoOfSendOrError)
            {
                ShowCaption = false;

                field(NoOfErrors2; l_int_CountRecords2)
                {
                    ApplicationArea = all;
                    caption = 'HSBC Out Sent or Error';

                    trigger OnDrillDown()
                    begin
                        CLEAR(l_pag_GlobalHSBCLog);
                        l_pag_GlobalHSBCLog.Run();
                    end;
                }
            }
            cuegroup(NoOfSendOrError2)
            {
                ShowCaption = false;

                field(NoOfErrors3; l_int_CountRecords3)
                {
                    ApplicationArea = all;
                    caption = 'Citi Out Sent or Error';

                    trigger OnDrillDown()
                    begin
                        CLEAR(l_pag_GlobalCitiLog);
                        l_pag_GlobalCitiLog.Run();
                    end;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        CLEAR(l_pag_GlobalBankAPILog);
        //l_pag_GlobalBankAPILog.PassDate(CALCDATE('<-1W>', TODAY), TODAY);
        l_int_CountRecords:=l_pag_GlobalBankAPILog.CountRecords(TRUE);
        Clear(l_pag_GlobalHSBCLog);
        l_int_CountRecords2:=l_pag_GlobalHSBCLog.CountRecords(TRUE);
        Clear(l_pag_GlobalCitiLog);
        l_int_CountRecords3:=l_pag_GlobalCitiLog.CountRecords(TRUE);
    end;
    var l_pag_GlobalBankAPILog: Page "Global Bank API Log Error List";
    l_int_CountRecords: integer;
    l_pag_GlobalHSBCLog: Page "GlobalHSBCOutSentOrError";
    l_int_CountRecords2: Integer;
    l_pag_GlobalCitiLog: Page "GlobalCitiOutSentOrError";
    l_int_CountRecords3: Integer;
}
