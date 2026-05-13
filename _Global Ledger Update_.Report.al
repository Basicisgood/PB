report 50109 "Global Ledger Update"
{
    ApplicationArea = All;
    Caption = 'Global Ledger Update';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Company; Company)
        {
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemTableView = sorting("Entry No.");

                trigger OnPreDataItem()
                begin
                    "Vendor Ledger Entry".ChangeCompany(Company.Name);
                end;
                trigger OnAfterGetRecord()
                begin
                    GBVendLedgEntry.Init();
                    GBVendLedgEntry.TransferFields("Vendor Ledger Entry");
                    GBVendLedgEntry."Company Name":=Company.Name;
                    GBVendLedgEntry."Company Code":=Company.Name;
                    IF not GBVendLedgEntry.Insert()then GBVendLedgEntry.Modify();
                end;
            }
            dataitem("Detailed Vendor Ledg. Entry"; "Detailed Vendor Ledg. Entry")
            {
                DataItemTableView = sorting("Entry No.");

                trigger OnPreDataItem()
                begin
                    "Detailed Vendor Ledg. Entry".ChangeCompany(Company.Name);
                end;
                trigger OnAfterGetRecord()
                begin
                    GBDetailedVendLedgEntry.Init();
                    GBDetailedVendLedgEntry.TransferFields("Detailed Vendor Ledg. Entry");
                    GBDetailedVendLedgEntry."Company Name":=Company.Name;
                    IF NOT GBDetailedVendLedgEntry.Insert()then GBDetailedVendLedgEntry.Modify();
                end;
            }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemTableView = sorting("Entry No.");

                trigger OnPreDataItem()
                begin
                    "Cust. Ledger Entry".ChangeCompany(Company.Name);
                end;
                trigger OnAfterGetRecord()
                begin
                    GBCustLedgEntry.Init();
                    GBCustLedgEntry.TransferFields("Cust. Ledger Entry");
                    GBCustLedgEntry."Company Name":=Company.Name;
                    GBCustLedgEntry."Company Code":=Company.Name;
                    IF NOT GBCustLedgEntry.Insert()then GBCustLedgEntry.Modify();
                end;
            }
            dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
            {
                DataItemTableView = sorting("Entry No.");

                trigger OnPreDataItem()
                begin
                    "Detailed Cust. Ledg. Entry".ChangeCompany(Company.Name);
                end;
                trigger OnAfterGetRecord()
                begin
                    GBDetailedCustLedgEntry.Init();
                    GBDetailedCustLedgEntry.TransferFields("Detailed Cust. Ledg. Entry");
                    GBDetailedCustLedgEntry."Company Name":=Company.Name;
                    IF NOT GBDetailedCustLedgEntry.Insert()then GBDetailedCustLedgEntry.Modify();
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
        GBCustLedgEntry.DeleteAll();
        GBDetailedCustLedgEntry.DeleteAll();
        GBVendLedgEntry.DeleteAll();
        GBDetailedVendLedgEntry.DeleteAll();
    end;
    trigger OnPostReport()
    begin
        Message('Done');
    end;
    var GBCustLedgEntry: Record "Global Cust. Ledger entry";
    GBDetailedCustLedgEntry: Record "GB Detailed Cust. Ledg. Entry";
    GBVendLedgEntry: Record "Global Vendor Ledger Entry";
    GBDetailedVendLedgEntry: Record "GB Detailed Vendor Ledg. Entry";
}
