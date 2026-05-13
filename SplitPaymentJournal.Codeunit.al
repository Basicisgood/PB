codeunit 50118 SplitPaymentJournal
{
    Permissions = TableData "Vendor Ledger Entry"=rimd;
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    begin
        ProcessJournalBatch(rec."Journal Template Name", Rec."Journal Batch Name");
        Commit();
    end;
    procedure ProcessJournalBatch(P_TempName: Code[20]; P_BatchName: Code[20])
    var
        L_GJL: Record "Gen. Journal Line";
    begin
        GJLSplit.reset;
        GJLSplit.SetRange("Journal Template Name", P_TempName);
        GJLSplit.SetRange("Journal Batch Name", P_BatchName);
        IF NOT GJLSplit.IsEmpty then GJLSplit.DeleteAll();
        L_GJL.reset;
        L_GJL.SetRange("Journal Template Name", P_TempName);
        L_GJL.SetRange("Journal Batch Name", P_BatchName);
        IF L_GJL.FindFirst()then repeat SplitLinebasedOnApplicationNew2(L_GJL);
            until L_GJL.Next() = 0;
    end;
    local procedure SplitLinebasedOnApplicationNew(var GenJnlLine_p: Record "Gen. Journal Line")
    var
        // VendorLedentry: Record "Vendor Ledger Entry";
        VendorLedentry: Record "Global Vendor Ledger Entry";
        NeedToSplit: Boolean;
        FirstLine: Boolean;
        TotApplyAmt: Decimal;
    begin
        TotApplyAmt:=0;
        TempVendorLedentry.deleteall;
        TempELE.DeleteAll();
        GenJnlLine:=GenJnlLine_p;
        NeedToSplit:=false;
        FirstLine:=true;
        IF NOT(GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor)then begin
            GJLSplit.Init();
            GJLSplit.TransferFields(GenJnlLine);
            LineNo+=10000;
            GJLSplit."Line No.":=LineNo;
            GJLSplit."Source Line No.":=GenJnlLine."Line No.";
            GJLSplit.Insert();
            exit;
        end;
        IF GenJnlLine."Applies-to ID" = '' then begin
            GJLSplit.Init();
            GJLSplit.TransferFields(GenJnlLine);
            LineNo+=10000;
            GJLSplit."Line No.":=LineNo;
            GJLSplit."Source Line No.":=GenJnlLine."Line No.";
            GJLSplit.Insert();
            exit;
        end;
        VendorLedentry.Reset();
        VendorLedentry.SetCurrentKey("Vendor No.", Open, Positive, "Due Date");
        VendorLedentry.SetRange("Vendor No.", GenJnlLine."Account No.");
        VendorLedentry.SetRange(open, true);
        VendorLedentry.SetRange("Applies-to ID", GenJnlLine."Document No.");
        IF VendorLedentry.FindSet()then repeat TempVendorLedentry.Init();
                TempVendorLedentry:=VendorLedentry;
                TempVendorLedentry.Insert();
            until VendorLedentry.Next() = 0;
        TempVendorLedentry.Reset();
        If TempVendorLedentry.FindSet()then repeat TempVendorLedentry.CalcFields("Remaining Amount");
                IF FirstLine then begin
                    FirstLine:=false;
                    GJLSplit.Init();
                    GJLSplit.TransferFields(GenJnlLine);
                    LineNo+=10000;
                    GJLSplit."Line No.":=LineNo;
                    GJLSplit."Source Line No.":=GenJnlLine."Line No.";
                    GJLSplit.Validate(Amount, -TempVendorLedentry."Amount to Apply");
                    IF GenJnlLine."Currency Factor" <> 0 then GJLSplit."Amount (LCY)":=GJLSplit.Amount * GenJnlLine."Currency Factor"
                    else
                        GJLSplit."Amount (LCY)":=GJLSplit.Amount;
                    GJLSplit.Validate("Applies-to Doc. Type", TempVendorLedentry."Document Type");
                    GJLSplit.Validate("Applies-to Doc. No.", TempVendorLedentry."Document No.");
                    GJLSplit.Validate("Applies-to ID", '');
                    GJLSplit.Validate("Invoice Link", TempVendorLedentry."Invoice Link");
                    GJLSplit."Applied Company Code":=TempVendorLedentry."Company Name";
                    GJLSplit.Insert;
                end
                Else
                begin
                    GJLSplit.Init();
                    GJLSplit.TransferFields(GenJnlLine);
                    LineNo+=10000;
                    GJLSplit."Line No.":=LineNo;
                    GJLSplit."Source Line No.":=GenJnlLine."Line No.";
                    GJLSplit.Validate(Amount, -TempVendorLedentry."Amount to Apply");
                    IF GenJnlLine."Currency Factor" <> 0 then GJLSplit."Amount (LCY)":=GJLSplit.Amount * GenJnlLine."Currency Factor"
                    else
                        GJLSplit."Amount (LCY)":=GJLSplit.Amount;
                    GJLSplit.Validate("Applies-to Doc. Type", TempVendorLedentry."Document Type");
                    GJLSplit.Validate("Applies-to Doc. No.", TempVendorLedentry."Document No.");
                    GJLSplit.Validate("Applies-to ID", '');
                    GJLSplit.Validate("Invoice Link", TempVendorLedentry."Invoice Link");
                    GJLSplit."Applied Company Code":=TempVendorLedentry."Company Name";
                    GJLSplit.Insert();
                end;
                TotApplyAmt+=ABS(TempVendorLedentry."Amount to Apply");
            until TempVendorLedentry.Next() = 0;
        //end;
        IF ABS(GenJnlLine.Amount) - ABS(TotApplyAmt) <> 0 then begin
            GJLSplit.Init();
            GJLSplit.TransferFields(GenJnlLine);
            LineNo+=10000;
            GJLSplit."Line No.":=LineNo;
            GJLSplit.Validate(Amount, ABS(GenJnlLine.Amount) - ABS(TotApplyAmt));
            IF GenJnlLine."Currency Factor" <> 0 then GJLSplit."Amount (LCY)":=GJLSplit.Amount * GenJnlLine."Currency Factor"
            else
                GJLSplit."Amount (LCY)":=GJLSplit.Amount;
            GJLSplit."Source Line No.":=GenJnlLine."Line No.";
            GJLSplit.insert;
        end;
    end;
    local procedure SplitLinebasedOnApplicationNew2(var GenJnlLine_p: Record "Gen. Journal Line")
    var
        VendorLedentry: Record "Global Vendor Ledger Entry";
        ELE: Record "Global Employee Ledger Entry";
        CLE: Record "Global Cust. Ledger entry";
        NeedToSplit: Boolean;
        FirstLine: Boolean;
        TotApplyAmt: Decimal;
    begin
        TotApplyAmt:=0;
        TempVendorLedentry.deleteall;
        TempELE.DeleteAll(); //employee
        TempCLE.deleteAll;
        GenJnlLine:=GenJnlLine_p;
        NeedToSplit:=false;
        FirstLine:=true;
        IF NOT((GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor) OR (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Employee) OR (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer))then begin
            GJLSplit.Init();
            GJLSplit.TransferFields(GenJnlLine);
            LineNo+=10000;
            GJLSplit."Line No.":=LineNo;
            GJLSplit."Source Line No.":=GenJnlLine."Line No.";
            GJLSplit.Insert();
            exit;
        end;
        IF GenJnlLine."Applies-to ID" = '' then begin
            GJLSplit.Init();
            GJLSplit.TransferFields(GenJnlLine);
            LineNo+=10000;
            GJLSplit."Line No.":=LineNo;
            GJLSplit."Source Line No.":=GenJnlLine."Line No.";
            GJLSplit."Amount (LCY)":=0; //Added on 4 feb26
            GJLSplit.Insert();
            exit;
        end;
        IF(GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor)then begin
            VendorLedentry.Reset();
            VendorLedentry.SetCurrentKey("Vendor No.", Open, Positive, "Due Date");
            VendorLedentry.SetRange("Vendor No.", GenJnlLine."Account No.");
            VendorLedentry.SetRange(open, true);
            VendorLedentry.SetRange("Applies-to ID", GenJnlLine."Document No.");
            VendorLedentry.SetRange("Bank Document No. Applied", GenJnlLine."Bank Document No."); //Sgarg- Added later
            IF VendorLedentry.FindSet()then repeat TempVendorLedentry.Init();
                    TempVendorLedentry:=VendorLedentry;
                    TempVendorLedentry.Insert();
                until VendorLedentry.Next() = 0;
            TempVendorLedentry.Reset();
            If TempVendorLedentry.FindSet()then repeat TempVendorLedentry.CalcFields("Remaining Amount");
                    GJLSplit.Init();
                    GJLSplit.TransferFields(GenJnlLine);
                    LineNo+=10000;
                    GJLSplit."Line No.":=LineNo;
                    GJLSplit."Source Line No.":=GenJnlLine."Line No.";
                    //GJLSplit.Validate("Currency Code", TempVendorLedentry."Currency Code");
                    // GJLSplit.Validate(Amount, -TempVendorLedentry."Amount to Apply");
                    GJLSplit.Validate(Amount, CalcApplnAmountToApply(GenJnlLine_p, TempVendorLedentry, -TempVendorLedentry."Amount to Apply"));
                    GJLSplit.Validate("Amount (LCY)", TempVendorLedentry."Amount to Apply");
                    /*
                                    IF GenJnlLine."Currency Factor" <> 0 then
                                        //GJLSplit."Amount (LCY)" := GJLSplit.Amount * GenJnlLine."Currency Factor"
                                         GJLSplit."Amount (LCY)" := Round(
                                CurrExchRate.ExchangeAmtFCYToLCY(GenJnlLine."Posting Date", GenJnlLine."Currency Code", GenJnlLine.Amount, GenJnlLine."Currency Factor"))
                                    else
                                        GJLSplit."Amount (LCY)" := GJLSplit.Amount;
                    */
                    GJLSplit.Validate("Applies-to Doc. Type", TempVendorLedentry."Document Type");
                    GJLSplit.Validate("Applies-to Doc. No.", TempVendorLedentry."Document No.");
                    GJLSplit.Validate("Applies-to ID", '');
                    GJLSplit.Validate("External Document No.", TempVendorLedentry."External Document No."); //NT_ 14-03-2025
                    GJLSplit.Validate("Invoice Link", TempVendorLedentry."Invoice Link");
                    GJLSplit."Applied Company Code":=TempVendorLedentry."Company Name";
                    GJLSplit."Invoice Currency Code":=TempVendorLedentry."Currency Code";
                    GJLSplit."IMOS Transaction No":=TempVendorLedentry."IMOS Transaction No";
                    GJLSplit.Insert();
                    //TotApplyAmt += ABS(TempVendorLedentry."Amount to Apply");
                    TotApplyAmt+=GJLSplit.Amount;
                until TempVendorLedentry.Next() = 0;
        end
        else IF(GenJnlLine."Account Type" = GenJnlLine."Account Type"::Employee)then begin
                //employee
                ELE.Reset();
                ELE.SetCurrentKey("Employee No.", Open, Positive);
                ELE.SetRange("Employee No.", GenJnlLine."Account No.");
                ELE.SetRange(open, true);
                ELE.SetRange("Applies-to ID", GenJnlLine."Document No.");
                ELE.SetRange("Bank Document No. Applied", GenJnlLine."Bank Document No."); //Sgarg- Added later
                IF ELE.FindSet()then repeat TempELE.Init();
                        TempELE:=ELE;
                        TempELE.Insert();
                    until ELE.Next() = 0;
                TempELE.Reset();
                If TempELE.FindSet()then repeat TempELE.CalcFields("Remaining Amount");
                        GJLSplit.Init();
                        GJLSplit.TransferFields(GenJnlLine);
                        LineNo+=10000;
                        GJLSplit."Line No.":=LineNo;
                        GJLSplit."Source Line No.":=GenJnlLine."Line No.";
                        GJLSplit.Validate(Amount, CalcApplnAmountToApplyEmp(GenJnlLine_p, TempELE, -TempELE."Amount to Apply"));
                        GJLSplit.Validate("Amount (LCY)", TempELE."Amount to Apply");
                        //     GJLSplit.Validate(Amount, -TempELE."Amount to Apply");
                        //     IF GenJnlLine."Currency Factor" <> 0 then
                        //         GJLSplit."Amount (LCY)" := Round(
                        // CurrExchRate.ExchangeAmtFCYToLCY(GenJnlLine."Posting Date", GenJnlLine."Currency Code", GenJnlLine.Amount, GenJnlLine."Currency Factor"))
                        //     else
                        //         GJLSplit."Amount (LCY)" := GJLSplit.Amount;
                        GJLSplit."Receipt image ID":=TempELE."Receipt image ID";
                        GJLSplit."External Document No.":=TempELE."External Document No.";
                        GJLSplit.Validate("Applies-to Doc. Type", TempELE."Document Type");
                        GJLSplit.Validate("Applies-to Doc. No.", TempELE."Document No.");
                        GJLSplit.Validate("Applies-to ID", '');
                        GJLSplit."Invoice Currency Code":=TempELE."Currency Code";
                        GJLSplit."Applied Company Code":=TempELE."Company Code";
                        GJLSplit.Insert();
                        //TotApplyAmt += ABS(TempELE."Amount to Apply");
                        // TotApplyAmt += abs(GJLSplit.Amount);
                        TotApplyAmt+=GJLSplit.Amount;
                    until TempELE.Next() = 0;
            end
            else IF(GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer)then begin
                    //Customer
                    CLE.Reset();
                    CLE.SetCurrentKey("Customer No.", Open, Positive);
                    CLE.SetRange("Customer No.", GenJnlLine."Account No.");
                    CLE.SetRange(open, true);
                    CLE.SetRange("Applies-to ID", GenJnlLine."Document No.");
                    CLE.SetRange("Bank Document No. Applied", GenJnlLine."Bank Document No."); //Sgarg- Added later
                    IF CLE.FindSet()then repeat TempCLE.Init();
                            TempCLE:=CLE;
                            TempCLE.Insert();
                        until CLE.Next() = 0;
                    TempCLE.Reset();
                    If TempCLE.FindSet()then repeat TempCLE.CalcFields("Remaining Amount");
                            GJLSplit.Init();
                            GJLSplit.TransferFields(GenJnlLine);
                            LineNo+=10000;
                            GJLSplit."Line No.":=LineNo;
                            GJLSplit."Source Line No.":=GenJnlLine."Line No.";
                            GJLSplit.Validate(Amount, CalcApplnAmountToApplyCust(GenJnlLine_p, TempCLE, -TempCLE."Amount to Apply"));
                            GJLSplit.Validate("Amount (LCY)", TempCLE."Amount to Apply");
                            //     GJLSplit.Validate(Amount, -TempELE."Amount to Apply");
                            //     IF GenJnlLine."Currency Factor" <> 0 then
                            //         GJLSplit."Amount (LCY)" := Round(
                            // CurrExchRate.ExchangeAmtFCYToLCY(GenJnlLine."Posting Date", GenJnlLine."Currency Code", GenJnlLine.Amount, GenJnlLine."Currency Factor"))
                            //     else
                            //         GJLSplit."Amount (LCY)" := GJLSplit.Amount;
                            // GJLSplit."Receipt image ID" := TempCLE."Receipt image ID";
                            GJLSplit."External Document No.":=TempCLE."External Document No.";
                            GJLSplit.Validate("Applies-to Doc. Type", TempCLE."Document Type");
                            GJLSplit.Validate("Applies-to Doc. No.", TempCLE."Document No.");
                            GJLSplit.Validate("Applies-to ID", '');
                            GJLSplit."Invoice Currency Code":=TempCLE."Currency Code";
                            GJLSplit."IMOS Transaction No":=TempCLE."IMOS Transaction No";
                            GJLSplit."Applied Company Code":=TempCLE."Company Name";
                            GJLSplit.Insert();
                            //TotApplyAmt += ABS(TempELE."Amount to Apply");
                            // TotApplyAmt += abs(GJLSplit.Amount);
                            TotApplyAmt+=GJLSplit.Amount;
                        until TempCLE.Next() = 0;
                end;
        TotApplyAmt:=Round(TotApplyAmt, 0.01, '=');
        IF(ABS(GenJnlLine.Amount) - ABS(TotApplyAmt) <> 0)then begin
            GJLSplit.Init();
            GJLSplit.TransferFields(GenJnlLine);
            LineNo+=10000;
            GJLSplit."Line No.":=LineNo;
            GJLSplit.Validate(Amount, ABS(GenJnlLine.Amount) - ABS(TotApplyAmt));
            GJLSplit.Validate("Amount (LCY)", 0);
            //IF GenJnlLine."Currency Factor" <> 0 then
            // GJLSplit."Amount (LCY)" := GJLSplit.Amount * GenJnlLine."Currency Factor"
            //GJLSplit."Amount (LCY)" := Round(
            //CurrExchRate.ExchangeAmtFCYToLCY(GenJnlLine."Posting Date", GenJnlLine."Currency Code", GenJnlLine.Amount, GenJnlLine."Currency Factor"))
            //else
            //GJLSplit."Amount (LCY)" := GJLSplit.Amount;
            GJLSplit."Source Line No.":=GenJnlLine."Line No.";
            GJLSplit.insert;
        end;
    end;
    var GenJnlLine: Record "Gen. Journal Line";
    //  TempVendorLedentry: Record "Vendor Ledger Entry" temporary;
    TempVendorLedentry: Record "Global Vendor Ledger Entry" temporary;
    TempELE: Record "Global Employee Ledger Entry" temporary;
    TempCLE: Record "Global Cust. Ledger entry" temporary;
    GJLSplit: Record "GJL Split";
    LineNo: Integer;
    PreviousLineNo: Integer;
    CurrExchRate: Record "Currency Exchange Rate";
    [EventSubscriber(ObjectType::Table, database::"Gen. Journal Line", 'OnAfterDeleteEvent', '', true, true)]
    local procedure OnDeleteGJL(var Rec: Record "Gen. Journal Line")
    var
        GJLSplit: Record "GJL Split";
    begin
        IF rec.IsTemporary then exit;
        GJLSplit.reset;
        GJLSplit.SetRange("Journal Template Name", rec."Journal Template Name");
        GJLSplit.SetRange("Journal Batch Name", rec."Journal Batch Name");
        GJLSplit.SetRange("Source Line No.", rec."Line No.");
        IF NOT GJLSplit.IsEmpty then GJLSplit.DeleteAll();
    end;
    Procedure CalcApplnAmountToApply(var GenJnlLine_p: Record "Gen. Journal Line"; P_GVLE: Record "Global Vendor Ledger Entry"; AmountToApply: Decimal): Decimal var
        ApplnDate: date;
        ApplnCurrencyCode: code[20];
        ApplnAmountToApply: Decimal;
        ValidExchRate: Boolean;
    begin
        ValidExchRate:=TRUE;
        ApplnDate:=GenJnlLine."Posting Date";
        ApplnCurrencyCode:=GenJnlLine."Currency Code";
        IF ApplnCurrencyCode = P_GVLE."Currency Code" THEN EXIT(AmountToApply);
        IF ApplnDate = 0D THEN ApplnDate:=P_GVLE."Posting Date";
        ApplnAmountToApply:=CurrExchRate.ApplnExchangeAmtFCYToFCY(ApplnDate, P_GVLE."Currency Code", ApplnCurrencyCode, AmountToApply, ValidExchRate);
        EXIT(ApplnAmountToApply);
    end;
    Procedure CalcApplnAmountToApplyEmp(var GenJnlLine_p: Record "Gen. Journal Line"; P_GELE: Record "Global Employee Ledger Entry"; AmountToApply: Decimal): Decimal var
        ApplnDate: date;
        ApplnCurrencyCode: code[20];
        ApplnAmountToApply: Decimal;
        ValidExchRate: Boolean;
    begin
        ValidExchRate:=TRUE;
        ApplnDate:=GenJnlLine."Posting Date";
        ApplnCurrencyCode:=GenJnlLine."Currency Code";
        IF ApplnCurrencyCode = P_GELE."Currency Code" THEN EXIT(AmountToApply);
        IF ApplnDate = 0D THEN ApplnDate:=P_GELE."Posting Date";
        ApplnAmountToApply:=CurrExchRate.ApplnExchangeAmtFCYToFCY(ApplnDate, P_GELE."Currency Code", ApplnCurrencyCode, AmountToApply, ValidExchRate);
        EXIT(ApplnAmountToApply);
    end;
    Procedure CalcApplnAmountToApplyCust(var GenJnlLine_p: Record "Gen. Journal Line"; P_GCLE: Record "Global Cust. Ledger Entry"; AmountToApply: Decimal): Decimal var
        ApplnDate: date;
        ApplnCurrencyCode: code[20];
        ApplnAmountToApply: Decimal;
        ValidExchRate: Boolean;
    begin
        ValidExchRate:=TRUE;
        ApplnDate:=GenJnlLine."Posting Date";
        ApplnCurrencyCode:=GenJnlLine."Currency Code";
        IF ApplnCurrencyCode = P_GCLE."Currency Code" THEN EXIT(AmountToApply);
        IF ApplnDate = 0D THEN ApplnDate:=P_GCLE."Posting Date";
        ApplnAmountToApply:=CurrExchRate.ApplnExchangeAmtFCYToFCY(ApplnDate, P_GCLE."Currency Code", ApplnCurrencyCode, AmountToApply, ValidExchRate);
        EXIT(ApplnAmountToApply);
    end;
}
