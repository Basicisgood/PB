page 50340 "JSON Buffer CustomPage"
{
    ApplicationArea = All;
    Caption = 'JSON Buffer CustomPage';
    PageType = List;
    SourceTable = "JSON Buffer";
    UsageCategory = Lists;

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
                field(Depth; Rec.Depth)
                {
                    ToolTip = 'Specifies the value of the Depth field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Token type"; Rec."Token type")
                {
                    ToolTip = 'Specifies the value of the Token type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Value"; Rec."Value")
                {
                    ToolTip = 'Specifies the value of the Value field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Value Type"; Rec."Value Type")
                {
                    ToolTip = 'Specifies the value of the Value Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Path; Rec.Path)
                {
                    ToolTip = 'Specifies the value of the Path field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Value BLOB"; Rec."Value BLOB")
                {
                    ToolTip = 'Specifies the value of the Value BLOB field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(GetRecords)
            {
                ApplicationArea = All;
                Caption = 'Get Records';
                Image = ShowList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesReceSetup: Record "Sales & Receivables Setup";
                    // HttpRequestCodeunit: Codeunit "HttpRequest Basic Auth";
                    BaseUrl, FinalUrl: text;
                    CustomerName: Text;
                begin
                    ////////get all Customers
                    SalesReceSetup.Reset();
                    SalesReceSetup.Get();
                // BaseUrl := SalesReceSetup."The URL";
                // HttpRequestCodeunit.HttpRequestGETWithBasicAuth(BaseUrl, 'Deepak', 'Dj320#Dune');
                /////////check request using code generated from postman api(code console) except my password
                // HttpRequestCodeunit.HttpRequestGETWithBasicAuth(BaseUrl, 'Deepak', 'RGVlcGFrOkRqMzIwI0R1bmU=');
                /////Get The Record of a perticular Customer
                // SalesReceSetup.Reset();
                // SalesReceSetup.Get();
                // BaseUrl := SalesReceSetup."The URL";
                // CustomerName := 'jj';
                // FinalUrl := BaseUrl + '(Customer_Name=''' + CustomerName + ''')';
                // HttpRequestCodeunit.HttpRequestGETWithBasicAuth(FinalUrl, 'Deepak', 'Dj320#Dune');
                // Message(FinalUrl);
                end;
            }
            action(CreateRecord)
            {
                ApplicationArea = All;
                Caption = 'create Records';
                Image = ShowList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesReceSetup: Record "Sales & Receivables Setup";
                    // HttpRequestCodeunit: Codeunit "HttpRequest Basic Auth";
                    BaseUrl: text;
                begin
                    SalesReceSetup.Reset();
                    SalesReceSetup.Get();
                // BaseUrl := SalesReceSetup."The URL";
                // HttpRequestCodeunit.HttpRequestPOSTWithBasicAuth(BaseUrl, 'Deepak', 'Dj320#Dune');
                end;
            }
            action(UpdateRecord)
            {
                ApplicationArea = All;
                Caption = 'Update Record';
                Image = ShowList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
            // trigger OnAction()
            // var
            //     SalesReceSetup: Record "Sales & Receivables Setup";
            //     HttpRequestCodeunit: Codeunit "HttpRequest Basic Auth";
            //     BaseUrl, FinalUrl : text;
            //     CustomerName: Text;
            // begin
            //     SalesReceSetup.Reset();
            //     SalesReceSetup.Get();
            //     BaseUrl := SalesReceSetup."The URL";
            //     CustomerName := 'Abhijeet';
            //     FinalUrl := BaseUrl + '(Customer_Name=''' + CustomerName + ''')';
            //     HttpRequestCodeunit.HttpRequestPATCHWithBasicAuth(FinalUrl, 'Deepak', 'Dj320#Dune');
            //     Message(FinalUrl);
            // end;
            }
        // action(DeleteRecords)
        // {
        //     ApplicationArea = All;
        //     Caption = 'Delete Records';
        //     Image = ShowList;
        //     Promoted = true;
        //     PromotedCategory = Process;
        //     PromotedIsBig = true;
        //     trigger OnAction()
        //     var
        //         SalesReceSetup: Record "Sales & Receivables Setup";
        //         HttpRequestCodeunit: Codeunit "HttpRequest Basic Auth";
        //         BaseUrl, FinalUrl : text;
        //         CustomerName: Text;
        //     begin
        //         SalesReceSetup.Reset();
        //         SalesReceSetup.Get();
        //         BaseUrl := SalesReceSetup."The URL";
        //         CustomerName := 'Abhijeet';
        //         FinalUrl := BaseUrl + '(Customer_Name=''' + CustomerName + ''')';
        //         HttpRequestCodeunit.HttpRequestDELETEWithBasicAuth(FinalUrl, 'Deepak', 'Dj320#Dune');
        //         Message(FinalUrl);
        // end;
        // }
        }
    }
}
