codeunit 50124 "Bank API"
{
    trigger OnRun()
    begin
    end;
    var EndToEndId: Text;
    isCitiEnquiry: Boolean;
    StmtDate: Date;
    BankAPISetup: Record "Bank API Setup";
    HSBCAccNo: Text[30];
    isCitiStmt: Boolean;
    isCityPayment: Boolean;
    IsHSBCStmt: Boolean;
    CitiStmtId: Code[30];
    HttpClient: HttpClient;
    HttpContent: HttpContent;
    ContentHeaders, RequestHeaders: HttpHeaders;
    HttpRequestMessage: HttpRequestMessage;
    HttpResponseMessage: HttpResponseMessage;
    Content, Response: InStream;
    EntryNo: Integer;
    g_jObj: JsonObject;
    Source: Code[2];
    BankIntType2: Option " ", HSBC, BOC, Citi;
    RequestUrl: Text;
    ResponseStr: Text;
    XmlString: Text;
    CitiBankAccNo: Text[30];
    g_cod_BankDocNo: Code[35];
    procedure AddRequestHeader(reqHeader: Text; reqValue: Text)
    begin
        RequestHeaders.Add(reqHeader, reqValue);
    end;
    procedure GenCitiBody(requestStream: InStream; isStmInit: Text; encode: Boolean): JsonObject var
        Base64: Codeunit "Base64 Convert";
        jObj: JsonObject;
    begin
        Clear(jObj);
        if encode then jObj.Add('inputStr', Base64.ToBase64(requestStream))
        else
            jObj.ReadFrom(requestStream);
        jObj.Add('isStmInit', isStmInit);
        GetCitiKeys(jObj);
        exit(jObj);
    end;
    procedure SetStmtDate(p_dat_StmtDate: Date)
    begin
        StmtDate:=p_dat_StmtDate;
    end;
    procedure GenPgpReqBody(requestStream: InStream; Bank: Code[10]): JsonObject var
        Base64: Codeunit "Base64 Convert";
        jObj: JsonObject;
    begin
        Clear(jObj);
        jObj.Add('inputStr', Base64.ToBase64(requestStream));
        case Bank of 'HSBC': GetHSBCKeys(jObj);
        'BOC': GetBOCKeys(jObj);
        end;
        exit(jObj);
    end;
    procedure GenPgpReqBody(requestStr: Text; Bank: Code[10]): JsonObject var
        jObj: JsonObject;
    begin
        Clear(jObj);
        jObj.Add('inputStr', requestStr);
        case Bank of 'HSBC': GetHSBCKeys(jObj);
        'BOC': GetBOCKeys(jObj);
        end;
        exit(jObj);
    end;
    procedure GetCitiKeys(var jObj: JsonObject)
    var
        Base64: Codeunit "Base64 Convert";
        InStream: InStream;
        temp: Text;
    begin
        Clear(InStream);
        BankAPISetup.TestField("Citi Encryption Cert");
        BankAPISetup.TestField("Citi Signing Cert");
        BankAPISetup.TestField("Citi Client SSL Cert");
        BankAPISetup.TestField("Citi Client Encryption Cert");
        BankAPISetup.TestField("Citi Client Sign Cert");
        if BankAPISetup.Get()then;
        BankAPISetup.CalcFields("Citi Encryption Cert", "Citi Signing Cert", "Citi Client SSL Cert", "Citi Client Encryption Cert", "Citi Client Sign Cert");
        BankAPISetup."Citi Encryption Cert".CreateInStream((InStream));
        InStream.Read(temp);
        jObj.Add('citiEncryptB64', Base64.ToBase64(temp));
        Clear(InStream);
        BankAPISetup."Citi Signing Cert".CreateInStream(InStream);
        InStream.Read(temp);
        jObj.Add('citiSignB64', Base64.ToBase64(temp));
        jObj.Add('CustPermId', BankAPISetup."Citi WL ID + Branch Code");
        Clear(InStream);
        BankAPISetup."Citi Client SSL Cert".CreateInStream(InStream);
        InStream.Read(temp);
        jObj.Add('clientSslPrivB64', temp);
        Clear(InStream);
        BankAPISetup."Citi Client Encryption Cert".CreateInStream(InStream);
        InStream.Read(temp);
        jObj.Add('clientEncryptB64', temp);
        Clear(InStream);
        BankAPISetup."Citi Client Sign Cert".CreateInStream(InStream);
        InStream.Read(temp);
        jObj.Add('clientSignB64', temp);
        jObj.Add('clientId', BankAPISetup."Citi Client Id");
        jObj.Add('clientSecret', BankAPISetup."Citi Client Secret");
        jObj.Add('clientSslPrivPw', BankAPISetup."Citi Client SSL Password");
        jObj.Add('clientEncryptPw', BankAPISetup."Citi Client Encrypt Password");
        jObj.Add('clientSignPw', BankAPISetup."Citi Client Sign Password");
        jObj.Add('baseUrl', BankAPISetup."Citi API Base URL");
        jObj.Add('tokenEndpoint', BankAPISetup."Citi Token Endpoint");
        jObj.Add('stmTokenEndpoint', BankAPISetup."Citi Statement Token Endpoint");
        jObj.Add('paymentEndpoint', BankAPISetup."Citi Payment Endpoint");
        jObj.Add('initStatementEndpoint', BankAPISetup."Citi Statment Init Endpoint");
        jObj.Add('retriStatementEndpoint', BankAPISetup."Citi Statment Retriv. Endpoint");
        jObj.Add('paymentStatusEndpoint', BankAPISetup."Citi Payment Status Endpoint");
    end;
    procedure GetLogEntryNo(): Integer begin
        exit(EntryNo);
    end;
    procedure GetResponseText(): Text begin
        Response.ResetPosition();
        Response.Read(ResponseStr);
        exit(ResponseStr);
    end;
    procedure GetStautCode(): Integer begin
        exit(HttpResponseMessage.HttpStatusCode());
    end;
    procedure GetXMLElement(response: text; element: Text): Text var
        endPos: Integer;
        startPos: Integer;
        tmp: Text;
    begin
        Clear(tmp);
        startPos:=StrPos(response, '<' + element + '>');
        startPos:=startPos + StrLen(element) + 2;
        endPos:=StrPos(response, '</' + element + '>');
        if endPos - startPos > 0 then tmp:=CopyStr(response, startPos, endPos - startPos);
        exit(tmp);
    end;
    procedure InitClient(url: Text; endpoint: Text)
    var
        fullUrl: Text;
    begin
        ClearAll();
        isCityPayment:=false;
        IsHSBCStmt:=false;
        isCitiStmt:=false;
        if BankAPISetup.Get()then;
        fullUrl:=url + '/' + endpoint;
        HttpRequestMessage.SetRequestUri(fullUrl);
        RequestUrl:=fullUrl;
        HttpContent.GetHeaders(ContentHeaders);
        HttpRequestMessage.GetHeaders(RequestHeaders);
    end;
    /*  procedure LogDebug(msg: Text)
     var
         l_rec_APILOG: Record "Bank API Log";
     begin
         l_rec_APILOG.Init();
         l_rec_APILOG."API URL" := msg;
         l_rec_APILOG.Insert(true);
     end; */
    procedure Post()
    var
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        OutStream: OutStream;
    begin
        HttpRequestMessage.Method:='POST';
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage)then begin
            HttpResponseMessage.Content.ReadAs(Response);
            TempBlob.CreateOutStream(OutStream);
            TempBlob.CreateInStream(InStream);
            g_jObj.WriteTo(OutStream);
            Log(RequestUrl, HttpResponseMessage.HttpStatusCode, InStream, Response);
        end
        else
        begin
            HttpResponseMessage.Content.ReadAs(Response);
            TempBlob.CreateOutStream(OutStream);
            TempBlob.CreateInStream(InStream);
            g_jObj.WriteTo(OutStream);
            Log(RequestUrl, HttpResponseMessage.HttpStatusCode, InStream, Response);
        end;
    end;
    procedure SetCitiEnquiry(p_txt_EndtoEndId: Text)
    begin
        isCitiEnquiry:=true;
        EndToEndId:=p_txt_EndtoEndId;
    end;
    procedure Post2(BankIntType: Option " ", HSBC, BOC, Citi)
    var
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        OutStream: OutStream;
    begin
        HttpRequestMessage.Method:='POST';
        BankIntType2:=BankIntType;
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage)then begin
            HttpResponseMessage.Content.ReadAs(Response);
            TempBlob.CreateOutStream(OutStream);
            TempBlob.CreateInStream(InStream);
            g_jObj.WriteTo(OutStream);
            Log(RequestUrl, HttpResponseMessage.HttpStatusCode, InStream, Response);
        end
        else
        begin
            HttpResponseMessage.Content.ReadAs(Response);
            TempBlob.CreateOutStream(OutStream);
            TempBlob.CreateInStream(InStream);
            g_jObj.WriteTo(OutStream);
            Log(RequestUrl, HttpResponseMessage.HttpStatusCode, InStream, Response);
        end;
    end;
    procedure SetCitiDetails(var CitiStatementId: Record "Citi Inbound Statement Id")
    begin
        CitiStmtId:=CitiStatementId."Statement Id";
        CitiBankAccNo:=CitiStatementId."Bank Account No.";
        StmtDate:=CitiStatementId."Statement Date From";
    end;
    procedure SetCitiPayment(p_txt_EndtoEndId: Text)
    begin
        isCityPayment:=true;
        EndToEndId:=p_txt_EndtoEndId;
    end;
    procedure SetCitiStmt()
    begin
        isCitiStmt:=true;
    end;
    procedure SetContentType(contentType: Text)
    begin
        if ContentHeaders.Contains('Content-Type')then ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', contentType);
    end;
    procedure SetHSBCStmt()
    begin
        IsHSBCStmt:=true;
    end;
    procedure SetXml(InStream: InStream; BankDocNo: code[35])
    begin
        InStream.Read(XmlString);
        g_cod_BankDocNo:=BankDocNo;
    end;
    procedure WritePaymEnqRequestBody(RequestStr: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        Instream: InStream;
        jObj: JsonObject;
        OutStream: OutStream;
    begin
        jObj.Add('paymentEnquiryBase64', RequestStr);
        g_jObj:=jObj;
        TempBlob.CreateInStream(Instream);
        TempBlob.CreateOutStream(OutStream);
        jObj.WriteTo(OutStream);
        HttpContent.WriteFrom(Instream);
        HttpRequestMessage.Content:=HttpContent;
    end;
    procedure WriteRequestBody(jObj: JsonObject)
    var
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
    begin
        TempBlob.CreateOutStream(OutStream);
        TempBlob.CreateInStream(Content);
        g_jObj:=jObj;
        jObj.WriteTo(OutStream);
        HttpContent.WriteFrom(Content);
        HttpRequestMessage.Content:=HttpContent;
    end;
    procedure WriteRequestBody(RequestStr: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        Instream: InStream;
        jObj: JsonObject;
        OutStream: OutStream;
    begin
        jObj.Add('paymentBase64', RequestStr);
        g_jObj:=jObj;
        TempBlob.CreateInStream(Instream);
        TempBlob.CreateOutStream(OutStream);
        jObj.WriteTo(OutStream);
        HttpContent.WriteFrom(Instream);
        HttpRequestMessage.Content:=HttpContent;
    end;
    local procedure GetBOCKeys(var jObj: JsonObject)
    var
        Base64: Codeunit "Base64 Convert";
        InStream: InStream;
        temp: Text;
    begin
        Clear(InStream);
        BankAPISetup.TestField("BOC Private Key Password");
        BankAPISetup.TestField("BOC Private Key");
        BankAPISetup.TestField("BOC Public Key");
        BankAPISetup.CalcFields("BOC Public Key", "BOC Private Key");
        BankAPISetup."BOC Private Key".CreateInStream((InStream));
        InStream.Read(temp);
        jObj.Add('PrivateKey', Base64.ToBase64(temp));
        Clear(InStream);
        BankAPISetup."BOC Public Key".CreateInStream(InStream);
        InStream.Read(temp);
        jObj.Add('PublicKey', Base64.ToBase64(temp));
        jObj.Add('password', BankAPISetup."BOC Private Key Password");
    end;
    local procedure GetHSBCKeys(var jObj: JsonObject)
    var
        Base64: Codeunit "Base64 Convert";
        InStream: InStream;
        temp: Text;
    begin
        Clear(InStream);
        BankAPISetup.TestField("HSBC HK Private Key Password");
        BankAPISetup.TestField("HSBC HK Private Key");
        BankAPISetup.TestField("HSBC HK Public Key");
        BankAPISetup.CalcFields("HSBC HK Private Key", "HSBC HK Public Key");
        BankAPISetup."HSBC HK Private Key".CreateInStream((InStream));
        InStream.Read(temp);
        jObj.Add('PrivateKey', Base64.ToBase64(temp));
        Clear(InStream);
        BankAPISetup."HSBC HK Public Key".CreateInStream(InStream);
        InStream.Read(temp);
        jObj.Add('PublicKey', Base64.ToBase64(temp));
        jObj.Add('password', BankAPISetup."HSBC HK Private Key Password");
    end;
    local procedure Log(p_txt_url: Text; p_int_StatusCode: Integer; RequestInStream: InStream; ResponseInStream: InStream)
    var
        l_rec_APILog: Record "Bank API Log";
        OutStream: OutStream;
    begin
        Clear(l_rec_APILog);
        l_rec_APILog.Init();
        l_rec_APILog."API URL":=p_txt_url;
        l_rec_APILog."Status Code":=p_int_StatusCode;
        Clear(OutStream);
        l_rec_APILog."Request Json".CreateOutStream(OutStream);
        CopyStream(OutStream, RequestInStream);
        Clear(OutStream);
        l_rec_APILog."Response Json".CreateOutStream(OutStream);
        CopyStream(OutStream, ResponseInStream);
        ResponseInStream.Read(ResponseStr);
        if isCitiStmt then begin
            l_rec_APILog."Citi Status Code":=GetXMLElement(ResponseStr, 'httpCode');
            if StmtDate <> 0D then l_rec_APILog."Statement From Date":=StmtDate;
        end;
        if isCitiEnquiry then l_rec_APILog."Original End to End Id":=EndToEndId;
        if isCityPayment then begin
            l_rec_APILog."Txt Status":=GetXMLElement(ResponseStr, 'TxSts');
            // l_rec_APILog."Original End to End Id" := GetXMLElement(ResponseStr, 'OrgnlEndToEndId');
            l_rec_APILog."Original End to End Id":=EndToEndId;
        end;
        if XmlString <> '' then begin
            Clear(OutStream);
            l_rec_APILog."Xml String".CreateOutStream(OutStream);
            OutStream.Write(XmlString);
        end;
        if g_cod_BankDocNo <> '' then begin
            l_rec_APILog."Original End to End Id":=g_cod_BankDocNo;
        end;
        if(CitiStmtId <> '') and (CitiBankAccNo <> '')then begin
            l_rec_APILog."Citi Statement Id":=CitiStmtId;
            l_rec_APILog."Citi Bank Account No.":=CitiBankAccNo;
        end;
        if Source <> '' then l_rec_APILog.Source:=Source;
        if IsHSBCStmt then begin
            l_rec_APILog."HSBC MsgId":=GetXMLElement(ResponseStr, 'MsgId');
            l_rec_APILog."Citi Bank Account No.":=HSBCAccNo;
            if StmtDate <> 0D then l_rec_APILog."Statement From Date":=StmtDate;
        end;
        l_rec_APILog."Bank Integration Type":=BankIntType2;
        l_rec_APILog.Insert(true);
        Commit();
        EntryNo:=l_rec_APILog."Entry No.";
    end;
    procedure SetSource(var p_cod_Source: Code[2])
    begin
        Source:=p_cod_Source;
    end;
    procedure SetHSBCAccNo(var p_txt_BankAccNo: Text[30])
    begin
        HSBCAccNo:=p_txt_BankAccNo;
    end;
}
