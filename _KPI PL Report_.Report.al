report 50164 "KPI PL Report"
{ //PS013
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    // WordLayout = './HSBC payment review layout.docx';
    //WordLayout = './HSBCpaymentreview.docx';
    RDLCLayout = 'src/ReportLayout/KPI PL Report.rdl';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("KPI PL Report Setup"; "KPI PL Report Setup")
        {
            column(Header; Header)
            {
            }
            column(Row_Level; "Row Level")
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
                column(Amount_1; AmountVal[1])
                {
                }
                column(Amount_2; AmountVal[2])
                {
                }
                column(Amount_3; AmountVal[3])
                {
                }
                column(Amount_4; AmountVal[4])
                {
                }
                column(Amount_5; AmountVal[5])
                {
                }
                column(Amount_6; AmountVal[6])
                {
                }
                column(Amount_7; AmountVal[7])
                {
                }
                column(Amount_8; AmountVal[8])
                {
                }
                column(Amount_9; AmountVal[9])
                {
                }
                column(Amount_10; AmountVal[10])
                {
                }
                column(Amount_11; AmountVal[11])
                {
                }
                column(Amount_12; AmountVal[12])
                {
                }
                trigger OnPreDataItem()
                var
                begin
                    AccNo:='';
                    GLAccount1.Reset();
                    GLAccount1.ChangeCompany(MasterCompany);
                    GLAccount1.SetRange("Account Group", "KPI PL Report Setup"."Account Group");
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
                    Clear(AmountVal);
                    GLEntry.reset;
                    GLEntry.SetCurrentKey("G/L Account No.", "Posting Date");
                    GLEntry.SetRange("G/L Account No.", "G/L Account"."No.");
                    glentry.SetFilter("Posting Date", '%1..%2', DMY2Date(1, 1, year), DMY2Date(31, 1, year));
                    if glentry.findset then repeat AmountVal[1]+=GLEntry.Amount;
                        until GLEntry.next = 0;
                    glentry.SetFilter("Posting Date", '%1..%2', DMY2Date(1, 2, year), CalcDate('-1D', DMY2Date(1, 3, year)));
                    if glentry.findfirst then repeat AmountVal[2]+=GLEntry.Amount;
                        until GLEntry.next = 0;
                    glentry.SetFilter("Posting Date", '%1..%2', DMY2Date(1, 3, year), DMY2Date(31, 3, year));
                    if glentry.findfirst then repeat AmountVal[3]+=GLEntry.Amount;
                        until GLEntry.next = 0;
                    glentry.SetFilter("Posting Date", '%1..%2', DMY2Date(1, 4, year), DMY2Date(30, 4, year));
                    if glentry.findfirst then repeat AmountVal[4]+=GLEntry.Amount;
                        until GLEntry.next = 0;
                    glentry.SetFilter("Posting Date", '%1..%2', DMY2Date(1, 5, year), DMY2Date(31, 5, year));
                    if glentry.findfirst then repeat AmountVal[5]+=GLEntry.Amount;
                        until GLEntry.next = 0;
                    glentry.SetFilter("Posting Date", '%1..%2', DMY2Date(1, 6, year), DMY2Date(30, 6, year));
                    if glentry.findfirst then repeat AmountVal[6]+=GLEntry.Amount;
                        until GLEntry.next = 0;
                    glentry.SetFilter("Posting Date", '%1..%2', DMY2Date(1, 7, year), DMY2Date(31, 7, year));
                    if glentry.findfirst then repeat AmountVal[7]+=GLEntry.Amount;
                        until GLEntry.next = 0;
                    glentry.SetFilter("Posting Date", '%1..%2', DMY2Date(1, 8, year), DMY2Date(31, 8, year));
                    if glentry.findfirst then repeat AmountVal[8]+=GLEntry.Amount;
                        until GLEntry.next = 0;
                    glentry.SetFilter("Posting Date", '%1..%2', DMY2Date(1, 9, year), DMY2Date(30, 9, year));
                    if glentry.findfirst then repeat AmountVal[9]+=GLEntry.Amount;
                        until GLEntry.next = 0;
                    glentry.SetFilter("Posting Date", '%1..%2', DMY2Date(1, 10, year), DMY2Date(31, 10, year));
                    if glentry.findfirst then repeat AmountVal[10]+=GLEntry.Amount;
                        until GLEntry.next = 0;
                    glentry.SetFilter("Posting Date", '%1..%2', DMY2Date(1, 11, year), DMY2Date(30, 11, year));
                    if glentry.findfirst then repeat AmountVal[11]+=GLEntry.Amount;
                        until GLEntry.next = 0;
                    glentry.SetFilter("Posting Date", '%1..%2', DMY2Date(1, 12, year), DMY2Date(31, 12, year));
                    if glentry.findfirst then repeat AmountVal[12]+=GLEntry.Amount;
                        until GLEntry.next = 0;
                /*
                    GLAccount.reset;
                    GLAccount.SetRange("No.", "G/L Account"."No.");
                    glaccount.SetFilter("Date Filter", '%1..%2', DMY2Date(1, 1, year), DMY2Date(31, 1, year));
                    if glaccount.findfirst then begin
                        GLAccount.CalcFields("Net Change");
                        AmountVal[1] := GLAccount."Net Change";
                    end;
                    glaccount.SetFilter("Date Filter", '%1..%2', DMY2Date(1, 2, year), CalcDate('-1D', DMY2Date(1, 3, year)));
                    if glaccount.findfirst then begin
                        GLAccount.CalcFields("Net Change");
                        AmountVal[2] := GLAccount."Net Change";
                    end;
                    glaccount.SetFilter("Date Filter", '%1..%2', DMY2Date(1, 3, year), DMY2Date(31, 3, year));
                    if glaccount.findfirst then begin
                        GLAccount.CalcFields("Net Change");
                        AmountVal[3] := GLAccount."Net Change";
                    end;
                    glaccount.SetFilter("Date Filter", '%1..%2', DMY2Date(1, 4, year), DMY2Date(30, 4, year));
                    if glaccount.findfirst then begin
                        GLAccount.CalcFields("Net Change");
                        AmountVal[4] := GLAccount."Net Change";
                    end;
                    glaccount.SetFilter("Date Filter", '%1..%2', DMY2Date(1, 5, year), DMY2Date(31, 5, year));
                    if glaccount.findfirst then begin
                        GLAccount.CalcFields("Net Change");
                        AmountVal[5] := GLAccount."Net Change";
                    end;
                    glaccount.SetFilter("Date Filter", '%1..%2', DMY2Date(1, 6, year), DMY2Date(30, 6, year));
                    if glaccount.findfirst then begin
                        GLAccount.CalcFields("Net Change");
                        AmountVal[6] := GLAccount."Net Change";
                    end;
                    glaccount.SetFilter("Date Filter", '%1..%2', DMY2Date(1, 7, year), DMY2Date(31, 7, year));
                    if glaccount.findfirst then begin
                        GLAccount.CalcFields("Net Change");
                        AmountVal[7] := GLAccount."Net Change";
                    end;
                    glaccount.SetFilter("Date Filter", '%1..%2', DMY2Date(1, 8, year), DMY2Date(31, 8, year));
                    if glaccount.findfirst then begin
                        GLAccount.CalcFields("Net Change");
                        AmountVal[8] := GLAccount."Net Change";
                    end;
                    glaccount.SetFilter("Date Filter", '%1..%2', DMY2Date(1, 9, year), DMY2Date(30, 9, year));
                    if glaccount.findfirst then begin
                        GLAccount.CalcFields("Net Change");
                        AmountVal[9] := GLAccount."Net Change";
                    end;
                    glaccount.SetFilter("Date Filter", '%1..%2', DMY2Date(1, 10, year), DMY2Date(31, 10, year));
                    if glaccount.findfirst then begin
                        GLAccount.CalcFields("Net Change");
                        AmountVal[10] := GLAccount."Net Change";
                    end;
                    glaccount.SetFilter("Date Filter", '%1..%2', DMY2Date(1, 11, year), DMY2Date(30, 11, year));
                    if glaccount.findfirst then begin
                        GLAccount.CalcFields("Net Change");
                        AmountVal[11] := GLAccount."Net Change";
                    end;
                    glaccount.SetFilter("Date Filter", '%1..%2', DMY2Date(1, 12, year), DMY2Date(31, 12, year));
                    if glaccount.findfirst then begin
                        GLAccount.CalcFields("Net Change");
                        AmountVal[12] := GLAccount."Net Change";
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
    GLAccount1: Record "G/L Account";
    AccNo: text;
    CompanyMapping: Record "Company Name Mapping";
    GLEntry: Record "G/L Entry";
}
