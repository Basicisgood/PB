tableextension 50115 "Currency Exch. Rate" extends "Currency Exchange Rate"
{
    fields
    {
        field(50001; "Converted Rate"; Decimal)
        {
            Editable = false;
            DecimalPlaces = 2: 10;
        }
    }
    trigger OnInsert()
    begin
        //CreateOutboundLog(0);//TEC.VJ 11082024
        CreateOutboundLogForIMOS(0); //TEC.VJ 13092024
    end;
    trigger OnModify()
    begin
    // UpdateExchangeRateCalculationTable(); //TEC#001
    end;
    procedure CreateOutboundLog(P_Type: Option Insert, Update)
    var
        OutboundLog: Record "DNV Outbound Log";
        Log: Record "DNV Outbound Log";
    begin
        Log.Reset;
        Log.SetCurrentKey("Table No.", "Primary key", Status);
        Log.SetRange("Table No.", Database::"Currency Exchange Rate");
        Log.SetRange("Primary key", Rec."Currency Code");
        Log.SetRange("Primary key 2", Format(Rec."Starting Date"));
        Log.SetFilter(Status, '<>%1', Log.Status::Success);
        if not Log.FindFirst()then begin
            OutboundLog.Init();
            OutboundLog."Table No.":=Database::"Currency Exchange Rate";
            OutboundLog."Primary key":=Rec."Currency Code";
            OutboundLog."Primary key 2":=Format(Rec."Starting Date");
            OutboundLog."Entry Type":=P_Type;
            OutboundLog.Status:=OutboundLog.Status::Pending;
            OutboundLog."Company Name":=CompanyName;
            OutboundLog.Insert(true);
        end;
    end;
    //TEC.VJ 13092024>>
    //PS004 Start
    procedure CreateOutboundLogForConcur(P_Type: Option Insert, Update)
    var
        OutboundLog: Record "Concur Outbound Log";
        Log: Record "Concur Outbound Log";
    begin
        Log.Reset;
        Log.SetCurrentKey("Table No.", "Primary key", Status);
        Log.SetRange("Table No.", Database::"Currency Exchange Rate");
        Log.SetRange("Primary key", Rec."Currency Code");
        Log.SetRange("Primary key 2", Format(Rec."Starting Date"));
        Log.SetFilter(Status, '<>%1', Log.Status::Success);
        if not Log.FindFirst()then begin
            OutboundLog.Init();
            OutboundLog."Table No.":=Database::"Currency Exchange Rate";
            OutboundLog."Table Name":=rec.TableName;
            OutboundLog."Primary key":=Rec."Currency Code";
            OutboundLog."Primary key 2":=Format(Rec."Starting Date", 0, '<Year4>-<Month,2>-<Day,2>');
            OutboundLog."Entry Type":=P_Type;
            OutboundLog.Status:=OutboundLog.Status::Pending;
            OutboundLog."Company Name":=CompanyName;
            OutboundLog.Insert(true);
        end;
    end;
    //PS004 End
    procedure CreateOutboundLogForIMOS(P_Type: Option Insert, Update)
    var
        IMOSOutboundLog: Record "IMOS API Log";
        Log: Record "IMOS API Log";
    begin
        if Rec."Currency Code" = '' then exit;
        Log.Reset;
        Log.SetCurrentKey("Table No.", "Primary key", Status);
        Log.SetRange("Table No.", Database::"Currency Exchange Rate");
        Log.SetRange("Primary key 2", Rec."Currency Code");
        //Log.SetRange("Primary key 3", Format(Rec."Starting Date"));
        log.SetRange("Currency Exch Start Date", Rec."Starting Date");
        Log.SetFilter(Status, '<>%1', Log.Status::Success);
        if not Log.FindFirst()then begin
            IMOSOutboundLog.Init();
            IMOSOutboundLog."Table No.":=Database::"Currency Exchange Rate";
            IMOSOutboundLog."Primary key 2":=Rec."Currency Code";
            IMOSOutboundLog."Primary key 3":=Format(Rec."Starting Date");
            IMOSOutboundLog."Entry Type":=P_Type;
            IMOSOutboundLog.Status:=IMOSOutboundLog.Status::Pending;
            IMOSOutboundLog."Currency Exch Start Date":=Rec."Starting Date";
            IMOSOutboundLog.Insert(true);
        end;
    end;
    //TEC.VJ 13092024<<
    local procedure UpdateCompaniesExchangeRate()
    var
        GLSetup: Record "General Ledger Setup";
        CurrencyXRate: Record "Currency Exchange Rate";
        XRateCal: Record "Exchange Rate Calculation";
        Companies: Record "Company Name Mapping";
        Currency: Record Currency;
        Found: Boolean;
    begin
        Companies.Reset();
        Companies.SetRange("Master Data Company", false);
        if Companies.FindFirst()then repeat GLSetup.Reset();
                GLSetup.ChangeCompany(Companies."BC Company Name");
                if GLSetup.FindFirst()then;
                XRateCal.Reset();
                XRateCal.SetRange("Local Currency (LCY)", GLSetup."LCY Code");
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
                                Found:=false;
                            end
                            else
                                Found:=true;
                            CurrencyXRate."Exchange Rate Amount":=100;
                            CurrencyXRate."Adjustment Exch. Rate Amount":=100;
                            CurrencyXRate."Relational Adjmt Exch Rate Amt":=100 * XRateCal."Exchange Rate Amount";
                            if Found then begin
                                if CurrencyXRate.Modify()then;
                            end
                            else
                            begin
                                if CurrencyXRate.Insert()then;
                            end;
                            Clear(CurrencyXRate);
                            CurrencyXRate.ChangeCompany(Companies."BC Company Name");
                            CurrencyXRate.SetRange("Starting Date", CalcDate('+1M', XRateCal."Starting Date"));
                            CurrencyXRate.SetRange("Currency Code", XRateCal."Foreign Currency (FCY)");
                            if not CurrencyXRate.FindFirst()then begin
                                CurrencyXRate.Init();
                                CurrencyXRate."Starting Date":=CalcDate('+1M', XRateCal."Starting Date");
                                CurrencyXRate."Currency Code":=XRateCal."Foreign Currency (FCY)";
                                Found:=false;
                            end
                            else
                                Found:=true;
                            CurrencyXRate."Exchange Rate Amount":=100;
                            CurrencyXRate."Adjustment Exch. Rate Amount":=100;
                            CurrencyXRate."Relational Exch. Rate Amount":=100 * XRateCal."Exchange Rate Amount";
                            if Found then begin
                                if CurrencyXRate.Modify()then;
                            end
                            else
                            begin
                                if CurrencyXRate.Insert()then;
                            end;
                        end;
                    until XRateCal.Next() = 0;
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
        CurrenciesToCalculate: Record Currency;
        l_rec_CompanyMapping: Record "Company Name Mapping";
    begin
        if l_rec_CompanyMapping.Get(CompanyName)then if not l_rec_CompanyMapping."Master Data Company" then exit;
        l_rec_ExchangeCal.Reset();
        if l_rec_ExchangeCal.FindSet()then l_rec_ExchangeCal.DeleteAll();
        CurrenciesToCalculate.Reset();
        CurrenciesToCalculate.SetRange("Need to calculate", true);
        if CurrenciesToCalculate.FindSet()then repeat l_rec_Currency.Reset();
                if l_rec_Currency.FindFirst()then repeat Clear(l_rec_ExchangeCal);
                        CurrencyExchangeRate.GetLastestExchangeRate(CurrenciesToCalculate.Code, ExchangeRateDate, USDToLCYRate);
                        CurrencyExchangeRate.GetLastestExchangeRate(l_rec_Currency.Code, ExchangeRateDate, USDToFCYRate);
                        l_rec_ExchangeCal.Init();
                        l_rec_ExchangeCal."Starting Date":=ExchangeRateDate;
                        l_rec_ExchangeCal."Local Currency (LCY)":=CurrenciesToCalculate.Code;
                        l_rec_ExchangeCal."Foreign Currency (FCY)":=l_rec_Currency.Code;
                        if USDToLCYRate <> 0 then l_rec_ExchangeCal."Exchange Rate Amount":=USDToFCYRate / USDToLCYRate;
                        if l_rec_ExchangeCal.Insert()then;
                    until l_rec_Currency.Next() = 0;
            until CurrenciesToCalculate.Next() = 0;
        UpdateCompaniesExchangeRate;
    end;
}
