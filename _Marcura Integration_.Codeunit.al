codeunit 50220 "Marcura Integration"
{
    trigger OnRun()
    var
        CUAPITokenReqquest: Codeunit "API Token Request";
        MarcuraSetup: Record "Marcura Setup";
        AccessToken: Text;
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
        APISetup: Record "Marcura Setup";
    begin
        APISetup.GET;
        APISetup.TestField("User Id");
        APISetup.TestField(Password);
        APISetup.TestField("Token URL");
        APISetup.TestField("Payment API URL");
        AccessToken:=GenerateRefreshToken();
        IF AccessToken = '' then Error('No Access Token generated');
        HttpClient.DefaultRequestHeaders().Add('Authorization', AccessToken);
        HttpClient.Timeout(120000);
        HttpClient.Get(APISetup."Payment API URL", ResponseMessage);
        IF ResponseMessage.IsSuccessStatusCode()THEN BEGIN
            ResponseMessage.Content().ReadAs(JsonResponseTxt);
            JsonBuffer.ReadFromText(JsonResponseTxt); // JSON Buffer
            //ProcessInvoiceJson(JsonResponseTxt);//insert data in staging tab
            ImportFromJson(JsonResponseTxt);
            if GuiAllowed then Message('Response inserted successfully.');
        //Page.Run(Page::"JSON Buffer CustomPage", JsonBuffer);
        //ProcessJasonresponse(JsonResponseTxt);
        end
        else
        begin
            ResponseMessage.Content().ReadAs(JsonResponseTxt);
            if GuiAllowed then Error('JsonResponse Text%1', JsonResponseTxt);
        end;
    end;
    procedure ImportFromJson(JsonText: Text)
    var
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        MarcuraPayStaging: Record "Marcura Payment Staging";
        DebitDetails, DebitAccount, PaymentType, VendorBank: JsonObject;
        JsonToken: JsonToken;
    begin
        JsonArray.ReadFrom(JsonText);
        if JsonArray.Count() = 0 then exit;
        //f guiallowed then Error('No data found in the JSON array.');
        begin
            foreach JsonToken in JsonArray do begin
                JsonObject:=JsonToken.AsObject();
                MarcuraPayStaging.Init();
                MarcuraPayStaging."Entry No.":=0;
                if JsonObject.Get('daId', JsonToken)then if JsonToken.AsValue().AsInteger() <> 0 then MarcuraPayStaging."daId":=JsonToken.AsValue().AsInteger();
                if JsonObject.Get('pplTransactionId', JsonToken)then MarcuraPayStaging."Transaction Id":=JsonToken.AsValue().AsInteger();
                if JsonObject.Get('referenceNumber', JsonToken)then MarcuraPayStaging."Reference No.":=JsonToken.AsValue().AsText();
                if JsonObject.Get('interfaceUniqueReference', JsonToken)then MarcuraPayStaging."Interface Unique Reference No":=JsonToken.AsValue().AsText();
                if JsonObject.Get('imosReferenceNumber', JsonToken)then MarcuraPayStaging."IMOS Reference No.":=JsonToken.AsValue().AsText();
                if JsonObject.Get('transactionId', JsonToken)then MarcuraPayStaging."IMOS Transaction ID":=JsonToken.AsValue().AsText();
                if JsonObject.Get('counterPartyRef', JsonToken)then MarcuraPayStaging."Counter Party Reference No.":=JsonToken.AsValue().AsText();
                if JsonObject.Get('paymentCurrency', JsonToken)then MarcuraPayStaging."Payment Currency":=JsonToken.AsValue().AsText();
                if JsonObject.Get('paymentAmount', JsonToken)then MarcuraPayStaging."Payment Amount":=JsonToken.AsValue().AsDecimal();
                if JsonObject.Get('debitDetails', JsonToken)then begin
                    DebitDetails:=JsonToken.AsObject();
                    if DebitDetails.Get('debitedCurrency', JsonToken)then MarcuraPayStaging."Debit Currency":=JsonToken.AsValue().AsText();
                    if DebitDetails.Get('debitedAmount', JsonToken)then MarcuraPayStaging."Debit Amount":=JsonToken.AsValue().AsDecimal();
                    if DebitDetails.Get('debitAccount', JsonToken)then begin
                        DebitAccount:=JsonToken.AsObject();
                        if DebitAccount.Get('name', JsonToken)then MarcuraPayStaging."Debit Account Name":=JsonToken.AsValue().AsText();
                        if DebitAccount.Get('familiarName', JsonToken)then MarcuraPayStaging."Debit Account Familiar Name":=JsonToken.AsValue().AsText();
                        if DebitAccount.Get('iban', JsonToken)then MarcuraPayStaging."Debit Account IBAN":=JsonToken.asvalue.AsText();
                        if DebitAccount.Get('accountNumber', JsonToken)then MarcuraPayStaging."Debit Account No.":=JsonToken.AsValue().AsText();
                    end;
                end;
                if JsonObject.Get('vendorBankDetails', JsonToken)then begin
                    VendorBank:=JsonToken.AsObject();
                    if VendorBank.Get('vendorBankCountryCode', JsonToken)then MarcuraPayStaging."Vendor Bank Country Code":=JsonToken.asvalue.AsText();
                end;
                if JsonObject.Get('bankStatementDate', JsonToken)then MarcuraPayStaging."Bank Statement Date":=JsonToken.asvalue.AsDatetime();
                if JsonObject.Get('paymentExecutedDate', JsonToken)then MarcuraPayStaging."Payment Execution Date":=JsonToken.asvalue.AsDatetime();
                if JsonObject.Get('valueDate', JsonToken)then MarcuraPayStaging."Value Date":=JsonToken.asvalue.AsDatetime();
                if JsonObject.Get('bankExchangeRate', JsonToken)then MarcuraPayStaging."Bank Exchange Rate":=JsonToken.asvalue.AsDecimal();
                if JsonObject.Get('bankReference', JsonToken)then MarcuraPayStaging."Bank Reference":=JsonToken.asvalue.AsText();
                if JsonObject.Get('paymentType', JsonToken)then begin
                    PaymentType:=JsonToken.AsObject();
                    if PaymentType.Get('id', JsonToken)then MarcuraPayStaging."Payment Type ID":=JsonToken.asValue.AsInteger();
                    if PaymentType.Get('description', JsonToken)then MarcuraPayStaging."Payment Type Description":=JsonToken.asvalue.AsText();
                end;
                MarcuraPayStaging.Insert();
            //        Message('Record inserted: %1', MarcuraPayStaging."daId");
            end;
        end;
    end;
    procedure GenerateRefreshToken(): Text var
        TokenURL: Text[1024];
        ClientId: Text[1024];
        ClientSecret: Text[1024];
        Resource: Text[1024];
        //  RequestBody: Label 'grant_type=client_credentials&client_id=%1&client_secret=%2&scope=%3';
        //RequestBody: Label 'client_id=d4b0bf5d-9021-4ff7-bc48-b6c0ce512d9c&client_secret=2280ce1d-85a5-4ac0-989c-2073c3c809f0&grant_type=refresh_token&refresh_token=i5jzxuuhpxm5yafvw8olksu58mq';
        //       RequestBody: Label '{"username": "pac-dad-bc-api", "password": "PacBC@pi@2025"}';
        RequestBody: Label '{"clientId": "Jk45lACQf6pLuOU5zuxGID3XLy4ZgVql", "clientSecret": "BeO6M1_arX7Ip2zz6K1j5gHnANEMiIOITJB199jmiAmp5YMHGl5j8uy0X0NhAVTU"}';
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
        APISetup: Record "Marcura Setup";
    begin
        APISetup.Get();
        // APISetup.TestField("Is Enable", true);
        APISetup.TestField("Token URL");
        // APISetup.TestField("User Id");
        // APISetup.TestField(Password);
        AccessTokenErr:='';
        AccessToken:='';
        TokenURL:=APISetup."Token URL";
        RequestHeader:=HttpClient.DefaultRequestHeaders;
        RequestHeader.Add('User-Agent', 'Dynamics 365');
        //AddHttpBasicAuthHeader(APISetup."User ID", APISetup.Password, HttpClient);
        Content.GetHeaders(RequestHeader);
        RequestHeader.Clear();
        HttpClient.SetBaseAddress(TokenURL);
        RequestMessage.Method('POST');
        RequestHeader.Remove('Content-Type');
        //RequestHeader.Add('Content-Type', 'application/x-www-form-urlencoded');
        RequestHeader.Add('Content-Type', 'application/json');
        Clear(TempBlob);
        TempBlob.CreateOutStream(Outstr);
        //Outstr.WriteText(StrSubstNo(RequestBody));
        Outstr.WriteText(RequestBody);
        //Outstr.WriteText(StrSubstNo('{"username": "' + APISetup."User Id" + ' ", "' + 'password" :' + APISetup.Password + '"}'));
        TempBlob.CreateInStream(Instr);
        Content.WriteFrom(Instr);
        RequestMessage.Content(Content);
        HttpClient.Send(RequestMessage, ResponseMessage);
        IF ResponseMessage.IsSuccessStatusCode()THEN BEGIN
            ResponseMessage.Content().ReadAs(APIResult);
            ResponseJsonObject.ReadFrom(APIResult);
            ResponseJsonObject.GET('token', ResponseJsonToken);
            AccessToken:='Bearer ' + ResponseJsonToken.AsValue().AsText();
        END
        ELSE
        begin
            AccessTokenErr:=CopyStr(GetLastErrorText(), 1, 100);
            Error('Token not generated');
        end;
        APISetup.SetAccessToken(AccessToken);
        APISetup.Modify();
        exit(AccessToken);
    end;
    var JsonBuffer: Record "JSON Buffer" temporary;
//JsonBufferValue: text;
//ConcurAPIResponse: Record "Concur API Response";
//ConcurAPIResponse2: Record "Concur API Response";
//LogEntryNo: Integer;
//g_ConcurID: Text;
}
