codeunit 50158 "Concur Cash Advance"
{
    trigger OnRun()
    begin
        GetCashAdvanceData(true);
    end;
    procedure GetCashAdvanceData(processData: Boolean): Text var
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
        AckCashAdvance: Codeunit "Concur Post Cash Advance Ackn.";
    begin
        APISetup.GET;
        APISetup.TestField("Is Enable Cash Advance");
        APISetup.TestField("Get Cash Advance URL");
        AccessToken:=GenerateRefreshToken();
        IF AccessToken = '' then Error('No Access Token generated');
        HttpClient.DefaultRequestHeaders().Add('Authorization', AccessToken);
        HttpClient.Get(APISetup."Get Cash Advance URL", ResponseMessage);
        IF ResponseMessage.IsSuccessStatusCode()THEN BEGIN
            ResponseMessage.Content().ReadAs(JsonResponseTxt);
            if processData then begin
                JsonBuffer.ReadFromText(JsonResponseTxt); // JSON Buffer
                LogEntryNo:=ConcurAPIInboundLog.InsertLog(8, JsonResponseTxt);
                Clear(g_ConcurID);
                ProcessInvoiceJson(JsonResponseTxt); //insert data in staging tab
                if g_ConcurID <> '' then ConcurAPIInboundLog.Updateexpenseid(g_ConcurID, LogEntryNo);
                Clear(AckCashAdvance);
                if g_ConcurID <> '' then AckCashAdvance.GetAcknowledgement(g_ConcurID, LogEntryNo);
            // if GuiAllowed then
            //     Message('Response inserted successfully.');
            end
            else if GuiAllowed then Error('%1', JsonResponseTxt);
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
    procedure ProcessInvoiceJson(jsonText: Text)
    var
        JsonObject: JsonObject;
        JsonToken: JsonToken;
        ContentObject: JsonObject;
        ContentDetailsArray: JsonArray;
        ContentDetailsObject: JsonObject;
        HeaderTable: Record "Concur Cash Advance"; //this is the table in which we have to store the data by response
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
    procedure Contnentdata(ContentObject: JsonObject; var HeaderTable: Record "Concur Cash Advance") //procedure to calculate each array and group present in response
    var
        JsonToken: JsonToken;
        ExpenseEntryArray: JsonArray;
        AllocationArray: JsonArray;
        TaxArray: JsonArray;
        i: Integer;
        L: Integer;
        M: Integer;
        N: Integer;
        EmployeeObject: JsonObject;
        DocumentObject: JsonObject;
        CashAdvanceObject: JsonObject;
        JournalObject: JsonObject;
        JournalObject2: JsonObject;
        JournalArray: JsonArray;
    begin
        if ContentObject.Get('document', JsonToken)then begin
            if JsonToken.IsObject()then begin
                DocumentObject:=JsonToken.AsObject();
                //employeeData//
                if DocumentObject.Get('employeeData', JsonToken)then begin
                    if JsonToken.IsObject()then EmployeeObject:=JsonToken.AsObject();
                end;
                //cashAdvanceData//
                if DocumentObject.Get('cashAdvanceData', JsonToken)then begin
                    if JsonToken.IsObject()then CashAdvanceObject:=JsonToken.AsObject();
                end;
                InsertEntryNo(HeaderTable);
                InsertHeader(ContentObject, JsonToken, HeaderTable);
                InsertEmployee(EmployeeObject, JsonToken, HeaderTable);
                InsertCashAdvance(CashAdvanceObject, JsonToken, HeaderTable);
                if DocumentObject.Get('journalData', JsonToken) and JsonToken.IsArray()then begin
                    JournalArray:=JsonToken.AsArray();
                    if JournalArray.Get(0, JsonToken)then if JsonToken.IsObject()then begin
                            JournalObject:=JsonToken.AsObject();
                            InsertJournalObject(JournalObject, JsonToken, HeaderTable);
                        end;
                end;
                HeaderTable."Company":=CompanyName;
                HeaderTable."Create Date":=Today;
                HeaderTable.Insert();
            //UpdateinMasterTable(HeaderTable);  //Sgarg
            end;
        end end;
    local procedure InsertEntryNo(var HeaderTable: Record "Concur Cash Advance")
    var
        HeaderTableNew: Record "Concur Cash Advance";
    begin
        HeaderTableNew.Reset();
        if HeaderTableNew.FindLast()then HeaderTable."Entry No.":=HeaderTableNew."Entry No." + 1
        else
            HeaderTable."Entry No.":=1;
        HeaderTable."API Log Entry No.":=LogEntryNo;
    end;
    local procedure InsertHeader(ContentObject: JsonObject; JsonToken: JsonToken; var HeaderTable: Record "Concur Cash Advance")
    begin
        if ContentObject.Get('id', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Concur ID":=JsonToken.AsValue().AsText();
            if StrPos(g_ConcurID, HeaderTable."Concur ID") = 0 then begin
                if g_ConcurID = '' then g_ConcurID:=HeaderTable."Concur ID"
                else
                    g_ConcurID+=',' + HeaderTable."Concur ID";
            end;
        end;
        if ContentObject.Get('docType', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable.DocType:=JsonToken.AsValue().AsText();
        end;
        if ContentObject.Get('companyId', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable.CompanyID:=JsonToken.AsValue().AsText();
        end;
        if ContentObject.Get('entityId', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable.entityId:=JsonToken.AsValue().AsText();
        end;
        if ContentObject.Get('companyUuid', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable.companyUuid:=JsonToken.AsValue().AsText();
        end;
        if ContentObject.Get('erpSystemId', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable.erpSystemId:=JsonToken.AsValue().AsText();
        end;
        if ContentObject.Get('docStatus', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable.docStatus:=JsonToken.AsValue().AsText();
        end;
    end;
    local procedure InsertEmployee(EmployeeObject: JsonObject; JsonToken: JsonToken; var HeaderTable: Record "Concur Cash Advance")
    begin
        if EmployeeObject.Get('employeeReimbursementMethodCode', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."Emp. ReimbursementMethodCode":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeOrgUnit1Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeOrgUnit1Code":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeOrgUnit2Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeOrgUnit2Code":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeOrgUnit3Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeOrgUnit3Code":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeOrgUnit4Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeOrgUnit4Code":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeOrgUnit5Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeOrgUnit5Code":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeOrgUnit6Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeOrgUnit6Code":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeOrgUnit1Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeOrgUnit1Value":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeOrgUnit2Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeOrgUnit2Value":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeOrgUnit3Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeOrgUnit3Value":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeOrgUnit4Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeOrgUnit4Value":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeOrgUnit5Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeOrgUnit5Value":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeOrgUnit6Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeOrgUnit6Value":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom1Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom1Code":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom2Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom2Code":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom3Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom3Code":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom4Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom4Code":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom5Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom5Code":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom6Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom6Code":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom7Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom7Code":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom8Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom8Code":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom9Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom9Code":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom10Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom10Code":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom11Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom11Code":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom12Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom12Code":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom13Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom13Code":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom14Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom14Code":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom15Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom15Code":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom16Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom16Code":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom17Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom17Code":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom18Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom18Code":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom19Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom19Code":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom20Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom20Code":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom21Code', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom21Code":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom1Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom1Value":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom2Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom2Value":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom3Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom3Value":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom4Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom4Value":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom5Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom5Value":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom6Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom6Value":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom7Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom7Value":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom8Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom8Value":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom9Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom9Value":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom10Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom10Value":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom11Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom11Value":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom12Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom12Value":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom13Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom13Value":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom14Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom14Value":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom15Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom15Value":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom16Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom16Value":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom17Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom17Value":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom18Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom18Value":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom19Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom19Value":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom20Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom20Value":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeCustom21Value', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCustom21Value":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeMI', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeMI":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('loginId', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."loginId":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeId', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeId":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeFirstName', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeFirstName":=JsonToken.AsValue().AsText();
        end;
        if EmployeeObject.Get('employeeLastName', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeLastName":=JsonToken.AsValue().AsText();
        end;
    end;
    local procedure InsertCashAdvance(CashAdvanceObject: JsonObject; JsonToken: JsonToken; var HeaderTable: Record "Concur Cash Advance")
    var
        DateTime_Var: DateTime;
        Date_Var: Date;
        HeaderTable2: Record "Concur Cash Advance";
    begin
        if CashAdvanceObject.Get('requestedDisbursementDate', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."requestedDisbursementDate":=JsonToken.AsValue().AsText();
        end;
        if CashAdvanceObject.Get('cardAccountID', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."cardAccountID":=JsonToken.AsValue().AsText();
        end;
        if CashAdvanceObject.Get('cardTransactionID', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."cardTransactionID":=JsonToken.AsValue().AsText();
        end;
        if CashAdvanceObject.Get('cardTransactionAmount', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."cardTransactionAmount":=JsonToken.AsValue().AsDecimal();
        end;
        if CashAdvanceObject.Get('cardTransactionCurrency', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."cardTransactionCurrency":=JsonToken.AsValue().AsText();
        end;
        if CashAdvanceObject.Get('cardTransactionPostedAmount', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."cardTransactionPostedAmount":=JsonToken.AsValue().AsDecimal();
        end;
        if CashAdvanceObject.Get('cardTransactionPostedCurrency', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."cardTransactionPostedCurrency":=JsonToken.AsValue().AsText();
        end;
        if CashAdvanceObject.Get('currencyNumCode', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."currencyNumCode":=JsonToken.AsValue().AsText();
        end;
        if CashAdvanceObject.Get('employeeCurrencyAlphaCode', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."employeeCurrencyAlphaCode":=JsonToken.AsValue().AsText();
        end;
        if CashAdvanceObject.Get('name', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."name":=JsonToken.AsValue().AsText();
        end;
        if CashAdvanceObject.Get('transactionType', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."transactionType":=JsonToken.AsValue().AsInteger();
        end;
        if CashAdvanceObject.Get('travelStartDate', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."travelStartDate":=JsonToken.AsValue().AsText();
        end;
        if CashAdvanceObject.Get('travelEndDate', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."travelEndDate":=JsonToken.AsValue().AsText();
        end;
        if CashAdvanceObject.Get('locationName', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."locationName":=JsonToken.AsValue().AsText();
        end;
        if CashAdvanceObject.Get('exchangeRate', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."exchangeRate":=JsonToken.AsValue().AsDecimal();
        end;
        if CashAdvanceObject.Get('clearingAccountCode', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."clearingAccountCode":=JsonToken.AsValue().AsText();
        end;
        if CashAdvanceObject.Get('purpose', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."purpose":=JsonToken.AsValue().AsText();
        end;
        if CashAdvanceObject.Get('countryCode', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."countryCode":=JsonToken.AsValue().AsText();
        end;
        if CashAdvanceObject.Get('issuedDate', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."issuedDate":=JsonToken.AsValue().AsText();
        end;
        if CashAdvanceObject.Get('cashAdvanceId', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."cashAdvanceId":=JsonToken.AsValue().AsText();
        end;
        if CashAdvanceObject.Get('expensePayIndicator', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."expensePayIndicator":=JsonToken.AsValue().AsText();
        end;
        if CashAdvanceObject.Get('paymentMethod', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."paymentMethod":=JsonToken.AsValue().AsInteger();
        end;
        if CashAdvanceObject.Get('requestAmount', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."requestAmount":=JsonToken.AsValue().AsDecimal();
        end;
        if CashAdvanceObject.Get('requestDate', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."requestDate":=JsonToken.AsValue().AsText();
        end;
        if CashAdvanceObject.Get('currencyAlphaCode', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."currencyAlphaCode":=JsonToken.AsValue().AsText();
        end;
        if CashAdvanceObject.Get('isTest', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."isTest":=JsonToken.AsValue().AsText();
        end;
        if CashAdvanceObject.Get('countrySubCode', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."countrySubCode":=JsonToken.AsValue().AsText();
        end;
        //#266 TEC.VJ 07APR2025>>
        IF HeaderTable.CurrencyAlphaCode = HeaderTable.EmployeeCurrencyAlphaCode then HeaderTable."CH/TVL":='CH'
        ELSE
            HeaderTable."CH/TVL":='TVL';
        IF HeaderTable.IssuedDate <> '' then begin
            Evaluate(DateTime_Var, HeaderTable.IssuedDate);
            Date_Var:=DT2Date(DateTime_Var);
            Evaluate(HeaderTable."Issued Year", Format(Date2DMY(Date_Var, 3)));
            Evaluate(HeaderTable."Issued Month", Format(Date_Var, 0, '<Month Text,3>'));
            HeaderTable2.Reset();
            HeaderTable2.SetCurrentKey(CompanyID, "CH/TVL"); //#345 VJ 02June2025
            HeaderTable2.SetRange(EmployeeOrgUnit3Code, HeaderTable.EmployeeOrgUnit3Code); //#345 VJ 02June2025
            HeaderTable2.SetRange("CH/TVL", HeaderTable."CH/TVL"); //#345 VJ 02June2025
            HeaderTable2.SetRange("Issued Year", HeaderTable."Issued Year");
            HeaderTable2.SetRange("Issued Month", HeaderTable."Issued Month");
            if HeaderTable2.Count() <> 0 then //HeaderTable."No. of Cash Advance for Month" := Format(HeaderTable2.Count())
                HeaderTable."No. of Cash Advance for Month":=Format(HeaderTable2.Count() + 1) //#343 TEC.VJ 27052025 to fix to include current line in count
            else
                HeaderTable."No. of Cash Advance for Month":=Format(1);
        end;
    //#266 TEC.VJ 07APR2025<<
    end;
    local procedure InsertJournalObject(var JournalObject: JsonObject; JsonToken: JsonToken; var HeaderTable: Record "Concur Cash Advance")
    begin
        if JournalObject.Get('payer', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."payer":=JsonToken.AsValue().AsText();
        end;
        if JournalObject.Get('paymentCode', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."paymentCode":=JsonToken.AsValue().AsCode();
        end;
        if JournalObject.Get('amount', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."amount":=JsonToken.AsValue().AsDecimal();
        end;
        if JournalObject.Get('payee', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."payee":=JsonToken.AsValue().AsText();
        end;
        if JournalObject.Get('accountCode', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."accountCode":=JsonToken.AsValue().AsCode();
        end;
        if JournalObject.Get('debitOrCredit', JsonToken)then begin
            if not JsonToken.AsValue().IsNull then HeaderTable."debitOrCredit":=JsonToken.AsValue().AsCode();
        end;
    end;
    procedure ReProcessInvoiceJson(jsonText: Text; p_LogEntryNo: Integer) // reprocess log response
    var
        ConcurExpStaging: Record "Concur Cash Advance";
    begin
        ConcurExpStaging.Reset();
        ConcurExpStaging.SetRange("API Log Entry No.", p_LogEntryNo);
        if ConcurExpStaging.FindFirst()then ConcurExpStaging.DeleteAll();
        LogEntryNo:=p_LogEntryNo;
        ProcessInvoiceJson(jsonText);
    end;
    // procedure UpdateInMastertable(var P_Detail: Record "Concur Cash Advance")
    // var
    //     //Sgarg- Added this Fxn
    //     InboundMaster: Record "Concur Inbound Master";
    //     APISetup: Record "Concur API Setup";
    //     DateTimeValue: DateTime;
    //     L_ShipSign: Text;
    //     InboundMaster2: Record "Concur Inbound Master";
    // begin
    //     APISetup.GET;
    //     L_ShipSign := '';
    //     IF (P_Detail.Shipsign <> '') AND (P_Detail.Shipsign <> 'Not Applicable') then
    //         L_ShipSign := APISetup."Company Code Prefix" + P_Detail.Shipsign;
    //     IF NOT InboundMaster.GET(P_Detail."Report ID", P_Detail."Report Key", L_ShipSign) then begin
    //         IF InboundMaster2.GET(P_Detail."Report ID", P_Detail."Report Key", '') then
    //             InboundMaster2.Rename(P_Detail."Report ID", P_Detail."Report Key", L_ShipSign)
    //         else begin
    //             InboundMaster2.reset;
    //             InboundMaster2.SetRange("Report ID", P_Detail."Report ID");
    //             InboundMaster2.SetRange("External Doc No.", P_Detail."Report Key");
    //             if InboundMaster2.FindFirst() then begin
    //                 IF L_ShipSign <> '' then
    //                     CreateConCurMaster(P_Detail, true)
    //             end else
    //                 CreateConCurMaster(P_Detail, false);
    //         End;
    //     END
    // end;
    // procedure CreateConCurMaster(var P_Detail: Record "Concur Cash Advance"; P_FinBlank: Boolean)
    // var
    //     //Sgarg-Created this Fxn
    //     InboundMaster: Record "Concur Inbound Master";
    //     APISetup: Record "Concur API Setup";
    //     DateTimeValue: DateTime;
    // begin
    //     APISetup.GET;
    //     InboundMaster.Init();
    //     InboundMaster."Report ID" := P_Detail."Report ID";
    //     InboundMaster."External Doc No." := P_Detail."Report Key";
    //     InboundMaster."Emp Id" := P_Detail."EMP ID";
    //     InboundMaster."Report Currency" := P_Detail."Report Currency";
    //     IF P_Detail."Journal Type" = 'CASH_LEDGER' then
    //         InboundMaster."Cash Ledger" := true;
    //     IF P_FinBlank then
    //         InboundMaster."Fin Company Code" := ''
    //     else
    //         InboundMaster."Fin Company Code" := APISetup."Company Code Prefix" + P_Detail."Employee Org Unit 3";
    //     IF (P_Detail.Shipsign <> '') AND (P_Detail.Shipsign <> 'Not Applicable') then
    //         InboundMaster."Ship Company Code" := APISetup."Company Code Prefix" + P_Detail.Shipsign;
    //     DateTimeValue := 0DT;
    //     evaluate(DateTimeValue, P_Detail."Report Payment Processing Date");
    //     InboundMaster."Payment Date" := DT2Date(DateTimeValue);
    //     InboundMaster."Create DateTime" := CurrentDateTime;
    //     InboundMaster.Status := InboundMaster.Status::Pending;
    //     InboundMaster.Insert(true);
    // end;
    var JsonBuffer: Record "JSON Buffer" temporary;
    JsonBufferValue: text;
    LogEntryNo: Integer;
    g_ConcurID: Text;
}
