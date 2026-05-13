codeunit 50167 "Concur Outbound Exch. Rate API"
{ //PS004
    trigger OnRun()
    begin
        //GetExpenseImageUrl(true);
        SendExchRate(0);
    end;
    procedure GenerateRefreshToken(): Text var
        TokenURL: Text[1024];
        ClientId: Text[1024];
        ClientSecret: Text[1024];
        Resource: Text[1024];
        //  RequestBody: Label 'grant_type=client_credentials&client_id=%1&client_secret=%2&scope=%3';
        RequestBody: Label 'client_id=d4b0bf5d-9021-4ff7-bc48-b6c0ce512d9c&client_secret=2280ce1d-85a5-4ac0-989c-2073c3c809f0&grant_type=refresh_token&refresh_token=i5jzxuuhpxm5yafvw8olksu58mq'; /////this is also used for token generation in postman body
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
    procedure SendExchRate(P_Type: Option Insert, Update): Text var
        TokenUrl: Text[1024];
        HttpClient: HttpClient;
        ResponseMessage: HttpResponseMessage;
        RequestHeader: HttpHeaders;
        JsonResponseTxt: Text;
        AccessTokenErr: Text;
        AccessToken: Text;
        NewAccessToken: Text;
        ResponseString: Text;
        APISetup: Record "Concur API Setup";
        XmlDoc: XmlDocument;
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        Instr: InStream;
        XmlStream: InStream;
        RequestMessage: HttpRequestMessage;
        Content: HttpContent;
    begin
        APISetup.GET;
        APISetup.TestField("Enable Outbound Integration", true);
        APISetup.TestField("Exchange Rate URL");
        AccessToken:=GenerateRefreshToken();
        IF AccessToken = '' then Error('No Access Token generated');
        HttpClient.DefaultRequestHeaders().Add('Authorization', AccessToken);
        Content.GetHeaders(RequestHeader);
        RequestHeader.Clear();
        HttpClient.SetBaseAddress(APISetup."Exchange Rate URL");
        RequestMessage.Method('POST');
        RequestHeader.Remove('Content-Type');
        RequestHeader.Add('Content-Type', 'application/Json');
        Clear(TempBlob);
        TempBlob.CreateOutStream(Outstr);
        Outstr.WriteText(PrepareBody(P_Type));
        TempBlob.CreateInStream(Instr);
        Content.WriteFrom(Instr);
        RequestMessage.Content(Content);
        HttpClient.Send(RequestMessage, ResponseMessage);
        IF ResponseMessage.IsSuccessStatusCode()THEN BEGIN
            // Message('Success');
            ResponseMessage.Content().ReadAs(JsonResponseTxt);
            ProcessJasonresponse(JsonResponseTxt);
        //if GuiAllowed then
        //    Message('%1', JsonResponseTxt);
        end
        else
        begin
            ResponseMessage.Content().ReadAs(JsonResponseTxt);
            ProcessJasonresponse(JsonResponseTxt);
        //if GuiAllowed then
        //    Message('JsonResponse Text%1', JsonResponseTxt);
        // message('Error %1', CopyStr(GetLastErrorText(), 1, 100));
        end;
    end;
    // procedure GetHeader()
    // var
    // begin
    //     ExpenseImageTab.Reset();
    //     ExpenseImageTab.DeleteAll();
    //     ExpenseImageTab.Init();
    //     ExpenseImageTab.Id := ResponseXMLHeader(2, '/Image/Id');
    //     ExpenseImageTab.url := ResponseXMLHeader(2, '/Image/Url');
    //     ExpenseImageTab.Insert();
    // end;
    ////////read Response
    procedure ResponseXMLHeader(Depth: integer; path1: text): text var
    begin
        XMLBuffer.Reset();
        XMLBuffer.SetRange(Depth, Depth);
        XMLBuffer.SetRange(path, path1);
        XMLBuffer.SetFilter(Value, '<>%1', '');
        if XMLBuffer.FindFirst()then begin
            XMLBufferValue:=XMLBuffer.Value;
            exit(XMLBufferValue);
        end;
    end;
    ///////insert Into staging
    // local procedure InsertDataIntoStagingTable()
    // var
    //     StagingTab: Record "Concur Inbound Image";
    // begin
    //     StagingTab.Reset();
    //     ExpenseImageTab.Reset();
    //     ExpenseImageTab.FindSet();
    //     StagingTab.Init();
    //     StagingTab."Image ID" := ExpenseImageTab.Id;
    //     StagingTab."Image URL " := ExpenseImageTab.Url;
    //     StagingTab.Insert();
    // end;
    procedure PrepareBody(P_Type: Option Insert, Update): Text var
        CurrExchRate: Record "Currency Exchange Rate";
        JArray: JsonArray;
        JArray2: JsonArray;
        GLObject: JsonObject;
        GLObject1: JsonObject;
        DefDimObject: JsonObject;
        JsonData: Text;
        ConcurOutbound: Record "Concur Outbound Log";
        GLSetup: record "General Ledger Setup";
        Currency: Record Currency;
        PrimaryKey2: Date;
    begin
        clear(JArray);
        Clear(GLObject1);
        TempOutboundLog.DeleteAll();
        ConcurOutbound.reset;
        ConcurOutbound.SetRange("Table No.", 330);
        ConcurOutbound.SetRange("Entry Type", P_Type);
        ConcurOutbound.SetFilter(Status, '<>%1', ConcurOutbound.Status::Success);
        IF ConcurOutbound.FindFirst()then begin
            clear(JArray2);
            repeat GLSetup.Get();
                Evaluate(PrimaryKey2, ConcurOutbound."Primary key 2");
                CurrExchRate.GET(ConcurOutbound."Primary key", PrimaryKey2);
                Currency.Get(CurrExchRate."Currency Code");
                clear(GLObject);
                GLObject.Add('from_crn_code', GLSetup."LCY Code");
                GLObject.Add('start_date', Format(CurrExchRate."Starting Date", 0, '<Year4>-<Month,2>-<Day,2>'));
                GLObject.Add('rate', CurrExchRate."Converted Rate");
                GLObject.Add('to_crn_code', CurrExchRate."Currency Code");
                JArray2.Add(GLObject);
                TempOutboundLog.Init();
                TempOutboundLog.TransferFields(ConcurOutbound);
                TempOutboundLog.Insert();
            until ConcurOutbound.Next() = 0;
            GLObject1.Add('currency_sets', JArray2);
        end;
        //JArray2.WriteTo(JsonData);
        GLObject1.WriteTo(JsonData);
        //Error('Request :%1', JsonData);
        Exit(JsonData);
    end;
    procedure ProcessJasonresponse(P_Jason: Text)
    var
        Jmgt: Codeunit "JSON Management";
        JsonBuffer: Record "JSON Buffer";
        JsonBuffer2: Record "JSON Buffer" temporary;
        PartNo: Text;
        DocNo: Text;
        JPage: Page "JSon Buffer List";
        i: Integer;
        TotalObjectNo: Integer;
        CurrencyCode: code[20];
        ErrorText: Text[1000];
        PKEntryNo: Integer;
        PKEntryNo2: Integer;
        ExchangeRateDate: Text;
        ExchangeDateTime: DateTime;
        ExchangeDate: Date;
        OverallStatusVal: Text[30];
        OverallStatusMsg: Text[100];
        // ExchangeRateDateTxt : 
        StatusMsg: Text[100];
        StatusCode: Code[10];
        StartDate: text[20];
        CurrCode: Code[10];
    begin
        //Message('Temp Count %1', TempOutboundLog.Count);
        JsonBuffer.DeleteAll();
        //Message('response...%1', P_Jason);
        JsonBuffer2.ReadFromText(P_Jason);
        //Page.Run(Page::"JSon Buffer List", JsonBuffer2);
        //Message('%1..Json Count', JsonBuffer2.Count);
        OverallStatusMsg:='';
        OverallStatusVal:='';
        JsonBuffer2.reset;
        JsonBuffer2.SetRange(Depth, 1);
        JsonBuffer2.SetRange("Token type", JsonBuffer2."Token type"::String);
        JsonBuffer2.SetRange(Path, 'overallStatus');
        if JsonBuffer2.FindFirst()then OverallStatusVal:=JsonBuffer2.Value;
        JsonBuffer2.reset;
        JsonBuffer2.SetRange(Depth, 1);
        JsonBuffer2.SetRange("Token type", JsonBuffer2."Token type"::String);
        JsonBuffer2.SetRange(Path, 'message');
        if JsonBuffer2.FindFirst()then OverallStatusmsg:=JsonBuffer2.Value;
        i:=0;
        g_APISetup.Get();
        JsonBuffer2.reset;
        JsonBuffer2.SetFilter("Token type", '<>%1', JsonBuffer2."Token type"::"Property Name");
        JsonBuffer2.SetRange(Depth, 3);
        if JsonBuffer2.Findset()then repeat if(JsonBuffer2."Token type" = JsonBuffer2."Token type"::String) and (JsonBuffer2.Path = 'currencySets[' + format(i) + '].statusMessage')then StatusMsg:=JsonBuffer2.Value;
                if(JsonBuffer2."Token type" = JsonBuffer2."Token type"::Integer) and (JsonBuffer2.Path = 'currencySets[' + format(i) + '].statusCode')then Statuscode:=JsonBuffer2.Value;
                if(JsonBuffer2."Token type" = JsonBuffer2."Token type"::String) and (JsonBuffer2.Path = 'currencySets[' + format(i) + '].start_date')then StartDate:=JsonBuffer2.Value;
                if(JsonBuffer2."Token type" = JsonBuffer2."Token type"::String) and (JsonBuffer2.Path = 'currencySets[' + format(i) + '].to_crn_code')then begin
                    CurrCode:=JsonBuffer2.Value;
                    ConcurOutboundLog.Reset();
                    ConcurOutboundLog.SetRange("Primary key", CurrCode);
                    ConcurOutboundLog.SetRange("Primary key 2", StartDate);
                    ConcurOutboundLog.SetRange(Status, ConcurOutboundLog.Status::Pending);
                    if ConcurOutboundLog.findfirst then begin
                        ConcurOutboundLog."Status Code":=StatusCode;
                        ConcurOutboundLog."Status Message":=StatusMsg;
                        ConcurOutboundLog."Overall Status":=OverallStatusVal;
                        ConcurOutboundLog.Message:=OverallStatusMsg;
                        if StatusMsg = 'success' then begin
                            ConcurOutboundLog.Status:=ConcurOutboundLog.Status::Success;
                            ConcurOutboundLog."Sent Date Time":=CurrentDateTime;
                        end
                        else
                            ConcurOutboundLog.Status:=ConcurOutboundLog.Status::Error;
                        ConcurOutboundLog.Path:=g_APISetup."Exchange Rate URL";
                        ConcurOutboundLog.Modify();
                        StartDate:='';
                        StatusCode:='';
                        StatusMsg:='';
                        CurrCode:='';
                        i+=1;
                    end;
                end;
            until JsonBuffer2.Next() = 0;
    end;
    var XMLBuffer: Record "XML Buffer" temporary;
    //ExpenseImageTab: Record "Concur Expense Image";
    XMLBufferValue: text;
    TempOutboundLog: Record "Concur Outbound Log" temporary;
    ConcurOutboundLog: Record "Concur Outbound Log";
    g_APISetup: Record "Concur API Setup";
}
