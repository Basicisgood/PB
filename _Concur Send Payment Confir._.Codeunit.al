codeunit 50189 "Concur Send Payment Confir."
{
    Permissions = tabledata "Employee Ledger Entry"=rm;

    trigger OnRun()
    var
        EmpLedgerEntry: Record "Employee Ledger Entry";
    begin
        Clear(EmpLedgerEntry);
        GetPostingPaymentConfirmation(EmpLedgerEntry, false);
    end;
    // Updated GetAcknowledgement to accept JSON data
    procedure GetPostingPaymentConfirmation(EmpLedgEntry_Var: Record "Employee Ledger Entry"; pRequestPreview: Boolean): Text var
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
        url:=APISetup."Finan Trans. Payment Conf. URL";
        RequestMessage.SetRequestUri(Url);
        RequestMessage.Method('POST');
        RequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Add('Authorization', AccessToken);
        // Pass the received JSON data to GeneratePostPayload
        JsonRequest:=GeneratePostingPaymentConfirmation2(EmpLedgEntry_Var);
        HttpContent.WriteFrom(JsonRequest);
        HttpContent.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/json');
        HttpContent.GetHeaders(ContentHeaders);
        RequestMessage.Content(HttpContent);
        if pRequestPreview then Message(JsonRequest)
        else
        begin
            // Message(JsonRequest);
            if HttpClient.Send(RequestMessage, ResponseMessage)then begin
                ResponseMessage.Content.ReadAs(JsonResponseTxt);
                if ResponseMessage.IsSuccessStatusCode then begin
                    JsonBuffer.ReadFromText(JsonResponseTxt);
                    LogEntryNo:=ConcurAPIInboundLog.InsertLog(5, JsonRequest, JsonResponseTxt);
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
            end;
        end;
    end;
    // Updated GeneratePostPayload to process the complex JSON input
    procedure GeneratePostingPaymentConfirmation2(EmpLedgEntry_Var: Record "Employee Ledger Entry"): Text var
        HeaderJsonObject: JsonObject;
        LineJsonObject: JsonObject;
        LineJsonArray: JsonArray;
        EmpLedgEntry: Record "Employee Ledger Entry";
        ChildJsonArray: JsonArray;
        clearingDetailsArray: JsonArray;
        ClearingJsonObject: JsonObject;
        PostingDocJsonArray: JsonArray;
        PostingDocJsonObject: JsonObject;
        ResponseTEST: Text;
        ReceiverObj: JsonObject;
        clearingReference: JsonObject;
        ApplEmpLedgEntry: Record "Employee Ledger Entry";
        ApplicationEntr: Record "detailed Employee Ledger Entry";
        AppliedAmount: Decimal;
        Employee: Record Employee;
        ConcurApiSet: Record "Concur API Setup";
        CompanyCode: code[20];
        CompanyMapp: Record "Company Name Mapping";
        CompanyId: text[50];
        AppliedDocNo: Code[20];
    begin
        Clear(LineJsonArray);
        Clear(HeaderJsonObject);
        ConcurApiSet.Get();
        //#267 TEC.VJ 20MAR2025>>
        Clear(CompanyId);
        IF CompanyMapp.Get(CompanyName)THEN;
        //TEC.VJ 30Oct2025 << Comment for Company Code Prefix
        // if CopyStr(CompanyMapp."PB Company Code", 1, 1) = ConcurApiSet."Company Code Prefix" then
        //     CompanyId := CopyStr(CompanyMapp."PB Company Code", 2, strlen(CompanyMapp."PB Company Code"))
        // else
        //     CompanyId := CompanyMapp."PB Company Code";
        //TEC.VJ 30Oct2025 >> Comment for Company Code Prefix
        //TEC.VJ 30Oct2025 <<
        if CompanyMapp."Concur Company Code" <> '' then CompanyId:=CompanyMapp."Concur Company Code"
        else
            CompanyId:=CompanyMapp."PB Company Code";
        //TEC.VJ 30Oct2025 >>
        //#267 TEC.VJ 20MAR2025<<
        EmpLedgEntry.Reset();
        EmpLedgEntry.SetFilter("Concur ID", '<>%1', '');
        EmpLedgEntry.SetFilter("Employee No.", '<>%1', '*CC*'); //#390 VJ 04082025
        if EmpLedgEntry_Var."Entry No." <> 0 then EmpLedgEntry.SetFilter("Entry No.", '=%1', EmpLedgEntry_Var."Entry No.");
        //EmpLedgEntry.SetRange("Exported to Concur", false);//#372 VJ 18June2025 commented
        EmpLedgEntry.SetRange("Payment Confirmed in Concur", false); //#372 VJ 18June2025 added new check for payment confirmation Exported to Concur is used for confirmation only
        EmpLedgEntry.SetFilter(PaymentConfirmationResult, '<>%1', 'SUCCESS'); //VJ 05MAR2025
        // EmpLedgEntry.SetFilter("Global Dimension 2 Code", '=%1|%2', 'CONCR', 'CONCL');//#267 TEC.VJ 20MAR2025 //#329 TEC.VJ 08MAY2052 COMMENTED
        EmpLedgEntry.SetFilter("Global Dimension 2 Code", '=%1|%2', ConcurApiSet."Default Concur Dimension", ConcurApiSet."CL Default Concur Dim."); //#267 TEC.VJ 20MAR2025 //#329 TEC.VJ 08MAY2052
        EmpLedgEntry.Setfilter("Shortcut Dimension 9 Code_PB", '<>CARD'); //VJ 13062025 Ronald #351
        EmpLedgEntry.SetAutoCalcFields("Remaining Amount", "Original Amount");
        if EmpLedgEntry.FindSet()then begin
            HeaderJsonObject.Add('systemId', '');
            repeat Clear(LineJsonObject);
                Clear(PostingDocJsonArray);
                Clear(clearingDetailsArray);
                Clear(PostingDocJsonObject);
                Clear(ClearingJsonObject);
                clear(ReceiverObj);
                clear(clearingReference);
                clear(AppliedAmount);
                //EmpLedgEntry.CalcFields("Remaining Amount");
                LineJsonObject.Add('docId', EmpLedgEntry."Concur ID");
                if EmpLedgEntry."Remaining Amount" > 0 then LineJsonObject.Add('processingStatusCode', 'PP')
                else
                    LineJsonObject.Add('processingStatusCode', 'CP');
                //#267 TEC.VJ 20MAR2025>>
                if abs(EmpLedgEntry."Remaining Amount") < abs(EmpLedgEntry."Original Amount")then begin
                    ApplEmpLedgEntry.Reset();
                    ApplEmpLedgEntry.SetRange("Closed by Entry No.", EmpLedgEntry."Entry No.");
                    ApplEmpLedgEntry.SetRange("Employee No.", EmpLedgEntry."Employee No."); //VJ 13062025
                    if ApplEmpLedgEntry.FindSet()then begin
                        repeat ApplicationEntr.Reset();
                            ApplicationEntr.SetRange("Employee Ledger Entry No.", ApplEmpLedgEntry."Entry No.");
                            ApplicationEntr.SetRange("Entry Type", ApplicationEntr."Entry Type"::Application);
                            ApplicationEntr.SetLoadFields("Document No.", Amount);
                            if ApplicationEntr.FindSet()then begin
                                AppliedDocNo:=ApplicationEntr."Document No.";
                                ApplicationEntr.CalcSums(Amount);
                                AppliedAmount+=ApplicationEntr.Amount;
                            end;
                        until ApplEmpLedgEntry.Next() = 0;
                    end
                    ELSE
                    begin
                        ApplEmpLedgEntry.Reset();
                        ApplEmpLedgEntry.SetRange("Entry No.", EmpLedgEntry."Closed by Entry No.");
                        if ApplEmpLedgEntry.FindSet()then repeat ApplicationEntr.Reset();
                                ApplicationEntr.SetRange("Employee Ledger Entry No.", ApplEmpLedgEntry."Entry No.");
                                ApplicationEntr.SetRange("Entry Type", ApplicationEntr."Entry Type"::Application);
                                ApplicationEntr.SetLoadFields("Document No.", Amount);
                                if ApplicationEntr.FindSet()then begin
                                    AppliedDocNo:=ApplicationEntr."Document No.";
                                    ApplicationEntr.CalcSums(Amount);
                                    AppliedAmount+=ApplicationEntr.Amount;
                                end;
                            until ApplEmpLedgEntry.Next() = 0;
                    end;
                    if Employee.Get(EmpLedgEntry."Employee No.")then;
                    ClearingJsonObject.Add('clearingDate', EmpLedgEntry."Posting Date");
                    ClearingJsonObject.Add('clearingAmount', abs(AppliedAmount)); //VJ 14042025 ADDED abs()
                    ClearingJsonObject.Add('clearingCurrency', ApplicationEntr."Currency Code");
                    ReceiverObj.Add('receiverId', EmpLedgEntry."Employee No.");
                    ReceiverObj.Add('receiverName', Employee."First Name"); //#329 TEC.VJ 08MAY2052 Change fullname to Firstname
                    ReceiverObj.Add('receiverType', 'EMPLOYEE');
                    ClearingJsonObject.Add('receiver', ReceiverObj);
                    clearingReference.Add('companyCode', CompanyId);
                    clearingReference.Add('financialDocumentId', ApplicationEntr."Document No.");
                    clearingReference.Add('fiscalYear', Format(Date2DMY(EmpLedgEntry."Posting Date", 3)));
                    //clearingReference.Add('paymentRef', EmpLedgEntry."Bank Document No.");
                    clearingReference.Add('paymentRef', AppliedDocNo);
                    clearingReference.Add('paymentMethod', 'E'); //
                    ClearingJsonObject.Add('clearingReference', clearingReference);
                    clearingDetailsArray.add(ClearingJsonObject);
                end;
                //#267 TEC.VJ 20MAR2025<<
                LineJsonObject.Add('clearingDetails', clearingDetailsArray);
                LineJsonArray.Add(LineJsonObject);
            until EmpLedgEntry.Next() = 0;
            HeaderJsonObject.Add('processingConfirmation', LineJsonArray);
            HeaderJsonObject.WriteTo(ResponseTEST);
            exit(ResponseTEST);
        end;
    // Message(test);
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
        PaymentConfrResult: text[100];
        ConcurAPIInbound: Record "Concur API Inbound";
    begin
        JsonBuffer.Reset();
        JsonBuffer.SetRange(Value, 'code');
        JsonBuffer.SetRange(Depth, 2);
        if JsonBuffer.FindSet()then begin
            TotalRec:=JsonBuffer.Count;
            for i:=0 to TotalRec do begin
                PaymentConfrResult:=ResponseJsonHeader(2, '[' + Format(i) + '].paymentConfirmationResult');
                if PaymentConfrResult <> '' then begin
                    EmpLedgEntry.Reset();
                    EmpLedgEntry.SetRange("Concur ID", ResponseJsonHeader(2, '[' + Format(i) + '].docId'));
                    EmpLedgEntry.Setfilter("Shortcut Dimension 9 Code_PB", '<>CARD'); //VJ 13062025 Ronald #351
                    if EmpLedgEntry.FindFirst()then begin
                        ConcurAPIInbound.Updateexpenseid(EmpLedgEntry."Concur ID", LogEntryNo); //TEC.VJ 16JULY2025
                        repeat EmpLedgEntry.PaymentConfirmationResult:=ResponseJsonHeader(2, '[' + Format(i) + '].paymentConfirmationResult');
                            // EmpLedgEntry."Exported to Concur" := true;
                            EmpLedgEntry."Payment Confirmed in Concur":=true; //#372 VJ 18June2025 added new check for payment confirmation Exported to Concur is used for confirmation only
                            EmpLedgEntry.errorMessage:=ResponseJsonHeader(2, '[' + Format(i) + '].errorMessage');
                            EmpLedgEntry.Modify();
                        until EmpLedgEntry.Next() = 0; //TEC.VJ 08JULY2025 update response in all entries for Concur id
                    end;
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
