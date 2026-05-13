codeunit 50176 "Concur_FinExpenseProcess"
{ //PS006
    trigger OnRun()
    var
        VMT: record VMT;
        LineNo: Integer;
        GenJnlLine: Record "Gen. Journal Line";
        ReportKey: text[80];
        ReportID: Text[100];
        NoSeries: Codeunit "No. Series";
        DocNo: Code[20];
        CompanyMapping: record "Company Name Mapping";
        CuConcurFinExpPost: Codeunit "Concur Finance Exp. Post";
        APISetup: Record "Concur API Setup";
        InboundFinExpen: Record "Concur inbound financial Expen";
        PrintEmp: Boolean;
        ConcurStagingBuffer: Record "Concur Staging Buffer";
        L_TaxAmt: Decimal;
        ErrorText: text;
        CompNameMapping: Record "Company Name Mapping";
    begin
        CompanyMapping.get(CompanyName);
        apiSetup.Get();
        apiSetup.TestField("Concur Template Name");
        apiSetup.TestField("Concur Batch Name");
        APISetup.TestField("Concur Gen. Journal No.");
        //APISetup.TestField("Company Code Prefix");
        InboundFinExpen.Reset();
        InboundFinExpen.SetFilter("Expense Status", '<>%1', InboundFinExpen."Expense Status"::Processed);
        InboundFinExpen.SetFilter("Entry Approved Amount", '<>%1', '');
        InboundFinExpen.SetFilter("Emp ID", '<>%1', '');
        if InboundFinExpen.FindSet()then repeat InboundFinExpen.TestField("Report Org Unit 3");
                if(InboundFinExpen."Expense Status" <> InboundFinExpen."Expense Status"::Cancel) and (uppercase(InboundFinExpen."Journal Type") <> 'CASH_LEDGER')then begin
                    if InboundFinExpen."Finance Company No" = '' then begin
                        /// InboundFinExpen."Finance Company No" := APISetup."Company Code Prefix" + InboundFinExpen."Report Org Unit 3";
                         //InboundFinExpen."Finance Company No" := APISetup."Company Code Prefix" + InboundFinExpen."Employee Org Unit 3";//TEC.VJ 30Oct2025 << Comment for Company Code Prefix
                        //TEC.VJ 30Oct2025 <<
                        InboundFinExpen."Finance Company No":=CompanyMapping.GetBCCompCode(InboundFinExpen."Employee Org Unit 3");
                        //TEC.VJ 30Oct2025 >>
                        InboundFinExpen.Modify();
                    end;
                    if InboundFinExpen."Ship Sign Company No" = '' then begin
                        if(((InboundFinExpen.Shipsign <> 'NA') and (InboundFinExpen.Shipsign <> 'Not Applicable') and (InboundFinExpen.Shipsign <> '')) and ((InboundFinExpen."Entry Custom 2(DOC Code)" <> 'NA') and (InboundFinExpen."Entry Custom 2(DOC Code)" <> 'Not Applicable') and (InboundFinExpen."Entry Custom 2(DOC Code)" <> ''))) and (InboundFinExpen."Journal Key" <> '16900000')then begin
                            VMT.Reset();
                            //  vmt.SetFilter(DBASE, APISetup."Company Code Prefix" + InboundFinExpen.Shipsign);//TEC.VJ 30Oct2025 << Comment for Company Code Prefix
                            //TEC.VJ 30Oct2025 <<
                            vmt.SetFilter(DBASE, CompanyMapping.GetBCCompCode(InboundFinExpen.Shipsign));
                            //TEC.VJ 30Oct2025 >>
                            if VMT.FindSet()then begin
                                InboundFinExpen."Ship Sign Company No":=VMT.DBASE;
                                InboundFinExpen.Modify();
                            end
                            else
                            begin
                                Error('VMT mapping not found for %1 Company', InboundFinExpen.Shipsign);
                            end;
                        end;
                    end;
                end;
                if(InboundFinExpen."Expense Status" <> InboundFinExpen."Expense Status"::Cancel) and (uppercase(InboundFinExpen."Journal Type") = 'CASH_LEDGER') and (UpperCase(InboundFinExpen."Payment Type") = 'COMPANY PAID') and (InboundFinExpen."Journal Key" <> '16900000') and ((uppercase(InboundFinExpen."Expense Type Name") <> 'BANK CLOSING BALANCE') AND (uppercase(InboundFinExpen."Expense Type Name") <> 'BANK OPENING BALANCE') AND (uppercase(InboundFinExpen."Expense Type Name") <> 'FUNDING FROM HK'))then begin
                    if InboundFinExpen."Finance Company No" = '' then begin
                        // InboundFinExpen."Finance Company No" := APISetup."Company Code Prefix" + InboundFinExpen."Report Org Unit 3";//TEC.VJ 30Oct2025 << Comment for Company Code Prefix
                        //TEC.VJ 30Oct2025 <<
                        InboundFinExpen."Finance Company No":=CompanyMapping.GetBCCompCode(InboundFinExpen."Report Org Unit 3");
                        //TEC.VJ 30Oct2025 >>
                        InboundFinExpen.Modify();
                    end;
                end;
            until InboundFinExpen.Next() = 0;
        commit;
        // Finance Company Posting
        ReportKey:='';
        ReportID:='';
        if InboundFinExpen.FindSet()then begin
            GenJnlLine.Reset();
            GenJnlLine.SetRange("Journal Template Name", apiSetup."Concur Template Name");
            GenJnlLine.SetRange("Journal Batch Name", apiSetup."Concur Batch Name");
            if GenJnlLine.FindLast()then LineNo:=GenJnlLine."Line No." + 10000
            else
                LineNo:=10000;
            repeat Commit();
                clear(CuConcurFinExpPost);
                InboundFinExpen.TestField("Report Key");
                InboundFinExpen.TestField("Report ID");
                PrintEmp:=false;
                if(ReportKey <> InboundFinExpen."Report Key") and (ReportID <> InboundFinExpen."Report ID") and (ReportKey <> '') and (ReportID <> '')then PrintEmp:=true;
                if PrintEmp = true then begin
                    if CuConcurFinExpPost.PostFinCompany(InboundFinExpen, DocNo, LineNo, PrintEmp)then begin
                        if(InboundFinExpen."Posted Document No Fin Company" <> '') and (InboundFinExpen."Posted Document No Shp Company" <> '')then InboundFinExpen."Expense Status":=InboundFinExpen."Expense Status"::Processed
                        else
                            InboundFinExpen."Expense Status":=InboundFinExpen."Expense Status"::"Finanace Company Processed";
                        InboundFinExpen."Error Description":='';
                        InboundFinExpen.Modify();
                    end
                    else
                    begin
                        InboundFinExpen."Expense Status":=InboundFinExpen."Expense Status"::Error;
                        InboundFinExpen."Error Description":=GetLastErrorText();
                        InboundFinExpen.Modify();
                    end;
                    LineNo+=10000;
                    PrintEmp:=false;
                end;
                if(ReportKey <> InboundFinExpen."Report Key") and (ReportID <> InboundFinExpen."Report ID")then DocNo:=NoSeries.GetNextNo(APISetup."Concur Gen. Journal No.");
                if CuConcurFinExpPost.PostFinCompany(InboundFinExpen, DocNo, LineNo, PrintEmp)then begin
                    if(InboundFinExpen."Posted Document No Fin Company" <> '') and (InboundFinExpen."Posted Document No Shp Company" <> '')then InboundFinExpen."Expense Status":=InboundFinExpen."Expense Status"::Processed
                    else
                        InboundFinExpen."Expense Status":=InboundFinExpen."Expense Status"::"Finanace Company Processed";
                    InboundFinExpen."Error Description":='';
                    InboundFinExpen.Modify();
                end
                else
                begin
                    InboundFinExpen."Expense Status":=InboundFinExpen."Expense Status"::Error;
                    InboundFinExpen."Error Description":=GetLastErrorText();
                    InboundFinExpen.Modify();
                end;
                LineNo+=10000;
                ReportKey:=InboundFinExpen."Report Key";
                ReportKey:=InboundFinExpen."Report ID";
            until InboundFinExpen.Next() = 0;
        end;
        // Ship shop Company Posting
        ReportKey:='';
        ReportID:='';
        InboundFinExpen.Reset();
        InboundFinExpen.SetCurrentKey("Report ID", "Report Key");
        InboundFinExpen.SetFilter(InboundFinExpen."Expense Status", '<>%1', InboundFinExpen."Expense Status"::Processed);
        InboundFinExpen.SetRange("Ship Sign Company No", CompanyName);
        InboundFinExpen.SetRange("Posted Document No Shp Company", '');
        if InboundFinExpen.FindSet()then begin
            GenJnlLine.Reset();
            GenJnlLine.SetRange("Journal Template Name", apiSetup."Concur Template Name");
            GenJnlLine.SetRange("Journal Batch Name", apiSetup."Concur Batch Name");
            if GenJnlLine.FindLast()then LineNo:=GenJnlLine."Line No." + 10000
            else
                LineNo:=10000;
            repeat Commit();
                clear(CuConcurFinExpPost);
                InboundFinExpen.TestField("Report Key");
                InboundFinExpen.TestField("Report ID");
                PrintEmp:=false;
                //VT
                if(ReportKey <> InboundFinExpen."Report Key") and (ReportID <> InboundFinExpen."Report ID") and (ReportKey <> '') and (ReportID <> '')then PrintEmp:=true;
                if PrintEmp = true then begin
                    if CuConcurFinExpPost.PostshipCompany(InboundFinExpen, DocNo, LineNo, PrintEmp)then begin
                        if(InboundFinExpen."Posted Document No Fin Company" <> '') and (InboundFinExpen."Posted Document No Shp Company" <> '')then InboundFinExpen."Expense Status":=InboundFinExpen."Expense Status"::Processed
                        else
                            InboundFinExpen."Expense Status":=InboundFinExpen."Expense Status"::"Ship Shop Company Processed";
                        InboundFinExpen."Error Description":='';
                        InboundFinExpen.Modify();
                    end
                    else
                    begin
                        InboundFinExpen."Expense Status":=InboundFinExpen."Expense Status"::Error;
                        InboundFinExpen."Error Description":=GetLastErrorText();
                        InboundFinExpen.Modify();
                    end;
                    LineNo+=10000;
                    PrintEmp:=false;
                end;
                //VT
                if(ReportKey <> InboundFinExpen."Report Key") and (ReportID <> InboundFinExpen."Report ID")then //VT
 DocNo:=NoSeries.GetNextNo(APISetup."Concur Gen. Journal No.");
                if CuConcurFinExpPost.PostshipCompany(InboundFinExpen, DocNo, LineNo, PrintEmp)then begin
                    if(InboundFinExpen."Posted Document No Fin Company" <> '') and (InboundFinExpen."Posted Document No Shp Company" <> '')then InboundFinExpen."Expense Status":=InboundFinExpen."Expense Status"::Processed
                    else
                        InboundFinExpen."Expense Status":=InboundFinExpen."Expense Status"::"Ship Shop Company Processed";
                    InboundFinExpen."Error Description":='';
                    InboundFinExpen.Modify();
                end
                else
                begin
                    InboundFinExpen."Expense Status":=InboundFinExpen."Expense Status"::Error;
                    InboundFinExpen."Error Description":=GetLastErrorText();
                    InboundFinExpen.Modify();
                end;
                LineNo+=10000;
                ReportKey:=InboundFinExpen."Report Key";
                ReportID:=InboundFinExpen."Report ID";
            until InboundFinExpen.Next() = 0;
        end;
    end;
    local procedure UpdateStagingLineStatus(var P_ConCurBuff: Record "Concur Staging Buffer" temporary; ErrorDesc: Text[250]; Processed_p: Boolean)
    var
        Staging: Record "Concur inbound financial Expen";
        Staging2: Record "Concur inbound financial Expen";
    begin
        Staging.Reset();
        Staging.SetCurrentKey("Report ID", "Report Key");
        Staging.SetRange("Report ID", P_ConCurBuff."Report ID");
        Staging.SetRange("Report Key", P_ConCurBuff."External Doc No.");
        Staging.SetFilter("Expense Status", '%1|%2', Staging."Expense Status"::Error, Staging."Expense Status"::Pending);
        If Staging.FindSet()then repeat If Processed_p then begin
                    Staging2.GET(Staging."Entry No.");
                    Staging2."Expense Status":=Staging2."Expense Status"::Processed;
                    Staging2."Error Description":='';
                end
                Else
                begin
                    Staging2.GET(Staging."Entry No.");
                    Staging2."Expense Status":=Staging2."Expense Status"::Error;
                    Staging2."Error Description":=ErrorDesc;
                end;
                Staging2.Modify();
            until Staging.Next() = 0;
    end;
    var CU_50202: Codeunit 50310;
}
