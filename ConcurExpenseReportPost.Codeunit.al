codeunit 50181 ConcurExpenseReportPost
{ //PS007
    //PB-2026010205 TEC.VG 09FEB2026 Change code from GenJnlLine.Insert(); to GenJnlLine.Insert(true); to update posting no. series so system take corrext document no. based on posting date in all the place 
    trigger OnRun()
    var
        PbPurcchInv: Record "PB Purchase Invoice Inbound";
        VMT: record VMT;
        RecurringFrequency: DateFormula;
        GenJnlTemplate: Record "Gen. Journal Template";
        LineNo1: Integer;
        TotalAmt: Decimal;
        JnlCreated: Boolean;
        LineNo: Integer;
        PreviousRec: Record "Expense Report Staging";
        EmployeeID: text[30];
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        FD5Val: text[30];
        GenJnlLine: Record "Gen. Journal Line";
        ReportKey: text[80];
        NoSeries: Codeunit "No. Series";
        DocNo: Code[20];
        DNVSetup: Record "DNV Integration Setup";
        PBPurchInvLine: record "PB Purchase Invoice Line Inb";
        CompanyMapping: record "Company Name Mapping";
        CuDNVInvPost: Codeunit "DNV Invoice Post";
        CuConcurFinExpPost: Codeunit "Concur Finance Exp. Post";
        APISetup: Record "Concur API Setup";
        InboundFinExpen: Record "Concur inbound financial Expen";
        ExpReportStaging: Record "Expense Report Staging";
    //GenJnlLine:Record "Gen. Journal Line";
    begin
        apiSetup.Get();
        apiSetup.TestField("Concur accr. Template Name");
        apiSetup.TestField("Concur accr. Batch Name");
        APISetup.TestField("Concur accr. Gen. Journal No.");
        APISetup.TestField("Accrual Report Name Filter 1");
        APISetup.TestField("Accrual Report Name Filter 2");
        APISetup.TestField("Accrual Report Name Filter 3");
        APISetup.TestField("Accrual FD5 Filter 1");
        //APISetup.TestField("Recurring Frequency");
        APISetup.TestField("Accrual Credit GL Code");
        APISetup.TestField("Accrual Debit GL Code");
        Evaluate(RecurringFrequency, '1D');
        GenJnlTemplate.Get(APISetup."Concur Accr. Template Name");
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", apiSetup."Concur accr. Template Name");
        GenJnlLine.SetRange("Journal Batch Name", apiSetup."Concur accr. Batch Name");
        if GenJnlLine.FindLast()then LineNo1:=GenJnlLine."Line No." + 10000
        else
            LineNo1:=10000;
        ExpReportStaging.Reset();
        ExpReportStaging.SetCurrentKey("Employee ID", "New FD5");
        ExpReportStaging.SetFilter("Process status", '<>%1&<>%2', ExpReportStaging."Process Status"::Success, ExpReportStaging."Process status"::Cancel);
        ExpReportStaging.SetFilter("Account Code", '%1', '8*');
        ExpReportStaging.SetFilter("Reimbursement Currency", '<>%1', 'BRL');
        ExpReportStaging.SetFilter("Posted Amount", '<>%1', 0);
        ExpReportStaging.SetFilter("New FD5", '<>%1', '');
        ExpReportStaging.SetFilter("Employee ID", '<>%1', '');
        ExpReportStaging.SetFilter("Posting Date", '<>%1', 0D);
        if ExpReportStaging.FindSet()then begin
            if JnlCreated = false then begin
                //DocNo := NoSeries.GetNextNo(APISetup."Concur accr. Gen. Journal No.");//PB-2026010205] [URGENT] BC-create wrong document number for Concur accrual VJ 21Jan2026 start
                DocNo:=NoSeries.GetNextNo(APISetup."Concur accr. Gen. Journal No.", ExpReportStaging."Posting Date"); //PB-2026010205] [URGENT] BC-create wrong document number for Concur accrual VJ 21Jan2026 start
                JnlCreated:=true;
            end;
            repeat //if ('0' + ExpReportStaging.Company = CompanyName) //02Jan2026 VJ Commented
                if(CompanyMapping.GetBCCompCode(ExpReportStaging.Company) = CompanyName) //02Jan2026 VJ PB-2026010206] Urgent-BC-post failure for Concur accrual in 2602
 and (uppercase(ExpReportStaging.Group) <> 'CASH_LEDGER') and ((ExpReportStaging.Vessel = '') or (UpperCase(ExpReportStaging.Vessel) = 'NA') or (UpperCase(ExpReportStaging.Vessel) = 'NOT APPLICABLE'))then begin
                    if(strpos(uppercase(ExpReportStaging."Report Name"), uppercase(APISetup."Accrual Report Name Filter 1")) = 0) and (strpos(uppercase(ExpReportStaging."Report Name"), uppercase(APISetup."Accrual Report Name Filter 2")) = 0) and (strpos(uppercase(ExpReportStaging."Report Name"), uppercase(APISetup."Accrual Report Name Filter 3")) = 0)then begin
                        if((EmployeeID <> ExpReportStaging."Employee ID") and (employeeid <> '')) or ((ExpReportStaging."New FD5" <> FD5Val) and (FD5Val <> ''))then begin
                            GenJnlLine.Init();
                            GenJnlLine."Journal Template Name":=apiSetup."Concur accr. Template Name";
                            GenJnlLine."Journal Batch Name":=apiSetup."Concur accr. Batch Name";
                            GenJnlLine."Line No.":=LineNo1;
                            GenJnlLine."Posting Date":=PreviousRec."Posting Date";
                            GenJnlLine."Source Code":=GenJnlTemplate."Source Code";
                            GenJnlLine."Recurring Method":=GenJnlLine."Recurring Method"::"RF Reversing Fixed";
                            GenJnlLine.validate("Recurring Frequency", RecurringFrequency);
                            GenJnlLine."Document No.":=DocNo;
                            GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                            GenJnlLine.Validate("Account No.", APISetup."Accrual Debit GL Code");
                            GenJnlLine.Description:=copystr(PreviousRec.Employee, Strpos(PreviousRec.Employee, ',') + 2) + ' Concur Accrual ' + Format(Date2DMY(PreviousRec."Posting Date", 3));
                            if StrLen(Format(Date2DMY(PreviousRec."Posting Date", 2))) = 1 then GenJnlLine.Description:=GenJnlLine.Description + '0' + Format(Date2DMY(PreviousRec."Posting Date", 2))
                            else
                                GenJnlLine.Description:=GenJnlLine.Description + Format(Date2DMY(PreviousRec."Posting Date", 2));
                            GenJnlLine.Validate(Amount, TotalAmt);
                            GenJnlLine.Validate("Currency Code", PreviousRec."Reimbursement Currency");
                            //GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                            //GenJnlLine.Validate("Bal. Account No.", '516412');
                            VMT.Reset();
                            VMT.SetRange(DBASE, CompanyName);
                            if VMT.FindFirst()then GenJnlLine.Validate("Shortcut Dimension 1 Code", VMT.SEGMENT);
                            GenJnlLine.Validate("Shortcut Dimension 5 Code", PreviousRec."New FD5");
                            GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyName);
                            GenJnlLine.Validate("Shortcut Dimension 2 Code", apiSetup."Default Concur accr. Dimension");
                            //GenJnlLine."PB Concur invoice" := true;
                            GenJnlLine.Insert(true);
                            LineNo1+=10000;
                            GenJnlLine.Init();
                            GenJnlLine."Journal Template Name":=apiSetup."Concur accr. Template Name";
                            GenJnlLine."Journal Batch Name":=apiSetup."Concur accr. Batch Name";
                            GenJnlLine."Line No.":=LineNo1;
                            GenJnlLine."Posting Date":=PreviousRec."Posting Date";
                            GenJnlLine."Source Code":=GenJnlTemplate."Source Code";
                            GenJnlLine."Recurring Method":=GenJnlLine."Recurring Method"::"RF Reversing Fixed";
                            GenJnlLine.validate("Recurring Frequency", RecurringFrequency);
                            GenJnlLine."Document No.":=DocNo;
                            GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                            GenJnlLine.Validate("Account No.", APISetup."Accrual Credit GL Code");
                            GenJnlLine.Description:=copystr(PreviousRec.Employee, Strpos(PreviousRec.Employee, ',') + 2) + ' Concur Accrual ' + Format(Date2DMY(PreviousRec."Posting Date", 3));
                            if StrLen(Format(Date2DMY(PreviousRec."Posting Date", 2))) = 1 then GenJnlLine.Description:=GenJnlLine.Description + '0' + Format(Date2DMY(PreviousRec."Posting Date", 2))
                            else
                                GenJnlLine.Description:=GenJnlLine.Description + Format(Date2DMY(PreviousRec."Posting Date", 2));
                            GenJnlLine.Validate(Amount, -TotalAmt);
                            GenJnlLine.Validate("Currency Code", PreviousRec."Reimbursement Currency");
                            VMT.Reset();
                            VMT.SetRange(DBASE, CompanyName);
                            if VMT.FindFirst()then GenJnlLine.Validate("Shortcut Dimension 1 Code", VMT.SEGMENT);
                            GenJnlLine.Validate("Shortcut Dimension 5 Code", PreviousRec."New FD5");
                            GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyName);
                            GenJnlLine.Validate("Shortcut Dimension 2 Code", apiSetup."Default Concur accr. Dimension");
                            //GenJnlLine."PB Concur invoice" := true;
                            GenJnlLine.Insert(true);
                            //DocNo := NoSeries.GetNextNo(APISetup."Concur accr. Gen. Journal No.");//PB-2026010205] [URGENT] BC-create wrong document number for Concur accrual VJ 21Jan2026 start
                            DocNo:=NoSeries.GetNextNo(APISetup."Concur accr. Gen. Journal No.", PreviousRec."Posting Date"); //PB-2026010205] [URGENT] BC-create wrong document number for Concur accrual VJ 21Jan2026 end
                            LineNo1+=10000;
                            JnlCreated:=false;
                            TotalAmt:=ExpReportStaging."Posted Amount";
                            PreviousRec:=ExpReportStaging;
                            ExpReportStaging."Process status":=ExpReportStaging."Process status"::Success;
                            ExpReportStaging."Processed date/time":=CurrentDateTime;
                            ExpReportStaging."Document No.":=DocNo;
                            ExpReportStaging.Modify();
                        end
                        else
                        begin
                            PreviousRec:=ExpReportStaging;
                            TotalAmt+=ExpReportStaging."Posted Amount";
                            ExpReportStaging."Process status":=ExpReportStaging."Process status"::Success;
                            ExpReportStaging."Processed date/time":=CurrentDateTime;
                            ExpReportStaging."Document No.":=docno;
                            ExpReportStaging.Modify();
                        end;
                    end
                    else
                    begin
                        if(strpos(uppercase(ExpReportStaging."Report Name"), uppercase(APISetup."Accrual Report Name Filter 2")) <> 0) or (strpos(uppercase(ExpReportStaging."Report Name"), uppercase(APISetup."Accrual Report Name Filter 3")) <> 0)then if(strpos(uppercase(ExpReportStaging."New FD5"), uppercase(APISetup."Accrual FD5 Filter 1")) <> 0)then begin
                                if((EmployeeID <> ExpReportStaging."Employee ID") and (employeeid <> '')) or ((ExpReportStaging."New FD5" <> FD5Val) and (FD5Val <> ''))then begin
                                    GenJnlLine.Init();
                                    GenJnlLine."Journal Template Name":=apiSetup."Concur accr. Template Name";
                                    GenJnlLine."Journal Batch Name":=apiSetup."Concur accr. Batch Name";
                                    GenJnlLine."Line No.":=LineNo1;
                                    GenJnlLine."Posting Date":=PreviousRec."Posting Date";
                                    GenJnlLine."Source Code":=GenJnlTemplate."Source Code";
                                    GenJnlLine."Recurring Method":=GenJnlLine."Recurring Method"::"RF Reversing Fixed";
                                    GenJnlLine.validate("Recurring Frequency", RecurringFrequency);
                                    GenJnlLine."Document No.":=DocNo;
                                    GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                                    GenJnlLine.Validate("Account No.", APISetup."Accrual Debit GL Code");
                                    GenJnlLine.Description:=copystr(PreviousRec.Employee, Strpos(PreviousRec.Employee, ',') + 2) + ' Concur Accrual ' + Format(Date2DMY(PreviousRec."Posting Date", 3));
                                    if StrLen(Format(Date2DMY(PreviousRec."Posting Date", 2))) = 1 then GenJnlLine.Description:=GenJnlLine.Description + '0' + Format(Date2DMY(PreviousRec."Posting Date", 2))
                                    else
                                        GenJnlLine.Description:=GenJnlLine.Description + Format(Date2DMY(PreviousRec."Posting Date", 2));
                                    GenJnlLine.Validate(Amount, TotalAmt);
                                    GenJnlLine.Validate("Currency Code", PreviousRec."Reimbursement Currency");
                                    VMT.Reset();
                                    VMT.SetRange(DBASE, CompanyName);
                                    if VMT.FindFirst()then GenJnlLine.Validate("Shortcut Dimension 1 Code", VMT.SEGMENT);
                                    GenJnlLine.Validate("Shortcut Dimension 5 Code", PreviousRec."New FD5");
                                    GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyName);
                                    GenJnlLine.Validate("Shortcut Dimension 2 Code", apiSetup."Default Concur accr. Dimension");
                                    //GenJnlLine."PB Concur invoice" := true;
                                    GenJnlLine.Insert(true);
                                    LineNo1+=10000;
                                    GenJnlLine.Init();
                                    GenJnlLine."Journal Template Name":=apiSetup."Concur accr. Template Name";
                                    GenJnlLine."Journal Batch Name":=apiSetup."Concur accr. Batch Name";
                                    GenJnlLine."Line No.":=LineNo1;
                                    GenJnlLine."Posting Date":=PreviousRec."Posting Date";
                                    GenJnlLine."Source Code":=GenJnlTemplate."Source Code";
                                    GenJnlLine."Recurring Method":=GenJnlLine."Recurring Method"::"RF Reversing Fixed";
                                    GenJnlLine.validate("Recurring Frequency", RecurringFrequency);
                                    GenJnlLine."Document No.":=docno;
                                    GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                                    GenJnlLine.Validate("Account No.", APISetup."Accrual Credit GL Code");
                                    GenJnlLine.Description:=copystr(PreviousRec.Employee, Strpos(PreviousRec.Employee, ',') + 2) + ' Concur Accrual ' + Format(Date2DMY(PreviousRec."Posting Date", 3));
                                    if StrLen(Format(Date2DMY(PreviousRec."Posting Date", 2))) = 1 then GenJnlLine.Description:=GenJnlLine.Description + '0' + Format(Date2DMY(PreviousRec."Posting Date", 2))
                                    else
                                        GenJnlLine.Description:=GenJnlLine.Description + Format(Date2DMY(PreviousRec."Posting Date", 2));
                                    GenJnlLine.Validate(Amount, -TotalAmt);
                                    GenJnlLine.Validate("Currency Code", PreviousRec."Reimbursement Currency");
                                    VMT.Reset();
                                    VMT.SetRange(DBASE, CompanyName);
                                    if VMT.FindFirst()then GenJnlLine.Validate("Shortcut Dimension 1 Code", VMT.SEGMENT);
                                    GenJnlLine.Validate("Shortcut Dimension 5 Code", PreviousRec."New FD5");
                                    GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyName);
                                    GenJnlLine.Validate("Shortcut Dimension 2 Code", apiSetup."Default Concur accr. Dimension");
                                    //GenJnlLine."PB Concur invoice" := true;
                                    GenJnlLine.Insert(true);
                                    //DocNo := NoSeries.GetNextNo(APISetup."Concur accr. Gen. Journal No.");//PB-2026010205] [URGENT] BC-create wrong document number for Concur accrual VJ 21Jan2026 start
                                    DocNo:=NoSeries.GetNextNo(APISetup."Concur accr. Gen. Journal No.", PreviousRec."Posting Date"); //PB-2026010205] [URGENT] BC-create wrong document number for Concur accrual VJ 21Jan2026 start
                                    LineNo1+=10000;
                                    JnlCreated:=false;
                                    TotalAmt:=ExpReportStaging."Posted Amount";
                                    PreviousRec:=ExpReportStaging;
                                    ExpReportStaging."Process status":=ExpReportStaging."Process status"::Success;
                                    ExpReportStaging."Processed date/time":=CurrentDateTime;
                                    ExpReportStaging."Document No.":=DocNo;
                                    ExpReportStaging.Modify();
                                end
                                else
                                begin
                                    PreviousRec:=ExpReportStaging;
                                    TotalAmt+=ExpReportStaging."Posted Amount";
                                    ExpReportStaging."Process status":=ExpReportStaging."Process status"::Success;
                                    ExpReportStaging."Processed date/time":=CurrentDateTime;
                                    ExpReportStaging."Document No.":=DocNo;
                                    ExpReportStaging.Modify();
                                end;
                            end;
                    end;
                    EmployeeID:=ExpReportStaging."Employee ID";
                    FD5Val:=ExpReportStaging."New FD5";
                end;
            until ExpReportStaging.Next() = 0;
            if TotalAmt <> 0 then begin
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name":=apiSetup."Concur accr. Template Name";
                GenJnlLine."Journal Batch Name":=apiSetup."Concur accr. Batch Name";
                GenJnlLine."Line No.":=LineNo1;
                GenJnlLine."Posting Date":=PreviousRec."Posting Date";
                GenJnlLine."Source Code":=GenJnlTemplate."Source Code";
                GenJnlLine."Recurring Method":=GenJnlLine."Recurring Method"::"RF Reversing Fixed";
                GenJnlLine.validate("Recurring Frequency", RecurringFrequency);
                GenJnlLine."Document No.":=docno;
                GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine.Validate("Account No.", APISetup."Accrual Debit GL Code");
                GenJnlLine.Description:=copystr(PreviousRec.Employee, Strpos(PreviousRec.Employee, ',') + 2) + ' Concur Accrual ' + Format(Date2DMY(PreviousRec."Posting Date", 3));
                if StrLen(Format(Date2DMY(PreviousRec."Posting Date", 2))) = 1 then GenJnlLine.Description:=GenJnlLine.Description + '0' + Format(Date2DMY(PreviousRec."Posting Date", 2))
                else
                    GenJnlLine.Description:=GenJnlLine.Description + Format(Date2DMY(PreviousRec."Posting Date", 2));
                GenJnlLine.Validate(Amount, TotalAmt);
                GenJnlLine.Validate("Currency Code", PreviousRec."Reimbursement Currency");
                VMT.Reset();
                VMT.SetRange(DBASE, CompanyName);
                if VMT.FindFirst()then GenJnlLine.Validate("Shortcut Dimension 1 Code", VMT.SEGMENT);
                GenJnlLine.Validate("Shortcut Dimension 5 Code", PreviousRec."New FD5");
                GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyName);
                GenJnlLine.Validate("Shortcut Dimension 2 Code", apiSetup."Default Concur accr. Dimension");
                //GenJnlLine."PB Concur invoice" := true;
                GenJnlLine.Insert(true);
                lineno1+=10000;
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name":=apiSetup."Concur accr. Template Name";
                GenJnlLine."Journal Batch Name":=apiSetup."Concur accr. Batch Name";
                GenJnlLine."Line No.":=LineNo1;
                GenJnlLine."Posting Date":=PreviousRec."Posting Date";
                GenJnlLine."Source Code":=GenJnlTemplate."Source Code";
                GenJnlLine."Recurring Method":=GenJnlLine."Recurring Method"::"RF Reversing Fixed";
                GenJnlLine.validate("Recurring Frequency", RecurringFrequency);
                GenJnlLine."Document No.":=docno;
                GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine.Validate("Account No.", APISetup."Accrual Credit GL Code");
                GenJnlLine.Description:=copystr(PreviousRec.Employee, Strpos(PreviousRec.Employee, ',') + 2) + ' Concur Accrual ' + Format(Date2DMY(PreviousRec."Posting Date", 3));
                if StrLen(Format(Date2DMY(PreviousRec."Posting Date", 2))) = 1 then GenJnlLine.Description:=GenJnlLine.Description + '0' + Format(Date2DMY(PreviousRec."Posting Date", 2))
                else
                    GenJnlLine.Description:=GenJnlLine.Description + Format(Date2DMY(PreviousRec."Posting Date", 2));
                GenJnlLine.Validate(Amount, -TotalAmt);
                GenJnlLine.Validate("Currency Code", PreviousRec."Reimbursement Currency");
                VMT.Reset();
                VMT.SetRange(DBASE, CompanyName);
                if VMT.FindFirst()then GenJnlLine.Validate("Shortcut Dimension 1 Code", VMT.SEGMENT);
                GenJnlLine.Validate("Shortcut Dimension 5 Code", PreviousRec."New FD5");
                GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyName);
                GenJnlLine.Validate("Shortcut Dimension 2 Code", apiSetup."Default Concur accr. Dimension");
                //GenJnlLine."PB Concur invoice" := true;
                GenJnlLine.Insert(true);
            end;
            GenJnlLine.reset;
            GenJnlLine.SetRange("Journal Template Name", APISetup."Concur Accr. Template Name");
            GenJnlLine.SetRange("Journal Batch Name", APISetup."Concur Accr. Batch Name");
            if GenJnlLine.FindFirst()then GenJnlPostBatch.Run(GenJnlLine);
            GenJnlLine.reset;
            GenJnlLine.SetRange("Journal Template Name", APISetup."Concur Accr. Template Name");
            GenJnlLine.SetRange("Journal Batch Name", APISetup."Concur Accr. Batch Name");
            if GenJnlLine.FindSet()then GenJnlLine.DeleteAll();
        end;
    end;
}
