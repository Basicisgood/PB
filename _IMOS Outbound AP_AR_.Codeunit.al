codeunit 50213 "IMOS Outbound AP/AR"
{
    trigger OnRun()
    begin
        UpdateInvList(21);
        UpdateInvList(25);
        UpdateAmountInfo(21);
        UpdateAmountInfo(25);
        UpdateIMOSInfo(21);
        UpdateIMOSInfo(25);
        GetBankID(0);
        //        exit;
        GetAndUpdateAPILOGForIRPayment;
        GetAndUpdateAPILOGForIRPaymentList;
        GetAndUpdateAPILOGForIRPayment_Vendor;
        GetAndUpdateAPILOGForIRPaymentList_VendorList;
    end;
    procedure GetBankID(mEntryNo: Integer)
    var
        IMOSAPILOG: Record "IMOS API Log";
        IMOSAPILOG2: Record "IMOS API Log";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        Centpayment: Record "PB Central Payment History";
        BLE: Record "Bank Account Ledger Entry";
        IMOSBankMapping: Record "IMOS Bank Mapping";
        Centpay: Record "PB Central Payment History";
        GLEntry: Record "G/L Entry";
    begin
        IMOSAPILOG.Reset();
        IMOSAPILOG.SetFilter("Bank ID", '=%1', '');
        IMOSAPILOG.SetRange("Company Code", CompanyName);
        IMOSAPILOG.SetFilter(Status, '=%1|%2', IMOSAPILOG.Status::Error, IMOSAPILOG.Status::Pending);
        if IMOSAPILOG.FindSet()then repeat BLE.Reset();
                BLE.SetRange("Document No.", IMOSAPILOG."Primary key 2");
                if BLE.FindSet()then begin
                    IMOSBankMapping.Reset();
                    IMOSBankMapping.SetRange("BC Bank Code", ble."Bank Account No.");
                    if IMOSBankMapping.FindSet()then IMOSAPILOG."Bank ID":=IMOSBankMapping."IMOS Bank ID";
                end;
                if IMOSAPILOG."Bank ID" = '' then begin
                    Centpay.Reset();
                    Centpay.SetRange("Target Processed Document No.", IMOSAPILOG."Primary key 2");
                    if Centpay.FindSet()then begin
                        BLE.Reset();
                        BLE.ChangeCompany(Centpay."Source Company");
                        BLE.SetRange("Document No.", Centpay."Source Gl Entry Document No");
                        if BLE.FindSet()then begin
                            IMOSBankMapping.Reset();
                            IMOSBankMapping.SetRange("BC Bank Code", ble."Bank Account No.");
                            if IMOSBankMapping.FindSet()then IMOSAPILOG."Bank ID":=IMOSBankMapping."IMOS Bank ID";
                        end;
                    end;
                end;
                if IMOSAPILOG."Bank ID" = '' then begin
                    GLEntry.Reset();
                    GLEntry.SetRange("Document No.", IMOSAPILOG."Primary key 2");
                    GLEntry.SetFilter("IMOS Bank ID", '<>%1', '');
                    if GLEntry.FindSet()then IMOSAPILOG."Bank ID":=GLEntry."IMOS Bank ID";
                end;
                IMOSAPILOG.Modify();
            until IMOSAPILOG.Next() = 0;
        Commit();
    end;
    procedure UpdateIMOSInfo(mtableNo: Integer)
    var
        IMOSAPILOG: Record "IMOS API Log";
        IMOSAPILOG2: Record "IMOS API Log";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        Centpayment: Record "PB Central Payment History";
    begin
        IMOSAPILOG.Reset();
        IMOSAPILOG.SetRange("Company Code", CompanyName);
        IMOSAPILOG.SetRange("Table No.", mtableNo);
        IMOSAPILOG.SetRange("Company Code", CompanyName);
        IMOSAPILOG.SetFilter(Status, '=%1|%2', IMOSAPILOG.Status::Error, IMOSAPILOG.Status::Pending);
        if IMOSAPILOG.FindSet()then repeat IF mtableNo = 21 then begin
                    CustLedgEntry.Reset();
                    CustLedgEntry.SetRange("Document No.", IMOSAPILOG."Primary key 3");
                    CustLedgEntry.FindSet();
                    IMOSAPILOG."IMOS Transaction No":=CustLedgEntry."IMOS Transaction No";
                end
                else if mtableNo = 25 then begin
                        VendLedgEntry.Reset();
                        VendLedgEntry.SetRange("Document No.", IMOSAPILOG."Primary key 3");
                        VendLedgEntry.FindSet();
                        IMOSAPILOG."IMOS Transaction No":=VendLedgEntry."IMOS Transaction No";
                    end;
                IMOSAPILOG.Modify();
            until IMOSAPILOG.Next() = 0;
        Commit();
    end;
    procedure UpdateAmountInfo(mtableNo: Integer)
    var
        IMOSAPILOG: Record "IMOS API Log";
        IMOSAPILOG2: Record "IMOS API Log";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        Centpayment: Record "PB Central Payment History";
    begin
        IMOSAPILOG.Reset();
        IMOSAPILOG.SetRange("Company Code", CompanyName);
        IMOSAPILOG.SetRange("Table No.", mtableNo);
        IMOSAPILOG.SetRange("Company Code", CompanyName);
        IMOSAPILOG.SetFilter(Status, '=%1|%2', IMOSAPILOG.Status::Error, IMOSAPILOG.Status::Pending);
        if IMOSAPILOG.FindSet()then repeat IF mtableNo = 21 then begin
                    CustLedgEntry.Reset();
                    CustLedgEntry.SetRange("Document No.", IMOSAPILOG."Primary key 2");
                    CustLedgEntry.FindSet();
                    IMOSAPILOG."Payment Amount LCY":=IMOSAPILOG."Payment Amount" / CustLedgEntry."Original Currency Factor";
                    IMOSAPILOG."Currency Factor":=CustLedgEntry."Original Currency Factor";
                    IMOSAPILOG."Over Receipt Amount":=0;
                    if CustLedgEntry."Over Receipt Amount" <> 0 then if CustLedgEntry."Over Receipt Amount" > 0 then begin
                            if IMOSAPILOG."Payment Amount" < 0 then IMOSAPILOG."Over Receipt Amount":=CustLedgEntry."Over Receipt Amount" * -1;
                        end
                        else
                        begin
                            if IMOSAPILOG."Payment Amount" > 0 then IMOSAPILOG."Over Receipt Amount":=CustLedgEntry."Over Receipt Amount" * -1;
                        end;
                end
                else if mtableNo = 25 then begin
                        VendLedgEntry.Reset();
                        VendLedgEntry.SetRange("Document No.", IMOSAPILOG."Primary key 2");
                        VendLedgEntry.FindSet();
                        IMOSAPILOG."Payment Amount LCY":=IMOSAPILOG."Payment Amount" / VendLedgEntry."Original Currency Factor";
                        IMOSAPILOG."Currency Factor":=VendLedgEntry."Original Currency Factor";
                        if VendLedgEntry."Bank Document No." <> '' then IMOSAPILOG."Bank Document No.":=VendLedgEntry."Bank Document No.";
                    end;
                Centpayment.Reset();
                Centpayment.SetRange("Target Company", CompanyName);
                Centpayment.SetRange("Target Processed Document No.", IMOSAPILOG."Primary key 2");
                if Centpayment.FindSet()then begin
                    if IMOSAPILOG."Bank ID" = '' then IMOSAPILOG."Bank ID":=Centpayment."Bank ID";
                    IMOSAPILOG."Bank Charge Amount":=Centpayment."Bank Charges";
                end;
                IMOSAPILOG.Modify();
            until IMOSAPILOG.Next() = 0;
        Commit();
    end;
    procedure GetAndUpdateAPILOGForIRPaymentList_VendorList()
    VAR
        IMOSAPILOG: Record "IMOS API Log";
        IMOSAPILOG2: Record "IMOS API Log";
        RecCustLedEntry: record "Vendor Ledger Entry";
        RecCustLedgEntry1: record "Vendor Ledger Entry";
        InvoiceExchXML: Label '<invoiceTransNo>%1</invoiceTransNo><entryDate>%2</entryDate><actDate>%3</actDate><externalRefId>%4</externalRefId><payMode>%5</payMode><bankCode>%6</bankCode><currencyAmount>%7</currencyAmount><bankCharge>%8</bankCharge><bankChargeCode>%9</bankChargeCode><baseCurrencyAmount>%10</baseCurrencyAmount><bankXCRate>%11</bankXCRate><memo>%12</memo>';
        InvoiceListLbl: Label '<invoice><invoiceTransNo>%1</invoiceTransNo><currencyAmount>%2</currencyAmount></invoice>';
        XMLData: Text[2048];
        CurrDate: Date;
        VendLEntDocNo: Code[20];
        InVTransNo: Text[50];
        EntryDate: text;
        ACtDate: text;
        ExtranalRefID: Text;
        PayMode: Text;
        bankCode: Text;
        CurrenyAmount: text;
        IMOSBankMapping: record "IMOS Bank Mapping";
        GLEntry: record "G/L Entry";
        BankCharge: Decimal;
        BankCharge_Txt: Text;
        BankChargeGL: Code[20];
        InvoiceData: Text;
        DecCurrencyAmount: Decimal;
        DecCurrencyAmountLCY: Decimal;
        CurrenyAmountLCY: Text;
        ExchRate: Text;
        Memo: Text;
    begin
        IMOSSetup.get;
        BankChargeGL:=IMOSSetup."Bank Charge GL Code";
        IMOSAPILOG.reset;
        IMOSAPILOG.SetRange("Table No.", Database::"Vendor Ledger Entry");
        IMOSAPILOG.SetFilter(Status, '<>%1', IMOSAPILOG.Status::Success);
        IMOSAPILOG.SetRange("Company Code", CompanyName);
        //IMOSAPILOG.SetRange("Entry No.", 824898, 824907);
        //IMOSAPILOG.SetFilter("Primary key 2", '=%1|%2|%3|%4', '0798-RCFBJ-25000388', '0798-RCFBJ-25000481', '0798-RCFBJ-25000483', '0798-RCFBJ-25000484');
        IMOSAPILOG.SetRange("Invoice List", true);
        IMOSAPILOG.SetFilter("Bank ID", '<>%1', '');
        IF IMOSAPILOG.FindFirst()then begin
            repeat InVTransNo:='';
                EntryDate:='';
                ACtDate:='';
                ExtranalRefID:='';
                PayMode:='WT';
                bankCode:='';
                CurrenyAmount:='';
                BankCharge:=0;
                IMOSAPILOG2.Reset();
                IMOSAPILOG2.SetRange("Table No.", Database::"Vendor Ledger Entry");
                //               IMOSAPILOG2.SetFilter(Status, '<>%1', IMOSAPILOG2.Status::Success);
                IMOSAPILOG2.SetRange("Company Code", CompanyName);
                IMOSAPILOG2.SetRange("Invoice List", true);
                IMOSAPILOG2.SetRange("Primary key 2", IMOSAPILOG."Primary key 2");
                if IMOSAPILOG2.FindSet()then begin
                    RecCustLedEntry.Reset();
                    RecCustLedEntry.SetRange("Document No.", IMOSAPILOG."Primary key 2");
                    RecCustLedEntry.FindFirst();
                    if RecCustLedEntry."Bank Document No." <> '' then IMOSAPILOG."Bank Document No.":=RecCustLedEntry."Bank Document No.";
                    IMOSAPILOG."Payment Amount LCY":=IMOSAPILOG."Payment Amount" / RecCustLedEntry."Original Currency Factor";
                    IMOSAPILOG."Currency Factor":=RecCustLedEntry."Original Currency Factor";
                    VendLEntDocNo:=RecCustLedEntry."Document No.";
                    DecCurrencyAmount:=0;
                    DecCurrencyAmountLCY:=0;
                    BankCharge:=0;
                    //                    VendLEntDocNo := RecCustLedEntry."Document No.";
                    ACtDate:=format(RecCustLedEntry."Document Date", 0, ImOSDatelbl);
                    EntryDate:=format(RecCustLedEntry."Posting Date", 0, ImOSDatelbl);
                    InvoiceData:='<invoiceList>';
                    if IMOSAPILOG."Bank Document No." = '' then ExtranalRefID:=RecCustLedEntry."Document No."
                    else
                        ExtranalRefID:=IMOSAPILOG."Bank Document No.";
                    ExtranalRefID:=RecCustLedEntry."Document No." + IMOSAPILOG."Document No Suffix";
                    memo:=IMOSAPILOG."Bank Document No.";
                    repeat DecCurrencyAmount:=DecCurrencyAmount + (IMOSAPILOG2."Payment Amount") + IMOSAPILOG2."Over Receipt Amount";
                        DecCurrencyAmountLCY:=DecCurrencyAmountLCY + IMOSAPILOG2."Payment Amount LCY";
                        BankCharge:=BankCharge + IMOSAPILOG2."Bank Charge Amount";
                        RecCustLedEntry.Reset();
                        RecCustLedEntry.SetRange("Document No.", IMOSAPILOG2."Primary key 3");
                        RecCustLedEntry.SetFilter("IMOS Transaction No", '<>%1', '');
                        RecCustLedEntry.FindSet();
                        InVTransNo:=RecCustLedEntry."IMOS Transaction No";
                        InvoiceData:=InvoiceData + StrSubstNo(InvoiceListLbl, InVTransNo, format(1 * IMOSAPILOG2."Payment Amount", 0, ImOSDatelbl));
                    until IMOSAPILOG2.Next() = 0;
                    InvoiceData:=InvoiceData + '</invoiceList>';
                end;
                //  DecCurrencyAmount := -1 * DecCurrencyAmount;
                CurrenyAmount:=format(DecCurrencyAmount, 0, ImOSDatelbl);
                DecCurrencyAmountLCY:=DecCurrencyAmount / IMOSAPILOG."Currency Factor";
                CurrenyAmountLCY:=format(DecCurrencyAmountLCY, 0, ImOSDatelbl);
                ExchRate:=format(IMOSAPILOG."Currency Factor", 0, ImOSDatelbl);
                BankCharge_Txt:=format(BankCharge, 0, imosdatelbl);
                bankCode:=IMOSAPILOG."Bank ID";
                if bankCode = '' then begin
                    GLEntry.Reset();
                    GLEntry.SetCurrentKey("Document No.");
                    GLEntry.SetRange("Document No.", IMOSAPILOG."Primary key 2");
                    GLEntry.SetFilter("IMOS Bank ID", '<>%1', '');
                    if GLEntry.FindSet()then // bankCode := IMOSBankMapping."IMOS Bank ID";
                        bankCode:=GLEntry."IMOS Bank ID";
                end;
                InVTransNo:='';
                XMLData:='<simplePayment>' + StrSubstNo(InvoiceExchXML, InVTransNo, EntryDate, ACtDate, ExtranalRefID, PayMode, bankCode, CurrenyAmount, BankCharge_Txt, BankChargeGL, CurrenyAmountLCY, ExchRate, Memo) + InvoiceData + '</simplePayment>';
                GetAPIResponse(IMOSAPILOG, XMLData);
                IMOSAPILOG."XML Data":=XmlData;
                IMOSAPILOG."Sent Date Time":=CurrentDateTime;
                IMOSAPILOG."Bank ID":=bankCode;
                IMOSAPILOG.Modify();
                if IMOSAPILOG.Status = IMOSAPILOG.Status::Success then begin
                    IMOSAPILOG2.Reset();
                    IMOSAPILOG2.SetRange("Table No.", Database::"Vendor Ledger Entry");
                    IMOSAPILOG2.SetFilter(Status, '<>%1', IMOSAPILOG2.Status::Success);
                    IMOSAPILOG2.SetRange("Company Code", CompanyName);
                    IMOSAPILOG2.SetRange("Invoice List", true);
                    IMOSAPILOG2.SetRange("Primary key 2", IMOSAPILOG."Primary key 2");
                    IMOSAPILOG2.SetFilter("Entry No.", '<>%1', IMOSAPILOG."Entry No.");
                    if IMOSAPILOG2.FindSet()then repeat IMOSAPILOG2.Status:=IMOSAPILOG2.Status::Success;
                            IMOSAPILOG2."XML Data":=XmlData;
                            IMOSAPILOG2."Sent Date Time":=CurrentDateTime;
                            IMOSAPILOG2."Bank ID":=bankCode;
                            IMOSAPILOG2.Modify();
                        until IMOSAPILOG2.Next() = 0;
                end;
            until IMOSAPILOG.Next() = 0;
        end;
    END;
    procedure GetAndUpdateAPILOGForIRPaymentList()
    VAR
        IMOSAPILOG: Record "IMOS API Log";
        IMOSAPILOG2: Record "IMOS API Log";
        RecCustLedEntry: record "Cust. Ledger Entry";
        RecCustLedgEntry1: record "Cust. Ledger Entry";
        InvoiceExchXML: Label '<invoiceTransNo>%1</invoiceTransNo><entryDate>%2</entryDate><actDate>%3</actDate><externalRefId>%4</externalRefId><payMode>%5</payMode><bankCode>%6</bankCode><currencyAmount>%7</currencyAmount><bankCharge>%8</bankCharge><bankChargeCode>%9</bankChargeCode><baseCurrencyAmount>%10</baseCurrencyAmount><bankXCRate>%11</bankXCRate><memo>%12</memo>';
        InvoiceListLbl: Label '<invoice><invoiceTransNo>%1</invoiceTransNo><currencyAmount>%2</currencyAmount></invoice>';
        XMLData: Text[2048];
        CurrDate: Date;
        VendLEntDocNo: Code[20];
        InVTransNo: Text[50];
        EntryDate: text;
        ACtDate: text;
        ExtranalRefID: Text;
        PayMode: Text;
        bankCode: Text;
        CurrenyAmount: text;
        IMOSBankMapping: record "IMOS Bank Mapping";
        GLEntry: record "G/L Entry";
        BankCharge: Decimal;
        BankCharge_Txt: Text;
        BankChargeGL: Code[20];
        InvoiceData: Text;
        DecCurrencyAmount: Decimal;
        CurrenyAmountLCY: Text;
        DecCurrencyAmountLCY: Decimal;
        ExchRate: Text;
        DecInvoiceAmount: Decimal;
        Memo: Text;
    begin
        IMOSSetup.get;
        BankChargeGL:=IMOSSetup."Bank Charge GL Code";
        IMOSAPILOG.reset;
        IMOSAPILOG.SetRange("Table No.", Database::"Cust. Ledger Entry");
        IMOSAPILOG.SetFilter(Status, '<>%1', IMOSAPILOG.Status::Success);
        IMOSAPILOG.SetRange("Company Code", CompanyName);
        //IMOSAPILOG.Setfilter("Primary key 2", '=%1|%2', '0799-RCFBJ-25000621', '0799-RCFBJ-25000590');
        IMOSAPILOG.SetRange("Invoice List", true);
        IMOSAPILOG.SetFilter("Bank ID", '<>%1', '');
        IF IMOSAPILOG.FindFirst()then begin
            repeat InVTransNo:='';
                EntryDate:='';
                ACtDate:='';
                ExtranalRefID:='';
                PayMode:='WT';
                bankCode:='';
                CurrenyAmount:='';
                BankCharge:=0;
                IMOSAPILOG2.Reset();
                IMOSAPILOG2.SetRange("Table No.", Database::"Cust. Ledger Entry");
                //               IMOSAPILOG2.SetFilter(Status, '<>%1', IMOSAPILOG2.Status::Success);
                IMOSAPILOG2.SetRange("Company Code", CompanyName);
                IMOSAPILOG2.SetRange("Invoice List", true);
                IMOSAPILOG2.SetRange("Primary key 2", IMOSAPILOG."Primary key 2");
                if IMOSAPILOG2.FindSet()then begin
                    RecCustLedEntry.Reset();
                    RecCustLedEntry.SetRange("Document No.", IMOSAPILOG."Primary key 2");
                    RecCustLedEntry.FindFirst();
                    BankCharge:=0;
                    DecCurrencyAmount:=0;
                    DecCurrencyAmountLCY:=0;
                    VendLEntDocNo:=RecCustLedEntry."Document No.";
                    ACtDate:=format(RecCustLedEntry."Document Date", 0, ImOSDatelbl);
                    EntryDate:=format(RecCustLedEntry."Posting Date", 0, ImOSDatelbl);
                    InvoiceData:='<invoiceList>';
                    if IMOSAPILOG."Bank Document No." = '' then ExtranalRefID:=RecCustLedEntry."Document No."
                    else
                        ExtranalRefID:=IMOSAPILOG."Bank Document No.";
                    ExtranalRefID:=RecCustLedEntry."Document No." + IMOSAPILOG."Document No Suffix";
                    memo:=IMOSAPILOG."Bank Document No.";
                    repeat DecCurrencyAmount:=DecCurrencyAmount + (IMOSAPILOG2."Payment Amount") + IMOSAPILOG2."Over Receipt Amount";
                        DecInvoiceAmount:=IMOSAPILOG2."Payment Amount" + IMOSAPILOG2."Over Receipt Amount";
                        DecInvoiceAmount:=-1 * DecInvoiceAmount;
                        BankCharge:=BankCharge + IMOSAPILOG2."Bank Charge Amount";
                        RecCustLedEntry.Reset();
                        RecCustLedEntry.SetRange("Document No.", IMOSAPILOG2."Primary key 3");
                        RecCustLedEntry.SetFilter("IMOS Transaction No", '<>%1', '');
                        RecCustLedEntry.FindSet();
                        InVTransNo:=RecCustLedEntry."IMOS Transaction No";
                        InvoiceData:=InvoiceData + StrSubstNo(InvoiceListLbl, InVTransNo, format(DecInvoiceAmount, 0, ImOSDatelbl));
                    until IMOSAPILOG2.Next() = 0;
                    InvoiceData:=InvoiceData + '</invoiceList>';
                end;
                DecCurrencyAmount:=-1 * DecCurrencyAmount;
                CurrenyAmount:=format(DecCurrencyAmount, 0, ImOSDatelbl);
                DecCurrencyAmountLCY:=DecCurrencyAmount / IMOSAPILOG."Currency Factor";
                CurrenyAmountLCY:=format(DecCurrencyAmountLCY, 0, ImOSDatelbl);
                ExchRate:=format(IMOSAPILOG."Currency Factor", 0, ImOSDatelbl);
                BankCharge_Txt:=format(BankCharge, 0, imosdatelbl);
                bankCode:=IMOSAPILOG."Bank ID";
                if bankCode = '' then begin
                    GLEntry.Reset();
                    GLEntry.SetCurrentKey("Document No.");
                    GLEntry.SetRange("Document No.", IMOSAPILOG."Primary key 2");
                    GLEntry.SetFilter("IMOS Bank ID", '<>%1', '');
                    if GLEntry.FindSet()then // bankCode := IMOSBankMapping."IMOS Bank ID";
                        bankCode:=GLEntry."IMOS Bank ID";
                end;
                InVTransNo:='';
                XMLData:='<simplePayment>' + StrSubstNo(InvoiceExchXML, InVTransNo, EntryDate, ACtDate, ExtranalRefID, PayMode, bankCode, CurrenyAmount, BankCharge_Txt, BankChargeGL, CurrenyAmountLCY, ExchRate, Memo) + InvoiceData + '</simplePayment>';
                GetAPIResponse(IMOSAPILOG, XMLData);
                IMOSAPILOG."XML Data":=XmlData;
                IMOSAPILOG."Sent Date Time":=CurrentDateTime;
                IMOSAPILOG."Bank ID":=bankCode;
                IMOSAPILOG.Modify();
                if IMOSAPILOG.Status = IMOSAPILOG.Status::Success then begin
                    IMOSAPILOG2.Reset();
                    IMOSAPILOG2.SetRange("Table No.", Database::"Cust. Ledger Entry");
                    IMOSAPILOG2.SetFilter(Status, '<>%1', IMOSAPILOG2.Status::Success);
                    IMOSAPILOG2.SetRange("Company Code", CompanyName);
                    IMOSAPILOG2.SetRange("Invoice List", true);
                    IMOSAPILOG2.SetRange("Primary key 2", IMOSAPILOG."Primary key 2");
                    IMOSAPILOG2.SetFilter("Entry No.", '<>%1', IMOSAPILOG."Entry No.");
                    if IMOSAPILOG2.FindSet()then repeat IMOSAPILOG2.Status:=IMOSAPILOG2.Status::Success;
                            IMOSAPILOG2."XML Data":=XmlData;
                            IMOSAPILOG2."Sent Date Time":=CurrentDateTime;
                            IMOSAPILOG2."Bank ID":=bankCode;
                            IMOSAPILOG2.Modify();
                        until IMOSAPILOG2.Next() = 0;
                end;
            until IMOSAPILOG.Next() = 0;
        end;
    END;
    procedure UpdateInvList(mtableNo: Integer)
    var
        IMOSAPILOG: Record "IMOS API Log";
        IMOSAPILOG2: Record "IMOS API Log";
    begin
        IMOSAPILOG.Reset();
        IMOSAPILOG.SetRange("Company Code", CompanyName);
        IMOSAPILOG.SetRange("Table No.", mtableNo);
        IMOSAPILOG.SetFilter(Status, '=%1|%2', IMOSAPILOG.Status::Error, IMOSAPILOG.Status::Pending);
        if IMOSAPILOG.FindSet()then repeat IMOSAPILOG2.Reset();
                IMOSAPILOG2.SetRange("Company Code", IMOSAPILOG."Company Code");
                IMOSAPILOG2.SetRange("Table No.", IMOSAPILOG."Table No.");
                IMOSAPILOG2.SetFilter("Entry No.", '<>%1', IMOSAPILOG."Entry No.");
                IMOSAPILOG2.SetFilter("Primary key 2", IMOSAPILOG."Primary key 2");
                IMOSAPILOG2.SetFilter(Status, '=%1|%2', IMOSAPILOG2.Status::Error, IMOSAPILOG2.Status::Pending);
                if IMOSAPILOG2.FindSet()then begin
                    repeat IMOSAPILOG2."Invoice List":=true;
                        IMOSAPILOG2.Modify();
                    until IMOSAPILOG2.Next() = 0;
                    IMOSAPILOG."Invoice List":=true;
                    IMOSAPILOG.Modify();
                end;
            until IMOSAPILOG.Next() = 0;
        Commit();
    end;
    procedure GetAndUpdateAPILOGForIRPayment()
    VAR
        IMOSAPILOG: Record "IMOS API Log";
        RecCustLedEntry: record "Cust. Ledger Entry";
        RecCustLedgEntry1: record "Cust. Ledger Entry";
        InvoiceExchXML: Label '<simplePayment><invoiceTransNo>%1</invoiceTransNo><entryDate>%2</entryDate><actDate>%3</actDate><externalRefId>%4</externalRefId><payMode>%5</payMode><bankCode>%6</bankCode><currencyAmount>%7</currencyAmount><bankCharge>%8</bankCharge><bankChargeCode>%9</bankChargeCode><baseCurrencyAmount>%10</baseCurrencyAmount><bankXCRate>%11</bankXCRate><memo>%12</memo></simplePayment>';
        XMLData: Text[2048];
        CurrDate: Date;
        VendLEntDocNo: Code[20];
        InVTransNo: Text[50];
        EntryDate: text;
        ACtDate: text;
        ExtranalRefID: Text;
        PayMode: Text;
        bankCode: Text;
        CurrenyAmount: text;
        IMOSBankMapping: record "IMOS Bank Mapping";
        GLEntry: record "G/L Entry";
        BankCharge: text;
        BankChargeGL: Code[20];
        DecCurrencyAmount: Decimal;
        DecCurrencyAmountLCY: Decimal;
        CurrenyAmountLCY: Text;
        ExchRate: Text;
        memo: Text;
    begin
        IMOSSetup.get;
        BankChargeGL:=IMOSSetup."Bank Charge GL Code";
        IMOSAPILOG.reset;
        IMOSAPILOG.SetRange("Table No.", Database::"Cust. Ledger Entry");
        IMOSAPILOG.SetFilter(Status, '<>%1', IMOSAPILOG.Status::Success);
        IMOSAPILOG.SetRange("Company Code", CompanyName);
        IMOSAPILOG.SetRange("Invoice List", false);
        IMOSAPILOG.SetFilter("Bank ID", '<>%1', '');
        IF IMOSAPILOG.FindFirst()then begin
            repeat InVTransNo:='';
                EntryDate:='';
                ACtDate:='';
                ExtranalRefID:='';
                PayMode:='WT';
                //bankCode := '20020806';
                CurrenyAmount:='';
                BankCharge:='';
                RecCustLedEntry.Reset();
                //RecVendLedEntry.SetRange("Document Type", RecVendLedEntry."Document Type"::Payment);
                RecCustLedEntry.SetRange("Document No.", IMOSAPILOG."Primary key 2");
                RecCustLedEntry.FindFirst();
                VendLEntDocNo:=RecCustLedEntry."Document No.";
                ACtDate:=format(RecCustLedEntry."Document Date", 0, ImOSDatelbl);
                EntryDate:=format(RecCustLedEntry."Posting Date", 0, ImOSDatelbl);
                if IMOSAPILOG."Bank Document No." = '' then ExtranalRefID:=RecCustLedEntry."Document No."
                else
                    ExtranalRefID:=IMOSAPILOG."Bank Document No.";
                ExtranalRefID:=RecCustLedEntry."Document No." + IMOSAPILOG."Document No Suffix";
                memo:=IMOSAPILOG."Bank Document No.";
                //CurrenyAmount := format(IMOSAPILOG."Payment Amount" + IMOSAPILOG."Over Receipt Amount", 0, ImOSDatelbl);
                //                if IMOSAPILOG."Payment Amount" < 0 then IMOSAPILOG."Over Receipt Amount" := IMOSAPILOG."Over Receipt Amount" * -1;
                DecCurrencyAmount:=IMOSAPILOG."Payment Amount" + IMOSAPILOG."Over Receipt Amount";
                DecCurrencyAmount:=-1 * DecCurrencyAmount;
                DecCurrencyAmountLCY:=DecCurrencyAmount / IMOSAPILOG."Currency Factor";
                CurrenyAmountLCY:=format(DecCurrencyAmountLCY, 0, ImOSDatelbl);
                ExchRate:=format(IMOSAPILOG."Currency Factor", 0, ImOSDatelbl);
                CurrenyAmount:=format(DecCurrencyAmount, 0, ImOSDatelbl);
                RecCustLedEntry.Reset();
                RecCustLedEntry.SetRange("Document No.", IMOSAPILOG."Primary key 3");
                RecCustLedEntry.FindSet();
                InVTransNo:=RecCustLedEntry."IMOS Transaction No";
                BankCharge:=format(IMOSAPILOG."Bank Charge Amount", 0, imosdatelbl);
                bankCode:=IMOSAPILOG."Bank ID";
                if bankCode = '' then begin
                    GLEntry.Reset();
                    GLEntry.SetCurrentKey("Document No.");
                    GLEntry.SetRange("Document No.", IMOSAPILOG."Primary key 2");
                    GLEntry.SetFilter("IMOS Bank ID", '<>%1', '');
                    if GLEntry.FindSet()then // bankCode := IMOSBankMapping."IMOS Bank ID";
                        bankCode:=GLEntry."IMOS Bank ID";
                end;
                XMLData:=StrSubstNo(InvoiceExchXML, InVTransNo, EntryDate, ACtDate, ExtranalRefID, PayMode, bankCode, CurrenyAmount, BankCharge, BankChargeGL, CurrenyAmountLCY, ExchRate, memo);
                GetAPIResponse(IMOSAPILOG, XMLData);
                IMOSAPILOG."XML Data":=XmlData;
                IMOSAPILOG."Sent Date Time":=CurrentDateTime;
                IMOSAPILOG."Bank ID":=bankCode;
                IMOSAPILOG.Modify();
            until IMOSAPILOG.Next() = 0;
        end;
    END;
    procedure GetAndUpdateAPILOGForIRPayment_Vendor()
    VAR
        IMOSAPILOG: Record "IMOS API Log";
        RecCustLedEntry: record "Vendor Ledger Entry";
        RecCustLedgEntry1: record "Vendor Ledger Entry";
        InvoiceExchXML: Label '<simplePayment><invoiceTransNo>%1</invoiceTransNo><entryDate>%2</entryDate><actDate>%3</actDate><externalRefId>%4</externalRefId><payMode>%5</payMode><bankCode>%6</bankCode><currencyAmount>%7</currencyAmount><bankCharge>%8</bankCharge><bankChargeCode>%9</bankChargeCode><baseCurrencyAmount>%10</baseCurrencyAmount><bankXCRate>%11</bankXCRate><memo>%12</memo></simplePayment>';
        XMLData: Text[2048];
        CurrDate: Date;
        VendLEntDocNo: Code[20];
        InVTransNo: Text[50];
        EntryDate: text;
        ACtDate: text;
        ExtranalRefID: Text;
        PayMode: Text;
        bankCode: Text;
        CurrenyAmount: text;
        CurrenyAmountLCY: text;
        ExchRate: text;
        IMOSBankMapping: record "IMOS Bank Mapping";
        GLEntry: record "G/L Entry";
        BankCharge: text;
        BankChargeGL: Code[20];
        DecCurrencyAmount: Decimal;
        Memo: Text;
    begin
        IMOSSetup.get;
        BankChargeGL:=IMOSSetup."Bank Charge GL Code";
        IMOSAPILOG.reset;
        IMOSAPILOG.SetRange("Table No.", Database::"Vendor Ledger Entry");
        IMOSAPILOG.SetFilter(Status, '<>%1', IMOSAPILOG.Status::Success);
        IMOSAPILOG.SetRange("Company Code", CompanyName);
        IMOSAPILOG.SetRange("Invoice List", false);
        IMOSAPILOG.SetFilter("Bank ID", '<>%1', '');
        //IMOSAPILOG.SetRange("Entry No.", 824898, 824907);
        IF IMOSAPILOG.FindFirst()then begin
            repeat InVTransNo:='';
                EntryDate:='';
                ACtDate:='';
                ExtranalRefID:='';
                PayMode:='WT';
                //bankCode := '20020806';
                CurrenyAmount:='';
                BankCharge:='';
                RecCustLedEntry.Reset();
                //RecVendLedEntry.SetRange("Document Type", RecVendLedEntry."Document Type"::Payment);
                RecCustLedEntry.SetRange("Document No.", IMOSAPILOG."Primary key 2");
                RecCustLedEntry.FindFirst();
                if RecCustLedEntry."Bank Document No." <> '' then IMOSAPILOG."Bank Document No.":=RecCustLedEntry."Bank Document No.";
                IMOSAPILOG."Payment Amount LCY":=IMOSAPILOG."Payment Amount" / RecCustLedEntry."Original Currency Factor";
                IMOSAPILOG."Currency Factor":=RecCustLedEntry."Original Currency Factor";
                VendLEntDocNo:=RecCustLedEntry."Document No.";
                ACtDate:=format(RecCustLedEntry."Document Date", 0, ImOSDatelbl);
                EntryDate:=format(RecCustLedEntry."Posting Date", 0, ImOSDatelbl);
                if IMOSAPILOG."Bank Document No." = '' then ExtranalRefID:=RecCustLedEntry."Document No."
                else
                    ExtranalRefID:=IMOSAPILOG."Bank Document No.";
                ExtranalRefID:=RecCustLedEntry."Document No." + IMOSAPILOG."Document No Suffix";
                memo:=IMOSAPILOG."Bank Document No.";
                //CurrenyAmount := format(IMOSAPILOG."Payment Amount" + IMOSAPILOG."Over Receipt Amount", 0, ImOSDatelbl);
                DecCurrencyAmount:=IMOSAPILOG."Payment Amount";
                //  DecCurrencyAmount := -1 * DecCurrencyAmount;
                CurrenyAmount:=format(DecCurrencyAmount, 0, ImOSDatelbl);
                CurrenyAmountLCY:=format(IMOSAPILOG."Payment Amount LCY", 0, ImOSDatelbl);
                ExchRate:=format(IMOSAPILOG."Currency Factor", 0, ImOSDatelbl);
                RecCustLedEntry.Reset();
                RecCustLedEntry.SetRange("Document No.", IMOSAPILOG."Primary key 3");
                RecCustLedEntry.FindSet();
                InVTransNo:=RecCustLedEntry."IMOS Transaction No";
                //BankCharge := IMOSAPILOG."Bank Charge Amount";
                BankCharge:=format(IMOSAPILOG."Bank Charge Amount", 0, imosdatelbl);
                if IMOSAPILOG."Bank ID" = '' then begin
                    GLEntry.Reset();
                    GLEntry.SetCurrentKey("Document No.");
                    GLEntry.SetRange("Document No.", IMOSAPILOG."Primary key 2");
                    GLEntry.SetFilter("IMOS Bank ID", '<>%1', '');
                    if GLEntry.FindSet()then bankCode:=GLEntry."IMOS Bank ID";
                end
                else
                    bankCode:=IMOSAPILOG."Bank ID";
                XMLData:=StrSubstNo(InvoiceExchXML, InVTransNo, EntryDate, ACtDate, ExtranalRefID, PayMode, bankCode, CurrenyAmount, BankCharge, BankChargeGL, CurrenyAmountLCY, ExchRate, Memo);
                GetAPIResponse(IMOSAPILOG, XMLData);
                IMOSAPILOG."XML Data":=XmlData;
                IMOSAPILOG."Sent Date Time":=CurrentDateTime;
                IMOSAPILOG."Bank ID":=bankCode;
                IMOSAPILOG.Modify();
            until IMOSAPILOG.Next() = 0;
        end;
    END;
    procedure GetAndUpdateAPILOGForCustLedger(P_Type: Option Insert, Update)
    VAR
        IMOSAPILOG: Record "IMOS API Log";
        XMLData: Text;
        RecCustLedEntry: Record "Cust. Ledger Entry";
        XMLPayment: Label '<simplePayment><invoiceTransNo>%1</invoiceTransNo><entryDate>%2</entryDate><actDate>%3</actDate><externalRefId>%4</externalRefId><bankCode>%5</bankCode><currencyAmount>%6</currencyAmount><currency>%7</currency><baseCurrencyAmount>%7</baseCurrencyAmount><batchId>%8</batchId><bankXCRate>%9</bankXCRate><isAdvance>%10</isAdvance><xcRate>%11</xcRate><companyCode>%12</companyCode><transType><%13</transType><customerNo>%14</customerNo><customerName>%15</customerName><customerType>%16</customerType><customerCrossRef>%17</customerCrossRef><invoiceList><invoice><invoiceTransNo>%18</invoiceTransNo><currencyAmount>%19</currencyAmount></invoice></invoiceList></simplePayment>';
    begin
        IMOSAPILOG.reset;
        IMOSAPILOG.SetRange("Table No.", Database::"Cust. Ledger Entry");
        IMOSAPILOG.SetRange("Entry Type", P_Type);
        IMOSAPILOG.SetFilter(Status, '<>%1', IMOSAPILOG.Status::Success);
        IF IMOSAPILOG.FindFirst()then begin
            repeat RecCustLedEntry.Reset();
                RecCustLedEntry.SetRange("Document Type", RecCustLedEntry."Document Type"::Payment);
                RecCustLedEntry.SetRange("Document No.", IMOSAPILOG."Primary key 2");
                if RecCustLedEntry.FindFirst()then XMLData:=StrSubstNo(XMLPayment);
                GetAPIResponse(IMOSAPILOG, XMLData);
                IMOSAPILOG."XML Data":=XMLData;
                IMOSAPILOG."Sent Date Time":=CurrentDateTime;
                IMOSAPILOG.Modify();
            until IMOSAPILOG.Next() = 0;
        end;
    END;
    procedure GetAndUpdateAPILOGForVendorBankAcc(P_Type: Option Insert, Update)
    VAR
        IMOSAPILOG: Record "IMOS API Log";
        XMLData: Text;
        VendBankAcc: Record "Vendor Bank Account";
        ComDimMapp: Record "Vendor Type Mapping";
        XMLPayment: Label '<simplePayment><invoiceTransNo>%1</invoiceTransNo><entryDate>%2</entryDate><actDate>%3</actDate><externalRefId>%4</externalRefId><bankCode>%5</bankCode><currencyAmount>%6</currencyAmount><currency>%7</currency><baseCurrencyAmount>%7</baseCurrencyAmount><batchId>%8</batchId><bankXCRate>%9</bankXCRate><isAdvance>%10</isAdvance><xcRate>%11</xcRate><companyCode>%12</companyCode><transType><%13</transType><customerNo>%14</customerNo><customerName>%15</customerName><customerType>%16</customerType><customerCrossRef>%17</customerCrossRef><invoiceList><invoice><invoiceTransNo>%18</invoiceTransNo><currencyAmount>%19</currencyAmount></invoice></invoiceList></simplePayment>';
    begin
        IMOSAPILOG.reset;
        IMOSAPILOG.SetRange("Table No.", Database::"Cust. Ledger Entry");
        IMOSAPILOG.SetRange("Entry Type", P_Type);
        IMOSAPILOG.SetFilter(Status, '<>%1', IMOSAPILOG.Status::Success);
        IF IMOSAPILOG.FindFirst()then begin
            repeat VendBankAcc.Reset();
                VendBankAcc.SetRange("Vendor No.", IMOSAPILOG."Primary key 2");
                VendBankAcc.SetRange("Code", IMOSAPILOG."Primary key 3");
                if VendBankAcc.FindFirst()then XMLData:=StrSubstNo(XMLPayment);
                GetAPIResponse(IMOSAPILOG, XMLData);
                IMOSAPILOG."Sent Date Time":=CurrentDateTime;
                IMOSAPILOG.Modify();
            until IMOSAPILOG.Next() = 0;
        end;
    END;
    procedure GetAndUpdateAPILOGForInvoice()
    VAR
        IMOSAPILOG: Record "IMOS API Log";
        IMOSInvoiceInbound: record "IMOS API Inbound";
        InvoiceExchXML: Label '<invoiceStatus><transNo>%1</transNo><externalRefId>%2</externalRefId><interfaceStatus>%3</interfaceStatus><interfaceErrorCode>%4</interfaceErrorCode><interfaceErrorDesc>%5</interfaceErrorDesc></invoiceStatus>';
        XMLData: Text[2048];
        CurrDate: Date;
    begin
        IMOSAPILOG.reset;
        IMOSAPILOG.SetRange("Table No.", Database::"IMOS API Inbound");
        IMOSAPILOG.SetFilter(Status, '<>%1', IMOSAPILOG.Status::Success);
        IF IMOSAPILOG.FindFirst()then begin
            repeat IMOSInvoiceInbound.get(IMOSAPILOG."Primary key 2");
                if IMOSInvoiceInbound.Status = IMOSInvoiceInbound.Status::Processed then begin
                    XMLData:=StrSubstNo(InvoiceExchXML, IMOSInvoiceInbound."Transaction No", 'Received in BC', 'S', '', '');
                end
                else
                begin
                    XMLData:=StrSubstNo(InvoiceExchXML, IMOSInvoiceInbound."Transaction No", 'ERROR', 'B', IMOSInvoiceInbound."Error Description", IMOSInvoiceInbound."Error Description");
                end;
                GetAPIResponse(IMOSAPILOG, XMLData);
                IMOSAPILOG."XML Data":=XmlData;
                IMOSAPILOG."Sent Date Time":=CurrentDateTime;
                IMOSAPILOG.Modify();
            until IMOSAPILOG.Next() = 0;
        end;
    END;
    procedure GetAndUpdateAPILOGForInvoicefromStaging()
    VAR
        IMOSAPILOG: Record "IMOS API Log";
        IMOSInvoiceInbound: record "Imos invoice Staging Table";
        InvoiceExchXML: Label '<invoiceStatus><transNo>%1</transNo><externalRefId>%2</externalRefId><interfaceStatus>%3</interfaceStatus><interfaceErrorCode>%4</interfaceErrorCode><interfaceErrorDesc>%5</interfaceErrorDesc></invoiceStatus>';
        XMLData: Text[2048];
        CurrDate: Date;
    begin
        IMOSAPILOG.reset;
        IMOSAPILOG.SetRange("Table No.", Database::"Imos invoice Staging Table");
        IMOSAPILOG.SetFilter(Status, '<>%1', IMOSAPILOG.Status::Success);
        IF IMOSAPILOG.FindFirst()then begin
            repeat IMOSInvoiceInbound.get(IMOSAPILOG."Primary key 2");
                if IMOSInvoiceInbound."BC Status" = IMOSInvoiceInbound."BC Status"::Processed then begin
                    XMLData:=StrSubstNo(InvoiceExchXML, IMOSInvoiceInbound.transNo, IMOSInvoiceInbound."Posted Document No", 'S', '', '');
                end
                else
                begin
                    XMLData:=StrSubstNo(InvoiceExchXML, IMOSInvoiceInbound.transNo, 'ERROR', 'B', IMOSInvoiceInbound."Error Description", IMOSInvoiceInbound."Error Description");
                end;
                GetAPIResponse(IMOSAPILOG, XMLData);
                IMOSAPILOG."XML Data":=XmlData;
                IMOSAPILOG."Sent Date Time":=CurrentDateTime;
                IMOSAPILOG.Modify();
            until IMOSAPILOG.Next() = 0;
        end;
    END;
    procedure GetAPIResponse(VAR IMOSAPILOG: Record "IMOS API Log"; XMLData: Text): Text var
        TokenUrl: Text[1024];
        ClientId: Text[1024];
        ClientSecret: Text[1024];
        Resource: Text[1024];
        HttpClient: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestHeader: HttpHeaders;
        Content: HttpContent;
        TempBlob: Codeunit "Temp Blob";
        Outstr: OutStream;
        Instr: InStream;
        APIResult: Text;
        ResponseJsonObject: JsonObject;
        ResponseJsonToken: JsonToken;
        AccessTokenErr: Text;
        AccessToken: Text;
        NewAccessToken: Text;
        JsonResponseTxt: Text;
        ErrorText: text;
        CompanydimMap: Record "Vendor Type Mapping";
    begin
        IMOSSetup.GET;
        IMOSSetup.TestField("Is Enable", true);
        AccessToken:=IMOSSetup."API Token";
        IF AccessToken = '' then Error('No Access Token generated');
        TempIMOSLOG.DeleteAll();
        Clear(TempBlob);
        RequestHeader:=HttpClient.DefaultRequestHeaders;
        RequestHeader.Add('User-Agent', 'Dynamics 365');
        HttpClient.DefaultRequestHeaders().Add('Authorization', AccessToken);
        Content.GetHeaders(RequestHeader);
        RequestHeader.Clear();
        TokenURL:=IMOSSetup."Token URL";
        HttpClient.SetBaseAddress(TokenURL);
        RequestMessage.Method('POST');
        RequestHeader.Remove('Content-Type');
        RequestHeader.Add('Content-Type', 'application/Json');
        ErrorText:='';
        TempBlob.CreateOutStream(Outstr);
        Outstr.WriteText(XMLData);
        TempBlob.CreateInStream(Instr);
        Content.WriteFrom(Instr);
        RequestMessage.Content(Content);
        HttpClient.Send(RequestMessage, ResponseMessage);
        IF ResponseMessage.IsSuccessStatusCode()THEN BEGIN
            //Message('Success');
            ResponseMessage.Content().ReadAs(JsonResponseTxt);
        //ProcessJasonresponse(JsonResponseTxt);
        //Message('%1', JsonResponseTxt);
        end
        else
        begin
            ResponseMessage.Content().ReadAs(JsonResponseTxt);
            // Message('JsonResponse Text%1', JsonResponseTxt);
            // message('Error %1', CopyStr(GetLastErrorText(), 1, 100));
            ErrorText:=JsonResponseTxt;
        end;
        IF ErrorText <> '' then begin
            IMOSAPILOG.Status:=IMOSAPILOG.Status::Error;
            IMOSAPILOG.Response:=ErrorText;
        end
        else
        begin
            IMOSAPILOG.Status:=IMOSAPILOG.Status::Success;
            IMOSAPILOG."Response":=JsonResponseTxt;
            if CompanydimMap.Get(IMOSAPILOG."Primary key", IMOSAPILOG."Primary key 2", IMOSAPILOG."Primary key 3", IMOSAPILOG."Primary key 4")then CompanydimMap.ModifyAll(Sync, true, false);
        end;
    end;
    // procedure ProcessJasonresponse(P_Jason: Text)
    // var
    //     Jmgt: Codeunit "JSON Management";
    //     JsonBuffer: Record "JSON Buffer";
    //     JsonBuffer2: Record "JSON Buffer" temporary;
    //     PartNo: Text;
    //     DocNo: Text;
    //     JPage: Page "JSon Buffer List";
    //     i: Integer;
    //     TotalObjectNo: Integer;
    //     VendNo: code[20];
    //     ErrorText: Text[1000];
    //     PKEntryNo: Integer;
    // begin
    //     //Message('Temp Count %1', TempIMOSLOG.Count);
    //     JsonBuffer.DeleteAll();
    //     //Message('response...%1', P_Jason);
    //     JsonBuffer2.ReadFromText(P_Jason);
    //     Page.Run(Page::"JSon Buffer List", JsonBuffer2);
    //     //Message('%1..Json Count', JsonBuffer2.Count);
    //     JsonBuffer2.reset;
    //     JsonBuffer2.SetRange(Depth, 3);
    //     JsonBuffer2.SetRange("Token type", JsonBuffer2."Token type"::String);
    //     IF JsonBuffer2.FindLast() then
    //         TotalObjectNo := JsonBuffer2."Object Number";
    //     // Message('%1..ObjectNumber', TotalObjectNo);
    //     for i := 1 To TotalObjectNo Do begin
    //         VendNo := '';
    //         ErrorText := '';
    //         JsonBuffer2.SetRange("Object Number");
    //         JsonBuffer2.SetRange(Error);
    //         IF JsonBuffer2.findset then
    //             JsonBuffer2.SetRange("Object Number", i);
    //         JsonBuffer2.SetRange("Token type");
    //         JsonBuffer2.SetRange("Token type", JsonBuffer2."Token type"::"Property Name");
    //         JsonBuffer2.SetRange(Value, 'ExternalId');//DNV Integration
    //         IF JsonBuffer2.FindFirst() then
    //             PKEntryNo := JsonBuffer2."Entry No.";
    //         JsonBuffer2.SetRange(Value);
    //         JsonBuffer2.SetRange("Token type");
    //         JsonBuffer2.SetRange("Token type", JsonBuffer2."Token type"::String);//DNV Integration
    //         JsonBuffer2.SetRange("Entry No.", PKEntryNo + 1);
    //         if JsonBuffer2.FindFirst() then
    //             VendNo := JsonBuffer2.Value;
    //         JsonBuffer2.SetRange("Entry No.");
    //         IF JsonBuffer2.findset then
    //             JsonBuffer2.SetRange(JsonBuffer2.Error, true);
    //         IF JsonBuffer2.FindFirst() then
    //             ErrorText := CopyStr(JsonBuffer2.Value, 1, 999);
    //         TempIMOSLOG.reset;
    //         TempIMOSLOG.SetRange("Primary key", VendNo);
    //         IF TempIMOSLOG.FindFirst() then begin
    //             IF ErrorText <> '' then begin
    //                 TempIMOSLOG.Status := TempIMOSLOG.Status::Error;
    //                 TempIMOSLOG."Error Reason" := ErrorText;
    //             end
    //             else begin
    //                 TempIMOSLOG.Status := TempIMOSLOG.Status::Success;
    //                 TempIMOSLOG."Error Reason" := '';//DNV Integration
    //             end;
    //             TempIMOSLOG."Sent Date Time" := CurrentDateTime;
    //             TempIMOSLOG.Modify();
    //         end;
    //     end;
    // TempIMOSLOG.reset;
    // IF TempIMOSLOG.FindFirst() then
    //     repeat
    //         IF DNVOutboundLog.GET(TempIMOSLOG."Entry No.") then begin
    //             DNVOutboundLog.TransferFields(TempIMOSLOG);
    //             DNVOutboundLog.Modify();
    //         end;
    //     until TempIMOSLOG.Next() = 0;
    //IF JsonBuffer2.FindFirst() then
    //    repeat
    //        JsonBuffer.Init();
    //        JsonBuffer.TransferFields(JsonBuffer2);
    //        JsonBuffer.insert;
    //    until JsonBuffer2.Next() = 0;
    //clear(JPage);
    //JPage.SetTableView(JsonBuffer);
    //JPage.Run();
    // end;
    var Client: HttpClient;
    Request: HttpRequestMessage;
    Response: HttpResponseMessage;
    ContentHeaders: HttpHeaders;
    Content: HttpContent;
    Result: text;
    ActionResponse: Text;
    JLinesToken: JsonToken;
    Custom_JsonObject: JsonObject;
    JsonBuffer: Record "JSON Buffer" temporary;
    JsonBufferValue: Text;
    ArrayResult: Decimal;
    JsonManag: codeunit "JSON Management";
    IMOSSetup: Record "IMOS Setup";
    ShowMess: Boolean;
    CU_TokenRequest: Codeunit "API Token Request";
    BodyReq: Label '<company><companyType>%1</companyType><externalRef>%2</externalRef><shortName>%3</shortName><fullName>%4</fullName><currency>%5</currency><address1>%6</address1><address2>%7</address2><address3>%8</address3><countryCode>%9</countryCode><phone>%10</phone><fax>%11</fax><email>%12</email><web>%13</web><referenceCode>%14</referenceCode><parentCompanyShortName>%15</parentCompanyShortName><parentCompanyType>%16</parentCompanyType>        <isInactive>%17</isInactive></company>';
    TempIMOSLOG: Record "IMOS API Log" temporary;
    ImOSDatelbl: label '<Standard Format, 9 >';
}
