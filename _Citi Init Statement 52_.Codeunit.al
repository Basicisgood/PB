codeunit 50163 "Citi Init Statement 52"
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
    begin
        Clear(BankAccList);
        BankAccount.Reset();
        BankAccount.SetCurrentKey("Currency Code Custom");
        BankAccount.SetAscending("Currency Code Custom", false);
        BankAccount.SetRange("Bank Integration Type", BankAccount."Bank Integration Type"::Citi);
        BankAccount.SetFilter("Bank Statement from API", '=%1|%2', BankAccount."Bank Statement from API"::CAMT52, BankAccount."Bank Statement from API"::"CAMT52 & 53");
        if BankAccount.FindFirst()then repeat if BankAccList <> '' then BankAccList+=',';
                BankAccList+=BankAccount."Bank Account No.";
            until BankAccount.Next() = 0;
        Clear(BankAPI);
        Clear(jObj);
        TempBlob.CreateInStream(InStream);
        TempBlob.CreateOutStream(OutStream);
        if BankAPISetup.Get()then;
        BankAPI.InitClient(BankAPISetup."PGP Base API Url", 'CitiStatement');
        DateStr:=Format(Today, 0, '<Year4>-<Month,2>-<Day,2>');
        jObj.Add('formatName', 'CAMT_052_001_02');
        // jObj.Add('accountNumber', BankAccount."Bank Account No.");
        jObj.Add('accountNumber', BankAccList);
        jObj.Add('fromDate', DateStr);
        jObj.Add('toDate', DateStr);
        // AddTemplateName(BankAccount."Bank Account No.", jObj);
        AddTemplateName(CompanyName, jObj);
        jObj.WriteTo(OutStream);
        BankAPI.WriteRequestBody(BankAPI.GenCitiBody(InStream, 'true', false));
        l_cod_Source:='52';
        BankAPI.SetSource(l_cod_Source);
        BankAPI.SetCitiStmt();
        BankAPI.Post();
        ResponseStr:=BankAPI.GetResponseText();
        XmlDocument.ReadFrom(ResponseStr, XmlDoc);
        XmlNs.AddNamespace('ns', 'http://com.citi.citiconnect/services/types/inquiries/statement/v1');
        XmlDoc.SelectSingleNode('/ns:statementInitiationResponse/ns:statementId', XmlNs, Node);
        CitiInboundStatement.Init();
        CitiInboundStatement."Statement Id":=Node.AsXmlElement().InnerText;
        CitiInboundStatement."Bank Account No.":=CompanyName;
        CitiInboundStatement."Format Name":='CAMT_052_001_02';
        CitiInboundStatement."Statement Date From":=Today;
        CitiInboundStatement.Retrieved:=false;
        CitiInboundStatement.Insert();
    //     Sleep(900000);
    end;
    local procedure AddTemplateName(BankAccNo: Code[20]; var jObj: JsonObject)
    var
        TemplateNameMapping: Record "Citi Template Name Mapping";
    begin
        if TemplateNameMapping.Get(BankAccNo)then jObj.Add('templateName', TemplateNameMapping."CAMT52 Template Name");
    end;
}
