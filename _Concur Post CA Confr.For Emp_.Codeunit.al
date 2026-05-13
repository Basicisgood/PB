codeunit 50222 "Concur Post CA Confr.For Emp"
{
    Permissions = tabledata "Employee Ledger Entry"=rm;

    trigger OnRun()
    var
        EmpLedgEntry: Record "Employee Ledger Entry";
    begin
        //TEC.VJ 14MAY2025>>
        ConcurApiSetup.Get();
        Clear(EmpLedgEntry);
        EmpLedgEntry.Reset();
        EmpLedgEntry.SetFilter("Concur ID", '<>%1', '');
        EmpLedgEntry.SetRange("Exported to Concur", false);
        EmpLedgEntry.SetRange("Cash Advance", true);
        EmpLedgEntry.SetFilter(ConfirmationResult, '<>%1', 'SUCCESS'); //VJ 05MAR2025
        EmpLedgEntry.SetFilter("Global Dimension 2 Code", '=%1', ConcurApiSetup."Cash Advance FD10");
        if EmpLedgEntry.FindSet()then repeat GetPostingConfirmation(EmpLedgEntry);
            until EmpLedgEntry.Next() = 0;
    //TEC.VJ 14MAY2025<<
    end;
    //TEC.VJ 14MAY2025>>
    procedure GetPostingConfirmation(EmpLedger: Record "Employee Ledger Entry"): Text var
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
        ConcurCashAdvance: Codeunit "Concur Cash Advance";
        ConcurAPIInboundLog: Record 50189;
        LogEntryNo: Integer;
        JsonRequest: Text;
    begin
        JsonBuffer.DeleteAll();
        Clear(JsonBuffer);
        APISetup.GET;
        APISetup.TestField("Is Enable", true);
        APISetup.TestField("Post Cash Advance Confir. URL");
        Clear(ConcurCashAdvance);
        AccessToken:=ConcurCashAdvance.GenerateRefreshToken();
        IF AccessToken = '' then Error('No Access Token generated');
        url:=APISetup."Post Cash Advance Confir. URL";
        RequestMessage.SetRequestUri(Url);
        RequestMessage.Method('POST');
        RequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Add('Authorization', AccessToken);
        // Pass the received JSON data to GeneratePostPayload
        JsonRequest:=GeneratePostingConfirmation2(EmpLedger);
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
                LogEntryNo:=ConcurAPIInboundLog.InsertLog(9, JsonRequest, JsonResponseTxt);
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
    procedure GeneratePostingConfirmation2(EmpLedger: Record "Employee Ledger Entry"): Text var
        HeaderJsonObject: JsonObject;
        LineJsonObject: JsonObject;
        LineJsonArray: JsonArray;
        EmpLedgerEntry_Var: Record "Employee Ledger Entry";
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
        EmpLedgerEntry_Var.Reset();
        EmpLedgerEntry_Var.SetFilter("Concur ID", '<>%1', '');
        if EmpLedger."Entry No." <> 0 then EmpLedgerEntry_Var.SetFilter("Entry No.", '=%1', EmpLedger."Entry No.");
        EmpLedgerEntry_Var.SetRange("Exported to Concur", false);
        EmpLedgerEntry_Var.SetRange("Cash Advance", true);
        EmpLedgerEntry_Var.SetFilter(ConfirmationResult, '<>%1', 'SUCCESS'); //VJ 05MAR2025
        EmpLedgerEntry_Var.SetFilter("Global Dimension 2 Code", '=%1', ConcurApiSetup."Cash Advance FD10");
        if EmpLedgerEntry_Var.FindSet()then begin
            HeaderJsonObject.Add('systemId', '');
            repeat Clear(LineJsonObject);
                Clear(PostingDocJsonArray);
                Clear(SystemJsonArray);
                Clear(PostingDocJsonObject);
                Clear(SystemJsonObject);
                Clear(PaymentRelJsonArray);
                LineJsonObject.Add('docId', EmpLedgerEntry_Var."Concur ID");
                LineJsonObject.Add('overallPostingStatusCode', 'success');
                PostingDocJsonObject.Add('companyId', companyId);
                PostingDocJsonObject.Add('documentNumber', EmpLedgerEntry_Var."Document No.");
                PostingDocJsonObject.Add('fiscalYear', format(Date2DMY(EmpLedgerEntry_Var."Posting Date", 3)));
                //PaymentRelJsonArray
                PostingDocJsonObject.Add('paymentRelevantLineItems', PaymentRelJsonArray);
                PostingDocJsonObject.Add('postingDate', format(EmpLedgerEntry_Var."Posting Date", 0, '<Closing><Year4>-<Month,2>-<Day,2>'));
                PostingDocJsonArray.Add(PostingDocJsonObject);
                LineJsonObject.Add('postingDocs', PostingDocJsonArray);
                SystemJsonObject.add('concurTransactionLineItemId', EmpLedgerEntry_Var."Entry Id");
                SystemJsonObject.add('messageId', EmpLedgerEntry_Var."Document No.");
                SystemJsonObject.add('messageLanguage', 'EN');
                SystemJsonObject.add('messageLongText', '');
                SystemJsonObject.add('messageShortText', 'This doc was posted successfully from ERP');
                SystemJsonArray.add(SystemJsonObject);
                LineJsonObject.Add('systemMessages', SystemJsonArray);
                LineJsonArray.Add(LineJsonObject);
            until EmpLedgerEntry_Var.Next() = 0;
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
        EmpLedgerEntry_Var: Record "Employee Ledger Entry";
        TotalRec: Integer;
        ConcurAPIInbound: Record "Concur API Inbound";
    begin
        JsonBuffer.Reset();
        JsonBuffer.SetRange(Value, 'code');
        JsonBuffer.SetRange(Depth, 2);
        if JsonBuffer.FindSet()then begin
            TotalRec:=JsonBuffer.Count;
            for i:=0 to TotalRec do begin
                EmpLedgerEntry_Var.Reset();
                EmpLedgerEntry_Var.SetRange("Concur ID", ResponseJsonHeader(2, '[' + Format(i) + '].docId'));
                EmpLedgerEntry_Var.SetRange("Cash Advance", true);
                if EmpLedgerEntry_Var.FindFirst()then begin
                    EmpLedgerEntry_Var."ConfirmationResult":=ResponseJsonHeader(2, '[' + Format(i) + '].postingConfirmationResult');
                    EmpLedgerEntry_Var."Exported to Concur":=true;
                    EmpLedgerEntry_Var.errorMessage:=ResponseJsonHeader(2, '[' + Format(i) + '].errorMessage');
                    EmpLedgerEntry_Var.Modify();
                    ConcurAPIInbound.Updateexpenseid(EmpLedgerEntry_Var."Concur ID", LogEntryNo); //TEC.VJ 16JULY2025
                end;
            end;
        end;
    end;
    //TEC.VJ 14MAY2025>>
    var JsonBuffer: Record "JSON Buffer" temporary;
    ConcurApiSetup: Record "Concur API Setup";
}
