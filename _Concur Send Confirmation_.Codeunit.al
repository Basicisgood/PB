codeunit 50186 "Concur Send Confirmation"
{
    Permissions = tabledata "Employee Ledger Entry"=rm;

    trigger OnRun()
    var
        EmpLedgerEntry: Record "Employee Ledger Entry";
    begin
        Clear(EmpLedgerEntry);
        GetPostingConfirmation(EmpLedgerEntry);
    end;
    // Procedure to generate the refresh token (unchanged)
    // Procedure to handle Basic Auth (unchanged)
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
    // Updated GetAcknowledgement to accept JSON data
    procedure GetPostingConfirmation(EmpLedgEntry_Var: Record "Employee Ledger Entry"): Text var
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
        JsonRequest:=GeneratePostingConfirmation2(EmpLedgEntry_Var);
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
                // UpdateEmpLedgerEntry();
                UpdateEmpLedgerEntry(LogEntryNo); //TEC.VJ 16JULY2025
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
    procedure GeneratePostingConfirmation(): Text var
        JsonResponse: Text;
        PostingConfirmations: Text;
        SystemMessages: Text;
        EmpLedgEntry: Record "Employee Ledger Entry";
    begin
        // Start of the JSON response
        JsonResponse:='{ "systemId": "", "postingConfirmations": [';
        // // First posting confirmation with error
        PostingConfirmations:='{';
        PostingConfirmations+='"docId": "2b3b5d29bc624bc0aa2af82bb875be27",';
        PostingConfirmations+='"overallPostingStatusCode": "error",';
        PostingConfirmations+='"postingDocs": [],';
        SystemMessages:='[{';
        SystemMessages+='"concurTransactionLineItemId": "1",';
        SystemMessages+='"messageId": "0002-LI",';
        SystemMessages+='"messageLanguage": "KR",';
        SystemMessages+='"messageLongText": "",';
        SystemMessages+='"messageShortText": "Check the report"';
        SystemMessages+='}]';
        PostingConfirmations+='"systemMessages": ' + SystemMessages;
        PostingConfirmations+='},';
        // Second posting confirmation with success
        PostingConfirmations+='{';
        PostingConfirmations+='"docId": "7df07e74c72d4054be5814e60db1b346",';
        PostingConfirmations+='"overallPostingStatusCode": "success",';
        PostingConfirmations+='"postingDocs": [';
        PostingConfirmations+='{';
        PostingConfirmations+='"companyId": "3000",';
        PostingConfirmations+='"documentNumber": "12345678",';
        PostingConfirmations+='"fiscalYear": "2020",';
        PostingConfirmations+='"paymentRelevantLineItems": [],';
        PostingConfirmations+='"postingDate": "2020-10-20"';
        PostingConfirmations+='}],';
        PostingConfirmations+='"systemMessages": []';
        PostingConfirmations+='},';
        // Third posting confirmation with success and system message
        PostingConfirmations+='{';
        PostingConfirmations+='"docId": "26ad7d99480d45a5b4459d7d7f912219",';
        PostingConfirmations+='"overallPostingStatusCode": "success",';
        PostingConfirmations+='"postingDocs": [';
        PostingConfirmations+='{';
        PostingConfirmations+='"companyId": "3000",';
        PostingConfirmations+='"documentNumber": "87654321",';
        PostingConfirmations+='"fiscalYear": "2020",';
        PostingConfirmations+='"paymentRelevantLineItems": [],';
        PostingConfirmations+='"postingDate": "2020-10-20"';
        PostingConfirmations+='}],';
        SystemMessages:='[{';
        SystemMessages+='"concurTransactionLineItemId": "1",';
        SystemMessages+='"messageId": "0003-LI",';
        SystemMessages+='"messageLanguage": "KR",';
        SystemMessages+='"messageLongText": "",';
        SystemMessages+='"messageShortText": "This doc was posted successfully from ERP"';
        SystemMessages+='}]';
        PostingConfirmations+='"systemMessages": ' + SystemMessages;
        PostingConfirmations+='}';
        // End of the JSON response
        JsonResponse+=PostingConfirmations;
        JsonResponse+=']}';
        // Return the JSON string
        exit(JsonResponse);
    end;
    procedure GeneratePostingConfirmation2(EmpLedgEntry_Var: Record "Employee Ledger Entry"): Text var
        HeaderJsonObject: JsonObject;
        LineJsonObject: JsonObject;
        LineJsonArray: JsonArray;
        EmpLedgEntry: Record "Employee Ledger Entry";
        ChildJsonArray: JsonArray;
        SystemJsonArray: JsonArray;
        SystemJsonObject: JsonObject;
        PostingDocJsonArray: JsonArray;
        PaymentRelJsonArray: JsonArray;
        PostingDocJsonObject: JsonObject;
        ResponseTEST: Text;
        CompanyMapp: Record "Company Name Mapping";
    begin
        Clear(LineJsonArray);
        Clear(HeaderJsonObject);
        EmpLedgEntry.Reset();
        EmpLedgEntry.SetFilter("Concur ID", '<>%1', '');
        if EmpLedgEntry_Var."Entry No." <> 0 then EmpLedgEntry.SetFilter("Entry No.", '=%1', EmpLedgEntry_Var."Entry No.");
        EmpLedgEntry.SetRange("Exported to Concur", false);
        EmpLedgEntry.SetFilter(ConfirmationResult, '<>%1', 'SUCCESS'); //VJ 05MAR2025
        if EmpLedgEntry.FindSet()then begin
            HeaderJsonObject.Add('systemId', '');
            repeat Clear(LineJsonObject);
                Clear(PostingDocJsonArray);
                Clear(SystemJsonArray);
                Clear(PostingDocJsonObject);
                Clear(SystemJsonObject);
                Clear(PaymentRelJsonArray);
                CompanyMapp.Get(CompanyName);
                LineJsonObject.Add('docId', EmpLedgEntry."Concur ID");
                LineJsonObject.Add('overallPostingStatusCode', 'success');
                PostingDocJsonObject.Add('companyId', CompanyMapp."PB Company Code");
                PostingDocJsonObject.Add('documentNumber', EmpLedgEntry."Document No.");
                PostingDocJsonObject.Add('fiscalYear', '"' + Date2DMY(EmpLedgEntry."Posting Date", 3) + '"');
                //PaymentRelJsonArray
                PostingDocJsonObject.Add('paymentRelevantLineItems', PaymentRelJsonArray);
                PostingDocJsonObject.Add('postingDate', Format(EmpLedgEntry."Posting Date", 0, '<Year,4>-<Month,2>-<Day,2>'));
                PostingDocJsonArray.Add(PostingDocJsonObject);
                LineJsonObject.Add('postingDocs', PostingDocJsonArray);
                SystemJsonObject.add('concurTransactionLineItemId', EmpLedgEntry."Entry Id");
                SystemJsonObject.add('messageId', EmpLedgEntry."Document No.");
                SystemJsonObject.add('messageLanguage', 'EN');
                SystemJsonObject.add('messageLongText', '');
                SystemJsonObject.add('messageShortText', 'Check the report');
                SystemJsonArray.add(SystemJsonObject);
                LineJsonObject.Add('systemMessages', SystemJsonArray);
                LineJsonArray.Add(LineJsonObject);
            until EmpLedgEntry.Next() = 0;
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
    local procedure UpdateEmpLedgerEntry(LogEntryNo: Integer)
    var
        i: Integer;
        EmpLedgEntry: Record "Employee Ledger Entry";
        TotalRec: Integer;
        ConcurAPIInbound: Record "Concur API Inbound";
    begin
        JsonBuffer.Reset();
        JsonBuffer.SetRange(Value, 'code');
        JsonBuffer.SetRange(Depth, 2);
        if JsonBuffer.FindSet()then begin
            TotalRec:=JsonBuffer.Count;
            for i:=0 to TotalRec do begin
                EmpLedgEntry.Reset();
                EmpLedgEntry.SetRange("Concur ID", ResponseJsonHeader(2, '[' + Format(i) + '].docId'));
                if EmpLedgEntry.FindFirst()then begin
                    ConcurAPIInbound.Updateexpenseid(EmpLedgEntry."Concur ID", LogEntryNo); //TEC.VJ 16JULY2025
                    repeat EmpLedgEntry."ConfirmationResult":=ResponseJsonHeader(2, '[' + Format(i) + '].postingConfirmationResult');
                        EmpLedgEntry."Exported to Concur":=true;
                        EmpLedgEntry.errorMessage:=ResponseJsonHeader(2, '[' + Format(i) + '].errorMessage');
                        EmpLedgEntry.Modify();
                    until EmpLedgEntry.Next() = 0; //TEC.VJ 08JULY2025 update response in all entries for Concur id
                end;
            end;
        end;
    end;
    var JsonBuffer: Record "JSON Buffer" temporary;
    // ExpenseAttendee: Record expenseAttendeeList;
    JsonBufferValue: text;
    AcknowledgeResult: Text;
    ErrorMessage: Text;
}
