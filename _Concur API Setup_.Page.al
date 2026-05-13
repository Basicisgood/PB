page 50188 "Concur API Setup"
{
    ApplicationArea = All;
    Caption = 'Concur API Setup';
    PageType = Card;
    SourceTable = "Concur API Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(Inbound)
            {
                group(Expense)
                {
                    Caption = 'Expense';

                    field("Is Enable"; Rec."Is Enable")
                    {
                        ToolTip = 'Specifies the value of the Is Enable field.', Comment = '%';
                        ApplicationArea = all;
                    }
                    field("Token URL"; Rec."Token URL")
                    {
                        ToolTip = 'Specifies the value of the Token URL field.', Comment = '%';
                        ApplicationArea = all;
                    }
                    field("Financial Transaction URL"; Rec."Financial Transaction URL")
                    {
                        ToolTip = 'Specifies the value of the Financial Transaction URL field.', Comment = '%';
                        ApplicationArea = All;
                    }
                    field("Financial Transaction Ack URL"; Rec."Financial Transaction Ack URL")
                    {
                        ToolTip = 'Specifies the value of the Financial Transaction Ack URL field.', Comment = '%';
                        ApplicationArea = All;
                    }
                    field("Financial Trans Confirm URL"; Rec."Financial Trans Confirm URL")
                    {
                        ToolTip = 'Specifies the value of the Financial Trans Confirm URL field.', Comment = '%';
                        ApplicationArea = All;
                    }
                    field("Finan Trans. Payment Conf. URL"; Rec."Finan Trans. Payment Conf. URL")
                    {
                        ToolTip = 'Specifies the value of the Financial Transaction Payment Confirmation URL field.', Comment = '%';
                        ApplicationArea = All;
                    }
                    field("User ID"; Rec."User ID")
                    {
                        ToolTip = 'Specifies the value of the User ID field.', Comment = '%';
                        ApplicationArea = all;
                        Visible = false;
                    }
                    field(Password; Rec.Password)
                    {
                        ToolTip = 'Specifies the value of the Password field.', Comment = '%';
                        ApplicationArea = all;
                        Visible = false;
                    }
                    field("Access Token"; AccessToken)
                    {
                        ApplicationArea = All;
                        Visible = false;
                        ToolTip = 'Specifies the value of the Access Token field.';
                        MultiLine = true;

                        trigger OnValidate()
                        var
                            currentyear: Date;
                        begin
                            Rec.SetAccessToken(AccessToken);
                        end;
                    }
                    field("Concur Gen. Journal No."; Rec."Concur Gen. Journal No.")
                    {
                        ApplicationArea = all;
                    }
                    field("Concur Template Name"; Rec."Concur Template Name")
                    {
                        ApplicationArea = all;
                    }
                    field("Concur Batch Name"; Rec."Concur Batch Name")
                    {
                        ApplicationArea = all;
                    }
                    field("Default Concur Dimension"; Rec."Default Concur Dimension")
                    {
                        ApplicationArea = all;
                    }
                    field("CL Concur Gen. Journal No."; Rec."CL Concur Gen. Journal No.")
                    {
                        ApplicationArea = all;
                    }
                    field("CL Concur Template Name"; Rec."CL Concur Template Name")
                    {
                        ApplicationArea = all;
                    }
                    field("CL Concur Batch Name"; Rec."CL Concur Batch Name")
                    {
                        ApplicationArea = all;
                    }
                    field("CL Default Concur Dim."; Rec."CL Default Concur Dim.")
                    {
                        ApplicationArea = all;
                    }
                    field("Expense Type Name Filter 1"; Rec."Expense Type Name Filter 1")
                    {
                        ApplicationArea = all;
                    }
                    field("Expense Type Name Filter 2"; Rec."Expense Type Name Filter 2")
                    {
                        ToolTip = 'Specifies the value of the Expense Type Name Filter 2 field.', Comment = '%';
                        ApplicationArea = All;
                    }
                    field("Expense Type Name Filter 3"; Rec."Expense Type Name Filter 3")
                    {
                        ToolTip = 'Specifies the value of the Expense Type Name Filter 3 field.', Comment = '%';
                        ApplicationArea = All;
                    }
                    field("DOC Cash FD9"; Rec."DOC Cash FD9")
                    {
                        ToolTip = 'Specifies the value of the DOC Cash FD9 field.', Comment = '%';
                        ApplicationArea = All;
                    }
                    field("DOC Non Cash FD9"; Rec."DOC Non Cash FD9")
                    {
                        ToolTip = 'Specifies the value of the DOC Non Cash FD9 field.', Comment = '%';
                        ApplicationArea = All;
                    }
                    field("Cash Advance Return G/L Acc"; Rec."Cash Advance Return G/L Acc")
                    {
                        ApplicationArea = All;
                    }
                }
                group(Accrual)
                {
                    Caption = 'Accrual';

                    //PS007 Start
                    field("Concur Accr. Template Name"; Rec."Concur Accr. Template Name")
                    {
                        ApplicationArea = all;
                    }
                    field("Concur Accr. Batch Name"; Rec."Concur Accr. Batch Name")
                    {
                        ApplicationArea = all;
                    }
                    field("Concur Accr. Gen. Journal No."; Rec."Concur Accr. Gen. Journal No.")
                    {
                        ApplicationArea = all;
                    }
                    field("Default Concur Accr. Dimension"; Rec."Default Concur Accr. Dimension")
                    {
                        ApplicationArea = all;
                    }
                    field("Accrual Debit GL Code"; Rec."Accrual Debit GL Code")
                    {
                        ApplicationArea = all;
                    }
                    field("Accrual Credit GL Code"; Rec."Accrual Credit GL Code")
                    {
                        ApplicationArea = all;
                    }
                    field("Accrual Report Name Filter 1"; Rec."Accrual Report Name Filter 1")
                    {
                        ApplicationArea = all;
                    }
                    field("Accrual Report Name Filter 2"; Rec."Accrual Report Name Filter 2")
                    {
                        ApplicationArea = all;
                    }
                    field("Accrual Report Name Filter 3"; Rec."Accrual Report Name Filter 3")
                    {
                        ApplicationArea = all;
                    }
                    field("Accrual FD5 Filter 1"; Rec."Accrual FD5 Filter 1")
                    {
                        ApplicationArea = all;
                    }
                //PS007 End
                }
                group(Attendee)
                {
                    Caption = 'Attendee';

                    field("Expense Attendee URL"; Rec."Expense Attendee URL")
                    {
                        ToolTip = 'Specifies the value of the Expense Attendee URL field.', Comment = '%';
                        ApplicationArea = All;
                    }
                    //PS009 Start
                    field("Get Attendee Info URL"; Rec."Get Attendee Info URL")
                    {
                        ApplicationArea = all;
                    }
                    field("Get Identity URL"; Rec."Get Identity URL")
                    {
                        ApplicationArea = all;
                    }
                //PS009 End
                }
                group("Inbound Image")
                {
                    field("Concur Inbound Image URL"; Rec."Concur Inbound Image URL")
                    {
                        ToolTip = 'Specifies the value of the Concur Inbound Image URL field.', Comment = '%';
                        ApplicationArea = All;
                    }
                }
                field("Company Code Prefix"; Rec."Company Code Prefix")
                {
                    ApplicationArea = all;
                }
                field("Concur Cash Ledger FD6"; Rec."Concur Cash Ledger FD6")
                {
                    ApplicationArea = All;
                }
                //PS014 Start
                field("Client ID"; Rec."Client ID")
                {
                    ApplicationArea = all;
                }
                field("Client Secret"; Rec."Client Secret")
                {
                    ApplicationArea = all;
                }
                field("Refresh Token"; Rec."Refresh Token")
                {
                    ApplicationArea = all;
                }
            //PS014 End
            }
            //PS004 Start
            //#256 TEC.VJ 10MAR2025>>
            group("Cash Advance")
            {
                field("Is Enable Cash Advance"; Rec."Is Enable Cash Advance")
                {
                    ToolTip = 'Specifies the value of the Is Enable Cash Advance field.', Comment = '%';
                    ApplicationArea = all;
                    Caption = 'Is Enable';
                }
                field("Get Cash Advance URL"; Rec."Get Cash Advance URL")
                {
                    ToolTip = 'Specifies the value of the Get Cash Advance URL field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Send Back Ackn. To Concur URL"; Rec."Post Cash Advance Ack. URL")
                {
                    ToolTip = 'Specifies the value of the Send Back acknowledgements To Concur URL field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Send Post confir.To Concur URL"; Rec."Post Cash Advance Confir. URL")
                {
                    ToolTip = 'Specifies the value of the Send Post Confirmation To Concur URL field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Cash Advance Template Name"; Rec."Cash Advance Template Name")
                {
                    ApplicationArea = All;
                }
                field("Cash Advance Batch Name"; Rec."Cash Advance Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Cash Advance No. Series"; Rec."Cash Advance No. Series")
                {
                    ApplicationArea = All;
                }
                field("Cash Advance FD10"; Rec."Cash Advance FD10")
                {
                    ApplicationArea = All;
                }
            }
            //#256 TEC.VJ 10MAR2025<<
            group(Outbound)
            {
                field("Enable Outbound Integration"; Rec."Enable Outbound Integration")
                {
                    ToolTip = 'Specifies the value of the Enable Outbound Integration field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("API Token"; Rec."API Token")
                {
                    ToolTip = 'Specifies the value of the API Token field.', Comment = '%';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Exchange Rate URL"; Rec."Exchange Rate URL")
                {
                    ToolTip = 'Specifies the value of the Exchange Rate URL field.', Comment = '%';
                    ApplicationArea = All;
                }
                //PS005 Start
                field("Employee URL"; Rec."Employee URL")
                {
                    ToolTip = 'Specifies the value of the Employee URL field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Company ID"; Rec."Company ID")
                {
                    ToolTip = 'Specifies the value of the Company ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Default Company"; Rec."Default Company")
                {
                    ApplicationArea = all;
                }
                //PS005 End
                //PS006 Start
                field("Payment URL"; Rec."Payment URL")
                {
                    ApplicationArea = all;
                }
            //PS006 End
            }
        //PS004 End
        }
    }
    actions
    {
        area(Processing)
        {
            action("Generate Token")
            {
                ApplicationArea = all;
                Image = Create;

                trigger OnAction()
                var
                    PBAPI: Codeunit "Concur Financial Transaction";
                begin
                    if PBAPI.GenerateRefreshToken() = '' then Message('No Access Token generated')
                    else
                        Message('Access Token generated Successfully');
                end;
            }
            group(ConcurAPISetup)
            {
                action(ConcurSetup)
                {
                    ApplicationArea = all;
                    Caption = 'Concur API Setup';
                    Image = Setup;
                    RunObject = page "Concur API Setup";
                }
            }
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
                /* action(ExpenseAttendeeAPI)
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
                } */
                action(SendConfirmation)
                {
                    Caption = 'Send Confirmation';
                    ApplicationArea = all;
                    Image = Process;
                    Visible = false; //#329 TEC.VJ

                    trigger OnAction()
                    var
                        ConcurSendConfrmation: Codeunit "Concur Send Confirmation";
                    begin
                    //ConcurSendConfrmation.GetPostingConfirmation();
                    end;
                }
                action(SendPaymentConfirmation)
                {
                    Caption = 'Send Payment Confirmation';
                    ApplicationArea = all;
                    Image = Process;
                    Visible = false; //#329 TEC.VJ

                    trigger OnAction()
                    var
                        ConcurSendPaymtConf: Codeunit "Concur Send Payment Confir.";
                    begin
                    //ConcurSendPaymtConf.GetPostingPaymentConfirmation();
                    end;
                }
                //#256 TEC.VJ 10MAR2025>>
                action(GetCashAdvance)
                {
                    Caption = 'Get Cash Advance';
                    ApplicationArea = all;
                    Image = Process;

                    trigger OnAction()
                    var
                        PBAPIToken: Codeunit "Concur Cash Advance";
                    begin
                        PBAPIToken.GetCashAdvanceData(true);
                    end;
                }
                //#328 TEC.VJ>>
                // action(SendBackAck)
                // {
                //     Caption = 'Post Cash Advance acknowledgement';
                //     ApplicationArea = all;
                //     Image = Process;
                //     trigger OnAction()
                //     var
                //         ConcurCashAdvAck: Codeunit "Concur Post Cash Advance Ackn.";
                //     begin
                //         // ConcurCashAdvAck.Run();
                //     end;
                // }
                //#328 TEC.VJ<<
                action(SendPostConfirmation)
                {
                    Caption = 'Post Cash Advance Confirmation';
                    ApplicationArea = all;
                    Image = Process;

                    trigger OnAction()
                    var
                        ConcurCashAdSendPostConf: Codeunit "Concur Post CA Confr.For Emp";
                    begin
                        ConcurCashAdSendPostConf.Run(); //#328 TEC.VJ
                    end;
                }
            //#256 TEC.VJ 10MAR2025<<
            }
            group(ConCurPages)
            {
                Caption = 'Concur Staging Pages';

                action(ConcurInbFinExpense)
                {
                    ApplicationArea = all;
                    Caption = 'Concur Expense Line';
                    Image = ImportLog;
                    RunObject = page "Concur Inbound Financial Expen";
                }
                /*   action(AttendeesAPI)
                  {
                      ApplicationArea = all;
                      Caption = 'Concur Expense Attendees API';
                      Image = ImportLog;
                      RunObject = page ConcurExpenseAttendeeAPI;
                  } */
                /*   action("Concur Inbound Image")
                  {
                      ApplicationArea = all;
                      Caption = 'Concur Inbound Image';
                      Image = ImportLog;
                      RunObject = page "Concur Inbound Image";
                  } */
                action("Concur Expense Master")
                {
                    Caption = 'Concur Expense Master';
                    ApplicationArea = all;
                    RunObject = page "Concur inbound Master";
                }
                action("Concur Accrual Staging")
                {
                    ApplicationArea = all;
                    RunObject = page "Expense Report Staging";
                }
                action(ConcurCashAdvancePage) //#256 TEC.VJ
                {
                    ApplicationArea = all;
                    Caption = 'Concur Cash Advance';
                    Image = ImportLog;
                    RunObject = page "Concur Cash Advance";
                }
            }
            group(ConcurLog)
            {
                Caption = 'Concur API Log';

                /*  action(ConcurStaging)
                 {
                     ApplicationArea = all;
                     Caption = 'Concur API Staging Log';
                     Image = ImportLog;
                     RunObject = page "Concur API Response";
                 } */
                //PS004 Start
                action("Concur Outbnd. Log")
                {
                    ApplicationArea = all;
                    Caption = 'Concur Outbound Log';
                    Image = ImportLog;
                    RunObject = page "Concur Outbound Log";
                }
                //PS004 End
                action("Concur API inbound")
                {
                    Caption = 'Concur API inbound';
                    ApplicationArea = All;
                    RunObject = page "Concur API Inbound List";
                }
            }
            group(Setup)
            {
                action("Concur VAT Setup")
                {
                    ApplicationArea = all;
                    RunObject = page "Concur VAT Setup";
                }
                action("Concur Bank Account Setup")
                {
                    ApplicationArea = all;
                    RunObject = page "Concur Bank Account Setup";
                }
            }
        }
        area(Promoted)
        {
            actionref(ConcurSetup1; ConcurSetup)
            {
            }
            group(API_G)
            {
                Caption = 'API';

                actionref(FinanTransAPI1; FinanTransAPI)
                {
                }
                /* actionref(ExpenseAttendeeAPI1; ExpenseAttendeeAPI) { }
                actionref(ConcurInboundImageAPI1; ConcurInboundImageAPI) { } */
                actionref(GetCashAdvance1; GetCashAdvance)
                {
                }
            /* actionref(ExpenseAttendeeAPI1; ExpenseAttendeeAPI) { }
                actionref(ConcurInboundImageAPI1; ConcurInboundImageAPI) { } */
            }
            group(ConcurPages_g)
            {
                Caption = 'Concur Staging Pages';

                actionref(ConcurInbFinExpense1; ConcurInbFinExpense)
                {
                }
                // actionref(ConcurInboundImage1; "Concur Inbound Image") { }
                actionref("Concur Expense Master_"; "Concur Expense Master")
                {
                }
                actionref("Concur Accrual Staging_"; "Concur Accrual Staging")
                {
                }
                actionref("ConcurCashAdvancePage_"; "ConcurCashAdvancePage")
                {
                } //#256 TEC.VJ
            }
            group(ConcurLog_g)
            {
                Caption = 'Concur API Log';

                /* actionref(ConcurStaging1; ConcurStaging) { }
                actionref(AttendeesAPI1; AttendeesAPI) { } */
                //PS004 Start
                actionref("Concur Outbound Log"; "Concur Outbnd. Log")
                {
                }
                //PS004 End
                actionref("Concur API inbound_"; "Concur API inbound")
                {
                }
            }
            group(Setup_g)
            {
                Caption = 'Setup';

                actionref("Concur VAT Setup_"; "Concur VAT Setup")
                {
                }
                actionref("Concur Bank Account Setup_"; "Concur Bank Account Setup")
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        AccessToken:=rec.GetAccessToken();
    end;
    var AccessToken: text;
}
