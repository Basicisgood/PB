codeunit 50180 "IC Central Payment Posting"
{
    TableNo = "PB Central Payment History";

    trigger OnRun()
    var
        GenJnlLine: record "Gen. Journal Line";
        vendor: Record Vendor;
        LineNo: Integer;
        NoSeries: Codeunit "No. Series";
        GenTemp: Record "Gen. Journal Template";
        GlSetup: Record "General Ledger Setup";
        GlDescription: Text;
        GlAccountNo: Code[20];
        GenJnLLine2: record "Gen. Journal Line";
        CurrentaccountNo: code[20];
        CompanyMapping: record "Company Name Mapping";
        PBCommonSetup: record "PB Common Setup";
        ICCurrentAccountNo: code[20];
        VendLedgEntry: record "Vendor Ledger Entry";
        VMTList: Record VMT;
        VendorNo: code[20];
        EmpLedgerEntry: record "Employee Ledger Entry";
        CU50190: Codeunit 50190;
        IsEntryOpen: Boolean;
        Customer: Record Customer;
        CustomerNo: Code[20];
        CustLedgEntry: Record "Cust. Ledger Entry";
        IMOSSetup: Record "IMOS Setup";
        GLEntry: Record "G/L Entry";
        P6050: page 6050;
    begin
        //        if rec."Entry Type" = rec."Entry Type"::Customer then Error('CT');
        rec.CalcFields("Parent Entry No.");
        GLEntry.Reset();
        GLEntry.SetRange("Central Payment Entry No", Rec."Entry No.");
        GLEntry.SetRange(Reversed, false);
        if GLEntry.FindSet()then exit;
        if rec."Source Company" = CompanyName then begin
            rec.CalcFields("Parent Entry No.");
            GLEntry.Reset();
            GLEntry.SetRange("Central Payment Entry No", Rec."Parent Entry No.");
            GLEntry.SetRange(Reversed, false);
            if GLEntry.FindSet()then exit;
            GLEntry.Reset();
            GLEntry.SetRange("Central Pay. Parent Entry No", Rec."Parent Entry No.");
            GLEntry.SetRange(Reversed, false);
            if GLEntry.FindSet()then exit;
        end;
        GlSetup.Get();
        PBCommonSetup.Get();
        IMOSSetup.Get();
        rec.CalcFields("Document Amount", "Document Bank Charges Amount", "Document Over Receipt Amount");
        if Rec."Document Bank Charges Amount" <> 0 then begin
            if(Rec."Posted in Source Company" = false) and (rec."Source Company" = CompanyName)then begin
                CurrentaccountNo:='';
                ICCurrentAccountNo:='';
                CompanyMapping.get(CompanyName);
                CompanyMapping.TestField("Current Account No.");
                CurrentaccountNo:=CompanyMapping."Current Account No.";
                GenTemp.get(PBCommonSetup."Central Payment Template Name");
                VMTList.Reset();
                VMTList.SetRange(DBASE, CompanyMapping."PB Company Code");
                VMTList.FindSet();
                CompanyMapping.Reset();
                CompanyMapping.SetRange("BC Company Name", rec."Target Company");
                CompanyMapping.FindSet();
                CompanyMapping.TestField("Current Account No.");
                ICCurrentAccountNo:=CompanyMapping."Current Account No.";
                if rec."Entry Type" = rec."Entry Type"::Vendor then begin
                    VendLedgEntry.Reset();
                    if rec."No." <> '' then VendLedgEntry.SetRange("Vendor No.", Rec."No.");
                    VendLedgEntry.SetRange("Document No.", rec."Source Gl Entry Document No");
                    VendLedgEntry.FindSet();
                    IsEntryOpen:=VendLedgEntry.Open;
                end
                else if rec."Entry Type" = rec."Entry Type"::Employee then begin
                        EmpLedgerEntry.Reset();
                        if rec."No." <> '' then EmpLedgerEntry.SetRange("Employee No.", Rec."No.");
                        EmpLedgerEntry.SetRange("Document No.", rec."Source Gl Entry Document No");
                        EmpLedgerEntry.FindSet();
                        IsEntryOpen:=EmpLedgerEntry.Open;
                    end
                    else if rec."Entry Type" = rec."Entry Type"::Customer then begin
                            CustLedgEntry.Reset();
                            if rec."No." <> '' then CustLedgEntry.SetRange("Customer No.", Rec."No.");
                            CustLedgEntry.SetRange("Document No.", rec."Source Gl Entry Document No");
                            CustLedgEntry.FindSet();
                            IsEntryOpen:=CustLedgEntry.Open;
                        end;
                GenJnlLine.Reset();
                GenJnlLine.setrange("Journal Template Name", PBCommonSetup."Central Payment Template Name");
                GenJnlLine.setrange("Journal Batch Name", PBCommonSetup."Central Payment Batch Name");
                if GenJnlLine.FindLast()then GenJnlLine.DeleteAll(true);
                LineNo:=0;
                // IC Line
                LineNo:=LineNo + 10000;
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name":=PBCommonSetup."Central Payment Template Name";
                GenJnlLine."Journal Batch Name":=PBCommonSetup."Central Payment Batch Name";
                GenJnlLine.Validate("Document No.", format(rec."Entry No."));
                GenJnlLine."Line No.":=LineNo;
                GenJnlLine.Validate("Posting Date", Rec."Posting Date");
                GenJnlLine.Validate("Document Date", rec."Document Date");
                GenJnlLine.validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
                GenJnlLine.Validate("Account No.", ICCurrentAccountNo);
                GenJnlLine.Validate("Currency Code", rec."Currency Code");
                //GenJnlLine.Validate(Amount, (-1 * (rec.Amount + rec."Over Receipt Amount" - rec."Bank Charges")));
                GenJnlLine.Validate(Amount, (-1 * (rec."Document Amount" + rec."Document Over Receipt Amount" - rec."Document Bank Charges Amount")));
                if rec."Exchange Rate" <> 0 then GenJnLLine.Validate("Currency Factor", rec."Exchange Rate");
                if VMTList."Use FD1 Mapping" then GenJnlLine.Validate("Shortcut Dimension 1 Code", rec.FD1)
                else
                    GenJnlLine.Validate("Shortcut Dimension 1 Code", vmtlist.SEGMENT);
                GenJnlLine.Validate("Shortcut Dimension 2 Code", PBCommonSetup."Central Payment Template Name");
                GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyName);
                GenJnlLine.Validate("External Document No.", rec."Source Gl Entry Document No");
                GenJnlLine."CP External Document No":=rec."Invoice External No.";
                GenJnlLine."Bank Document No.":=rec."Bank Document No.";
                GenJnlLine."IMOS Transaction No":=rec."IMOS Transaction No";
                GenJnlLine."Central Payment Entry No":=Rec."Entry No.";
                GenJnlLine."Central Pay. Parent Entry No":=rec."Parent Entry No.";
                GenJnlLine.Insert(true);
                //Customer Line
                LineNo:=LineNo + 10000;
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name":=PBCommonSetup."Central Payment Template Name";
                GenJnlLine."Journal Batch Name":=PBCommonSetup."Central Payment Batch Name";
                GenJnlLine.Validate("Document No.", format(rec."Entry No."));
                GenJnlLine."Line No.":=LineNo;
                GenJnlLine.Validate("Posting Date", Rec."Posting Date");
                GenJnlLine.Validate("Document Date", rec."Document Date");
                GenJnlLine.validate("Account Type", GenJnlLine."Account Type"::Customer);
                GenJnlLine.Validate("Account No.", CustLedgEntry."Customer No.");
                GenJnlLine.Validate("Currency Code", rec."Currency Code");
                GenJnlLine.Validate(Amount, (1 * (rec."Document Amount" + rec."Document Over Receipt Amount")));
                if rec."Exchange Rate" <> 0 then GenJnLLine.Validate("Currency Factor", rec."Exchange Rate");
                if VMTList."Use FD1 Mapping" then GenJnlLine.Validate("Shortcut Dimension 1 Code", rec.FD1)
                else
                    GenJnlLine.Validate("Shortcut Dimension 1 Code", vmtlist.SEGMENT);
                GenJnlLine.Validate("Shortcut Dimension 2 Code", PBCommonSetup."Central Payment Template Name");
                GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyName);
                GenJnlLine.Validate("External Document No.", rec."Source Gl Entry Document No");
                GenJnlLine."CP External Document No":=rec."Invoice External No.";
                GenJnlLine."Bank Document No.":=rec."Bank Document No.";
                GenJnlLine."Central Payment Entry No":=Rec."Entry No.";
                GenJnlLine."Central Pay. Parent Entry No":=rec."Parent Entry No.";
                GenJnlLine."IMOS Transaction No":=rec."IMOS Transaction No";
                if IsEntryOpen then begin
                    if Rec."Entry Type" = rec."Entry Type"::Vendor then GenJnlLine.Validate("Applies-to Doc. Type", VendLedgEntry."Document Type")
                    else if Rec."Entry Type" = Rec."Entry Type"::Employee then GenJnlLine.Validate("Applies-to Doc. Type", EmpLedgerEntry."Document Type")
                        else if Rec."Entry Type" = Rec."Entry Type"::Customer then GenJnlLine.Validate("Applies-to Doc. Type", CustLedgEntry."Document Type");
                    GenJnlLine.Validate("Applies-to Doc. No.", rec."Source Gl Entry Document No");
                end
                else
                    GenJnlLine."Manual Application Needed":=true;
                GenJnlLine.Insert(true);
                //Bank Charges
                LineNo:=LineNo + 10000;
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name":=PBCommonSetup."Central Payment Template Name";
                GenJnlLine."Journal Batch Name":=PBCommonSetup."Central Payment Batch Name";
                GenJnlLine.Validate("Document No.", format(rec."Entry No."));
                GenJnlLine."Line No.":=LineNo;
                GenJnlLine.Validate("Posting Date", Rec."Posting Date");
                GenJnlLine.Validate("Document Date", rec."Document Date");
                GenJnlLine.validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
                GenJnlLine.Validate("Account No.", IMOSSetup."Bank Charge GL Code");
                GenJnlLine.Validate("Currency Code", rec."Currency Code");
                GenJnlLine.Validate(Amount, (-1 * (rec."Document Bank Charges Amount")));
                if rec."Exchange Rate" <> 0 then GenJnLLine.Validate("Currency Factor", rec."Exchange Rate");
                if VMTList."Use FD1 Mapping" then GenJnlLine.Validate("Shortcut Dimension 1 Code", rec.FD1)
                else
                    GenJnlLine.Validate("Shortcut Dimension 1 Code", vmtlist.SEGMENT);
                GenJnlLine.Validate("Shortcut Dimension 2 Code", PBCommonSetup."Central Payment Template Name");
                GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyName);
                GenJnlLine.Validate("Shortcut Dimension 3 Code", Rec.FD3);
                GenJnLLine.Validate("Shortcut Dimension 4 Code", Rec.FD4);
                GenJnlLine.Validate("Shortcut Dimension 5 Code", Rec.FD5);
                GenJnlLine.Validate("Shortcut Dimension 10 Code", Rec.FD10);
                GenJnlLine.Validate("External Document No.", rec."Source Gl Entry Document No");
                GenJnlLine."CP External Document No":=rec."Invoice External No.";
                GenJnlLine."Bank Document No.":=rec."Bank Document No.";
                GenJnlLine."Central Payment Entry No":=Rec."Entry No.";
                GenJnlLine."Central Pay. Parent Entry No":=rec."Parent Entry No.";
                GenJnlLine."IMOS Transaction No":=rec."IMOS Transaction No";
                GenJnlLine.Insert(true);
                GenJnlLine.Reset();
                GenJnlLine.setrange("Journal Template Name", PBCommonSetup."Central Payment Template Name");
                GenJnlLine.setrange("Journal Batch Name", PBCommonSetup."Central Payment Batch Name");
                GenJnlLine.SetRange("Document No.", Format(Rec."Entry No."));
                GenJnlLine.FindSet();
                Clear(CU50190);
                CU50190.Run(GenJnlLine);
            end;
            if(Rec."Posted in Target Company" = false) and (rec."Target Company" = CompanyName)then begin
                CurrentaccountNo:='';
                ICCurrentAccountNo:='';
                CompanyMapping.get(CompanyName);
                CompanyMapping.TestField("Current Account No.");
                CurrentaccountNo:=CompanyMapping."Current Account No.";
                GenTemp.get(PBCommonSetup."Central Payment Template Name");
                VMTList.Reset();
                VMTList.SetRange(DBASE, CompanyMapping."PB Company Code");
                VMTList.FindSet();
                CompanyMapping.Reset();
                CompanyMapping.SetRange("BC Company Name", rec."Source Company");
                CompanyMapping.FindSet();
                CompanyMapping.TestField("Current Account No.");
                ICCurrentAccountNo:=CompanyMapping."Current Account No.";
                GenTemp.get(PBCommonSetup."Central Payment Template Name");
                if rec."Entry Type" = rec."Entry Type"::Vendor then begin
                    VendLedgEntry.Reset();
                    if Rec."No." <> '' then VendLedgEntry.SetRange("Vendor No.", Rec."No.");
                    VendLedgEntry.SetRange("Document No.", rec."Applied Document No.");
                    VendLedgEntry.FindSet();
                    VendLedgEntry."Applies-to ID":='';
                    VendLedgEntry.Modify();
                end
                else if rec."Entry Type" = rec."Entry Type"::Employee then begin
                        EmpLedgerEntry.Reset();
                        //EmpLedgerEntry.ChangeCompany(rec."Target Company");
                        if rec."No." <> '' then EmpLedgerEntry.setrange("Employee No.", Rec."No.");
                        EmpLedgerEntry.SetRange("Document No.", rec."Applied Document No.");
                        EmpLedgerEntry.FindSet();
                        EmpLedgerEntry."Applies-to ID":='';
                        EmpLedgerEntry.Modify();
                    end
                    else if rec."Entry Type" = rec."Entry Type"::Customer then begin
                            CustLedgEntry.Reset();
                            if Rec."No." <> '' then CustLedgEntry.SetRange("Customer No.", Rec."No.");
                            CustLedgEntry.SetRange("Document No.", rec."Applied Document No.");
                            CustLedgEntry.FindSet();
                            CustLedgEntry."Applies-to ID":='';
                            CustLedgEntry.Modify();
                        end;
                GenJnlLine.Reset();
                GenJnlLine.setrange("Journal Template Name", PBCommonSetup."Central Payment Template Name");
                GenJnlLine.setrange("Journal Batch Name", PBCommonSetup."Central Payment Batch Name");
                if GenJnlLine.FindLast()then GenJnlLine.DeleteAll(true);
                LineNo:=0;
                //Customer Entry
                LineNo:=LineNo + 10000;
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name":=PBCommonSetup."Central Payment Template Name";
                GenJnlLine."Journal Batch Name":=PBCommonSetup."Central Payment Batch Name";
                if rec."Entry Type" <> rec."Entry Type"::Customer then begin
                    if Rec.Amount < 0 then GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment)
                    else
                        GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Refund);
                end
                else
                begin
                    if Rec.Amount > 0 then GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment)
                    else
                        GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Refund);
                end;
                GenJnlLine.Validate("Document No.", Format(Rec."Entry No."));
                GenJnlLine."Line No.":=LineNo;
                GenJnlLine.Validate("Posting Date", Rec."Posting Date");
                GenJnlLine.Validate("Document Date", rec."Document Date");
                if rec."Entry Type" = rec."Entry Type"::Vendor then begin
                    GenJnlLine.validate("Account Type", GenJnlLine."Account Type"::Vendor);
                    GenJnlLine.Validate("Account No.", VendLedgEntry."Vendor No.");
                end
                else if rec."Entry Type" = rec."Entry Type"::Employee then begin
                        GenJnlLine.validate("Account Type", GenJnlLine."Account Type"::Employee);
                        GenJnlLine.Validate("Account No.", EmpLedgerEntry."Employee No.");
                    end
                    else if rec."Entry Type" = rec."Entry Type"::Customer then begin
                            GenJnlLine.validate("Account Type", GenJnlLine."Account Type"::Customer);
                            GenJnlLine.Validate("Account No.", CustLedgEntry."Customer No.");
                        end;
                //              GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                //            GenJnlLine.Validate("Bal. Account No.", ICCurrentAccountNo);
                GenJnlLine.Validate("Currency Code", rec."Currency Code");
                GenJnlLine.Validate(Amount, (-1 * (rec.Amount + rec."Over Receipt Amount")));
                if rec."Exchange Rate" <> 0 then GenJnLLine.Validate("Currency Factor", rec."Exchange Rate");
                if not VMTList."Use FD1 Mapping" then GenJnlLine.Validate("Shortcut Dimension 1 Code", vmtlist.SEGMENT)
                else
                    GenJnlLine.Validate("Shortcut Dimension 1 Code", rec.FD1);
                GenJnlLine.Validate("Shortcut Dimension 2 Code", PBCommonSetup."Central Payment Template Name");
                GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyName);
                GenJnlLine.Validate("External Document No.", rec."Source Gl Entry Document No");
                if Rec."Over Receipt Amount" <> 0 then GenJnlLine."CP Over Receipt":=true;
                GenJnlLine."Over Receipt":=Rec."Over Receipt Amount";
                GenJnlLine."Bank Charges":=Rec."Bank Charges";
                GenJnlLine."CP External Document No":=rec."Invoice External No.";
                GenJnlLine."IMOS Transaction No":=rec."IMOS Transaction No";
                GenJnlLine."IMOS Bank ID":=Rec."Bank ID";
                GenJnlLine."Central Payment Entry No":=Rec."Entry No.";
                GenJnlLine."Central Pay. Parent Entry No":=rec."Parent Entry No.";
                GenJnlLine."Bank Document No.":=rec."Bank Document No.";
                //GenJnlLine.Validate("Applies-to Doc. Type", GenJnlLine."Applies-to Doc. Type"::Invoice);
                if Rec."Entry Type" = rec."Entry Type"::Vendor then GenJnlLine.Validate("Applies-to Doc. Type", VendLedgEntry."Document Type")
                else if Rec."Entry Type" = Rec."Entry Type"::Employee then GenJnlLine.Validate("Applies-to Doc. Type", EmpLedgerEntry."Document Type")
                    else if Rec."Entry Type" = Rec."Entry Type"::Customer then GenJnlLine.Validate("Applies-to Doc. Type", CustLedgEntry."Document Type");
                GenJnlLine.Validate("Applies-to Doc. No.", rec."Applied Document No.");
                GenJnlLine.Insert(true);
                //IC Entry
                LineNo:=LineNo + 10000;
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name":=PBCommonSetup."Central Payment Template Name";
                GenJnlLine."Journal Batch Name":=PBCommonSetup."Central Payment Batch Name";
                if rec."Entry Type" <> rec."Entry Type"::Customer then begin
                    if Rec.Amount < 0 then GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment)
                    else
                        GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Refund);
                end
                else
                begin
                    if Rec.Amount > 0 then GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment)
                    else
                        GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Refund);
                end;
                GenJnlLine.Validate("Document No.", Format(Rec."Entry No."));
                GenJnlLine."Line No.":=LineNo;
                GenJnlLine.Validate("Posting Date", Rec."Posting Date");
                GenJnlLine.Validate("Document Date", rec."Document Date");
                GenJnlLine.Validate("Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                GenJnlLine.Validate("Account No.", ICCurrentAccountNo);
                GenJnlLine.Validate("Currency Code", rec."Currency Code");
                GenJnlLine.Validate(Amount, (1 * (rec.Amount + rec."Over Receipt Amount" - rec."Bank Charges")));
                if rec."Exchange Rate" <> 0 then GenJnLLine.Validate("Currency Factor", rec."Exchange Rate");
                if VMTList."Use FD1 Mapping" then GenJnlLine.Validate("Shortcut Dimension 1 Code", rec.FD1)
                else
                    GenJnlLine.Validate("Shortcut Dimension 1 Code", vmtlist.SEGMENT);
                GenJnlLine.Validate("Shortcut Dimension 2 Code", PBCommonSetup."Central Payment Template Name");
                GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyName);
                GenJnlLine.Validate("External Document No.", rec."Source Gl Entry Document No");
                if Rec."Over Receipt Amount" <> 0 then GenJnlLine."CP Over Receipt":=true;
                GenJnlLine."Over Receipt":=Rec."Over Receipt Amount";
                GenJnlLine."Bank Charges":=Rec."Bank Charges";
                GenJnlLine."CP External Document No":=rec."Invoice External No.";
                GenJnlLine."IMOS Transaction No":=rec."IMOS Transaction No";
                GenJnlLine."IMOS Bank ID":=Rec."Bank ID";
                GenJnlLine."Central Payment Entry No":=Rec."Entry No.";
                GenJnlLine."Central Pay. Parent Entry No":=rec."Parent Entry No.";
                GenJnlLine."Bank Document No.":=rec."Bank Document No.";
                //GenJnlLine.Validate("Applies-to Doc. Type", GenJnlLine."Applies-to Doc. Type"::Invoice);
                GenJnlLine.Validate("Applies-to Doc. No.", rec."Applied Document No.");
                GenJnlLine.Insert(true);
                //Bank Charge
                if rec."Bank Charges" <> 0 then begin
                    LineNo:=LineNo + 10000;
                    GenJnlLine.Init();
                    GenJnlLine."Journal Template Name":=PBCommonSetup."Central Payment Template Name";
                    GenJnlLine."Journal Batch Name":=PBCommonSetup."Central Payment Batch Name";
                    if rec."Entry Type" <> rec."Entry Type"::Customer then begin
                        if Rec.Amount < 0 then GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment)
                        else
                            GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Refund);
                    end
                    else
                    begin
                        if Rec.Amount > 0 then GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment)
                        else
                            GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Refund);
                    end;
                    GenJnlLine.Validate("Document No.", Format(Rec."Entry No."));
                    GenJnlLine."Line No.":=LineNo;
                    GenJnlLine.Validate("Posting Date", Rec."Posting Date");
                    GenJnlLine.Validate("Document Date", rec."Document Date");
                    GenJnlLine.Validate("Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                    GenJnlLine.Validate("Account No.", IMOSSetup."Bank Charge GL Code");
                    GenJnlLine.Validate("Currency Code", rec."Currency Code");
                    GenJnlLine.Validate(Amount, (1 * (rec."Bank Charges")));
                    if rec."Exchange Rate" <> 0 then GenJnLLine.Validate("Currency Factor", rec."Exchange Rate");
                    if VMTList."Use FD1 Mapping" then GenJnlLine.Validate("Shortcut Dimension 1 Code", rec.FD1)
                    else
                        GenJnlLine.Validate("Shortcut Dimension 1 Code", vmtlist.SEGMENT);
                    GenJnlLine.Validate("Shortcut Dimension 2 Code", PBCommonSetup."Central Payment Template Name");
                    GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyName);
                    GenJnlLine.Validate("Shortcut Dimension 3 Code", Rec.FD3);
                    GenJnLLine.Validate("Shortcut Dimension 4 Code", Rec.FD4);
                    GenJnlLine.Validate("Shortcut Dimension 5 Code", Rec.FD5);
                    GenJnlLine.Validate("Shortcut Dimension 10 Code", Rec.FD10);
                    GenJnlLine.Validate("External Document No.", rec."Source Gl Entry Document No");
                    if Rec."Over Receipt Amount" <> 0 then GenJnlLine."CP Over Receipt":=true;
                    GenJnlLine."Over Receipt":=Rec."Over Receipt Amount";
                    GenJnlLine."Bank Charges":=Rec."Bank Charges";
                    GenJnlLine."CP External Document No":=rec."Invoice External No.";
                    GenJnlLine."IMOS Transaction No":=rec."IMOS Transaction No";
                    GenJnlLine."IMOS Bank ID":=Rec."Bank ID";
                    GenJnlLine."Central Payment Entry No":=Rec."Entry No.";
                    GenJnlLine."Central Pay. Parent Entry No":=rec."Parent Entry No.";
                    GenJnlLine."Bank Document No.":=rec."Bank Document No.";
                    //GenJnlLine.Validate("Applies-to Doc. Type", GenJnlLine."Applies-to Doc. Type"::Invoice);
                    GenJnlLine.Insert(true);
                end;
                GenJnlLine.Reset();
                GenJnlLine.setrange("Journal Template Name", PBCommonSetup."Central Payment Template Name");
                GenJnlLine.setrange("Journal Batch Name", PBCommonSetup."Central Payment Batch Name");
                GenJnlLine.SetRange("Document No.", Format(Rec."Entry No."));
                GenJnlLine.FindSet();
                Clear(CU50190);
                CU50190.Run(GenJnlLine);
            end;
            exit;
        end;
        if(Rec."Posted in Source Company" = false) and (rec."Source Company" = CompanyName)then begin
            CurrentaccountNo:='';
            ICCurrentAccountNo:='';
            CompanyMapping.get(CompanyName);
            CompanyMapping.TestField("Current Account No.");
            CurrentaccountNo:=CompanyMapping."Current Account No.";
            GenTemp.get(PBCommonSetup."Central Payment Template Name");
            VMTList.Reset();
            VMTList.SetRange(DBASE, CompanyMapping."PB Company Code");
            VMTList.FindSet();
            CompanyMapping.Reset();
            CompanyMapping.SetRange("BC Company Name", rec."Target Company");
            CompanyMapping.FindSet();
            CompanyMapping.TestField("Current Account No.");
            ICCurrentAccountNo:=CompanyMapping."Current Account No.";
            if rec."Entry Type" = rec."Entry Type"::Vendor then begin
                VendLedgEntry.Reset();
                if rec."No." <> '' then VendLedgEntry.SetRange("Vendor No.", Rec."No.");
                VendLedgEntry.SetRange("Document No.", rec."Source Gl Entry Document No");
                VendLedgEntry.FindSet();
                IsEntryOpen:=VendLedgEntry.Open;
            end
            else if rec."Entry Type" = rec."Entry Type"::Employee then begin
                    EmpLedgerEntry.Reset();
                    if rec."No." <> '' then EmpLedgerEntry.SetRange("Employee No.", Rec."No.");
                    EmpLedgerEntry.SetRange("Document No.", rec."Source Gl Entry Document No");
                    EmpLedgerEntry.FindSet();
                    IsEntryOpen:=EmpLedgerEntry.Open;
                end
                else if rec."Entry Type" = rec."Entry Type"::Customer then begin
                        CustLedgEntry.Reset();
                        if rec."No." <> '' then CustLedgEntry.SetRange("Customer No.", Rec."No.");
                        CustLedgEntry.SetRange("Document No.", rec."Source Gl Entry Document No");
                        CustLedgEntry.FindSet();
                        IsEntryOpen:=CustLedgEntry.Open;
                    end;
            GenJnlLine.Reset();
            GenJnlLine.setrange("Journal Template Name", PBCommonSetup."Central Payment Template Name");
            GenJnlLine.setrange("Journal Batch Name", PBCommonSetup."Central Payment Batch Name");
            if GenJnlLine.FindLast()then GenJnlLine.DeleteAll(true);
            LineNo:=0;
            LineNo:=LineNo + 10000;
            GenJnlLine.Init();
            GenJnlLine."Journal Template Name":=PBCommonSetup."Central Payment Template Name";
            GenJnlLine."Journal Batch Name":=PBCommonSetup."Central Payment Batch Name";
            /*
                        if rec."Entry Type" <> rec."Entry Type"::Customer then begin
                            if Rec.Amount < 0 then
                                GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment)
                            else
                                GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Refund);

                        end else begin
                            if Rec.Amount > 0 then
                                GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment)
                            else
                                GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Refund);

                        end;
            */
            GenJnlLine.Validate("Document No.", format(rec."Entry No."));
            GenJnlLine."Line No.":=LineNo;
            GenJnlLine.Validate("Posting Date", Rec."Posting Date");
            GenJnlLine.Validate("Document Date", rec."Document Date");
            GenJnlLine.validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.Validate("Account No.", ICCurrentAccountNo);
            if rec."Entry Type" = rec."Entry Type"::Vendor then begin
                GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::Vendor);
                GenJnlLine.Validate("Bal. Account No.", VendLedgEntry."Vendor No.");
            end
            else if rec."Entry Type" = rec."Entry Type"::Employee then begin
                    GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::Employee);
                    GenJnlLine.Validate("Bal. Account No.", EmpLedgerEntry."Employee No.");
                end
                else if rec."Entry Type" = rec."Entry Type"::Customer then begin
                        GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::Customer);
                        GenJnlLine.Validate("Bal. Account No.", CustLedgEntry."Customer No.");
                    end;
            GenJnlLine.Validate("Currency Code", rec."Currency Code");
            GenJnlLine.Validate(Amount, (-1 * (rec."Document Amount" + rec."Document Over Receipt Amount")));
            if rec."Exchange Rate" <> 0 then GenJnLLine.Validate("Currency Factor", rec."Exchange Rate");
            if VMTList."Use FD1 Mapping" then GenJnlLine.Validate("Shortcut Dimension 1 Code", rec.FD1)
            else
                GenJnlLine.Validate("Shortcut Dimension 1 Code", vmtlist.SEGMENT);
            //GenJnlLine.Validate("Shortcut Dimension 1 Code", vmtlist.SEGMENT);
            GenJnlLine.Validate("Shortcut Dimension 2 Code", PBCommonSetup."Central Payment Template Name");
            GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyName);
            GenJnlLine.Validate("External Document No.", rec."Source Gl Entry Document No");
            GenJnlLine."CP External Document No":=rec."Invoice External No.";
            GenJnlLine."Bank Document No.":=rec."Bank Document No.";
            //GenJnlLine.Validate("Shortcut Dimension 9 Code", DNVSetup."Invoice Countrt Party Type"); // take fro msetup
            //GenJnlLine.Validate("Shortcut Dimension 10 Code", VMTShipCode.VESSELCODE);
            //GenJnlLine."Ship Manager Id" := rec."Ship Manager";
            GenJnlLine."Central Payment Entry No":=Rec."Entry No.";
            GenJnlLine."IMOS Transaction No":=rec."IMOS Transaction No";
            //GenJnlLine."Original Invoice No" := rec."Original Invoice No";
            //GenJnlLine."External Document No." := rec.Code;
            //GenJnlLine.Description := format(VMTShipCode.SHIPSIGN) + GlDescription;
            //if InvoiceAmount < 0 then
            //  GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo"
            //else
            //  GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice;
            if IsEntryOpen then begin
                if Rec."Entry Type" = rec."Entry Type"::Vendor then GenJnlLine.Validate("Applies-to Doc. Type", VendLedgEntry."Document Type")
                else if Rec."Entry Type" = Rec."Entry Type"::Employee then GenJnlLine.Validate("Applies-to Doc. Type", EmpLedgerEntry."Document Type")
                    else if Rec."Entry Type" = Rec."Entry Type"::Customer then GenJnlLine.Validate("Applies-to Doc. Type", CustLedgEntry."Document Type");
                GenJnlLine.Validate("Applies-to Doc. No.", rec."Source Gl Entry Document No");
            end
            else
                GenJnlLine."Manual Application Needed":=true;
            GenJnlLine.Insert(true);
            Clear(CU50190);
            CU50190.Run(GenJnlLine);
        //rec."Source Processed Document No." := GenJnlLine."Document No.";
        //rec.Modify();
        end;
        //target company
        if(Rec."Posted in Target Company" = false) and (rec."Target Company" = CompanyName)then begin
            CurrentaccountNo:='';
            ICCurrentAccountNo:='';
            CompanyMapping.get(CompanyName);
            CompanyMapping.TestField("Current Account No.");
            CurrentaccountNo:=CompanyMapping."Current Account No.";
            GenTemp.get(PBCommonSetup."Central Payment Template Name");
            VMTList.Reset();
            VMTList.SetRange(DBASE, CompanyMapping."PB Company Code");
            VMTList.FindSet();
            CompanyMapping.Reset();
            CompanyMapping.SetRange("BC Company Name", rec."Source Company");
            CompanyMapping.FindSet();
            CompanyMapping.TestField("Current Account No.");
            ICCurrentAccountNo:=CompanyMapping."Current Account No.";
            GenTemp.get(PBCommonSetup."Central Payment Template Name");
            if rec."Entry Type" = rec."Entry Type"::Vendor then begin
                VendLedgEntry.Reset();
                if Rec."No." <> '' then VendLedgEntry.SetRange("Vendor No.", Rec."No.");
                VendLedgEntry.SetRange("Document No.", rec."Applied Document No.");
                VendLedgEntry.FindSet();
                VendLedgEntry."Applies-to ID":='';
                VendLedgEntry.Modify();
            end
            else if rec."Entry Type" = rec."Entry Type"::Employee then begin
                    EmpLedgerEntry.Reset();
                    //EmpLedgerEntry.ChangeCompany(rec."Target Company");
                    if rec."No." <> '' then EmpLedgerEntry.setrange("Employee No.", Rec."No.");
                    EmpLedgerEntry.SetRange("Document No.", rec."Applied Document No.");
                    EmpLedgerEntry.FindSet();
                    EmpLedgerEntry."Applies-to ID":='';
                    EmpLedgerEntry.Modify();
                end
                else if rec."Entry Type" = rec."Entry Type"::Customer then begin
                        CustLedgEntry.Reset();
                        if Rec."No." <> '' then CustLedgEntry.SetRange("Customer No.", Rec."No.");
                        CustLedgEntry.SetRange("Document No.", rec."Applied Document No.");
                        CustLedgEntry.FindSet();
                        CustLedgEntry."Applies-to ID":='';
                        CustLedgEntry.Modify();
                    end;
            GenJnlLine.Reset();
            GenJnlLine.setrange("Journal Template Name", PBCommonSetup."Central Payment Template Name");
            GenJnlLine.setrange("Journal Batch Name", PBCommonSetup."Central Payment Batch Name");
            if GenJnlLine.FindLast()then GenJnlLine.DeleteAll(true);
            LineNo:=0;
            LineNo:=LineNo + 10000;
            GenJnlLine.Init();
            GenJnlLine."Journal Template Name":=PBCommonSetup."Central Payment Template Name";
            GenJnlLine."Journal Batch Name":=PBCommonSetup."Central Payment Batch Name";
            if rec."Entry Type" <> rec."Entry Type"::Customer then begin
                if Rec.Amount < 0 then GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment)
                else
                    GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Refund);
            end
            else
            begin
                if Rec.Amount > 0 then GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment)
                else
                    GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Refund);
            end;
            GenJnlLine.Validate("Document No.", Format(Rec."Entry No."));
            GenJnlLine."Line No.":=LineNo;
            GenJnlLine.Validate("Posting Date", Rec."Posting Date");
            GenJnlLine.Validate("Document Date", rec."Document Date");
            if rec."Entry Type" = rec."Entry Type"::Vendor then begin
                GenJnlLine.validate("Account Type", GenJnlLine."Account Type"::Vendor);
                GenJnlLine.Validate("Account No.", VendLedgEntry."Vendor No.");
            end
            else if rec."Entry Type" = rec."Entry Type"::Employee then begin
                    GenJnlLine.validate("Account Type", GenJnlLine."Account Type"::Employee);
                    GenJnlLine.Validate("Account No.", EmpLedgerEntry."Employee No.");
                end
                else if rec."Entry Type" = rec."Entry Type"::Customer then begin
                        GenJnlLine.validate("Account Type", GenJnlLine."Account Type"::Customer);
                        GenJnlLine.Validate("Account No.", CustLedgEntry."Customer No.");
                    end;
            GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
            GenJnlLine.Validate("Bal. Account No.", ICCurrentAccountNo);
            GenJnlLine.Validate("Currency Code", rec."Currency Code");
            GenJnlLine.Validate(Amount, (-1 * (rec.Amount + rec."Over Receipt Amount")));
            if rec."Exchange Rate" <> 0 then GenJnLLine.Validate("Currency Factor", rec."Exchange Rate");
            if VMTList."Use FD1 Mapping" then GenJnlLine.Validate("Shortcut Dimension 1 Code", rec.FD1)
            else
                GenJnlLine.Validate("Shortcut Dimension 1 Code", vmtlist.SEGMENT);
            GenJnlLine.Validate("Shortcut Dimension 2 Code", PBCommonSetup."Central Payment Template Name");
            GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyName);
            GenJnlLine.Validate("External Document No.", rec."Source Gl Entry Document No");
            if Rec."Over Receipt Amount" <> 0 then GenJnlLine."CP Over Receipt":=true;
            GenJnlLine."Over Receipt":=Rec."Over Receipt Amount";
            GenJnlLine."Bank Charges":=Rec."Bank Charges";
            GenJnlLine."CP External Document No":=rec."Invoice External No.";
            GenJnlLine."IMOS Transaction No":=rec."IMOS Transaction No";
            GenJnlLine."IMOS Bank ID":=Rec."Bank ID";
            GenJnlLine."Central Payment Entry No":=Rec."Entry No.";
            GenJnlLine."Bank Document No.":=rec."Bank Document No.";
            //GenJnlLine.Validate("Applies-to Doc. Type", GenJnlLine."Applies-to Doc. Type"::Invoice);
            if Rec."Entry Type" = rec."Entry Type"::Vendor then GenJnlLine.Validate("Applies-to Doc. Type", VendLedgEntry."Document Type")
            else if Rec."Entry Type" = Rec."Entry Type"::Employee then GenJnlLine.Validate("Applies-to Doc. Type", EmpLedgerEntry."Document Type")
                else if Rec."Entry Type" = Rec."Entry Type"::Customer then GenJnlLine.Validate("Applies-to Doc. Type", CustLedgEntry."Document Type");
            GenJnlLine.Validate("Applies-to Doc. No.", rec."Applied Document No.");
            GenJnlLine.Insert(true);
            Clear(CU50190);
            CU50190.Run(GenJnlLine);
        end;
    end;
}
