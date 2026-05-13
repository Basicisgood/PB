codeunit 50204 "Post HSBC Inbound Payment Jnl"
{
    TableNo = "HSBC Inbound Staging";

    trigger OnRun()
    var
        PaymentJnl: Record "Gen. Journal Line";
        PaymentJnl2: Record "Gen. Journal Line";
        GenJnlBostBatch: Codeunit 13;
        FindRecord: Boolean;
        BankAPISetup: Record "Bank API Setup";
        Sign: decimal;
        IsACH: Boolean;
    begin
        BankAPISetup.Get();
        FindPaymentJournal(Rec, PaymentJnl, FindRecord); //#85 TEC.VJ 15012025
        IF FindRecord THEN begin
            IsACH:=GetIsACH(Rec); //NT_ 21-04-2026
            //#293 TEC.VJ>>
            PaymentJnl.FindSet();
            if PaymentJnl."Source Code" = 'INTERCOMP' THEN begin
                repeat Clear(GenJnlBostBatch);
                    if PaymentJnl.Amount < 0 then sign:=-1
                    else
                        sign:=1;
                    //#85>>
                    PaymentJnl.SetHideValidation(true);
                    if Rec.EntryBookedDate <> 0D then begin //TEC.VJ Changed EntryValuedDate to EntryBookedDate
                        if not IsACH then //NT_ 21-04-2026
 PaymentJnl."Exchange Rate":=Rec.XChangeRate; //#85 TEC.VJ 15012025
                        PaymentJnl.Validate("Posting Date", Rec.EntryBookedDate);
                        //#212 TEC.VJ 11022025>>
                        // if (Rec.EntryCurrency = 'USD') and (Rec.EntryAmount <> PaymentJnl."Amount (LCY)") tHEN
                        //     PaymentJnl.Validate("Amount (LCY)", Rec.EntryAmount);
                        if not IsACH then begin //NT_ 21-04-2026
                            if Rec.EntryAmount = 0 then begin
                                if(Rec.TxCurrency = 'USD') and (Rec.TxAmt <> PaymentJnl."Amount (LCY)")tHEN //#212 TEC.VJ 11022025
 PaymentJnl.Validate("Amount (LCY)", Rec.TxAmt * sign);
                            end
                            else if(Rec.EntryCurrency = 'USD') and (Rec.TxAmt <> PaymentJnl."Amount (LCY)")tHEN //#212 TEC.VJ 11022025
 PaymentJnl.Validate("Amount (LCY)", Rec.EntryAmount * sign);
                        //#212 TEC.VJ 11022025<<
                        end; //NT_ 21-04-2026
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
                repeat //NT_ 22-04-2026
 Clear(GenJnlBostBatch);
                    //#85>>
                    PaymentJnl.SetHideValidation(true);
                    if Rec.EntryBookedDate <> 0D then begin //TEC.VJ Changed EntryValuedDate to EntryBookedDate
                        if not IsACH then //NT_ 21-04-2026
 PaymentJnl."Exchange Rate":=Rec.XChangeRate; //#85 TEC.VJ 15012025
                        PaymentJnl.Validate("Posting Date", Rec.EntryBookedDate);
                        //#212 TEC.VJ 11022025>>
                        // if (Rec.EntryCurrency = 'USD') and (Rec.EntryAmount <> PaymentJnl."Amount (LCY)") tHEN
                        //     PaymentJnl.Validate("Amount (LCY)", Rec.EntryAmount);
                        if not IsACH then begin //NT_ 21-04-2026
                            if Rec.EntryAmount = 0 then begin
                                if(Rec.TxCurrency = 'USD') and (Rec.TxAmt <> PaymentJnl."Amount (LCY)")tHEN //#212 TEC.VJ 11022025
 PaymentJnl.Validate("Amount (LCY)", Rec.TxAmt);
                            end
                            else if(Rec.EntryCurrency = 'USD') and (Rec.TxAmt <> PaymentJnl."Amount (LCY)")tHEN //#212 TEC.VJ 11022025
 PaymentJnl.Validate("Amount (LCY)", Rec.EntryAmount);
                        //#212 TEC.VJ 11022025<<
                        end; //NT_ 21-04-2026
                        //#294 TEC.VJ 02APR2025>>
                        IF PaymentJnl."API Bank Account Indicator" THEN begin
                            PaymentJnl.Validate("Account Type", PaymentJnl."Account Type"::"G/L Account");
                            PaymentJnl.Validate("Account No.", BankAPISetup."API Bank Dummy Account");
                        end;
                        //#294 TEC.VJ 02APR2025<<
                        PaymentJnl.Modify();
                    // Commit(); //NT_ 22-04-2026
                    end;
                until PaymentJnl.Next() = 0; //NT_ 22-04-2026
                Commit(); //NT_ 22-04-2026
            end;
            //PaymentJnl2.Get(PaymentJnl."Journal Template Name", PaymentJnl."Journal Batch Name", PaymentJnl."Line No.");
            //NT_ 22-04-2026 >>
            // PaymentJnl2.Reset();
            // PaymentJnl2.SetRange("Journal Template Name", PaymentJnl."Journal Template Name");
            // PaymentJnl2.SetRange("Journal Batch Name", PaymentJnl."Journal Batch Name");
            // if PaymentJnl."Source Code" = 'INTERCOMP' THEN //#293 TEC.VJ>> 
            //     PaymentJnl2.SetRange("Bank Document No.", PaymentJnl."Bank Document No.")
            // else
            //     PaymentJnl2.SetRange("Line No.", PaymentJnl."Line No.");
            //#85<<
            // if PaymentJnl2.FindFirst() then begin
            //     FoundMAtch := true;
            //     GenJnlBostBatch.Run(PaymentJnl2);
            // end;
            //   PaymentJnl2.Reset();
            PaymentJnl2.CopyFilters(PaymentJnl);
            if PaymentJnl2.FindSet()then begin
                FoundMAtch:=true;
                GenJnlBostBatch.Run(PaymentJnl2);
            end;
        //NT_ 22-04-2026 <<
        end
        else
            Error(StrSubstNo('There is no payment journal %1', PaymentJnl.GetFilters));
    end;
    var FoundMAtch: Boolean;
    procedure GetFoundMatch(): Boolean var
        myInt: Integer;
    begin
        exit(FoundMAtch);
    end;
    local procedure FindPaymentJournal(HSBCInbound: Record "HSBC Inbound Staging"; var PaymentJnl: Record "Gen. Journal Line"; var FindRecord: Boolean)
    var
        BankAcc: Record "Bank Account";
        BankDocNo: Code[500];
        BatchBankDocNo: Code[500];
        HSBCOutboundStag: Record "HSBC Outbound Staging Table";
        HSBCOutboundStag2: Record "HSBC Outbound Staging Table";
        EmplyeeBankAcc: Record "Employee Bank Account";
        VendbankAc: Record "Vendor Bank Account";
        useBatchId: Boolean;
        TextBuilder: TextBuilder;
    begin
        useBatchId:=false; //NT_ 21OCT2025
        //#134 TEC.VJ>>
        if(HSBCInbound.EntryCrDrInd = 'CRDT') and (HSBCInbound.EntryTransCode = '108')then begin
            BankDocNo:=HSBCInbound."Additional Entry Information";
        end
        else
        begin
            BankDocNo:=HSBCInbound.TxEndtoEndId;
        end;
        //#134 TEC.VJ<<
        //#85 TEC.VJ 15012025>>
        //NT_ 21OCT2025 >> 
        HSBCOutboundStag.Reset();
        HSBCOutboundStag.SetRange("Bank Document No.", HSBCInbound.TxEndtoEndId);
        if not HSBCOutboundStag.Findset()then begin
            HSBCOutboundStag.Reset();
            HSBCOutboundStag.SetRange("Batch Id", HSBCInbound.TxEndtoEndId);
            if HSBCOutboundStag.FindSet()then begin
                useBatchId:=true;
                BankDocNo:=HSBCOutboundStag."Bank Document No.";
            end;
        end;
        //NT_ 21OCT2025 << 
        FindRecord:=false;
        HSBCOutboundStag.Reset();
        //NT_ 21OCT2025 >>
        if useBatchId then begin
            HSBCOutboundStag.SetRange("Batch Id", HSBCInbound.TxEndtoEndId);
            //NT_ 21042026>>
            HSBCOutboundStag2.Reset();
            HSBCOutboundStag2.SetRange("Batch Id", HSBCInbound.TxEndtoEndId);
            if HSBCOutboundStag2.FindSet()then repeat if TextBuilder.Length > 0 then TextBuilder.Append('|');
                    TextBuilder.Append(HSBCOutboundStag2."Bank Document No.");
                until HSBCOutboundStag2.Next() = 0;
            BatchBankDocNo:=TextBuilder.ToText();
        //NT_ 21042026<<
        end
        else
            HSBCOutboundStag.SetRange("Bank Document No.", HSBCInbound.TxEndtoEndId);
        // HSBCOutboundStag.SetRange("Bank Document No.", HSBCInbound.TxEndtoEndId);
        //NT_ 21OCT2025 <<
        if HSBCOutboundStag.Findset()then begin
            // repeat  //NT_ 13022026 //NT_ 21APR2026
            case HSBCOutboundStag."Account Type" of HSBCOutboundStag."Account Type"::"Bank Account": begin
                BankAcc.Reset();
                BankAcc.SetRange("Bank Account No.", HSBCInbound."Bank Account");
                if BankAcc.FindFirst()then;
                PaymentJnl.Reset();
                PaymentJnl.SetFilter("Source Code", '=%1|%2', 'PAYMENTJNL', 'INTERCOMP'); //#134
                //##DC find by Batch ID for Low Value
                //NT_ 21-04-2026 >>
                if useBatchId then PaymentJnl.SetFilter("Bank Document No.", BatchBankDocNo)
                else
                    //NT_ 21-04-2026 <<
                    PaymentJnl.SetRange("Bank Document No.", BankDocNo);
                /* VJ 21Jan2025 commented as disucssed with Walter
                        // PaymentJnl.SetFilter("Currency Code", HSBCInbound.EntryCurrency);//#85
                        // PaymentJnl.SetRange("Account Type", PaymentJnl."Account Type"::"Bank Account");//#85
                        // PaymentJnl.SetRange("Account No.", BankAcc."No.");//#85
                        */
                //NT_ 22-04-2026 >>
                // IF PaymentJnl.FindFirst() then 
                IF PaymentJnl.FindSet()then //NT_ 22-04-2026 <<
                    FindRecord:=true end;
            HSBCOutboundStag."Account Type"::Vendor: begin
                VendbankAc.Reset();
                VendbankAc.SetRange("Vendor No.", HSBCOutboundStag."Account No.");
                VendbankAc.SetRange("Bank Account No.", HSBCInbound."Bank Account");
                if VendbankAc.FindFirst()then;
                PaymentJnl.Reset();
                PaymentJnl.SetFilter("Source Code", '=%1|%2', 'PAYMENTJNL', 'INTERCOMP'); //#134
                //##DC find by Batch ID for Low Value
                //NT_ 21-04-2026 >>
                if useBatchId then PaymentJnl.SetFilter("Bank Document No.", BatchBankDocNo)
                else
                    //NT_ 21-04-2026 <<
                    PaymentJnl.SetRange("Bank Document No.", BankDocNo);
                // PaymentJnl.SetFilter("Currency Code", HSBCInbound.EntryCurrency);//#85
                // PaymentJnl.SetRange("Account Type", PaymentJnl."Account Type"::Vendor);//#85
                // PaymentJnl.SetRange("Account No.", VendbankAc."Vendor No.");//#85
                //NT_ 22-04-2026 >>
                // IF PaymentJnl.FindFirst() then 
                IF PaymentJnl.FindSet()then //NT_ 22-04-2026 <<
                    FindRecord:=true end;
            //VJ 27Mar2025 fix bug where citi inbound processing create new payment journal instead of posting existing with account type customer
            HSBCOutboundStag."Account Type"::Customer: begin
                PaymentJnl.Reset();
                PaymentJnl.SetFilter("Source Code", '=%1|%2', 'PAYMENTJNL', 'INTERCOMP'); //#134
                //##DC find by Batch ID for Low Value
                //NT_ 21-04-2026 >>
                if useBatchId then PaymentJnl.SetFilter("Bank Document No.", BatchBankDocNo)
                else
                    //NT_ 21-04-2026 <<
                    PaymentJnl.SetRange("Bank Document No.", BankDocNo);
                //NT_ 22-04-2026 >>
                // IF PaymentJnl.FindFirst() then 
                IF PaymentJnl.FindSet()then //NT_ 22-04-2026 <<
                    FindRecord:=true end;
            //VJ 27Mar2025 fix bug
            HSBCOutboundStag."Account Type"::Employee: begin
                EmplyeeBankAcc.Reset();
                EmplyeeBankAcc.SetRange("Employee No.", HSBCOutboundStag."Account No.");
                EmplyeeBankAcc.SetRange("Bank Account No.", HSBCInbound."Bank Account");
                if EmplyeeBankAcc.FindFirst()then;
                PaymentJnl.Reset();
                PaymentJnl.SetFilter("Source Code", '=%1|%2', 'PAYMENTJNL', 'INTERCOMP'); //#134
                //##DC find by Batch ID for Low Value
                //NT_ 21-04-2026 >>
                if useBatchId then PaymentJnl.SetFilter("Bank Document No.", BatchBankDocNo)
                else
                    //NT_ 21-04-2026 <<
                    PaymentJnl.SetRange("Bank Document No.", BankDocNo);
                // PaymentJnl.SetFilter("Currency Code", HSBCInbound.EntryCurrency);//#85
                // PaymentJnl.SetRange("Account Type", PaymentJnl."Account Type"::Employee);//#85
                // PaymentJnl.SetRange("Account No.", EmplyeeBankAcc."Employee No.");//#85
                //NT_ 22-04-2026 >>
                // IF PaymentJnl.FindFirst() then 
                IF PaymentJnl.FindSet()then //NT_ 22-04-2026 <<
                    FindRecord:=true end;
            end;
        // until HSBCOutboundStag.Next() = 0; //NT_ 13022026 //NT_ 21APR2026
        end;
    //#85 TEC.VJ 15012025<<
    end;
    local procedure GetIsACH(HSBCInbound: Record "HSBC Inbound Staging"): Boolean var
        l_rec_HSBCOutbound: Record "HSBC Outbound Staging Table";
    begin
        l_rec_HSBCOutbound.Reset();
        l_rec_HSBCOutbound.SetRange("Batch Id", HSBCInbound.TxEndtoEndId);
        if l_rec_HSBCOutbound.FindFirst()then exit(l_rec_HSBCOutbound."Batch Type" = l_rec_HSBCOutbound."Batch Type"::"HK Lower Value");
    end;
}
