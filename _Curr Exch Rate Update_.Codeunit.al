codeunit 50140 "Curr Exch Rate Update"
{
    //TableNo = "Exch Rate Details";
    trigger OnRun()
    var
        CuuExchRateDetail: record "Exch Rate Details";
        CurrExchRate: record "Currency Exchange Rate";
        Currency: record Currency;
        CalcDateF: Text;
        NewDate: Date;
    begin
        exit;
        CalcDateF:='<CM+1D>';
        CuuExchRateDetail.Reset();
        CuuExchRateDetail.SetFilter("Exchange Rate", '<>%1', 0);
        CuuExchRateDetail.SetRange(Synched, false);
        if CuuExchRateDetail.FindSet()then repeat if Currency.get(CuuExchRateDetail."Currency Code")then begin
                    CurrExchRate.Reset();
                    CurrExchRate.SetRange("Currency Code", CuuExchRateDetail."Currency Code");
                    if CurrExchRate.FindLast()then begin
                        CurrExchRate."Relational Adjmt Exch Rate Amt":=CuuExchRateDetail."Converted Rate" * 100;
                        CurrExchRate.Modify();
                    end;
                    NewDate:=CalcDate(CalcDateF, DT2Date(CuuExchRateDetail.Date));
                    CurrExchRate.Init();
                    CurrExchRate."Currency Code":=Currency.Code;
                    CurrExchRate."Starting Date":=NewDate;
                    CurrExchRate."Exchange Rate Amount":=100;
                    CurrExchRate."Relational Exch. Rate Amount":=CuuExchRateDetail."Converted Rate" * 100;
                    CurrExchRate."Adjustment Exch. Rate Amount":=100;
                    CurrExchRate."Relational Adjmt Exch Rate Amt":=CuuExchRateDetail."Converted Rate" * 100;
                    CurrExchRate."Fix Exchange Rate Amount":=CurrExchRate."Fix Exchange Rate Amount"::Currency;
                    CurrExchRate."Converted Rate":=CuuExchRateDetail."Exchange Rate";
                    if not CurrExchRate.Insert()then CurrExchRate.Modify();
                    CuuExchRateDetail.Synched:=true;
                    CuuExchRateDetail.Modify();
                    CurrExchRate.CreateOutboundLogForIMOS(0);
                    CurrExchRate.CreateOutboundLog(0);
                    CurrExchRate.CreateOutboundLogForConcur(0); //PS004
                end;
            //end;
            until CuuExchRateDetail.Next() = 0;
        Codeunit.Run(Codeunit::"Upd. ExchRates All Companies"); //TEC#001
    end;
}
