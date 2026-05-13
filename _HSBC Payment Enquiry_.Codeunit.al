codeunit 50184 "HSBC Payment Enquiry"
{
    trigger OnRun()
    var
        HSBCOutbound: Record "HSBC Outbound Staging Table";
        PaymentEnqStatusSetup: Record "Payment Enquiry Status Setup";
        FilterText: Text;
    begin
        Clear(FilterText);
        PaymentEnqStatusSetup.Reset();
        PaymentEnqStatusSetup.SetRange(Reprocess, true);
        if PaymentEnqStatusSetup.FindFirst()then repeat if FilterText <> '' then FilterText+='|';
                FilterText+=Format(PaymentEnqStatusSetup.Status);
            until PaymentEnqStatusSetup.Next() = 0;
        HSBCOutbound.Reset();
        HSBCOutbound.SetFilter(Status, FilterText);
        if HSBCOutbound.FindFirst()then repeat Encrypt(HSBCOutbound);
                PostToBank();
                Decrypt();
                UpdateTable();
            until HSBCOutbound.Next() = 0;
    end;
    local procedure UpdateTable()
    var
        HSBCOutbound: Record "HSBC Outbound Staging Table";
        StatusMapping: Record "Bank API status Mapping";
        endtoendid: Text;
        txsts: Text;
        addinf: Text;
    begin
        endtoendid:=BankAPI.GetXMLElement(ResponseStr, 'OrgnlEndToEndId');
        txsts:=BankAPI.GetXMLElement(ResponseStr, 'TxSts');
        addinf:=BankAPI.GetXMLElement(ResponseStr, 'AddtlInf');
        if HSBCOutbound.Get(endtoendid)then begin
            // if StatusMapping.Get(txsts) then begin
            //     // HSBCOutbound."API Status" := StatusMapping."API Status (BC)";
            //     AssignStatus(HSBCOutbound, StatusMapping);//TEC.VJ 07012025
            // end;
            HSBCOutbound."API Information":=addinf;
            HSBCOutbound.Modify();
        end;
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
    local procedure Encrypt(var Outbound: Record "HSBC Outbound Staging Table")
    var
        BankAPISetup: Record "Bank API Setup";
        InStream: InStream;
        OutStream: OutStream;
        RequestStr: Text;
    begin
        Clear(BankAPI);
        g_TempBlob.CreateInStream(InStream);
        g_TempBlob.CreateOutStream(OutStream);
        if BankAPISetup.Get()then;
        BankAPI.InitClient(BankAPISetup."PGP Base API Url", 'pgpencrypt');
        // RequestStr := StrSubstNo(RequestBody, 'PC12345678', '', '', '', '19474762-4b12-4641-9fc4-dca636650620');
        RequestStr:=StrSubstNo(RequestBody, BankAPISetup."x-hsbc-profile-id", Outbound."Bank Document No.");
        OutStream.WriteText(RequestStr);
        BankAPI.WriteRequestBody(BankAPI.GenPgpReqBody(InStream, 'HSBC'));
        InStream.ResetPosition();
        BankAPI.SetXml(InStream, Outbound."Bank Document No.");
        g_cod_BankDocNo:=Outbound."Bank Document No.";
        BankAPI.Post();
        ResponseStr:=BankAPI.GetResponseText();
    end;
    local procedure PostToBank()
    var
        BankAPISetup: Record "Bank API Setup";
        RequestStr: Text;
        l_rec_StatusMapping: Record "Bank API status Mapping";
        l_rec_Outbound: Record "HSBC Outbound Staging Table";
        JObj: JsonObject;
        JToken: JsonToken;
        StatusCodeValue: Text;
    begin
        Clear(BankAPI);
        if BankAPISetup.Get()then;
        BankAPI.InitClient(BankAPISetup."HSBC HK Base API Url", BankAPISetup."HSBC Payment Status Endpoint");
        BankAPI.SetContentType('application/json');
        BankAPI.AddRequestHeader('x-hsbc-profile-id', BankAPISetup."x-hsbc-profile-id");
        BankAPI.AddRequestHeader('x-hsbc-client-id', BankAPISetup."x-hsbc-client-id");
        BankAPI.AddRequestHeader('x-hsbc-client-secret', BankAPISetup."x-hsbc-client-secret");
        BankAPI.AddRequestHeader('x-payload-type', BankAPISetup."x-payload-type");
        BankAPI.WritePaymEnqRequestBody(ResponseStr);
        BankAPI.Post();
        ResponseStr:=BankAPI.GetResponseText();
        if JObj.ReadFrom(ResponseStr)then begin
            if JObj.Get('statusCode', JToken)then begin
                StatusCodeValue:=JToken.AsValue().AsText();
                if l_rec_StatusMapping.Get(StatusCodeValue)then;
                if l_rec_Outbound.Get(g_cod_BankDocNo)then;
                AssignStatus(l_rec_Outbound, l_rec_StatusMapping);
                l_rec_Outbound.Modify();
            end;
        end;
    end;
    //TEC.VJ>>
    local procedure AssignStatus(var HSBCOutbound: Record "HSBC Outbound Staging Table"; StatusMapping: Record "Bank API status Mapping")
    var
        CreateRejBatchLines: codeunit "Create Rejection Batch Lines";
        GenJnlLine: Record "Gen. Journal Line";
    begin
        case StatusMapping."API Status (BC)" of StatusMapping."API Status (BC)"::Approved: HSBCOutbound.Status:=HSBCOutbound.Status::Approved;
        StatusMapping."API Status (BC)"::Rejected: begin
            HSBCOutbound.Status:=HSBCOutbound.Status::Rejected;
            GenJnlLine.Reset();
            GenJnlLine.SetRange("Bank Document No.", HSBCOutbound."Bank Document No.");
            IF GenJnlLine.FindSet()then CreateRejBatchLines.Run(GenJnlLine);
        end;
        StatusMapping."API Status (BC)"::Fail: HSBCOutbound.Status:=HSBCOutbound.Status::Fail;
        StatusMapping."API Status (BC)"::"Bank Process": HSBCOutbound.Status:=HSBCOutbound.Status::"Bank Process";
        StatusMapping."API Status (BC)"::Booked: HSBCOutbound.Status:=HSBCOutbound.Status::Booked;
        StatusMapping."API Status (BC)"::Pending: HSBCOutbound.Status:=HSBCOutbound.Status::Pending;
        StatusMapping."API Status (BC)"::Sent: HSBCOutbound.Status:=HSBCOutbound.Status::Sent;
        StatusMapping."API Status (BC)"::Settled: HSBCOutbound.Status:=HSBCOutbound.Status::Settled;
        end;
    end;
    //TEC.VJ<< 07012025
    var RequestBody: Label '<StatusEnquiry><ProfileID>%1</ProfileID><Key><InstructionID></InstructionID><MessageID></MessageID><PmtInfID></PmtInfID><ReferenceID></ReferenceID><EndToEndID>%2</EndToEndID></Key></StatusEnquiry>';
    BankAPI: Codeunit "Bank API";
    ResponseStr: Text;
    g_TempBlob: Codeunit "Temp Blob";
    g_cod_BankDocNo: Code[35];
}
