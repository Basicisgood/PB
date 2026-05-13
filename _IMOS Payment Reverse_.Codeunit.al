codeunit 50214 "IMOS Payment Reverse"
{
    trigger OnRun()
    var
        IMOSPayRevStaging: record "IMOS Payment Reversal Staging";
        IMOSPayRevLines: Record "IMOS Payment Reversal Line";
        IMOSPayRevDetails: record "IMOS Pay Reversal Details";
        CustVendNo: Code[20];
        CustVendType: Code[20];
        mStrpos: Integer;
        LcyCurrency: code[10];
        ImosSetup: Record "IMOS Setup";
        IMOSBankMapping: Record "IMOS Bank Mapping";
        COANo: Code[20];
        CUIMOSPayRevPosting: Codeunit "IMOS Payment Reverse Posting";
        GLEntry: Record "G/L Entry";
    begin
        LcyCurrency:='USD';
        ImosSetup.Get();
        IMOSPayRevStaging.Reset();
        IMOSPayRevStaging.SetFilter(Status, '=%1|%2', IMOSPayRevStaging.Status::Error, IMOSPayRevStaging.Status::Pending);
        if IMOSPayRevStaging.FindSet()then repeat if IMOSPayRevStaging."BC Company Code" = '' then begin
                    IMOSPayRevLines.Reset();
                    IMOSPayRevLines.SetRange("Reverse Entry No.", IMOSPayRevStaging."Entry No.");
                    if IMOSPayRevLines.FindSet()then IMOSPayRevStaging."BC Company Code":='0' + CopyStr(IMOSPayRevLines."Company Code", 2);
                    IMOSPayRevStaging.Modify();
                end;
                IMOSPayRevDetails.Reset();
                IMOSPayRevDetails.SetRange("Entry No.", IMOSPayRevStaging."Entry No.");
                if IMOSPayRevDetails.FindSet()then IMOSPayRevDetails.DeleteAll();
                if 1 = 1 then begin
                    IMOSPayRevLines.Reset();
                    IMOSPayRevLines.SetRange("Reverse Entry No.", IMOSPayRevStaging."Entry No.");
                    if IMOSPayRevLines.FindSet()then repeat CustVendNo:='';
                            CustVendType:='';
                            mStrpos:=StrPos(IMOSPayRevLines."Vendor External Reference No", '_');
                            if mStrpos > 0 then begin
                                CustVendNo:=CopyStr(IMOSPayRevLines."Vendor External Reference No", 1, mStrpos - 1);
                                CustVendType:=CopyStr(IMOSPayRevLines."Vendor External Reference No", mStrpos + 1);
                            end;
                            COANo:='';
                            IMOSBankMapping.Reset();
                            IMOSBankMapping.SetRange("IMOS Bank ID", IMOSPayRevLines."Bank Code");
                            if IMOSBankMapping.FindSet()then COANo:=IMOSBankMapping."Dummy GL Code";
                            IMOSPayRevDetails.Reset();
                            IMOSPayRevDetails.SetRange("Entry No.", IMOSPayRevStaging."Entry No.");
                            IMOSPayRevDetails.SetRange("No.", CustVendNo);
                            IMOSPayRevDetails.SetRange(Type, CustVendType);
                            IMOSPayRevDetails.SetRange("Vessal Code", IMOSPayRevLines."Vessel Code");
                            if IMOSPayRevLines."Currency Amount" <> 0 then begin
                                IMOSPayRevDetails.SetRange("Currency code", IMOSPayRevLines.Currency);
                                IMOSPayRevDetails.SetRange("COA No", COANo);
                            end
                            else
                            begin
                                IMOSPayRevDetails.SetRange("Currency code", LcyCurrency);
                                IMOSPayRevDetails.SetRange("COA No", ImosSetup."Exch Gain/Loss Account");
                                COANo:=ImosSetup."Exch Gain/Loss Account";
                            end;
                            if not IMOSPayRevDetails.FindSet()then begin
                                IMOSPayRevDetails.Reset();
                                IMOSPayRevDetails.Init();
                                IMOSPayRevDetails."Entry No.":=IMOSPayRevStaging."Entry No.";
                                if CustVendType = 'C' then IMOSPayRevDetails."Account Type":=IMOSPayRevDetails."Account Type"::Customer
                                else
                                    IMOSPayRevDetails."Account Type":=IMOSPayRevDetails."Account Type"::Vendor;
                                IMOSPayRevDetails."No.":=CustVendNo;
                                IMOSPayRevDetails.Type:=CustVendType;
                                IMOSPayRevDetails."COA No":=COANo;
                                IMOSPayRevDetails."Vessal Code":=IMOSPayRevLines."Vessel Code";
                                if IMOSPayRevLines."Currency Amount" <> 0 then begin
                                    IMOSPayRevDetails."Currency code":=IMOSPayRevLines.Currency;
                                    IMOSPayRevDetails.Amount:=IMOSPayRevLines."Currency Amount";
                                end
                                else
                                begin
                                    IMOSPayRevDetails."Currency code":=LcyCurrency;
                                    IMOSPayRevDetails.Amount:=IMOSPayRevLines."Base Currency Amount";
                                end;
                                IMOSPayRevDetails."Amount LCY":=IMOSPayRevLines."Base Currency Amount";
                                IMOSPayRevDetails.Insert();
                            end
                            else
                            begin
                                if IMOSPayRevLines."Currency Amount" <> 0 then IMOSPayRevDetails.Amount:=IMOSPayRevDetails.Amount + IMOSPayRevLines."Currency Amount"
                                else
                                    IMOSPayRevDetails.Amount:=IMOSPayRevDetails.Amount + IMOSPayRevLines."Base Currency Amount";
                                IMOSPayRevDetails."Amount LCY":=IMOSPayRevDetails."Amount LCY" + IMOSPayRevLines."Base Currency Amount";
                                IMOSPayRevDetails.Modify();
                            end;
                        until IMOSPayRevLines.Next() = 0;
                end;
            until IMOSPayRevStaging.Next() = 0;
        //Posting
        IMOSPayRevStaging.Reset();
        IMOSPayRevStaging.SetFilter(Status, '=%1|%2', IMOSPayRevStaging.Status::Error, IMOSPayRevStaging.Status::Pending);
        IMOSPayRevStaging.setrange("BC Company Code", CompanyName);
        if IMOSPayRevStaging.FindSet()then repeat Commit();
                Clear(CUIMOSPayRevPosting);
                if CUIMOSPayRevPosting.Run(IMOSPayRevStaging)then begin
                    IMOSPayRevStaging.Status:=IMOSPayRevStaging.Status::Processed;
                    IMOSPayRevStaging."Error Description":='';
                    IMOSPayRevStaging.Modify();
                end
                else
                begin
                    IMOSPayRevStaging.Status:=IMOSPayRevStaging.Status::Error;
                    IMOSPayRevStaging."Error Description":=GetLastErrorText();
                    IMOSPayRevStaging.Modify();
                end;
            until IMOSPayRevStaging.Next() = 0;
        //Update Posted Document No
        IMOSPayRevStaging.Reset();
        IMOSPayRevStaging.Reset();
        IMOSPayRevStaging.SetFilter("Status", '=%1', IMOSPayRevStaging."Status"::Processed);
        IMOSPayRevStaging.SetRange("Posted Document No", '');
        IMOSPayRevStaging.SetRange("BC Company Code", CompanyName);
        if IMOSPayRevStaging.FindSet()then repeat GLEntry.Reset();
                GLEntry.SetCurrentKey("IMOS Transaction No");
                GLEntry.SetRange("IMOS Transaction No", IMOSPayRevStaging."Payment Transaction No.");
                GLEntry.SetRange(Reversed, false);
                if GLEntry.FindLast()then begin
                    IMOSPayRevStaging."Posted Document No":=GLEntry."Document No.";
                    IMOSPayRevStaging.Modify();
                end;
            until IMOSPayRevStaging.Next() = 0;
        commit;
    end;
}
