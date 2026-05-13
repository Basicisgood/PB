codeunit 50216 "Concur Post Cash Advance Ackn."
{
    local procedure AddHttpBasicAuthHeader(UserName: Text[50]; Password: Text[50]; var HttpClient: HttpClient);
    var
        AuthString: Text;
        Base64Helpers: Codeunit "Base64 Convert";
    begin
        AuthString:=STRSUBSTNO('%1:%2', UserName, Password);
        AuthString:=Base64Helpers.ToBase64(AuthString);
        AuthString:=STRSUBSTNO('Basic %1', AuthString);
        HttpClient.DefaultRequestHeaders().Add('Authorization', AuthString);
    end;
    procedure GetAcknowledgement(p_ids: Text; LogEntryNo: Integer): Text var
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
        RequestMessage: HttpRequestMessage;
        RequestHeaders: HttpHeaders;
        HttpContent: HttpContent;
        ContentHeaders: HttpHeaders;
        url: Text;
        ConcurCashAdvance: Codeunit "Concur Cash Advance";
        AcknowledgeResult: Text;
        ErrorMessage: Text;
        ConcurAPIInboundLog: Record "Concur API Inbound";
    begin
        if p_ids = '' then exit;
        APISetup.GET;
        APISetup.TestField("Is Enable Cash Advance", true);
        APISetup.TestField("Post Cash Advance Ack. URL");
        Clear(ConcurCashAdvance);
        AccessToken:=ConcurCashAdvance.GenerateRefreshToken();
        IF AccessToken = '' then Error('No Access Token generated');
        url:=APISetup."Post Cash Advance Ack. URL";
        RequestMessage.SetRequestUri(Url);
        RequestMessage.Method('POST');
        RequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Add('Authorization', AccessToken);
        HttpContent.WriteFrom(GeneratePostPayload(p_ids));
        HttpContent.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/json');
        HttpContent.GetHeaders(ContentHeaders);
        RequestMessage.Content(HttpContent);
        if HttpClient.Send(RequestMessage, ResponseMessage)then begin
            ResponseMessage.Content.ReadAs(JsonResponseTxt);
            // Message('%1', JsonResponseTxt);
            if ResponseMessage.IsSuccessStatusCode then begin
                JsonBuffer.ReadFromText(JsonResponseTxt);
                // Directly get AcknowledgeResult and ErrorMessage using ResponseJsonHeader
                AcknowledgeResult:=ResponseJsonHeader(2, '[0].acknowledgeResult');
                ErrorMessage:=ResponseJsonHeader(2, '[0].errorMessage');
                ConcurAPIInboundLog.Updateexpnseack(AcknowledgeResult, ErrorMessage, JsonResponseTxt, p_ids, LogEntryNo);
            // Return both as a concatenated string or in a desired format
            //exit('AcknowledgeResult: ' + AcknowledgeResult + ', ErrorMessage: ' + ErrorMessage);
            //Page.Run(Page::"JSON Buffer CustomPage", JsonBuffer);
            end
            else
                Message('Request failed!: %1', JsonResponseTxt);
        end;
    end;
    local procedure GeneratePostPayload(Ids: Text): Text var
        JsonPayload: JsonObject;
        JsonArray: JsonArray;
        Payload: Text;
        IdList: List of[Text];
        Id: Text;
    begin
        //Ids := '458f1ddbddf54404842391d03f02cbbe,3d499302c4c942958f9cbab6187cabfc,9d45abf8b8954c79b9dd878a31554b3d,bfc94f38a7b141f99297c2830c9c5eb6,568a898bb05442e19cde74a8b13dd808,5003b32a0bbb4f8e87f115c76e55c7db,c804e8139a334de2a1cd32b2d9ddfcde,5e7a94d680214e0ba6077ee6255706b0';
        IdList:=Ids.Split(','); ////Split the string based on comma separated
        foreach Id in IdList do 
            ///using foreach loop
            JsonArray.Add(Id);
        JsonPayload.Add('ids', JsonArray);
        JsonPayload.WriteTo(Payload);
        exit(Payload);
    end;
    local procedure ResponseJsonHeader(Depth: integer; path1: text): text var
        JsonBufferValue: Text;
    begin
        JSONBuffer.Reset();
        JSONBuffer.SetRange(Depth, Depth);
        JSONBuffer.SetRange(Path, path1);
        JsonBuffer.SetFilter("Token type", '<>%1&<>%2', JsonBuffer."Token type"::"Property Name", JsonBuffer."Token type"::Null);
        if JSONBuffer.FindFirst()then begin
            JsonBufferValue:=JsonBuffer.Value;
            exit(JsonBufferValue);
        end;
        exit('');
    end;
    var JsonBuffer: Record "JSON Buffer" temporary;
    JsonBufferValue: text;
}
