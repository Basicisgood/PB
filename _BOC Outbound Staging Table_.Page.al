page 50195 "BOC Outbound Staging Table"
{
    ApplicationArea = All;
    Caption = 'BOC Outbound Staging';
    PageType = List;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(API)
            {
                ApplicationArea = all;

                trigger OnAction()
                begin
                    // Encrypt();
                    CallBank();
                end;
            }
        }
    }
    local procedure CallBank()
    begin
        Clear(BankAPI);
        BankAPI.InitClient('https://gdbapiusmf.ftcwifi.com/', 'api/admin/pre-e2ee');
        BankAPI.AddRequestHeader('platformAc', '01227468735905');
        BankAPI.AddRequestHeader('keyName', '0001');
        BankAPI.AddRequestHeader('messageId', '20241022100503623');
        BankAPI.AddRequestHeader('requestTime', '2024/10/22 10:05:03 GMT+08:00');
        BankAPI.Post();
    end;
    local procedure Encrypt()
    var
        BankAPISetup: Record "Bank API Setup";
        InStream: InStream;
        jObj: JsonObject;
        b64: Codeunit "Base64 Convert";
    begin
        Clear(BankAPI);
        // g_TempBlob.CreateInStream(InStream);
        if BankAPISetup.Get()then;
        BankAPI.InitClient(BankAPISetup."PGP Base API Url", 'pgpencrypt');
        jObj.Add('changePwd', 'N');
        BankAPI.WriteRequestBody(BankAPI.GenPgpReqBody(b64.ToBase64(Format(jObj)), 'BOC'));
        BankAPI.Post();
        ResponseStr:=BankAPI.GetResponseText();
        Message(ResponseStr);
    end;
    var BankAPI: Codeunit "Bank API";
    g_TempBlob: Codeunit "Temp Blob";
    ResponseStr: Text;
}
