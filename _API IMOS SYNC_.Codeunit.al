codeunit 50155 "API IMOS SYNC"
{
    trigger OnRun()
    begin
        //        UpdateInvList(21);
        //      UpdateInvList(25);
        GetAndUpdateAPILOGForComDimMapping(0);
        Sleep(100);
        GetAndUpdateAPILOGForComDimMapping(1);
        sleep(100);
        GetAndUpdateAPILOGForCurrExchRate(0);
        Sleep(100);
        GetAndUpdateAPILOGForCurrExchRate(1);
        GetAndUpdateAPILOGForVendorBankAccounts(0);
        GetAndUpdateAPILOGForCustomerBankAccounts(0);
        GetAndUpdateAPILOGForInvoice;
        GetAndUpdateAPILOGForInvoicePayment;
        //GetAndUpdateAPILOGForIRPayment;
        GetAndUpdateAPILOGForInvoicefromStaging;
    //GetAndUpdateAPILOGForIRPaymentList;
    end;
    procedure GetAndUpdateAPILOGForIRPaymentList()
    VAR
        IMOSAPILOG: Record "IMOS API Log";
        IMOSAPILOG2: Record "IMOS API Log";
        RecCustLedEntry: record "Cust. Ledger Entry";
        RecCustLedgEntry1: record "Cust. Ledger Entry";
        InvoiceExchXML: Label '<invoiceTransNo>%1</invoiceTransNo><entryDate>%2</entryDate><actDate>%3</actDate><externalRefId>%4</externalRefId><payMode>%5</payMode><bankCode>%6</bankCode><currencyAmount>%7</currencyAmount><bankCharge>%8</bankCharge><bankChargeCode>%9</bankChargeCode>';
        InvoiceListLbl: Label '<invoice><invoicetransno>%1</invoicetransno><currencyAmount>%2</currencyAmount></invoice>';
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
        BankChargeGL: Code[20];
        InvoiceData: Text;
        DecCurrencyAmount: Decimal;
    begin
        IMOSSetup.get;
        BankChargeGL:=IMOSSetup."Bank Charge GL Code";
        IMOSAPILOG.reset;
        IMOSAPILOG.SetRange("Table No.", Database::"Cust. Ledger Entry");
        IMOSAPILOG.SetFilter(Status, '<>%1', IMOSAPILOG.Status::Success);
        IMOSAPILOG.SetRange("Company Code", CompanyName);
        IMOSAPILOG.SetRange("Invoice List", true);
        IF IMOSAPILOG.FindFirst()then begin
            repeat InVTransNo:='';
                EntryDate:='';
                ACtDate:='';
                ExtranalRefID:='';
                PayMode:='WT';
                bankCode:='';
                CurrenyAmount:='';
                IMOSAPILOG2.Reset();
                IMOSAPILOG2.SetRange("Table No.", Database::"Cust. Ledger Entry");
                IMOSAPILOG2.SetFilter(Status, '<>%1', IMOSAPILOG2.Status::Success);
                IMOSAPILOG2.SetRange("Company Code", CompanyName);
                IMOSAPILOG2.SetRange("Invoice List", true);
                IMOSAPILOG2.SetRange("Primary key 2", IMOSAPILOG."Primary key 2");
                if IMOSAPILOG2.FindSet()then begin
                    RecCustLedEntry.Reset();
                    RecCustLedEntry.SetRange("Document No.", IMOSAPILOG."Primary key 2");
                    RecCustLedEntry.FindFirst();
                    DecCurrencyAmount:=0;
                    VendLEntDocNo:=RecCustLedEntry."Document No.";
                    ACtDate:=format(RecCustLedEntry."Document Date", 0, ImOSDatelbl);
                    EntryDate:=format(RecCustLedEntry."Posting Date", 0, ImOSDatelbl);
                    InvoiceData:='<invoicelist>';
                    ExtranalRefID:=RecCustLedEntry."Document No.";
                    repeat DecCurrencyAmount:=DecCurrencyAmount + abs(IMOSAPILOG."Payment Amount") + IMOSAPILOG."Over Receipt Amount";
                        BankCharge:=BankCharge + IMOSAPILOG2."Bank Charge Amount";
                        RecCustLedEntry.Reset();
                        RecCustLedEntry.SetRange("Document No.", IMOSAPILOG2."Primary key 3");
                        RecCustLedEntry.FindSet();
                        InVTransNo:=RecCustLedEntry."IMOS Transaction No";
                        InvoiceData:=InvoiceData + StrSubstNo(InvoiceListLbl, InVTransNo, format(-1 * IMOSAPILOG2."Payment Amount", 0, ImOSDatelbl));
                    until IMOSAPILOG2.Next() = 0;
                    InvoiceData:=InvoiceData + '</invoicelist>';
                end;
                CurrenyAmount:=format(abs(DecCurrencyAmount), 0, ImOSDatelbl);
                GLEntry.Reset();
                GLEntry.SetCurrentKey("Document No.");
                GLEntry.SetRange("Document No.", IMOSAPILOG."Primary key 2");
                GLEntry.SetFilter("IMOS Bank ID", '<>%1', '');
                if GLEntry.FindSet()then // bankCode := IMOSBankMapping."IMOS Bank ID";
                    bankCode:=GLEntry."IMOS Bank ID";
                InVTransNo:='';
                XMLData:='<simplePayment>' + StrSubstNo(InvoiceExchXML, InVTransNo, EntryDate, ACtDate, ExtranalRefID, PayMode, bankCode, CurrenyAmount, BankCharge, BankChargeGL) + InvoiceData + '</simplePayment>';
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
                    if IMOSAPILOG2.FindSet()then repeat IMOSAPILOG2."XML Data":=XmlData;
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
    procedure GetAndUpdateAPILOGForComDimMapping(P_Type: Option Insert, Update)
    VAR
        RecVendor: Record Vendor;
        RecCustomer: Record Customer;
        IMOSAPILOG: Record "IMOS API Log";
        CountryCode: Record "Country/Region";
        XMLData: Text;
        RecVendor2: Record Vendor;
        RecCustomer2: Record Customer;
        ParentCompShortName: Text;
        ParentCompType: Text;
        IsBlocked: Boolean;
    begin
        IMOSAPILOG.reset;
        IMOSAPILOG.SetRange("Table No.", Database::"Vendor Type Mapping");
        IMOSAPILOG.SetRange("Entry Type", P_Type);
        IMOSAPILOG.SetFilter(Status, '<>%1', IMOSAPILOG.Status::Success);
        IF IMOSAPILOG.FindFirst()then begin
            repeat XMLData:='';
                if IMOSAPILOG."Primary key" = IMOSAPILOG."Primary key"::Customer then begin
                    RecCustomer.GET(IMOSAPILOG."Primary key 2");
                    if RecCustomer.Blocked = RecCustomer.Blocked::All then IsBlocked:=true
                    else
                        IsBlocked:=false;
                    if CountryCode.GET(RecCustomer."Country/Region Code")then;
                    //XMLData := StrSubstNo(BodyReq, IMOSAPILOG."Primary key 4", RecCustomer."No.", RecCustomer.Name, RecCustomer.Name, '', RecCustomer."Currency Code", RecCustomer.Address, CountryCode.Name, RecCustomer."Country/Region Code", RecCustomer."Fax No.", RecCustomer."E-Mail", RecCustomer."Home Page")
                    RecVendor2.Reset();
                    RecCustomer2.Reset();
                    ParentCompShortName:='';
                    ParentCompType:='';
                    If RecCustomer."Parent Company Type" = RecVendor."Parent Company Type"::Vendor then IF RecVendor2.get(RecCustomer."Parent Company")then begin
                            ParentCompShortName:=RecVendor2."Short Name";
                            ParentCompType:=IMOSAPILOG."Primary key 4";
                        end;
                    If RecCustomer."Parent Company Type" = RecVendor."Parent Company Type"::Customer then IF RecCustomer2.get(RecCustomer."Parent Company")then begin
                            ParentCompShortName:=RecCustomer2."Short Name";
                            ParentCompType:=IMOSAPILOG."Primary key 4";
                        end;
                    ParentCompType:=RecCustomer."Parent Company CP Type";
                    XMLData:=StrSubstNo(BodyReq, IMOSAPILOG."Primary key 4", RecCustomer."No." + '_' + IMOSAPILOG."Primary key 4", RecCustomer."Short Name", RecCustomer.Name, RecCustomer."Currency Code", RecCustomer.Address, RecCustomer."Address 2", RecCustomer."Äddress 3", RecCustomer."Country/Region Code", RecCustomer."Phone No.", RecCustomer."Fax No.", RecCustomer."E-Mail", RecCustomer."Home Page", RecCustomer."Reference Code", ParentCompShortName, ParentCompType, format(IsBlocked, 0, ImOSDatelbl), RecCustomer.Contact);
                end
                else if IMOSAPILOG."Primary key" = IMOSAPILOG."Primary key"::Vendor then begin
                        RecVendor.GET(IMOSAPILOG."Primary key 2");
                        if RecVendor.Blocked = RecVendor.Blocked::All then IsBlocked:=true
                        else
                            IsBlocked:=false;
                        if CountryCode.GET(RecVendor."Country/Region Code")then;
                        RecVendor2.Reset();
                        RecCustomer2.Reset();
                        ParentCompShortName:='';
                        ParentCompType:='';
                        If RecVendor."Parent Company Type" = RecVendor."Parent Company Type"::Vendor then IF RecVendor2.get(RecVendor."Parent Company")then begin
                                ParentCompShortName:=RecVendor2."Short Name";
                            end;
                        If RecVendor."Parent Company Type" = RecVendor."Parent Company Type"::Customer then IF RecCustomer2.get(RecVendor."Parent Company")then begin
                                ParentCompShortName:=RecCustomer2."Short Name";
                            //ParentCompType := IMOSAPILOG."Primary key 4";
                            end;
                        ParentCompType:=RecVendor."Parent Company CP Type";
                        XMLData:=StrSubstNo(BodyReq, IMOSAPILOG."Primary key 4", RecVendor."No." + '_' + IMOSAPILOG."Primary key 4", RecVendor."Short Name", RecVendor.Name, RecVendor."Currency Code", RecVendor.Address, recvendor."Address 2", RecVendor."Äddress 3", RecVendor."Country/Region Code", RecVendor."Phone No.", RecVendor."Fax No.", RecVendor."E-Mail", RecVendor."Home Page", RecVendor."Reference Code", ParentCompShortName, ParentCompType, format(IsBlocked, 0, ImOSDatelbl), RecVendor.Contact);
                    end;
                GetAPIResponse(IMOSAPILOG, XMLData);
                IMOSAPILOG."XML Data":=XMLData;
                IMOSAPILOG."Sent Date Time":=CurrentDateTime;
                IMOSAPILOG.Status:=IMOSAPILOG.Status::Success;
                IMOSAPILOG.Modify();
            until IMOSAPILOG.Next() = 0;
        end;
    END;
    procedure GetAndUpdateAPILOGForVendorBankAccounts(P_Type: Option Insert, Update)
    VAR
        VendBankAccount: Record "Vendor Bank Account";
        IMOSAPILOG: Record "IMOS API Log";
        CountryCode: Record "Country/Region";
        VendorbankXML: text;
        vendor: Record Vendor;
        XMLData: Text[2048];
    begin
        VendorbankXML:='<companyBank><externalRef>%1</externalRef><beneficiaryBankName>%2</beneficiaryBankName><beneficiaryBankBranch>%3</beneficiaryBankBranch><beneficiaryBankAddress1>%4</beneficiaryBankAddress1><beneficiaryBankAddress2>%5</beneficiaryBankAddress2><beneficiaryBankCountryCode>%6</beneficiaryBankCountryCode><beneficiaryBankSwiftCode>%7</beneficiaryBankSwiftCode><beneficiaryBankFullName>%8</beneficiaryBankFullName><beneficiaryBankAct>%9</beneficiaryBankAct><beneficiaryBankAbaNo>%10</beneficiaryBankAbaNo><beneficiaryBankIban>%11</beneficiaryBankIban><beneficiaryBankCurrency>%12</beneficiaryBankCurrency><beneficiaryBankExternalRef>%13</beneficiaryBankExternalRef><beneficiaryAddress1>%14</beneficiaryAddress1><beneficiaryAddress2>%15</beneficiaryAddress2><beneficiaryAddress3>%16</beneficiaryAddress3><beneficiaryCountryCode>%17</beneficiaryCountryCode><correspondentBankName>%18</correspondentBankName><correspondentBankBranch>%19</correspondentBankBranch><correspondentBankAddress1>%20</correspondentBankAddress1>';
        VendorbankXML:=VendorbankXML + '<correspondentBankAddress2>%21</correspondentBankAddress2><correspondentBankCountryCode>%22</correspondentBankCountryCode><correspondentBankSwiftCode>%23</correspondentBankSwiftCode><correspondentBankAbaNo>%24</correspondentBankAbaNo><correspondentBankAct>%25</correspondentBankAct><correspondentBankIban>%26</correspondentBankIban><isInactive>%27</isInactive><isDefault>%28</isDefault><restrictFromPayBatch>%29</restrictFromPayBatch></companyBank>';
        IMOSAPILOG.reset;
        IMOSAPILOG.SetRange("Table No.", Database::"Vendor Bank Account");
        IMOSAPILOG.SetFilter(Status, '<>%1', IMOSAPILOG.Status::Success);
        IF IMOSAPILOG.FindFirst()then begin
            repeat if VendBankAccount.Get(IMOSAPILOG."Primary key 2", IMOSAPILOG."Primary key 3")then begin
                    vendor.Get(VendBankAccount."Vendor No.");
                    XMLData:=StrSubstNo(VendorbankXML, VendBankAccount."Vendor No." + '_' + IMOSAPILOG."Primary key 4", VendBankAccount.Name, VendBankAccount."Bank Branch No.", VendBankAccount."Bene Bank Address 1", VendBankAccount."Bene Bank Address 2", VendBankAccount."Country/Region Code", VendBankAccount."SWIFT Code", VendBankAccount."Beneficiary Name", VendBankAccount."Bank Account No.", VendBankAccount."ABA/BSB No.", VendBankAccount.IBAN, VendBankAccount."Currency Code", VendBankAccount."IMOS Ext Ref", VendBankAccount.Address, VendBankAccount."Address 2", VendBankAccount."Address 3", vendor."Country/Region Code", VendBankAccount."Correspondent Bank Name", VendBankAccount."Correspondent Branch", VendBankAccount."Correspondent Address", '', VendBankAccount."Corresp. Country/Region Code", VendBankAccount."Correspondent Swift Code", VendBankAccount."Correspondent ABA/BSB No.", VendBankAccount."Correspondent Bank Account No.", VendBankAccount."Correspondent IBAN No.", format(VendBankAccount."Is Inactive", 0, ImOSDatelbl), format(VendBankAccount."Is Default", 0, ImOSDatelbl), format(VendBankAccount."Res. PB", 0, ImOSDatelbl));
                    XMLData:=DelChr(XMLData, '=', '@|#|$|&|%|');
                    GetAPIResponse(IMOSAPILOG, XMLData);
                    IMOSAPILOG."XML Data":=XmlData;
                    IMOSAPILOG."Sent Date Time":=CurrentDateTime;
                    IMOSAPILOG.Status:=IMOSAPILOG.Status::Success;
                end
                else
                begin
                    IMOSAPILOG."Sent Date Time":=CurrentDateTime;
                    IMOSAPILOG.Status:=IMOSAPILOG.Status::Error;
                    IMOSAPILOG."XML Data":='Can not find Vendor Bank Account ' + format(IMOSAPILOG."Primary key 2") + ' ' + IMOSAPILOG."Primary key 3";
                end;
                IMOSAPILOG.Modify();
            until IMOSAPILOG.Next() = 0;
        end;
    END;
    procedure GetAndUpdateAPILOGForCustomerBankAccounts(P_Type: Option Insert, Update)
    VAR
        CustBankAccount: Record "Customer Bank Account";
        IMOSAPILOG: Record "IMOS API Log";
        CountryCode: Record "Country/Region";
        CustomerbankXML: text;
        Customer: Record Customer;
        XMLData: Text[2048];
    begin
        CustomerbankXML:='<companyBank><externalRef>%1</externalRef><beneficiaryBankName>%2</beneficiaryBankName><beneficiaryBankBranch>%3</beneficiaryBankBranch><beneficiaryBankAddress1>%4</beneficiaryBankAddress1><beneficiaryBankAddress2>%5</beneficiaryBankAddress2><beneficiaryBankCountryCode>%6</beneficiaryBankCountryCode><beneficiaryBankSwiftCode>%7</beneficiaryBankSwiftCode><beneficiaryBankFullName>%8</beneficiaryBankFullName><beneficiaryBankAct>%9</beneficiaryBankAct><beneficiaryBankAbaNo>%10</beneficiaryBankAbaNo><beneficiaryBankIban>%11</beneficiaryBankIban><beneficiaryBankCurrency>%12</beneficiaryBankCurrency><beneficiaryBankExternalRef>%13</beneficiaryBankExternalRef><beneficiaryAddress1>%14</beneficiaryAddress1><beneficiaryAddress2>%15</beneficiaryAddress2><beneficiaryAddress3>%16</beneficiaryAddress3><beneficiaryCountryCode>%17</beneficiaryCountryCode><correspondentBankName>%18</correspondentBankName><correspondentBankBranch>%19</correspondentBankBranch><correspondentBankAddress1>%20</correspondentBankAddress1>';
        CustomerbankXML:=CustomerbankXML + '<correspondentBankAddress2>%21</correspondentBankAddress2><correspondentBankCountryCode>%22</correspondentBankCountryCode><correspondentBankSwiftCode>%23</correspondentBankSwiftCode><correspondentBankAbaNo>%24</correspondentBankAbaNo><correspondentBankAct>%25</correspondentBankAct><correspondentBankIban>%26</correspondentBankIban><isInactive>%27</isInactive><isDefault>%28</isDefault><restrictFromPayBatch>%29</restrictFromPayBatch><beneficiaryAddress3>%30</beneficiaryAddress3><beneficiaryAddress4>%31</beneficiaryAddress4></companyBank>';
        IMOSAPILOG.reset;
        IMOSAPILOG.SetRange("Table No.", Database::"Customer Bank Account");
        IMOSAPILOG.SetFilter(Status, '<>%1', IMOSAPILOG.Status::Success);
        IF IMOSAPILOG.FindFirst()then begin
            repeat if CustBankAccount.Get(IMOSAPILOG."Primary key 2", IMOSAPILOG."Primary key 3")then begin
                    Customer.Get(CustBankAccount."Customer No.");
                    XMLData:=StrSubstNo(CustomerbankXML, CustBankAccount."Customer No." + '_' + IMOSAPILOG."Primary key 4", CustBankAccount.Name, CustBankAccount."Bank Branch No.", CustBankAccount."Bene Bank Address 1", CustBankAccount."Bene Bank Address 2", CustBankAccount."Country/Region Code", CustBankAccount."SWIFT Code", CustBankAccount."Beneficiary Name", CustBankAccount."Bank Account No.", CustBankAccount."ABA/BSB No.", CustBankAccount.IBAN, CustBankAccount."Currency Code", CustBankAccount."IMOS Ext Ref", CustBankAccount.Address, CustBankAccount."Address 2", CustBankAccount."Address 3", Customer."Country/Region Code", CustBankAccount."Correspondent Bank Name", CustBankAccount."Correspondent Branch", '', '', CustBankAccount."Corresp. Country/Region Code", CustBankAccount."Correspondent Swift Code", CustBankAccount."Correspondent ABA/BSB No.", CustBankAccount."Correspondent Bank Account No.", CustBankAccount."Correspondent IBAN No.", format(CustBankAccount."Is Inactive", 0, ImOSDatelbl), format(CustBankAccount."Is Default", 0, ImOSDatelbl), format(CustBankAccount."Res. PB", 0, ImOSDatelbl), CustBankAccount."Address 3", CustBankAccount."Address 4");
                    XMLData:=DelChr(XMLData, '=', '@|#|$|&|%|');
                    GetAPIResponse(IMOSAPILOG, XMLData);
                    IMOSAPILOG."XML Data":=XmlData;
                    IMOSAPILOG."Sent Date Time":=CurrentDateTime;
                    IMOSAPILOG.Status:=IMOSAPILOG.Status::Success;
                end
                else
                begin
                    IMOSAPILOG."Sent Date Time":=CurrentDateTime;
                    IMOSAPILOG.Status:=IMOSAPILOG.Status::Error;
                    IMOSAPILOG."XML Data":='Can not find Vendor Bank Account ' + format(IMOSAPILOG."Primary key 2") + ' ' + IMOSAPILOG."Primary key 3";
                end;
                IMOSAPILOG.Modify();
            until IMOSAPILOG.Next() = 0;
        end;
    END;
    procedure GetAndUpdateAPILOGForCurrExchRate(P_Type: Option Insert, Update)
    VAR
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        IMOSAPILOG: Record "IMOS API Log";
        CountryCode: Record "Country/Region";
        CurrExchXML: Label '<exchangeRate><baseCurrency>%1</baseCurrency><currency>%2</currency><effectiveDate>%3</effectiveDate><rate>%4</rate></exchangeRate>';
        XMLData: Text[2048];
        CurrDate: Date;
        ImOSDateFormat: DateTime;
        IMoSdate: Text;
        IMOSTime: Time;
    begin
        IMOSTime:=100000T;
        IMOSAPILOG.reset;
        IMOSAPILOG.SetRange("Table No.", Database::"Currency Exchange Rate");
        IMOSAPILOG.SetRange("Entry Type", P_Type);
        IMOSAPILOG.SetFilter(Status, '<>%1', IMOSAPILOG.Status::Success);
        IF IMOSAPILOG.FindFirst()then begin
            repeat //Evaluate(CurrDate, IMOSAPILOG."Primary key 3");
                CurrDate:=IMOSAPILOG."Currency Exch Start Date";
                CurrExchRate.Get(IMOSAPILOG."Primary key 2", CurrDate);
                ImOSDateFormat:=CreateDateTime(CurrDate, IMOSTime);
                IMoSdate:=Format(ImOSDateFormat, 0, ImOSDatelbl);
                XMLData:=StrSubstNo(CurrExchXML, 'USD', CurrExchRate."Currency Code", IMoSdate, format(CurrExchRate."Converted Rate", 0, ImOSDatelbl));
                GetAPIResponse(IMOSAPILOG, XMLData);
                IMOSAPILOG."XML Data":=XmlData;
                IMOSAPILOG."Sent Date Time":=CurrentDateTime;
                IMOSAPILOG.Modify();
            until IMOSAPILOG.Next() = 0;
        end;
    END;
    procedure GetAndUpdateAPILOGForVendLedg(P_Type: Option Insert, Update)
    VAR
        IMOSAPILOG: Record "IMOS API Log";
        XMLData: Text;
        RecCustLedEntry: Record "Vendor Ledger Entry";
        // XMLPayment: Label '<simplePayment><invoiceTransNo/><entryDate>2024-08-07 00;00:00.0</entryDate><actDate>2024-08-07 00;00:00.0</actDate><externalRefId>0206-TRAPA-00090374X0798USD</externalRefId><bankCode>20020601</bankCode><currencyAmount>51187.20</currencyAmount><currency>USD</currency><baseCurrencyAmount>51187.20</baseCurrencyAmount><batchId/><bankXCRate>1.00</bankXCRate><isAdvance/><xcRate/><companyCode/><transType/><vendorNo/><vendorName/><vendorType/><vendorCrossRef/><invoiceList><invoice><invoiceTransNo>24S7980047937N</invoiceTransNo><currencyAmount>51187.20</currencyAmount></invoice></invoiceList></simplePayment>';
        XMLPayment: Label '<simplePayment><invoiceTransNo>%1</invoiceTransNo><entryDate>%2</entryDate><actDate>%3</actDate><externalRefId>%4</externalRefId><bankCode>%5</bankCode><currencyAmount>%6</currencyAmount><currency>%7</currency><baseCurrencyAmount>%8</baseCurrencyAmount><batchId>%9</batchId><bankXCRate>%10</bankXCRate><isAdvance>%11</isAdvance><xcRate>%12</xcRate><companyCode>%13</companyCode><transType><%14</transType><vendorNo>%15</vendorNo><vendorName>%16</vendorName><vendorType>%17</vendorType><vendorCrossRef>%18</vendorCrossRef><invoiceList><invoice><invoiceTransNo>%19</invoiceTransNo><currencyAmount>%20</currencyAmount></invoice></invoiceList></simplePayment>';
    begin
        IMOSAPILOG.reset;
        IMOSAPILOG.SetRange("Table No.", Database::"Vendor Ledger Entry");
        IMOSAPILOG.SetRange("Entry Type", P_Type);
        IMOSAPILOG.SetFilter(Status, '<>%1', IMOSAPILOG.Status::Success);
        IF IMOSAPILOG.FindFirst()then begin
            repeat RecCustLedEntry.Reset();
                RecCustLedEntry.SetRange("Document Type", RecCustLedEntry."Document Type"::Payment);
                RecCustLedEntry.SetRange("Document No.", IMOSAPILOG."Primary key 2");
                if RecCustLedEntry.FindFirst()then begin
                    XMLData:=StrSubstNo(XMLPayment, '', RecCustLedEntry."Posting Date", RecCustLedEntry."Posting Date", RecCustLedEntry."External Document No.", RecCustLedEntry."Bal. Account No.", RecCustLedEntry.Amount, RecCustLedEntry."Currency Code", RecCustLedEntry."Amount (LCY)", RecCustLedEntry."Journal Batch Name", 0, 0, 0, CompanyName, '', RecCustLedEntry."Vendor No.", RecCustLedEntry."Vendor Name", '', '', RecCustLedEntry."Document No.", RecCustLedEntry.Amount);
                end;
                GetAPIResponse(IMOSAPILOG, XMLData);
                IMOSAPILOG."XML Data":=XmlData;
                IMOSAPILOG."Sent Date Time":=CurrentDateTime;
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
    procedure GetAndUpdateAPILOGForCustBankAcc(P_Type: Option Insert, Update)
    VAR
        IMOSAPILOG: Record "IMOS API Log";
        XMLData: Text;
        CustBankAcc: Record "Customer Bank Account";
        ComDimMapp: Record "Vendor Type Mapping";
        XMLPayment: Label '<simplePayment><invoiceTransNo>%1</invoiceTransNo><entryDate>%2</entryDate><actDate>%3</actDate><externalRefId>%4</externalRefId><bankCode>%5</bankCode><currencyAmount>%6</currencyAmount><currency>%7</currency><baseCurrencyAmount>%7</baseCurrencyAmount><batchId>%8</batchId><bankXCRate>%9</bankXCRate><isAdvance>%10</isAdvance><xcRate>%11</xcRate><companyCode>%12</companyCode><transType><%13</transType><customerNo>%14</customerNo><customerName>%15</customerName><customerType>%16</customerType><customerCrossRef>%17</customerCrossRef><invoiceList><invoice><invoiceTransNo>%18</invoiceTransNo><currencyAmount>%19</currencyAmount></invoice></invoiceList></simplePayment>';
    begin
        IMOSAPILOG.reset;
        IMOSAPILOG.SetRange("Table No.", Database::"Cust. Ledger Entry");
        IMOSAPILOG.SetRange("Entry Type", P_Type);
        IMOSAPILOG.SetFilter(Status, '<>%1', IMOSAPILOG.Status::Success);
        IF IMOSAPILOG.FindFirst()then begin
            repeat CustBankAcc.Reset();
                CustBankAcc.SetRange("Customer No.", IMOSAPILOG."Primary key 2");
                CustBankAcc.SetRange(Code, IMOSAPILOG."Primary key 3");
                if CustBankAcc.FindFirst()then XMLData:=StrSubstNo(XMLPayment);
                GetAPIResponse(IMOSAPILOG, XMLData);
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
    procedure GetAndUpdateAPILOGForInvoicePayment()
    VAR
        IMOSAPILOG: Record "IMOS API Log";
        RecVendLedEntry: record "Vendor Ledger Entry";
        VendorLedgEntry1: record "Vendor Ledger Entry";
        InvoiceExchXML: Label '<simplePayment><invoiceTransNo>%1</invoiceTransNo><entryDate>%2</entryDate><actDate>%3</actDate><externalRefId>%4</externalRefId><payMode>%5</payMode><bankCode>%6</bankCode><currencyAmount>%7</currencyAmount></simplePayment>';
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
    begin
        IMOSAPILOG.reset;
        IMOSAPILOG.SetRange("Table No.", Database::"Vendor Ledger Entry");
        IMOSAPILOG.SetFilter(Status, '<>%1', IMOSAPILOG.Status::Success);
        IMOSAPILOG.SetRange("Company Code", CompanyName);
        IMOSAPILOG.SetRange("Invoice List", false);
        IF IMOSAPILOG.FindFirst()then begin
            repeat InVTransNo:='';
                EntryDate:='';
                ACtDate:='';
                ExtranalRefID:='';
                PayMode:='WT';
                bankCode:='20020806';
                CurrenyAmount:='';
                RecVendLedEntry.Reset();
                //RecVendLedEntry.SetRange("Document Type", RecVendLedEntry."Document Type"::Payment);
                RecVendLedEntry.SetRange("Document No.", IMOSAPILOG."Primary key 2");
                if RecVendLedEntry.FindFirst()then begin
                    RecVendLedEntry.CalcFields(Amount);
                    VendLEntDocNo:=RecVendLedEntry."Document No.";
                    ACtDate:=format(RecVendLedEntry."Posting Date", 0, ImOSDatelbl);
                    EntryDate:=format(RecVendLedEntry."Posting Date", 0, ImOSDatelbl);
                    ExtranalRefID:=RecVendLedEntry."Document No.";
                    CurrenyAmount:=format(RecVendLedEntry.Amount, 0, ImOSDatelbl);
                    RecVendLedEntry.Reset();
                    RecVendLedEntry.SetRange("Document No.", IMOSAPILOG."Primary key 3");
                    if RecVendLedEntry.FindSet()then begin
                        InVTransNo:=RecVendLedEntry."IMOS Transaction No";
                    end;
                end;
                GLEntry.Reset();
                GLEntry.SetCurrentKey("Document No.");
                GLEntry.SetFilter("Document No.", '=%1|%2', IMOSAPILOG."Primary key 2", InVTransNo);
                if GLEntry.FindSet()then repeat IMOSBankMapping.Reset();
                        IMOSBankMapping.SetRange("Dummy GL Code", GLEntry."G/L Account No.");
                        if IMOSBankMapping.FindSet()then bankCode:=IMOSBankMapping."IMOS Bank ID";
                    until GLEntry.Next() = 0;
                XMLData:=StrSubstNo(InvoiceExchXML, InVTransNo, EntryDate, ACtDate, ExtranalRefID, PayMode, bankCode, CurrenyAmount);
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
    BodyReq: Label '<company><companyType>%1</companyType><externalRef>%2</externalRef><shortName>%3</shortName><fullName>%4</fullName><currency>%5</currency><address1>%6</address1><address2>%7</address2><address3>%8</address3><countryCode>%9</countryCode><phone>%10</phone><fax>%11</fax><email>%12</email><web>%13</web><referenceCode>%14</referenceCode><parentCompanyShortName>%15</parentCompanyShortName><parentCompanyType>%16</parentCompanyType>  <isInactive>%17</isInactive><mainContact>%18</mainContact></company>';
    TempIMOSLOG: Record "IMOS API Log" temporary;
    ImOSDatelbl: label '<Standard Format, 9 >';
}
