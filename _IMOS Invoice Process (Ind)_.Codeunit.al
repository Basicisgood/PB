codeunit 50173 "IMOS Invoice Process (Ind)"
{
    trigger OnRun()
    var
        IMOSInvoiceStaging: Record "IMOS Invoice Staging Table";
        VMT: record VMT;
        IMOSInvLine: record "IMOS Invoice Line";
        CompanyMapping: record "Company Name Mapping";
        CuIMOSInvPost: Codeunit "IMOS Invoice Posting";
        BCCompanyCode: Text;
        GLEntry: record "G/L Entry";
        LineCounter: Integer;
        GlAmount: Decimal;
    begin
        IMOSInvoiceStaging.Reset();
        IMOSInvoiceStaging.SetFilter("BC Status", '=%1|%2', IMOSInvoiceStaging."BC Status"::Pending, IMOSInvoiceStaging."BC Status"::Error);
        if IMOSInvoiceStaging.FindSet()then repeat IMOSInvLine.Reset();
                IMOSInvLine.SetRange("Invoice Entry No.", IMOSInvoiceStaging."Entry No.");
                IMOSInvLine.SetRange(baseCurrencyAmount, 0);
                IMOSInvLine.SetRange(currencyAmount, 0);
                if IMOSInvLine.FindSet()then IMOSInvLine.DeleteAll();
            until IMOSInvoiceStaging.Next() = 0;
        Commit();
        IMOSInvoiceStaging.Reset();
        IMOSInvoiceStaging.SetFilter("BC Status", '=%1|%2', IMOSInvoiceStaging."BC Status"::Pending, IMOSInvoiceStaging."BC Status"::Error);
        if IMOSInvoiceStaging.FindSet()then repeat if IMOSInvoiceStaging.transType = 5 then DataValidity(IMOSInvoiceStaging);
            until IMOSInvoiceStaging.Next() = 0;
        Commit();
        IMOSInvoiceStaging.Reset();
        IMOSInvoiceStaging.SetFilter("BC Status", '=%1|%2', IMOSInvoiceStaging."BC Status"::Pending, IMOSInvoiceStaging."BC Status"::Error);
        if IMOSInvoiceStaging.FindSet()then repeat SplitTransaction(IMOSInvoiceStaging);
                ChecknCreateDimensions(IMOSInvoiceStaging);
                if(IMOSInvoiceStaging.Status = '1') or (IMOSInvoiceStaging.Status = 'R')then begin
                    if IMOSInvoiceStaging."BC Company Code" = '' then begin
                        IMOSInvLine.Reset();
                        IMOSInvLine.SetRange("Invoice Entry No.", IMOSInvoiceStaging."Entry No.");
                        IMOSInvLine.SetFilter(companyCode, '<>%1', '');
                        if IMOSInvLine.FindSet()then begin
                            BCCompanyCode:='';
                            BCCompanyCode:=CopyStr(IMOSInvLine.companyCode, 2);
                            CompanyMapping.Reset();
                            CompanyMapping.SetRange("IMOS Company code", BCCompanyCode);
                            CompanyMapping.findset;
                            BCCompanyCode:=CompanyMapping."BC Company Name";
                            // BCCompanyCode := '0' + CopyStr(IMOSInvLine.companyCode, 2);
                            VMT.Reset();
                            vmt.SetFilter(DBASE, BCCompanyCode);
                            if VMT.FindSet()then begin
                                CompanyMapping.Reset();
                                CompanyMapping.SetRange("PB Company Code", VMT.DBASE);
                                CompanyMapping.FindSet();
                                IMOSInvoiceStaging."BC Company Code":=CompanyMapping."BC Company Name";
                                IMOSInvoiceStaging."Error Description":='';
                            end
                            else
                            begin
                                IMOSInvoiceStaging."BC Status":=IMOSInvoiceStaging."BC Status"::Error;
                                IMOSInvoiceStaging."Error Description":=StrSubstNo('VMT mapping not found for %1 Company', BCCompanyCode);
                                IMOSInvoiceStaging.Modify(true);
                            end;
                        end;
                        IMOSInvoiceStaging.Modify();
                    end;
                end
                else
                begin
                    IMOSInvoiceStaging."BC Status":=IMOSInvoiceStaging."BC Status"::Cancel;
                    IMOSInvoiceStaging."Error Description":='Invalid type';
                    IMOSInvoiceStaging.Modify(true);
                end;
            until IMOSInvoiceStaging.Next() = 0;
        // Finance Company Posting
        IMOSInvoiceStaging.Reset();
        IMOSInvoiceStaging.Reset();
        IMOSInvoiceStaging.SetFilter("BC Status", '=%1|%2', IMOSInvoiceStaging."BC Status"::Pending, IMOSInvoiceStaging."BC Status"::Error);
        IMOSInvoiceStaging.SetRange("BC Company Code", CompanyName);
        if IMOSInvoiceStaging.FindSet()then repeat Commit();
                clear(CuIMOSInvPost);
                if CuIMOSInvPost.run(IMOSInvoiceStaging)then begin
                    IMOSInvoiceStaging."BC Status":=IMOSInvoiceStaging."BC Status"::Processed;
                    IMOSInvoiceStaging."Error Description":='';
                    IMOSInvoiceStaging.Modify(true);
                end
                else
                begin
                    IMOSInvoiceStaging."BC Status":=IMOSInvoiceStaging."BC Status"::Error;
                    IMOSInvoiceStaging."Error Description":=GetLastErrorText();
                    IMOSInvoiceStaging.Modify(true);
                end;
            until IMOSInvoiceStaging.Next() = 0;
        IMOSInvoiceStaging.Reset();
        IMOSInvoiceStaging.Reset();
        IMOSInvoiceStaging.SetFilter("BC Status", '=%1', IMOSInvoiceStaging."BC Status"::Processed);
        IMOSInvoiceStaging.SetRange("Posted Document No", '');
        IMOSInvoiceStaging.SetRange("BC Company Code", CompanyName);
        if IMOSInvoiceStaging.FindSet()then repeat GLEntry.Reset();
                GLEntry.SetCurrentKey("IMOS Transaction No");
                GLEntry.SetRange("IMOS Transaction No", IMOSInvoiceStaging.transNo);
                GLEntry.SetRange(Reversed, false);
                if GLEntry.FindLast()then begin
                    IMOSInvoiceStaging."Posted Document No":=GLEntry."Document No.";
                    IMOSInvoiceStaging.Modify();
                end;
            until IMOSInvoiceStaging.Next() = 0;
        commit;
        // Update Other Fields
        IMOSInvoiceStaging.Reset();
        IMOSInvoiceStaging.SetFilter("BC Status", '=%1', IMOSInvoiceStaging."BC Status"::Processed);
        IMOSInvoiceStaging.SetFilter("Posted Document No", '<>%1', '');
        IMOSInvoiceStaging.SetRange("BC Company Code", CompanyName);
        if IMOSInvoiceStaging.FindSet()then repeat GlAmount:=0;
                LineCounter:=0;
                GLEntry.Reset();
                GLEntry.SetCurrentKey("Document No.");
                GLEntry.SetRange("Document No.", IMOSInvoiceStaging."Posted Document No");
                if GLEntry.FindSet()then repeat GlAmount:=GlAmount + GLEntry."Debit Amount";
                        LineCounter:=LineCounter + 1;
                    until GLEntry.Next() = 0;
                IMOSInvoiceStaging."No of Lines in BC":=LineCounter;
                IMOSInvoiceStaging."Amount Posted in BC":=GlAmount;
                if GLEntry.Reversed then IMOSInvoiceStaging."Reversed in BC":=true;
                IMOSInvoiceStaging.Modify();
            until IMOSInvoiceStaging.Next() = 0;
    end;
    procedure ChecknCreateDimensions(var iIMOSStaging: record "IMOS Invoice Staging Table")
    var
        IMOSInvLine: record "IMOS Invoice Line";
        DImValue: record "Dimension Value";
        Companies: record Company;
        CompMapping: record "Company Name Mapping";
        TCCode: Code[20];
    begin
        CompMapping.Reset();
        CompMapping.Get(CompanyName);
        //if not CompMapping."Master Data Company" then exit;
        IMOSInvLine.Reset();
        IMOSInvLine.SetRange("Invoice Entry No.", iIMOSStaging."Entry No.");
        if IMOSInvLine.FindSet()then begin
            repeat TCCode:='';
                if iIMOSStaging.tcCode = '' then tccode:=IMOSInvLine.voyageTCICode
                else
                    TCCode:=format(iIMOSStaging.tcCode);
                IF IMOSInvLine.vesselCode <> '' then begin
                    if not DImValue.get('FD2', IMOSInvLine.vesselCode)then begin
                        DImValue.Reset();
                        DImValue.Init();
                        DImValue.validate("Dimension Code", 'FD2');
                        DImValue.Validate(Code, IMOSInvLine.vesselCode);
                        DImValue.Validate(Name, IMOSInvLine.vesselCode);
                        DImValue.Insert(true);
                        DImValue."Global Dimension No.":=10;
                        DImValue.Modify();
                    end;
                    DImValue.Reset();
                    CompMapping.Reset();
                    CompMapping.SetRange("IMOS Company", true);
                    if CompMapping.FindSet()then repeat DImValue.Reset();
                            DImValue.ChangeCompany(CompMapping."BC Company Name");
                            if not DImValue.get('FD2', IMOSInvLine.vesselCode)then begin
                                DImValue.Reset();
                                DImValue.ChangeCompany(CompMapping."BC Company Name");
                                DImValue.Init();
                                DImValue.validate("Dimension Code", 'FD2');
                                DImValue.Validate(Code, IMOSInvLine.vesselCode);
                                DImValue.Validate(Name, IMOSInvLine.vesselCode);
                                DImValue.Insert(true);
                                DImValue."Global Dimension No.":=10;
                                DImValue.Modify();
                            end;
                        until CompMapping.Next() = 0;
                end;
                IF TCCode <> '' then begin
                    DImValue.Reset();
                    //                    DImValue.Setfilter("Dimension Code", 'FD4');
                    //                  DImValue.Setfilter(code, TCCode);
                    //                if not DImValue.FindSet() then begin
                    DImValue.Reset();
                    DImValue.Init();
                    DImValue.validate("Dimension Code", 'FD4');
                    DImValue.Validate(Code, TCCode);
                    DImValue.Validate(Name, TCCode);
                    if DImValue.Insert(true)then;
                    //DImValue."Global Dimension No." := 4;
                    //DImValue.Modify();
                    //              end;
                    DImValue.Reset();
                    CompMapping.Reset();
                    CompMapping.SetRange("IMOS Company", true);
                    if CompMapping.FindSet()then repeat //DImValue.Reset();
                            //DImValue.ChangeCompany(CompMapping."BC Company Name");
                            //DImValue.setfilter("Dimension Code", 'FD4');
                            //DImValue.SetFilter(code, TCCode);
                            //if not DImValue.FindSet() then begin
                            DImValue.Reset();
                            DImValue.ChangeCompany(CompMapping."BC Company Name");
                            DImValue.Init();
                            DImValue.validate("Dimension Code", 'FD4');
                            DImValue.Validate(Code, TCCode);
                            DImValue.Validate(Name, TCCode);
                            if DImValue.Insert(true)then;
                        //DImValue."Global Dimension No." := 4;
                        //DImValue.Modify();
                        //end;
                        until CompMapping.Next() = 0;
                end;
            until IMOSInvLine.Next() = 0;
        end;
        Commit();
        ;
    //                GenJnlLine.Validate("Shortcut Dimension 10 Code", IMOSInvLine.vesselCode);
    //        if rec.tcCode = '' then
    //          GenJnlLine.Validate("Shortcut Dimension 4 Code", format(IMOSInvLine.voyageTCICode))
    //    else
    //      GenJnlLine.Validate("Shortcut Dimension 4 Code", format(rec.tcCode));
    end;
    procedure SplitTransaction(var iIMOSStaging: record "IMOS Invoice Staging Table")
    var
        IMOSInvLine: record "IMOS Invoice Line";
        tmpItem: record Item temporary;
        Counter: Integer;
        ICCompany: Text;
        IMOSStaging2: record "IMOS Invoice Staging Table";
        IMOSInvLine2: record "IMOS Invoice Line";
    begin
        Counter:=0;
        ICCompany:='';
        if tmpItem.FindSet()then tmpItem.DeleteAll();
        IMOSInvLine.Reset();
        IMOSInvLine.SetRange("Invoice Entry No.", iIMOSStaging."Entry No.");
        if IMOSInvLine.FindSet()then begin
            ICCompany:=IMOSInvLine.companyCode;
            repeat tmpItem.Reset();
                if not tmpItem.get(IMOSInvLine.companyCode)then begin
                    tmpItem.Reset();
                    tmpItem.Init();
                    tmpItem."No.":=IMOSInvLine.companyCode;
                    tmpItem.Insert();
                    Counter:=Counter + 1;
                end;
            until IMOSInvLine.Next() = 0;
        end;
        if Counter <= 1 then exit;
        iIMOSStaging."IC Transaction":=true;
        iIMOSStaging.Modify();
        tmpItem.Reset();
        tmpItem.SetFilter("No.", '<>%1', ICCompany);
        tmpItem.FindSet();
        repeat IMOSStaging2.Reset();
            IMOSStaging2.Init();
            IMOSStaging2.TransferFields(iIMOSStaging);
            IMOSStaging2."Entry No.":=0;
            IMOSStaging2."BC Company Code":='';
            IMOSStaging2.Insert();
            IMOSInvLine.Reset();
            IMOSInvLine.SetRange("Invoice Entry No.", iIMOSStaging."Entry No.");
            IMOSInvLine.SetRange(companyCode, tmpItem."No.");
            if IMOSInvLine.FindSet()then repeat IMOSInvLine2.Reset();
                    IMOSInvLine2.Init();
                    IMOSInvLine2.TransferFields(IMOSInvLine);
                    IMOSInvLine2."Invoice Entry No.":=IMOSStaging2."Entry No.";
                    IMOSInvLine2.Insert();
                until IMOSInvLine.Next() = 0;
            IMOSInvLine.Reset();
            IMOSInvLine.SetRange("Invoice Entry No.", iIMOSStaging."Entry No.");
            IMOSInvLine.SetRange(companyCode, tmpItem."No.");
            if IMOSInvLine.FindSet()then IMOSInvLine.DeleteAll();
        until tmpItem.Next() = 0;
        Commit();
    end;
    procedure DataValidity(var iIMOSStaging: record "IMOS Invoice Staging Table")
    var
        IMOSInvLine: record "IMOS Invoice Line";
        GLAccount: record "G/L Account";
    begin
        IMOSInvLine.Reset();
        IMOSInvLine.SetRange("Invoice Entry No.", iIMOSStaging."Entry No.");
        IMOSInvLine.SetFilter(deptCode, '=%1|%2', 'AR', 'AP');
        if IMOSInvLine.FindSet()then begin
            repeat if GLAccount.Get(IMOSInvLine.ledgerCode)then begin
                    iIMOSStaging."BC Status":=iIMOSStaging."BC Status"::Cancel;
                    iIMOSStaging."Error Description":='AUTO CANCEL. GJ WITH AR/AP CODES';
                    iIMOSStaging.Modify();
                    exit;
                end;
            until IMOSInvLine.Next() = 0;
            IMOSInvLine.Reset();
            IMOSInvLine.SetRange("Invoice Entry No.", iIMOSStaging."Entry No.");
            IMOSInvLine.SetFilter(deptCode, '=%1', 'GL');
            if IMOSInvLine.FindSet()then begin
                repeat if strlen(IMOSInvLine.ledgerCode) > 6 then begin
                        iIMOSStaging."BC Status":=iIMOSStaging."BC Status"::Cancel;
                        iIMOSStaging."Error Description":='AUTO CANCEL. GJ WITH wrong GL CODES';
                        iIMOSStaging.Modify();
                        exit;
                    end;
                until IMOSInvLine.Next() = 0;
            end;
        end;
    end;
}
