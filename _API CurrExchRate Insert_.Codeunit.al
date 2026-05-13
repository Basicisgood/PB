codeunit 50153 "API CurrExchRate Insert"
{
    trigger OnRun()
    begin
        CurrExchRateInsert(0);
        Sleep(1000);
    //ContactInsert(1);
    end;
    procedure CurrExchRateInsert(P_Type: Option Insert, Update): Text var
        TokenUrl: Text[1024];
        ClientId: Text[1024];
        ClientSecret: Text[1024];
        Resource: Text[1024];
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
        JsonResponseTxt: Text;
    begin
        APISetup.GET;
        APISetup.TestField("Is Enable", true);
        IF P_Type = 0 then begin
            APISetup.TestField("CurrExchRate Create URL");
            TokenUrl:=APISetup."CurrExchRate Create URL";
        end;
        AccessToken:=CU_TokenRequest.GenerateRefreshToken();
        IF AccessToken = '' then Error('No Access Token generated');
        RequestHeader:=HttpClient.DefaultRequestHeaders;
        RequestHeader.Add('User-Agent', 'Dynamics 365');
        HttpClient.DefaultRequestHeaders().Add('Authorization', AccessToken);
        Content.GetHeaders(RequestHeader);
        RequestHeader.Clear();
        HttpClient.SetBaseAddress(TokenURL);
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
            if GuiAllowed then Message('%1', JsonResponseTxt);
        end
        else
        begin
            ResponseMessage.Content().ReadAs(JsonResponseTxt);
            if GuiAllowed then Message('JsonResponse Text%1', JsonResponseTxt);
        // message('Error %1', CopyStr(GetLastErrorText(), 1, 100));
        end;
    end;
    procedure PrepareBody(P_Type: Option Insert, Update): Text var
        CurrExchRate: Record "Currency Exchange Rate";
        JArray: JsonArray;
        JArray2: JsonArray;
        GLObject: JsonObject;
        DefDimObject: JsonObject;
        JsonData: Text;
        DVNOutbound: Record "DNV Outbound Log";
        GLSetup: record "General Ledger Setup";
        Currency: Record Currency;
        PrimaryKey2: Date;
        NextMonthStartDate: Date;
        NextMonthStartDatetext: Text;
    begin
        clear(JArray);
        // Calculate the first date of the next month
        NextMonthStartDate:=CalcDate('<+CM>', Today);
        NextMonthStartDatetext:=Format(NextMonthStartDate);
        TempOutboundLog.DeleteAll();
        DVNOutbound.reset;
        DVNOutbound.SetRange("Table No.", 330);
        DVNOutbound.SetRange("Entry Type", P_Type);
        //DVNOutbound.SetRange("Primary key 2", NextMonthStartDatetext);
        DVNOutbound.SetFilter(Status, '<>%1', DVNOutbound.Status::Success);
        IF DVNOutbound.FindFirst()then begin
            clear(JArray2);
            repeat Clear(CurrExchRate); //VJ 10DEC2024 error is showing for previous record
                GLSetup.Get();
                Currency.Get(DVNOutbound."Primary key"); //VJ 10DEC2024
                Evaluate(PrimaryKey2, DVNOutbound."Primary key 2");
                CurrExchRate.GET(DVNOutbound."Primary key", PrimaryKey2);
                Currency.Get(CurrExchRate."Currency Code");
                clear(GLObject);
                GLObject.Add('CurrencyCode', CurrExchRate."Currency Code");
                GLObject.Add('BaseCurrencyCode', GLSetup."LCY Code");
                GLObject.Add('ExchangeRateDate', Format(CurrExchRate."Starting Date"));
                GLObject.Add('ExchangeRateAmount', CurrExchRate."Converted Rate");
                GLObject.Add('CurrencyName', Currency.Description);
                JArray2.Add(GLObject);
                //GLObject.Add('currency set',JArray2);
                TempOutboundLog.Init();
                TempOutboundLog.TransferFields(DVNOutbound);
                TempOutboundLog.Insert();
            until DVNOutbound.Next() = 0;
        end;
        JArray2.WriteTo(JsonData);
        //GLObject.WriteTo()
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
    // ExchangeRateDateTxt : 
    begin
        //Message('Temp Count %1', TempOutboundLog.Count);
        JsonBuffer.DeleteAll();
        //Message('response...%1', P_Jason);
        JsonBuffer2.ReadFromText(P_Jason);
        //Page.Run(Page::"JSon Buffer List", JsonBuffer2);
        //Message('%1..Json Count', JsonBuffer2.Count);
        JsonBuffer2.reset;
        JsonBuffer2.SetRange(Depth, 3);
        JsonBuffer2.SetRange("Token type", JsonBuffer2."Token type"::String);
        IF JsonBuffer2.FindLast()then TotalObjectNo:=JsonBuffer2."Object Number";
        // Message('%1..ObjectNumber', TotalObjectNo);
        for i:=1 To TotalObjectNo Do begin
            CurrencyCode:='';
            ErrorText:='';
            PKEntryNo2:=0;
            ExchangeRateDate:='';
            JsonBuffer2.Reset();
            JsonBuffer2.SetRange("Object Number");
            JsonBuffer2.SetRange(Error);
            IF JsonBuffer2.findset then JsonBuffer2.SetRange("Object Number", i);
            JsonBuffer2.SetRange("Token type");
            JsonBuffer2.SetRange("Token type", JsonBuffer2."Token type"::"Property Name");
            JsonBuffer2.SetRange(Value, 'CurrencyCode'); //DNV Integration
            IF JsonBuffer2.FindFirst()then PKEntryNo:=JsonBuffer2."Entry No.";
            JsonBuffer2.SetRange(Value);
            JsonBuffer2.SetRange(Value, 'ExchangeRateDate');
            IF JsonBuffer2.FindFirst()then PKEntryNo2:=JsonBuffer2."Entry No.";
            JsonBuffer2.SetRange(Value);
            JsonBuffer2.SetRange("Token type");
            JsonBuffer2.SetRange("Entry No.", PKEntryNo2 + 1);
            JsonBuffer2.SetRange("Token type", JsonBuffer2."Token type"::Date); //DNV Integration
            if JsonBuffer2.FindFirst()then ExchangeRateDate:=JsonBuffer2.Value;
            Evaluate(ExchangeDateTime, ExchangeRateDate);
            ExchangeDate:=DT2Date(ExchangeDateTime);
            JsonBuffer2.SetRange("Token type");
            JsonBuffer2.SetRange("Token type", JsonBuffer2."Token type"::String); //DNV Integration
            JsonBuffer2.SetRange("Entry No.", PKEntryNo + 1);
            if JsonBuffer2.FindFirst()then CurrencyCode:=JsonBuffer2.Value;
            JsonBuffer2.SetRange("Entry No.");
            IF JsonBuffer2.findset then JsonBuffer2.SetRange(JsonBuffer2.Error, true);
            IF JsonBuffer2.FindFirst()then ErrorText:=CopyStr(JsonBuffer2.Value, 1, 999);
            TempOutboundLog.reset;
            TempOutboundLog.SetRange("Primary key", CurrencyCode);
            TempOutboundLog.SetRange("Primary key 2", Format(ExchangeDate));
            IF TempOutboundLog.FindFirst()then begin
                IF ErrorText <> '' then begin
                    TempOutboundLog.Status:=TempOutboundLog.Status::Error;
                    TempOutboundLog."Error Reason":=ErrorText;
                end
                else
                begin
                    TempOutboundLog.Status:=TempOutboundLog.Status::Success;
                    TempOutboundLog."Error Reason":=''; //DNV Integration
                end;
                TempOutboundLog."Sent Date Time":=CurrentDateTime;
                TempOutboundLog.Modify();
            end;
        end;
        TempOutboundLog.reset;
        IF TempOutboundLog.FindFirst()then repeat IF DNVOutboundLog.GET(TempOutboundLog."Entry No.")then begin
                    DNVOutboundLog.TransferFields(TempOutboundLog);
                    DNVOutboundLog.Modify();
                end;
            until TempOutboundLog.Next() = 0;
    //IF JsonBuffer2.FindFirst() then
    //    repeat
    //        JsonBuffer.Init();
    //        JsonBuffer.TransferFields(JsonBuffer2);
    //        JsonBuffer.insert;
    //    until JsonBuffer2.Next() = 0;
    //clear(JPage);
    //JPage.SetTableView(JsonBuffer);
    //JPage.Run();
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
    CU_TokenRequest: Codeunit "API Token Request";
    TempOutboundLog: Record "DNV Outbound Log" temporary;
    DNVOutboundLog: Record "DNV Outbound Log";
}
