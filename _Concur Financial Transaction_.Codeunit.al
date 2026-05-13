codeunit 50126 "Concur Financial Transaction"
{
    trigger OnRun()
    begin
        GetFinancialTransactions(true);
    end;
    procedure GetFinancialTransactions(processData: Boolean): Text var
        TokenUrl: Text[1024];
        HttpClient: HttpClient;
        ResponseMessage: HttpResponseMessage;
        RequestHeader: HttpHeaders;
        ResponseJsonObject: JsonObject;
        ResponseJsonToken: JsonToken;
        AccessTokenErr: Text;
        AccessToken: Text;
        NewAccessToken: Text;
        JsonResponseTxt: Text;
        APISetup: Record "Concur API Setup";
        ConcurAPIInboundLog: Record "Concur API Inbound";
        AckFinanceTransaction: Codeunit "Concur Financial Trans Ack";
    begin
        APISetup.GET;
        APISetup.TestField("Is Enable", true);
        APISetup.TestField("Financial Transaction URL");
        APISetup.TestField("Financial Transaction Ack URL");
        AccessToken:=GenerateRefreshToken();
        IF AccessToken = '' then Error('No Access Token generated');
        HttpClient.DefaultRequestHeaders().Add('Authorization', AccessToken);
        HttpClient.Get(APISetup."Financial Transaction URL", ResponseMessage);
        IF ResponseMessage.IsSuccessStatusCode()THEN BEGIN
            ResponseMessage.Content().ReadAs(JsonResponseTxt);
            if processData then begin
                JsonBuffer.ReadFromText(JsonResponseTxt); // JSON Buffer
                LogEntryNo:=ConcurAPIInboundLog.InsertLog(1, JsonResponseTxt);
                //VJ 29NOV2024
                // InsertAPILog(3, 'id'); // insert response into api log
                // InsertDataInBC(); // insert data into staging
                // ConcurAPIInboundLog.InsertLog(1, JsonResponseTxt);//procedure to insert log
                Clear(g_ConcurID);
                ProcessInvoiceJson(JsonResponseTxt); //insert data in staging tab
                // if g_ConcurID = '' then
                //     Error('Error ack id= %1', g_ConcurID);
                if g_ConcurID <> '' then ConcurAPIInboundLog.Updateexpenseid(g_ConcurID, LogEntryNo);
                Clear(AckFinanceTransaction);
                if g_ConcurID <> '' then AckFinanceTransaction.GetAcknowledgement(g_ConcurID, LogEntryNo)// if GuiAllowed then
            //    Message('Response inserted successfully.');
            end
            else if GuiAllowed then Error('%1', JsonResponseTxt);
        //Page.Run(Page::"JSON Buffer CustomPage", JsonBuffer);
        //ProcessJasonresponse(JsonResponseTxt);
        end
        else
        begin
            ResponseMessage.Content().ReadAs(JsonResponseTxt);
            if GuiAllowed then Error('JsonResponse Text%1', JsonResponseTxt);
        end;
    end;
    procedure GenerateRefreshToken(): Text var
        TokenURL: Text[1024];
        ClientId: Text[1024];
        ClientSecret: Text[1024];
        Resource: Text[1024];
        //  RequestBody: Label 'grant_type=client_credentials&client_id=%1&client_secret=%2&scope=%3';
        RequestBody: Label 'client_id=d4b0bf5d-9021-4ff7-bc48-b6c0ce512d9c&client_secret=2280ce1d-85a5-4ac0-989c-2073c3c809f0&grant_type=refresh_token&refresh_token=i5jzxuuhpxm5yafvw8olksu58mq';
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
        APISetup: Record "Concur API Setup";
    begin
        APISetup.Get();
        // APISetup.TestField("Is Enable", true);
        APISetup.TestField("Token URL");
        APISetup.TestField("Client ID");
        APISetup.TestField("Client Secret");
        APISetup.TestField("Refresh Token");
        // APISetup.TestField("User Id");
        // APISetup.TestField(Password);
        AccessTokenErr:='';
        AccessToken:='';
        TokenURL:=APISetup."Token URL";
        RequestHeader:=HttpClient.DefaultRequestHeaders;
        RequestHeader.Add('User-Agent', 'Dynamics 365');
        AddHttpBasicAuthHeader(APISetup."User ID", APISetup.Password, HttpClient);
        Content.GetHeaders(RequestHeader);
        RequestHeader.Clear();
        HttpClient.SetBaseAddress(TokenURL);
        RequestMessage.Method('POST');
        RequestHeader.Remove('Content-Type');
        RequestHeader.Add('Content-Type', 'application/x-www-form-urlencoded');
        Clear(TempBlob);
        TempBlob.CreateOutStream(Outstr);
        //Outstr.WriteText(StrSubstNo(RequestBody));
        Outstr.WriteText(StrSubstNo('client_id=' + APISetup."Client ID" + '&client_secret=' + APISetup."Client Secret" + '&grant_type=refresh_token&refresh_token=' + APISetup."Refresh Token"));
        TempBlob.CreateInStream(Instr);
        Content.WriteFrom(Instr);
        RequestMessage.Content(Content);
        HttpClient.Send(RequestMessage, ResponseMessage);
        IF ResponseMessage.IsSuccessStatusCode()THEN BEGIN
            ResponseMessage.Content().ReadAs(APIResult);
            ResponseJsonObject.ReadFrom(APIResult);
            ResponseJsonObject.GET('access_token', ResponseJsonToken);
            AccessToken:='Bearer ' + ResponseJsonToken.AsValue().AsText();
        END
        ELSE
            AccessTokenErr:=CopyStr(GetLastErrorText(), 1, 100);
        //Message('%1', AccessToken);
        APISetup.SetAccessToken(AccessToken);
        APISetup.Modify();
        exit(AccessToken);
    end;
    procedure AddHttpBasicAuthHeader(UserName: Text[50]; Password: Text[50]; var HttpClient: HttpClient);
    var
        AuthString: Text;
        Base64Helpers: Codeunit "Base64 Convert";
    begin
        AuthString:=STRSUBSTNO('%1:%2', UserName, Password);
        AuthString:=Base64Helpers.ToBase64(AuthString);
        AuthString:=STRSUBSTNO('Basic %1', AuthString);
        HttpClient.DefaultRequestHeaders().Add('Authorization', AuthString);
    end;
    procedure ResponseJsonHeader(Depth: integer; path1: text): text var
    begin
        JSONBuffer.Reset();
        JSONBuffer.SetRange(Depth, Depth);
        JSONBuffer.SetRange(Path, path1);
        JsonBuffer.SetFilter("Token type", '<>%1&<>%2', JsonBuffer."Token type"::"Property Name", JsonBuffer."Token type"::Null);
        JsonBuffer.SetFilter(Value, '<>%1', '');
        if JSONBuffer.FindFirst()then begin
            JsonBufferValue:=JsonBuffer.Value;
            exit(JsonBufferValue);
        end;
    end;
    //////////////////////
    procedure ProcessInvoiceJson(jsonText: Text) // This procedure calls from the page51027 concur API log to read the response.
    var
        JsonObject: JsonObject;
        JsonToken: JsonToken;
        ContentObject: JsonObject;
        ContentDetailsArray: JsonArray;
        ContentDetailsObject: JsonObject;
        HeaderTable: Record "Concur inbound financial Expen"; //this is the table in which we have to store the data by response
        i: Integer;
    begin
        if not JsonObject.ReadFrom(JSONText)then Error('The JSON text could not be parsed into a JsonObject.');
        if JsonObject.Get('content', JsonToken)then begin //this line get the content array contain data 
            if JsonToken.IsArray()then begin
                ContentDetailsArray:=JsonToken.AsArray(); // Assign the JsonArray data to the variable whose data type is  jsonarray
                // Loop through the "content" array and process each item
                for i:=0 to ContentDetailsArray.Count()do begin
                    if ContentDetailsArray.Get(i, JsonToken)then if JsonToken.IsObject()then begin
                            // Get the invoice detail object
                            ContentDetailsObject:=JsonToken.AsObject();
                            // Process data
                            Contnentdata(ContentDetailsObject, HeaderTable);
                        end
                        else
                            Error('Invalid content detail object in "content" array at index %1.', i);
                end;
                message('Data insert successfully in staging table');
            end
            else
                Error('The "content" field is not a valid array.');
        end
        else
            Error('The "content" field is missing.');
    end;
    procedure Contnentdata(ContentObject: JsonObject; var HeaderTable: Record "Concur inbound financial Expen") //procedure to calculate each array and group present in response
    var
        JsonToken: JsonToken;
        ExpenseEntryArray: JsonArray;
        AllocationArray: JsonArray;
        JournalArray: JsonArray;
        TaxArray: JsonArray;
        i: Integer;
        L: Integer;
        M: Integer;
        N: Integer;
        EmployeeObject: JsonObject;
        ReportObject: JsonObject;
        ExpenseEntryDetailsObject: JsonObject;
        AllocationObject: JsonObject;
        DocumentObject: JsonObject;
        JournalObject: JsonObject;
        TaxObject: JsonObject;
        L_JournalAmt: Decimal;
        L_NetTaxAmt: Decimal;
    begin
        if ContentObject.Get('document', JsonToken)then begin
            if JsonToken.IsObject()then begin
                DocumentObject:=JsonToken.AsObject();
                //employee//
                if DocumentObject.Get('employee', JsonToken)then begin
                    if JsonToken.IsObject()then EmployeeObject:=JsonToken.AsObject();
                end;
                //report//
                if DocumentObject.Get('report', JsonToken)then begin
                    if JsonToken.IsObject()then ReportObject:=JsonToken.AsObject();
                end;
                ////ExpenseEntry//
                if DocumentObject.Get('expenseEntry', JsonToken) and JsonToken.IsArray()then begin
                    ExpenseEntryArray:=JsonToken.AsArray();
                    for i:=0 to ExpenseEntryArray.Count()do begin
                        if ExpenseEntryArray.Get(i, JsonToken)then if JsonToken.IsObject()then begin
                                ExpenseEntryDetailsObject:=JsonToken.AsObject();
                                //Allocation//
                                if ExpenseEntryDetailsObject.Get('allocation', JsonToken) and JsonToken.IsArray()then begin
                                    AllocationArray:=JsonToken.AsArray();
                                    for L:=0 to AllocationArray.Count()do begin
                                        if AllocationArray.Get(L, JsonToken)then if JsonToken.IsObject()then begin
                                                AllocationObject:=JsonToken.AsObject();
                                                //journal//
                                                if AllocationObject.Get('journal', JsonToken) and JsonToken.IsArray()then begin
                                                    JournalArray:=JsonToken.AsArray();
                                                    for M:=0 to JournalArray.Count()do begin
                                                        if JournalArray.Get(M, JsonToken)then if JsonToken.IsObject()then begin
                                                                JournalObject:=JsonToken.AsObject();
                                                                if JournalObject.Get('journalAccountCode', JsonToken)then if JsonToken.AsValue().AsText() <> '' then begin
                                                                        // InsertdataToBc(ContentObject, DocumentObject, EmployeeObject, ReportObject, ExpenseEntryDetailsObject, AllocationObject, HeaderTable, JsonToken);
                                                                        InsertEntryNo(HeaderTable);
                                                                        InsertHeader(ContentObject, JsonToken, HeaderTable);
                                                                        InsertDocument(DocumentObject, JsonToken, HeaderTable);
                                                                        InsertEmployee(EmployeeObject, JsonToken, HeaderTable);
                                                                        InsertReport(ReportObject, JsonToken, HeaderTable);
                                                                        InsertExpenseEntry(ExpenseEntryDetailsObject, JsonToken, HeaderTable);
                                                                        InsertAllocation(AllocationObject, JsonToken, HeaderTable);
                                                                        //journal fields
                                                                        if JournalObject.Get('journalAccountCode', JsonToken)then begin
                                                                            if not JsonToken.AsValue().IsNull then HeaderTable."Journal Key":=JsonToken.AsValue().AsText();
                                                                        end;
                                                                        if JournalObject.Get('amountGross', JsonToken)then begin
                                                                            if not JsonToken.AsValue().IsNull then HeaderTable.JournalAmt:=JsonToken.AsValue().AsText();
                                                                        end;
                                                                        if JournalObject.Get('amountNetOfReclaim', JsonToken)then begin
                                                                            if not JsonToken.AsValue().IsNull then HeaderTable."Net adjusted Reclaim Amount":=JsonToken.AsValue().AsText();
                                                                        end;
                                                                        if JournalObject.Get('amountNetOfTax', JsonToken)then begin
                                                                            if not JsonToken.AsValue().IsNull then HeaderTable."Net Tax Amount":=JsonToken.AsValue().AsText();
                                                                        end;
                                                                        if JournalObject.Get('accountingTransactionType', JsonToken)then begin
                                                                            if not JsonToken.AsValue().IsNull then HeaderTable."Entry Transaction Type":=JsonToken.AsValue().AsText();
                                                                        end;
                                                                        // if JournalObject.Get('journalPayee', JsonToken) then begin
                                                                        //     if not JsonToken.AsValue().IsNull then
                                                                        //         HeaderTable."Journal Key" := JsonToken.AsValue().AsText();
                                                                        // end;
                                                                        // if JournalObject.Get('journalPayer', JsonToken) then begin
                                                                        //     if not JsonToken.AsValue().IsNull then
                                                                        //         HeaderTable.journalPayer := JsonToken.AsValue().AsText();
                                                                        // end;
                                                                        //
                                                                        //TEC-SGarg>>
                                                                        L_JournalAmt:=0;
                                                                        L_NetTaxAmt:=0;
                                                                        Evaluate(L_JournalAmt, HeaderTable.JournalAmt);
                                                                        Evaluate(L_NetTaxAmt, HeaderTable."Net Tax Amount");
                                                                        HeaderTable."Calculated Tax Amount":=L_JournalAmt - L_NetTaxAmt;
                                                                        //TEC-SGarg<<
                                                                        HeaderTable.Insert();
                                                                        UpdateinMasterTable(HeaderTable); //Sgarg
                                                                    end;
                                                            end;
                                                    end;
                                                end;
                                                if AllocationObject.Get('tax', JsonToken) and JsonToken.IsArray()then begin
                                                    TaxArray:=JsonToken.AsArray();
                                                    for N:=0 to TaxArray.Count()do begin
                                                        if TaxArray.Get(N, JsonToken)then if JsonToken.IsObject()then begin
                                                                TaxObject:=JsonToken.AsObject();
                                                                if TaxObject.Get('locationCountryCode', JsonToken)then if JsonToken.AsValue().AsText() <> '' then begin
                                                                        /*
                                                                        InsertEntryNo(HeaderTable);
                                                                        InsertHeader(ContentObject, JsonToken, HeaderTable);
                                                                        InsertDocument(DocumentObject, JsonToken, HeaderTable);
                                                                        InsertEmployee(EmployeeObject, JsonToken, HeaderTable);
                                                                        InsertReport(ReportObject, JsonToken, HeaderTable);
                                                                        InsertExpenseEntry(ExpenseEntryDetailsObject, JsonToken, HeaderTable);
                                                                        InsertAllocation(AllocationObject, JsonToken, HeaderTable);
                                                                        */
                                                                        //Tax Field//
                                                                        // if TaxObject.Get('locationCountryCode', JsonToken) then begin
                                                                        //     if not JsonToken.AsValue().IsNull then
                                                                        //         HeaderTable.locationCountryCode := JsonToken.AsValue().AsText();
                                                                        // end;
                                                                        if TaxObject.Get('taxSource', JsonToken)then begin
                                                                            if not JsonToken.AsValue().IsNull then HeaderTable."Tax source":=JsonToken.AsValue().AsText();
                                                                        end;
                                                                        if TaxObject.Get('taxGuid', JsonToken)then begin
                                                                            if not JsonToken.AsValue().IsNull then HeaderTable."Tax id":=JsonToken.AsValue().AsText();
                                                                        end;
                                                                        if TaxObject.Get('amountReclaim', JsonToken)then begin
                                                                            if not JsonToken.AsValue().IsNull then HeaderTable."Report Entry Tax Reclm Adj.Amt":=JsonToken.AsValue().AsText();
                                                                        end;
                                                                        // if TaxObject.Get('taxReclaimCode', JsonToken) then begin
                                                                        //     if not JsonToken.AsValue().IsNull then
                                                                        //         HeaderTable.taxReclaimCode := JsonToken.AsValue().AsText();
                                                                        // end;
                                                                        // if TaxObject.Get('taxAuthorityLabel', JsonToken) then begin
                                                                        //     if not JsonToken.AsValue().IsNull then
                                                                        //         HeaderTable."Tax label" := JsonToken.AsValue().AsText();
                                                                        // end;
                                                                        // if TaxObject.Get('amountTax', JsonToken) then begin
                                                                        //     if not JsonToken.AsValue().IsNull then
                                                                        //         HeaderTable.amountTax := JsonToken.AsValue().AsText();
                                                                        // end;
                                                                        //
                                                                        //HeaderTable.Insert();
                                                                        HeaderTable.Modify();
                                                                    end end;
                                                    end;
                                                end;
                                            end;
                                    end;
                                end;
                            end;
                    end;
                end;
            end;
        end;
    end;
    local procedure InsertEntryNo(var HeaderTable: Record "Concur inbound financial Expen")
    var
        HeaderTableNew: Record "Concur inbound financial Expen";
    begin
        Clear(HeaderTable); //VJ 30/09/2025 +++
        HeaderTable.Init(); //VJ 30/09/2025 +++
        HeaderTableNew.Reset();
        if HeaderTableNew.FindLast()then HeaderTable."Entry No.":=HeaderTableNew."Entry No." + 1
        else
            HeaderTable."Entry No.":=1;
        HeaderTable."API Log Entry No.":=LogEntryNo;
    end;
    local procedure InsertHeader(ContentObject: JsonObject; JsonToken: JsonToken; var HeaderTable: Record "Concur inbound financial Expen")
    begin
        if ContentObject.Get('id', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Concur ID":=JsonToken.AsValue().AsText();
            if StrPos(g_ConcurID, HeaderTable."Concur ID") = 0 then begin
                if g_ConcurID = '' then g_ConcurID:=HeaderTable."Concur ID"
                else
                    g_ConcurID+=',' + HeaderTable."Concur ID";
            end;
        end;
    end;
    local procedure InsertDocument(DocumentObject: JsonObject; JsonToken: JsonToken; var HeaderTable: Record "Concur inbound financial Expen")
    begin
    //Document fields//
    end;
    local procedure InsertEmployee(EmployeeObject: JsonObject; JsonToken: JsonToken; var HeaderTable: Record "Concur inbound financial Expen")
    begin
        if EmployeeObject.Get('employeeId', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."EMP ID":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeOrgUnit1Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Employee Org Unit 1 Region":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeOrgUnit3Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Employee Org Unit 3":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeOrgUnit4Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Employee Org Unit 4-FD5":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeReimbursementMethodCode', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."reimb. Currency Alpha ISE":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeFirstName', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."First Name":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom21Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Journal Type":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom14Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Custom 14-Employee Acc code":=JsonToken.AsValue().AsText();
        end;
    end;
    local procedure InsertReport(ReportObject: JsonObject; JsonToken: JsonToken; var HeaderTable: Record "Concur inbound financial Expen")
    begin
        if ReportObject.Get('reportCustom12Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."New FD5":=JsonToken.AsValue().AsText();
        end;
        if ReportObject.Get('reportCustom17Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Report Custom 17  ":=JsonToken.AsValue().AsText();
        end;
        if ReportObject.Get('reportCustom1Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Report Entry Custom1 Proj Code":=JsonToken.AsValue().AsText();
        end;
        if ReportObject.Get('reportCustom2Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Report Entry Custom2(DOC code)":=JsonToken.AsValue().AsText();
        end;
        if ReportObject.Get('reportCustom3Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Report Entry Custom3 CT trvl":=JsonToken.AsValue().AsText();
        end;
        if ReportObject.Get('reportEntryTransactionAmount', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Report Entry Tax Adj. Amount":=JsonToken.AsValue().AsText();
        end;
        if ReportObject.Get('reportId', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Report ID":=JsonToken.AsValue().AsText();
        end;
        if ReportObject.Get('reportKey', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Report Key":=JsonToken.AsValue().AsText();
        end;
        if ReportObject.Get('reportName', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Report Name":=JsonToken.AsValue().AsText();
        end;
        if ReportObject.Get('reportOrgUnit3Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Report Org Unit 3   Division":=JsonToken.AsValue().AsText();
        end;
        if ReportObject.Get('reportOrgUnit4Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Report Org Unit 4   Company":=JsonToken.AsValue().AsText();
        end;
        if ReportObject.Get('reportPaymentProcessingDate', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Report Payment Processing Date":=JsonToken.AsValue().AsText();
        end;
        if ReportObject.Get('policyId', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Report Policy Name":=JsonToken.AsValue().AsText();
        end;
        if ReportObject.Get('reportSubmitDate', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Report Submit Date":=JsonToken.AsValue().AsText();
        end;
        if ReportObject.Get('totalApprovedAmount', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Report Total Approved Amount":=JsonToken.AsValue().AsText();
        end;
        if ReportObject.Get('reportUserDefinedDate', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Report User Defined Date":=JsonToken.AsValue().AsText();
        end;
        if ReportObject.Get('homeCountryCode', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Home Country":=JsonToken.AsValue().AsText();
        end;
        if ReportObject.Get('reportOrgUnit3Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Report Org Unit 3":=JsonToken.AsValue().AsText();
        end;
        if ReportObject.Get('employeeCurrencyAlphaCode', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Report Currency":=JsonToken.AsValue().AsText();
        end;
    end;
    local procedure InsertExpenseEntry(ExpenseEntryDetailsObject: JsonObject; JsonToken: JsonToken; var HeaderTable: Record "Concur inbound financial Expen")
    begin
        if ExpenseEntryDetailsObject.Get('entryApprovedAmount', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Entry Approved Amount":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('entryCountryCode', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Entry Country":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('entryCountrySubCode', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Entry Country Sub":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('entryDescription', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Entry Description":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('entryReceiptId', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Receipt Received":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('entryId', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Entry Id":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('cardTransactionPostedAmount', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Entry Posted Amount (Incl GST)":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('cardBillingDate', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Entry Transaction Date":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('entryExchangeRateDirection', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Exchange Rate Direction":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('expenseTypeName', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Expense Type Name":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('entryCustom13Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Custom 13-Corp Card acc Code":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('employeeCustom14Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Custom 14-Employee Acc code":=JsonToken.AsValue().AsText();
        end;
        //#192 VJ 27/01/2025>>
        if ExpenseEntryDetailsObject.Get('entryCustom4Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Cashledger Employee Name":=CopyStr(JsonToken.AsValue().AsText(), 1, 100);
        end;
        //#192 VJ 27/01/2025<<
        if ExpenseEntryDetailsObject.Get('entryCustom39Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Custom 39-Tax Reclaim Amount":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('entryCustom40Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Custom 40-Net of Tax Amount":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('entryCustom35Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Custom 35-Tax Reclaim Country":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('entryCustom39Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Custom 39-Tax Reclaim Amount":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('entryCustom40Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Custom 40-Net of Tax Amount":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('entryReceiptId', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Receipt Received":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('entryReceiptType', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Receipt Type":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('entryExchangeRate', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Currency Exchange Rate":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('entryCurrAlphaCode', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Spend Currency Alpha ISO":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('entryVendorDescription', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Vendor Description":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('entryIsPersonal', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Is Personal":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('entryCustom1Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable.Shipsign:=JsonToken.AsValue().AsText();
            // if NOT (HeaderTable.Shipsign in ['NA', '', 'Not Applicable']) THEN begin//#380 TEC.VJ 15JULY2025
            if ExpenseEntryDetailsObject.Get('entryCustom2Code', JsonToken)then begin
                if not JsonToken.AsValue().IsNull then HeaderTable."Entry Custom 2(DOC Code)":=JsonToken.AsValue().AsText();
            end;
        // end else
        //    HeaderTable."Entry Custom 2(DOC Code)" := HeaderTable.Shipsign;//#380 TEC.VJ 15JULY2025
        end;
        if ExpenseEntryDetailsObject.Get('entryCustom4Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Employee name":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('entryCustom6Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Cash Led entry description":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('entryVendorDescription', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Cash Led journal entry descri":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('entryCustom38Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Tax label":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('entryCustom39Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Journal Tax Amount":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('entryCustom40Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Journal Net Amount":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('entryDate', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Entry Date":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('legacyEntryId', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Legacy Entry Id":=JsonToken.AsValue().AsText();
        end;
        if ExpenseEntryDetailsObject.Get('reportEntryPaymentTypeName', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Payment Type":=JsonToken.AsValue().AsText();
        end;
    end;
    local procedure InsertAllocation(AllocationObject: JsonObject; JsonToken: JsonToken; var HeaderTable: Record "Concur inbound financial Expen")
    begin
        if AllocationObject.Get('allocationAccountResolverKey', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Allocation Alloc Key":=JsonToken.AsValue().AsText();
        end;
        if AllocationObject.Get('allocationPercentage', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Allocation Percentage":=JsonToken.AsValue().AsText();
        end;
    end;
    procedure ReProcessInvoiceJson(jsonText: Text; p_LogEntryNo: Integer) // reprocess log response
    var
        ConcurExpStaging: Record "Concur inbound financial Expen";
    begin
        ConcurExpStaging.Reset();
        ConcurExpStaging.SetRange("API Log Entry No.", p_LogEntryNo);
        if ConcurExpStaging.FindFirst()then ConcurExpStaging.DeleteAll();
        LogEntryNo:=p_LogEntryNo;
        ProcessInvoiceJson(jsonText);
    end;
    procedure UpdateInMastertable(var P_Detail: Record "Concur inbound financial Expen")
    var
        //Sgarg- Added this Fxn
        InboundMaster: Record "Concur Inbound Master";
        APISetup: Record "Concur API Setup";
        DateTimeValue: DateTime;
        L_ShipSign: Text;
        InboundMaster2: Record "Concur Inbound Master";
        CompNameMapping: Record "Company Name Mapping";
    begin
        APISetup.GET;
        L_ShipSign:='';
        //TEC.VJ 30Oct2025 << Comment for Company Code Prefix
        // IF (P_Detail.Shipsign <> '') AND (P_Detail.Shipsign <> 'Not Applicable') then
        //     L_ShipSign := APISetup."Company Code Prefix" + P_Detail.Shipsign;
        //TEC.VJ 30Oct2025 >> Comment for Company Code Prefix
        //TEC.VJ 30Oct2025 <<
        if CompNameMapping.Get(CompanyName)then IF(P_Detail.Shipsign <> '') AND (P_Detail.Shipsign <> 'Not Applicable')then L_ShipSign:=CompNameMapping.GetBCCompCode(P_Detail.Shipsign);
        //TEC.VJ 30Oct2025 >>
        IF NOT InboundMaster.GET(P_Detail."Report ID", P_Detail."Report Key", L_ShipSign)then begin
            IF InboundMaster2.GET(P_Detail."Report ID", P_Detail."Report Key", '')then InboundMaster2.Rename(P_Detail."Report ID", P_Detail."Report Key", L_ShipSign)
            else
            begin
                InboundMaster2.reset;
                InboundMaster2.SetRange("Report ID", P_Detail."Report ID");
                InboundMaster2.SetRange("External Doc No.", P_Detail."Report Key");
                if InboundMaster2.FindFirst()then begin
                    IF L_ShipSign <> '' then CreateConCurMaster(P_Detail, true)end
                else
                    CreateConCurMaster(P_Detail, false);
            End;
        END //ELSE BEGIN
    // IF (P_Detail.Shipsign <> '') AND (P_Detail.Shipsign <> 'Not Applicable') then begin
    //     CreateConCurMaster(P_Detail, true);
    //IF StrPos(InboundMaster."Ship Company Code", P_Detail.Shipsign) = 0 then begin
    //    IF InboundMaster."Ship Company Code" = '' then
    //        InboundMaster."Ship Company Code" += APISetup."Company Code Prefix" + P_Detail.Shipsign
    //    else
    ///         InboundMaster."Ship Company Code" += '|' + APISetup."Company Code Prefix" + P_Detail.Shipsign;
     //   InboundMaster.Modify();
    //end;
    // end;
    //END;
    end;
    procedure CreateConCurMaster(var P_Detail: Record "Concur inbound financial Expen"; P_FinBlank: Boolean)
    var
        //Sgarg-Created this Fxn
        InboundMaster: Record "Concur Inbound Master";
        APISetup: Record "Concur API Setup";
        DateTimeValue: DateTime;
        CompNameMapping: Record "Company Name Mapping";
    begin
        APISetup.GET;
        InboundMaster.Init();
        InboundMaster."Report ID":=P_Detail."Report ID";
        InboundMaster."External Doc No.":=P_Detail."Report Key";
        InboundMaster."Emp Id":=P_Detail."EMP ID";
        InboundMaster."Report Currency":=P_Detail."Report Currency";
        IF P_Detail."Journal Type" = 'CASH_LEDGER' then InboundMaster."Cash Ledger":=true;
        //TEC.VJ 30Oct2025 << Comment for Company Code Prefix
        // IF P_FinBlank then
        //     InboundMaster."Fin Company Code" := ''
        // else
        //     InboundMaster."Fin Company Code" := APISetup."Company Code Prefix" + P_Detail."Employee Org Unit 3";
        // IF (P_Detail.Shipsign <> '') AND (P_Detail.Shipsign <> 'Not Applicable') then
        //     InboundMaster."Ship Company Code" := APISetup."Company Code Prefix" + P_Detail.Shipsign;
        //TEC.VJ 30Oct2025 >> Comment for Company Code Prefix
        //TEC.VJ 30Oct2025 <<
        ///if CompNameMapping.Get(CompanyName) then
        IF P_FinBlank then InboundMaster."Fin Company Code":=''
        else
            InboundMaster."Fin Company Code":=CompNameMapping.GetBCCompCode(P_Detail."Employee Org Unit 3");
        IF(P_Detail.Shipsign <> '') AND (P_Detail.Shipsign <> 'Not Applicable')then InboundMaster."Ship Company Code":=CompNameMapping.GetBCCompCode(P_Detail.Shipsign);
        //TEC.VJ 30Oct2025 >>
        DateTimeValue:=0DT;
        evaluate(DateTimeValue, P_Detail."Report Payment Processing Date");
        InboundMaster."Payment Date":=DT2Date(DateTimeValue);
        InboundMaster."Create DateTime":=CurrentDateTime;
        InboundMaster.Status:=InboundMaster.Status::Pending;
        InboundMaster.Insert(true);
    end;
    var JsonBuffer: Record "JSON Buffer" temporary;
    JsonBufferValue: text;
    ConcurAPIResponse: Record "Concur API Response";
    ConcurAPIResponse2: Record "Concur API Response";
    LogEntryNo: Integer;
    g_ConcurID: Text;
}
