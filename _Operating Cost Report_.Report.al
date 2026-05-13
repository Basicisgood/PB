report 50166 "Operating Cost Report"
{ //PS015
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    // WordLayout = './HSBC payment review layout.docx';
    //WordLayout = './HSBCpaymentreview.docx';
    RDLCLayout = 'src/ReportLayout/Operating Cost Report.rdl';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Operating Costs Report Setup"; "Operating Costs Report Setup")
        {
            column(Header; Header)
            {
            }
            column(Table_Name; "Table Name")
            {
            }
            column(RMT_List; "RMT List")
            {
            }
            column(Sub_Header; "Sub Header")
            {
            }
            column(Account_Group; "Account Group")
            {
            }
            column(Year; format(Year))
            {
            }
            column(companyname; CompanyName1)
            {
            }
            dataitem("G/L Account"; "G/L Account")
            {
                //DataItemLink = "Account Group" = field("Account Group");
                column(ActualAmt; ActualAmt)
                {
                }
                column(BudgetAmt; BudgetAmt)
                {
                }
                trigger OnPreDataItem()
                var
                begin
                    AccNo:='';
                    GLAccount1.Reset();
                    GLAccount1.ChangeCompany(MasterCompany);
                    GLAccount1.SetRange("Account Group", "Operating Costs Report Setup"."Account Group");
                    if GLAccount1.FindSet()then repeat if AccNo = '' then AccNo:=GLAccount1."No."
                            else
                                AccNo:=AccNo + '|' + GLAccount1."No.";
                        until GLAccount1.Next() = 0;
                    "G/L Account".SetFilter("No.", AccNo);
                end;
                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    ActualAmt:=0;
                    BudgetAmt:=0;
                    GLEntry.reset;
                    //GLEntry.ChangeCompany(CompanyName);
                    GLEntry.SetCurrentKey("G/L Account No.", "Business Unit Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date");
                    GLEntry.SetRange("G/L Account No.", "G/L Account"."No.");
                    if BUFilter <> '' then glentry.SetFilter("Business Unit Code", BUFilter);
                    if "Operating Costs Report Setup".FD10 <> '' then GLEntry.SetFilter("Global Dimension 2 Code", "Operating Costs Report Setup".FD10);
                    GLentry.SetFilter("Posting Date", '%1..%2', DMY2Date(1, 1, year), DMY2Date(31, 12, year));
                    if glentry.findset then repeat ActualAmt+=GLEntry.Amount;
                        until GLEntry.next = 0;
                    GLEntry.reset;
                    GLEntry.ChangeCompany(BudgetCompany);
                    GLEntry.SetCurrentKey("G/L Account No.", "Business Unit Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date");
                    GLEntry.SetRange("G/L Account No.", "G/L Account"."No.");
                    if BUFilter <> '' then glentry.SetFilter("Business Unit Code", BUFilter);
                    if "Operating Costs Report Setup".FD10 <> '' then GLEntry.SetFilter("Global Dimension 2 Code", "Operating Costs Report Setup".FD10);
                    GLentry.SetFilter("Posting Date", '%1..%2', DMY2Date(1, 1, year), DMY2Date(31, 12, year));
                    if glentry.findset then repeat BudgetAmt+=GLEntry.Amount;
                        until GLEntry.next = 0;
                /*
                    GLAccount.reset;
                    GLAccount.ChangeCompany(BudgetCompany);
                    GLAccount.SetRange("No.", "G/L Account"."No.");
                    glaccount.SetFilter("Date Filter", '%1..%2', DMY2Date(1, 1, year), DMY2Date(31, 12, year));
                    if BUFilter <> '' then
                        glaccount.SetFilter("Business Unit Filter", BUFilter);
                    if "Operating Costs Report Setup".FD10 <> '' then
                        "G/L Account".SetFilter("Global Dimension 2 Filter", "Operating Costs Report Setup".FD10);
                    if glaccount.findfirst then begin
                        GLAccount.CalcFields("Net Change");
                        BudgetAmt := GLAccount."Net Change";
                    end;
                    */
                end;
            }
            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                CompanyRec.Get(CompanyName);
                CompanyName1:=CompanyRec."Display Name";
                if Year = 0 then Year:=Date2DMY(today, 3);
                COmpanyMapping.reset;
                COmpanyMapping.SetRange("Master Data Company", true);
                if COmpanyMapping.FindFirst()then MasterCompany:=COmpanyMapping."BC Company Name"
                else
                    Error('Master Data Company not found in Company Mapping.');
                COmpanyMapping.reset;
                COmpanyMapping.SetRange("Budget Company", true);
                if COmpanyMapping.FindFirst()then budgetCompany:=COmpanyMapping."BC Company Name"
                else
                    Error('Budget Company not found in Company Mapping.');
                BUFilter:='';
                if DBaseFilter <> '' then begin
                    COmpanyMapping.reset;
                    COmpanyMapping.SetRange(DBase, DBaseFilter);
                    if COmpanyMapping.FindSet()then repeat if BUFilter = '' then BUFilter:=COmpanyMapping."BC Company Name"
                            else
                                BUFilter:=BUFilter + '|' + COmpanyMapping."BC Company Name";
                        until COmpanyMapping.Next() = 0;
                end;
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
                    field(Year; Year)
                    {
                        ApplicationArea = All;
                    }
                    field(DBaseFilter; DBaseFilter)
                    {
                        Caption = 'DBase';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
    var Year: Integer;
    SubSegment: Code[20];
    AmountVal: array[12]of Decimal;
    CompanyName1: text;
    CompanyRec: Record Company;
    GLAccount: Record "G/L Account";
    MasterCompany: Text[30];
    BudgetCompany: Text[30];
    GLAccount1: Record "G/L Account";
    AccNo: text;
    CompanyMapping: Record "Company Name Mapping";
    BUFilter: text;
    DBaseFilter: text;
    ActualAmt: Decimal;
    BudgetAmt: Decimal;
    GLEntry: Record "G/L Entry";
}
