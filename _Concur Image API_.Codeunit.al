codeunit 50191 "Concur Image API"
{
    trigger OnRun()
    begin
    end;
    procedure GetExpenseImageUrl(ImageID: code[50])
    var
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
        ConcurAPI: Codeunit "Concur Expense_Image";
    begin
        APISetup.GET;
        APISetup.TestField("Is Enable", true);
        APISetup.TestField("Concur Inbound Image URL");
        AccessToken:=ConcurAPI.GenerateRefreshToken();
        IF AccessToken = '' then Error('No Access Token generated');
        HttpClient.DefaultRequestHeaders().Add('Authorization', AccessToken);
        HttpClient.Get(APISetup."Concur Inbound Image URL" + ImageID, ResponseMessage);
        If not ResponseMessage.IsSuccessStatusCode()then Error(StrSubstNo('Status code: %1\' + 'Description: %2', ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase()));
        ResponseMessage.Content.ReadAs(ResponseString);
        ResponseString:=ConcurAPI.GetImageURL(ResponseString);
        ResponseString:=ResponseString.Replace('amp;', '');
        Hyperlink(ResponseString);
    end;
}
