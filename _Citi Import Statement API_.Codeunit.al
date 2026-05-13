codeunit 50164 "Citi Import Statement API"
{
    trigger OnRun()
    var
        CitiStatementId: Record "Citi Inbound Statement Id";
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        OutStream: OutStream;
        DTPlus15mins: DateTime;
        StatusCode: Integer;
        Citi52: XmlPort CitiCAMT52;
        Citi53: XmlPort CitiCAMT53;
    begin
        ClearAll();
        CitiStatementId.Reset();
        CitiStatementId.SetRange(Retrieved, false);
        CitiStatementId.SetCurrentKey(SystemCreatedAt);
        CitiStatementId.SetAscending(SystemCreatedAt, true);
        if(CitiStatementId.FindFirst())then begin
            // repeat
            DTPlus15mins:=CitiStatementId.SystemCreatedAt + (60 * 15 * 1000);
            if(CurrentDateTime <= DTPlus15mins)then exit;
            RetrieveStatement(CitiStatementId, StatusCode);
            TempBlob.CreateInStream(InStream);
            TempBlob.CreateOutStream(OutStream);
            OutStream.WriteText(ResponseStr);
            case CitiStatementId."Format Name" of 'CAMT_053_001_02': begin
                Clear(Citi53);
                Citi53.SetSource(InStream);
                if not Citi53.Import()then begin
                    CitiStatementId.Status:=CitiStatementId.Status::Error;
                    CitiStatementId."Error Msg":=GetLastErrorText();
                end;
            end;
            'CAMT_052_001_02': begin
                Clear(Citi52);
                Citi52.SetSource(InStream);
                if not Citi52.Import()then begin
                    CitiStatementId.Status:=CitiStatementId.Status::Error;
                    CitiStatementId."Error Msg":=GetLastErrorText();
                end;
            end;
            end;
            if StatusCode = 200 then CitiStatementId.Retrieved:=true;
            if StatusCode = 500 then CitiStatementId.Retrieved:=false;
            CitiStatementId.Modify();
        end;
    //     Sleep(900000);
    // until CitiStatementId.Next() = 0;
    end;
    var ResponseStr: Text;
    local procedure RetrieveStatement(var CitiStatementId: Record "Citi Inbound Statement Id"; var StatusCode: Integer)
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
        BankAPI.SetCitiDetails(CitiStatementId);
        jObj.Add('statementId', CitiStatementId."Statement Id");
        // jObj.Add('statementId', '111111114');
        //CAMT_053_001_02 111111112
        //CAMT_052_001_02 111111114
        jObj.WriteTo(OutStream);
        BankAPI.WriteRequestBody(BankAPI.GenCitiBody(InStream, 'false', false));
        BankAPI.Post();
        ResponseStr:=BankAPI.GetResponseText();
        StatusCode:=BankAPI.GetStautCode();
    // Message(ResponseStr);
    end;
}
