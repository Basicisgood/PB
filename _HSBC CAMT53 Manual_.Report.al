report 50122 "HSBC CAMT53 Manual"
{
    Caption = 'HSBC CAMT53 Manual';
    ApplicationArea = all;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Bank Account"; "Bank Account")
        {
            DataItemTableView = sorting("No.");

            trigger OnPreDataItem()
            begin
                SetRange("Bank Account No.", g_txt_BankAccount);
                SetFilter("Bank Statement from API", '%1|%2', "Bank Statement from API"::"CAMT52 & 53", "Bank Statement from API"::CAMT53);
            end;
            trigger OnAfterGetRecord()
            var
                TempBlob: Codeunit "Temp Blob";
                InStream: InStream;
                OutStream: OutStream;
                ErrorLog: Record "HSBC API Inbound Error Log";
                StartDate: Date;
                EndDate: Date;
            begin
                // ClearAll();
                GenStmtRequest(false, "Bank Account");
                Encrypt();
                PostToBank();
                Decrypt("Bank Account"."Bank Account No.");
                Clear(TempBlob);
                Clear(InStream);
                Clear(OutStream);
                TempBlob.CreateInStream(InStream);
                TempBlob.CreateOutStream(OutStream);
                OutStream.WriteText(ResponseStr);
                if not Xmlport.Import(Xmlport::"HSBC Inbound CAMT 53", InStream)then begin
                    Clear(ErrorLog);
                    ErrorLog.Init();
                    ErrorLog."Bank Account No.":="Bank Account"."Bank Account No.";
                    ErrorLog."Statement Date":=g_dat_StatementDate;
                    ErrorLog."Error Msg":=GetLastErrorText();
                    ErrorLog.Insert();
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                field(g_dat_StatementDate; g_dat_StatementDate)
                {
                    Caption = 'Statement Date';
                    ApplicationArea = all;
                }
                field(g_txt_BankAccount; g_txt_BankAccount)
                {
                    Caption = 'Bank Account No.';
                    Editable = false;
                    ApplicationArea = all;
                }
            }
        }
    }
    var jObj: JsonObject;
    ResponseStr: Text;
    g_txt_XML: Text;
    g_dat_StatementDate: Date;
    g_txt_BankAccount: Text[30];
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
        l_cod_Source:='53';
        BankAPI.SetSource(l_cod_Source);
        BankAPI.SetHSBCAccNo(BankAccNo);
        BankAPI.SetStmtDate(g_dat_StatementDate);
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
    local procedure GenStmtRequest(isIntra: Boolean; BankAccount: Record "Bank Account");
    var
        BankAPISetup: Record "Bank API Setup";
    begin
        Clear(BankAPISetup);
        Clear(jObj);
        if BankAPISetup.Get()then;
        if isIntra then begin
            jObj.Add('transactionDate', Format(Today, 0, '<Year4>-<Month,2>-<Day,2>'));
            jObj.Add('transactionTimeFrom', '00:00');
            jObj.Add('transactionTimeTo', '23:59');
        end
        else
            jObj.Add('transactionDate', Format(g_dat_StatementDate, 0, '<Year4>-<Month,2>-<Day,2>'));
        jObj.Add('accountNumber', BankAccount."Bank Account No.");
        jObj.Add('accountCountry', BankAccount."Country/Region Code");
        jObj.Add('institutionCode', Format(BankAccount."HSBC Institution Code"));
        jObj.Add('accountType', BankAccount."HSBC Account Type");
        jObj.Add('bankTransactionType', 'BAI');
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
        g_txt_XML:=ResponseStr;
    end;
    procedure SetBankAccountNo(BankAccNo: Text[30])
    begin
        g_txt_BankAccount:=BankAccNo;
    end;
}
