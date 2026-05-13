codeunit 50161 "HSBC Inbound CAMT52"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        OutStream: OutStream;
        BankAccount: Record "Bank Account";
        HSBCXml: XmlPort "HSBC Inbound CAMT 52";
        ErrorLog: Record "HSBC API Inbound Error Log";
    begin
        BankAccount.Reset();
        BankAccount.SetRange("Bank Integration Type", BankAccount."Bank Integration Type"::HSBC);
        BankAccount.SetFilter("Bank Statement from API", '=%1|%2', BankAccount."Bank Statement from API"::CAMT52, BankAccount."Bank Statement from API"::"CAMT52 & 53");
        if Rec."Parameter String" <> '' then BankAccount.SetFilter("Country/Region Code", Rec."Parameter String");
        if BankAccount.FindFirst()then repeat // ClearAll();
                GenStmtRequest(true, BankAccount);
                Encrypt();
                PostToBank();
                if g_int_HttpStatusCode <> 200 then exit;
                Decrypt(BankAccount."Bank Account No.");
                Clear(TempBlob);
                Clear(InStream);
                Clear(OutStream);
                TempBlob.CreateInStream(InStream);
                TempBlob.CreateOutStream(OutStream);
                OutStream.WriteText(ResponseStr);
                Clear(HSBCXml);
                HSBCXml.SetSource(InStream);
                if not HSBCXml.Import()then begin
                    Clear(ErrorLog);
                    ErrorLog.Init();
                    ErrorLog."Bank Account No.":=BankAccount."Bank Account No.";
                    ErrorLog."Statement Date":=Today;
                    ErrorLog."Error Msg":=GetLastErrorText();
                    ErrorLog.Insert();
                end;
            until BankAccount.Next() = 0;
    end;
    var jObj: JsonObject;
    ResponseStr: Text;
    g_int_HttpStatusCode: Integer;
    local procedure Decrypt(BankAccNo: Text[30])
    var
        BankAPISetup: Record "Bank API Setup";
        BankAPI: Codeunit "Bank API";
        Json: Codeunit "JSON Management";
        l_cod_Source: Code[2];
    begin
        Clear(BankAPI);
        Clear(BankAPISetup);
        if BankAPISetup.Get()then;
        BankAPI.InitClient(BankAPISetup."PGP Base API Url", 'pgpdecrypt');
        Json.InitializeObject(ResponseStr);
        Json.GetStringPropertyValueByName('reportBase64', ResponseStr);
        BankAPI.WriteRequestBody(BankAPI.GenPgpReqBody(ResponseStr, 'HSBC'));
        l_cod_Source:='52';
        BankAPI.SetSource(l_cod_Source);
        BankAPI.SetHSBCAccNo(BankAccNo);
        BankAPI.SetStmtDate(Today);
        BankAPI.SetHSBCStmt();
        BankAPI.Post();
        ResponseStr:=BankAPI.GetResponseText();
    // Message(ResponseStr);
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
    local procedure GenStmtRequest(isIntra: Boolean; BankAccount: Record "Bank Account")
    var
        BankAPISetup: Record "Bank API Setup";
        totDateTime: DateTime;
    begin
        Clear(BankAPISetup);
        Clear(jObj);
        if BankAPISetup.Get()then;
        totDateTime:=CurrentDateTime - (1000 * 60);
        if isIntra then begin
            jObj.Add('transactionDate', Format(Today, 0, '<Year4>-<Month,2>-<Day,2>'));
            jObj.Add('transactionTimeFrom', '00:00');
            jObj.Add('transactionTimeTo', '23:59');
        end
        else
            jObj.Add('transactionDate', Format(BankAPISetup."HSBC Last Statement DateTime", 0, '<Year4>-<Month,2>-<Day,2>'));
        jObj.Add('accountNumber', BankAccount."Bank Account No.");
        jObj.Add('accountCountry', BankAccount."Country/Region Code");
        jObj.Add('institutionCode', Format(BankAccount."HSBC Institution Code"));
        jObj.Add('accountType', BankAccount."HSBC Account Type");
        jObj.Add('bankTransactionType', 'BAI');
    /* BankAPISetup."HSBC Last Statement DateTime" := CurrentDateTime;
        BankAPISetup.Modify(); */
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
        g_int_HttpStatusCode:=API.GetStautCode();
    end;
}
