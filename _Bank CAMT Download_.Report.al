report 50165 "Bank CAMT Download"
{
    ApplicationArea = All;
    Caption = 'Bank CAMT Download';
    UsageCategory = Documents;
    ProcessingOnly = true;
    UseRequestPage = true;

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Filters)
                {
                    field(Bank; Bank)
                    {
                        ApplicationArea = All;
                    }
                    field(bankType; bankType)
                    {
                        ApplicationArea = all;
                    }
                    field(g_dat_FromDate; g_dat_FromDate)
                    {
                        ApplicationArea = All;
                        Caption = 'From Date';
                    }
                    field(g_dat_ToDate; g_dat_ToDate)
                    {
                        ApplicationArea = All;
                        Caption = 'To Date';
                    }
                    field(BankAccount; BankAccount)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
        trigger OnClosePage()
        begin
            if(BankAccount = '') or (g_dat_FromDate = 0D) or (g_dat_ToDate = 0D)then exit;
            case Bank of Bank::CITI: begin
                case bankType of bankType::CAMT52: begin
                    CITI52();
                end;
                bankType::CAMT53: begin
                    CITI53();
                end;
                end;
            end;
            Bank::HSBC: begin
                case bankType of bankType::CAMT52: begin
                    HSBC52();
                end;
                bankType::CAMT53: begin
                    HSBC53();
                end;
                end;
            end;
            end;
        end;
    }
    var g_cod_FormatName: code[30];
    g_cod_StatementId: Code[30];
    g_dat_FromDate: Date;
    g_dat_ToDate: Date;
    jObj: JsonObject;
    bankType: Option CAMT53, CAMT52;
    Bank: Option HSBC, CITI;
    ResponseStr: Text;
    BankAccount: Text[30];
    local procedure AddTemplateName(BankAccNo: Code[20]; var jObj: JsonObject; bankType: Integer)
    var
        TemplateNameMapping: Record "Citi Template Name Mapping";
    begin
        if TemplateNameMapping.Get(BankAccNo)then begin
            if bankType = 52 then jObj.Add('templateName', TemplateNameMapping."CAMT52 Template Name");
            if bankType = 53 then jObj.Add('templateName', TemplateNameMapping."CAMT53 Template Name");
            if bankType = 0 then jObj.Add('templateName', 'none');
        end;
    end;
    local procedure CITI52()
    var
        BankAPISetup: Record "Bank API Setup";
        CitiInboundStatement: Record "Citi Inbound Statement Id";
        BankAPI: Codeunit "Bank API";
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        jObj: JsonObject;
        OutStream: OutStream;
        DateStr: Text;
        filename: Text;
        XmlDoc: XmlDocument;
        XmlNs: XmlNamespaceManager;
        Node: XmlNode;
    begin
        Clear(BankAPI);
        Clear(jObj);
        TempBlob.CreateInStream(InStream);
        TempBlob.CreateOutStream(OutStream);
        if BankAPISetup.Get()then;
        BankAPI.InitClient(BankAPISetup."PGP Base API Url", 'CitiStatement');
        jObj.Add('formatName', 'CAMT_052_001_02');
        jObj.Add('accountNumber', BankAccount);
        DateStr:=Format(g_dat_FromDate, 0, '<Year4>-<Month,2>-<Day,2>');
        jObj.Add('fromDate', DateStr);
        DateStr:=Format(g_dat_ToDate, 0, '<Year4>-<Month,2>-<Day,2>');
        jObj.Add('toDate', DateStr);
        AddTemplateName(BankAccount, jObj, 52);
        jObj.WriteTo(OutStream);
        BankAPI.WriteRequestBody(BankAPI.GenCitiBody(InStream, 'true', false));
        BankAPI.Post();
        ResponseStr:=BankAPI.GetResponseText();
        XmlDocument.ReadFrom(ResponseStr, XmlDoc);
        XmlNs.AddNamespace('ns', 'http://com.citi.citiconnect/services/types/inquiries/statement/v1');
        XmlDoc.SelectSingleNode('/ns:statementInitiationResponse/ns:statementId', XmlNs, Node);
        g_cod_StatementId:=Node.AsXmlElement().InnerText;
        RetrieveStatement(g_cod_StatementId);
        Clear(TempBlob);
        Clear(InStream);
        Clear(OutStream);
        TempBlob.CreateInStream(InStream);
        TempBlob.CreateOutStream(OutStream);
        OutStream.WriteText(ResponseStr);
        filename:=StrSubstNo('%1-%2_%3_%4%5.xml', g_dat_FromDate, g_dat_ToDate, BankAccount, Format(Bank), Format(bankType));
        DownloadFromStream(InStream, '', '', '', filename);
    end;
    local procedure CITI53()
    var
        BankAPISetup: Record "Bank API Setup";
        BankAPI: Codeunit "Bank API";
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        OutStream: OutStream;
        jObj: JsonObject;
        XmlDoc: XmlDocument;
        Node: XmlNode;
        XmlNs: XmlNamespaceManager;
        CitiInboundStatement: Record "Citi Inbound Statement Id";
        DateStr: Text;
        filename: Text;
    begin
        Clear(BankAPI);
        Clear(jObj);
        TempBlob.CreateInStream(InStream);
        TempBlob.CreateOutStream(OutStream);
        if BankAPISetup.Get()then;
        BankAPI.InitClient(BankAPISetup."PGP Base API Url", 'CitiStatement');
        jObj.Add('formatName', 'CAMT_053_001_02');
        jObj.Add('accountNumber', BankAccount);
        DateStr:=Format(g_dat_FromDate, 0, '<Year4>-<Month,2>-<Day,2>');
        jObj.Add('fromDate', DateStr);
        DateStr:=Format(g_dat_ToDate, 0, '<Year4>-<Month,2>-<Day,2>');
        jObj.Add('toDate', DateStr);
        AddTemplateName(BankAccount, jObj, 0);
        jObj.WriteTo(OutStream);
        BankAPI.WriteRequestBody(BankAPI.GenCitiBody(InStream, 'true', false));
        BankAPI.Post();
        ResponseStr:=BankAPI.GetResponseText();
        XmlDocument.ReadFrom(ResponseStr, XmlDoc);
        XmlNs.AddNamespace('ns', 'http://com.citi.citiconnect/services/types/inquiries/statement/v1');
        XmlDoc.SelectSingleNode('/ns:statementInitiationResponse/ns:statementId', XmlNs, Node);
        g_cod_StatementId:=Node.AsXmlElement().InnerText;
        RetrieveStatement(g_cod_StatementId);
        Clear(TempBlob);
        Clear(InStream);
        Clear(OutStream);
        TempBlob.CreateInStream(InStream);
        TempBlob.CreateOutStream(OutStream);
        OutStream.WriteText(ResponseStr);
        filename:=StrSubstNo('%1-%2_%3_%4%5.xml', g_dat_FromDate, g_dat_ToDate, BankAccount, Format(Bank), Format(bankType));
        DownloadFromStream(InStream, '', '', '', filename);
    end;
    local procedure Decrypt()
    var
        BankAPISetup: Record "Bank API Setup";
        BankAPI: Codeunit "Bank API";
        Json: Codeunit "JSON Management";
    begin
        Clear(BankAPI);
        Clear(BankAPISetup);
        if BankAPISetup.Get()then;
        BankAPI.InitClient(BankAPISetup."PGP Base API Url", 'pgpdecrypt');
        Json.InitializeObject(ResponseStr);
        Json.GetStringPropertyValueByName('reportBase64', ResponseStr);
        BankAPI.WriteRequestBody(BankAPI.GenPgpReqBody(ResponseStr, 'HSBC'));
        BankAPI.Post();
        ResponseStr:=BankAPI.GetResponseText();
        Message(ResponseStr);
    end;
    local procedure Encrypt()
    var
        BankAPISetup: Record "Bank API Setup";
        BankAPI: Codeunit "Bank API";
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        OutStream: OutStream;
    begin
        Clear(BankAPI);
        TempBlob.CreateInStream(InStream);
        TempBlob.CreateOutStream(OutStream);
        jObj.WriteTo(OutStream);
        if BankAPISetup.Get()then;
        BankAPI.InitClient(BankAPISetup."PGP Base API Url", 'pgpencrypt');
        BankAPI.WriteRequestBody(BankAPI.GenPgpReqBody(InStream, 'HSBC'));
        BankAPI.Post();
        ResponseStr:=BankAPI.GetResponseText();
    end;
    local procedure GenStmtRequest(isIntra: Boolean; accNumber: text[30])
    var
        BankAPISetup: Record "Bank API Setup";
    begin
        Clear(BankAPISetup);
        Clear(jObj);
        if BankAPISetup.Get()then;
        if isIntra then begin
            jObj.Add('transactionDate', Format(g_dat_FromDate, 0, '<Year4>-<Month,2>-<Day,2>'));
            jObj.Add('transactionTimeFrom', '00:00');
            jObj.Add('transactionTimeTo', '23:59');
        end
        else
            jObj.Add('transactionDate', Format(g_dat_FromDate, 0, '<Year4>-<Month,2>-<Day,2>'));
        jObj.Add('accountNumber', accNumber);
        jObj.Add('accountCountry', BankAPISetup."HSBC Account Country");
        jObj.Add('institutionCode', BankAPISetup."HSBC Institution Code");
        jObj.Add('accountType', BankAPISetup."HSBC Account Type");
        jObj.Add('bankTransactionType', 'BAI');
    end;
    local procedure HSBC52()
    var
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        OutStream: OutStream;
        filename: Text;
    begin
        GenStmtRequest(true, BankAccount);
        Encrypt();
        PostToBank();
        Decrypt();
        TempBlob.CreateInStream(InStream);
        TempBlob.CreateOutStream(OutStream);
        OutStream.WriteText(ResponseStr);
        filename:=StrSubstNo('%1_%2_%3%4.xml', g_dat_FromDate, BankAccount, Format(Bank), Format(bankType));
        DownloadFromStream(InStream, '', '', '', filename);
    end;
    local procedure HSBC53()
    var
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        OutStream: OutStream;
        filename: Text;
    begin
        GenStmtRequest(false, BankAccount);
        Encrypt();
        PostToBank();
        Decrypt();
        TempBlob.CreateInStream(InStream);
        TempBlob.CreateOutStream(OutStream);
        OutStream.WriteText(ResponseStr);
        filename:=StrSubstNo('%1_%2_%3%4.xml', g_dat_FromDate, BankAccount, Format(Bank), Format(bankType));
        DownloadFromStream(InStream, '', '', '', filename);
    end;
    local procedure PostToBank()
    var
        APISETUP: Record "Bank API Setup";
        API: Codeunit "Bank API";
        l_jObj: JsonObject;
    begin
        if APISETUP.Get()then;
        API.InitClient(APISETUP."HSBC HK Base API Url", APISETUP."HSBC Statement Endpoint");
        API.SetContentType('application/json');
        l_jObj.Add('transactionsRequestBase64', ResponseStr);
        API.AddRequestHeader('x-hsbc-profile-id', APISETUP."x-hsbc-profile-id");
        API.AddRequestHeader('x-hsbc-client-id', APISETUP."x-hsbc-client-id");
        API.AddRequestHeader('x-hsbc-client-secret', APISETUP."x-hsbc-client-secret");
        API.AddRequestHeader('x-report-type', 'CAMT');
        API.WriteRequestBody(l_jObj);
        API.Post();
        ResponseStr:=API.GetResponseText();
    end;
    local procedure RetrieveStatement(StatementId: Code[30])
    var
        BankAPISetup: Record "Bank API Setup";
        BankAPI: Codeunit "Bank API";
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        jObj: JsonObject;
        OutStream: OutStream;
    begin
        Clear(BankAPI);
        Clear(jObj);
        TempBlob.CreateInStream(InStream);
        TempBlob.CreateOutStream(OutStream);
        if BankAPISetup.Get()then;
        BankAPI.InitClient(BankAPISetup."PGP Base API Url", 'CitiStatement');
        jObj.Add('statementId', StatementId);
        jObj.WriteTo(OutStream);
        BankAPI.WriteRequestBody(BankAPI.GenCitiBody(InStream, 'false', false));
        BankAPI.Post();
        ResponseStr:=BankAPI.GetResponseText();
    end;
}
