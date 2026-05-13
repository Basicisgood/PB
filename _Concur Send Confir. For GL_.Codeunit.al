codeunit 50218 "Concur Send Confir. For GL"
{
    Permissions = tabledata "G/L Entry"=rm;

    trigger OnRun()
    var
        GenLedgerEntry: Record "G/L Entry";
    begin
        Clear(GenLedgerEntry);
        GetPostingConfirmation(GenLedgerEntry);
    end;
    procedure GetPostingConfirmation(GLEntry_Var: Record "G/L Entry"): Text var
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
        AcknowledgeResult: Text;
        ErrorMessage: Text;
        ConcurFinancialTransaction: Codeunit "Concur Financial Transaction";
        ConcurAPIInboundLog: Record 50189;
        LogEntryNo: Integer;
        JsonRequest: Text;
    begin
        APISetup.GET;
        APISetup.TestField("Is Enable", true);
        APISetup.TestField("Financial Trans Confirm URL");
        Clear(ConcurFinancialTransaction);
        AccessToken:=ConcurFinancialTransaction.GenerateRefreshToken();
        IF AccessToken = '' then Error('No Access Token generated');
        url:=APISetup."Financial Trans Confirm URL";
        RequestMessage.SetRequestUri(Url);
        RequestMessage.Method('POST');
        RequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Add('Authorization', AccessToken);
        // Pass the received JSON data to GeneratePostPayload
        JsonRequest:=GeneratePostingConfirmation2(GLEntry_Var);
        HttpContent.WriteFrom(JsonRequest);
        HttpContent.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/json');
        HttpContent.GetHeaders(ContentHeaders);
        RequestMessage.Content(HttpContent);
        // Message(JsonRequest);
        if HttpClient.Send(RequestMessage, ResponseMessage)then begin
            ResponseMessage.Content.ReadAs(JsonResponseTxt);
            if ResponseMessage.IsSuccessStatusCode then begin
                JsonBuffer.ReadFromText(JsonResponseTxt);
                LogEntryNo:=ConcurAPIInboundLog.InsertLog(4, JsonRequest, JsonResponseTxt);
                //Page.Run(Page::"JSON Buffer CustomPage", JsonBuffer);
                // UpdateGLEntry();
                UpdateGLEntry(LogEntryNo); //TEC.VJ 16JULY2025
            end
            else
            begin
                ResponseMessage.Content().ReadAs(JsonResponseTxt);
                if GuiAllowed then Message('JsonResponse Text%1', JsonResponseTxt);
            end;
        // exit('No Responses');
        end
        else
        begin
            ResponseMessage.Content().ReadAs(JsonResponseTxt);
            if GuiAllowed then Message('JsonResponse Text%1', JsonResponseTxt);
        end;
    end;
    // Updated GeneratePostPayload to process the complex JSON input
    procedure GeneratePostingConfirmation2(GLEntry_Var: Record "G/L Entry"): Text var
        HeaderJsonObject: JsonObject;
        LineJsonObject: JsonObject;
        LineJsonArray: JsonArray;
        GLEntry: Record "G/L Entry";
        ChildJsonArray: JsonArray;
        SystemJsonArray: JsonArray;
        SystemJsonObject: JsonObject;
        PostingDocJsonArray: JsonArray;
        PaymentRelJsonArray: JsonArray;
        PostingDocJsonObject: JsonObject;
        ResponseTEST: Text;
        CompanyMapp: Record "Company Name Mapping";
        CompanyId: text[50];
        ConcurApiSetup: Record "Concur API Setup";
    begin
        ConcurApiSetup.Get();
        Clear(LineJsonArray);
        Clear(HeaderJsonObject);
        Clear(CompanyId);
        CompanyMapp.Get(CompanyName);
        //TEC.VJ 30Oct2025 << Comment for Company Code Prefix
        // if CopyStr(CompanyMapp."PB Company Code", 1, 1) = ConcurApiSetup."Company Code Prefix" then
        //     CompanyId := CopyStr(CompanyMapp."PB Company Code", 2, strlen(CompanyMapp."PB Company Code"))
        // else
        //     CompanyId := CompanyMapp."PB Company Code";
        //TEC.VJ 30Oct2025 >> Comment for Company Code Prefix
        //TEC.VJ 30Oct2025 <<
        if CompanyMapp."Concur Company Code" <> '' then CompanyId:=CompanyMapp."Concur Company Code"
        else
            CompanyId:=CompanyMapp."PB Company Code";
        //TEC.VJ 30Oct2025 >>
        GLEntry.Reset();
        GLEntry.SetFilter("Concur ID", '<>%1', '');
        if GLEntry_Var."Entry No." <> 0 then GLEntry.SetFilter("Entry No.", '=%1', GLEntry_Var."Entry No.");
        GLEntry.SetRange("Exported to Concur", false); //#372 VJ Rolled back
        // GLEntry.SetRange("Payment Confirmed in Concur", false);//#372 VJ 30June2025 added new check for payment confirmation Exported to Concur is used for confirmation only
        GLEntry.SetFilter(ConfirmationResult, '<>%1', 'SUCCESS'); //VJ 05MAR2025
        //#329 TEC.VJ 08MAY2025>>
        GLEntry.SetRange("PB Concur invoice", true);
        // GLEntry.SetFilter("Global Dimension 2 Code", '=%1|%2', 'CONCR', 'CONCL');//#267 TEC.VJ 20MAR2025
        GLEntry.SetFilter("Global Dimension 2 Code", '=%1|%2', ConcurApiSetup."Default Concur Dimension", ConcurApiSetup."CL Default Concur Dim."); //#267 TEC.VJ 20MAR2025
        //#329 TEC.VJ 08MAY2025<<
        if GLEntry.FindSet()then begin
            HeaderJsonObject.Add('systemId', '');
            repeat Clear(LineJsonObject);
                Clear(PostingDocJsonArray);
                Clear(SystemJsonArray);
                Clear(PostingDocJsonObject);
                Clear(SystemJsonObject);
                Clear(PaymentRelJsonArray);
                LineJsonObject.Add('docId', GLEntry."Concur ID");
                LineJsonObject.Add('overallPostingStatusCode', 'success');
                PostingDocJsonObject.Add('companyId', companyId);
                PostingDocJsonObject.Add('documentNumber', GLEntry."Document No.");
                PostingDocJsonObject.Add('fiscalYear', format(Date2DMY(GLEntry."Posting Date", 3)));
                //PaymentRelJsonArray
                PostingDocJsonObject.Add('paymentRelevantLineItems', PaymentRelJsonArray);
                PostingDocJsonObject.Add('postingDate', format(GLEntry."Posting Date", 0, '<Closing><Year4>-<Month,2>-<Day,2>'));
                PostingDocJsonArray.Add(PostingDocJsonObject);
                LineJsonObject.Add('postingDocs', PostingDocJsonArray);
                SystemJsonObject.add('concurTransactionLineItemId', GLEntry."Entry Id");
                SystemJsonObject.add('messageId', GLEntry."Document No.");
                SystemJsonObject.add('messageLanguage', 'EN');
                SystemJsonObject.add('messageLongText', '');
                // SystemJsonObject.add('messageShortText', 'Check the report');
                SystemJsonObject.add('messageShortText', 'This doc was posted successfully from ERP.');
                SystemJsonArray.add(SystemJsonObject);
                LineJsonObject.Add('systemMessages', SystemJsonArray);
                LineJsonArray.Add(LineJsonObject);
            until GLEntry.Next() = 0;
            HeaderJsonObject.Add('postingConfirmations', LineJsonArray);
            HeaderJsonObject.WriteTo(ResponseTEST);
            // Message(ResponseTEST);
            exit(ResponseTEST);
        end;
    end;
    // Procedure to extract specific values from the JSON response (unchanged)
    procedure ResponseJsonHeader(Depth: integer; path1: text): text var
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
    local procedure UpdateGLEntry(LogEntryNo: Integer)
    var
        i: Integer;
        GLEntry: Record "G/L Entry";
        TotalRec: Integer;
        ConcurAPIInbound: Record "Concur API Inbound";
    begin
        JsonBuffer.Reset();
        JsonBuffer.SetRange(Value, 'code');
        JsonBuffer.SetRange(Depth, 2);
        if JsonBuffer.FindSet()then begin
            TotalRec:=JsonBuffer.Count;
            for i:=0 to TotalRec do begin
                GLEntry.Reset();
                GLEntry.SetRange("Concur ID", ResponseJsonHeader(2, '[' + Format(i) + '].docId'));
                if GLEntry.FindFirst()then begin
                    ConcurAPIInbound.Updateexpenseid(GLEntry."Concur ID", LogEntryNo); //TEC.VJ 16JULY2025
                    repeat GLEntry."ConfirmationResult":=ResponseJsonHeader(2, '[' + Format(i) + '].postingConfirmationResult');
                        GLEntry."Exported to Concur":=true; //#372 rolled back
                        // GLEntry."Payment Confirmed in Concur" := true;//#372 VJ 30June2025
                        GLEntry.errorMessage:=ResponseJsonHeader(2, '[' + Format(i) + '].errorMessage');
                        GLEntry.Modify();
                    until GLEntry.Next() = 0; //TEC.VJ 08JULY2025 update response in all entries for Concur id
                end;
            end;
        end;
    end;
    var JsonBuffer: Record "JSON Buffer" temporary;
}
