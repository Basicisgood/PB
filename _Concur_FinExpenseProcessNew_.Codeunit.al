codeunit 50210 "Concur_FinExpenseProcessNew"
{
    trigger OnRun()
    var
    begin
        PostFinCompany();
        Commit();
        PostShipCompany();
    end;
    procedure PostFinCompany()
    var
        VMT: record VMT;
        LineNo: Integer;
        ReportKey: text[80];
        ReportID: Text[100];
        NoSeries: Codeunit "No. Series";
        DocNo: Code[20];
        CompanyMapping: record "Company Name Mapping";
        CuConcurFinExpPost: Codeunit "Concur Finance Exp. Post";
        APISetup: Record "Concur API Setup";
        InboundFinExpen: Record "Concur inbound financial Expen";
        L_TaxAmt: Decimal;
        L_EmpAmt: Decimal;
        ErrorText: text;
        PostedFinNo: code[20];
    begin
        apiSetup.Get();
        apiSetup.TestField("Concur Template Name");
        apiSetup.TestField("Concur Batch Name");
        APISetup.TestField("Concur Gen. Journal No.");
        apiSetup.TestField("CL Concur Template Name");
        apiSetup.TestField("CL Concur Batch Name");
        APISetup.TestField("CL Concur Gen. Journal No.");
        //APISetup.TestField("Company Code Prefix");
        APISetup.TestField("Expense Type Name Filter 1");
        APISetup.TestField("Expense Type Name Filter 2");
        APISetup.TestField("Expense Type Name Filter 3");
        // Finance Company Posting
        ReportKey:='';
        ReportID:='';
        //Message(CompanyName);
        ConcurMaster.reset;
        ConcurMaster.SetCurrentKey("Report ID", "External Doc No.");
        ConcurMaster.SetRange("Fin Company Code", CompanyName);
        ConcurMaster.SetRange("Posted Doc No. Fin Company", '');
        ConcurMaster.SetFilter(Status, '%1|%2|%3', ConcurMaster.Status::Error, ConcurMaster.Status::Pending, ConcurMaster.Status::"Vessel Company Processed");
        IF ConcurMaster.FindFirst()then repeat IF NOT CheckAlreadyCreatedAndPosted(ConcurMaster, false)then begin
                    ConcurStagingBuffer.reset;
                    ConcurStagingBuffer.DeleteAll();
                    InboundFinExpen.Reset();
                    InboundFinExpen.SetCurrentKey("Report ID", "Report Key");
                    InboundFinExpen.SetRange("Report ID", ConcurMaster."Report ID");
                    InboundFinExpen.SetRange("Report Key", ConcurMaster."External Doc No.");
                    // InboundFinExpen.Setfilter("Journal Key", '<>%1', '16600000');  //Commented - 30 April25 - for return case
                    InboundFinExpen.SetFilter("Expense Type Name", '<>%1&<>%2&<>%3', APISetup."Expense Type Name Filter 1", APISetup."Expense Type Name Filter 2", APISetup."Expense Type Name Filter 3");
                    IF InboundFinExpen.FindFirst()then repeat IF NOT((Uppercase(InboundFinExpen."Payment Type") = 'CASH') AND (InboundFinExpen."Journal Key" = '16900000'))then begin
                                IF NOT ConcurStagingBuffer.GET(InboundFinExpen."Employee Org Unit 3", InboundFinExpen."Report ID", InboundFinExpen."Report Key", InboundFinExpen."Payment Type")then begin
                                    ConcurStagingBuffer.init;
                                    ConcurStagingBuffer."Company Code":=InboundFinExpen."Employee Org Unit 3";
                                    ConcurStagingBuffer."Report ID":=InboundFinExpen."Report ID";
                                    ConcurStagingBuffer."Concur ID":=InboundFinExpen."Concur ID";
                                    ConcurStagingBuffer."External Doc No.":=InboundFinExpen."Report Key";
                                    ConcurStagingBuffer."Payment Type":=InboundFinExpen."Payment Type";
                                    ConcurStagingBuffer."Emp Code":=InboundFinExpen."EMP ID";
                                    // evaluate(ConcurStagingBuffer."Tax Amount", InboundFinExpen."Journal Tax Amount");
                                    evaluate(ConcurStagingBuffer."Emp Amount", InboundFinExpen."Entry Approved Amount");
                                    //ConcurStagingBuffer."Tax Code" := InboundFinExpen."Tax label";
                                    ConcurStagingBuffer."Payment Date":=ConcurMaster."Payment Date";
                                    ConcurStagingBuffer."Report Currency":=ConcurMaster."Report Currency";
                                    ConcurStagingBuffer."Cash Ledger":=ConcurMaster."Cash Ledger";
                                    ConcurStagingBuffer."Is Ship Run":=false;
                                    ConcurStagingBuffer."Ship Company Code":=ConcurMaster."Ship Company Code";
                                    ConcurStagingBuffer."Fin Company Code":=ConcurMaster."Fin Company Code";
                                    //ConcurStagingBuffer.shi
                                    IF ConcurStagingBuffer.Insert()then;
                                END
                                else
                                begin
                                    L_EmpAmt:=0;
                                    Evaluate(L_EmpAmt, InboundFinExpen."Entry Approved Amount");
                                    ConcurStagingBuffer."Emp Amount"+=L_EmpAmt;
                                    ConcurStagingBuffer.Modify();
                                end;
                            end;
                        until InboundFinExpen.Next() = 0;
                    commit;
                    Clear(CU_50310);
                    ClearLastError();
                    PostedFinNo:='';
                    IF CU_50310.RUN(ConcurStagingBuffer)then begin
                        PostedFinNo:=CU_50310.GetDocNo();
                    end;
                    ErrorText:=GetLastErrorText();
                    IF ErrorText = '' then begin
                        ConcurMaster."Fin Status":='Processed';
                        ConcurMaster."Error Description":='';
                        ConcurMaster."Posted Doc No. Fin Company":=PostedFinNo;
                        if concurmaster."Posted Doc No. ship Company" = '' then begin
                            if ConcurMaster."Ship Company Code" <> '' then ConcurMaster.Status:=ConcurMaster.Status::"Finance Company Processed"
                            else
                                ConcurMaster.Status:=ConcurMaster.Status::Processed;
                        end
                        else
                            ConcurMaster.Status:=ConcurMaster.Status::Processed;
                    end
                    Else
                    Begin
                        ConcurMaster."Fin Status":='Error';
                        ConcurMaster."Error Description":=ErrorText;
                        ConcurMaster.Status:=ConcurMaster.Status::Error;
                    End;
                // ConcurMaster.Modify();
                end
                else
                begin
                    ConcurMaster."Fin Status":='Processed';
                    if concurmaster."Posted Doc No. ship Company" = '' then begin
                        if ConcurMaster."Ship Company Code" <> '' then ConcurMaster.Status:=ConcurMaster.Status::"Finance Company Processed"
                        else
                            ConcurMaster.Status:=ConcurMaster.Status::Processed;
                    end;
                end;
                ConcurMaster.Modify();
            until ConcurMaster.Next() = 0;
    end;
    procedure PostShipCompany()
    var
        InboundFinExpen: Record "Concur inbound financial Expen";
        L_TaxAmt: Decimal;
        L_EmpAmt: Decimal;
        ErrorText: text;
        PostedShipNo: code[20];
        ShipSign: Code[10];
        Len: Integer;
        APISetup: Record "Concur API Setup";
        CompNameMapping: Record "Company Name Mapping";
    begin
        ConcurStagingBuffer.reset;
        ConcurStagingBuffer.DeleteAll();
        commit;
        Len:=STRLEN(CompanyName);
        //ShipSign := COPYSTR(CompanyName, 2, Len - 1);//VJ 01Nov2025---
        //VJ 01Nov2025+++
        CompNameMapping.Get(CompanyName);
        if StrLen(CompNameMapping."Concur Company Code") = 3 then ShipSign:=COPYSTR(CompanyName, 2, Len - 1)
        else
            ShipSign:=CompanyName;
        //VJ 01Nov2025+++
        ConcurMaster.reset;
        ConcurMaster.SetCurrentKey("Ship Company Code", "Posted Doc No. Ship Company");
        ConcurMaster.SetRange("Ship Company Code", CompanyName);
        ConcurMaster.SetRange("Posted Doc No. Ship Company", '');
        ConcurMaster.SetFilter(Status, '%1|%2|%3', ConcurMaster.Status::Error, ConcurMaster.Status::Pending, ConcurMaster.Status::"Finance Company Processed");
        //ConcurMaster.Setfilter("Ship Company Code", '%1', '*' + CompanyName + '*');
        IF ConcurMaster.FindFirst()then repeat IF NOT CheckAlreadyCreatedAndPosted(ConcurMaster, true)then begin
                    ConcurStagingBuffer.reset;
                    ConcurStagingBuffer.DeleteAll();
                    InboundFinExpen.Reset();
                    InboundFinExpen.SetCurrentKey("Report ID", "Report Key");
                    InboundFinExpen.SetRange("Report ID", ConcurMaster."Report ID");
                    InboundFinExpen.SetRange("Report Key", ConcurMaster."External Doc No.");
                    InboundFinExpen.SetRange(Shipsign, ShipSign);
                    InboundFinExpen.Setfilter("Journal Key", '<>%1', '16600000');
                    InboundFinExpen.SetFilter("Expense Type Name", '<>%1&<>%2&<>%3', APISetup."Expense Type Name Filter 1", APISetup."Expense Type Name Filter 2", APISetup."Expense Type Name Filter 3");
                    IF InboundFinExpen.FindFirst()then repeat //IF NOT (Uppercase(InboundFinExpen."Payment Type") = 'CASH') AND (InboundFinExpen."Journal Key" = '16900000') then begin
                            IF NOT((Uppercase(InboundFinExpen."Payment Type") = 'CASH') AND (InboundFinExpen."Journal Key" = '16900000'))then begin
                                IF NOT ConcurStagingBuffer.GET(InboundFinExpen.Shipsign, InboundFinExpen."Report ID", InboundFinExpen."Report Key", InboundFinExpen."Payment Type")then begin
                                    ConcurStagingBuffer.init;
                                    ConcurStagingBuffer."Company Code":=InboundFinExpen.Shipsign;
                                    ConcurStagingBuffer."Report ID":=InboundFinExpen."Report ID";
                                    ConcurStagingBuffer."Concur ID":=InboundFinExpen."Concur ID";
                                    ConcurStagingBuffer."External Doc No.":=InboundFinExpen."Report Key";
                                    ConcurStagingBuffer."Payment Type":=InboundFinExpen."Payment Type";
                                    ConcurStagingBuffer."Emp Code":=InboundFinExpen."EMP ID";
                                    //evaluate(ConcurStagingBuffer."Tax Amount", InboundFinExpen."Journal Tax Amount");
                                    evaluate(ConcurStagingBuffer."Emp Amount", InboundFinExpen."Entry Approved Amount");
                                    //ConcurStagingBuffer."Tax Code" := InboundFinExpen."Tax label";
                                    ConcurStagingBuffer."Payment Date":=ConcurMaster."Payment Date";
                                    ConcurStagingBuffer."Report Currency":=ConcurMaster."Report Currency";
                                    ConcurStagingBuffer."Cash Ledger":=ConcurMaster."Cash Ledger";
                                    ConcurStagingBuffer."Is Ship Run":=true;
                                    ConcurStagingBuffer."Ship Company Code":=ConcurMaster."Ship Company Code";
                                    ConcurStagingBuffer."Fin Company Code":=ConcurMaster."Fin Company Code";
                                    IF ConcurStagingBuffer.Insert()then;
                                END
                                else
                                begin
                                    L_TaxAmt:=0;
                                    L_EmpAmt:=0;
                                    Evaluate(L_EmpAmt, InboundFinExpen."Journal Net Amount");
                                    ConcurStagingBuffer."Emp Amount"+=L_EmpAmt;
                                    ConcurStagingBuffer.Modify();
                                end;
                            end;
                        until InboundFinExpen.Next() = 0;
                    commit;
                    Clear(CU_50310);
                    ClearLastError();
                    PostedShipNo:='';
                    IF CU_50310.RUN(ConcurStagingBuffer)then begin
                        PostedShipNo:=CU_50310.GetDocNo();
                    end;
                    ErrorText:=GetLastErrorText();
                    IF ErrorText = '' then begin
                        ConcurMaster."Ship Status":='Processed';
                        ConcurMaster."Error Description":='';
                        ConcurMaster."Posted Doc No. Ship Company":=PostedShipNo;
                        if concurmaster."Posted Doc No. fin Company" = '' then begin
                            if ConcurMaster."Fin Company Code" <> '' then ConcurMaster.Status:=ConcurMaster.Status::"Vessel Company Processed"
                            else
                                ConcurMaster.Status:=ConcurMaster.Status::Processed;
                        end
                        else
                            ConcurMaster.Status:=ConcurMaster.Status::Processed;
                    end
                    Else
                    Begin
                        ConcurMaster."Ship Status":='Error';
                        ConcurMaster."Error Description":=ErrorText;
                    End;
                end
                else
                begin
                    ConcurMaster."Ship Status":='Processed';
                    if ConcurMaster."Posted Doc No. fin Company" = '' then begin
                        if ConcurMaster."Fin Company Code" <> '' then ConcurMaster.Status:=ConcurMaster.Status::"Vessel Company Processed"
                        else
                            ConcurMaster.Status:=ConcurMaster.Status::Processed;
                    end end;
                ConcurMaster.Modify();
            until ConcurMaster.Next() = 0;
    end;
    procedure CheckAlreadyCreatedAndPosted(P_InboundMaster: Record "Concur Inbound Master"; P_ShipRun: Boolean): Boolean var
        L_GJL: Record "Gen. Journal Line";
        L_GLE: Record "G/L Entry";
        L_TempName: Code[20];
        L_BatchName: code[20];
        ConCurSetup: Record "Concur API Setup";
    begin
        ConCurSetup.get;
        IF P_InboundMaster."Cash Ledger" then begin
            L_TempName:=ConcurSetup."CL Concur Template Name";
            L_BatchName:=ConcurSetup."CL Concur Batch Name";
        end
        else
        begin
            L_TempName:=ConcurSetup."Concur Template Name";
            L_BatchName:=ConcurSetup."Concur Batch Name";
        end;
        L_GJL.Reset();
        L_GJL.SetRange("Journal Template Name", L_TempName);
        L_GJL.SetRange("Journal Batch Name", L_BatchName);
        L_GJL.SetRange("Report ID", P_InboundMaster."Report ID");
        L_GJL.SetRange("Original Ex Doc No.", P_InboundMaster."External Doc No.");
        L_GJL.SetRange("Ship Company Code", P_InboundMaster."Ship Company Code");
        L_GJL.SetRange("Is Ship Run", P_ShipRun);
        IF L_GJL.FindFirst()then exit(true);
        L_GLE.reset;
        L_GLE.SetRange("Report ID", P_InboundMaster."Report ID");
        L_GLE.SetRange("Original Ex Doc No.", P_InboundMaster."External Doc No.");
        L_GLE.SetRange("Ship Company Code", P_InboundMaster."Ship Company Code");
        L_GLE.SetRange("Is Ship Run", P_ShipRun);
        IF L_GLE.FindFirst()then exit(true);
    //  L_GLE
    end;
    var CU_50310: Codeunit 50310;
    ConcurMaster: Record "Concur Inbound Master";
    ConcurStagingBuffer: Record "Concur Staging Buffer" temporary;
}
