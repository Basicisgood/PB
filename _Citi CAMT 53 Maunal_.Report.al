report 50123 "Citi CAMT 53 Maunal"
{
    Caption = 'Citi CAMT 53 Maunal';
    ApplicationArea = all;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Bank Account"; "Bank Account")
        {
            DataItemTableView = sorting("No.");

            trigger OnPreDataItem()
            begin
                SetRange("Bank Account No.", g_txt_BankAccount);
                SetFilter("Bank Statement from API", '%1|%2', "Bank Statement from API"::"CAMT52 & 53", "Bank Statement from API"::CAMT53);
            end;
            trigger OnAfterGetRecord()
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
                DateStr: Text;
                l_cod_Source: Code[2];
            begin
                Clear(BankAPI);
                Clear(jObj);
                TempBlob.CreateInStream(InStream);
                TempBlob.CreateOutStream(OutStream);
                if BankAPISetup.Get()then;
                BankAPI.InitClient(BankAPISetup."PGP Base API Url", 'CitiStatement');
                DateStr:=Format(g_dat_StatementDate, 0, '<Year4>-<Month,2>-<Day,2>');
                jObj.Add('formatName', 'CAMT_053_001_02');
                jObj.Add('accountNumber', "Bank Account"."Bank Account No.");
                jObj.Add('fromDate', DateStr);
                jObj.Add('toDate', DateStr);
                AddTemplateName("Bank Account"."Bank Account No.", jObj);
                jObj.WriteTo(OutStream);
                BankAPI.WriteRequestBody(BankAPI.GenCitiBody(InStream, 'true', false));
                l_cod_Source:='53';
                BankAPI.SetSource(l_cod_Source);
                BankAPI.SetCitiStmt();
                BankAPI.Post();
                ResponseStr:=BankAPI.GetResponseText();
                XmlDocument.ReadFrom(ResponseStr, XmlDoc);
                XmlNs.AddNamespace('ns', 'http://com.citi.citiconnect/services/types/inquiries/statement/v1');
                XmlDoc.SelectSingleNode('/ns:statementInitiationResponse/ns:statementId', XmlNs, Node);
                CitiInboundStatement.Init();
                CitiInboundStatement."Statement Id":=Node.AsXmlElement().InnerText;
                CitiInboundStatement."Format Name":='CAMT_053_001_02';
                CitiInboundStatement."Bank Account No.":="Bank Account"."Bank Account No.";
                CitiInboundStatement."Statement Date From":=g_dat_StatementDate;
                CitiInboundStatement.Retrieved:=false;
                CitiInboundStatement.Insert();
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                field(g_dat_StatementDate; g_dat_StatementDate)
                {
                    Caption = 'Statement Date';
                    ApplicationArea = all;
                }
                field(g_txt_BankAccount; g_txt_BankAccount)
                {
                    Caption = 'Bank Account No.';
                    Editable = false;
                    ApplicationArea = all;
                }
            }
        }
    }
    local procedure AddTemplateName(BankAccNo: Code[20]; var jObj: JsonObject)
    var
        TemplateNameMapping: Record "Citi Template Name Mapping";
    begin
        if g_dat_StatementDate = Today - 1 then begin
            if TemplateNameMapping.Get(BankAccNo)then jObj.Add('templateName', TemplateNameMapping."CAMT53 Template Name");
        end
        else
            jObj.Add('templateName', 'none');
    end;
    procedure SetBankAccountNo(BankAccNo: Text[30])
    begin
        g_txt_BankAccount:=BankAccNo;
    end;
    var g_dat_StatementDate: Date;
    g_txt_BankAccount: Text[30];
}
