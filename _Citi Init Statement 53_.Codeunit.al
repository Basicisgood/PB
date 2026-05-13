codeunit 50182 "Citi Init Statement 53"
{
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
        BankAccount.Reset();
        BankAccount.SetCurrentKey("Currency Code Custom");
        BankAccount.SetAscending("Currency Code Custom", false);
        BankAccount.SetRange("Bank Integration Type", BankAccount."Bank Integration Type"::Citi);
        BankAccount.SetFilter("Bank Statement from API", '=%1|%2', BankAccount."Bank Statement from API"::CAMT53, BankAccount."Bank Statement from API"::"CAMT52 & 53");
        if BankAccount.FindFirst()then repeat if BankAccList <> '' then BankAccList+=',';
                BankAccList+=BankAccount."Bank Account No.";
            until BankAccount.Next() = 0;
        Clear(BankAPI);
        Clear(jObj);
        TempBlob.CreateInStream(InStream);
        TempBlob.CreateOutStream(OutStream);
        if BankAPISetup.Get()then;
        BankAPI.InitClient(BankAPISetup."PGP Base API Url", 'CitiStatement');
        DateStr:=Format(Today - 1, 0, '<Year4>-<Month,2>-<Day,2>');
        jObj.Add('formatName', 'CAMT_053_001_02');
        // jObj.Add('accountNumber', BankAccount."Bank Account No.");
        jObj.Add('accountNumber', BankAccList);
        jObj.Add('fromDate', DateStr);
        jObj.Add('toDate', DateStr);
        AddTemplateName(CompanyName, jObj);
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
        if TemplateNameMapping.Get(BankAccNo)then jObj.Add('templateName', TemplateNameMapping."CAMT53 Template Name");
    end;
}
