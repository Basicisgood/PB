codeunit 50219 "Create Concur Advance"
{
    TableNo = "Concur Cash Advance";

    trigger OnRun()
    begin
        Apisetup.get;
        CreateGJL(Rec);
    end;
    procedure CreateGJL(var P_ConCurAdv: Record "Concur Cash Advance")
    var
        NoSeries: Codeunit "No. Series";
        DescDate: text;
        L_Mon: Text;
        L_Year: Text;
        L_Num: text;
        L_GLSetup: Record "General Ledger Setup";
        L_Amt: Decimal;
        CurrFactor: Decimal;
        CompanyNameMapp: Record "Company Name Mapping";
    begin
        GJL.init;
        GJL."Journal Template Name":=Apisetup."Cash Advance Template Name";
        GJL."Journal Batch Name":=Apisetup."Cash Advance Batch Name";
        GJL."Line No.":=GetLastLineNo() + 10000;
        IF StrLen(P_ConCurAdv.IssuedDate) > 10 then begin
            evaluate(GJL."Posting Date", CopyStr(P_ConCurAdv.IssuedDate, 1, 10));
        end
        else
            evaluate(GJL."Posting Date", P_ConCurAdv.IssuedDate);
        L_Year:=CopyStr(P_ConCurAdv.IssuedDate, 3, 2);
        L_mon:=CopyStr(P_ConCurAdv.IssuedDate, 6, 2);
        DescDate:=CopyStr(P_ConCurAdv.IssuedDate, 6, 2) + '/' + CopyStr(P_ConCurAdv.IssuedDate, 9, 2);
        GJL."Document Type":=GJL."Document Type"::Payment;
        GJL."Document No.":=NoSeries.GetNextNo(Apisetup."Cash Advance No. Series");
        GJL.validate("Account Type", GJL."Account Type"::Employee);
        GJL.Validate("Account No.", P_ConCurAdv.EmployeeId);
        GJL.Description:=DescDate + ' ' + GJL.Description;
        GJL.Description:=COPYSTR(GJL.Description + ' ' + format(P_ConCurAdv.CurrencyAlphaCode) + ' ' + format(P_ConCurAdv.RequestAmount) + ' ' + Format(P_ConCurAdv.Purpose), 1, 100);
        //>>#388 VJ 29072025
        // GJL.Comment := GJL.Description + ' ' + format(P_ConCurAdv.CurrencyAlphaCode) + ' ' + format(P_ConCurAdv.RequestAmount) +
        //                     ' ' + Format(P_ConCurAdv.Purpose);
        GJL.Comment:=COPYSTR(GJL.Description + ' ' + format(P_ConCurAdv.CurrencyAlphaCode) + ' ' + format(P_ConCurAdv.RequestAmount) + ' ' + Format(P_ConCurAdv.Purpose), 1, 250);
        //<<#388 VJ 29072025
        //  GJL.Validate("Currency Code", P_ConCurAdv.CurrencyAlphaCode);
        //GJL.Validate(Amount, P_ConCurAdv.RequestAmount);
        // GJL.Validate(Amount, P_ConCurAdv.Amount); //later change
        GJL.validate(GJL."Bal. Account Type", GJL."Bal. Account Type"::"Bank Account");
        // IF P_ConCurAdv."CH/TVL" = 'CH' then
        //     GJL.Validate("Bal. Account No.", GetAPIBankAccount(true))
        // else
        //    GJL.Validate("Bal. Account No.", GetAPIBankAccount(false));
        GJL.Validate("Bal. Account No.", GetAPIBankAccount(P_ConCurAdv.CurrencyAlphaCode));
        BankAccSetup.reset;
        BankAccSetup.SetRange("BC Company", CompanyName);
        BankAccSetup.SetRange("Cash Advance Bank Account", true);
        BankAccSetup.SetRange("Concur LCY Bank", true);
        BankAccSetup.FindFirst();
        // BankAccSetup2.reset;
        // BankAccSetup2.SetRange("BC Company", CompanyName);
        // BankAccSetup2.SetRange("Cash Advance Bank Account", true);
        // BankAccSetup2.SetRange("Concur LCY Bank", false);
        // BankAccSetup2.FindFirst();
        // L_GLSetup.GET;
        // IF (GJL."Currency Code" = P_ConCurAdv.CurrencyAlphaCode) AND (L_GLSetup."LCY Code" <> GJL."Currency Code") then BEGIN
        //     GJL.validate(Amount, P_ConCurAdv.Amount)
        // END ELSE BEGIN
        //     L_Amt := 0;
        //     CurrFactor := 0;
        //     CurrFactor := CurrExRate.ExchangeRate(GJL."Posting Date", GJL."Currency Code");
        //     L_Amt := CurrExRate.ExchangeAmtLCYToFCY(GJL."Posting Date", GJL."Currency Code", P_ConCurAdv.Amount, CurrFactor);
        //     GJL.validate(Amount, L_Amt);
        // END;
        L_GLSetup.GET;
        IF(GJL."Currency Code" <> P_ConCurAdv.CurrencyAlphaCode) AND (L_GLSetup."LCY Code" <> GJL."Currency Code")then BEGIN
            IF NOT(L_GLSetup."LCY Code" <> BankAccSetup."Currency Code")then begin
                L_Amt:=0;
                CurrFactor:=0;
                CurrFactor:=CurrExRate.ExchangeRate(GJL."Posting Date", GJL."Currency Code");
                L_Amt:=CurrExRate.ExchangeAmtLCYToFCY(GJL."Posting Date", GJL."Currency Code", P_ConCurAdv.Amount, CurrFactor);
                GJL.validate(Amount, L_Amt);
            end
            else
                GJL.validate(Amount, P_ConCurAdv.Amount);
        END
        ELSE
        BEGIN
            GJL.validate(Amount, P_ConCurAdv.Amount)END;
        L_Num:=P_ConCurAdv."No. of Cash Advance for Month";
        IF StrLen(L_Num) = 1 then L_Num:='0' + L_Num;
        //TEC.VJ 30Oct2025 << Comment for Company Code Prefix
        // GJL."External Document No." := Apisetup."Company Code Prefix" + P_ConCurAdv.EmployeeOrgUnit3Code + '-' +
        //                                L_Year + P_ConCurAdv."CH/TVL" + '-' + L_Mon + L_Num;
        //TEC.VJ 30Oct2025 >> Comment for Company Code Prefix
        //TEC.VJ 30Oct2025 <<
        CompanyNameMapp.Get(CompanyName);
        GJL."External Document No.":=CompanyNameMapp.GetBCCompCode(P_ConCurAdv.EmployeeOrgUnit3Code) + '-' + L_Year + P_ConCurAdv."CH/TVL" + '-' + L_Mon + L_Num;
        //TEC.VJ 30Oct2025 >>
        GJL."Concur ID":=P_ConCurAdv."Concur ID";
        GJL."Report ID":=P_ConCurAdv.CashAdvanceId;
        GJL."Cash Advance":=true;
        GJL.Insert();
        VMT.Reset();
        VMT.SetRange(DBASE, CompanyName);
        if VMT.FindFirst()then GJL.Validate("Shortcut Dimension 1 Code", VMT.SEGMENT);
        GJL.validate("Shortcut Dimension 5 Code", P_ConCurAdv.EmployeeCustom12Code);
        GJL.validate("Shortcut Dimension 6 Code", P_ConCurAdv.EmployeeId);
        //TEC.VJ 30Oct2025 << Comment for Company Code Prefix
        // GJL.validate("Shortcut Dimension 8 Code", Apisetup."Company Code Prefix" + P_ConCurAdv.EmployeeOrgUnit3Code);
        //TEC.VJ 30Oct2025 >> Comment for Company Code Prefix
        //TEC.VJ 30Oct2025 <<
        CompanyNameMapp.Get(CompanyName);
        GJL.validate("Shortcut Dimension 8 Code", CompanyNameMapp.GetBCCompCode(P_ConCurAdv.EmployeeOrgUnit3Code));
        //TEC.VJ 30Oct2025 >>
        //P_ConCurAdv.f
        GJl.validate("Shortcut Dimension 2 Code", Apisetup."Cash Advance FD10");
        GJL.Modify;
    end;
    procedure GetAPIBankAccount(P_Curr: Code[20]): code[20]var
        BankAccSetup2: Record "Concur Bank Acc Setup";
    begin
        //IF 
        BankAccSetup.reset;
        BankAccSetup.SetRange("BC Company", CompanyName);
        BankAccSetup.SetRange("Cash Advance Bank Account", true);
        BankAccSetup.SetRange("Concur LCY Bank", true);
        BankAccSetup.FindFirst();
        IF P_Curr = BankAccSetup."Currency Code" then exit(BankAccSetup."Bank Account")
        else
        begin
            BankAccSetup2.reset;
            BankAccSetup2.SetRange("BC Company", CompanyName);
            BankAccSetup2.SetRange("Cash Advance Bank Account", true);
            BankAccSetup2.SetRange("Concur LCY Bank", false);
            IF BankAccSetup2.FindFirst()then exit(BankAccSetup2."Bank Account");
        end;
        //BankAccSetup.SetRange("Currency Code", P_Curr);
        //IF P_CH then
        //    BankAccSetup.SetRange("Concur LCY Bank", true)
        //else
        //    BankAccSetup.SetRange("Concur LCY Bank", false);
        //IF BankAccSetup.FindFirst() then
        //    Exit(BankAccSetup."Bank Account");
        exit('');
    end;
    procedure GetLastLineNo(): Integer var
        L_GJL: Record "Gen. Journal Line";
    begin
        L_GJL.Reset;
        L_GJL.SetRange("Journal Template Name", Apisetup."Cash Advance Template Name");
        L_GJL.SetRange("Journal Batch Name", Apisetup."Cash Advance Batch Name");
        IF L_GJL.FindLast()then exit(L_GJL."Line No.");
        exit(0);
    end;
    var Apisetup: Record "Concur API Setup";
    GJL: Record "Gen. Journal Line";
    BankAccSetup: Record "Concur Bank Acc Setup";
    BankAccSetup2: Record "Concur Bank Acc Setup";
    LastLineNo: Integer;
    VMT: Record VMT;
    CurrExRate: Record "Currency Exchange Rate";
}
