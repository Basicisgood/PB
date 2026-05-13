codeunit 50177 "Concur Finance Exp. Post"
{ //PS006
    var VMT: record VMT;
    DateTimeValue: DateTime;
    BankAccMapping: Record "Concur Bank Acc Setup";
    DNVSetup: Record "DNV Integration Setup";
    PBPurchInvLine: record "PB Purchase Invoice Line Inb";
    CompanyMapping: record "Company Name Mapping";
    GenJnlLine: record "Gen. Journal Line";
    vendor: Record Vendor;
    LineNo: Integer;
    InvoiceAmount: Decimal;
    VMTShipCode: record VMT;
    NoSeries: Codeunit "No. Series";
    GenTemp: Record "Gen. Journal Template";
    GlSetup: Record "General Ledger Setup";
    GlDescription: Text;
    GlAccountNo: Code[20];
    DryDockGL: Record "DNV Dry Dock GL Mapping";
    GenJnLLine2: record "Gen. Journal Line";
    CurrentaccountNo: code[20];
    ConcurSetup: Record "Concur API Setup";
    procedure PostFinCompany(var InboundFinExpen: Record "Concur inbound financial Expen"; DocNo: Code[20]; LineNo1: Integer; PrintEmp: Boolean): Boolean var
        myInt: Integer;
        Intvalue: Integer;
        totalvalue: Integer;
        entrycustom2code: Text;
        empvalue: Text;
        entrydate: Date;
    begin
        GlSetup.Get();
        ConcurSetup.Get();
        ConcurSetup.TestField("Default Concur Dimension");
        if InboundFinExpen."Ship Sign Company No" <> '' then begin
            CompanyMapping.get(InboundFinExpen."Ship Sign Company No");
            CompanyMapping.TestField("Current Account No.");
        end;
        if(InboundFinExpen."Posted Document No Fin Company" = '') and (InboundFinExpen."Finance Company No" = CompanyName)then begin
            if PrintEmp = true then begin
                if((InboundFinExpen.Shipsign = 'NA') or (InboundFinExpen.Shipsign = 'Not Applicable') or (InboundFinExpen.Shipsign = '')) and ((InboundFinExpen."Entry Custom 2(DOC Code)" = 'NA') or (InboundFinExpen."Entry Custom 2(DOC Code)" = 'Not Applicable') or (InboundFinExpen."Entry Custom 2(DOC Code)" = '')) and (UpperCase(InboundFinExpen."Payment Type") <> 'CASH') and (InboundFinExpen."Journal Key" = '16900000') and (uppercase(InboundFinExpen."Journal Type") <> 'CASH_LEDGER')then begin
                    GenJnlLine.Init();
                    GenJnlLine."Journal Template Name":=ConcurSetup."Concur Template Name";
                    GenJnlLine."Journal Batch Name":=ConcurSetup."Concur Batch Name";
                    GenJnlLine."Line No.":=LineNo1;
                    DateTimeValue:=0DT;
                    evaluate(DateTimeValue, InboundFinExpen."Report Payment Processing Date");
                    GenJnlLine."Posting Date":=DT2Date(DateTimeValue);
                    DateTimeValue:=0DT;
                    evaluate(DateTimeValue, InboundFinExpen."Report Payment Processing Date");
                    GenJnlLine."VAT Reporting Date":=DT2Date(DateTimeValue);
                    GenJnlLine."Document No.":=DocNo;
                    GenJnlLine."External Document No.":=InboundFinExpen."Report Key";
                    GenJnlLine."Concur ID":=InboundFinExpen."Concur ID"; //VT
                    GenJnlLine."Entry Id":=InboundFinExpen."Entry Id"; //VT
                    GenJnlLine."Receipt image ID":=InboundFinExpen."Receipt Received"; //VT
                    //GenJnlLine."Shortcut Dimension 5 Code" := InboundFinExpen."New FD5";//VT
                    GenJnlLine."Account Type":=GenJnlLine."Account Type"::Employee;
                    GenJnlLine.Validate("Account No.", InboundFinExpen."EMP ID");
                    GenJnlLine.Description:=InboundFinExpen."Entry Description";
                    // Evaluate(GenJnlLine.Amount, InboundFinExpen."Entry Approved Amount");
                    Evaluate(GenJnlLine.Amount, InboundFinExpen."Report Total Approved Amount");
                    GenJnlLine.Validate(Amount);
                    if InboundFinExpen."Journal Tax Amount" <> '' then begin
                        Evaluate(GenJnlLine."VAT Amount", InboundFinExpen."Journal Tax Amount");
                        GenJnlLine.Validate("VAT Amount");
                    end;
                    GenJnlLine.Validate("Currency Code", InboundFinExpen."Spend Currency Alpha ISO");
                    // GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Employee;
                    // GenJnlLine.Validate("Bal. Account No.", InboundFinExpen."EMP ID" + 'CC');
                    VMT.Reset();
                    VMT.SetRange(DBASE, InboundFinExpen."Report Org Unit 3");
                    if VMT.FindFirst()then GenJnlLine.Validate("Shortcut Dimension 1 Code", VMT.SEGMENT);
                    GenJnlLine.Validate("Shortcut Dimension 5 Code", InboundFinExpen."New FD5");
                    GenJnlLine.Validate("Shortcut Dimension 6 Code", InboundFinExpen."EMP ID");
                    GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyName);
                    GenJnlLine.Validate("Shortcut Dimension 9 Code", 'CARD');
                    GenJnlLine.Validate("Shortcut Dimension 2 Code", ConcurSetup."Default Concur Dimension");
                    GenJnlLine."PB Concur invoice":=true;
                    GenJnlLine.Insert();
                    InboundFinExpen."Posted Document No Fin Company":=GenJnlLine."Document No.";
                    InboundFinExpen.Modify();
                    exit(true);
                end;
            end;
            if((InboundFinExpen.Shipsign = 'NA') or (InboundFinExpen.Shipsign = 'Not Applicable') or (InboundFinExpen.Shipsign = '')) and ((InboundFinExpen."Entry Custom 2(DOC Code)" = 'NA') or (InboundFinExpen."Entry Custom 2(DOC Code)" = 'Not Applicable') or (InboundFinExpen."Entry Custom 2(DOC Code)" = '')) and (UpperCase(InboundFinExpen."Payment Type") <> 'CASH') and (InboundFinExpen."Journal Key" <> '16900000') and (uppercase(InboundFinExpen."Journal Type") <> 'CASH_LEDGER')then begin
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name":=ConcurSetup."Concur Template Name";
                GenJnlLine."Journal Batch Name":=ConcurSetup."Concur Batch Name";
                GenJnlLine."Line No.":=LineNo1;
                DateTimeValue:=0DT;
                evaluate(DateTimeValue, InboundFinExpen."Report Payment Processing Date");
                GenJnlLine."Posting Date":=DT2Date(DateTimeValue);
                DateTimeValue:=0DT;
                evaluate(DateTimeValue, InboundFinExpen."Report Payment Processing Date");
                GenJnlLine."VAT Reporting Date":=DT2Date(DateTimeValue);
                GenJnlLine."Document No.":=DocNo;
                GenJnlLine."External Document No.":=InboundFinExpen."Report Key";
                GenJnlLine."Concur ID":=InboundFinExpen."Concur ID"; //VT
                GenJnlLine."Entry Id":=InboundFinExpen."Entry Id"; //VT
                GenJnlLine."Receipt image ID":=InboundFinExpen."Receipt Received"; //VT
                GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine.Validate("Account No.", InboundFinExpen."Journal Key");
                GenJnlLine.Description:=InboundFinExpen."Entry Description";
                Evaluate(GenJnlLine.Amount, InboundFinExpen."Entry Approved Amount");
                GenJnlLine.Validate(Amount);
                if InboundFinExpen."Journal Tax Amount" <> '' then begin
                    Evaluate(GenJnlLine."VAT Amount", InboundFinExpen."Journal Tax Amount");
                    GenJnlLine.Validate("VAT Amount");
                end;
                GenJnlLine.Validate("Currency Code", InboundFinExpen."Spend Currency Alpha ISO");
                // GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Employee;
                // GenJnlLine.Validate("Bal. Account No.", InboundFinExpen."EMP ID" + 'CC');
                VMT.Reset();
                VMT.SetRange(DBASE, CompanyName);
                if VMT.FindFirst()then GenJnlLine.Validate("Shortcut Dimension 1 Code", VMT.SEGMENT);
                GenJnlLine.Validate("Shortcut Dimension 5 Code", InboundFinExpen."New FD5");
                GenJnlLine.Validate("Shortcut Dimension 6 Code", InboundFinExpen."EMP ID");
                GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyName);
                GenJnlLine.Validate("Shortcut Dimension 9 Code", 'CARD');
                GenJnlLine.Validate("Shortcut Dimension 2 Code", ConcurSetup."Default Concur Dimension");
                GenJnlLine."PB Concur invoice":=true;
                GenJnlLine.Insert();
                InboundFinExpen."Posted Document No Fin Company":=GenJnlLine."Document No.";
                InboundFinExpen.Modify();
                exit(true);
            end;
            if((InboundFinExpen.Shipsign = 'NA') or (InboundFinExpen.Shipsign = 'Not Applicable') or (InboundFinExpen.Shipsign = '')) and ((InboundFinExpen."Entry Custom 2(DOC Code)" = 'NA') or (InboundFinExpen."Entry Custom 2(DOC Code)" = 'Not Applicable') or (InboundFinExpen."Entry Custom 2(DOC Code)" = '')) and (UpperCase(InboundFinExpen."Payment Type") = 'CASH') and (InboundFinExpen."Journal Key" <> '16900000') and (uppercase(InboundFinExpen."Journal Type") <> 'CASH_LEDGER')then begin
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name":=ConcurSetup."Concur Template Name";
                GenJnlLine."Journal Batch Name":=ConcurSetup."Concur Batch Name";
                GenJnlLine."Line No.":=LineNo1;
                DateTimeValue:=0DT;
                evaluate(DateTimeValue, InboundFinExpen."Report Payment Processing Date");
                GenJnlLine."Posting Date":=DT2Date(DateTimeValue);
                DateTimeValue:=0DT;
                evaluate(DateTimeValue, InboundFinExpen."Report Payment Processing Date");
                GenJnlLine."VAT Reporting Date":=DT2Date(DateTimeValue);
                GenJnlLine."Document No.":=DocNo;
                GenJnlLine."External Document No.":=InboundFinExpen."Report Key";
                GenJnlLine."Concur ID":=InboundFinExpen."Concur ID"; //VT
                GenJnlLine."Entry Id":=InboundFinExpen."Entry Id"; //VT
                GenJnlLine."Receipt image ID":=InboundFinExpen."Receipt Received"; //VT
                GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine.Validate("Account No.", InboundFinExpen."Journal Key");
                GenJnlLine.Description:=InboundFinExpen."Entry Description";
                Evaluate(GenJnlLine.Amount, InboundFinExpen."Entry Approved Amount");
                GenJnlLine.Validate(Amount);
                if InboundFinExpen."Journal Tax Amount" <> '' then begin
                    Evaluate(GenJnlLine."VAT Amount", InboundFinExpen."Journal Tax Amount");
                    GenJnlLine.Validate("VAT Amount");
                end;
                GenJnlLine.Validate("Currency Code", InboundFinExpen."Spend Currency Alpha ISO");
                // GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Employee;
                // GenJnlLine.Validate("Bal. Account No.", InboundFinExpen."EMP ID");
                VMT.Reset();
                VMT.SetRange(DBASE, CompanyName);
                if VMT.FindFirst()then GenJnlLine.Validate("Shortcut Dimension 1 Code", VMT.SEGMENT);
                GenJnlLine.Validate("Shortcut Dimension 5 Code", InboundFinExpen."New FD5");
                GenJnlLine.Validate("Shortcut Dimension 6 Code", InboundFinExpen."EMP ID");
                GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyName);
                GenJnlLine.Validate("Shortcut Dimension 9 Code", 'CARD');
                GenJnlLine.Validate("Shortcut Dimension 2 Code", ConcurSetup."Default Concur Dimension");
                GenJnlLine."PB Concur invoice":=true;
                GenJnlLine.Insert();
                InboundFinExpen."Posted Document No Fin Company":=GenJnlLine."Document No.";
                InboundFinExpen.Modify();
                exit(true);
            end;
            if PrintEmp = true then begin
                if(((InboundFinExpen.Shipsign <> 'NA') and (InboundFinExpen.Shipsign <> 'Not Applicable') and (InboundFinExpen.Shipsign <> '')) or ((InboundFinExpen."Entry Custom 2(DOC Code)" <> 'NA') and (InboundFinExpen."Entry Custom 2(DOC Code)" <> 'Not Applicable') and (InboundFinExpen."Entry Custom 2(DOC Code)" <> ''))) and (UpperCase(InboundFinExpen."Payment Type") <> 'CASH') and (InboundFinExpen."Journal Key" = '16900000') and (uppercase(InboundFinExpen."Journal Type") <> 'CASH_LEDGER')then begin
                    GenJnlLine.Init();
                    GenJnlLine."Journal Template Name":=ConcurSetup."Concur Template Name";
                    GenJnlLine."Journal Batch Name":=ConcurSetup."Concur Batch Name";
                    GenJnlLine."Line No.":=LineNo1;
                    DateTimeValue:=0DT;
                    evaluate(DateTimeValue, InboundFinExpen."Report Payment Processing Date");
                    GenJnlLine."Posting Date":=DT2Date(DateTimeValue);
                    DateTimeValue:=0DT;
                    evaluate(DateTimeValue, InboundFinExpen."Report Payment Processing Date");
                    GenJnlLine."VAT Reporting Date":=DT2Date(DateTimeValue);
                    GenJnlLine."Document No.":=DocNo;
                    GenJnlLine."External Document No.":=InboundFinExpen."Report Key";
                    GenJnlLine."Concur ID":=InboundFinExpen."Concur ID"; //VT
                    GenJnlLine."Entry Id":=InboundFinExpen."Entry Id"; //VT
                    GenJnlLine."Receipt image ID":=InboundFinExpen."Receipt Received"; //VT
                    GenJnlLine."Account Type":=GenJnlLine."Account Type"::Employee;
                    GenJnlLine.Validate("Account No.", InboundFinExpen."EMP ID");
                    DateTimeValue:=0DT;
                    entrydate:=0D;
                    evaluate(DateTimeValue, InboundFinExpen."Entry Date");
                    entrydate:=DT2Date(DateTimeValue);
                    GenJnlLine.Description:=InboundFinExpen."Report Org Unit 3" + ' ' + copystr(InboundFinExpen."Entry Custom 2(DOC Code)", StrLen(InboundFinExpen."Entry Custom 2(DOC Code)") - 2, 3) + ' ' + CopyStr(InboundFinExpen."Employee name", 1, 10) + ' ' + Format(entrydate);
                    // Evaluate(GenJnlLine.Amount, InboundFinExpen."Entry Approved Amount");
                    Evaluate(GenJnlLine.Amount, InboundFinExpen."Report Total Approved Amount");
                    GenJnlLine.Validate(Amount);
                    if InboundFinExpen."Journal Tax Amount" <> '' then begin
                        Evaluate(GenJnlLine."VAT Amount", InboundFinExpen."Journal Tax Amount");
                        GenJnlLine.Validate("VAT Amount");
                    end;
                    GenJnlLine.Validate("Currency Code", InboundFinExpen."Spend Currency Alpha ISO");
                    // GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Employee;
                    // GenJnlLine.Validate("Bal. Account No.", InboundFinExpen."EMP ID" + 'CC');
                    VMT.Reset();
                    VMT.SetRange(DBASE, CompanyName);
                    if VMT.FindFirst()then GenJnlLine.Validate("Shortcut Dimension 1 Code", VMT.SEGMENT);
                    VMT.Reset();
                    VMT.Setfilter(DBASE, CompanyName);
                    if VMT.FindFirst()then GenJnlLine.Validate("Shortcut Dimension 10 Code", VMT.VESSELCODE);
                    GenJnlLine.Validate("Shortcut Dimension 5 Code", InboundFinExpen."New FD5");
                    GenJnlLine.Validate("Shortcut Dimension 6 Code", InboundFinExpen."EMP ID");
                    GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyName);
                    GenJnlLine.Validate("Shortcut Dimension 9 Code", 'CARD');
                    GenJnlLine.Validate("Shortcut Dimension 2 Code", ConcurSetup."Default Concur Dimension");
                    GenJnlLine."PB Concur invoice":=true;
                    GenJnlLine.Insert();
                    InboundFinExpen."Posted Document No Fin Company":=GenJnlLine."Document No.";
                    InboundFinExpen.Modify();
                    exit(true);
                end;
            end;
            if(((InboundFinExpen.Shipsign <> 'NA') and (InboundFinExpen.Shipsign <> 'Not Applicable') and (InboundFinExpen.Shipsign <> '')) or ((InboundFinExpen."Entry Custom 2(DOC Code)" <> 'NA') and (InboundFinExpen."Entry Custom 2(DOC Code)" <> 'Not Applicable') and (InboundFinExpen."Entry Custom 2(DOC Code)" <> ''))) and (UpperCase(InboundFinExpen."Payment Type") <> 'CASH') and (InboundFinExpen."Journal Key" <> '16900000') and (uppercase(InboundFinExpen."Journal Type") <> 'CASH_LEDGER')then begin
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name":=ConcurSetup."Concur Template Name";
                GenJnlLine."Journal Batch Name":=ConcurSetup."Concur Batch Name";
                GenJnlLine."Line No.":=LineNo1;
                DateTimeValue:=0DT;
                evaluate(DateTimeValue, InboundFinExpen."Report Payment Processing Date");
                GenJnlLine."Posting Date":=DT2Date(DateTimeValue);
                DateTimeValue:=0DT;
                evaluate(DateTimeValue, InboundFinExpen."Report Payment Processing Date");
                GenJnlLine."VAT Reporting Date":=DT2Date(DateTimeValue);
                GenJnlLine."Document No.":=DocNo;
                GenJnlLine."External Document No.":=InboundFinExpen."Report Key";
                GenJnlLine."Concur ID":=InboundFinExpen."Concur ID"; //VT
                GenJnlLine."Entry Id":=InboundFinExpen."Entry Id"; //VT
                GenJnlLine."Receipt image ID":=InboundFinExpen."Receipt Received"; //VT
                GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine.Validate("Account No.", CompanyMapping."Current Account No.");
                DateTimeValue:=0DT;
                entrydate:=0D;
                evaluate(DateTimeValue, InboundFinExpen."Entry Date");
                entrydate:=DT2Date(DateTimeValue);
                GenJnlLine.Description:=InboundFinExpen."Report Org Unit 3" + ' ' + copystr(InboundFinExpen."Entry Custom 2(DOC Code)", StrLen(InboundFinExpen."Entry Custom 2(DOC Code)") - 2, 3) + ' ' + CopyStr(InboundFinExpen."Employee name", 1, 10) + ' ' + Format(entrydate);
                Evaluate(GenJnlLine.Amount, InboundFinExpen."Entry Approved Amount");
                GenJnlLine.Validate(Amount);
                if InboundFinExpen."Journal Tax Amount" <> '' then begin
                    Evaluate(GenJnlLine."VAT Amount", InboundFinExpen."Journal Tax Amount");
                    GenJnlLine.Validate("VAT Amount");
                end;
                GenJnlLine.Validate("Currency Code", InboundFinExpen."Spend Currency Alpha ISO");
                // GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Employee;
                // GenJnlLine.Validate("Bal. Account No.", InboundFinExpen."EMP ID" + 'CC');
                VMT.Reset();
                VMT.SetRange(DBASE, CompanyName);
                if VMT.FindFirst()then GenJnlLine.Validate("Shortcut Dimension 1 Code", VMT.SEGMENT);
                VMT.Reset();
                // VMT.Setfilter(DBASE, CompanyName);
                VMT.Setfilter(DBASE, CompanyName);
                if VMT.FindFirst()then GenJnlLine.Validate("Shortcut Dimension 10 Code", VMT.VESSELCODE);
                GenJnlLine.Validate("Shortcut Dimension 5 Code", InboundFinExpen."New FD5");
                GenJnlLine.Validate("Shortcut Dimension 6 Code", InboundFinExpen."EMP ID");
                GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyName);
                GenJnlLine.Validate("Shortcut Dimension 9 Code", 'CARD');
                GenJnlLine.Validate("Shortcut Dimension 2 Code", ConcurSetup."Default Concur Dimension");
                GenJnlLine."PB Concur invoice":=true;
                DateTimeValue:=0DT;
                entrydate:=0D;
                evaluate(DateTimeValue, InboundFinExpen."Entry Date");
                entrydate:=DT2Date(DateTimeValue);
                totalvalue:=StrLen(InboundFinExpen."Entry Custom 2(DOC Code)");
                Intvalue:=totalvalue - 3;
                entrycustom2code:=CopyStr(InboundFinExpen."Entry Custom 2(DOC Code)", Intvalue + 1);
                empvalue:=CopyStr(InboundFinExpen."Employee name", 1, 10);
                GenJnlLine.Description:=Format(VMT.SHIPSIGN) + ' ' + entrycustom2code + empvalue + Format(entrydate);
                InboundFinExpen."Posted Document No Fin Company":=GenJnlLine."Document No.";
                InboundFinExpen.Modify();
                exit(true);
            end;
            if(((InboundFinExpen.Shipsign <> 'NA') and (InboundFinExpen.Shipsign <> 'Not Applicable') and (InboundFinExpen.Shipsign <> '')) or ((InboundFinExpen."Entry Custom 2(DOC Code)" <> 'NA') and (InboundFinExpen."Entry Custom 2(DOC Code)" <> 'Not Applicable') and (InboundFinExpen."Entry Custom 2(DOC Code)" <> ''))) and (UpperCase(InboundFinExpen."Payment Type") = 'CASH') and (InboundFinExpen."Journal Key" <> '16900000') and (uppercase(InboundFinExpen."Journal Type") <> 'CASH_LEDGER')then begin
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name":=ConcurSetup."Concur Template Name";
                GenJnlLine."Journal Batch Name":=ConcurSetup."Concur Batch Name";
                GenJnlLine."Line No.":=LineNo1;
                DateTimeValue:=0DT;
                evaluate(DateTimeValue, InboundFinExpen."Report Payment Processing Date");
                GenJnlLine."Posting Date":=DT2Date(DateTimeValue);
                DateTimeValue:=0DT;
                evaluate(DateTimeValue, InboundFinExpen."Report Payment Processing Date");
                GenJnlLine."VAT Reporting Date":=DT2Date(DateTimeValue);
                GenJnlLine."Document No.":=DocNo;
                GenJnlLine."External Document No.":=InboundFinExpen."Report Key";
                GenJnlLine."Concur ID":=InboundFinExpen."Concur ID"; //VT
                GenJnlLine."Entry Id":=InboundFinExpen."Entry Id"; //VT
                GenJnlLine."Receipt image ID":=InboundFinExpen."Receipt Received"; //VT
                GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine.Validate("Account No.", CompanyMapping."Current Account No.");
                DateTimeValue:=0DT;
                entrydate:=0D;
                evaluate(DateTimeValue, InboundFinExpen."Entry Date");
                entrydate:=DT2Date(DateTimeValue);
                GenJnlLine.Description:=InboundFinExpen."Shortcut Dim 8 Code FD8_Comp" + ' ' + copystr(InboundFinExpen."Entry Custom 2(DOC Code)", StrLen(InboundFinExpen."Entry Custom 2(DOC Code)") - 2, 3) + ' ' + CopyStr(InboundFinExpen."Employee name", 1, 10) + ' ' + Format(entrydate);
                Evaluate(GenJnlLine.Amount, InboundFinExpen."Entry Approved Amount");
                GenJnlLine.Validate(Amount);
                if InboundFinExpen."Journal Tax Amount" <> '' then begin
                    Evaluate(GenJnlLine."VAT Amount", InboundFinExpen."Journal Tax Amount");
                    GenJnlLine.Validate("VAT Amount");
                end;
                GenJnlLine.Validate("Currency Code", InboundFinExpen."Spend Currency Alpha ISO");
                // GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Employee;
                // GenJnlLine.Validate("Bal. Account No.", InboundFinExpen."EMP ID");
                VMT.Reset();
                VMT.SetRange(DBASE, CompanyName);
                if VMT.FindFirst()then GenJnlLine.Validate("Shortcut Dimension 1 Code", VMT.SEGMENT);
                VMT.Reset();
                VMT.Setfilter(DBASE, CompanyName);
                if VMT.FindFirst()then GenJnlLine.Validate("Shortcut Dimension 10 Code", VMT.VESSELCODE);
                GenJnlLine.Validate("Shortcut Dimension 5 Code", InboundFinExpen."New FD5");
                GenJnlLine.Validate("Shortcut Dimension 6 Code", InboundFinExpen."EMP ID");
                GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyName);
                //GenJnlLine.Validate("Shortcut Dimension 9 Code", 'CARD');
                GenJnlLine.Validate("Shortcut Dimension 2 Code", ConcurSetup."Default Concur Dimension");
                GenJnlLine."PB Concur invoice":=true;
                DateTimeValue:=0DT;
                entrydate:=0D;
                evaluate(DateTimeValue, InboundFinExpen."Entry Date");
                entrydate:=DT2Date(DateTimeValue);
                totalvalue:=StrLen(InboundFinExpen."Entry Custom 2(DOC Code)");
                Intvalue:=totalvalue - 3;
                entrycustom2code:=CopyStr(InboundFinExpen."Entry Custom 2(DOC Code)", Intvalue + 1);
                empvalue:=CopyStr(InboundFinExpen."Employee name", 1, 10);
                GenJnlLine.Description:=Format(VMT.SHIPSIGN) + ' ' + entrycustom2code + empvalue + Format(entrydate);
                // GenJnlLine.Validate(short);
                GenJnlLine.Insert();
                InboundFinExpen."Posted Document No Fin Company":=GenJnlLine."Document No.";
                InboundFinExpen.Modify();
                exit(true);
            end;
            IF(uppercase(InboundFinExpen."Journal Type") = 'CASH_LEDGER') and (UpperCase(InboundFinExpen."Payment Type") = 'COMPANY PAID') and (InboundFinExpen."Journal Key" <> '16900000') and ((uppercase(InboundFinExpen."Expense Type Name") <> 'BANK CLOSING BALANCE') AND (uppercase(InboundFinExpen."Expense Type Name") <> 'BANK OPENING BALANCE') AND (uppercase(InboundFinExpen."Expense Type Name") <> 'FUNDING FROM HK')) AND (InboundFinExpen."Journal Key" <> '372000')then begin
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name":=ConcurSetup."Concur Template Name";
                GenJnlLine."Journal Batch Name":=ConcurSetup."Concur Batch Name";
                GenJnlLine."Line No.":=LineNo1;
                DateTimeValue:=0DT;
                evaluate(DateTimeValue, InboundFinExpen."Report Payment Processing Date");
                GenJnlLine."Posting Date":=DT2Date(DateTimeValue);
                DateTimeValue:=0DT;
                evaluate(DateTimeValue, InboundFinExpen."Report Payment Processing Date");
                GenJnlLine."VAT Reporting Date":=DT2Date(DateTimeValue);
                GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No.":=DocNo;
                GenJnlLine."External Document No.":=InboundFinExpen."Report Key" + '_' + InboundFinExpen."Legacy Entry Id";
                GenJnlLine."Concur ID":=InboundFinExpen."Concur ID"; //VT
                GenJnlLine."Entry Id":=InboundFinExpen."Entry Id"; //VT
                GenJnlLine."Receipt image ID":=InboundFinExpen."Receipt Received"; //VT
                GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine.Validate("Account No.", InboundFinExpen."Journal Key");
                GenJnlLine.Description:=InboundFinExpen."Cash Led entry description" + ' ' + InboundFinExpen."Entry Description";
                Evaluate(GenJnlLine.Amount, InboundFinExpen."Entry Approved Amount");
                GenJnlLine.Validate(Amount);
                if InboundFinExpen."Journal Tax Amount" <> '' then begin
                    Evaluate(GenJnlLine."VAT Amount", InboundFinExpen."Journal Tax Amount");
                    GenJnlLine.Validate("VAT Amount");
                end;
                GenJnlLine.Validate("Currency Code", InboundFinExpen."Spend Currency Alpha ISO");
                // GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
                // BankAccMapping.reset;
                // BankAccMapping.SetRange("BC Company", InboundFinExpen."Report Org Unit 3");
                // BankAccMapping.SetRange("Report Name", CopyStr(InboundFinExpen."Report Name", StrLen(InboundFinExpen."Report Name") - 2, 3));
                // if BankAccMapping.FindFirst() then
                //     GenJnlLine.Validate("Bal. Account No.", BankAccMapping."Bank Account")
                // else begin
                //     BankAccMapping.reset;
                //     BankAccMapping.SetRange("BC Company", InboundFinExpen."Report Org Unit 3");
                //     BankAccMapping.SetRange("Report Name", '');
                //     if BankAccMapping.FindFirst() then
                //         GenJnlLine.Validate("Bal. Account No.", BankAccMapping."Bank Account")
                // end;
                VMT.Reset();
                VMT.SetRange(DBASE, InboundFinExpen."Report Org Unit 3");
                if VMT.FindFirst()then begin
                    GenJnlLine.Validate("Shortcut Dimension 1 Code", VMT.SEGMENT);
                    GenJnlLine.Validate("Shortcut Dimension 10 Code", VMT.VESSELCODE);
                end;
                GenJnlLine.Validate("Shortcut Dimension 5 Code", InboundFinExpen."New FD5");
                GenJnlLine.Validate("Shortcut Dimension 6 Code", InboundFinExpen."EMP ID");
                GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyName);
                //GenJnlLine.Validate("Shortcut Dimension 9 Code", 'CARD');
                GenJnlLine.Validate("Shortcut Dimension 2 Code", ConcurSetup."Default Concur Dimension");
                totalvalue:=StrLen(InboundFinExpen."Entry Custom 2(DOC Code)");
                DateTimeValue:=0DT;
                entrydate:=0D;
                evaluate(DateTimeValue, InboundFinExpen."Entry Date");
                entrydate:=DT2Date(DateTimeValue);
                Intvalue:=totalvalue - 3;
                entrycustom2code:=CopyStr(InboundFinExpen."Entry Custom 2(DOC Code)", Intvalue + 1);
                empvalue:=CopyStr(InboundFinExpen."Employee name", 1, 10);
                GenJnlLine.Description:=Format(VMT.SHIPSIGN) + ' ' + entrycustom2code + empvalue + Format(entrydate);
                GenJnlLine.Insert();
                InboundFinExpen."Posted Document No Fin Company":=GenJnlLine."Document No.";
                InboundFinExpen.Modify();
                exit(true);
            END;
            IF(uppercase(InboundFinExpen."Journal Type") = 'CASH_LEDGER') and (UpperCase(InboundFinExpen."Payment Type") = 'COMPANY PAID') and (InboundFinExpen."Journal Key" <> '16900000') and ((uppercase(InboundFinExpen."Expense Type Name") <> 'BANK CLOSING BALANCE') AND (uppercase(InboundFinExpen."Expense Type Name") <> 'BANK OPENING BALANCE') AND (uppercase(InboundFinExpen."Expense Type Name") <> 'FUNDING FROM HK')) AND ((InboundFinExpen."Journal Key" = '372000') or (InboundFinExpen."Journal Key" = InboundFinExpen."EMP ID"))then begin
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name":=ConcurSetup."Concur Template Name";
                GenJnlLine."Journal Batch Name":=ConcurSetup."Concur Batch Name";
                GenJnlLine."Line No.":=LineNo1;
                DateTimeValue:=0DT;
                evaluate(DateTimeValue, InboundFinExpen."Report Payment Processing Date");
                GenJnlLine."Posting Date":=DT2Date(DateTimeValue);
                DateTimeValue:=0DT;
                evaluate(DateTimeValue, InboundFinExpen."Report Payment Processing Date");
                GenJnlLine."VAT Reporting Date":=DT2Date(DateTimeValue);
                GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No.":=DocNo;
                GenJnlLine."Concur ID":=InboundFinExpen."Concur ID"; //VT
                GenJnlLine."Entry Id":=InboundFinExpen."Entry Id"; //VT
                GenJnlLine."Receipt image ID":=InboundFinExpen."Receipt Received"; //VT
                GenJnlLine."External Document No.":=copystr(InboundFinExpen."Entry Description", StrLen(InboundFinExpen."Entry Description") - 4, 5);
                GenJnlLine."Account Type":=GenJnlLine."Account Type"::Employee;
                GenJnlLine.Validate("Account No.", InboundFinExpen."EMP ID");
                GenJnlLine.Description:=InboundFinExpen."Employee name" + ' ' + InboundFinExpen."Entry Description";
                Evaluate(GenJnlLine.Amount, InboundFinExpen."Entry Approved Amount");
                GenJnlLine.Validate(Amount);
                if InboundFinExpen."Journal Tax Amount" <> '' then begin
                    Evaluate(GenJnlLine."VAT Amount", InboundFinExpen."Journal Tax Amount");
                    GenJnlLine.Validate("VAT Amount");
                end;
                GenJnlLine.Validate("Currency Code", InboundFinExpen."Spend Currency Alpha ISO");
                GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"Bank Account";
                // BankAccMapping.reset;
                // BankAccMapping.SetRange("BC Company", InboundFinExpen."Report Org Unit 3");
                // BankAccMapping.SetRange("Report Name", CopyStr(InboundFinExpen."Report Name", StrLen(InboundFinExpen."Report Name") - 2, 3));
                // if BankAccMapping.FindFirst() then
                //     GenJnlLine.Validate("Bal. Account No.", BankAccMapping."Bank Account")
                // else begin
                //     BankAccMapping.reset;
                //     BankAccMapping.SetRange("BC Company", InboundFinExpen."Report Org Unit 3");
                //     BankAccMapping.SetRange("Report Name", '');
                //     if BankAccMapping.FindFirst() then
                //         GenJnlLine.Validate("Bal. Account No.", BankAccMapping."Bank Account")
                // end;
                VMT.Reset();
                VMT.SetRange(DBASE, InboundFinExpen."Report Org Unit 3");
                if VMT.FindFirst()then begin
                    GenJnlLine.Validate("Shortcut Dimension 1 Code", VMT.SEGMENT);
                    GenJnlLine.Validate("Shortcut Dimension 10 Code", VMT.VESSELCODE);
                end;
                GenJnlLine.Validate("Shortcut Dimension 5 Code", InboundFinExpen."New FD5");
                GenJnlLine.Validate("Shortcut Dimension 6 Code", InboundFinExpen."EMP ID");
                GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyName);
                //GenJnlLine.Validate("Shortcut Dimension 9 Code", 'CARD');
                GenJnlLine.Validate("Shortcut Dimension 2 Code", ConcurSetup."Default Concur Dimension");
                GenJnlLine.Insert();
                InboundFinExpen."Posted Document No Fin Company":=GenJnlLine."Document No.";
                InboundFinExpen.Modify();
                exit(true);
            END;
        end;
    end;
    procedure PostShipCompany(var InboundFinExpen: Record "Concur inbound financial Expen"; DocNo: Code[20]; LineNo1: Integer; PrintEmp: Boolean): Boolean var
        myInt: Integer;
        entrydate: Date;
    begin
        GlSetup.Get();
        ConcurSetup.Get();
        ConcurSetup.TestField("Default Concur Dimension");
        CompanyMapping.get(InboundFinExpen."Finance Company No");
        CompanyMapping.TestField("Current Account No.");
        PrintEmp:=false;
        if PrintEmp = false then if(InboundFinExpen."Posted Document No Shp Company" = '') and (InboundFinExpen."Ship Sign Company No" = CompanyName)then begin
                if(((InboundFinExpen.Shipsign <> 'NA') and (InboundFinExpen.Shipsign <> 'Not Applicable') and (InboundFinExpen.Shipsign <> '')) or ((InboundFinExpen."Entry Custom 2(DOC Code)" <> 'NA') and (InboundFinExpen."Entry Custom 2(DOC Code)" <> 'Not Applicable') and (InboundFinExpen."Entry Custom 2(DOC Code)" <> ''))) and (UpperCase(InboundFinExpen."Payment Type") <> 'CASH') and (InboundFinExpen."Journal Key" <> '16900000') and (uppercase(InboundFinExpen."Journal Type") <> 'CASH_LEDGER')then begin
                    GenJnlLine.Init();
                    GenJnlLine."Journal Template Name":=ConcurSetup."Concur Template Name";
                    GenJnlLine."Journal Batch Name":=ConcurSetup."Concur Batch Name";
                    GenJnlLine."Line No.":=LineNo1;
                    DateTimeValue:=0DT;
                    evaluate(DateTimeValue, InboundFinExpen."Report Payment Processing Date");
                    GenJnlLine."Posting Date":=DT2Date(DateTimeValue);
                    DateTimeValue:=0DT;
                    evaluate(DateTimeValue, InboundFinExpen."Report Payment Processing Date");
                    GenJnlLine."VAT Reporting Date":=DT2Date(DateTimeValue);
                    GenJnlLine."Document No.":=DocNo;
                    GenJnlLine."Concur ID":=InboundFinExpen."Concur ID"; //VT
                    GenJnlLine."Entry Id":=InboundFinExpen."Entry Id"; //VT
                    GenJnlLine."Receipt image ID":=InboundFinExpen."Receipt Received"; //VT
                    GenJnlLine."External Document No.":=InboundFinExpen."Report Key";
                    GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine.Validate("Account No.", InboundFinExpen."Journal Key");
                    DateTimeValue:=0DT;
                    entrydate:=0D;
                    evaluate(DateTimeValue, InboundFinExpen."Entry Date");
                    entrydate:=DT2Date(DateTimeValue);
                    GenJnlLine.Description:=InboundFinExpen."Report Org Unit 3" + ' ' + copystr(InboundFinExpen."Entry Custom 2(DOC Code)", StrLen(InboundFinExpen."Entry Custom 2(DOC Code)") - 2, 3) + ' ' + CopyStr(InboundFinExpen."Employee name", 1, 10) + ' ' + Format(entrydate);
                    Evaluate(GenJnlLine.Amount, InboundFinExpen."Entry Approved Amount");
                    GenJnlLine.Validate(Amount);
                    if InboundFinExpen."Journal Tax Amount" <> '' then begin
                        Evaluate(GenJnlLine."VAT Amount", InboundFinExpen."Journal Tax Amount");
                        GenJnlLine.Validate("VAT Amount");
                    end;
                    GenJnlLine.Validate("Currency Code", InboundFinExpen."Spend Currency Alpha ISO");
                    // GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                    // GenJnlLine.Validate("Bal. Account No.", CompanyMapping."Current Account No.");
                    VMT.Reset();
                    VMT.SetRange(DBASE, CompanyName);
                    if VMT.FindFirst()then GenJnlLine.Validate("Shortcut Dimension 1 Code", VMT.SEGMENT);
                    VMT.Reset();
                    VMT.Setfilter(DBASE, CompanyName);
                    if VMT.FindFirst()then GenJnlLine.Validate("Shortcut Dimension 10 Code", VMT.VESSELCODE);
                    GenJnlLine.Validate("Shortcut Dimension 5 Code", InboundFinExpen."New FD5");
                    GenJnlLine.Validate("Shortcut Dimension 6 Code", InboundFinExpen."EMP ID");
                    GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyName);
                    //GenJnlLine.Validate("Shortcut Dimension 9 Code", 'CARD');
                    GenJnlLine.Validate("Shortcut Dimension 2 Code", ConcurSetup."Default Concur Dimension");
                    GenJnlLine."PB Concur invoice":=true;
                    GenJnlLine.Insert();
                    InboundFinExpen."Posted Document No Shp Company":=GenJnlLine."Document No.";
                    InboundFinExpen.Modify();
                    exit(true);
                end;
                if(((InboundFinExpen.Shipsign <> 'NA') and (InboundFinExpen.Shipsign <> 'Not Applicable') and (InboundFinExpen.Shipsign <> '')) or ((InboundFinExpen."Entry Custom 2(DOC Code)" <> 'NA') and (InboundFinExpen."Entry Custom 2(DOC Code)" <> 'Not Applicable') and (InboundFinExpen."Entry Custom 2(DOC Code)" <> ''))) and (UpperCase(InboundFinExpen."Payment Type") = 'CASH') and (InboundFinExpen."Journal Key" <> '16900000') and (uppercase(InboundFinExpen."Journal Type") <> 'CASH_LEDGER')then begin
                    GenJnlLine.Init();
                    GenJnlLine."Journal Template Name":=ConcurSetup."Concur Template Name";
                    GenJnlLine."Journal Batch Name":=ConcurSetup."Concur Batch Name";
                    GenJnlLine."Line No.":=LineNo1;
                    DateTimeValue:=0DT;
                    evaluate(DateTimeValue, InboundFinExpen."Report Payment Processing Date");
                    GenJnlLine."Posting Date":=DT2Date(DateTimeValue);
                    DateTimeValue:=0DT;
                    evaluate(DateTimeValue, InboundFinExpen."Report Payment Processing Date");
                    GenJnlLine."VAT Reporting Date":=DT2Date(DateTimeValue);
                    GenJnlLine."Document No.":=DocNo;
                    GenJnlLine."Concur ID":=InboundFinExpen."Concur ID"; //VT
                    GenJnlLine."Entry Id":=InboundFinExpen."Entry Id"; //VT
                    GenJnlLine."Receipt image ID":=InboundFinExpen."Receipt Received"; //VT
                    GenJnlLine."External Document No.":=InboundFinExpen."Report Key";
                    GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine.Validate("Account No.", InboundFinExpen."Journal Key");
                    DateTimeValue:=0DT;
                    entrydate:=0D;
                    evaluate(DateTimeValue, InboundFinExpen."Entry Date");
                    entrydate:=DT2Date(DateTimeValue);
                    GenJnlLine.Description:=InboundFinExpen."Report Org Unit 3" + ' ' + copystr(InboundFinExpen."Entry Custom 2(DOC Code)", StrLen(InboundFinExpen."Entry Custom 2(DOC Code)") - 2, 3) + ' ' + CopyStr(InboundFinExpen."Employee name", 1, 10) + ' ' + Format(entrydate);
                    Evaluate(GenJnlLine.Amount, InboundFinExpen."Entry Approved Amount");
                    GenJnlLine.Validate(Amount);
                    if InboundFinExpen."Journal Tax Amount" <> '' then begin
                        Evaluate(GenJnlLine."VAT Amount", InboundFinExpen."Journal Tax Amount");
                        GenJnlLine.Validate("VAT Amount");
                    end;
                    GenJnlLine.Validate("Currency Code", InboundFinExpen."Spend Currency Alpha ISO");
                    // GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                    // GenJnlLine.Validate("Bal. Account No.", CompanyMapping."Current Account No.");
                    VMT.Reset();
                    VMT.SetRange(DBASE, InboundFinExpen."Finance Company No");
                    if VMT.FindFirst()then GenJnlLine.Validate("Shortcut Dimension 1 Code", VMT.SEGMENT);
                    VMT.Reset();
                    VMT.Setfilter(DBASE, CompanyName);
                    if VMT.FindFirst()then GenJnlLine.Validate("Shortcut Dimension 10 Code", VMT.VESSELCODE);
                    GenJnlLine.Validate("Shortcut Dimension 5 Code", InboundFinExpen."New FD5");
                    GenJnlLine.Validate("Shortcut Dimension 6 Code", InboundFinExpen."EMP ID");
                    GenJnlLine.Validate("Shortcut Dimension 8 Code", InboundFinExpen."Finance Company No");
                    //GenJnlLine.Validate("Shortcut Dimension 9 Code", 'CARD');
                    GenJnlLine.Validate("Shortcut Dimension 2 Code", ConcurSetup."Default Concur Dimension");
                    GenJnlLine."PB Concur invoice":=true;
                    GenJnlLine.Insert();
                    InboundFinExpen."Posted Document No Shp Company":=GenJnlLine."Document No.";
                    InboundFinExpen.Modify();
                    exit(true);
                end;
            end;
    end;
}
