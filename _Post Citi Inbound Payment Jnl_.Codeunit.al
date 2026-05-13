codeunit 50205 "Post Citi Inbound Payment Jnl"
{
    TableNo = "Citi Inbound Staging";

    trigger OnRun()
    var
        PaymentJnl: Record "Gen. Journal Line";
        PaymentJnl2: Record "Gen. Journal Line";
        GenJnlBostBatch: Codeunit "Gen. Jnl.-Post Batch";
        FindRecord: Boolean;
        GenledSEtup: Record "General Ledger Setup";
        CurrExchRate: Record "Currency Exchange Rate";
        lvCurrency: Record Currency;
        CurrencyFactor: Decimal;
        BankAPISetup: Record "Bank API Setup";
        Sign: decimal;
    begin
        GenledSEtup.get();
        BankAPISetup.Get();
        FindPaymentJournal(Rec, PaymentJnl, FindRecord); //#85 TEC.VJ 15012025
        IF FindRecord THEN begin
            //#293 TEC.VJ>>
            PaymentJnl.FindSet();
            if PaymentJnl."Source Code" = 'INTERCOMP' THEN begin
                repeat Clear(GenJnlBostBatch);
                    //#85>>
                    if PaymentJnl.Amount < 0 then sign:=-1
                    else
                        sign:=1;
                    PaymentJnl.SetHideValidation(true);
                    if Rec.EntryBookedDate <> 0D then begin
                        PaymentJnl."Exchange Rate":=Rec.XChangeRate; //#85 TEC.VJ 15012025
                        if PaymentJnl."Posting Date" <> Rec.EntryBookedDate then PaymentJnl.Validate("Posting Date", Rec.EntryBookedDate);
                        //#212 TEC.VJ 11022025>>
                        //VJ 21032025 COmmented and added new logic below end;>>
                        /* if Rec.EntryAmount = 0 then begin
                             if (Rec.TxCurrency = 'USD') and (Rec.TxAmt <> PaymentJnl."Amount (LCY)") tHEN
                                 PaymentJnl.Validate("Amount (LCY)", Rec.TxAmt);
                         end else
                             if (Rec.EntryCurrency = 'USD') and (Rec.TxAmt <> PaymentJnl."Amount (LCY)") tHEN
                                 PaymentJnl.Validate("Amount (LCY)", Rec.EntryAmount);
                         //#212 TEC.VJ 11022025<<
                         */
                        if GenledSEtup."LCY Code" = Rec.TxCurrency then begin
                            if(Rec.TxAmt <> PaymentJnl."Amount (LCY)")tHEN PaymentJnl.Validate("Amount (LCY)", Rec.TxAmt * sign);
                        end;
                        if(PaymentJnl."Currency Code" <> GenledSEtup."LCY Code")then begin
                            lvCurrency.GET(Rec.TxCurrency);
                            CurrencyFactor:=CurrExchRate.ExchangeRate(PaymentJnl."Posting Date", Rec.TxCurrency);
                            PaymentJnl."Amount (LCY)":=ROUND(CurrExchRate.ExchangeAmtFCYToLCY(PaymentJnl."Posting Date", Rec.TxCurrency, Rec.TxAmt, CurrencyFactor), lvCurrency."Amount Rounding Precision") * sign;
                        end;
                        //VJ 21032025 COmmented and added new logic below end;
                        if PaymentJnl."API Bank Account Indicator" then begin
                            PaymentJnl.Validate("PB IC Account Type", PaymentJnl."PB IC Account Type"::"G/L Account");
                            PaymentJnl.Validate("PB IC Account", BankAPISetup."API Bank Dummy Account");
                        end;
                        PaymentJnl.Modify();
                    end;
                until PaymentJnl.Next() = 0;
                Commit();
            //#293 TEC.VJ<<
            end
            else
            begin
                Clear(GenJnlBostBatch);
                //#85>>
                PaymentJnl.SetHideValidation(true);
                if Rec.EntryBookedDate <> 0D then begin
                    PaymentJnl."Exchange Rate":=Rec.XChangeRate; //#85 TEC.VJ 15012025
                    if PaymentJnl."Posting Date" <> Rec.EntryBookedDate then PaymentJnl.Validate("Posting Date", Rec.EntryBookedDate);
                    //#212 TEC.VJ 11022025>>
                    //VJ 21032025 COmmented and added new logic below end;>>
                    /* if Rec.EntryAmount = 0 then begin
                         if (Rec.TxCurrency = 'USD') and (Rec.TxAmt <> PaymentJnl."Amount (LCY)") tHEN
                             PaymentJnl.Validate("Amount (LCY)", Rec.TxAmt);
                     end else
                         if (Rec.EntryCurrency = 'USD') and (Rec.TxAmt <> PaymentJnl."Amount (LCY)") tHEN
                             PaymentJnl.Validate("Amount (LCY)", Rec.EntryAmount);
                     //#212 TEC.VJ 11022025<<
                     */
                    if GenledSEtup."LCY Code" = Rec.TxCurrency then begin
                        if(Rec.TxAmt <> PaymentJnl."Amount (LCY)")tHEN PaymentJnl.Validate("Amount (LCY)", Rec.TxAmt);
                    end;
                    if(PaymentJnl."Currency Code" <> GenledSEtup."LCY Code")then begin
                        lvCurrency.GET(Rec.TxCurrency);
                        CurrencyFactor:=CurrExchRate.ExchangeRate(PaymentJnl."Posting Date", Rec.TxCurrency);
                        PaymentJnl."Amount (LCY)":=ROUND(CurrExchRate.ExchangeAmtFCYToLCY(PaymentJnl."Posting Date", Rec.TxCurrency, Rec.TxAmt, CurrencyFactor), lvCurrency."Amount Rounding Precision");
                    end;
                    //#294 TEC.VJ 02APR2025>>
                    IF PaymentJnl."API Bank Account Indicator" THEN begin
                        PaymentJnl."Skip BankDoc Checking":=true; //#384 VJ 22072025 so that acount no. event will trigger bank document no. checking
                        PaymentJnl.Validate("Account Type", PaymentJnl."Account Type"::"G/L Account");
                        PaymentJnl.Validate("Account No.", BankAPISetup."API Bank Dummy Account");
                    end;
                    //#294 TEC.VJ 02APR2025<<
                    //VJ 21032025 COmmented and added new logic below end;
                    PaymentJnl.Modify();
                    Commit();
                end;
            end;
            //#85<<
            PaymentJnl2.Reset();
            PaymentJnl2.SetRange("Journal Template Name", PaymentJnl."Journal Template Name");
            PaymentJnl2.SetRange("Journal Batch Name", PaymentJnl."Journal Batch Name");
            if PaymentJnl."Source Code" = 'INTERCOMP' THEN //#293 TEC.VJ>> 
 PaymentJnl2.SetRange("Bank Document No.", PaymentJnl."Bank Document No.")
            else
                PaymentJnl2.SetRange("Line No.", PaymentJnl."Line No.");
            //#85<<
            if PaymentJnl2.FindFirst()then begin
                FoundMAtch:=true;
                GenJnlBostBatch.Run(PaymentJnl2);
            end;
        end
        else
            error(StrSubstNo('There is no payment journal %1', PaymentJnl.GetFilters)); //VJ 30DEC
    end;
    var FoundMAtch: Boolean;
    procedure GetFoundMatch(): Boolean var
        myInt: Integer;
    begin
        exit(FoundMAtch);
    end;
    local procedure FindPaymentJournal(CITIInbound: Record "CITI Inbound Staging"; var PaymentJnl: Record "Gen. Journal Line"; var FindRecord: Boolean)
    var
        BankAcc: Record "Bank Account";
        BankDocNo: Code[20];
        CitiOutboundStag: Record "Citi Outbound Staging Table";
        EmplyeeBankAcc: Record "Employee Bank Account";
        VendbankAc: Record "Vendor Bank Account";
    begin
        //#134 TEC.VJ>>
        if(CITIInbound.EntryCrDrInd = 'CRDT') and (CITIInbound.EntryTransCode = '108')then begin
            BankDocNo:=CopyStr(CITIInbound."Additional Entry Information", 1, 20);
        end
        else
        begin
            BankDocNo:=copystr(CITIInbound.TxEndtoEndId, 1, 20);
        end;
        //#134 TEC.VJ<<
        //#85 TEC.VJ 15012025>>
        FindRecord:=false;
        CitiOutboundStag.Reset();
        CitiOutboundStag.SetRange("Bank Document No.", CITIInbound.TxEndtoEndId);
        if CitiOutboundStag.Findset()then begin
            case CitiOutboundStag."Account Type" of CitiOutboundStag."Account Type"::"Bank Account": begin
                BankAcc.Reset();
                BankAcc.SetRange("Bank Account No.", CITIInbound."Bank Account");
                if BankAcc.FindFirst()then;
                PaymentJnl.Reset();
                PaymentJnl.SetFilter("Source Code", '=%1|%2', 'PAYMENTJNL', 'INTERCOMP'); //#134
                PaymentJnl.SetRange("Bank Document No.", BankDocNo);
                /* VJ 21Jan2025 commented as disucssed with Walter
                        PaymentJnl.SetFilter("Currency Code", CITIInbound.EntryCurrency);//#85
                        PaymentJnl.SetRange("Account Type", PaymentJnl."Account Type"::"Bank Account");//#85
                        PaymentJnl.SetRange("Account No.", BankAcc."No.");//#85
                        */
                IF PaymentJnl.FindFirst()then FindRecord:=true end;
            CitiOutboundStag."Account Type"::Vendor: begin
                VendbankAc.Reset();
                VendbankAc.SetRange("Vendor No.", CitiOutboundStag."Account No.");
                VendbankAc.SetRange("Bank Account No.", CITIInbound."Bank Account");
                if VendbankAc.FindFirst()then;
                PaymentJnl.Reset();
                PaymentJnl.SetFilter("Source Code", '=%1|%2', 'PAYMENTJNL', 'INTERCOMP'); //#134
                PaymentJnl.SetRange("Bank Document No.", BankDocNo);
                /* VJ 21Jan2025 commented as disucssed with Walter
                        PaymentJnl.SetFilter("Currency Code", CITIInbound.EntryCurrency);//#85
                        PaymentJnl.SetRange("Account Type", PaymentJnl."Account Type"::Vendor);//#85
                        PaymentJnl.SetRange("Account No.", VendbankAc."Vendor No.");//#85
                        */
                IF PaymentJnl.FindFirst()then FindRecord:=true end;
            //VJ 27Mar2025 fix bug where citi inbound processing create new payment journal instead of posting existing with account type customer
            CitiOutboundStag."Account Type"::Customer: begin
                PaymentJnl.Reset();
                PaymentJnl.SetFilter("Source Code", '=%1|%2', 'PAYMENTJNL', 'INTERCOMP'); //#134
                PaymentJnl.SetRange("Bank Document No.", BankDocNo);
                IF PaymentJnl.FindFirst()then FindRecord:=true end;
            //VJ 27Mar2025 fix bug
            CitiOutboundStag."Account Type"::Employee: begin
                EmplyeeBankAcc.Reset();
                EmplyeeBankAcc.SetRange("Employee No.", CitiOutboundStag."Account No.");
                EmplyeeBankAcc.SetRange("Bank Account No.", CITIInbound."Bank Account");
                if EmplyeeBankAcc.FindFirst()then;
                PaymentJnl.Reset();
                PaymentJnl.SetFilter("Source Code", '=%1|%2', 'PAYMENTJNL', 'INTERCOMP'); //#134
                PaymentJnl.SetRange("Bank Document No.", BankDocNo);
                /* VJ 21Jan2025 commented as disucssed with Walter
                        PaymentJnl.SetFilter("Currency Code", CITIInbound.EntryCurrency);//#85
                        PaymentJnl.SetRange("Account Type", PaymentJnl."Account Type"::Vendor);//#85
                        PaymentJnl.SetRange("Account No.", EmplyeeBankAcc."Employee No.");//#85
                        */
                IF PaymentJnl.FindFirst()then FindRecord:=true end;
            end;
        end;
    //#85 TEC.VJ 15012025<<
    end;
}
