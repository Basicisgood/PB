page 50148 "API Menu"
{
    Caption = 'API Interface Menu';
    PageType = Card;
    UsageCategory = Administration;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            group(General)
            {
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            group(IMOS)
            {
                Group("IMOS Master")
                {
                    Caption = 'IMOS';

                    action("IMOS API Log")
                    {
                        ApplicationArea = all;
                        Caption = 'IMOS API Log';
                        Image = ImportLog;
                        RunObject = page "IMOS API Log";
                    }
                    action("Company Dimension Mapping")
                    {
                        ApplicationArea = all;
                        Caption = 'Company Dimension Mapping';
                        Image = ImportLog;
                        RunObject = page "Company Dimension Mapping";
                    }
                    action("Company Mapping")
                    {
                        ApplicationArea = all;
                        Caption = 'Company Mapping';
                        Image = ImportLog;
                        RunObject = page "Company Mapping";
                    }
                }
                group("IMOS Setup")
                {
                    action(IMOSSetup)
                    {
                        ApplicationArea = all;
                        Caption = 'IMOS Setup';
                        Image = Setup;
                        RunObject = page "IMOS Setup";
                    }
                }
                group("IMOS Staging")
                {
                    action("IMOS Invoice Staging List")
                    {
                        ApplicationArea = all;
                        Caption = 'IMOS Invoice Staging List';
                        Image = ListPage;
                    //                        RunObject = page "IMOS Invoice Staging List";
                    }
                }
            }
            group(DNV)
            {
                Group("DNV Outbound Transaction")
                {
                    action("DNV Outbound Log")
                    {
                        ApplicationArea = all;
                        Caption = 'DNV Outbound Log';
                        Image = Log;
                        RunObject = page "DNV Outbound Log";
                    }
                }
                Group("DNV Outbound Setup")
                {
                    action("DNV Integration Setup")
                    {
                        ApplicationArea = all;
                        Caption = 'DNV Integration Setup';
                        Image = Setup;
                        RunObject = page "DNV Integration Setup";
                    }
                }
                Group("DNV Inbound API Transaction Page")
                {
                    action("Purchase Invoice Inbound API")
                    {
                        ApplicationArea = all;
                        Caption = 'Purchase Invoice Inbound API';
                        Image = ListPage;
                        RunObject = page "Purchase Invoice Inbound API";
                    }
                    action("Committed Cost Inbound API")
                    {
                        ApplicationArea = all;
                        Caption = 'Committed Cost Inbound API';
                        Image = ListPage;
                        RunObject = page "Committed Cost Inbound API";
                    }
                    action("Crew Member Inbound API")
                    {
                        ApplicationArea = all;
                        Caption = 'Crew Member Inbound API';
                        Image = ListPage;
                        RunObject = page "Crew Member Inbound API";
                    }
                    action("Crew Payroll Inbound API")
                    {
                        ApplicationArea = all;
                        Caption = 'Crew Payroll Inbound API';
                        Image = ListPage;
                        RunObject = page "Crew Payroll Inbound API";
                    }
                }
                Group("DNV Inbound Transaction List Page")
                {
                    action("Purchase Invoice Inbound List")
                    {
                        ApplicationArea = all;
                        Caption = 'Purchase Invoice Inbound List';
                        Image = ListPage;
                        RunObject = page "Purchase Invoice Inbound List";
                    }
                    action("Committed Cost Inbound List")
                    {
                        ApplicationArea = all;
                        Caption = 'Committed Cost Inbound List';
                        Image = ListPage;
                        RunObject = page "Committed Cost Inbounds";
                    }
                    action("Crew Member Inbound List")
                    {
                        ApplicationArea = all;
                        Caption = 'Crew Member Inbound List';
                        Image = ListPage;
                        RunObject = page "Crew Member Inbound List";
                    }
                    action("Crew Payroll Inbound List")
                    {
                        ApplicationArea = all;
                        Caption = 'Crew Payroll Inbound List';
                        Image = ListPage;
                        RunObject = page "Crew Payroll Inbound List";
                    }
                }
                Group("Inbound Setup")
                {
                    action("DNV Inbound Integration Setup")
                    {
                        ApplicationArea = all;
                        Caption = 'DNV Inbound Integration Setup';
                        Image = Setup;
                        RunObject = page "DNV Integration Setup";
                    }
                }
                Group("DNV Inbound Transaction Error log")
                {
                    action("Inbound Error Log Entry")
                    {
                        ApplicationArea = all;
                        Caption = 'Inbound Error Log Entry';
                        Image = Setup;
                        RunObject = page "Inbound Error Log Entry";
                    }
                }
            }
            group(Concur)
            {
                Caption = 'Concur';

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
                group("Sample API")
                {
                    action(FinanTransSampleAPI)
                    {
                        Caption = 'Financial Transaction Sample API';
                        ApplicationArea = all;
                        Image = Process;

                        trigger OnAction()
                        var
                            PBAPIToken: Codeunit "Concur Financial Transaction";
                        begin
                            PBAPIToken.GetFinancialTransactions(false);
                        end;
                    }
                    action(ExpenseAttendeeSampleAPI)
                    {
                        Caption = 'Expense Attendee Sample API';
                        ApplicationArea = all;
                        Image = Process;

                        trigger OnAction()
                        var
                            ExpenseAttendeeResponsCodeunit: Codeunit "Concur Expense Attendee Resp.";
                        begin
                        //ExpenseAttendeeResponsCodeunit.GetExpenseAttendee(false); //PS009
                        end;
                    }
                    action(ConcurInboundImageSampleAPI)
                    {
                        Caption = 'Expense Image Url Log';
                        ApplicationArea = all;
                        Image = Process;

                        trigger OnAction()
                        var
                            ExpenseImageCodeunit: Codeunit "Concur Expense_Image";
                        begin
                            ExpenseImageCodeunit.GetExpenseImageUrl(false);
                        end;
                    }
                }
                group(ConCurPages)
                {
                    Caption = 'Concur Staging Pages';

                    action(ConcurInbFinExpense)
                    {
                        ApplicationArea = all;
                        Caption = 'Concur Inbound Financial Expense';
                        Image = ImportLog;
                        RunObject = page "Concur Inbound Financial Expen";
                    }
                    action("Concur Expense Attendee")
                    {
                        ApplicationArea = all;
                        Caption = 'Concur Expense Attendee';
                        Image = ImportLog;
                        RunObject = page "Concur Inbound AttendeeStaging";
                    }
                    action("Concur Inbound Image")
                    {
                        ApplicationArea = all;
                        Caption = 'Concur Inbound Image';
                        Image = ImportLog;
                        RunObject = page "Concur Inbound Image";
                    }
                }
                group(ConcurLog)
                {
                    Caption = 'Concur API Log';

                    action(ConcurStaging)
                    {
                        ApplicationArea = all;
                        Caption = 'Concur API Staging Log';
                        Image = ImportLog;
                        RunObject = page "Concur API Response";
                    }
                    action(AttendeesAPI)
                    {
                        ApplicationArea = all;
                        Caption = 'Concur Expense Attendees API';
                        Image = ImportLog;
                        RunObject = page ConcurExpenseAttendeeAPI;
                    }
                    action("Expense Image Url Log")
                    {
                        ApplicationArea = all;
                        Caption = 'Expense Image Url Log';
                        Image = ImportLog;
                    //RunObject = page "Expense Image Url Log";
                    }
                    //PS004 Start
                    action("Concur Outbound Log")
                    {
                        ApplicationArea = all;
                        Image = ImportLog;
                        Caption = 'Concur Outbound Log';
                        RunObject = page "Concur Outbound Log";
                    }
                    action("Concur API Inbound Log")
                    {
                        ApplicationArea = all;
                        Caption = 'Concur API Inbound Log';
                        Image = Log;
                        RunObject = page "Concur API Inbound List";
                    }
                //PS004 End
                }
            }
            group(BankAPI)
            {
                Caption = 'Bank API';

                action("Bank API Setup")
                {
                    ApplicationArea = all;
                    Caption = 'Bank API Setup';
                    Image = Setup;
                    RunObject = page "Bank API Setup";
                }
                group(HSBC)
                {
                    action(BatchSetup)
                    {
                        ApplicationArea = all;
                        Caption = 'HSBC Batch Setup';
                        Image = ImportLog;
                        RunObject = page "HSBC Batch Setup";
                    }
                    action(HSBCInboundStaging)
                    {
                        ApplicationArea = all;
                        Caption = 'HSBC Inbound Staging';
                        Image = ImportLog;
                        RunObject = page "HSBC Inbound Staging";
                    }
                    action(HSBCNotification)
                    {
                        ApplicationArea = all;
                        Caption = 'HSBC Notification';
                        Image = ImportLog;
                        RunObject = page "HSBC Notification";
                    }
                    action(HSBCOutboundStaging)
                    {
                        ApplicationArea = all;
                        Caption = 'HSBC Outbound Staging';
                        Image = ImportLog;
                        RunObject = page "HSBC Outbound Staging";
                    }
                }
                group(Citi)
                {
                    action(CitiBatchSetup)
                    {
                        ApplicationArea = all;
                        Caption = 'Citi Batch Setup';
                        Image = ImportLog;
                        RunObject = page "Citi Batch Setup";
                    }
                    action(CitiInboundStaging)
                    {
                        ApplicationArea = all;
                        Caption = 'Citi Inbound Staging';
                        Image = ImportLog;
                        RunObject = page "Citi Inbound Staging";
                    }
                    action(CitiInboundStatementId)
                    {
                        ApplicationArea = all;
                        Caption = 'Citi Inbound Statement Id';
                        Image = ImportLog;
                        RunObject = page "Citi Inbound Statement Id";
                    }
                    action(CitiOutboundStaging)
                    {
                        ApplicationArea = all;
                        Caption = 'Citi Outbound Staging';
                        Image = ImportLog;
                        RunObject = page "Citi Outbound Staging";
                    }
                }
            }
        }
        area(Promoted)
        {
            group("IMOS Master_")
            {
                Caption = 'IMOS';

                group(IMOS_SETUPGROUP)
                {
                    Caption = 'IMOS Setup';

                    actionref(IMOSSETUP1; IMOSSetup)
                    {
                    }
                }
                group("IMOSMaster")
                {
                    Caption = 'IMOS';

                    actionref(IMOSAPILOG; "IMOS API Log")
                    {
                    }
                    actionref(COMPANYDIMENSIONMAPPING; "Company Dimension Mapping")
                    {
                    }
                    actionref("Company Mapping1"; "Company Mapping")
                    {
                    }
                }
                group("IMOS Staging_")
                {
                    Caption = 'IMOS Staging';

                    actionref("IMOS Invoice Staging List1"; "IMOS Invoice Staging List")
                    {
                    }
                }
            }
            group("DNV Master")
            {
                Caption = 'DNV';

                Group("DNVOutboundTransaction")
                {
                    Caption = 'DNV Outbound Transaction';

                    actionref(DNVOutboundLog; "DNV Outbound Log")
                    {
                    }
                }
                Group("DNVOutboundSetup")
                {
                    Caption = 'DNV Outbound Setup';

                    actionref(DNVIntegrationSetup; "DNV Integration Setup")
                    {
                    }
                }
                Group("DNVInboundAPITransactionPage")
                {
                    Caption = 'DNV Inbound API Transaction Page';

                    actionref(PurchaseInvoiceInboundAPI; "Purchase Invoice Inbound API")
                    {
                    }
                    actionref(CommittedCostInboundAPI; "Committed Cost Inbound API")
                    {
                    }
                    actionref(CrewMemberInboundAPI; "Crew Member Inbound API")
                    {
                    }
                    actionref(CrewPayrollInboundAPI; "Crew Payroll Inbound API")
                    {
                    }
                }
                Group("DNVInboundTransactionListPage")
                {
                    Caption = 'DNV Inbound Transaction List Page';

                    actionref("Purchase Invoice Inbound List_Promoted"; "Purchase Invoice Inbound List")
                    {
                    }
                    actionref("Committed Cost Inbound List_Promoted"; "Committed Cost Inbound List")
                    {
                    }
                    actionref("Crew Member Inbound List_Promoted"; "Crew Member Inbound List")
                    {
                    }
                    actionref("Crew Payroll Inbound List_Promoted"; "Crew Payroll Inbound List")
                    {
                    }
                }
                Group("InboundSetup")
                {
                    caption = 'DNV Inbound Setup';

                    actionref("DNV Inbound Integration Setup_Promoted"; "DNV Inbound Integration Setup")
                    {
                    }
                }
                group("Inbound Error Log")
                {
                    Caption = 'DNV Inbound Error Log';

                    actionref("Inbound Error Log Entry_Promoted"; "Inbound Error Log Entry")
                    {
                    }
                }
            }
            group(Concur_)
            {
                Caption = 'Concur';

                actionref(ConcurSetup1; ConcurSetup)
                {
                }
                group(SampleAPI_G)
                {
                    Caption = 'Sample API';

                    actionref(FinanTransSampleAPI1; FinanTransSampleAPI)
                    {
                    }
                    actionref(ExpenseAttendeeSampleAPI1; ExpenseAttendeeSampleAPI)
                    {
                    }
                    actionref(ConcurInboundImageSampleAPI1; ConcurInboundImageSampleAPI)
                    {
                    }
                }
                group(ConcurPages_g)
                {
                    Caption = 'Concur Staging Pages';

                    actionref(ConcurInbFinExpense1; ConcurInbFinExpense)
                    {
                    }
                    actionref(ConcurInboundExpenseAtt; "Concur Expense Attendee")
                    {
                    }
                    actionref(ConcurInboundImage1; "Concur Inbound Image")
                    {
                    }
                }
                group(ConcurLog_g)
                {
                    Caption = 'Concur API Log';

                    actionref(ConcurStaging1; ConcurStaging)
                    {
                    }
                    actionref(AttendeesAPI1; AttendeesAPI)
                    {
                    }
                    actionref("Expense Image Url Log1"; "Expense Image Url Log")
                    {
                    }
                    actionref("Concur API Inbound Log_Promoted"; "Concur API Inbound Log")
                    {
                    }
                }
            }
            group(BankAPI_g)
            {
                Caption = 'Bank API';

                actionref("Bank API Setup1"; "Bank API Setup")
                {
                }
                group(HSBC_g)
                {
                    Caption = 'HSBC';

                    actionRef(BatchSetup1; BatchSetup)
                    {
                    }
                    actionref(HSBCNotification1; HSBCNotification)
                    {
                    }
                    actionref(HSBCInboundStaging1; HSBCInboundStaging)
                    {
                    }
                    actionref(HSBCOutboundStaging1; HSBCOutboundStaging)
                    {
                    }
                }
                group(Citi_g)
                {
                    Caption = 'Citi';

                    actionref(CitiBatchSetup1; CitiBatchSetup)
                    {
                    }
                    actionref(CitiInboundStatementId1; CitiInboundStatementId)
                    {
                    }
                    actionref(CitiInboundStaging1; CitiInboundStaging)
                    {
                    }
                    actionref(CitiOutboundStaging1; CitiOutboundStaging)
                    {
                    }
                }
            }
        }
    }
}
