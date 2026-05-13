report 50161 "Global Employee Ledger Update"
{
    ApplicationArea = All;
    Caption = 'Global Employee Ledger Update';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Company; Company)
        {
            dataitem("Employee Ledger Entry"; "Employee Ledger Entry")
            {
                DataItemTableView = sorting("Entry No.");

                trigger OnPreDataItem()
                begin
                    "Employee Ledger Entry".ChangeCompany(Company.Name);
                end;
                trigger OnAfterGetRecord()
                begin
                    GBEmpLedgEntry.Init();
                    GBEmpLedgEntry.TransferFields("Employee Ledger Entry");
                    GBEmpLedgEntry."Company Code":=Company.Name;
                    IF not GBEmpLedgEntry.Insert()then GBEmpLedgEntry.Modify();
                end;
            }
            dataitem("Detailed Employee Ledger Entry"; "Detailed Employee Ledger Entry")
            {
                DataItemTableView = sorting("Entry No.");

                trigger OnPreDataItem()
                begin
                    "Detailed Employee Ledger Entry".ChangeCompany(Company.Name);
                end;
                trigger OnAfterGetRecord()
                begin
                    GBDetailedEmpLedgEntry.Init();
                    GBDetailedEmpLedgEntry.TransferFields("Detailed Employee Ledger Entry");
                    GBDetailedEmpLedgEntry."Company Code":=Company.Name;
                    IF NOT GBDetailedEmpLedgEntry.Insert()then GBDetailedEmpLedgEntry.Modify();
                end;
            }
            trigger OnAfterGetRecord()
            var
                CompanyNameMapping: Record "Company Name Mapping";
            begin
                IF NOT CompanyNameMapping.Get(Company.Name)then CurrReport.Skip();
                if CompanyNameMapping."Test Company" then CurrReport.Skip();
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    trigger OnPreReport()
    begin
        GBEmpLedgEntry.DeleteAll();
        GBDetailedEmpLedgEntry.DeleteAll();
    end;
    trigger OnPostReport()
    begin
        Message('Done');
    end;
    var GBEmpLedgEntry: Record "Global Employee Ledger Entry";
    GBDetailedEmpLedgEntry: Record "GB Det. Employee Ledger Entry";
}
