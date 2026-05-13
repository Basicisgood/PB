codeunit 50150 "API Token Request"
{
    trigger OnRun()
    begin
    end;
    [EventSubscriber(ObjectType::Table, Database::"JSON Buffer", 'OnAfterInsertEvent', '', true, true)]
    local procedure OnInsertJsonBuffer(var Rec: Record "JSON Buffer")
    var
        DotPos: Integer;
        Val: Text;
    begin
        IF StrPos(rec.Path, 'Errors') > 0 then rec.Error:=true;
        DotPos:=StrPos(rec.Path, '.');
        IF DotPos > 0 then val:=COPYSTR(rec.Path, 1, DotPos - 1)
        else
            Val:=rec.Path;
        IF val <> '' then begin
            if Evaluate(rec."Object Number", DELCHR(val, '=', '[]'))then;
            rec."Object Number"+=1;
        end;
        rec.Modify();
    end;
    procedure GenerateRefreshToken(): Text var
        TokenURL: Text[1024];
        ClientId: Text[1024];
        ClientSecret: Text[1024];
        Resource: Text[1024];
        //  RequestBody: Label 'grant_type=client_credentials&client_id=%1&client_secret=%2&scope=%3';
        RequestBody: Label 'grant_type=client_credentials&scope=%1';
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
    begin
        APISetup.Get();
        APISetup.TestField("Is Enable", true);
        APISetup.TestField("Token URL");
        APISetup.TestField("User Id");
        APISetup.TestField(Password);
        AccessTokenErr:='';
        AccessToken:='';
        //ClientId := SalesSetup."Client ID";
        //ClientSecret := SalesSetup."Client Secret";
        //Resource := SalesSetup."Resource Url";
        TokenURL:=APISetup."Token URL";
        RequestHeader:=HttpClient.DefaultRequestHeaders;
        RequestHeader.Add('User-Agent', 'Dynamics 365');
        AddHttpBasicAuthHeader(APISetup."User Id", APISetup.Password, HttpClient);
        // RequestHeader.Add('Authentication', 'Basic ' + APISetup."User Id" + ':' + APISetup.Password);
        //RequestHeader.Add('Username', APISetup."User Id");
        //RequestHeader.Add('Password', APISetup.Password);
        Content.GetHeaders(RequestHeader);
        RequestHeader.Clear();
        HttpClient.SetBaseAddress(TokenURL);
        RequestMessage.Method('POST');
        RequestHeader.Remove('Content-Type');
        RequestHeader.Add('Content-Type', 'application/x-www-form-urlencoded');
        Clear(TempBlob);
        TempBlob.CreateOutStream(Outstr);
        Outstr.WriteText(StrSubstNo(RequestBody, 'GenericInterfaceScope'));
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
    procedure GenerateMarcuraToken(): Text var
        TokenURL: Text[1024];
        ClientId: Text[1024];
        ClientSecret: Text[1024];
        Resource: Text[1024];
        //  RequestBody: Label 'grant_type=client_credentials&client_id=%1&client_secret=%2&scope=%3';
        RequestBody: Label 'grant_type=client_credentials&scope=%1';
        //RequestBody: Label '{"username": "pac-dad-bc-api","password": "PacBC@pi@2025"}';
        //RequestBody: Label 'grant_type=client_credentials&username=%1&password=%2';
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
        MarcuraSetup: Record "Marcura Setup";
    begin
        MarcuraSetup.Get();
        MarcuraSetup.TestField("Token URL");
        MarcuraSetup.TestField("User Id");
        MarcuraSetup.TestField(Password);
        AccessTokenErr:='';
        AccessToken:='';
        TokenURL:=MarcuraSetup."Token URL";
        RequestHeader:=HttpClient.DefaultRequestHeaders;
        RequestHeader.Add('User-Agent', 'Dynamics 365');
        AddHttpBasicAuthHeader(MarcuraSetup."User Id", MarcuraSetup.Password, HttpClient);
        // RequestHeader.Add('Authentication', 'Basic ' + APISetup."User Id" + ':' + APISetup.Password);
        RequestHeader.Add('Username', MarcuraSetup."User Id");
        RequestHeader.Add('Password', MarcuraSetup.Password);
        Content.GetHeaders(RequestHeader);
        RequestHeader.Clear();
        HttpClient.SetBaseAddress(TokenURL);
        RequestMessage.Method('POST');
        RequestHeader.Remove('Content-Type');
        //RequestHeader.Add('Content-Type', 'application/x-www-form-urlencoded');
        RequestHeader.Add('Content-Type', 'raw');
        Clear(TempBlob);
        TempBlob.CreateOutStream(Outstr);
        Outstr.WriteText(StrSubstNo(RequestBody, 'GenericInterfaceScope'));
        //Outstr.WriteText(StrSubstNo(RequestBody, MarcuraSetup."User Id", MarcuraSetup.Password));
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
        MarcuraSetup.SetAccessToken(AccessToken);
        MarcuraSetup.Modify();
        exit(AccessToken);
    end;
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
    APISetup: Record "DNV Integration Setup";
    ShowMess: Boolean;
}
