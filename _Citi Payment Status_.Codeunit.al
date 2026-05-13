codeunit 50187 "Citi Payment Status"
{
    Permissions = tabledata "Employee Ledger Entry"=RIMD;

    trigger OnRun()
    var
        CitiOutBound: Record "Citi Outbound Staging Table";
        PaymentEnqStatusSetup: Record "Payment Enquiry Status Setup";
        FilterText: Text;
    begin
        Clear(FilterText);
        PaymentEnqStatusSetup.Reset();
        PaymentEnqStatusSetup.SetRange(Reprocess, true);
        if PaymentEnqStatusSetup.FindFirst()then repeat if FilterText <> '' then FilterText+='|';
                FilterText+=Format(PaymentEnqStatusSetup.Status);
            until PaymentEnqStatusSetup.Next() = 0;
        ClearAll();
        CitiOutBound.Reset();
        CitiOutBound.SetRange(Processed, true);
        CitiOutBound.SetFilter(Status, FilterText);
        if CitiOutBound.FindSet()then repeat PaymentEnquiry(CitiOutBound."Bank Document No.");
                UpdateTable();
            until CitiOutBound.Next() = 0;
    end;
    var ResponseStr: Text;
    g_EndToEndId: Text;
    local procedure PaymentEnquiry(EndToEndId: Text)
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
        Clear(g_EndToEndId);
        g_EndToEndId:=EndToEndId;
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
        if CitiOutBound.Get(g_EndToEndId)then begin
            if endtoendid = 'Not Available' then begin
                CitiOutBound.Status:=CitiOutBound.Status::Fail;
            end
            else
            begin
                if StatusMapping.Get(txsts)then begin
                    // CitiOutBound."API Status" := StatusMapping."API Status (BC)";
                    AssignStatus(CitiOutBound, StatusMapping); //TEC.VJ 07012025
                end;
            end;
            CitiOutBound."API Information":=addinf;
            CitiOutBound.TxSts:=txsts; //NT_ 20250729
            CitiOutBound.Modify();
        end;
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
//TEC.VJ<< 07012025
}
