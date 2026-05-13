codeunit 50157 "Concur Expense_Image"
{
    trigger OnRun()
    begin
        GetExpenseImageUrl(true);
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
    procedure GetExpenseImageUrl(Process: Boolean): Text var
        TokenUrl: Text[1024];
        HttpClient: HttpClient;
        ResponseMessage: HttpResponseMessage;
        RequestHeader: HttpHeaders;
        AccessTokenErr: Text;
        AccessToken: Text;
        NewAccessToken: Text;
        ResponseString: Text;
        APISetup: Record "Concur API Setup";
        XmlDoc: XmlDocument;
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        XmlStream: InStream;
    begin
        APISetup.GET;
        APISetup.TestField("Is Enable", true);
        APISetup.TestField("Concur Inbound Image URL");
        AccessToken:=GenerateRefreshToken();
        IF AccessToken = '' then Error('No Access Token generated');
        HttpClient.DefaultRequestHeaders().Add('Authorization', AccessToken);
        HttpClient.Get(APISetup."Concur Inbound Image URL", ResponseMessage);
        If not ResponseMessage.IsSuccessStatusCode()then Exit(StrSubstNo('Status code: %1\' + 'Description: %2', ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase()));
        ResponseMessage.Content.ReadAs(ResponseString);
        XmlDocument.ReadFrom(ResponseString, XmlDoc);
        TempBlob.CreateOutStream(OutStr);
        XmlDoc.WriteTo(OutStr);
        TempBlob.CreateInStream(XmlStream);
        if Process then begin
            XMLBuffer.LoadFromStream(XmlStream);
            //InsertAPILog;
            InsertDataIntoStagingTable(ResponseString);
            LogEntryNo:=ConcurAPIInboundLog.InsertLog(3, ResponseString); //VJ 29NOV2024
            if GuiAllowed then Message('Response inserted successfully.');
        end
        else
            Message('Response : %1', XMLBuffer.GetValue());
    //Page.Run(Page::"XML Buffer Page", XMLBuffer);
    end;
    // procedure InsertAPILog()
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
    local procedure InsertDataIntoStagingTable(p_ResponseString: Text)
    var
        StagingTab: Record "Concur Inbound Image";
    begin
        StagingTab.Reset();
        StagingTab.Init();
        //StagingTab."Image ID" := ExpenseImageTab.Id;
        //StagingTab."Image URL " := ExpenseImageTab.Url;
        StagingTab."Image ID":=GetImageID(p_ResponseString);
        StagingTab."Image URL ":=Removeamp(GetImageURL(p_ResponseString));
        StagingTab."API Log Entry No.":=LogEntryNo;
        StagingTab.Insert();
    end;
    procedure GetImageID(p_ResponseString: Text): Text var
        textvar2: Text;
        Firstpos: Integer;
        seondpos: Integer;
    BEGIN
        Firstpos:=STRPOS(p_ResponseString, '<Id>') + 4;
        seondpos:=STRPOS(p_ResponseString, '</Id>') - Firstpos;
        textvar2:=COPYSTR(p_ResponseString, Firstpos, seondpos);
        exit(textvar2);
    END;
    procedure GetImageURL(p_ResponseString: Text): Text var
        textvar2: Text;
        Firstpos: Integer;
        seondpos: Integer;
    BEGIN
        Firstpos:=STRPOS(p_ResponseString, '<Url>') + 5;
        seondpos:=STRPOS(p_ResponseString, '</Url>') - Firstpos;
        textvar2:=COPYSTR(p_ResponseString, Firstpos, seondpos);
        exit(textvar2);
    END;
    procedure Removeamp(p_ResponseString: Text): Text var
        textvar2: Text;
        Firstpos: Integer;
        seondpos: Integer;
    BEGIN
        Firstpos:=STRPOS(p_ResponseString, '&amp;') + 1;
        textvar2:=DelStr(p_ResponseString, Firstpos, 4);
        seondpos:=STRPOS(textvar2, '&amp;') + 1;
        textvar2:=DelStr(textvar2, seondpos, 4);
        exit(textvar2);
    END;
    var XMLBuffer: Record "XML Buffer" temporary;
    XMLBufferValue: text;
    ConcurAPIInboundLog: Record "Concur API Inbound";
    LogEntryNo: Integer;
}
