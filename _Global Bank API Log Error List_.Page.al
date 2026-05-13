page 50272 "Global Bank API Log Error List"
{
    ApplicationArea = All;
    Caption = 'Global Bank API Log Error List';
    PageType = List;
    SourceTable = "Bank API Log";
    UsageCategory = Lists;
    SourceTableTemporary = true;
    SourceTableView = sorting("Request Date Time")order(descending);

    layout
    {
        area(Content)
        {
            group(G1)
            {
                Caption = '';

                field("From Date"; g_dat_FromDate)
                {
                    ApplicationArea = all;
                }
                field("To Date"; g_dat_ToDate)
                {
                    ApplicationArea = ALl;
                }
                field("Company Filter"; g_txt_CompanyList)
                {
                    ApplicationArea = All;
                }
            }
            repeater(General)
            {
                Editable = false;

                field("API URL"; Rec."API URL")
                {
                    ToolTip = 'Specifies the value of the API URL field.', Comment = '%';
                }
                field("Bank Integration Type"; Rec."Bank Integration Type")
                {
                    ToolTip = 'Specifies the value of the Bank Integration Type field.', Comment = '%';
                }
                field("Citi Bank Account No."; Rec."Citi Bank Account No.")
                {
                    ToolTip = 'Specifies the value of the Citi Bank Account No. field.';
                }
                field("Citi Statement Id"; Rec."Citi Statement Id")
                {
                    ToolTip = 'Specifies the value of the Citi Statement Id field.';
                }
                field("Citi Status Code"; Rec."Citi Status Code")
                {
                    ToolTip = 'Specifies the value of the Citi Status Code field.';
                }
                field("HSBC MsgId"; Rec."HSBC MsgId")
                {
                    ToolTip = 'Specifies the value of the HSBC MsgId field.';
                }
                field("Original End to End Id"; Rec."Original End to End Id")
                {
                    ToolTip = 'Specifies the value of the Original End to End Id field.';
                }
                field("Request Date Time"; Rec."Request Date Time")
                {
                    ToolTip = 'Specifies the value of the Request Date Time field.', Comment = '%';
                }
                field(Source; Rec.Source)
                {
                    ToolTip = 'Specifies the value of the Source field.';
                }
                field("Statement From Date"; Rec."Statement From Date")
                {
                    ToolTip = 'Specifies the value of the Statement From Date field.';
                }
                field("Status Code"; Rec."Status Code")
                {
                    ToolTip = 'Specifies the value of the Status Code field.', Comment = '%';
                }
                field("Txt Status"; Rec."Txt Status")
                {
                    ToolTip = 'Specifies the value of the Txt Status field.';
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
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Refresh)
            {
                trigger OnAction()
                begin
                    RefreshList();
                end;
            }
        }
    }
    local procedure RefreshList(): integer var
        myInt: Integer;
        l_Rec_Company: Record Company;
        l_Rec_BankAPILog: Record "Bank API Log";
        l_Rec_BankAPILog2: Record "Bank API Log";
        l_int_EntryNo: integer;
        l_bol_CreateEntry: boolean;
    begin
        Rec.RESET;
        REC.DELETEALL;
        l_Rec_Company.RESET;
        IF g_txt_CompanyList <> '' THEN l_Rec_Company.SETFILTER(Name, g_txt_CompanyList);
        IF l_Rec_Company.FINDSET THEN repeat l_Rec_BankAPILog.RESET;
                l_Rec_BankAPILog.ChangeCompany(l_Rec_Company.Name);
                l_Rec_BankAPILog.SETRANGE("Request Date Time", CREATEDATETIME(g_dat_FromDate, 000000T), CREATEDATETIME(g_dat_ToDate, 235959T));
                l_Rec_BankAPILog.SETFILTER("Status Code", '<>%1', 200);
                IF l_Rec_BankAPILog.FINDSET THEN repeat IF not g_bol_CheckCountOnly THEN BEGIN
                            REc:=l_Rec_BankAPILog;
                            Rec."Entry No.":=l_int_EntryNo;
                            Rec."API URL":='[' + l_Rec_Company.Name + '] ' + Rec."API URL" + ' (' + FORMAT(l_Rec_BankAPILog."Entry No.") + ')';
                            Rec.INSERT;
                        END;
                        l_int_EntryNo+=1;
                    UNTIL l_Rec_BankAPILog.NEXT = 0;
                l_Rec_BankAPILog.RESET;
                l_Rec_BankAPILog.ChangeCompany(l_Rec_Company.Name);
                l_Rec_BankAPILog.SETRANGE("Request Date Time", CREATEDATETIME(g_dat_FromDate, 000000T), CREATEDATETIME(g_dat_ToDate, 235959T));
                l_Rec_BankAPILog.SETFILTER("Citi Status Code", '<>%1&<>%2', '200', '');
                IF l_Rec_BankAPILog.FINDSET THEN repeat IF not g_bol_CheckCountOnly THEN BEGIN
                            REc:=l_Rec_BankAPILog;
                            Rec."Entry No.":=l_int_EntryNo;
                            Rec."API URL":='[' + l_Rec_Company.Name + '] ' + Rec."API URL" + ' (' + FORMAT(l_Rec_BankAPILog."Entry No.") + ')';
                            Rec.INSERT;
                        END;
                        l_int_EntryNo+=1;
                    UNTIL l_Rec_BankAPILog.NEXT = 0;
            UNTIL l_Rec_Company.NEXT = 0;
        EXIT(l_int_EntryNo);
    end;
    procedure CountRecords(CountOnly: Boolean): integer var
        l_rec_BankAPISetup: Record "Bank API Setup";
    begin
        IF l_rec_BankAPISetup.GET THEN;
        g_bol_CheckCountOnly:=CountOnly;
        IF g_dat_FromDate = 0D THEN begin
            g_dat_FromDate:=CalcDate(l_rec_BankAPISetup."Bank API List Date Formula", TODAY);
            g_dat_ToDate:=TODAY;
        end;
        g_txt_CompanyList:=l_rec_BankAPISetup."Company Code Filter list";
        EXIT(RefreshList);
    end;
    procedure PassDate(FromDate: Date; ToDate: Date)
    begin
        g_dat_FromDate:=FromDate;
        g_dat_ToDate:=ToDate;
    end;
    trigger OnAfterGetRecord()
    begin
        GetJsonFieldText();
    end;
    trigger OnOpenPage()
    var
    begin
        //g_dat_FromDate := CALCDATE('<-1W>', TODAY);
        //g_dat_ToDate := TODAY;
        CountRecords(FALSE);
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
    var g_dat_FromDate: Date;
    g_dat_ToDate: Date;
    g_bol_CheckCountOnly: boolean;
    g_txt_CompanyList: text;
    g_txt_Request: Text;
    g_txt_Response: Text;
    g_txt_XmlString: Text;
}
