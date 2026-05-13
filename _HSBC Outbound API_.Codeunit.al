codeunit 50159 "HSBC Outbound API"
{
    trigger OnRun()
    begin
        API();
    end;
    var BankAPI: Codeunit "Bank API";
    g_TempBlob: Codeunit "Temp Blob";
    Error: Boolean;
    BankLogEntryNo: Integer;
    ResponseStr: Text;
    local procedure API()
    var
        HSBCSetup: Record "HSBC Batch Setup";
        HSBCOutbound: Record "HSBC Outbound Staging Table";
    begin
        ClearAll();
        HSBCSetup.Reset();
        HSBCSetup.SetRange(Processed, false);
        if HSBCSetup.FindFirst()then repeat HSBCOutbound.Reset();
                HSBCOutbound.SetRange("Batch Type", HSBCSetup."Batch Type");
                HSBCOutbound.SetRange("Batch Id", HSBCSetup."Batch No.");
                HSBCOutbound.SetFilter(Status, '%1|%2', HSBCOutbound.Status::Pending, HSBCOutbound.Status::Fail);
                // HSBCOutbound.Setrange(Status, HSBCOutbound.Status::Pending);//TEC.VJ 27NOV2024
                if HSBCOutbound.FindSet()then begin
                    APICall(HSBCOutbound);
                    if not Error then begin
                        // HSBCSetup.Processed := true;
                        HSBCSetup."Bank Log Entry No.":=BankLogEntryNo;
                        HSBCSetup.Modify();
                    end;
                end;
            until HSBCSetup.Next() = 0;
    end;
    local procedure APICall(var OutBound: Record "HSBC Outbound Staging Table")
    begin
        GenerateXML(OutBound);
        BankLogEntryNo:=BankAPI.GetLogEntryNo();
        Encrypt(OutBound."Bank Document No.");
        PostToBank(OutBound."Bank Integration Type");
        UpdateOutboundStagingStatus(OutBound);
        Decrypt();
    end;
    local procedure Decrypt()
    var
        BankAPISetup: Record "Bank API Setup";
        jObj: JsonObject;
        jToken: JsonToken;
    begin
        Clear(BankAPI);
        if BankAPISetup.Get()then;
        BankAPI.InitClient(BankAPISetup."PGP Base API Url", 'pgpdecrypt');
        jObj.ReadFrom(ResponseStr);
        if jObj.Get('responseBase64', jToken)then begin
            jToken.WriteTo(ResponseStr);
            ResponseStr:=Text.DelChr(ResponseStr, '=', '"');
            BankAPI.WriteRequestBody(BankAPI.GenPgpReqBody(ResponseStr, 'HSBC'));
            BankAPI.Post();
            ResponseStr:=BankAPI.GetResponseText();
        end;
    // Message(Format(BankAPI.GetStautCode()) + ' ' + ResponseStr);
    end;
    local procedure Encrypt(BankDocNo: Code[35])
    var
        BankAPISetup: Record "Bank API Setup";
        InStream: InStream;
    begin
        Clear(BankAPI);
        g_TempBlob.CreateInStream(InStream);
        if BankAPISetup.Get()then;
        BankAPI.InitClient(BankAPISetup."PGP Base API Url", 'pgpencrypt');
        BankAPI.WriteRequestBody(BankAPI.GenPgpReqBody(InStream, 'HSBC'));
        InStream.ResetPosition();
        BankAPI.SetXml(InStream, BankDocNo);
        BankAPI.Post();
        ResponseStr:=BankAPI.GetResponseText();
    end;
    local procedure GenerateXML(var OutBound: Record "HSBC Outbound Staging Table")
    var
        HK_HighValueXML: XmlPort "HSBC High Value XML";
        HK_LowValueXML: XmlPort "HSBC Low Value XML";
        US_HighValueXML: XmlPort "HSBC US High Value XML";
        US_LowValueXML: XmlPort "HSBC US Low Value XML";
        OutStream: OutStream;
    begin
        Clear(g_TempBlob);
        g_TempBlob.CreateOutStream(OutStream);
        case OutBound."Batch Type" of OutBound."Batch Type"::"HK Upper Value": begin
            HK_HighValueXML.SetRecord(OutBound);
            HK_HighValueXML.SetTableView(OutBound);
            HK_HighValueXML.SetDestination(OutStream);
            HK_HighValueXML.Export();
        end;
        OutBound."Batch Type"::"HK Lower Value": begin
            HK_LowValueXML.SetRecord(OutBound);
            HK_LowValueXML.SetTableView(OutBound);
            HK_LowValueXML.SetDestination(OutStream);
            HK_LowValueXML.Export();
        end;
        OutBound."Batch Type"::"US Upper Value": begin
            US_HighValueXML.SetRecord(OutBound);
            US_HighValueXML.SetTableView(OutBound);
            US_HighValueXML.SetDestination(OutStream);
            US_HighValueXML.Export();
        end;
        OutBound."Batch Type"::"US Lower Value": begin
            US_LowValueXML.SetRecord(OutBound);
            US_LowValueXML.SetTableView(OutBound);
            US_LowValueXML.SetDestination(OutStream);
            US_LowValueXML.Export();
        end;
        end;
    end;
    local procedure PostToBank(BankIntType: Option " ", HSBC, BOC, Citi)
    var
        BankAPISetup: Record "Bank API Setup";
    begin
        Clear(BankAPI);
        if BankAPISetup.Get()then;
        BankAPI.InitClient(BankAPISetup."HSBC HK Base API Url", BankAPISetup."HSBC Bulk Payment Endpoint");
        BankAPI.SetContentType('application/json');
        BankAPI.AddRequestHeader('x-hsbc-profile-id', BankAPISetup."x-hsbc-profile-id");
        BankAPI.AddRequestHeader('x-hsbc-client-id', BankAPISetup."x-hsbc-client-id");
        BankAPI.AddRequestHeader('x-hsbc-client-secret', BankAPISetup."x-hsbc-client-secret");
        BankAPI.AddRequestHeader('x-payload-type', BankAPISetup."x-payload-type");
        BankAPI.WriteRequestBody(ResponseStr);
        BankAPI.Post2(BankIntType);
        ResponseStr:=BankAPI.GetResponseText();
    end;
    local procedure UpdateOutboundStagingStatus(var HSBCOutbound: Record "HSBC Outbound Staging Table")
    var
        Outbound: Record "HSBC Outbound Staging Table";
        BankStatus: Integer;
        jObj: JsonObject;
        jToken: JsonToken;
        StatusCode: Code[5];
        CreateRejBatchLines: codeunit "Create Rejection Batch Lines";
        GenJnlLine: Record "Gen. Journal Line";
    begin
        BankStatus:=BankAPI.GetStautCode();
        if BankStatus = 200 then Error:=false
        else
            Error:=true;
        Outbound.Reset();
        Outbound.CopyFilters(HSBCOutbound);
        if Outbound.FindFirst()then repeat //NT_ 20250813 >>
                // if BankStatus = 200 then begin
                //     Outbound.Status := Outbound.Status::Sent;
                // end else begin
                //     Outbound.Status := Outbound.Status::Fail;
                // end;
                if BankStatus = 200 then begin
                    Outbound.Status:=Outbound.Status::Sent;
                end
                else
                begin
                    jObj.ReadFrom(ResponseStr);
                    if jObj.Get('statusCode', jToken)then begin
                        StatusCode:=jToken.AsValue().AsText();
                    end;
                    if StatusCode = 'RJCT' then begin
                        Outbound.Status:=Outbound.Status::Rejected;
                        GenJnlLine.Reset();
                        GenJnlLine.SetRange("Bank Document No.", Outbound."Bank Document No.");
                        IF GenJnlLine.FindSet()then CreateRejBatchLines.Run(GenJnlLine);
                    end
                    else
                        Outbound.Status:=Outbound.Status::Fail;
                end;
                //NT_ 20250813 <<
                Outbound.Modify();
            until Outbound.Next() = 0;
    end;
}
