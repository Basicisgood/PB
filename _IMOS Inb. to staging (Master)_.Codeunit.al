codeunit 50168 "IMOS Inb. to staging (Master)"
{
    trigger OnRun()
    var
        IMOSInbound: record "IMOS API Inbound";
        CUIMOSInvoiceProcess: Codeunit "Process Invoice JSON";
    begin
        IMOSInbound.Reset();
        //IMOSInbound.Setfilter(Status, '=%1', IMOSInbound.Status::Pending);
        IMOSInbound.Setfilter(Status, '=%1|%2', IMOSInbound.Status::Pending, IMOSInbound.Status::Error);
        if IMOSInbound.FindSet()then repeat Commit();
                Clear(CUIMOSInvoiceProcess);
                if not CUIMOSInvoiceProcess.Run(IMOSInbound)then begin
                    IMOSInbound.Status:=IMOSInbound.Status::Error;
                    IMOSInbound."Error Description":=GetLastErrorText();
                    IMOSInbound.Modify();
                    IMOSInbound.CreateOutboundLogForIMOS(0);
                end;
            until IMOSInbound.Next() = 0;
    end;
    procedure ProcessInvoiceJson(jsonText: Text; jsonText1: Text)
    var
        JsonObject: JsonObject;
        JsonObject1: JsonObject;
        JsonToken1: JsonToken;
        JsonToken: JsonToken;
        InvoiceObject: JsonObject;
        InvoiceDetailsArray: JsonArray;
        InvoiceDetailObject: JsonObject;
        HeaderTable: Record "IMOS Invoice Staging Table";
        LineTable: Record "IMOS Invoice Line"; // 
        i: Integer;
        SerializedText: Text;
        SerializedText1: Text;
    begin
        if not JsonObject.ReadFrom(JSONText)then Error('The JSON text could not be parsed into a JsonObject.');
        // Retrieve and validate the "invoice" field
        if JsonObject.Get('invoice', JsonToken)then begin
            if JsonToken.IsObject()then begin
                InvoiceObject:=JsonToken.AsObject();
                // Serialize the JsonObject back to text for debugging
                InvoiceObject.WriteTo(SerializedText);
            // Message('Invoice data successfully retrieved: %1', SerializedText);
            end
            else
                Error('The "invoice" field exists but is not a valid object.');
        end
        else
            Error('The "invoice" field is missing.');
        // Extract the "invoice" object as JsonToken
        if JsonObject.Get('invoice', JsonToken) and JsonToken.IsObject()then begin
            InvoiceObject:=JsonToken.AsObject();
            // Process header data
            MapHeaderFields(InvoiceObject, HeaderTable);
            HeaderTable.Insert(true);
        end;
        // Process line details
        // if not JsonObject.ReadFrom(jsonText) then
        //     Error('The JSON text could not be parsed into a JsonObject.');
        if InvoiceObject.Get('invoiceDetails', JsonToken) and JsonToken.IsArray()then begin
            InvoiceDetailsArray:=JsonToken.AsArray();
            for i:=0 to InvoiceDetailsArray.Count() - 1 do begin
                if InvoiceDetailsArray.Get(i, JsonToken1) and JsonToken1.IsObject()then begin
                    InvoiceDetailObject:=JsonToken1.AsObject();
                    MapLineFields(InvoiceDetailObject, LineTable, HeaderTable.transNo, HeaderTable."Entry No.");
                    LineTable.Insert(true);
                end;
            end;
        end
        else
            Error('The "invoiceDetails" element is missing or not an array.');
    // end else
    //  Error('The "invoice" object is missing in the JSON.');
    end;
    procedure MapHeaderFields(InvoiceObject: JsonObject; var HeaderTable: Record "IMOS Invoice Staging Table")
    var
        JsonToken: JsonToken;
        HeaderTableNew: Record "IMOS Invoice Staging Table";
    begin
        // Map each field from JSON to the header table fields
        HeaderTableNew.Reset();
        if HeaderTableNew.FindLast()then HeaderTable."Entry No.":=HeaderTableNew."Entry No." + 1
        else
            HeaderTable."Entry No.":=1;
        if InvoiceObject.Get('_action', JsonToken)then HeaderTable._action:=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('status', JsonToken)then HeaderTable.Status:=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('transNo', JsonToken)then HeaderTable."transNo":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('transType', JsonToken)then HeaderTable."transType":=JsonToken.AsValue().AsInteger();
        if InvoiceObject.Get('externalRefId', JsonToken)then HeaderTable."externalRefId":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('billExternalRef', JsonToken)then HeaderTable."billExternalRef":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('vendorNo', JsonToken)then HeaderTable."vendorNo":=JsonToken.AsValue().AsInteger();
        if InvoiceObject.Get('vendorName', JsonToken)then HeaderTable."vendorName":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('vendorShortName', JsonToken)then HeaderTable."vendorShortName":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('vendorExternalRef', JsonToken)then HeaderTable."vendorExternalRef":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('vendorReferenceCode', JsonToken)then HeaderTable."vendorReferenceCode":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('vendorType', JsonToken)then HeaderTable."vendorType":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('vendorCountryCode', JsonToken)then HeaderTable."vendorCountryCode":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('vendorCrossRef', JsonToken)then HeaderTable."vendorCrossRef":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('vendorCareOf', JsonToken)then HeaderTable."vendorCareOf":=JsonToken.AsValue().AsInteger();
        if InvoiceObject.Get('vendorCareOfRef', JsonToken)then HeaderTable."vendorCareOfRef":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('vendorCareOfCountryCode', JsonToken)then HeaderTable."vendorCareOfCountryCode":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('invoiceNo', JsonToken)then HeaderTable."invoiceNo":=copystr(JsonToken.AsValue().AsText(), 1, 35);
        if InvoiceObject.Get('revInvoiceNo', JsonToken)then HeaderTable."revInvoiceNo":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('purchaseOrderNo', JsonToken)then HeaderTable."purchaseOrderNo":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('memo', JsonToken)then HeaderTable.Memo:=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('billRemarks', JsonToken)then HeaderTable."billRemarks":=copystr(JsonToken.AsValue().AsText(), 1, 500);
        if InvoiceObject.Get('approval', JsonToken)then HeaderTable.Approval:=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('paymentTermsCode', JsonToken)then HeaderTable."paymentTermsCode":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('invoiceDate', JsonToken)then if JsonToken.AsValue().AsText() = '' then HeaderTable."InvoiceDate":=0D
            else
                HeaderTable."InvoiceDate":=JsonToken.AsValue().AsDate();
        if InvoiceObject.Get('entryDate', JsonToken)then if JsonToken.AsValue().AsText() = '' then HeaderTable.entryDate:=0D
            else
                HeaderTable."EntryDate":=JsonToken.AsValue().AsDate();
        if InvoiceObject.Get('actDate', JsonToken)then if JsonToken.AsValue().AsText() = '' then HeaderTable.actDate:=0D
            else
                HeaderTable."actDate":=JsonToken.AsValue().AsDate();
        if InvoiceObject.Get('dueDate', JsonToken)then if JsonToken.AsValue().AsText() = '' then HeaderTable.dueDate:=0D
            else
                HeaderTable."DueDate":=JsonToken.AsValue().AsDate();
        if InvoiceObject.Get('exchangeRateDate', JsonToken)then if JsonToken.AsValue().AsText() = '' then HeaderTable.exchangeRateDate:=0D
            else
                HeaderTable."ExchangeRateDate":=JsonToken.AsValue().AsDate();
        if InvoiceObject.Get('receivedDate', JsonToken)then if JsonToken.AsValue().AsText() = '' then HeaderTable.receivedDate:=0D
            else
                HeaderTable."ReceivedDate":=JsonToken.AsValue().AsDate();
        if InvoiceObject.Get('approvalDate', JsonToken)then HeaderTable."ApprovalDate":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('approvalDate2', JsonToken)then HeaderTable."ApprovalDate2":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('approvalDate3', JsonToken)then HeaderTable."ApprovalDate3":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('approvalComments', JsonToken)then HeaderTable."ApprovalComments":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('approvalComments2', JsonToken)then HeaderTable."ApprovalComments2":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('approvalComments3', JsonToken)then HeaderTable."ApprovalComments3":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('remarks', JsonToken)then HeaderTable.Remarks:=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('cpDate', JsonToken)then HeaderTable."CPDate":=JsonToken.AsValue().AsDate();
        if InvoiceObject.Get('aparCode', JsonToken)then HeaderTable."APARCode":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('currencyAmount', JsonToken)then if JsonToken.IsValue()then begin
                // Attempt to convert the value to a decimal using Evaluate
                if Evaluate(HeaderTable.currencyAmount, JsonToken.AsValue().AsText())then begin
                end // Successfully parsed to decimal, do nothing
                else
                    HeaderTable.currencyAmount:=0.0; // Assign a default value if parsing fails
            end
            else
                HeaderTable.currencyAmount:=0.0;
        if InvoiceObject.Get('currency', JsonToken)then HeaderTable.Currency:=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('exchangeRate', JsonToken)then if JsonToken.IsValue()then begin
                // Attempt to convert the value to a decimal using Evaluate
                if Evaluate(HeaderTable.exchangeRate, JsonToken.AsValue().AsText())then begin
                end // Successfully parsed to decimal, do nothing
                else
                    HeaderTable.exchangeRate:=0.0; // Assign a default value if parsing fails
            end
            else
                HeaderTable.exchangeRate:=0.0;
        if InvoiceObject.Get('baseCurrencyAmount', JsonToken)then if JsonToken.IsValue()then begin
                // Attempt to convert the value to a decimal using Evaluate
                if Evaluate(HeaderTable.baseCurrencyAmount, JsonToken.AsValue().AsText())then begin
                end // Successfully parsed to decimal, do nothing
                else
                    HeaderTable.baseCurrencyAmount:=0.0; // Assign a default value if parsing fails
            end
            else
                HeaderTable.baseCurrencyAmount:=0.0;
        if InvoiceObject.Get('oprTransNo', JsonToken)then HeaderTable."OprTransNo":=JsonToken.AsValue().AsInteger();
        if InvoiceObject.Get('oprBillSource', JsonToken)then HeaderTable."OprBillSource":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('vatCurr', JsonToken)then HeaderTable."VATCurr":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('tcCode', JsonToken)then HeaderTable."tcCode":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('vatExchangeRate', JsonToken)then if JsonToken.IsValue()then begin
                // Attempt to convert the value to a decimal using Evaluate
                if Evaluate(HeaderTable.vatExchangeRate, JsonToken.AsValue().AsText())then begin
                end // Successfully parsed to decimal, do nothing
                else
                    HeaderTable.vatExchangeRate:=0.0; // Assign a default value if parsing fails
            end
            else
                HeaderTable.vatExchangeRate:=0.0;
        if InvoiceObject.Get('vatExchangeRateDate', JsonToken)then HeaderTable."VATExchangeRateDate":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('remittanceSeq', JsonToken)then HeaderTable."RemittanceSeq":=JsonToken.AsValue().AsInteger();
        if InvoiceObject.Get('remittanceCompNo', JsonToken)then HeaderTable."RemittanceCompNo":=JsonToken.AsValue().AsInteger();
        if InvoiceObject.Get('remittanceAccountNo', JsonToken)then HeaderTable."RemittanceAccountNo":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('remittanceBankName', JsonToken)then HeaderTable."RemittanceBankName":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('remittanceExternalRef', JsonToken)then HeaderTable."RemittanceExternalRef":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('remittanceSwiftCode', JsonToken)then HeaderTable."RemittanceSwiftCode":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('remittanceFullName', JsonToken)then HeaderTable."RemittanceFullName":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('remittanceIban', JsonToken)then HeaderTable."RemittanceIBAN":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('docNo', JsonToken)then HeaderTable."DocNo":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('companyBU', JsonToken)then HeaderTable."CompanyBU":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('counterpartyBU', JsonToken)then HeaderTable."CounterpartyBU":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('paymentAccountNo', JsonToken)then HeaderTable."PaymentAccountNo":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('paymentBank', JsonToken)then HeaderTable."PaymentBank":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('paymentBankCode', JsonToken)then HeaderTable."PaymentBankCode":=JsonToken.AsValue().AsText();
        if InvoiceObject.Get('lastUserId', JsonToken)then HeaderTable."LastUserId":=JsonToken.AsValue().AsText();
    end;
    local procedure MapLineFields(InvoiceDetailObject: JsonObject; var LineTable: Record "IMOS Invoice Line"; TransactionNo: Text; EntryNoHeader: Integer)
    var
        JsonToken: JsonToken;
        LineTable1: Record "IMOS Invoice Line";
    begin
        // Map each field from JSON to the line table fields
        LineTable."Invoice Entry No.":=EntryNoHeader;
        if InvoiceDetailObject.Get('transNo', JsonToken)then LineTable."transNo":=JsonToken.AsValue().AsText();
        LineTable1.Reset();
        LineTable1.SetFilter("Invoice Entry No.", '%1', EntryNoHeader);
        LineTable1.SetFilter(transNo, '%1', JsonToken.AsValue().AsText());
        if LineTable1.FindLast()then LineTable."Line No":=LineTable1."Line No" + 10000
        else
            LineTable."Line No":=10000;
        if InvoiceDetailObject.Get('transType', JsonToken)then LineTable."transType":=JsonToken.AsValue().AsInteger();
        if InvoiceDetailObject.Get('seqNo', JsonToken)then LineTable."seqNo":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('oprSeqNo', JsonToken)then LineTable."oprSeqNo":=JsonToken.AsValue().AsInteger();
        if InvoiceDetailObject.Get('oprBillCode', JsonToken)then LineTable."oprBillCode":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('billSubSeq', JsonToken)then LineTable."billSubSeq":=JsonToken.AsValue().AsInteger();
        if InvoiceDetailObject.Get('billSubCode', JsonToken)then LineTable."billSubCode":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('billSubSource', JsonToken)then LineTable."billSubSource":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('companyCode', JsonToken)then LineTable."companyCode":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('companyExternalRef', JsonToken)then LineTable."companyExternalRef":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('companyContact', JsonToken)then LineTable."companyContact":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('companyContactPhone', JsonToken)then LineTable."companyContactPhone":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('lobCode', JsonToken)then LineTable."lobCode":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('deptCode', JsonToken)then LineTable."deptCode":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('vesselCode', JsonToken)then LineTable."vesselCode":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('vesselName', JsonToken)then LineTable."vesselName":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('vesselExternalRef', JsonToken)then LineTable."vesselExternalRef":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('vesselCrossRef', JsonToken)then LineTable."vesselCrossRef":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('vesselImoNo', JsonToken)then LineTable."vesselImoNo":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('vesselType', JsonToken)then LineTable."vesselType":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('vesselGRT', JsonToken)then if JsonToken.IsValue()then begin
                // Attempt to convert the value to a decimal using Evaluate
                if Evaluate(LineTable.vesselGRT, JsonToken.AsValue().AsText())then begin
                end // Successfully parsed to decimal, do nothing
                else
                    LineTable.vesselGRT:=0.0; // Assign a default value if parsing fails
            end
            else
                LineTable.vesselGRT:=0.0;
        if InvoiceDetailObject.Get('vendorNo', JsonToken)then LineTable."vendorNo":=JsonToken.AsValue().AsInteger();
        if InvoiceDetailObject.Get('vendorName', JsonToken)then LineTable."vendorName":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('vendorShortName', JsonToken)then LineTable."vendorShortName":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('vendorExternalRef', JsonToken)then LineTable."vendorExternalRef":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('vendorCrossRef', JsonToken)then LineTable."vendorCrossRef":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('vendorReferenceCode', JsonToken)then LineTable."vendorReferenceCode":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('vendorIsInternal', JsonToken)then LineTable."vendorIsInternal":=JsonToken.AsValue().AsBoolean();
        if InvoiceDetailObject.Get('vendorType', JsonToken)then LineTable."vendorType":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('intercompanyCode', JsonToken)then LineTable."intercompanyCode":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('voyageNo', JsonToken)then LineTable."voyageNo":=JsonToken.AsValue().AsInteger();
        if InvoiceDetailObject.Get('fixtureNo', JsonToken)then LineTable."fixtureNo":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('portName', JsonToken)then LineTable."portName":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('portNo', JsonToken)then LineTable."portNo":=JsonToken.AsValue().AsInteger();
        if InvoiceDetailObject.Get('portUNCode', JsonToken)then LineTable."portUNCode":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('portCountryCode', JsonToken)then LineTable."portCountryCode":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('ledgerCode', JsonToken)then LineTable."ledgerCode":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('ledgerCategory', JsonToken)then LineTable."ledgerCategory":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('aparCode', JsonToken)then LineTable."aparCode":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('actDate', JsonToken)then if JsonToken.AsValue().AsText() = '' then LineTable."actDate":=0D
            else
                LineTable."actDate":=JsonToken.AsValue().AsDate();
        if InvoiceDetailObject.Get('memo', JsonToken)then LineTable."memo":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('currencyAmount', JsonToken)then if JsonToken.IsValue()then begin
                // Attempt to convert the value to a decimal using Evaluate
                if Evaluate(LineTable.currencyAmount, JsonToken.AsValue().AsText())then begin
                end // Successfully parsed to decimal, do nothing
                else
                    LineTable.currencyAmount:=0.0; // Assign a default value if parsing fails
            end
            else
                LineTable.currencyAmount:=0.0;
        if InvoiceDetailObject.Get('currency', JsonToken)then LineTable."currency":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('exchangeRate', JsonToken)then if JsonToken.IsValue()then begin
                // Attempt to convert the value to a decimal using Evaluate
                if Evaluate(LineTable.exchangeRate, JsonToken.AsValue().AsText())then begin
                end // Successfully parsed to decimal, do nothing
                else
                    LineTable.exchangeRate:=0.0; // Assign a default value if parsing fails
            end
            else
                LineTable.exchangeRate:=0.0;
        if InvoiceDetailObject.Get('exchangeRateDate', JsonToken)then LineTable."exchangeRateDate":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('baseCurrencyAmount', JsonToken)then if JsonToken.IsValue()then begin
                // Attempt to convert the value to a decimal using Evaluate
                if Evaluate(LineTable.baseCurrencyAmount, JsonToken.AsValue().AsText())then begin
                end // Successfully parsed to decimal, do nothing
                else
                    LineTable.baseCurrencyAmount:=0.0; // Assign a default value if parsing fails
            end
            else
                LineTable.baseCurrencyAmount:=0.0;
        if InvoiceDetailObject.Get('taxCode', JsonToken)then LineTable."taxCode":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('companyBrokerage', JsonToken)then LineTable."companyBrokerage":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('counterpartyBrokerage', JsonToken)then LineTable."counterpartyBrokerage":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('lastUserId', JsonToken)then LineTable."lastUserId":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('lastModifiedDate', JsonToken)then LineTable."lastModifiedDate":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('description', JsonToken)then LineTable."description":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('taxRate', JsonToken)then if JsonToken.IsValue()then begin
                // Attempt to convert the value to a decimal using Evaluate
                if Evaluate(LineTable.taxRate, JsonToken.AsValue().AsText())then begin
                end // Successfully parsed to decimal, do nothing
                else
                    LineTable.taxRate:=0.0; // Assign a default value if parsing fails
            end
            else
                LineTable.taxRate:=0.0;
        if InvoiceDetailObject.Get('tradeRoute', JsonToken)then LineTable."tradeRoute":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('tradeRouteCode', JsonToken)then LineTable."tradeRouteCode":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('tradeRouteExtRef', JsonToken)then LineTable."tradeRouteExtRef":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('oprType', JsonToken)then LineTable."oprType":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('opsCoordinator', JsonToken)then LineTable."opsCoordinator":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('voyRef', JsonToken)then LineTable."voyRef":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('voyageCompanyCode', JsonToken)then LineTable."voyageCompanyCode":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('voyageTCICode', JsonToken)then LineTable."voyageTCICode":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('voyageTCOCode', JsonToken)then LineTable."voyageTCOCode":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('voyageCommenceDateTime', JsonToken)then LineTable."voyageCommenceDateTime":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('voyageCompletionDateTime', JsonToken)then LineTable."voyageCompletionDateTime":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('rate', JsonToken)then if JsonToken.IsValue()then begin
                // Attempt to convert the value to a decimal using Evaluate
                if Evaluate(LineTable.rate, JsonToken.AsValue().AsText())then begin
                end // Successfully parsed to decimal, do nothing
                else
                    LineTable.rate:=0.0; // Assign a default value if parsing fails
            end
            else
                LineTable.rate:=0.0;
        if InvoiceDetailObject.Get('percentage', JsonToken)then if JsonToken.IsValue()then begin
                // Attempt to convert the value to a decimal using Evaluate
                if Evaluate(LineTable.percentage, JsonToken.AsValue().AsText())then begin
                end // Successfully parsed to decimal, do nothing
                else
                    LineTable.percentage:=0.0; // Assign a default value if parsing fails
            end
            else
                LineTable.percentage:=0.0;
        if InvoiceDetailObject.Get('quantity', JsonToken)then if JsonToken.IsValue()then begin
                // Attempt to convert the value to a decimal using Evaluate
                if Evaluate(LineTable.quantity, JsonToken.AsValue().AsText())then begin
                end // Successfully parsed to decimal, do nothing
                else
                    LineTable.quantity:=0.0; // Assign a default value if parsing fails
            end
            else
                LineTable.quantity:=0.0;
        ;
        if InvoiceDetailObject.Get('BLDate', JsonToken)then LineTable."BLDate":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('BLCode', JsonToken)then LineTable."BLCode":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('cpUnit', JsonToken)then LineTable."cpUnit":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('consignee', JsonToken)then LineTable."consignee":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('commercialId', JsonToken)then LineTable."commercialId":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('consigneeNo', JsonToken)then LineTable."consigneeNo":=JsonToken.AsValue().AsInteger();
        if InvoiceDetailObject.Get('agent', JsonToken)then LineTable."agent":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('refBLNo', JsonToken)then LineTable."refBLNo":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('combineIndicator', JsonToken)then LineTable."combineIndicator":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('transhipIndicator', JsonToken)then LineTable."transhipIndicator":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('transhipSeq', JsonToken)then LineTable."transhipSeq":=JsonToken.AsValue().AsInteger();
        if InvoiceDetailObject.Get('transhipDate', JsonToken)then if JsonToken.AsValue().AsText() = '' then LineTable."transhipDate":=0D
            else
                LineTable."transhipDate":=JsonToken.AsValue().AsDate();
        if InvoiceDetailObject.Get('transhipPort', JsonToken)then LineTable."transhipPort":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('transhipToVessel', JsonToken)then LineTable."transhipToVessel":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('transhipToVoyNo', JsonToken)then LineTable."transhipToVoyNo":=JsonToken.AsValue().AsInteger();
        if InvoiceDetailObject.Get('transhipGross', JsonToken)then if JsonToken.IsValue()then begin
                // Attempt to convert the value to a decimal using Evaluate
                if Evaluate(LineTable.transhipGross, JsonToken.AsValue().AsText())then begin
                end // Successfully parsed to decimal, do nothing
                else
                    LineTable.transhipGross:=0.0; // Assign a default value if parsing fails
            end
            else
                LineTable.transhipGross:=0.0;
        if InvoiceDetailObject.Get('transhipGrossUnit', JsonToken)then LineTable."transhipGrossUnit":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('cargoFullName', JsonToken)then LineTable."cargoFullName":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('cargoGroupCode', JsonToken)then LineTable."cargoGroupCode":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('blQty', JsonToken)then if JsonToken.IsValue()then begin
                // Attempt to convert the value to a decimal using Evaluate
                if Evaluate(LineTable."blQty", JsonToken.AsValue().AsText())then begin
                end // Successfully parsed to decimal, do nothing
                else
                    LineTable."blQty":=0.0; // Assign a default value if parsing fails
            end
            else
                LineTable."blQty":=0.0;
        if InvoiceDetailObject.Get('cargoId', JsonToken)then LineTable."cargoId":=JsonToken.AsValue().AsInteger();
        if InvoiceDetailObject.Get('importedCargo', JsonToken)then LineTable."importedCargo":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('coaNo', JsonToken)then LineTable."coaNo":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('cargoRefContract', JsonToken)then LineTable."cargoRefContract":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('cargoExposureVesselNumber', JsonToken)then LineTable."cargoExposureVesselNumber":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('portCallSeq', JsonToken)then LineTable."portCallSeq":=JsonToken.AsValue().AsInteger();
        if InvoiceDetailObject.Get('voyageRef', JsonToken)then LineTable."voyageRef":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('bunkerType', JsonToken)then LineTable."bunkerType":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('tciVesselNumber', JsonToken)then LineTable."tciVesselNumber":=JsonToken.AsValue().AsText();
        if InvoiceDetailObject.Get('tciReference', JsonToken)then LineTable."tciReference":=JsonToken.AsValue().AsText();
    end;
}
