page 50146 "Bank API Log"
{
    ApplicationArea = All;
    Caption = 'Bank API Log';
    PageType = List;
    SourceTable = "Bank API Log";
    UsageCategory = Lists;
    SourceTableView = sorting("Entry No.")order(descending);

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Request Date Time"; Rec."Request Date Time")
                {
                    ToolTip = 'Specifies the value of the Request Date Time field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("API URL"; Rec."API URL")
                {
                    ToolTip = 'Specifies the value of the API URL field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Status Code"; Rec."Status Code")
                {
                    ToolTip = 'Specifies the value of the Status Code field.', Comment = '%';
                    StyleExpr = StyleExprtxt;
                    ApplicationArea = All;
                }
                field("HSBC MsgId"; Rec."HSBC MsgId")
                {
                    ToolTip = 'Specifies the value of the HSBC MsgId field.';
                    ApplicationArea = All;
                }
                field("Citi Statement Id"; Rec."Citi Statement Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Citi Statement Id field.';
                }
                field("Citi Bank Account No."; Rec."Citi Bank Account No.")
                {
                    Caption = 'Bank Account No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Citi Bank Account No. field.';
                }
                field("Statement From Date"; Rec."Statement From Date")
                {
                    ToolTip = 'Specifies the value of the Statement From Date field.';
                    ApplicationArea = All;
                }
                field("Xml String"; g_txt_XmlString)
                {
                    ToolTip = 'Specifies the value of the Xml String field.';
                    ApplicationArea = All;
                }
                field("Request Json"; g_txt_Request)
                {
                    ToolTip = 'Specifies the value of the Request Json field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Response Json"; g_txt_Response)
                {
                    ToolTip = 'Specifies the value of the Response Json field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Txt Status"; Rec."Txt Status")
                {
                    ToolTip = 'Specifies the value of the Txt Status field.';
                    ApplicationArea = All;
                }
                field("Original End to End Id"; Rec."Original End to End Id")
                {
                    ToolTip = 'Specifies the value of the Original End to End Id field.';
                    ApplicationArea = All;
                }
                field("Bank Integration Type"; Rec."Bank Integration Type")
                {
                    ToolTip = 'Specifies the value of the Bank Integration Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Citi Status Code"; Rec."Citi Status Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Citi Status Code field.';
                    Caption = 'Bank Http Code';
                    Style = Unfavorable;
                }
                field(Source; Rec.Source)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Source field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(DownloadXML)
            {
                Caption = 'Download XML';
                ApplicationArea = all;
                Image = Download;
                ToolTip = 'Executes the Download XML action.';

                trigger OnAction()
                var
                    InS: InStream;
                    FileName: Text;
                begin
                    FileName:='XML String' + '_' + Format(CurrentDateTime) + '.txt';
                    Rec.CalcFields("Xml String");
                    Rec."Xml String".CreateInStream(InS);
                    DownloadFromStream(InS, '', '', '', FileName);
                end;
            }
        }
    }
    var g_txt_Request: Text;
    g_txt_Response: Text;
    g_txt_XmlString: Text;
    trigger OnAfterGetRecord()
    begin
        GetJsonFieldText();
        if Rec."Status Code" = 200 then StyleExprtxt:='favorable'
        else
            StyleExprtxt:='Unfavorable';
    end;
    local procedure GetJsonFieldText()
    var
        InStream: InStream;
    begin
        Rec.CalcFields("Request Json", "Response Json", "Xml String");
        Clear(InStream);
        Rec."Request Json".CreateInStream(InStream);
        InStream.Read(g_txt_Request);
        Clear(InStream);
        Rec."Response Json".CreateInStream(InStream);
        InStream.Read(g_txt_Response);
        Clear(InStream);
        Rec."Xml String".CreateInStream(InStream);
        InStream.Read(g_txt_XmlString);
    end;
    local procedure SetRequestField()
    var
        OutStream: OutStream;
    begin
        Clear(OutStream);
        Rec."Request Json".CreateOutStream(OutStream);
        OutStream.Write(g_txt_Request);
        Rec.Modify();
    end;
    local procedure SetResponseField()
    var
        OutStream: OutStream;
    begin
        Clear(OutStream);
        Rec."Response Json".CreateOutStream(OutStream);
        OutStream.Write(g_txt_Response);
        Rec.Modify();
    end;
    var StyleExprtxt: text;
}
