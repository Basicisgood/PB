xmlport 50109 "Concur Accrual"
{
    Caption = 'Concur Accrual';
    Direction = Import;
    UseRequestPage = false;
    TableSeparator = '<NewLine>';
    Format = VariableText;
    TextEncoding = UTF16;

    schema
    {
    textelement(Root)
    {
    tableelement(ExpenseReportStaging;
    "Expense Report Staging")
    {
    fieldelement(EmployeeID;
    ExpenseReportStaging."Employee ID")
    {
    }
    textelement(Employee)
    {
    }
    fieldelement(Group;
    ExpenseReportStaging."Group")
    {
    }
    fieldelement(Employee;
    ExpenseReportStaging.Employee)
    {
    }
    fieldelement(Company;
    ExpenseReportStaging.Company)
    {
    }
    fieldelement(NewFD5;
    ExpenseReportStaging."New FD5")
    {
    }
    fieldelement(Vessel;
    ExpenseReportStaging.Vessel)
    {
    }
    fieldelement(PaymentType;
    ExpenseReportStaging."Payment Type")
    {
    }
    fieldelement(ApprovalStatus;
    ExpenseReportStaging."Approval Status")
    {
    }
    fieldelement(ReportName;
    ExpenseReportStaging."Report Name")
    {
    }
    textelement(DateFirstSubmitted)
    {
    trigger OnAfterAssignVariable()
    var
        day: Integer;
        month: Integer;
        year: Integer;
    begin
        if DateFirstSubmitted <> '' then begin
            Evaluate(year, CopyStr(DateFirstSubmitted, 1, 4));
            Evaluate(month, CopyStr(DateFirstSubmitted, 6, 2));
            Evaluate(day, CopyStr(DateFirstSubmitted, 9, 2));
            ExpenseReportStaging."Date First Submitted":=DMY2Date(day, month, year);
        end;
    end;
    }
    fieldelement(AccountCode;
    ExpenseReportStaging."Account Code")
    {
    }
    fieldelement(ExpensesType;
    ExpenseReportStaging."Expenses Type")
    {
    }
    fieldelement(Vendor;
    ExpenseReportStaging.Vendor)
    {
    }
    textelement(PostedDate)
    {
    trigger OnAfterAssignVariable()
    var
        day: Integer;
        month: Integer;
        year: Integer;
    begin
        if PostedDate <> '' then begin
            Evaluate(year, CopyStr(PostedDate, 1, 4));
            Evaluate(month, CopyStr(PostedDate, 6, 2));
            Evaluate(day, CopyStr(PostedDate, 9, 2));
            ExpenseReportStaging."Posted Date":=DMY2Date(day, month, year);
        end;
    end;
    }
    textelement(TransactionDate)
    {
    trigger OnAfterAssignVariable()
    var
        day: Integer;
        month: Integer;
        year: Integer;
    begin
        if TransactionDate <> '' then begin
            Evaluate(year, CopyStr(TransactionDate, 1, 4));
            Evaluate(month, CopyStr(TransactionDate, 6, 2));
            Evaluate(day, CopyStr(TransactionDate, 9, 2));
            ExpenseReportStaging."Transaction Date":=DMY2Date(day, month, year);
        end;
    end;
    }
    fieldelement(CountryRegion;
    ExpenseReportStaging."Country/Region")
    {
    }
    fieldelement(ReimbursementCurrency;
    ExpenseReportStaging."Reimbursement Currency")
    {
    }
    textelement(PostedAmount)
    {
    trigger OnAfterAssignVariable()
    var
        amt: Decimal;
    begin
        Evaluate(amt, PostedAmount);
        ExpenseReportStaging."Posted Amount":=amt;
    end;
    }
    trigger OnAfterInitRecord()
    begin
        if FirstLine then begin
            FirstLine:=false;
            currXMLport.Skip();
        end;
        ExpenseReportStaging."CSV file":=CSVName;
        ExpenseReportStaging."Posting Date":=g_dat_PostingDate;
    end;
    }
    }
    }
    procedure SetPostingDate(postingDate: Date)
    begin
        g_dat_PostingDate:=postingDate;
    end;
    procedure SetFileName(filename: text)
    begin
        CSVName:=filename;
    end;
    trigger OnPreXmlPort()
    begin
        FirstLine:=true;
    end;
    var FirstLine: Boolean;
    CSVName: Text;
    g_dat_PostingDate: Date;
}
