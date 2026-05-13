codeunit 50152 "API Contact Insert/Update"
{
    trigger OnRun()
    begin
        ContactInsert(0);
        Sleep(1000);
        ContactInsert(1);
    end;
    procedure ContactInsert(P_Type: Option Insert, Update): Text var
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
        DNVOutLog: record "DNV Outbound Log";
    begin
        APISetup.GET;
        APISetup.TestField("Is Enable", true);
        DNVOutLog.reset;
        DNVOutLog.SetRange("Table No.", 23);
        DNVOutLog.SetFilter(Status, '=%1', DNVOutLog.Status::Pending);
        IF P_Type = 0 then begin
            APISetup.TestField("Contact Create URL");
            TokenUrl:=APISetup."Contact Create URL";
            DNVOutLog.SetRange("Entry Type", DNVOutLog."Entry Type"::Insert);
        end
        else if P_Type = 1 then begin
                APISetup.TestField("Contact Update URL");
                TokenUrl:=APISetup."Contact Update URL";
                DNVOutLog.SetRange("Entry Type", DNVOutLog."Entry Type"::Update);
            end;
        if not DNVOutLog.FindSet()then exit;
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
        Outstr.WriteText(PrepareBody(P_Type, DNVOutLog."Entry No."));
        TempBlob.CreateInStream(Instr);
        Content.WriteFrom(Instr);
        RequestMessage.Content(Content);
        HttpClient.Send(RequestMessage, ResponseMessage);
        IF ResponseMessage.IsSuccessStatusCode()THEN BEGIN
            //Message('Success');
            ResponseMessage.Content().ReadAs(JsonResponseTxt);
            ProcessJasonresponse(JsonResponseTxt);
        //Message('%1', JsonResponseTxt);
        end
        else
        begin
            ResponseMessage.Content().ReadAs(JsonResponseTxt);
            if GuiAllowed then begin
                Message('JsonResponse Text%1', JsonResponseTxt);
                message(GetLastErrorText);
            end;
        end;
    end;
    procedure PrepareBody(P_Type: Option Insert, Update; mEntryNo: Integer): Text var
        RecVend: Record Vendor;
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
        DVNOutbound.SetRange("Table No.", 23);
        DVNOutbound.SetRange("Entry Type", P_Type);
        DVNOutbound.SetFilter(Status, '<>%1', DVNOutbound.Status::Success);
        if mEntryNo <> 0 then DVNOutbound.SetRange("Entry No.", mEntryNo);
        IF DVNOutbound.FindFirst()then begin
            clear(JArray2);
            repeat RecVend.Reset();
                RecVend.SetRange("DNV Vendor No.", DVNOutbound."Primary key");
                if not RecVend.FindSet()then begin
                    RecVend.Reset();
                    RecVend.SetRange("No.", DVNOutbound."Primary key");
                end;
                if RecVend.FindSet()then begin
                    clear(GLObject);
                    GLObject.Add('Name', RecVend."Name");
                    GLObject.Add('Name2', RecVend."Name 2");
                    if RecVend."DNV Vendor No." <> '' then GLObject.Add('CreditorNumber', RecVend."DNV Vendor No.")
                    else
                        GLObject.Add('CreditorNumber', RecVend."No.");
                    GLObject.Add('ShortName', CopyStr(RecVend."Search Name", 1, 10));
                    GLObject.Add('Remark', RecVend.Remarks);
                    GLObject.Add('Area', RecVend."Area");
                    GLObject.Add('Street', RecVend.Address);
                    GLObject.Add('Street2', RecVend."Address 2");
                    GLObject.Add('ZipCode', RecVend."Post Code");
                    GLObject.Add('Town', RecVend.City);
                    GLObject.Add('CountryCode', RecVend."Country/Region Code");
                    GLObject.Add('EMail', RecVend."E-Mail");
                    GLObject.Add('Fax', RecVend."Fax No.");
                    GLObject.Add('Phone', RecVend."Phone No.");
                    GLObject.Add('CellPhone', RecVend."Mobile Phone No.");
                    GLObject.Add('Telex', RecVend."Telex No.");
                    GLObject.Add('WebSite', RecVend."Home Page");
                    GLObject.Add('IsAgent', RecVend."Is Agent");
                    GLObject.Add('IsDeliveryAddress', RecVend."Is Delivery Address");
                    GLObject.Add('IsDockyardPhone', RecVend."Is Dockyard");
                    GLObject.Add('IsManufacturer', RecVend."Is Manufacturer");
                    GLObject.Add('IsService', RecVend."Is Service");
                    GLObject.Add('IsSupplier', RecVend."Is Supplier");
                    GLObject.Add('IsInvoiceAddress  ', RecVend."Is Invoice Address");
                    if RecVend."InActive Date" <> 0D then GLObject.Add('InvalidFrom', RecVend."InActive Date");
                    GLObject.Add('CurrencyCode', RecVend."Currency Code");
                    GLObject.Add('TransmissionFormat', CopyStr(format(RecVend."Transmission Format"), 1, 1));
                    if RecVend."DNV Vendor No." = '' then GLObject.Add('ExternalId', RecVend."No.")
                    else
                        GLObject.Add('ExternalId', RecVend."DNV Vendor No.");
                    JArray2.Add(GLObject);
                    TempOutboundLog.Init();
                    TempOutboundLog.TransferFields(DVNOutbound);
                    TempOutboundLog.Insert();
                end
                else
                begin
                    DVNOutbound.Status:=DVNOutbound.Status::Error;
                    DVNOutbound."Error Reason":='Vendor Not found';
                    DVNOutbound.Modify();
                end;
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
        VendNo: code[20];
        ErrorText: Text[1000];
        PKEntryNo: Integer;
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
            VendNo:='';
            ErrorText:='';
            JsonBuffer2.SetRange("Object Number");
            JsonBuffer2.SetRange(Error);
            IF JsonBuffer2.findset then JsonBuffer2.SetRange("Object Number", i);
            JsonBuffer2.SetRange("Token type");
            JsonBuffer2.SetRange("Token type", JsonBuffer2."Token type"::"Property Name");
            //JsonBuffer2.SetRange(Value, 'ExternalId');//DNV Integration
            JsonBuffer2.Setfilter(Value, '=%1|%2', 'ExternalId', 'CreditorNumber'); //DNV Integration
            IF JsonBuffer2.FindFirst()then PKEntryNo:=JsonBuffer2."Entry No.";
            JsonBuffer2.SetRange(Value);
            JsonBuffer2.SetRange("Token type");
            JsonBuffer2.SetRange("Token type", JsonBuffer2."Token type"::String); //DNV Integration
            JsonBuffer2.SetRange("Entry No.", PKEntryNo + 1);
            if JsonBuffer2.FindFirst()then VendNo:=JsonBuffer2.Value;
            if GuiAllowed then begin
                if VendNo = '' then begin
                    JsonBuffer2.Reset();
                    Page.Run(Page::"JSon Buffer List", JsonBuffer2);
                end;
            end;
            JsonBuffer2.SetRange("Entry No.");
            IF JsonBuffer2.findset then JsonBuffer2.SetRange(JsonBuffer2.Error, true);
            IF JsonBuffer2.FindFirst()then ErrorText:=CopyStr(JsonBuffer2.Value, 1, 999);
            TempOutboundLog.reset;
            TempOutboundLog.SetRange("Primary key", VendNo);
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
