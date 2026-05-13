codeunit 50162 "Citi Outbound API"
{
    trigger OnRun()
    var
        CitiOutBound: Record "Citi Outbound Staging Table";
        CitiOutBound2: Record "Citi Outbound Staging Table";
        CitiSetup: Record "HSBC Batch Setup";
    begin
        ClearAll();
        CitiOutBound.Reset();
        CitiOutBound.SetRange("Bank Integration Type", CitiOutBound."Bank Integration Type"::Citi);
        CitiOutBound.SetFilter(Status, '%1|%2', CitiOutBound.Status::Pending, CitiOutBound.Status::Fail);
        CitiOutBound.SetRange(Processed, false);
        if CitiOutBound.FindFirst()then repeat CitiOutBound2.Reset();
                CitiOutBound2.SetRange("Bank Document No.", CitiOutBound."Bank Document No.");
                CitiOutBound2.FindFirst();
                if PaymentEnquiry(CitiOutBound2."Bank Document No.")then begin //NT_ 02-25-2025
                    GenerateXML(CitiOutBound2);
                    PostToBank(CitiOutBound2."Bank Integration Type", CitiOutBound2."Bank Document No.");
                    UpdateOutboundStagingStatus(CitiOutBound2); //VJ09DEC2024
                /* //VJ 08Jan2025 commented to remove multiple modify error from standad BC
                                                               IF Error = FALSE then BEGIN
                                                                   CitiOutBound2.Processed := true;
                                                                   CitiOutBound2.Modify();
                                                               END;
                                                               */
                end
                else //NT_ 02-25-2025
                    UpdateTable(); //NT_ 02-25-2025
            until CitiOutBound.Next() = 0;
    end;
    local procedure PostToBank(BankIntType: Option " ", HSBC, BOC, Citi; EndToEndId: Text)
    var
        BankAPISetup: Record "Bank API Setup";
        InStream: InStream;
    begin
        Clear(BankAPI);
        g_TempBlob.CreateInStream(InStream);
        if BankAPISetup.Get()then;
        BankAPI.InitClient(BankAPISetup."PGP Base API Url", 'CitiPaymentInit');
        BankAPI.SetCitiPayment(EndToEndId);
        BankAPI.WriteRequestBody(BankAPI.GenCitiBody(InStream, 'false', true));
        InStream.ResetPosition();
        BankAPI.SetXml(InStream, '');
        BankAPI.Post2(BankIntType);
    end;
    local procedure GenerateXML(var OutBound: Record "Citi Outbound Staging Table")
    var
        Citi403: XmlPort "Citi 403 XML";
        Citi949: XmlPort "Citi 949 XML";
        Citi393: XmlPort "Citi 393 XML";
        Citi392: XmlPort "Citi 392 XML";
        Citi391: XmlPort "Citi 391 XML";
        OutStream: OutStream;
    begin
        Clear(g_TempBlob);
        g_TempBlob.CreateOutStream(OutStream);
        // BankAPI.LogDebug('Generating XML');
        case OutBound."Batch Type" of //outbound."Batch Type"::FP403:
        outbound."Batch Type"::CITI403: //>>VJ06DEC2024 Changed
 begin
            Citi403.SetRecord(OutBound);
            Citi403.SetTableView(OutBound);
            Citi403.SetDestination(OutStream);
            Citi403.Export();
        end;
        OutBound."Batch Type"::CITI949: begin
            Citi949.SetRecord(OutBound);
            Citi949.SetTableView(OutBound);
            Citi949.SetDestination(OutStream);
            Citi949.Export();
        end;
        OutBound."Batch Type"::CITI393: begin
            Citi393.SetRecord(OutBound);
            Citi393.SetTableView(OutBound);
            Citi393.SetDestination(OutStream);
            Citi393.Export();
        end;
        OutBound."Batch Type"::CITI391: begin
            Citi391.SetRecord(OutBound);
            Citi391.SetTableView(OutBound);
            Citi391.SetDestination(OutStream);
            Citi391.Export();
        end;
        OutBound."Batch Type"::CITI392: begin
            Citi392.SetRecord(OutBound);
            Citi392.SetTableView(OutBound);
            Citi392.SetDestination(OutStream);
            Citi392.Export();
        end;
        end;
    end;
    //>>VJ09DEC2024
    local procedure UpdateOutboundStagingStatus(var CitiOutbound: Record "Citi Outbound Staging Table")
    var
        Outbound: Record "Citi Outbound Staging Table";
        BankStatus: Integer;
    begin
        BankStatus:=BankAPI.GetStautCode();
        Error:=false;
        Outbound.Reset();
        Outbound.CopyFilters(CitiOutbound);
        if Outbound.FindFirst()then repeat if BankStatus = 200 then begin
                    Outbound.Status:=Outbound.Status::Sent;
                    Outbound.Processed:=true; //VJ 08Jan2025 added moved from above
                    Outbound.Modify();
                end
                else
                begin
                    Outbound.Status:=Outbound.Status::Fail;
                    Outbound.Modify();
                    Error:=true;
                end;
            until Outbound.Next() = 0;
    end;
    //<<VJ09DEC2024
    local procedure PaymentEnquiry(EndToEndId: Text)Continue: Boolean var
        BankAPISetup: Record "Bank API Setup";
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        jObj: JsonObject;
        OutStream: OutStream;
        Result: Text;
    begin
        Clear(BankAPI);
        Clear(jObj);
        TempBlob.CreateInStream(InStream);
        TempBlob.CreateOutStream(OutStream);
        if BankAPISetup.Get()then;
        BankAPI.InitClient(BankAPISetup."PGP Base API Url", 'CitiPaymEnquiry');
        BankAPI.SetCitiEnquiry(EndToEndId);
        jObj.Add('EndToEndId', EndToEndId);
        jObj.WriteTo(OutStream);
        BankAPI.WriteRequestBody(BankAPI.GenCitiBody(InStream, 'false', false));
        BankAPI.Post();
        ResponseStr:=BankAPI.GetResponseText();
        Result:=BankAPI.GetXMLElement(ResponseStr, 'OrgnlEndToEndId');
        // BankAPI.LogDebug(StrSubstNo('%1 %2', EndToEndId, Result));
        exit(Result = 'Not Available');
    // Message(ResponseStr);
    end;
    local procedure UpdateTable()
    var
        StatusMapping: Record "Bank API status Mapping";
        CitiOutBound: Record "Citi Outbound Staging Table";
        BankAPI: Codeunit "Bank API";
        addinf: Text;
        endtoendid: Text;
        txsts: Text;
    begin
        endtoendid:=BankAPI.GetXMLElement(ResponseStr, 'OrgnlEndToEndId');
        txsts:=BankAPI.GetXMLElement(ResponseStr, 'TxSts');
        addinf:=BankAPI.GetXMLElement(ResponseStr, 'AddtlInf');
        if CitiOutBound.Get(endtoendid)then begin
            if StatusMapping.Get(txsts)then begin
                // CitiOutBound."API Status" := StatusMapping."API Status (BC)";
                AssignStatus(CitiOutBound, StatusMapping); //TEC.VJ 07012025
            end;
            CitiOutBound."API Information":=addinf;
            CitiOutBound.Processed:=true;
            CitiOutBound.Modify();
        end;
    // BankAPI.LogDebug('Record found. Not processing payment');
    end;
    //TEC.VJ>>
    local procedure AssignStatus(var CitiOutbound: Record "Citi Outbound Staging Table"; StatusMapping: Record "Bank API status Mapping")
    var
        CreateRejBatchLines: codeunit "Create Rejection Batch Lines";
        GenJnlLine: Record "Gen. Journal Line";
    begin
        case StatusMapping."API Status (BC)" of StatusMapping."API Status (BC)"::Approved: CitiOutbound.Status:=CitiOutbound.Status::Approved;
        StatusMapping."API Status (BC)"::Rejected: begin
            CitiOutbound.Status:=CitiOutbound.Status::Rejected;
            GenJnlLine.Reset();
            GenJnlLine.SetRange("Bank Document No.", CitiOutbound."Bank Document No.");
            IF GenJnlLine.FindSet()then CreateRejBatchLines.Run(GenJnlLine);
        end;
        StatusMapping."API Status (BC)"::Fail: CitiOutbound.Status:=CitiOutbound.Status::Fail;
        StatusMapping."API Status (BC)"::"Bank Process": CitiOutbound.Status:=CitiOutbound.Status::"Bank Process";
        StatusMapping."API Status (BC)"::Booked: CitiOutbound.Status:=CitiOutbound.Status::Booked;
        StatusMapping."API Status (BC)"::Pending: CitiOutbound.Status:=CitiOutbound.Status::Pending;
        StatusMapping."API Status (BC)"::Sent: CitiOutbound.Status:=CitiOutbound.Status::Sent;
        StatusMapping."API Status (BC)"::Settled: CitiOutbound.Status:=CitiOutbound.Status::Settled;
        end;
    end;
    var g_TempBlob: Codeunit "Temp Blob";
    BankAPI: Codeunit "Bank API";
    ResponseStr: Text;
    Error: Boolean;
}
