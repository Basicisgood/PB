codeunit 50172 "Concur API Invoice Payment"
{
    trigger OnRun()
    begin
        //ContactInsert(0);
        Sleep(1000);
        PaymentInsert(1);
    end;
    procedure PaymentInsert(P_Type: Option Insert, Update): Text var
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
        APISetup.TestField("Enable Outbound Integration", true);
        APISetup.TestField("payment URL");
        TokenUrl:=APISetup."Payment URL";
        AccessToken:=GenerateRefreshToken();
        IF AccessToken = '' then Error('No Access Token generated');
        HttpClient.DefaultRequestHeaders().Add('Authorization', AccessToken);
        Content.GetHeaders(RequestHeader);
        RequestHeader.Clear();
        HttpClient.SetBaseAddress(TokenURL);
        RequestMessage.Method('POST');
        RequestHeader.Remove('Content-Type');
        RequestHeader.Add('Content-Type', 'application/json');
        Clear(TempBlob);
        TempBlob.CreateOutStream(Outstr);
        Outstr.WriteText(PrepareBody(P_Type));
        TempBlob.CreateInStream(Instr);
        Content.WriteFrom(Instr);
        RequestMessage.Content(Content);
        HttpClient.Send(RequestMessage, ResponseMessage);
        IF ResponseMessage.IsSuccessStatusCode()THEN BEGIN
            //Message('Success');
            ResponseMessage.Content().ReadAs(JsonResponseTxt);
            ProcessJasonresponse(JsonResponseTxt);
        //if GuiAllowed then
        //    Message('%1', JsonResponseTxt);
        end
        else
        begin
            ResponseMessage.Content().ReadAs(JsonResponseTxt);
            ProcessJasonresponse(JsonResponseTxt);
        //if GuiAllowed then
        //    Message('JsonResponse Text%1', JsonResponseTxt);
        // message('Error %1', CopyStr(GetLastErrorText(), 1, 100));
        end;
    end;
    procedure PrepareBody(P_Type: Option Insert, Update): Text var
        RecEmpLedEntry: Record "Employee Ledger Entry";
        JArray: JsonArray;
        JArray2: JsonArray;
        GLObject: JsonObject;
        DefDimObject: JsonObject;
        JsonData: Text;
        DVNOutbound: Record "DNV Outbound Log";
    begin
        clear(JArray);
        TempOutboundLog.DeleteAll();
        DVNOutbound.reset;
        DVNOutbound.SetRange("Table No.", 5222);
        DVNOutbound.SetRange("Entry Type", P_Type);
        DVNOutbound.SetFilter(Status, '<>%1', DVNOutbound.Status::Success);
        IF DVNOutbound.FindFirst()then begin
            clear(JArray2);
            repeat RecEmpLedEntry.Reset();
                //RecVendLedEntry.SetRange("Document Type", RecVendLedEntry."Document Type"::Payment);
                RecEmpLedEntry.SetRange("Document No.", DVNOutbound."Primary key");
                RecempLedEntry.SetRange("Exported to Concur", false);
            /*
            if RecempLedEntry.FindFirst() then begin
                empLEntDocNo := RecempLedEntry."Document No.";
                clear(GLObject);
                GLObject.Add('Code', RecVendLedEntry."Document No.");
                GLObject.Add('CurrencyCode', RecVendLedEntry."Currency Code");
                //GLObject.Add('BookingMethod', RecVendLedEntry."Booking Method");
                GLObject.Add('BookingMethod', 'S');
                GLObject.Add('PaymentDate', RecVendLedEntry."Payment Date");
                GLObject.Add('Remark', RecVendLedEntry.Remarks);
                RecVendLedEntry.Reset();
                RecVendLedEntry.SetRange("Document No.", DVNOutbound."Primary key 2");
                if RecVendLedEntry.FindSet() then begin
                    GLObject.Add('ShipManagerId', RecVendLedEntry."Ship Manager Id");
                    GLObject.Add('InvoiceDate', RecVendLedEntry."Posting Date");
                end;
                //GLObject.Add('ShipManagerId', 'b0001f1c-c746-4ca3-8042-c224837afd12');
                JArray2.Add(GLObject);
                TempOutboundLog.Init();
                TempOutboundLog.TransferFields(DVNOutbound);
                TempOutboundLog.Insert();
            end;
*/
            until DVNOutbound.Next() = 0;
        end;
        JArray2.WriteTo(JsonData);
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
        Code: code[20];
        ErrorText: Text[1000];
        PKEntryNo: Integer;
    begin
        //Message('Temp Count %1', TempOutboundLog.Count);
        JsonBuffer.DeleteAll();
        //Message('response...%1', P_Jason);
        JsonBuffer2.ReadFromText(P_Jason);
        //Message('%1..Json Count', JsonBuffer2.Count);
        JsonBuffer2.reset;
        JsonBuffer2.SetRange(Depth, 3);
        JsonBuffer2.SetRange("Token type", JsonBuffer2."Token type"::String);
        IF JsonBuffer2.FindLast()then TotalObjectNo:=JsonBuffer2."Object Number";
        // Message('%1..ObjectNumber', TotalObjectNo);
        for i:=1 To TotalObjectNo Do begin
            Code:='';
            ErrorText:='';
            JsonBuffer2.SetRange("Object Number");
            JsonBuffer2.SetRange(Error);
            IF JsonBuffer2.findset then JsonBuffer2.SetRange("Object Number", i);
            JsonBuffer2.SetRange("Token type");
            JsonBuffer2.SetRange("Token type", JsonBuffer2."Token type"::"Property Name");
            JsonBuffer2.SetRange(Value, 'Code'); //DNV Integration
            IF JsonBuffer2.FindFirst()then PKEntryNo:=JsonBuffer2."Entry No.";
            JsonBuffer2.SetRange(Value);
            JsonBuffer2.SetRange("Token type");
            JsonBuffer2.SetRange("Token type", JsonBuffer2."Token type"::String); //DNV Integration
            JsonBuffer2.SetRange("Entry No.", PKEntryNo + 1);
            if JsonBuffer2.FindFirst()then Code:=JsonBuffer2.Value;
            JsonBuffer2.SetRange("Entry No.");
            IF JsonBuffer2.findset then JsonBuffer2.SetRange(JsonBuffer2.Error, true);
            IF JsonBuffer2.FindFirst()then ErrorText:=CopyStr(JsonBuffer2.Value, 1, 999);
            TempOutboundLog.reset;
            TempOutboundLog.SetRange("Primary key", Code);
            IF TempOutboundLog.FindFirst()then begin
                IF ErrorText <> '' then begin
                    TempOutboundLog.Status:=TempOutboundLog.Status::Error;
                    TempOutboundLog."Error Reason":=ErrorText;
                end
                else
                begin
                    TempOutboundLog.Status:=TempOutboundLog.Status::Success;
                    TempOutboundLog."Error Reason":=''; //DNV Integration
                    UpdateVendorLedgerEntry(Code);
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
    APISetup: Record "Concur API Setup";
    ShowMess: Boolean;
    CU_TokenRequest: Codeunit "API Token Request";
    TempOutboundLog: Record "DNV Outbound Log" temporary;
    DNVOutboundLog: Record "DNV Outbound Log";
    VendorLedEntry: Record "Vendor Ledger Entry";
    VendLEntDocNo: code[20];
    EmpLEntDocNo: code[20];
    local procedure UpdateVendorLedgerEntry(var Code: code[20])
    begin
        VendorLedEntry.Reset();
        VendorLedEntry.SetFilter("Document Type", '%1', VendorLedEntry."Document Type"::Payment);
        VendorLedEntry.SetRange("Document No.", VendLEntDocNo);
        VendorLedEntry.SetRange("Exported to DNV", false);
        if VendorLedEntry.FindFirst()then VendorLedEntry."Exported to DNV":=true;
        if VendorLedEntry."Exported to DNV" = true then VendorLedEntry.Modify();
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
}
