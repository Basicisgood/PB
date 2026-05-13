report 50121 ARAP
{
    ApplicationArea = All;
    Caption = 'ARAP';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'src\ReportLayout\ARAPReport.rdl';

    dataset
    {
        dataitem("Company Name Mapping"; "Company Name Mapping")
        {
            DataItemTableView = sorting("BC Company Name")where("Master Data Company"=const(false));
            RequestFilterFields = "BC Company Name", DBase;

            trigger OnAfterGetRecord()
            begin
                InsertTempGLE();
                InsertTempCLE();
                InsertTempVLE();
            end;
        }
        dataitem(DetailLines; Integer)
        {
            DataItemTableView = sorting(Number);

            column(Dbase; g_rec_GLEtemp."Report ID")
            {
            }
            column(AccountGrp; g_rec_GLEtemp.Comment)
            {
            }
            column(CurrencyCode; g_rec_GLEtemp."Source Currency Code")
            {
            }
            column(Amount; g_rec_GLEtemp."Source Currency Amount")
            {
            AutoFormatType = 1;
            }
            column(AmountLCY; g_rec_GLEtemp."Source Currency VAT Amount")
            {
            AutoFormatType = 1;
            }
            column(ParentCompany; g_rec_GLEtemp."Receipt image ID")
            {
            }
            column(ParentNo; g_rec_GLEtemp."Business Unit Code")
            {
            }
            column(Companies; g_rec_GLEtemp."Shortcut Dimension 8 Code_PB")
            {
            }
            column(FD9; g_rec_GLEtemp."Shortcut Dimension 9 Code_PB")
            {
            }
            column(DocumentDate; g_rec_GLEtemp."Document Date")
            {
            }
            column(RecePayAmt; g_rec_GLEtemp.Quantity)
            {
            }
            column(FinalRecePay; g_rec_GLEtemp."Job No.")
            {
            }
            column(HeaderText1; HeaderText[1])
            {
            }
            column(HeaderText2; HeaderText[2])
            {
            }
            column(HeaderText3; HeaderText[3])
            {
            }
            column(HeaderText4; HeaderText[4])
            {
            }
            column(HeaderText5; HeaderText[5])
            {
            }
            column(BucketIndex; g_int_BucketIndex)
            {
            }
            column(PrintDetails; PrintDetails)
            {
            }
            column(Name; g_rec_GLEtemp."Remittance Full Name")
            {
            }
            column("CustVendNo"; g_rec_GLEtemp."Source No.")
            {
            }
            column(DocType; g_rec_GLEtemp."Document Type")
            {
            }
            column(DocNo; g_rec_GLEtemp."Document No.")
            {
            }
            column(PostingDate; g_rec_GLEtemp."Posting Date")
            {
            }
            column(DueDate; g_rec_GLEtemp."VAT Reporting Date")
            {
            }
            column(IsBD; g_rec_GLEtemp."Prior-Year Entry")
            {
            }
            column(SkipZero; SkipZero)
            {
            }
            trigger OnPreDataItem()
            begin
                CalcReceviablePayable();
                g_rec_GLEtemp.Reset();
                SetRange(Number, 1, g_rec_GLEtemp.Count);
            end;
            trigger OnAfterGetRecord()
            begin
                if Number = 1 then g_rec_GLEtemp.FindFirst()
                else
                    g_rec_GLEtemp.Next();
                if(g_rec_GLEtemp.Comment = 'B050') or (g_rec_GLEtemp.Comment = 'B075')then begin
                    case AgingBy of AgingBy::"Due Date": g_int_BucketIndex:=GetPeriodIndex(g_rec_GLEtemp."VAT Reporting Date");
                    AgingBy::"Document Date": g_int_BucketIndex:=GetPeriodIndex(g_rec_GLEtemp."Document Date");
                    AgingBy::"Posting Date": g_int_BucketIndex:=GetPeriodIndex(g_rec_GLEtemp."Posting Date");
                    end;
                end;
            end;
        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(AgedAsOf; EndingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Aged As Of';
                        ToolTip = 'Specifies the date that you want the aging calculated for.';
                    }
                    field(AgingBy; AgingBy)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Aging by';
                        OptionCaption = 'Due Date,Posting Date,Document Date';
                        ToolTip = 'Specifies if the aging will be calculated from the due date, the posting date, or the document date.';
                    }
                    field(PeriodLength; PeriodLength)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Period Length';
                        ToolTip = 'Specifies the period for which data is shown in the report. For example, enter "1M" for one month, "30D" for thirty days, "3Q" for three quarters, or "5Y" for five years.';
                    }
                    field(PrintDetails; PrintDetails)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Details';
                        ToolTip = 'Specifies if you want the report to show the detailed entries that add up the total balance for each vendor.';
                    }
                    field(HeadingType; HeadingType)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Heading Type';
                        OptionCaption = 'Date Interval,Number of Days';
                        ToolTip = 'Specifies if the column heading for the three periods will indicate a date interval or the number of days overdue.';
                    }
                    field(SkipZero; SkipZero)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Skip Zero Balance';
                        ToolTip = 'Specifies if you want to skip zero balance in the report.';
                    }
                    field(g_cod_CustNo; g_cod_CustNo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer No.';
                        TableRelation = Customer;
                    }
                    field(g_cod_VendNo; g_cod_VendNo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Vendor No.';
                        TableRelation = Vendor;
                    }
                }
            }
        }
        trigger OnOpenPage()
        begin
            if EndingDate = 0D then EndingDate:=WorkDate();
            if Format(PeriodLength) = '' then Evaluate(PeriodLength, '<1M>');
        end;
    }
    local procedure CalcDates()
    var
        PeriodLength2: DateFormula;
        i: Integer;
    begin
        if not Evaluate(PeriodLength2, StrSubstNo(Text027, PeriodLength))then Error(EnterDateFormulaErr);
        if AgingBy = AgingBy::"Due Date" then begin
            PeriodEndDate[1]:=DMY2Date(31, 12, 9999);
            PeriodStartDate[1]:=EndingDate + 1;
        end
        else
        begin
            PeriodEndDate[1]:=EndingDate;
            PeriodStartDate[1]:=CalcDate(PeriodLength2, EndingDate + 1);
        end;
        for i:=2 to ArrayLen(PeriodEndDate)do begin
            PeriodEndDate[i]:=PeriodStartDate[i - 1] - 1;
            PeriodStartDate[i]:=CalcDate(PeriodLength2, PeriodEndDate[i] + 1);
        end;
        i:=ArrayLen(PeriodEndDate);
        PeriodStartDate[i]:=0D;
        for i:=1 to ArrayLen(PeriodEndDate)do if PeriodEndDate[i] < PeriodStartDate[i]then Error(Text010, PeriodLength);
    end;
    local procedure CreateHeadings()
    var
        i: Integer;
    begin
        if AgingBy = AgingBy::"Due Date" then begin
            HeaderText[1]:=Text000;
            i:=2;
        end
        else
            i:=1;
        while i < ArrayLen(PeriodEndDate)do begin
            if HeadingType = HeadingType::"Date Interval" then HeaderText[i]:=StrSubstNo('%1\..%2', PeriodStartDate[i], PeriodEndDate[i])
            else
                HeaderText[i]:=StrSubstNo('%1 - %2 %3', EndingDate - PeriodEndDate[i] + 1, EndingDate - PeriodStartDate[i] + 1, Text002);
            i:=i + 1;
        end;
        if HeadingType = HeadingType::"Date Interval" then HeaderText[i]:=StrSubstNo('%1\%2', BeforeTok, PeriodStartDate[i - 1])
        else
            HeaderText[i]:=StrSubstNo('%1 %2 %3', AfterTok, EndingDate - PeriodStartDate[i - 1] + 1, Text002);
    end;
    local procedure CalcReceviablePayable()
    var
        l_cod_ParentCompany: Code[20];
        l_dec_PayAmt: Decimal;
        l_dec_ReceAmt: Decimal;
    begin
        foreach l_cod_ParentCompany in g_cod_ParentCompanyList do begin
            Clear(l_dec_ReceAmt);
            Clear(l_dec_PayAmt);
            g_rec_GLEtemp.Reset();
            g_rec_GLEtemp.SetRange("Business Unit Code", l_cod_ParentCompany);
            g_rec_GLEtemp.SetRange("Prior-Year Entry", false);
            g_rec_GLEtemp.SetRange(Comment, 'B050');
            g_rec_GLEtemp.CalcSums("Source Currency VAT Amount");
            l_dec_ReceAmt:=g_rec_GLEtemp."Source Currency VAT Amount";
            g_rec_GLEtemp.Reset();
            g_rec_GLEtemp.SetRange("Business Unit Code", l_cod_ParentCompany);
            g_rec_GLEtemp.SetRange("Prior-Year Entry", false);
            g_rec_GLEtemp.SetRange(Comment, 'B075');
            g_rec_GLEtemp.CalcSums("Source Currency VAT Amount");
            l_dec_ReceAmt:=g_rec_GLEtemp."Source Currency VAT Amount";
            if g_rec_GLEtemp.FindLast()then InsertFinalRecePay(l_dec_ReceAmt, l_dec_PayAmt, l_cod_ParentCompany);
        end;
        Clear(l_dec_ReceAmt);
        Clear(l_dec_PayAmt);
        g_rec_GLEtemp.Reset();
        g_rec_GLEtemp.SetFilter("Business Unit Code", '=%1', '');
        g_rec_GLEtemp.SetFilter(Comment, 'B050');
        g_rec_GLEtemp.SetRange("Prior-Year Entry", false);
        g_rec_GLEtemp.CalcSums("Source Currency VAT Amount");
        l_dec_ReceAmt:=g_rec_GLEtemp."Source Currency VAT Amount";
        g_rec_GLEtemp.ModifyAll("Job No.", 'B050');
        if g_rec_GLEtemp.FindLast()then begin
            g_rec_GLEtemp.Quantity:=l_dec_ReceAmt;
            g_rec_GLEtemp.Modify();
        end;
        g_rec_GLEtemp.Reset();
        g_rec_GLEtemp.SetFilter("Business Unit Code", '=%1', '');
        g_rec_GLEtemp.SetFilter(Comment, 'B075');
        g_rec_GLEtemp.SetRange("Prior-Year Entry", false);
        g_rec_GLEtemp.CalcSums("Source Currency VAT Amount");
        l_dec_PayAmt:=g_rec_GLEtemp."Source Currency VAT Amount";
        g_rec_GLEtemp.ModifyAll("Job No.", 'B075');
        if g_rec_GLEtemp.FindLast()then begin
            g_rec_GLEtemp.Quantity:=l_dec_PayAmt;
            g_rec_GLEtemp.Modify();
        end;
    end;
    local procedure InsertFinalRecePay(p_dec_ReceAmt: Decimal; p_dec_PayAmt: Decimal; p_cod_parentCompany: Code[20])
    var
        B5075: Code[4];
    begin
        if p_dec_ReceAmt + p_dec_PayAmt > 0 then begin
            B5075:='B050';
            g_rec_GLEtemp.Quantity:=p_dec_ReceAmt + p_dec_PayAmt;
        end
        else
        begin
            B5075:='B075';
            g_rec_GLEtemp.Quantity:=(p_dec_ReceAmt + p_dec_PayAmt);
        end;
        g_rec_GLEtemp.Modify();
        g_rec_GLEtemp.Reset();
        g_rec_GLEtemp.SetRange("Business Unit Code", p_cod_parentCompany);
        g_rec_GLEtemp.SetRange("Prior-Year Entry", false);
        g_rec_GLEtemp.ModifyAll("Job No.", B5075);
    end;
    local procedure GetPeriodIndex(Date: Date): Integer var
        i: Integer;
    begin
        for i:=1 to ArrayLen(PeriodEndDate)do if Date in[PeriodStartDate[i] .. PeriodEndDate[i]]then exit(i);
    end;
    local procedure InsertTempCLE()
    var
        l_rec_CLE: Record "Cust. Ledger Entry";
    begin
        l_rec_CLE.Reset();
        l_rec_CLE.ChangeCompany("Company Name Mapping"."BC Company Name");
        l_rec_CLE.SetFilter("Posting Date", '..%1', EndingDate);
        l_rec_CLE.SetFilter("Date Filter", '..%1', EndingDate);
        if g_cod_CustNo <> '' then l_rec_CLE.SetRange("Customer No.", g_cod_VendNo);
        if l_rec_CLE.FindFirst()then repeat InsertTempCLELines(l_rec_CLE);
            until l_rec_CLE.Next() = 0;
    end;
    local procedure InsertTempVLE()
    var
        l_rec_VLE: Record "Vendor Ledger Entry";
    begin
        l_rec_VLE.Reset();
        l_rec_VLE.ChangeCompany("Company Name Mapping"."BC Company Name");
        l_rec_VLE.SetFilter("Posting Date", '..%1', EndingDate);
        l_rec_VLE.SetFilter("Date Filter", '..%1', EndingDate);
        if g_cod_VendNo <> '' then l_rec_VLE.SetRange("Vendor No.", g_cod_VendNo);
        if l_rec_VLE.FindFirst()then repeat InsertTempVLELines(l_rec_VLE);
            until l_rec_VLE.Next() = 0;
    end;
    local procedure InsertTempVLELines(var p_rec_VLE: Record "Vendor Ledger Entry")
    begin
        p_rec_VLE.CalcFields("Remaining Amount", "Remaining Amt. (LCY)");
        if p_rec_VLE."Remaining Amount" = 0 then exit;
        g_rec_GLEtemp.Init();
        g_rec_GLEtemp."Entry No.":=GetLastEntryNo();
        g_rec_GLEtemp."Report ID":="Company Name Mapping".DBase;
        g_rec_GLEtemp."Concur ID":="Company Name Mapping"."BC Company Name";
        g_rec_GLEtemp.Comment:='B075';
        g_rec_GLEtemp."Document No.":=p_rec_VLE."Document No.";
        g_rec_GLEtemp."Posting Date":=p_rec_VLE."Posting Date";
        g_rec_GLEtemp."Document Date":=p_rec_VLE."Document Date";
        g_rec_GLEtemp."VAT Reporting Date":=p_rec_VLE."Due Date";
        g_rec_GLEtemp."Source No.":=p_rec_VLE."Vendor No.";
        g_rec_GLEtemp."Prior-Year Entry":=CheckIsBD(p_rec_VLE."Vendor No.", 'VEND');
        g_rec_GLEtemp."Remittance Full Name":=p_rec_VLE."Vendor Name";
        g_rec_GLEtemp."Document Type":=p_rec_VLE."Document Type";
        g_rec_GLEtemp."Shortcut Dimension 8 Code_PB":=p_rec_VLE."Shortcut Dimension 8 Code_PB";
        g_rec_GLEtemp."Shortcut Dimension 9 Code_PB":=p_rec_VLE."Shortcut Dimension 9 Code_PB";
        GetVLEAmts(p_rec_VLE);
        AddParentCompany(p_rec_VLE."Vendor No.", 'VEND');
        g_rec_GLEtemp.Insert();
    end;
    local procedure GetVLEAmts(var p_rec_VLE: Record "Vendor Ledger Entry")
    var
        GLSetup: Record "General Ledger Setup";
    begin
        g_rec_GLEtemp."Source Currency Code":=p_rec_VLE."Currency Code";
        g_rec_GLEtemp."Source Currency Amount":=p_rec_VLE."Remaining Amount";
        GLSetup.get();
        if GLSetup."LCY Code" = 'USD' then g_rec_GLEtemp."Source Currency VAT Amount":=p_rec_VLE."Remaining Amt. (LCY)"
        else
            g_rec_GLEtemp."Source Currency VAT Amount":=FCYToLCY(EndingDate, p_rec_VLE."Currency Code", p_rec_VLE."Remaining Amount");
    end;
    local procedure CheckIsBD(p_cod_No: Code[20]; Type: Code[4]): Boolean var
        l_rec_VendorTypeMapping: Record "Vendor Type Mapping";
    begin
        l_rec_VendorTypeMapping.Reset();
        if Type = 'VEND' then l_rec_VendorTypeMapping.SetRange(Type, l_rec_VendorTypeMapping.Type::Vendor);
        if Type = 'CUST' then l_rec_VendorTypeMapping.SetRange(Type, l_rec_VendorTypeMapping.Type::Customer);
        l_rec_VendorTypeMapping.SetRange("Vendor/Customer No.", p_cod_No);
        l_rec_VendorTypeMapping.SetRange("Vendor Type Dimension", 'FD9');
        l_rec_VendorTypeMapping.SetFilter("Vendor Type", 'K|P');
        if l_rec_VendorTypeMapping.FindFirst()then exit(true);
        exit(false);
    end;
    local procedure InsertTempCLELines(var p_rec_CLE: Record "Cust. Ledger Entry")
    begin
        p_rec_CLE.CalcFields("Remaining Amount", "Remaining Amt. (LCY)");
        if p_rec_CLE."Remaining Amount" = 0 then exit;
        g_rec_GLEtemp.Init();
        g_rec_GLEtemp."Entry No.":=GetLastEntryNo();
        g_rec_GLEtemp."Report ID":="Company Name Mapping".DBase;
        g_rec_GLEtemp."Concur ID":="Company Name Mapping"."BC Company Name";
        g_rec_GLEtemp.Comment:='B075';
        g_rec_GLEtemp."Document No.":=p_rec_CLE."Document No.";
        g_rec_GLEtemp."Posting Date":=p_rec_CLE."Posting Date";
        g_rec_GLEtemp."Document Date":=p_rec_CLE."Document Date";
        g_rec_GLEtemp."VAT Reporting Date":=p_rec_CLE."Due Date";
        g_rec_GLEtemp."Source No.":=p_rec_CLE."Customer No.";
        g_rec_GLEtemp."Prior-Year Entry":=CheckIsBD(p_rec_CLE."Customer No.", 'CUST');
        g_rec_GLEtemp."Remittance Full Name":=p_rec_CLE."Customer Name";
        g_rec_GLEtemp."Document Type":=p_rec_CLE."Document Type";
        g_rec_GLEtemp."Shortcut Dimension 8 Code_PB":=p_rec_CLE."Shortcut Dimension 8 Code_PB";
        g_rec_GLEtemp."Shortcut Dimension 9 Code_PB":=p_rec_CLE."Shortcut Dimension 9 Code_PB";
        GetVLEAmts(p_rec_CLE);
        AddParentCompany(p_rec_CLE."Customer No.", 'CUST');
        g_rec_GLEtemp.Insert();
    end;
    local procedure GetVLEAmts(var p_rec_CLE: Record "Cust. Ledger Entry")
    var
        GLSetup: Record "General Ledger Setup";
    begin
        g_rec_GLEtemp."Source Currency Code":=p_rec_CLE."Currency Code";
        g_rec_GLEtemp."Source Currency Amount":=p_rec_CLE."Remaining Amount";
        GLSetup.get();
        if GLSetup."LCY Code" = 'USD' then g_rec_GLEtemp."Source Currency VAT Amount":=p_rec_CLE."Remaining Amt. (LCY)"
        else
            g_rec_GLEtemp."Source Currency VAT Amount":=FCYToLCY(EndingDate, p_rec_CLE."Currency Code", p_rec_CLE."Remaining Amount");
    end;
    local procedure InsertTempGLE()
    var
        l_rec_GLAccount: Record "G/L Account";
        l_rec_GLE: Record "G/L Entry";
    begin
        l_rec_GLAccount.Reset();
        l_rec_GLAccount.ChangeCompany(MasterCompanyName());
        l_rec_GLAccount.SetFilter("Account Group", 'A021|A050|A051|A060|A075|A076|A090|A099|A999|A095');
        if l_rec_GLAccount.FindFirst()then repeat l_rec_GLE.Reset();
                l_rec_GLE.ChangeCompany("Company Name Mapping"."BC Company Name");
                case AgingBy of AgingBy::"Due Date", AgingBy::"Posting Date": l_rec_GLE.SetRange("Posting Date", DMY2Date(1, 1, 1970), EndingDate);
                AgingBy::"Document Date": l_rec_GLE.SetRange("Document Date", DMY2Date(1, 1, 1970), EndingDate);
                end;
                l_rec_GLE.SetFilter("Source No.", '=%1', '');
                l_rec_GLE.SetRange("G/L Account No.", l_rec_GLAccount."No.");
                if l_rec_GLE.FindFirst()then repeat InsertTempGLELines(l_rec_GLE, l_rec_GLAccount."Account Group");
                    until l_rec_GLE.Next() = 0;
            until l_rec_GLAccount.Next() = 0;
    end;
    local procedure InsertTempGLELines(var p_rec_GLE: Record "G/L Entry"; p_cod_AccountGroup: Code[20])
    begin
        g_rec_GLEtemp.Init();
        g_rec_GLEtemp."Entry No.":=GetLastEntryNo();
        g_rec_GLEtemp.Comment:=p_cod_AccountGroup;
        g_rec_GLEtemp."Report ID":="Company Name Mapping".DBase;
        g_rec_GLEtemp."Concur ID":="Company Name Mapping"."BC Company Name";
        g_rec_GLEtemp."Document No.":=p_rec_GLE."Document No.";
        g_rec_GLEtemp."Posting Date":=p_rec_GLE."Posting Date";
        g_rec_GLEtemp."Document Date":=p_rec_GLE."Document Date";
        g_rec_GLEtemp."VAT Reporting Date":=p_rec_GLE."Posting Date";
        g_rec_GLEtemp."Additional-Currency Amount":=p_rec_GLE."Additional-Currency Amount";
        g_rec_GLEtemp.Insert();
    end;
    local procedure AddParentCompany(AccNo: Code[20]; Type: Code[4])
    var
        l_rec_Customer: Record Customer;
        l_rec_Vendor: Record Vendor;
    begin
        case Type of 'CUST': begin
            if l_rec_Customer.get(AccNo)then begin
                g_rec_GLEtemp."Business Unit Code":=l_rec_Customer."Parent Company";
                g_rec_GLEtemp."Receipt image ID":=GetParentCompanyNameCust(l_rec_Customer);
                if not(g_cod_ParentCompanyList.Contains(l_rec_Customer."Parent Company")) and (l_rec_Customer."Parent Company" <> '')then g_cod_ParentCompanyList.Add(l_rec_Customer."Parent Company");
            end;
        end;
        'VEND': begin
            if l_rec_Vendor.get(AccNo)then begin
                g_rec_GLEtemp."Business Unit Code":=l_rec_Vendor."Parent Company";
                g_rec_GLEtemp."Receipt image ID":=GetParentCompanyNameVend(l_rec_Vendor);
                if not(g_cod_ParentCompanyList.Contains(l_rec_Vendor."Parent Company")) and (l_rec_Vendor."Parent Company" <> '')then g_cod_ParentCompanyList.Add(l_rec_Vendor."Parent Company");
            end;
        end;
        end;
    end;
    local procedure GetParentCompanyNameVend(var p_rec_Vend: Record Vendor): Text var
        l_rec_Vendors: Record Vendor;
        l_rec_Customers: Record Customer;
    begin
        if p_rec_Vend."Parent Company Type" = p_rec_Vend."Parent Company Type"::Vendor then begin
            l_rec_Vendors.get(p_rec_Vend."Parent Company");
            exit(l_rec_Vendors.Name);
        end;
        if p_rec_Vend."Parent Company Type" = p_rec_Vend."Parent Company Type"::Customer then begin
            l_rec_Customers.get(p_rec_Vend."Parent Company");
            exit(l_rec_Customers.Name);
        end;
    end;
    local procedure GetParentCompanyNameCust(var p_rec_Cust: Record Customer): Text var
        l_rec_Vendors: Record Vendor;
        l_rec_Customers: Record Customer;
    begin
        if p_rec_Cust."Parent Company Type" = p_rec_Cust."Parent Company Type"::Vendor then begin
            l_rec_Vendors.get(p_rec_Cust."Parent Company");
            exit(l_rec_Vendors.Name);
        end;
        if p_rec_Cust."Parent Company Type" = p_rec_Cust."Parent Company Type"::Customer then begin
            l_rec_Customers.get(p_rec_Cust."Parent Company");
            exit(l_rec_Customers.Name);
        end;
    end;
    local procedure MasterCompanyName(): Text[50]var
        l_rec_CompanyMapping: Record "Company Name Mapping";
    begin
        l_rec_CompanyMapping.Reset();
        l_rec_CompanyMapping.SetRange("Master Data Company", true);
        if l_rec_CompanyMapping.FindFirst()then exit(l_rec_CompanyMapping."BC Company Name");
    end;
    local procedure FCYToLCY(StartingDate: Date; FCYCode: Code[10]; Amt: Decimal): Decimal var
        CurrenExchRate: Record "Currency Exchange Rate";
    begin
        CurrenExchRate.Reset();
        CurrenExchRate.SetFilter("Starting Date", '..%1', StartingDate);
        CurrenExchRate.SetRange("Currency Code", FCYCode);
        if CurrenExchRate.FindLast()then exit(Amt * CurrenExchRate."Relational Adjmt Exch Rate Amt" / CurrenExchRate."Adjustment Exch. Rate Amount");
    end;
    local procedure GetLastEntryNo(): Integer var
        EntryNo: Integer;
    begin
        g_rec_GLEtemp.Reset();
        if g_rec_GLEtemp.FindLast()then EntryNo:=g_rec_GLEtemp."Entry No." + 1
        else
            EntryNo:=1;
        exit(EntryNo);
    end;
    trigger OnPreReport()
    begin
        CalcDates();
        CreateHeadings();
    end;
    var PeriodLength: DateFormula;
    EndingDate: Date;
    AgingBy: Option "Due Date", "Posting Date", "Document Date";
    HeadingType: Option "Date Interval", "Number of Days";
    // NewPagePerVendor: Boolean;
    PrintDetails: Boolean;
    g_rec_GLEtemp: Record "G/L Entry" temporary;
    g_cod_ParentCompanyList: List of[Code[20]];
    PeriodStartDate: array[5]of Date;
    PeriodEndDate: array[5]of Date;
    HeaderText: array[5]of Text[30];
    Text000: Label 'Not Due';
    #pragma warning restore AA0074
    AfterTok: Label 'After';
    BeforeTok: Label 'Before';
    Text002: Label 'days';
    Text027: Label '-%1', Comment = 'Negating the period length: %1 is the period length';
    #pragma warning restore AA0074
    EnterDateFormulaErr: Label 'Enter a date formula in the Period Length field.';
    Text010: Label 'The Date Formula %1 cannot be used. Try to restate it, for example, by using 1M+CM instead of CM+1M.';
    g_int_BucketIndex: Integer;
    SkipZero: Boolean;
    g_cod_VendNo: Code[20];
    g_cod_CustNo: code[20];
}
