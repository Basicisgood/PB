codeunit 50224 "DA Desk Process"
{
    trigger OnRun()
    var
        MarStaging: Record "Marcura Payment Staging";
        CustvendNo: Code[20];
        CustvendType: Code[20];
        mStrpos: Integer;
        MarStaging2: record "Marcura Payment Staging";
        Company: Record Company;
        Bank: Record "Bank Account";
        IsCustomer: Boolean;
        IsVendor: Boolean;
        Customer: Record Customer;
        Vendor: Record Vendor;
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLEdgEntry: Record "Vendor Ledger Entry";
        MarcuraSetup: record "Marcura Setup";
        GenJnlLine: Record "Gen. Journal Line";
        CU50190: Codeunit 50190;
        LineNo: Integer;
        GlEntry: Record "G/L Entry";
        CUMarcuraPosting: Codeunit 50226;
        CentralPayment: Record "PB Central Payment History";
        IMOSBankMapping: record "IMOS Bank Mapping";
        CompanyMapping: record "Company Name Mapping";
        //P1381: Page 1381;
        CU50220: Codeunit 50220;
    begin
        //CU50220.Run();
        MarcuraSetup.Get();
        MarStaging.Reset();
        MarStaging.SetFilter(Status, '=%1|%2', MarStaging.Status::Error, MarStaging.Status::Pending);
        if MarStaging.FindSet()then begin
            repeat //if MarStaging."Debit Account Name" = 'Pacific Basin Handysize Limited' then
                //  MarStaging."BC Company Code" := '0706'
                //else
                //  MarStaging."BC Company Code" := '0719';
                CompanyMapping.reset();
                CompanyMapping.SetRange("Marcura Debit Bank Account No", MarStaging."Debit Account IBAN");
                if CompanyMapping.FindFirst()then MarStaging."BC Company Code":=CompanyMapping."BC Company Name"
                else
                begin
                    MarStaging.Status:=MarStaging.Status::Error;
                    MarStaging."Error Description":='No Company Mapping found for Marcura Bank IBAN: ' + MarStaging."Debit Account IBAN";
                    MarStaging.Modify();
                    continue;
                end;
                Bank.Reset();
                bank.ChangeCompany(MarStaging."BC Company Code");
                Bank.SetRange("Bank Account No.", MarStaging."Debit Account IBAN");
                Bank.FindFirst();
                MarStaging."BC  Bank Code":=Bank."No.";
                MarStaging."Posting Date":=DT2Date(MarStaging."Bank Statement Date");
                //MarStaging."target Company Code" := '0' + CopyStr(MarStaging."IMOS Transaction ID", 4, 3);
                CompanyMapping.Reset();
                CompanyMapping.SetRange("IMOS Company code", CopyStr(MarStaging."IMOS Transaction ID", 4, 3));
                if CompanyMapping.FindSet()then MarStaging."Target Company Code":=CompanyMapping."BC Company Name"
                else
                begin
                    MarStaging.Status:=MarStaging.Status::Error;
                    MarStaging."Error Description":='No Company Mapping found for IMOS Company Code: ' + CopyStr(MarStaging."IMOS Transaction ID", 4, 3);
                    MarStaging.Modify();
                    continue;
                end;
                CustvendNo:='';
                CustvendType:='';
                mStrpos:=StrPos(MarStaging."Counter Party Reference No.", '_');
                if mStrpos > 0 then begin
                    CustvendNo:=CopyStr(MarStaging."Counter Party Reference No.", 1, mStrpos - 1);
                    CustvendType:=CopyStr(MarStaging."Counter Party Reference No.", mStrpos + 1);
                end;
                MarStaging."Customer/Vendor No":=CustvendNo;
                MarStaging."Vendor Type":=CustvendType;
                // duplicate checking
                MarStaging2.Reset();
                MarStaging2.SetRange("Transaction Id", MarStaging."Transaction Id");
                MarStaging2.SetFilter("Entry No.", '<>%1', MarStaging."Entry No.");
                if MarStaging2.FindSet()then begin
                    MarStaging.Status:=MarStaging.Status::Cancel;
                    MarStaging."Error Description":='Duplicate Transaction Id: ' + Format(MarStaging."Transaction Id");
                end;
                MarStaging.Modify();
            until MarStaging.Next() = 0;
            Commit();
        end;
        MarStaging.Reset();
        MarStaging.SetFilter(Status, '=%1|%2', MarStaging.Status::Error, MarStaging.Status::Pending);
        //MarStaging.SetRange("Target Company Code", CompanyName);
        MarStaging.SetFilter("Target Company Code", '<>%1', '');
        if MarStaging.FindSet()then begin
            repeat IsCustomer:=false;
                IsVendor:=false;
                Vendor.Reset();
                Vendor.ChangeCompany(MarStaging."Target Company Code");
                if Vendor.get(MarStaging."Customer/Vendor No")then begin
                    IsVendor:=true;
                    MarStaging."Account Type":=MarStaging."Account Type"::Vendor;
                end
                else
                begin
                    Customer.Reset();
                    Customer.ChangeCompany(MarStaging."Target Company Code");
                    if Customer.get(MarStaging."Customer/Vendor No")then begin
                        IsCustomer:=true;
                        MarStaging."Account Type":=MarStaging."Account Type"::Customer;
                    end;
                end;
                if not IsCustomer and not IsVendor then begin
                    MarStaging.Status:=MarStaging.Status::Error;
                    MarStaging."Error Description":='Invalid Customer/Vendor No: ' + MarStaging."Customer/Vendor No";
                end
                else
                begin
                    MarStaging.Status:=MarStaging.Status::Pending;
                end;
                if IsCustomer then begin
                    CustLedgEntry.Reset();
                    CustLedgEntry.ChangeCompany(MarStaging."Target Company Code");
                    CustLedgEntry.SetRange("IMOS Transaction No", MarStaging."IMOS Transaction ID");
                    CustLedgEntry.SetRange("Customer No.", MarStaging."Customer/Vendor No");
                    CustLedgEntry.SetRange(Open, true);
                    CustLedgEntry.SetRange(Reversed, false);
                    if not CustLedgEntry.FindFirst()then begin
                        MarStaging.Status:=MarStaging.Status::Error;
                        MarStaging."Error Description":='Customer Ledger Entry not found for IMOS Transaction No: ' + MarStaging."IMOS Transaction ID";
                    end
                    else
                    begin
                        Marstaging."BC Document No":=CustLedgEntry."Document No.";
                        MarStaging.Status:=MarStaging.Status::Pending;
                    end;
                end
                else if IsVendor then begin
                        VendLEdgEntry.Reset();
                        VendLEdgEntry.ChangeCompany(MarStaging."Target Company Code");
                        VendLEdgEntry.SetRange("IMOS Transaction No", MarStaging."IMOS Transaction ID");
                        VendLEdgEntry.SetRange("Vendor No.", MarStaging."Customer/Vendor No");
                        VendLEdgEntry.SetRange(Open, true);
                        VendLEdgEntry.SetRange(Reversed, false);
                        if not VendLEdgEntry.FindFirst()then begin
                            MarStaging.Status:=MarStaging.Status::Error;
                            MarStaging."Error Description":='Vendor Ledger Entry not found for IMOS Transaction No: ' + MarStaging."IMOS Transaction ID";
                        end
                        else
                        begin
                            MarStaging.Status:=MarStaging.Status::Pending;
                            MarStaging."BC Document No":=VendLEdgEntry."Document No.";
                        end;
                    end;
                MarStaging.Modify();
            until MarStaging.Next() = 0;
        end;
        MarStaging.Reset();
        MarStaging.Reset();
        MarStaging.SetFilter("Status", '=%1|%2', MarStaging."Status"::Pending, MarStaging."Status"::Error);
        MarStaging.SetFilter("BC Document No", '<>%1', ''); // only process records with BC Document No
        MarStaging.SetRange("BC Company Code", CompanyName);
        //MarStaging.SetRange("Entry No.", 7379, 7380);
        if MarStaging.FindSet()then repeat Commit();
                clear(CUMarcuraPosting);
                if CUMarcuraPosting.run(MarStaging)then begin
                //MarStaging."Status" := MarStaging."Status"::Processed;
                //MarStaging."Error Description" := '';
                //MarStaging.Modify(true);
                end
                else
                begin
                    MarStaging."Status":=MarStaging."Status"::Error;
                    MarStaging."Error Description":=GetLastErrorText();
                    MarStaging.Modify(true);
                end;
            until MarStaging.Next() = 0;
        exit;
        MarStaging.Reset();
        MarStaging.SetFilter("Status", '=%1', MarStaging."Status"::Processed);
        MarStaging.SetRange("Posted Document No", '');
        MarStaging.SetRange("BC Company Code", CompanyName);
        MarStaging.SetFilter("BC Document No", '<>%1', '');
        if MarStaging.FindSet()then repeat GLEntry.Reset();
                GLEntry.SetRange("Marcura Entry No", MarStaging."Entry No.");
                GLEntry.SetRange(Reversed, false);
                if GLEntry.FindLast()then begin
                    MarStaging."Posted Document No":=GLEntry."Document No.";
                    CentralPayment.Init();
                    CentralPayment."Entry No.":=0;
                    if MarStaging."Account Type" = MarStaging."Account Type"::Customer then CentralPayment."Entry Type":=CentralPayment."Entry Type"::Customer
                    else if MarStaging."Account Type" = MarStaging."Account Type"::Vendor then CentralPayment."Entry Type":=CentralPayment."Entry Type"::Vendor;
                    CentralPayment."No.":=MarStaging."Customer/Vendor No";
                    CentralPayment."Source Company":=MarStaging."BC Company Code";
                    CentralPayment."Source Document No":=MarStaging."Posted Document No";
                    CentralPayment.Amount:=-1 * MarStaging."Payment Amount";
                    CentralPayment."Exchange Rate":=MarStaging."Bank Exchange Rate";
                    CentralPayment."Currency Code":=MarStaging."Payment Currency";
                    CentralPayment."Target Company":=MarStaging."Target Company Code";
                    CentralPayment."Applied Document No.":=MarStaging."BC Document No";
                    CentralPayment."Creation DatenTime":=CurrentDateTime;
                    CentralPayment."Posting Date":=MarStaging."Posting Date";
                    CentralPayment."Document Date":=MarStaging."Posting Date";
                    //CentralPayment."Gen Jnl Line GUIID" := GraphMgmtTool.GetIdWithoutBrackets(P_GJL.SystemId);
                    CentralPayment."Bank Document No.":='';
                    CentralPayment."Invoice External No.":=MarStaging."IMOS Reference No.";
                    CentralPayment."IMOS Transaction No":=MarStaging."IMOS Transaction ID";
                    IMOSBankMapping.Reset();
                    IMOSBankMapping.SetRange("BC Bank Code", MarStaging."BC  Bank Code");
                    if IMOSBankMapping.FindSet()then CentralPayment."Bank ID":=IMOSBankMapping."IMOS Bank ID";
                    CentralPayment.Insert();
                    MarStaging."Central Payment Entry No.":=CentralPayment."Entry No.";
                    MarStaging.Modify();
                end;
            until MarStaging.Next() = 0;
        commit;
        exit;
        MarStaging.Reset();
        MarStaging.SetFilter(Status, '=%1|%2', MarStaging.Status::Error, MarStaging.Status::Pending);
        MarStaging.SetRange("Target Company Code", CompanyName);
        MarStaging.SetFilter("BC Document No", '=%1', '');
        if MarStaging.FindSet()then begin
            repeat LineNo:=LineNo + 1;
                GenJnlLine.Reset();
                GenJnlLine.Init();
                GenJnlLine.Validate("Journal Template Name", MarcuraSetup."Payment Template Name");
                GenJnlLine.Validate("Journal Batch Name", MarcuraSetup."Payment Batch Name");
                GenJnlLine.Validate("Line No.", LineNo);
                GenJnlLine.Validate("Posting Date", MarStaging."Posting Date");
                if MarStaging."Account Type" = MarStaging."Account Type"::Customer then begin
                    GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::Customer);
                    GenJnlLine.Validate("Account No.", MarStaging."Customer/Vendor No");
                    GenJnlLine.Validate("Document No.", MarStaging."IMOS Transaction ID");
                    GenJnlLine.Validate("Currency Code", MarStaging."Payment Currency");
                    GenJnlLine.Validate("Amount", -1 * MarStaging."Payment Amount");
                    GenJnlLine."IMOS Transaction No":=MarStaging."IMOS Transaction ID";
                    GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                    GenJnlLine.validate("Bal. Account No.", '101001');
                end
                else if MarStaging."Account Type" = MarStaging."Account Type"::Vendor then begin
                        GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::Vendor);
                        GenJnlLine.Validate("Account No.", MarStaging."Customer/Vendor No");
                        GenJnlLine.Validate("Document No.", MarStaging."IMOS Transaction ID");
                        GenJnlLine.Validate("Currency Code", MarStaging."Payment Currency");
                        GenJnlLine.Validate("Amount", -1 * MarStaging."Payment Amount");
                        GenJnlLine."IMOS Transaction No":=MarStaging."IMOS Transaction ID";
                        GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine.validate("Bal. Account No.", '101001');
                    end;
                GenJnlLine.Insert(true);
            until MarStaging.Next() = 0;
        end;
    end;
}
