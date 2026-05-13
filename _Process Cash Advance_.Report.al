report 50200 "Process Cash Advance"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Concur Cash Advance"; "Concur Cash Advance")
        {
            DataItemTableView = sorting("Entry no.")where(Status=filter(Pending|Error));

            trigger OnAfterGetRecord()
            var
                L_CashAdv: Record "Concur Cash Advance";
            begin
                L_CashAdv.GET("Concur Cash Advance"."Entry no.");
                clear(CU_CreateConcurAdv);
                ClearLastError();
                IF CU_CreateConcurAdv.run("Concur Cash Advance")then BEGIN
                    L_CashAdv.Status:=L_CashAdv.Status::Processed;
                    L_CashAdv."Error Description":='';
                END
                else
                begin
                    L_CashAdv.Status:=L_CashAdv.Status::Error;
                    L_CashAdv."Error Description":=GetLastErrorText;
                end;
                L_CashAdv.Modify();
                Commit();
            end;
            trigger OnPreDataItem()
            var
                Len: Integer;
                CompFilter: Code[10];
            begin
                apiSetup.Get();
                apiSetup.TestField("Cash Advance Template Name");
                apiSetup.TestField("Cash Advance Batch Name");
                APISetup.TestField("Cash Advance No. Series");
                // APISetup.TestField("Company Code Prefix");
                Len:=STRLEN(CompanyName);
                CompFilter:=COPYSTR(CompanyName, 2, Len - 1);
                SetRange(EmployeeOrgUnit3Code, CompFilter);
            end;
        }
    }
    var ApiSetup: Record "Concur API Setup";
    CU_CreateConcurAdv: Codeunit "Create Concur Advance";
}
