codeunit 50148 "DNV Crew Payroll Posting"
{
    TableNo = "PB Crew Payroll Inbound";

    trigger OnRun()
    var
        //PbPurcchInv: Record "PB Purchase Invoice Inbound";
        VMT: record VMT;
        DNVSetup: Record "DNV Integration Setup";
        DNVCrewPayLine: record "PB Crew Payroll Dim Inb";
        CompanyMapping: record "Company Name Mapping";
        GenJnlLine: record "Gen. Journal Line";
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
        TempGlACcountNet: Record "G/L Account Net Change" temporary;
        DNVMapping: record "DNV Mapping";
        NextDocumentNo: Code[20];
        Employee: Record Employee;
        ICCompanyNo: Text;
        LeaveAmount: Decimal;
        WagesAmount: Decimal;
        EmpCountryCode: Code[10];
        DimValue: record "Dimension Value";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        mEntryNo: Integer;
        GLEntry: Record "G/L Entry";
        JnlPostBatch: Codeunit 50190;
        CompanyMapping2: record "Company Name Mapping";
    begin
        GlSetup.Get();
        DNVSetup.Get();
        CompanyMapping.Reset();
        CompanyMapping.SetRange("Master Data Company", true);
        CompanyMapping.FindSet();
        Employee.Reset();
        Employee.ChangeCompany(CompanyMapping."BC Company Name");
        Employee.SetRange("No.", rec."Crew Personnel Number");
        if Employee.FindSet()then EmpCountryCode:=Employee.Nationality2;
        if EmpCountryCode <> '' then begin
            DimValue.Reset();
            DimValue.SetRange("Global Dimension No.", 7);
            DimValue.SetRange(code, EmpCountryCode);
            if not DimValue.FindSet()then EmpCountryCode:='Z000';
        end;
        if EmpCountryCode = '' then EmpCountryCode:='Z000';
        CompanyMapping.Reset();
        CompanyMapping.get(CompanyName);
        CompanyMapping.TestField("Current Account No.");
        if(Rec."Posted Document No Fin Company" = '') and (rec."Finance Company No" = CompanyName)then begin
            GenTemp.get(DNVSetup."Default Gen. Jnl. Template");
            GlDescription:='';
            VMT.Reset();
            vmt.SetRange(DBASE, CompanyMapping."PB Company Code");
            VMT.FindSet();
            VMTShipCode.Reset();
            VMTShipCode.Setfilter(SHIPSIGN, format(rec."Ship Short Sign"));
            VMTShipCode.FindSet();
            CompanyMapping2.Reset();
            CompanyMapping2.get(CompanyName);
            InvoiceAmount:=0;
            DNVCrewPayLine.Reset();
            DNVCrewPayLine.SetRange("Crew Payroll Entry No.", rec."Entry No.");
            DNVCrewPayLine.SetFilter("Total Amount", '<>%1', 0);
            DNVCrewPayLine.SetRange("IC Code", rec."Finance Company No");
            if DNVCrewPayLine.FindSet()then begin
                GenJnlLine.Reset();
                GenJnlLine.setrange("Journal Template Name", DNVSetup."Default Gen. Jnl. Template");
                GenJnlLine.setrange("Journal Batch Name", DNVSetup."Default Gen. Jnl. Batch");
                if GenJnlLine.FindSet()then GenJnlLine.DeleteAll(true);
                LineNo:=0;
                NextDocumentNo:=format(rec."Entry No.");
                repeat ICCompanyNo:='';
                    GlAccountNo:='';
                    ICCompanyNo:=DNVCrewPayLine."IC Code";
                    GlAccountNo:=DNVCrewPayLine."GL Code";
                    if ICCompanyNo <> '' then begin
                        LineNo:=LineNo + 10000;
                        CompanyMapping.Reset();
                        CompanyMapping.get(rec."Ship Sign Company No");
                        CompanyMapping.TestField("Current Account No.");
                        GenJnlLine.Init();
                        GenJnlLine."Journal Template Name":=DNVSetup."Default Gen. Jnl. Template";
                        GenJnlLine."Journal Batch Name":=DNVSetup."Default Gen. Jnl. Batch";
                        GenJnlLine.Validate("Document No.", NextDocumentNo);
                        GenJnlLine."Line No.":=LineNo;
                        GenJnlLine.Validate("Posting Date", Rec."Posting Date");
                        GenJnlLine.validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
                        GenJnlLine.Validate("Account No.", GlAccountNo);
                        GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                        GenJnlLine.Validate("Bal. Account No.", CompanyMapping."Current Account No.");
                        GenJnlLine.Validate("Currency Code", rec."Currency Code");
                        if COPYSTR(DNVCrewPayLine."Wage Dimension Code", 1, 1) <> 'D' then GenJnlLine.Validate(Amount, DNVCrewPayLine."Total Amount")
                        else
                            GenJnlLine.Validate(Amount, -1 * DNVCrewPayLine."Total Amount");
                        GenJnlLine.Validate("Shortcut Dimension 1 Code", vmt.SEGMENT);
                        if rec."Is Paid Out" then GenJnlLine.Validate("Shortcut Dimension 2 Code", 'DSOFF')
                        else
                            GenJnlLine.Validate("Shortcut Dimension 2 Code", 'DCREW');
                        GenJnlLine.Validate("Shortcut Dimension 6 Code", rec."Crew Personnel Number");
                        GenJnlLine.Validate("Shortcut Dimension 7 Code", EmpCountryCode);
                        GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyMapping2."PB Company Code");
                        GenJnlLine.Validate("Shortcut Dimension 9 Code", 'CREW'); // take fro msetup
                        GenJnlLine.Validate("Shortcut Dimension 10 Code", VMTShipCode.VESSELCODE);
                        GenJnlLine."External Document No.":=format(rec."Transaction Number");
                        GlDescription:=DNVCrewPayLine."Wage Dimension Value" + ' ' + format(rec."Payment From") + '-' + Format(rec."Payment To");
                        GenJnlLine.Description:=format(VMTShipCode.SHIPSIGN) + GlDescription;
                        GenJnlLine."DNV Crew Payroll Entry No":=rec."Entry No.";
                        GenJnlLine.Insert(true);
                    end;
                    GlAccountNo:='';
                until DNVCrewPayLine.Next() = 0;
                GenJnlLine.Reset();
                GenJnlLine.SetRange("Journal Template Name", DNVSetup."Default Gen. Jnl. Template");
                GenJnlLine.SetRange("Journal Batch Name", DNVSetup."Default Gen. Jnl. Batch");
                GenJnlLine.SetRange("Document No.", NextDocumentNo);
                GenJnlLine.FindSet();
                JnlPostBatch.Run(GenJnlLine);
            end
            else
                Error('Data is not valid');
        end;
        // Expenes Company Posting in ship company
        if(Rec."Posted Document No Shp Company" = '') and (rec."Ship Sign Company No" = CompanyName)then begin
            GlDescription:='';
            if Employee.Get(rec."Crew Personnel Number")then;
            VMT.Reset();
            vmt.SetRange(DBASE, CompanyMapping."PB Company Code");
            VMT.FindSet();
            VMTShipCode.Reset();
            VMTShipCode.Setfilter(SHIPSIGN, format(rec."Ship Short Sign"));
            VMTShipCode.FindSet();
            InvoiceAmount:=0;
            LeaveAmount:=0;
            WagesAmount:=0;
            DNVCrewPayLine.Reset();
            DNVCrewPayLine.SetRange("Crew Payroll Entry No.", rec."Entry No.");
            DNVCrewPayLine.SetFilter("Total Amount", '<>%1', 0);
            //DNVCrewPayLine.SetFilter("Wage Dimension Code", '<>%1', '005');
            if DNVCrewPayLine.FindSet()then begin
                GenJnlLine.Reset();
                if not Rec."Is Paid Out" then begin
                    GenJnlLine.setrange("Journal Template Name", DNVSetup."Default Gen. Jnl. Template");
                    GenJnlLine.setrange("Journal Batch Name", DNVSetup."Default Gen. Jnl. Batch");
                    GenTemp.get(DNVSetup."Default Gen. Jnl. Template");
                    NextDocumentNo:=format(rec."Entry No.");
                end
                else
                begin
                    GenJnlLine.setrange("Journal Template Name", DNVSetup."Payout Default Gen. Jnl. Templ");
                    GenJnlLine.setrange("Journal Batch Name", DNVSetup."Payout Default Gen. Jnl. Batch");
                    GenTemp.get(DNVSetup."Payout Default Gen. Jnl. Templ");
                    NextDocumentNo:=format(Rec."Entry No.");
                end;
                if GenJnlLine.FindLast()then LineNo:=GenJnlLine."Line No."
                else
                    LineNo:=0;
                repeat ICCompanyNo:='';
                    GlAccountNo:='';
                    ICCompanyNo:=DNVCrewPayLine."IC Code";
                    GlAccountNo:=DNVCrewPayLine."GL Code";
                    if DNVCrewPayLine."IC Code" <> '' then begin
                        CompanyMapping.Reset();
                        CompanyMapping.get(DNVCrewPayLine."IC Code");
                        CompanyMapping.TestField("Current Account No.");
                    end;
                    CompanyMapping2.Reset();
                    CompanyMapping2.Get(CompanyName);
                    LineNo:=LineNo + 10000;
                    GenJnlLine.Init();
                    if not rec."Is Paid Out" then begin
                        GenJnlLine."Journal Template Name":=DNVSetup."Default Gen. Jnl. Template";
                        GenJnlLine."Journal Batch Name":=DNVSetup."Default Gen. Jnl. Batch";
                    end
                    else
                    begin
                        GenJnlLine."Journal Template Name":=DNVSetup."Payout Default Gen. Jnl. Templ";
                        GenJnlLine."Journal Batch Name":=DNVSetup."Payout Default Gen. Jnl. Batch";
                    end;
                    GenJnlLine.Validate("Document No.", NextDocumentNo);
                    GenJnlLine."Line No.":=LineNo;
                    GenJnlLine.Validate("Posting Date", Rec."Posting Date");
                    GenJnlLine.validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    if ICCompanyNo = '' then GenJnlLine.Validate("Account No.", GlAccountNo)
                    else
                        GenJnlLine.Validate("Account No.", CompanyMapping."Current Account No.");
                    //GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                    GenJnlLine.Validate("Currency Code", rec."Currency Code");
                    if COPYSTR(DNVCrewPayLine."Wage Dimension Code", 1, 1) <> 'D' then GenJnlLine.Validate(Amount, DNVCrewPayLine."Total Amount")
                    else
                        GenJnlLine.Validate(Amount, -1 * DNVCrewPayLine."Total Amount");
                    GenJnlLine.Validate("Shortcut Dimension 1 Code", vmt.SEGMENT);
                    if rec."Is Paid Out" then GenJnlLine.Validate("Shortcut Dimension 2 Code", 'DSOFF')
                    else
                        GenJnlLine.Validate("Shortcut Dimension 2 Code", 'DCREW');
                    GenJnlLine.Validate("Shortcut Dimension 6 Code", rec."Crew Personnel Number");
                    GenJnlLine.Validate("Shortcut Dimension 7 Code", EmpCountryCode);
                    GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyMapping2."PB Company Code");
                    GenJnlLine.Validate("Shortcut Dimension 9 Code", 'CREW'); // take fro msetup
                    GenJnlLine.Validate("Shortcut Dimension 10 Code", VMTShipCode.VESSELCODE);
                    GenJnlLine."External Document No.":=format(rec."Transaction Number");
                    GlDescription:=DNVCrewPayLine."Wage Dimension Value" + '  ' + format(rec."Payment From") + '-' + Format(rec."Payment To");
                    GenJnlLine.Description:=format(VMTShipCode.SHIPSIGN) + '  ' + GlDescription;
                    if DNVCrewPayLine."Wage Dimension Code" <> '005' then begin
                        WagesAmount:=WagesAmount + GenJnlLine.Amount;
                    end
                    else
                    begin
                        LeaveAmount:=LeaveAmount + GenJnlLine.Amount;
                    end;
                    GenJnlLine."DNV Crew Payroll Entry No":=rec."Entry No.";
                    GenJnlLine.Insert(true);
                    GlAccountNo:='';
                until DNVCrewPayLine.Next() = 0;
                //Wages Balancing Amount
                if WagesAmount <> 0 then begin
                    LineNo:=LineNo + 10000;
                    GenJnlLine.Init();
                    if not rec."Is Paid Out" then begin
                        GenJnlLine."Journal Template Name":=DNVSetup."Default Gen. Jnl. Template";
                        GenJnlLine."Journal Batch Name":=DNVSetup."Default Gen. Jnl. Batch";
                    end
                    else
                    begin
                        GenJnlLine."Journal Template Name":=DNVSetup."Payout Default Gen. Jnl. Templ";
                        GenJnlLine."Journal Batch Name":=DNVSetup."Payout Default Gen. Jnl. Batch";
                    end;
                    GenJnlLine.Validate("Document No.", NextDocumentNo);
                    GenJnlLine."Line No.":=LineNo;
                    GenJnlLine.Validate("Posting Date", rec."Posting Date");
                    GenJnlLine.validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.Validate("Account No.", DNVSetup."Wages Bal Account No.");
                    GenJnlLine.Validate("Currency Code", rec."Currency Code");
                    GenJnlLine.Validate(Amount, -1 * WagesAmount);
                    GenJnlLine.Validate("Shortcut Dimension 1 Code", vmt.SEGMENT);
                    if rec."Is Paid Out" then GenJnlLine.Validate("Shortcut Dimension 2 Code", 'DSOFF')
                    else
                        GenJnlLine.Validate("Shortcut Dimension 2 Code", 'DCREW');
                    GenJnlLine.Validate("Shortcut Dimension 6 Code", rec."Crew Personnel Number");
                    GenJnlLine.Validate("Shortcut Dimension 7 Code", EmpCountryCode);
                    GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyMapping2."PB Company Code");
                    GenJnlLine.Validate("Shortcut Dimension 9 Code", 'CREW'); // take fro msetup
                    GenJnlLine.Validate("Shortcut Dimension 10 Code", VMTShipCode.VESSELCODE);
                    GenJnlLine."External Document No.":=format(rec."Transaction Number");
                    GlDescription:='Wage   ' + format(rec."Payment From") + '-' + Format(rec."Payment To");
                    GenJnlLine.Description:=format(VMTShipCode.SHIPSIGN) + '  ' + GlDescription;
                    GenJnlLine."DNV Crew Payroll Entry No":=rec."Entry No.";
                    GenJnlLine.Insert(true);
                end;
                //Leave Balancing Amount
                if LeaveAmount <> 0 then begin
                    LineNo:=LineNo + 10000;
                    GenJnlLine.Init();
                    if not rec."Is Paid Out" then begin
                        GenJnlLine."Journal Template Name":=DNVSetup."Default Gen. Jnl. Template";
                        GenJnlLine."Journal Batch Name":=DNVSetup."Default Gen. Jnl. Batch";
                    end
                    else
                    begin
                        GenJnlLine."Journal Template Name":=DNVSetup."Payout Default Gen. Jnl. Templ";
                        GenJnlLine."Journal Batch Name":=DNVSetup."Payout Default Gen. Jnl. Batch";
                    end;
                    GenJnlLine.Validate("Document No.", NextDocumentNo);
                    GenJnlLine."Line No.":=LineNo;
                    GenJnlLine.Validate("Posting Date", Rec."Posting Date");
                    GenJnlLine.validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.Validate("Account No.", DNVSetup."Leave Pay Bal Account No.");
                    GenJnlLine.Validate("Currency Code", rec."Currency Code");
                    GenJnlLine.Validate(Amount, -1 * LeaveAmount);
                    GenJnlLine.Validate("Shortcut Dimension 1 Code", vmt.SEGMENT);
                    if rec."Is Paid Out" then GenJnlLine.Validate("Shortcut Dimension 2 Code", 'DSOFF')
                    else
                        GenJnlLine.Validate("Shortcut Dimension 2 Code", 'DCREW');
                    GenJnlLine.Validate("Shortcut Dimension 6 Code", rec."Crew Personnel Number");
                    GenJnlLine.Validate("Shortcut Dimension 7 Code", EmpCountryCode);
                    GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyMapping2."PB Company Code");
                    GenJnlLine.Validate("Shortcut Dimension 9 Code", 'CREW'); // take fro msetup
                    GenJnlLine.Validate("Shortcut Dimension 10 Code", VMTShipCode.VESSELCODE);
                    GenJnlLine."External Document No.":=format(rec."Transaction Number");
                    GlDescription:=' Leave Pay ' + format(rec."Payment From") + '-' + Format(rec."Payment To");
                    GenJnlLine.Description:=format(VMTShipCode.SHIPSIGN) + '  ' + GlDescription;
                    GenJnlLine."DNV Crew Payroll Entry No":=rec."Entry No.";
                    GenJnlLine.Insert(true);
                end;
            end;
            GenJnlLine.Reset();
            if not rec."Is Paid Out" then begin
                GenJnlLine."Journal Template Name":=DNVSetup."Default Gen. Jnl. Template";
                GenJnlLine."Journal Batch Name":=DNVSetup."Default Gen. Jnl. Batch";
            end
            else
            begin
                GenJnlLine."Journal Template Name":=DNVSetup."Payout Default Gen. Jnl. Templ";
                GenJnlLine."Journal Batch Name":=DNVSetup."Payout Default Gen. Jnl. Batch";
            end;
            GenJnlLine.SetRange("Document No.", NextDocumentNo);
            GenJnlLine.FindSet();
            JnlPostBatch.Run(GenJnlLine);
        end;
    end;
}
