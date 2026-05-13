codeunit 50198 "Upd. ExchRates All Companies"
{
    trigger OnRun()
    begin
        UpdateExchangeRateCalculationTable();
    end;
    /*  local procedure ClearCurrency()
     var
         CurrencyXRate: Record "Currency Exchange Rate";
     begin
         CurrencyXRate.Reset();
         CurrencyXRate.ChangeCompany('USD_TEST');
         if CurrencyXRate.FindSet() then
             CurrencyXRate.DeleteAll();
     end; */
    local procedure UpdateCompaniesExchangeRate()
    var
        GLSetup: Record 98;
        CurrencyXRate: Record "Currency Exchange Rate";
        CurrencyXRate2: Record "Currency Exchange Rate";
        XRateCal: Record "Exchange Rate Calculation";
        Companies: Record "Company Name Mapping";
        Currency: Record Currency;
        Counter: Integer;
    begin
        Companies.Reset();
        Companies.SetRange("Master Data Company", false);
        if Companies.FindFirst()then repeat GLSetup.Reset();
                GLSetup.ChangeCompany(Companies."BC Company Name");
                if GLSetup.FindFirst()then;
                XRateCal.Reset();
                XRateCal.SetRange("Local Currency (LCY)", GLSetup."LCY Code");
                XRateCal.SetFilter("Starting Date", '<>%1', 0D);
                if XRateCal.FindSet()then repeat Currency.Reset();
                        Currency.ChangeCompany(Companies."BC Company Name");
                        Currency.SetRange(Code, XRateCal."Foreign Currency (FCY)");
                        if Currency.FindFirst()then begin
                            Clear(CurrencyXRate);
                            CurrencyXRate.ChangeCompany(Companies."BC Company Name");
                            CurrencyXRate.SetRange("Starting Date", XRateCal."Starting Date");
                            CurrencyXRate.SetRange("Currency Code", XRateCal."Foreign Currency (FCY)");
                            if not CurrencyXRate.FindFirst()then begin
                                CurrencyXRate.Init();
                                CurrencyXRate."Starting Date":=XRateCal."Starting Date";
                                CurrencyXRate."Currency Code":=XRateCal."Foreign Currency (FCY)";
                                CurrencyXRate."Exchange Rate Amount":=100;
                                CurrencyXRate."Adjustment Exch. Rate Amount":=100;
                                CurrencyXRate."Relational Exch. Rate Amount":=100 * XRateCal."Exchange Rate Amount";
                                CurrencyXRate."Relational Adjmt Exch Rate Amt":=100 * XRateCal."Exchange Rate Amount";
                                if CurrencyXRate.Insert()then;
                            end
                            else
                            begin
                                CurrencyXRate."Exchange Rate Amount":=100;
                                CurrencyXRate."Adjustment Exch. Rate Amount":=100;
                                CurrencyXRate."Relational Exch. Rate Amount":=100 * XRateCal."Exchange Rate Amount";
                                CurrencyXRate."Relational Adjmt Exch Rate Amt":=100 * XRateCal."Exchange Rate Amount";
                                if CurrencyXRate.Modify()then;
                            end;
                            CurrencyXRate2.Reset();
                            CurrencyXRate2.ChangeCompany(Companies."BC Company Name");
                            CurrencyXRate2.SetFilter("Starting Date", '<%1', XRateCal."Starting Date");
                            CurrencyXRate2.SetRange("Currency Code", XRateCal."Foreign Currency (FCY)");
                            if CurrencyXRate2.FindLast()then begin
                                CurrencyXRate2."Relational Adjmt Exch Rate Amt":=100 * XRateCal."Exchange Rate Amount";
                                CurrencyXRate2.Modify();
                            end;
                        end;
                    until XRateCal.Next() = 0;
            /* Currency.Reset();
            Currency.ChangeCompany(Companies."BC Company Name");
            if Currency.FindFirst() then
                repeat
                    Counter := 1;
                    CurrencyXRate.Reset();
                    CurrencyXRate.ChangeCompany(Companies."BC Company Name");
                    CurrencyXRate.SetRange("Currency Code", Currency.Code);
                    CurrencyXRate.Ascending(false);
                    if CurrencyXRate.FindFirst() then
                        repeat
                            if Counter <= 2 then begin
                                CurrencyXRate2.Reset();
                                CurrencyXRate2.ChangeCompany(Companies."BC Company Name");
                                CurrencyXRate2.SetRange("Currency Code", Currency.Code);
                                CurrencyXRate2.SetFilter("Starting Date", '<%1', CurrencyXRate."Starting Date");
                                if CurrencyXRate2.FindLast() then begin
                                    CurrencyXRate."Relational Exch. Rate Amount" := CurrencyXRate2."Relational Adjmt Exch Rate Amt";
                                    if CurrencyXRate.Modify() then;
                                end;
                                counter += 1;
                            end;
                        until CurrencyXRate.Next() = 0;
                until Currency.Next() = 0; */
            until Companies.Next = 0;
    end;
    local procedure UpdateExchangeRateCalculationTable()
    var
        l_rec_ExchangeCal: Record "Exchange Rate Calculation";
        l_rec_Currency: Record Currency;
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        ExchangeRateDate: Date;
        USDToLCYRate: Decimal;
        USDToFCYRate: Decimal;
        l_rec_CompanyMapping: Record "Company Name Mapping";
        CurrenciesToCalculate: Record Currency;
        lastDate: Date;
    begin
        if l_rec_CompanyMapping.Get(CompanyName)then if not l_rec_CompanyMapping."Master Data Company" then exit;
        l_rec_ExchangeCal.Reset();
        if l_rec_ExchangeCal.FindSet()then l_rec_ExchangeCal.DeleteAll();
        CurrenciesToCalculate.Reset();
        CurrenciesToCalculate.SetRange("Need to calculate", true);
        CurrenciesToCalculate.setfilter(Code, '<>USD');
        if CurrenciesToCalculate.FindSet()then repeat l_rec_Currency.Reset();
                if l_rec_Currency.FindFirst()then repeat Clear(l_rec_ExchangeCal);
                        CurrencyExchangeRate.GetLastestExchangeRate(l_rec_Currency.Code, ExchangeRateDate, USDToFCYRate);
                        CurrencyExchangeRate.GetLastestExchangeRate(CurrenciesToCalculate.Code, ExchangeRateDate, USDToLCYRate);
                        l_rec_ExchangeCal.Init();
                        l_rec_ExchangeCal."Starting Date":=ExchangeRateDate;
                        lastDate:=ExchangeRateDate;
                        l_rec_ExchangeCal."Local Currency (LCY)":=CurrenciesToCalculate.Code;
                        l_rec_ExchangeCal."Foreign Currency (FCY)":=l_rec_Currency.Code;
                        if USDToLCYRate <> 0 then l_rec_ExchangeCal."Exchange Rate Amount":=USDToFCYRate / USDToLCYRate;
                        if l_rec_ExchangeCal.Insert()then;
                    /*  Clear(l_rec_ExchangeCal);
                     GetPreviousExchangeRate(l_rec_Currency.Code, ExchangeRateDate, USDToFCYRate, lastDate);
                     GetPreviousExchangeRate(CurrenciesToCalculate.Code, ExchangeRateDate, USDToLCYRate, lastDate);
                     l_rec_ExchangeCal.Init();
                     l_rec_ExchangeCal."Starting Date" := ExchangeRateDate;
                     l_rec_ExchangeCal."Local Currency (LCY)" := CurrenciesToCalculate.Code;
                     l_rec_ExchangeCal."Foreign Currency (FCY)" := l_rec_Currency.Code;
                     if USDToLCYRate <> 0 then
                         l_rec_ExchangeCal."Exchange Rate Amount" := USDToFCYRate / USDToLCYRate;
                     if l_rec_ExchangeCal.Insert() then; */
                    until l_rec_Currency.Next() = 0;
            until CurrenciesToCalculate.Next() = 0;
        InsertUSDEntries();
        UpdateCompaniesExchangeRate;
    end;
    local procedure GetPreviousExchangeRate(CurrencyCode: Code[10]; var Date: Date; var Amt: Decimal; lastDate: date)
    var
        l_rec_CurrExchRate: Record "Currency Exchange Rate";
    begin
        Date:=0D;
        Amt:=0;
        l_rec_CurrExchRate.Reset();
        l_rec_CurrExchRate.SetRange("Currency Code", CurrencyCode);
        l_rec_CurrExchRate.SetFilter("Starting Date", '<%1', lastDate);
        if l_rec_CurrExchRate.FindLast()then begin
            Date:=l_rec_CurrExchRate."Starting Date";
            if l_rec_CurrExchRate."Exchange Rate Amount" <> 0 then Amt:=l_rec_CurrExchRate."Relational Exch. Rate Amount" / l_rec_CurrExchRate."Exchange Rate Amount";
        end;
    end;
    local procedure InsertUSDEntries()
    var
        l_rec_ExchangeCal: Record "Exchange Rate Calculation";
        l_rec_Currency: Record Currency;
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        ExchangeRateDate: Date;
        USDToFCYRate: Decimal;
        lastDate: Date;
    begin
        l_rec_Currency.Reset();
        if l_rec_Currency.FindFirst()then repeat Clear(l_rec_ExchangeCal);
                CurrencyExchangeRate.GetLastestExchangeRate(l_rec_Currency.Code, ExchangeRateDate, USDToFCYRate);
                l_rec_ExchangeCal.Init();
                l_rec_ExchangeCal."Starting Date":=ExchangeRateDate;
                lastDate:=ExchangeRateDate;
                l_rec_ExchangeCal."Local Currency (LCY)":='USD';
                l_rec_ExchangeCal."Foreign Currency (FCY)":=l_rec_Currency.Code;
                l_rec_ExchangeCal."Exchange Rate Amount":=USDToFCYRate;
                if l_rec_ExchangeCal.Insert()then;
            /*  Clear(l_rec_ExchangeCal);
             GetPreviousExchangeRate(l_rec_Currency.Code, ExchangeRateDate, USDToFCYRate, lastDate);
             l_rec_ExchangeCal.Init();
             l_rec_ExchangeCal."Starting Date" := ExchangeRateDate;
             l_rec_ExchangeCal."Local Currency (LCY)" := 'USD';
             l_rec_ExchangeCal."Foreign Currency (FCY)" := l_rec_Currency.Code;
             l_rec_ExchangeCal."Exchange Rate Amount" := USDToFCYRate;
             if l_rec_ExchangeCal.Insert() then; */
            until l_rec_Currency.Next() = 0;
    end;
}
