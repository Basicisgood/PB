codeunit 50310 ConCurFinExpensePostNew
{
    TableNo = "Concur Staging Buffer";

    trigger OnRun()
    begin
        ProcessConcurBuffer(rec);
    end;
    procedure ProcessConcurBuffer(var P_ConcurBuffer: Record "Concur Staging Buffer" temporary)
    var
        InboundFinExpen: Record "Concur inbound financial Expen";
        L_TaxAmt: Decimal;
        L_LCYAmt: Decimal;
        L_BalAmt: Decimal;
    begin
        NewDocNo:='';
        TempGJL.deleteAll;
        ConcurSetup.Get();
        CompanyNameMapping.Get(CompanyName);
        ConcurSetup.TestField("Cash Advance Return G/L Acc"); //Added on 30 April25
        ConcurSetup.TestField("Default Concur Dimension");
        if P_ConcurBuffer."Is Ship Run" then begin
            ConcurSetup.TestField("DOC Cash FD9");
            ConcurSetup.TestField("DOC Non Cash FD9");
        end;
        GenJnlline_g.Reset();
        GenJnlline_g.SetRange("Journal Template Name", ConcurSetup."Concur Template Name");
        GenJnlline_g.SetRange("Journal Batch Name", ConcurSetup."Concur Batch Name");
        IF GenJnlline_g.FindLast()then lastLineNo:=GenJnlline_g."Line No."
        Else
            lastLineNo:=0;
        GenJnlline_g.Reset();
        GenJnlline_g.SetRange("Journal Template Name", ConcurSetup."CL Concur Template Name");
        GenJnlline_g.SetRange("Journal Batch Name", ConcurSetup."CL Concur Batch Name");
        IF GenJnlline_g.FindLast()then CLLastLineNo:=GenJnlline_g."Line No."
        Else
            CLLastLineNo:=0;
        IF P_ConcurBuffer.FindFirst()then begin
            repeat NeedReverseEntry:=false; //30April
                ReverseAmt:=0; //30 April
                P_ConcurBuffer.TestField("Payment Type");
                InboundFinExpen.reset;
                IF P_ConcurBuffer."Is Ship Run" then InboundFinExpen.SetRange(Shipsign, P_ConcurBuffer."Company Code")
                else
                    InboundFinExpen.SetRange("Employee Org Unit 3", P_ConcurBuffer."Company Code");
                InboundFinExpen.SetRange("Report ID", P_ConcurBuffer."Report ID");
                InboundFinExpen.SetRange("Report Key", P_ConcurBuffer."External Doc No.");
                InboundFinExpen.SetRange("Payment Type", P_ConcurBuffer."Payment Type");
                // InboundFinExpen.Setfilter("Journal Key", '<>%1', '16600000');  //Commented on 30 April25
                IF InboundFinExpen.FindFirst()then begin
                    L_LCYAmt:=0;
                    L_BalAmt:=0;
                    repeat NeedReverseEntry:=false;
                        IF NOT((Uppercase(InboundFinExpen."Payment Type") = 'CASH') AND (InboundFinExpen."Journal Key" = '16900000'))then begin
                            IF P_ConcurBuffer."Cash Ledger" then CreateGenJournal_CashLedg(InboundFinExpen, P_ConcurBuffer, L_BalAmt, L_LCYAmt)
                            else
                                CreateGenJournal(InboundFinExpen, P_ConcurBuffer, L_BalAmt, L_LCYAmt);
                            L_TaxAmt:=0;
                            //Evaluate(L_TaxAmt, InboundFinExpen."Journal Tax Amount");
                            IF NOT P_ConcurBuffer."Is Ship Run" then L_TaxAmt:=InboundFinExpen."Calculated Tax Amount";
                            IF(L_TaxAmt <> 0)then CreateTaxLine(P_ConcurBuffer, L_TaxAmt, InboundFinExpen, TempGJL."Dimension Set ID", TempGJL.Description, TempGJL."External Document No.", L_BalAmt, L_LCYAmt);
                            IF NeedReverseEntry then CreateReverseAdvance(P_ConcurBuffer, ReverseAmt, P_ConcurBuffer."Emp Code", TempGJL."Dimension Set ID", ReverseDescription);
                        end;
                    until InboundFinExpen.Next() = 0;
                    //CreateBalAccountLine(P_ConcurBuffer, P_ConcurBuffer."Emp Amount", P_ConcurBuffer."Emp Code", P_ConcurBuffer."Payment Type", TempGJL."Dimension Set ID", L_LCYAmt);
                    CreateBalAccountLine(P_ConcurBuffer, L_BalAmt, P_ConcurBuffer."Emp Code", P_ConcurBuffer."Payment Type", TempGJL."Dimension Set ID", L_LCYAmt);
                //IF NeedReverseEntry then begin
                //    CreateReverseAdvance(P_ConcurBuffer, ReverseAmt, P_ConcurBuffer."Emp Code", TempGJL."Dimension Set ID", ReverseDescription);
                //end;
                END
                else
                    Error('Detail not found');
            until P_ConcurBuffer.Next() = 0;
        end
        else
            Error('Details not found');
        NewDocNo:='';
        IF TempGJL.FindFirst()then begin
            //PB-2026010205] [URGENT] BC-create wrong document number for Concur VJ 02Jan2026 start
            // IF P_ConcurBuffer."Cash Ledger" then
            //   NewDocNo := NoSeries.GetNextNo(ConcurSetup."CL Concur Gen. Journal No.", today)
            //else
            //  NewDocNo := NoSeries.GetNextNo(ConcurSetup."Concur Gen. Journal No.", today);
            IF P_ConcurBuffer."Cash Ledger" then NewDocNo:=NoSeries.GetNextNo(ConcurSetup."CL Concur Gen. Journal No.", P_ConcurBuffer."Payment Date")
            else
                NewDocNo:=NoSeries.GetNextNo(ConcurSetup."Concur Gen. Journal No.", P_ConcurBuffer."Payment Date");
            //PB-2026010205] [URGENT] BC-create wrong document number for Concur VJ 02Jan2026 end
            repeat GenJnlline_g.TransferFields(TempGJL);
                GenJnlline_g."Document No.":=NewDocNo;
                GenJnlline_g.insert(True);
            until TempGJL.Next() = 0;
        end;
    end;
    procedure GetDocNo(): Code[20]begin
        exit(NewDocNo);
    end;
    procedure CreateGenJournal(var P_ConcurInboundFin: Record "Concur inbound financial Expen"; var P_ConcurBuffer: Record "Concur Staging Buffer"; var P_BalAmt: Decimal; var P_BalLCYAmt: Decimal)
    begin
        TempGJL.Init();
        TempGJL."Journal Template Name":=ConcurSetup."Concur Template Name";
        TempGJL."Journal Batch Name":=ConcurSetup."Concur Batch Name";
        lastLineNo:=lastLineNo + 10000;
        TempGJL."Line No.":=lastLineNo;
        //TempGJL."Document Type" := TempGJL."Document Type"::Invoice;
        TempGJL.Validate("Document No.", 'xyz');
        TempGJL."Posting Date":=P_ConcurBuffer."Payment Date";
        TempGJL."External Document No.":=P_ConcurBuffer."External Doc No.";
        TempGJL."Concur ID":=P_ConcurInboundFin."Concur ID";
        TempGJL."Report ID":=P_ConcurBuffer."Report ID";
        TempGJL."Entry Id":=P_ConcurInboundFin."Entry Id";
        TempGJL."Receipt image ID":=P_ConcurInboundFin."Receipt Received";
        TempGJL."Original Ex Doc No.":=P_ConcurBuffer."External Doc No."; //Added on 280525
        IF P_ConcurBuffer."Is Ship Run" then begin
            TempGJL."Account Type":=TempGJL."Account Type"::"G/L Account";
            TempGJL.Validate("Account No.", P_ConcurInboundFin."Entry Custom 2(DOC Code)");
        end
        else
        begin
            IF(P_ConcurInboundFin.Shipsign <> '') AND (P_ConcurInboundFin.Shipsign <> 'NA') AND (P_ConcurInboundFin.Shipsign <> 'Not Applicable') AND (NOT P_ConcurBuffer."Is Ship Run") AND (P_ConcurInboundFin."Entry Custom 2(DOC Code)" <> 'NA')then begin
                //TEC.VJ 30Oct2025 << Comment for Company Code Prefix
                // CompanyMapping.get(ConcurSetup."Company Code Prefix" + P_ConcurInboundFin.Shipsign);
                // CompanyMapping.TestField("Current Account No.");
                // TempGJL."Account Type" := TempGJL."Account Type"::"G/L Account";
                // TempGJL.Validate("Account No.", CompanyMapping."Current Account No.");
                //TEC.VJ 30Oct2025 >> Comment for Company Code Prefix
                //TEC.VJ 30Oct2025 <<
                CompanyMapping.get(CompanyNameMapping.GetBCCompCode(P_ConcurInboundFin.Shipsign));
                CompanyMapping.TestField("Current Account No.");
                TempGJL."Account Type":=TempGJL."Account Type"::"G/L Account";
                TempGJL.Validate("Account No.", CompanyMapping."Current Account No.");
            //TEC.VJ 30Oct2025 >>
            end
            else
            begin
                IF P_ConcurInboundFin."Journal Key" = '16900000' then begin
                    TempGJL."Account Type":=TempGJL."Account Type"::Employee;
                    TempGJL.Validate("Account No.", P_ConcurInboundFin."EMP ID");
                end
                else
                begin
                    TempGJL."Account Type":=TempGJL."Account Type"::"G/L Account";
                    TempGJL.Validate("Account No.", P_ConcurInboundFin."Journal Key");
                end;
            end;
        end;
        IF P_ConcurBuffer."Is Ship Run" then TempGJL.Description:=GetDescription(P_ConcurInboundFin) //description
        else
            TempGJL.Description:=P_ConcurInboundFin."Entry Description"; // Changed on 18 July25
        //Evaluate(TempGJL.Amount, P_ConcurInboundFin."Journal Net Amount");
        Evaluate(TempGJL.Amount, P_ConcurInboundFin."Net Tax Amount"); //Sgarg- New change - 11feb25
        TempGJL.Validate(Amount);
        TempGJL.Validate("Currency Code", P_ConcurBuffer."Report Currency");
        IF TempGJL."Account No." = ConcurSetup."Cash Advance Return G/L Acc" then begin
            NeedReverseEntry:=true;
            ReverseAmt:=TempGJL.Amount;
            ReverseDescription:=P_ConcurInboundFin."Entry Description";
        end;
        VMT.Reset();
        VMT.SetRange(DBASE, CompanyName);
        if VMT.FindFirst()then TempGJL.Validate("Shortcut Dimension 1 Code", VMT.SEGMENT);
        TempGJL.Validate("Shortcut Dimension 2 Code", ConcurSetup."Default Concur Dimension");
        TempGJL.Validate("Shortcut Dimension 5 Code", P_ConcurInboundFin."New FD5");
        TempGJL.Validate("Shortcut Dimension 6 Code", P_ConcurInboundFin."EMP ID");
        TempGJL.Validate("Shortcut Dimension 8 Code", CompanyName);
        //IF UpperCase(P_ConcurBuffer."Payment Type") <> 'CASH' then
        //    TempGJL.Validate("Shortcut Dimension 9 Code", 'CARD');
        if P_ConcurBuffer."Is Ship Run" then begin
            if uppercase(P_ConcurInboundFin."Payment Type") = 'CASH' then TempGJL.Validate("Shortcut Dimension 9 Code", ConcurSetup."DOC Cash FD9")
            else
                TempGJL.Validate("Shortcut Dimension 9 Code", ConcurSetup."DOC Non Cash FD9");
        end;
        if(((P_ConcurInboundFin.Shipsign <> 'NA') and (P_ConcurInboundFin.Shipsign <> 'Not Applicable') and (P_ConcurInboundFin.Shipsign <> '')) or ((P_ConcurInboundFin."Entry Custom 2(DOC Code)" <> 'NA') and (P_ConcurInboundFin."Entry Custom 2(DOC Code)" <> 'Not Applicable') and (P_ConcurInboundFin."Entry Custom 2(DOC Code)" <> '')))then begin
            VMT.Reset();
            VMT.Setfilter(DBASE, CompanyName);
            if VMT.FindFirst()then TempGJL.Validate("Shortcut Dimension 10 Code", VMT.VESSELCODE);
        END;
        TempGJL."PB Concur invoice":=true;
        TempGJL."Is Ship Run":=P_ConcurBuffer."Is Ship Run";
        TempGJL."Fin Company Code":=P_ConcurBuffer."Fin Company Code";
        TempGJL."Ship Company Code":=P_ConcurBuffer."Ship Company Code";
        TempGJL.Insert();
        P_BalAmt+=TempGJL.Amount;
        P_BalLCYAmt+=TempGJL."Amount (LCY)";
    // exit(TempGJL."Amount (LCY)");
    end;
    procedure CreateTaxLine(var P_ConCurBuffer: Record "Concur Staging Buffer"; P_TaxAmt: Decimal; var P_Detail: Record "Concur inbound financial Expen"; P_DimsetId: Integer; P_Desc: Text; P_extDocNo: code[20]; var P_BalAmt: Decimal; var P_BalLCYAmt: Decimal)
    var
        ConCurVatSetup: Record "Concur VAT Setup";
    begin
        TempGJL.Init();
        IF P_ConCurBuffer."Cash Ledger" then begin
            TempGJL."Journal Template Name":=ConcurSetup."CL Concur Template Name";
            TempGJL."Journal Batch Name":=ConcurSetup."CL Concur Batch Name";
            CLLastLineNo:=CLLastLineNo + 10000;
            TempGJL."Line No.":=CLLastLineNo;
        end
        else
        begin
            TempGJL."Journal Template Name":=ConcurSetup."Concur Template Name";
            TempGJL."Journal Batch Name":=ConcurSetup."Concur Batch Name";
            lastLineNo:=lastLineNo + 10000;
            TempGJL."Line No.":=lastLineNo;
        end;
        if P_ConCurBuffer."Cash Ledger" then begin
            DateTimeValue:=0DT;
            evaluate(DateTimeValue, P_detail."Entry Date");
            if Date2DMY(DT2Date(DateTimeValue), 2) < Date2DMY(dt2date(P_detail.SystemCreatedAt), 2)then begin
                TempGJL."Document Date":=DT2Date(DateTimeValue);
                TempGJL."Posting Date":=CalcDate('-CM', DT2Date(P_Detail.SystemCreatedAt));
            end
            else
            begin
                TempGJL."Posting Date":=DT2Date(DateTimeValue);
                TempGJL."document Date":=DT2Date(DateTimeValue);
            end;
        end
        else
            TempGJL."Posting Date":=P_ConcurBuffer."Payment Date";
        //TempGJL."Document Type" := TempGJL."Document Type"::Invoice;
        TempGJL.Validate("Document No.", 'xyz');
        TempGJL."External Document No.":=P_extDocNo;
        TempGJL."Original Ex Doc No.":=P_ConcurBuffer."External Doc No."; //Added on 280525
        TempGJL."Concur ID":=P_ConCurBuffer."Concur ID";
        TempGJL."Account Type":=TempGJL."Account Type"::"G/L Account";
        TempGJL.Description:=P_Desc;
        ConCurVatSetup.reset;
        // ConCurVatSetup.SetRange("BC Company", ConcurSetup."Company Code Prefix" + P_ConCurBuffer."Company Code");//TEC.VJ 30Oct2025 << Comment for Company Code Prefix
        //TEC.VJ 30Oct2025 <<
        ConCurVatSetup.SetRange("BC Company", CompanyMapping.GetBCCompCode(P_ConCurBuffer."Company Code"));
        //TEC.VJ 30Oct2025 >>
        //ConCurVatSetup.SetRange("Tax Code", P_Detail."Tax label");
        ConCurVatSetup.FindFirst();
        TempGJL.Validate("Account No.", ConCurVatSetup."Ledger Account");
        //TempGJL."Tax Code" := P_Detail."Tax label";
        TempGJL.Validate("Currency Code", P_ConcurBuffer."Report Currency");
        TempGJL."Tax Code":=ConCurVatSetup."Tax Code";
        TempGJL.validate(Amount, P_TaxAmt);
        TempGJL."Report ID":=P_ConcurBuffer."Report ID";
        TempGJL."Receipt image ID":=P_Detail."Receipt Received";
        TempGJL."Entry Id":=P_Detail."Entry Id";
        TempGJL."Dimension Set ID":=P_DimSetId;
        IF P_ConCurBuffer."Cash Ledger" then TempGJL.Validate("Shortcut Dimension 2 Code", ConcurSetup."CL Default Concur Dim.")
        Else
            TempGJL.Validate("Shortcut Dimension 2 Code", ConcurSetup."Default Concur Dimension");
        if P_ConcurBuffer."Is Ship Run" then begin
            if uppercase(P_Detail."Payment Type") = 'CASH' then TempGJL.Validate("Shortcut Dimension 9 Code", ConcurSetup."DOC Cash FD9")
            else
                TempGJL.Validate("Shortcut Dimension 9 Code", ConcurSetup."DOC Non Cash FD9");
        end;
        TempGJL."Is Ship Run":=P_ConcurBuffer."Is Ship Run";
        TempGJL."Fin Company Code":=P_ConcurBuffer."Fin Company Code";
        TempGJL."Ship Company Code":=P_ConcurBuffer."Ship Company Code";
        TempGJL.Insert;
        P_BalAmt+=TempGJL.Amount;
        P_BalLCYAmt+=TempGJL."Amount (LCY)";
    // exit(TempGJL."Amount (LCY)");
    end;
    procedure CreateBalAccountLine(var P_ConCurBuffer: Record "Concur Staging Buffer"; P_BalAmt: Decimal; P_AccCode: code[20]; P_PaymentType: Text; P_DimsetId: Integer; P_AmtLCY: Decimal)
    var
        BankAccMapping: Record "Concur Bank Acc Setup";
        L_Detail: Record "Concur inbound financial Expen";
    begin
        TempGJL.Init();
        IF P_ConCurBuffer."Cash Ledger" then begin
            TempGJL."Journal Template Name":=ConcurSetup."CL Concur Template Name";
            TempGJL."Journal Batch Name":=ConcurSetup."CL Concur Batch Name";
            CLLastLineNo:=CLLastLineNo + 10000;
            TempGJL."Line No.":=CLLastLineNo;
        end
        else
        begin
            TempGJL."Journal Template Name":=ConcurSetup."Concur Template Name";
            TempGJL."Journal Batch Name":=ConcurSetup."Concur Batch Name";
            lastLineNo:=lastLineNo + 10000;
            TempGJL."Line No.":=lastLineNo;
        end;
        L_Detail.reset;
        L_Detail.SetRange("Report ID", P_ConCurBuffer."Report ID");
        L_Detail.SetRange("Report Key", P_ConCurBuffer."External Doc No.");
        IF L_Detail.FindFirst()then;
        if P_ConCurBuffer."Cash Ledger" then begin
            DateTimeValue:=0DT;
            evaluate(DateTimeValue, L_Detail."Entry Date");
            if Date2DMY(DT2Date(DateTimeValue), 2) < Date2DMY(dt2date(L_Detail.SystemCreatedAt), 2)then begin
                TempGJL."Document Date":=DT2Date(DateTimeValue);
                TempGJL."Posting Date":=CalcDate('-CM', DT2Date(L_Detail.SystemCreatedAt));
            end
            else
            begin
                TempGJL."Posting Date":=DT2Date(DateTimeValue);
                TempGJL."document Date":=DT2Date(DateTimeValue);
            end;
        end
        else
            TempGJL."Posting Date":=P_ConcurBuffer."Payment Date";
        TempGJL."External Document No.":=P_ConCurBuffer."External Doc No.";
        //TempGJL."Document Type" := TempGJL."Document Type"::Invoice;
        TempGJL.Validate("Document No.", 'xyz');
        TempGJL.Validate("Currency Code", P_ConcurBuffer."Report Currency");
        IF P_ConCurBuffer."Cash Ledger" then begin
            L_Detail.TestField("Report Name");
            L_Detail.TestField("Report Org Unit 3");
            TempGJL."Account Type":=TempGJL."Account Type"::"Bank Account";
            BankAccMapping.reset;
            // BankAccMapping.SetRange("BC Company", ConcurSetup."Company Code Prefix" + L_Detail."Report Org Unit 3");//TEC.VJ 30Oct2025 << Comment for Company Code Prefix
            //TEC.VJ 30Oct2025 <<
            BankAccMapping.SetRange("BC Company", CompanyMapping.GetBCCompCode(L_Detail."Report Org Unit 3"));
            //TEC.VJ 30Oct2025 >>
            BankAccMapping.SetRange("Report Name", CopyStr(L_Detail."Report Name", StrLen(L_Detail."Report Name") - 2));
            BankAccMapping.SetRange("Cash Advance Bank Account", false); //Sgarg-Add- 11mar25
            if BankAccMapping.FindFirst()then TempGJL.Validate("Account No.", BankAccMapping."Bank Account")
            else
            begin
                BankAccMapping.reset;
                // BankAccMapping.SetRange("BC Company", ConcurSetup."Company Code Prefix" + L_Detail."Report Org Unit 3");//TEC.VJ 30Oct2025 << Comment for Company Code Prefix
                //TEC.VJ 30Oct2025 <<
                BankAccMapping.SetRange("BC Company", CompanyMapping.GetBCCompCode(L_Detail."Report Org Unit 3"));
                //TEC.VJ 30Oct2025 >>
                BankAccMapping.SetRange("Report Name", CopyStr(L_Detail."Report Name", StrLen(L_Detail."Report Name") - 3));
                BankAccMapping.SetRange("Cash Advance Bank Account", false); //Sgarg-Add- 11mar25
                if BankAccMapping.FindFirst()then TempGJL.Validate("Account No.", BankAccMapping."Bank Account")
                else
                begin
                    BankAccMapping.reset;
                    // BankAccMapping.SetRange("BC Company", ConcurSetup."Company Code Prefix" + L_Detail."Report Org Unit 3");//TEC.VJ 30Oct2025 << Comment for Company Code Prefix
                    //TEC.VJ 30Oct2025 <<
                    BankAccMapping.SetRange("BC Company", CompanyMapping.GetBCCompCode(L_Detail."Report Org Unit 3"));
                    //TEC.VJ 30Oct2025 >>
                    BankAccMapping.SetRange("Report Name", '');
                    BankAccMapping.SetRange("Cash Advance Bank Account", false); //Sgarg-Add- 11mar25
                    if BankAccMapping.FindFirst()then TempGJL.Validate("Account No.", BankAccMapping."Bank Account");
                end;
            end;
        end
        else IF P_ConCurBuffer."Is Ship Run" then begin
                L_Detail.TestField("Report Org Unit 3");
                // CompanyMapping.get(ConcurSetup."Company Code Prefix" + L_Detail."Report Org Unit 3");//TEC.VJ 30Oct2025 << Comment for Company Code Prefix
                //TEC.VJ 30Oct2025 <<
                CompanyMapping.get(CompanyNameMapping.GetBCCompCode(L_Detail."Report Org Unit 3"));
                //TEC.VJ 30Oct2025 >>
                CompanyMapping.TestField("Current Account No.");
                TempGJL."Account Type":=TempGJL."Account Type"::"G/L Account";
                //BankAccMapping.reset;
                //BankAccMapping.SetRange("BC Company", ConcurSetup."Company Code Prefix" + L_Detail."Report Org Unit 3");
                //if BankAccMapping.FindFirst() then
                TempGJL.Validate("Account No.", CompanyMapping."Current Account No.");
            end
            else
            begin
                TempGJL."Account Type":=TempGJL."Account Type"::Employee;
                IF UpperCase(P_PaymentType) <> 'CASH' then TempGJL.validate("Account No.", P_AccCode + 'CC')
                else
                    TempGJL.validate("Account No.", P_AccCode);
            end;
        TempGJL.Validate("Currency Code", P_ConcurBuffer."Report Currency");
        TempGJL.Description:=P_ConCurBuffer."External Doc No.";
        TempGJL."Report ID":=P_ConcurBuffer."Report ID";
        TempGJL."Concur ID":=P_ConCurBuffer."Concur ID";
        TempGJL.validate(Amount, (-1) * P_BalAmt);
        TempGJL."Dimension Set ID":=P_DimsetId;
        IF P_ConCurBuffer."Cash Ledger" then TempGJL.Validate("Shortcut Dimension 2 Code", ConcurSetup."CL Default Concur Dim.")
        else
            TempGJL.Validate("Shortcut Dimension 2 Code", ConcurSetup."Default Concur Dimension");
        if P_ConcurBuffer."Is Ship Run" then begin
            if uppercase(L_Detail."Payment Type") = 'CASH' then TempGJL.Validate("Shortcut Dimension 9 Code", ConcurSetup."DOC Cash FD9")
            else
                TempGJL.Validate("Shortcut Dimension 9 Code", ConcurSetup."DOC Non Cash FD9");
        end;
        TempGJL.Validate("Amount (LCY)", (-1) * P_AmtLCY);
        TempGJL."Is Ship Run":=P_ConcurBuffer."Is Ship Run";
        TempGJL."Fin Company Code":=P_ConcurBuffer."Fin Company Code";
        TempGJL."Ship Company Code":=P_ConcurBuffer."Ship Company Code";
        TempGJL."Original Ex Doc No.":=P_ConcurBuffer."External Doc No."; //Added on 280525
        TempGJL.Insert;
    end;
    procedure GetDescription(var P_InboundDetail: Record "Concur inbound financial Expen"): Text var
        entrydate: Date;
        L_Desc: Text;
        L_ShipSign: Text;
        L_EmpRec: Record Employee;
    begin
        L_Desc:='';
        L_ShipSign:='';
        if(((P_InboundDetail.Shipsign <> 'NA') and (P_InboundDetail.Shipsign <> 'Not Applicable') and (P_InboundDetail.Shipsign <> '')) or ((P_InboundDetail."Entry Custom 2(DOC Code)" <> 'NA') and (P_InboundDetail."Entry Custom 2(DOC Code)" <> 'Not Applicable') and (P_InboundDetail."Entry Custom 2(DOC Code)" <> '')))then begin
            DateTimeValue:=0DT;
            entrydate:=0D;
            evaluate(DateTimeValue, P_InboundDetail."Entry Date");
            entrydate:=DT2Date(DateTimeValue);
            VMT.Reset();
            //VMT.Setfilter(DBASE, '0' + P_InboundDetail.Shipsign);//VJ 01Nov2025---
            //VJ 01Nov2025+++
            if StrLen(P_InboundDetail.Shipsign) = 3 then VMT.Setfilter(DBASE, '0' + P_InboundDetail.Shipsign)
            else
                VMT.Setfilter(DBASE, P_InboundDetail.Shipsign);
            //VJ 01Nov2025+++
            if VMT.FindFirst()then begin
                L_ShipSign:=format(VMT.SHIPSIGN);
            end;
            //L_EmpRec.GET(P_InboundDetail."EMP ID");
            L_Desc:=L_ShipSign + ' ' + copystr(P_InboundDetail."Entry Custom 2(DOC Code)", StrLen(P_InboundDetail."Entry Custom 2(DOC Code)") - 2, 3) + ' ' + CopyStr(P_InboundDetail."First Name", 1, 10) + ' ' + Format(entrydate);
        end
        else
        begin
            L_Desc:=P_InboundDetail."Entry Description";
        end;
        exit(L_Desc);
    end;
    procedure CreateGenJournal_CashLedg(var P_ConcurInboundFin: Record "Concur inbound financial Expen"; var P_ConcurBuffer: Record "Concur Staging Buffer"; var P_BalAmt: Decimal; var P_BalLCYAmt: Decimal)
    begin
        IF NOT((uppercase(P_ConcurInboundFin."Expense Type Name") <> 'BANK CLOSING BALANCE') AND (uppercase(P_ConcurInboundFin."Expense Type Name") <> 'BANK OPENING BALANCE') AND (uppercase(P_ConcurInboundFin."Expense Type Name") <> 'FUNDING FROM HK'))then exit;
        ConcurSetup.TestField("Concur Cash Ledger FD6");
        TempGJL.Init();
        TempGJL."Journal Template Name":=ConcurSetup."CL Concur Template Name";
        TempGJL."Journal Batch Name":=ConcurSetup."CL Concur Batch Name";
        CLLastLineNo:=CLLastLineNo + 10000;
        TempGJL."Line No.":=CLLastLineNo;
        //TempGJL."Document Type" := TempGJL."Document Type"::Invoice;
        TempGJL.Validate("Document No.", 'xyz');
        DateTimeValue:=0DT;
        evaluate(DateTimeValue, P_ConcurInboundFin."Entry Date");
        if Date2DMY(DT2Date(DateTimeValue), 2) < Date2DMY(dt2date(P_ConcurInboundFin.SystemCreatedAt), 2)then begin
            TempGJL."Document Date":=DT2Date(DateTimeValue);
            TempGJL."Posting Date":=CalcDate('-CM', DT2Date(P_ConcurInboundFin.SystemCreatedAt));
        end
        else
        begin
            TempGJL."Posting Date":=DT2Date(DateTimeValue);
            TempGJL."document Date":=DT2Date(DateTimeValue);
        end;
        TempGJL."External Document No.":=P_ConcurBuffer."External Doc No.";
        TempGJL."Concur ID":=P_ConcurInboundFin."Concur ID";
        TempGJL."Report ID":=P_ConcurBuffer."Report ID";
        TempGJL."Entry Id":=P_ConcurInboundFin."Entry Id";
        TempGJL."Receipt image ID":=P_ConcurInboundFin."Receipt Received";
        IF(P_ConcurInboundFin."Journal Key" = '372000') OR (P_ConcurInboundFin."Journal Key" = 'NA') OR (P_ConcurInboundFin."Journal Key" = '')then begin
            TempGJL."External Document No.":=copystr(P_ConcurInboundFin."Entry Description", StrLen(P_ConcurInboundFin."Entry Description") - 4, 5);
            TempGJL.Description:=P_ConcurInboundFin."Cashledger Employee Name" + ' ' + P_ConcurInboundFin."Entry Description";
            IF(P_ConcurInboundFin."Journal Key" = '372000')then begin
                IF(P_ConcurInboundFin."Employee name" <> 'NA') OR (P_ConcurInboundFin."Employee name" <> '')then begin
                    TempGJL."Account Type":=TempGJL."Account Type"::Employee;
                    TempGJL.Validate("Account No.", P_ConcurInboundFin."Employee name");
                end
                else
                begin
                    TempGJL."Account Type":=TempGJL."Account Type"::"G/L Account";
                    TempGJL.Validate("Account No.", '372000');
                end;
            end
            else
            begin
                TempGJL."Account Type":=TempGJL."Account Type"::"G/L Account";
                TempGJL.Validate("Account No.", P_ConcurInboundFin."Journal Key");
            end;
        end
        else
        begin
            TempGJL."External Document No.":=P_ConcurInboundFin."Report Key" + '_' + P_ConcurInboundFin."Legacy Entry Id";
            TempGJL.Description:=P_ConcurInboundFin."Cash Led entry description" + ' ' + P_ConcurInboundFin."Entry Description";
            TempGJL."Account Type":=TempGJL."Account Type"::"G/L Account";
            TempGJL.Validate("Account No.", P_ConcurInboundFin."Journal Key");
        end;
        //TempGJL.Description := P_ConcurInboundFin."Cash Led entry description" + '-' + P_ConcurInboundFin."Entry Description";
        //TempGJL.Description := GetDescription(P_ConcurInboundFin);  //description
        //    Evaluate(TempGJL.Amount, P_ConcurInboundFin."Entry Approved Amount");
        // Evaluate(TempGJL.Amount, P_ConcurInboundFin."Journal Net Amount");
        Evaluate(TempGJL.Amount, P_ConcurInboundFin."Net Tax Amount"); //Sgarg- New change - 11feb25
        TempGJL.Validate(Amount);
        TempGJL.Validate("Currency Code", P_ConcurBuffer."Report Currency");
        TempGJL."Original Ex Doc No.":=P_ConcurBuffer."External Doc No."; //Added on 280525
        VMT.Reset();
        VMT.SetRange(DBASE, CompanyName);
        if VMT.FindFirst()then TempGJL.Validate("Shortcut Dimension 1 Code", VMT.SEGMENT);
        TempGJL.Validate("Shortcut Dimension 2 Code", ConcurSetup."CL Default Concur Dim.");
        TempGJL.Validate("Shortcut Dimension 5 Code", P_ConcurInboundFin."New FD5");
        //TempGJL.Validate("Shortcut Dimension 6 Code", P_ConcurInboundFin."EMP ID");
        TempGJL.Validate("Shortcut Dimension 6 Code", ConcurSetup."Concur Cash Ledger FD6");
        TempGJL.Validate("Shortcut Dimension 8 Code", CompanyName);
        if P_ConcurBuffer."Is Ship Run" then begin
            if uppercase(P_ConcurInboundFin."Payment Type") = 'CASH' then TempGJL.Validate("Shortcut Dimension 9 Code", ConcurSetup."DOC Cash FD9")
            else
                TempGJL.Validate("Shortcut Dimension 9 Code", ConcurSetup."DOC Non Cash FD9");
        end;
        TempGJL."PB Concur invoice":=true;
        TempGJL."Is Ship Run":=P_ConcurBuffer."Is Ship Run";
        TempGJL."Fin Company Code":=P_ConcurBuffer."Fin Company Code";
        TempGJL."Ship Company Code":=P_ConcurBuffer."Ship Company Code";
        TempGJL.Insert();
        P_BalAmt+=TempGJL.Amount;
        P_BalLCYAmt+=TempGJL."Amount (LCY)";
    //exit(TempGJL."Amount (LCY)");
    end;
    procedure CreateReverseAdvance(var P_ConCurBuffer: Record "Concur Staging Buffer"; P_BalAmt: Decimal; P_AccCode: code[20]; P_DimsetId: Integer; P_Desc: text)
    var
        RecEmp: Record Employee;
    begin
        TempGJL.Init();
        IF P_ConCurBuffer."Cash Ledger" then begin
            TempGJL."Journal Template Name":=ConcurSetup."CL Concur Template Name";
            TempGJL."Journal Batch Name":=ConcurSetup."CL Concur Batch Name";
            CLLastLineNo:=CLLastLineNo + 10000;
            TempGJL."Line No.":=CLLastLineNo;
        end
        else
        begin
            TempGJL."Journal Template Name":=ConcurSetup."Concur Template Name";
            TempGJL."Journal Batch Name":=ConcurSetup."Concur Batch Name";
            lastLineNo:=lastLineNo + 10000;
            TempGJL."Line No.":=lastLineNo;
        end;
        //TempGJL."Document Type" := TempGJL."Document Type"::Invoice;
        TempGJL.Validate("Document No.", 'xyz');
        TempGJL."Posting Date":=P_ConcurBuffer."Payment Date";
        TempGJL."External Document No.":=P_ConcurBuffer."External Doc No.";
        TempGJL."Concur ID":=P_ConcurBuffer."Concur ID";
        TempGJL."Report ID":=P_ConcurBuffer."Report ID";
        TempGJL.validate("Account Type", TempGJL."Account Type"::Employee);
        TempGJL.Validate("Account No.", P_AccCode);
        RecEmp.GET(P_AccCode);
        TempGJL.Description:=RecEmp."First Name" + ' ' + P_Desc; //Added on 26 Jun25
        TempGJL.Validate(Amount, P_BalAmt);
        TempGJL.Validate("Bal. Account Type", TempGJL."Bal. Account Type"::"G/L Account");
        TempGJL.Validate("Bal. Account No.", ConcurSetup."Cash Advance Return G/L Acc");
        TempGJL."Dimension Set ID":=P_DimsetId;
        TempGJL.Insert;
    end;
    var GenJnlline_g: Record "Gen. Journal Line";
    TempGJL: Record "Gen. Journal Line" temporary;
    ConcurSetup: Record "Concur API Setup";
    lastLineNo: Integer;
    CLLastLineNo: Integer;
    DateTimeValue: DateTime;
    VMT: record VMT;
    NoSeries: Codeunit "No. Series";
    NewDocNo: Code[20];
    CompanyMapping: record "Company Name Mapping";
    CompanyNameMapping: record "Company Name Mapping";
    NeedReverseEntry: Boolean;
    ReverseAmt: Decimal;
    aa: Report "Standard Sales - Invoice";
    ReverseDescription: text;
}
