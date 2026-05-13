codeunit 50151 "API Account Insert/Update Req"
{
    trigger OnRun()
    begin
        GLAccountInsert(0);
        Sleep(1000);
        GLAccountInsert(1);
    end;
    procedure GLAccountInsert(P_Type: Option Insert, Update): Text var
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
            APISetup.TestField("Account Create URL");
            TokenUrl:=APISetup."Account Create URL";
        end
        else if P_Type = 1 then begin
                APISetup.TestField("Account Update URL");
                TokenUrl:=APISetup."Account Update URL";
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
            //   Message('Success');
            ResponseMessage.Content().ReadAs(JsonResponseTxt);
            ProcessJasonresponse(JsonResponseTxt);
        // Message('%1', JsonResponseTxt);
        end
        else
        begin
            ResponseMessage.Content().ReadAs(JsonResponseTxt);
        // Message('JsonResponse Text%1', JsonResponseTxt);
        //message('Error %1', CopyStr(GetLastErrorText(), 1, 100));
        end;
    end;
    procedure PrepareBody(P_Type: Option Insert, Update): Text var
        GLAcc: Record "G/L Account";
        RecDefDim: Record "Default Dimension";
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
        DVNOutbound.SetRange("Table No.", 15);
        DVNOutbound.SetRange("Entry Type", P_Type);
        DVNOutbound.SetFilter(Status, '<>%1', DVNOutbound.Status::Success);
        IF DVNOutbound.FindFirst()then begin
            clear(JArray2);
            repeat if GLAcc.GET(DVNOutbound."Primary key")then begin
                    clear(GLObject);
                    GLObject.Add('Code', copystr(GLAcc."No.", 4));
                    GLObject.Add('Name', GLAcc.Name);
                    GLObject.Add('Remark', GLAcc.Remarks);
                    GLObject.Add('IsValid', not GLAcc.Blocked);
                    RecDefDim.reset;
                    RecDefDim.SetRange(RecDefDim."Table ID", 15);
                    //RecDefDim.SetRange("No.", GLAcc."No.");
                    RecDefDim.SetRange("No.", GLAcc."No." + 'XXXXXXXXXX'); // temp dime block
                    IF RecDefDim.FindFirst()then begin
                        clear(JArray);
                        repeat clear(DefDimObject);
                            DefDimObject.Add('Code', RecDefDim."Dimension Code");
                            IF RecDefDim."Value Posting" = RecDefDim."Value Posting"::"Code Mandatory" then DefDimObject.Add('IsMandatory', true)
                            else
                                DefDimObject.Add('IsMandatory', false);
                            DefDimObject.Add('DefaultValueCode', RecDefDim."Dimension Value Code");
                            JArray.Add(DefDimObject);
                        until RecDefDim.Next() = 0;
                    end;
                    GLObject.Add('FinancialDimensionRelations', JArray);
                    GLObject.Add('ExternalId', copystr(GLAcc."No.", 4));
                    JArray2.Add(GLObject);
                    TempOutboundLog.Init();
                    TempOutboundLog.TransferFields(DVNOutbound);
                    TempOutboundLog.Insert();
                end;
            until DVNOutbound.Next() = 0;
        end;
        JArray2.WriteTo(JsonData);
        //Message('Request :%1', JsonData);
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
        GLAccountNo: code[20];
        ErrorText: Text[1000];
        DnvSetup: Record "DNV Integration Setup";
    begin
        DnvSetup.Get();
        //Message('Temp Count %1', TempOutboundLog.Count);
        JsonBuffer.DeleteAll();
        //Message('response...%1', P_Jason);
        JsonBuffer2.ReadFromText(P_Jason);
        //        Message('%1..Json Count', JsonBuffer2.Count);
        JsonBuffer2.reset;
        JsonBuffer2.SetRange(Depth, 3);
        JsonBuffer2.SetRange("Token type", JsonBuffer2."Token type"::String);
        IF JsonBuffer2.FindLast()then TotalObjectNo:=JsonBuffer2."Object Number";
        // Message('%1..ObjectNumber', TotalObjectNo);
        for i:=1 To TotalObjectNo Do begin
            GLAccountNo:='';
            ErrorText:='';
            JsonBuffer2.SetRange("Object Number");
            JsonBuffer2.SetRange(Error);
            IF JsonBuffer2.findset then JsonBuffer2.SetRange("Object Number", i);
            IF JsonBuffer2.FindFirst()then GLAccountNo:=JsonBuffer2.Value;
            IF JsonBuffer2.findset then JsonBuffer2.SetRange(JsonBuffer2.Error, true);
            IF JsonBuffer2.FindFirst()then ErrorText:=CopyStr(JsonBuffer2.Value, 1, 999);
            TempOutboundLog.reset;
            TempOutboundLog.SetRange("Primary key", DnvSetup."G/L Account Initials Sync" + GLAccountNo);
            IF TempOutboundLog.FindFirst()then begin
                IF ErrorText <> '' then begin
                    TempOutboundLog.Status:=TempOutboundLog.Status::Error;
                    TempOutboundLog."Error Reason":=ErrorText;
                end
                else
                begin
                    TempOutboundLog.Status:=TempOutboundLog.Status::Success;
                    TempOutboundLog."Error Reason":='';
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
    APISetup: Record "DNV Integration Setup";
    CU_TokenRequest: Codeunit "API Token Request";
    TempOutboundLog: Record "DNV Outbound Log" temporary;
    DNVOutboundLog: Record "DNV Outbound Log";
}
