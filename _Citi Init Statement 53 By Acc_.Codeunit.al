codeunit 50221 "Citi Init Statement 53 By Acc"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        BankAPISetup: Record "Bank API Setup";
        BankAPI: Codeunit "Bank API";
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        OutStream: OutStream;
        jObj: JsonObject;
        ResponseStr: Text;
        XmlDoc: XmlDocument;
        Node: XmlNode;
        XmlNs: XmlNamespaceManager;
        CitiInboundStatement: Record "Citi Inbound Statement Id";
        BankAccount: Record "Bank Account";
        DateStr: Text;
        l_cod_Source: Code[2];
        BankAccList: Text;
        l_cod_StatementId: Code[30];
    begin
        Rec.TestField("Parameter String");
        Clear(BankAPI);
        Clear(jObj);
        TempBlob.CreateInStream(InStream);
        TempBlob.CreateOutStream(OutStream);
        if BankAPISetup.Get()then;
        BankAPI.InitClient(BankAPISetup."PGP Base API Url", 'CitiStatement');
        DateStr:=Format(Today - 1, 0, '<Year4>-<Month,2>-<Day,2>');
        jObj.Add('formatName', 'CAMT_053_001_02');
        jObj.Add('accountNumber', Rec."Parameter String");
        jObj.Add('fromDate', DateStr);
        jObj.Add('toDate', DateStr);
        AddTemplateName(Rec."Parameter String", jObj);
        jObj.WriteTo(OutStream);
        BankAPI.WriteRequestBody(BankAPI.GenCitiBody(InStream, 'true', false));
        l_cod_Source:='53';
        BankAPI.SetSource(l_cod_Source);
        BankAPI.SetCitiStmt();
        BankAPI.Post();
        ResponseStr:=BankAPI.GetResponseText();
        XmlDocument.ReadFrom(ResponseStr, XmlDoc);
        XmlNs.AddNamespace('ns', 'http://com.citi.citiconnect/services/types/inquiries/statement/v1');
        if XmlDoc.SelectSingleNode('/ns:statementInitiationResponse/ns:statementId', XmlNs, Node)then l_cod_StatementId:=Node.AsXmlElement().InnerText
        else
            exit;
        CitiInboundStatement.Init();
        CitiInboundStatement."Statement Id":=l_cod_StatementId;
        CitiInboundStatement."Format Name":='CAMT_053_001_02';
        CitiInboundStatement."Bank Account No.":=CompanyName;
        CitiInboundStatement."Statement Date From":=Today - 1;
        CitiInboundStatement.Retrieved:=false;
        CitiInboundStatement.Insert();
    end;
    local procedure AddTemplateName(BankAccNo: Code[20]; var jObj: JsonObject)
    var
        TemplateNameMapping: Record "Citi Template Name Mapping";
    begin
        if TemplateNameMapping.Get(BankAccNo)then jObj.Add('templateName', TemplateNameMapping."CAMT53 Template Name")
        else
            Error('Template name not found.');
    end;
}
