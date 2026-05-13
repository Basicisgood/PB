codeunit 50147 "Worldlink Spot Rate Job"
{
    trigger OnRun()
    begin
        PostToBank();
    end;
    local procedure PostToBank()
    var
        BankAPISetup: Record "Bank API Setup";
        InStream: InStream;
        BankAPI: Codeunit "Bank API";
        TempBlob: Codeunit "Temp Blob";
        jObj: JsonObject;
        JsonObject: JsonObject;
        JsonToken: JsonToken;
        CurRate: Decimal;
        WordLinkSPotRate: Record "Worldlink Spot Rate";
    begin
        Clear(BankAPI);
        TempBlob.CreateInStream(InStream);
        if BankAPISetup.Get()then;
        BankAPI.InitClient(BankAPISetup."PGP Base API Url", 'CitiFxRate');
        Clear(jObj);
        BankAPI.GetCitiKeys(jObj);
        BankAPI.WriteRequestBody(jObj);
        BankAPI.Post();
        JsonObject.ReadFrom(BankAPI.GetResponseText());
        JsonObject.Get('IFX', JsonToken);
        JsonToken.AsObject().Get('BankSvcRs', JsonToken);
        JsonToken.AsObject().Get('ForExRateInqRs', JsonToken);
        JsonToken.AsObject().Get('ForExRateRec', JsonToken);
        JsonToken.AsObject().Get('ForExRateInfo', JsonToken);
        JsonToken.AsObject().Get('CurRate', JsonToken);
        CurRate:=JsonToken.AsValue().AsDecimal();
        WordLinkSPotRate.Reset();
        WordLinkSPotRate.Init();
        WordLinkSPotRate.Date:=Today;
        WordLinkSPotRate."From Currency":='USD';
        WordLinkSPotRate."To Currency":='INR';
        WordLinkSPotRate.Rate:=CurRate;
        WordLinkSPotRate.Insert();
    end;
}
