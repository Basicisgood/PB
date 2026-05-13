codeunit 50199 "Concur Get Identity"
{ //PS009
    trigger OnRun()
    begin
    //GetIdentity(true);
    end;
    procedure GenerateRefreshToken(): Text var
        TokenURL: Text[1024];
        ClientId: Text[1024];
        ClientSecret: Text[1024];
        Resource: Text[1024];
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
        //APISetup.SetAccessToken(AccessToken);
        //APISetup.Modify();
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
    procedure GetIdentity(Process: Boolean; var InboundFinExp: Record "Concur inbound financial Expen"): Text var
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
        JsonBuffer2: Record "JSON Buffer" temporary;
    begin
        APISetup.GET;
        APISetup.TestField("Is Enable", true);
        APISetup.TestField("Get Identity URL");
        AccessToken:=GenerateRefreshToken();
        IF AccessToken = '' then Error('No Access Token generated');
        HttpClient.DefaultRequestHeaders().Add('Authorization', AccessToken);
        HttpClient.Get(APISetup."Get Identity URL" + '?filter=employeeNumber eq "' + InboundFinExp."EMP ID" + '"', ResponseMessage);
        IF ResponseMessage.IsSuccessStatusCode()THEN BEGIN
            ResponseMessage.Content().ReadAs(JsonResponseTxt);
            //JsonBuffer2.ReadFromText(JsonResponseTxt);
            //Page.Run(Page::"JSon Buffer List", JsonBuffer2);
            if Process then begin
                JsonBuffer.ReadFromText(JsonResponseTxt);
                //InsertAPILog;
                LogEntryNo:=ConcurAPIInboundLog.InsertLog(6, JsonResponseTxt);
                InboundFinExp.UUID:=ResponseJsonHeader(3, 'Resources[0].id');
                InboundFinExp.Modify();
            //InsertDataIntoStagingtable;
            //if GuiAllowed then
            //    Message('Response inserted successfully.');
            end
            else if GuiAllowed then Message('JsonResponse : %1', JsonResponseTxt);
        //JsonBuffer.Reset();            
        // Page.Run(Page::"JSON Buffer CustomPage", JsonBuffer);
        end
        else
        begin
            ResponseMessage.Content().ReadAs(JsonResponseTxt);
        end;
    end;
    procedure GetConcurID(Process: Boolean; var EmployeeRec: Record Employee): Text var
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
        JsonBuffer2: Record "JSON Buffer";
    begin
        APISetup.GET;
        APISetup.TestField("Is Enable", true);
        APISetup.TestField("Get Identity URL");
        AccessToken:=GenerateRefreshToken();
        IF AccessToken = '' then Error('No Access Token generated');
        HttpClient.DefaultRequestHeaders().Add('Authorization', AccessToken);
        HttpClient.Get(APISetup."Get Identity URL" + '?filter=employeeNumber eq "' + employeerec."No." + '"', ResponseMessage);
        IF ResponseMessage.IsSuccessStatusCode()THEN BEGIN
            ResponseMessage.Content().ReadAs(JsonResponseTxt);
            //JsonBuffer2.ReadFromText(JsonResponseTxt);
            //Page.Run(Page::"JSon Buffer List", JsonBuffer2);            
            if Process then begin
                JsonBuffer.DeleteAll();
                Clear(JsonBuffer);
                JsonBuffer.ReadFromText(JsonResponseTxt);
                //InsertAPILog;
                //LogEntryNo := ConcurAPIInboundLog.InsertLog(6, JsonResponseTxt);
                EmployeeRec."Concur ID":=ResponseJsonHeader(3, 'Resources[0].id');
                EmployeeRec.Modify();
            //InsertDataIntoStagingtable;
            //if GuiAllowed then
            //    Message('Response inserted successfully.');
            end
            else if GuiAllowed then Message('JsonResponse : %1', JsonResponseTxt);
        //JsonBuffer.Reset();            
        // Page.Run(Page::"JSON Buffer CustomPage", JsonBuffer);
        end
        else
        begin
            ResponseMessage.Content().ReadAs(JsonResponseTxt);
        end;
    end;
    procedure InsertAPILog()
    var
        TotalCount, i, EntryyNo: Integer;
    begin
        ExpenseAttendeAPILog.Reset();
        ExpenseAttendeAPILog.DeleteAll();
        ExpenseAttendeAPILog.Init();
        ExpenseAttendeAPILog.attendeeId:=ResponseJsonHeader(3, 'expenseAttendeeList[0].attendeeId');
        ExpenseAttendeAPILog.customData:=ResponseJsonHeader(3, 'expenseAttendeeList[0].customData');
        ExpenseAttendeAPILog.isAmountUserEdited:=ResponseJsonHeader(3, 'expenseAttendeeList[0].isAmountUserEdited');
        ExpenseAttendeAPILog.isTraveling:=ResponseJsonHeader(3, 'expenseAttendeeList[0].isTraveling');
        ExpenseAttendeAPILog.associatedAttendeeCount:=ResponseJsonHeader(3, 'expenseAttendeeList[0].associatedAttendeeCount');
        ExpenseAttendeAPILog.versionNumber:=ResponseJsonHeader(3, 'expenseAttendeeList[0].versionNumber');
        ExpenseAttendeAPILog."transactionAmount value":=ResponseJsonHeader(4, 'expenseAttendeeList[0].transactionAmount.value');
        ExpenseAttendeAPILog."transactionAmount currencyCode":=ResponseJsonHeader(4, 'expenseAttendeeList[0].transactionAmount.currencyCode');
        ExpenseAttendeAPILog."approvedAmount value":=ResponseJsonHeader(4, 'expenseAttendeeList[0].approvedAmount.value');
        ExpenseAttendeAPILog."approvedAmount currencyCode":=ResponseJsonHeader(4, 'expenseAttendeeList[0].approvedAmount.currencyCode');
        ExpenseAttendeAPILog.Insert();
    end;
    procedure InsertDataIntoStagingtable()
    var
        StagingTab: Record "Concur inbound Attende Staging";
    begin
        StagingTab.Reset();
        ExpenseAttendeAPILog.Reset();
        ExpenseAttendeAPILog.FindSet();
        StagingTab.Init();
        if ExpenseAttendeAPILog."transactionAmount value" <> '' then Evaluate(StagingTab."Transaction Amount", ExpenseAttendeAPILog."transactionAmount value");
        if ExpenseAttendeAPILog."approvedAmount value" <> '' then Evaluate(StagingTab."Approved Amount", ExpenseAttendeAPILog."approvedAmount value");
        StagingTab.AttendeeID:=ExpenseAttendeAPILog.attendeeId;
        StagingTab.Custom1:=ExpenseAttendeAPILog.customData;
        StagingTab.Custom2:=ExpenseAttendeAPILog.isAmountUserEdited;
        StagingTab.Custom3:=ExpenseAttendeAPILog.isTraveling;
        StagingTab.AssociatedAttendeeCount:=ExpenseAttendeAPILog.associatedAttendeeCount;
        StagingTab.Custom4:=ExpenseAttendeAPILog.versionNumber;
        StagingTab.EntryID:=ExpenseAttendeAPILog.attendeeId;
        StagingTab.ID:=ExpenseAttendeAPILog.attendeeId;
        StagingTab."API Log Entry No.":=LogEntryNo;
        StagingTab.Insert();
    end;
    ////////read Response
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
    var JsonBuffer: Record "JSON Buffer" temporary;
    ExpenseAttendeAPILog: Record "Expense Attendee API Log";
    JsonBufferValue: text;
    LogEntryNo: Integer;
}
