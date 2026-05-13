page 50224 "Concur API Inbound List"
{
    ApplicationArea = All;
    Caption = 'Concur API Inbound List';
    PageType = List;
    SourceTable = "Concur API Inbound";
    UsageCategory = Lists;
    SourceTableView = order(descending);
    InsertAllowed = false;

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
                field("Creation DateTime"; Rec."Creation DateTime")
                {
                    ToolTip = 'Specifies the value of the Creation DateTime field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(JsonRequest; JsonRequestText)
                {
                    Caption = 'Json Request';
                    ToolTip = 'Specifies the value of the JsonRequest field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(JsonData; JsonDataText)
                {
                    Caption = 'Json Response';
                    ToolTip = 'Specifies the value of the Content field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Processed to Staging"; Rec."Processed to Staging")
                {
                    ToolTip = 'Specifies the value of the Processed to Staging field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Staging Entry No."; Rec."Staging Entry No.")
                {
                    ToolTip = 'Specifies the value of the Staging Entry No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("API Type"; Rec."API Type")
                {
                    ToolTip = 'Specifies the value of the API Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(ExpenseID; Rec.ExpenseID)
                {
                    ToolTip = 'Specifies the value of the ExpenseID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(AckJsonData; AckJsonDatatxt)
                {
                    ToolTip = 'Specifies the value of the AckContent field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(acknowledgeResult; Rec.acknowledgeResult)
                {
                    ToolTip = 'Specifies the value of the acknowledgeResult field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Ack errorMessage"; Rec."Ack errorMessage")
                {
                    ToolTip = 'Specifies the value of the errorMessage field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Transaction No"; Rec."Transaction No")
                {
                    ToolTip = 'Specifies the value of the Transaction No field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group("API")
            {
                action(FinanTransAPI)
                {
                    Caption = 'Get Financial Transaction';
                    ApplicationArea = all;
                    Image = Process;

                    trigger OnAction()
                    var
                        PBAPIToken: Codeunit "Concur Financial Transaction";
                    begin
                        PBAPIToken.GetFinancialTransactions(true);
                    end;
                }
                action(ExpenseAttendeeAPI)
                {
                    Caption = 'Get Expense Attendee';
                    ApplicationArea = all;
                    Image = Process;

                    trigger OnAction()
                    var
                        ExpenseAttendeeResponsCodeunit: Codeunit "Concur Expense Attendee Resp.";
                    begin
                    //ExpenseAttendeeResponsCodeunit.GetExpenseAttendee(true);  //PS009
                    end;
                }
                action(ConcurInboundImagEAPI)
                {
                    Caption = 'Get Expense Image Url';
                    ApplicationArea = all;
                    Image = Process;

                    trigger OnAction()
                    var
                        ExpenseImageCodeunit: Codeunit "Concur Expense_Image";
                    begin
                        ExpenseImageCodeunit.GetExpenseImageUrl(true);
                    end;
                }
            }
            group("Cash Advance API")
            {
                //#256 TEC.VJ 10MAR2025>>
                action(GetCashAdvance)
                {
                    Caption = 'Get Concur Cash Advance';
                    ApplicationArea = all;
                    Image = Process;

                    trigger OnAction()
                    var
                        PBAPIToken: Codeunit "Concur Cash Advance";
                    begin
                        PBAPIToken.GetCashAdvanceData(true);
                    end;
                }
                action(SendBackAck)
                {
                    Caption = 'Post Cash Advance acknowledgement';
                    ApplicationArea = all;
                    Image = Process;

                    trigger OnAction()
                    var
                        Cod50169: Codeunit "Concur Post Cash Advance Ackn.";
                    begin
                        Rec.TestField("API Type", Rec."API Type"::"Cash Advance");
                        Rec.TestField(Rec.ExpenseID);
                        Cod50169.GetAcknowledgement(Rec.ExpenseID, Rec."Entry No."); //#328
                    end;
                }
                action(SendPostConfirmation)
                {
                    Caption = 'Post Cash Advance Confirmation';
                    ApplicationArea = all;
                    Image = Process;

                    trigger OnAction()
                    var
                        ConcurSendPaymtConf: Codeunit "Concur Post CA Confr.For Emp";
                        EmpLedg: Record "Employee Ledger Entry"; //TEC.VJ 14MAY2025
                    begin
                        Clear(EmpLedg);
                        ConcurSendPaymtConf.GetPostingConfirmation(EmpLedg); //VJ15APR2025//#328 TEC.VJ
                    end;
                }
            //#256 TEC.VJ 10MAR2025<<
            }
            action(ProcessFinanceExpense)
            {
                ApplicationArea = all;
                Caption = 'Process Finance Expense';
                Image = Process;

                trigger OnAction()
                var
                    Cod50126: Codeunit "Concur Financial Transaction";
                    ConcurinboundfinancialExpen: Record "Concur inbound financial Expen";
                begin
                    Rec.TestField("API Type", Rec."API Type"::Expense);
                    ConcurinboundfinancialExpen.Reset();
                    ConcurinboundfinancialExpen.SetRange("API Log Entry No.", Rec."Entry No.");
                    if ConcurinboundfinancialExpen.FindFirst()then Error('Staging entries already exist for this log');
                    Cod50126.ProcessInvoiceJson(JsonDataText);
                    Rec."Processed to Staging":=true;
                    Rec.Modify();
                end;
            }
            action(ReProcessFinanceExpense)
            {
                ApplicationArea = all;
                Caption = 'Re-process Finance Expense';
                Image = Process;

                trigger OnAction()
                var
                    Cod50126: Codeunit "Concur Financial Transaction";
                    ConcurinboundfinancialExpen: Record "Concur inbound financial Expen";
                begin
                    Rec.TestField("API Type", Rec."API Type"::Expense);
                    ConcurinboundfinancialExpen.Reset();
                    ConcurinboundfinancialExpen.SetRange("API Log Entry No.", Rec."Entry No.");
                    if ConcurinboundfinancialExpen.FindFirst()then if not Confirm('Staging entries already exist for this log, do you want to reprocess?', false)then exit;
                    Cod50126.ReProcessInvoiceJson(JsonDataText, Rec."Entry No.");
                    Rec."Processed to Staging":=true;
                    Rec.Modify();
                    Message('Processing done');
                end;
            }
            action(ProcessFinanceExpenseAck)
            {
                ApplicationArea = all;
                Caption = 'Send Finance Expense Ack';
                Image = Process;

                trigger OnAction()
                var
                    Cod50169: Codeunit "Concur Financial Trans Ack";
                begin
                    Rec.TestField("API Type", Rec."API Type"::Expense);
                    Rec.TestField(Rec.ExpenseID);
                    Cod50169.GetAcknowledgement(Rec.ExpenseID, Rec."Entry No.");
                end;
            }
            action(SeeStagingData)
            {
                ApplicationArea = all;
                Caption = 'View Staging Data';
                Image = View;

                trigger OnAction()
                var
                    ConcurinboundfinancialExpen: Record "Concur inbound financial Expen";
                    ConcurInboundAtt: Record "Concur inbound Attende Staging";
                    ConcurCashAdv: Record "Concur Cash Advance";
                begin
                    if Rec."API Type" = Rec."API Type"::Image then Error('Type must be Json not xml');
                    if Rec."API Type" = Rec."API Type"::Expense then begin
                        ConcurinboundfinancialExpen.Reset();
                        ConcurinboundfinancialExpen.SetRange("API Log Entry No.", Rec."Entry No.");
                        if ConcurinboundfinancialExpen.FindFirst()then Page.Run(50217, ConcurinboundfinancialExpen);
                    end;
                    if Rec."API Type" = Rec."API Type"::Attende then begin
                        ConcurInboundAtt.Reset();
                        ConcurInboundAtt.SetRange("API Log Entry No.", Rec."Entry No.");
                        if ConcurInboundAtt.FindFirst()then Page.Run(50231, ConcurInboundAtt);
                    end;
                    //#256 TEC.VJ>>
                    if Rec."API Type" = Rec."API Type"::"Cash Advance" then begin
                        ConcurCashAdv.Reset();
                        ConcurCashAdv.SetRange("API Log Entry No.", Rec."Entry No.");
                        if ConcurCashAdv.FindFirst()then Page.Run(Page::"Concur Cash Advance", ConcurCashAdv);
                    end;
                //#256 TEC.VJ<<
                end;
            }
            action(SeeJsonData)
            {
                ApplicationArea = all;
                Caption = 'View Json Data';
                Image = View;

                trigger OnAction()
                var
                    JsonBuffer: Record "JSON Buffer";
                begin
                    if Rec."API Type" = Rec."API Type"::Image then Error('Type must be Json not xml');
                    JsonBuffer.ReadFromText(JsonDataText); // JSON Buffer
                    Page.Run(Page::"JSON Buffer CustomPage", JsonBuffer);
                end;
            }
        }
    }
    var JsonDataText: text;
    JsonRequestText: text;
    AckJsonDatatxt: Text;
    instreamvar: InStream;
    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(JsonData);
        Rec.CalcFields(JsonRequest);
        Clear(JsonRequestText);
        Clear(JsonDataText);
        if Rec.JsonData.HasValue then begin
            Rec.JsonData.CreateInStream(instreamvar);
            instreamvar.Read(JsonDataText);
        end;
        if Rec.JsonRequest.HasValue then begin
            Rec.JsonRequest.CreateInStream(instreamvar);
            instreamvar.Read(JsonRequestText);
        end;
        Clear(instreamvar);
        Clear(AckJsonDatatxt);
        Rec.CalcFields(AckJsonData);
        if Rec.AckJsonData.HasValue then begin
            Rec.AckJsonData.CreateInStream(instreamvar);
            instreamvar.Read(AckJsonDatatxt);
        end;
    end;
}
