codeunit 50149 "DNV Crew Payroll Process"
{
    trigger OnRun()
    var
        DNVCrewPayroll: Record "PB Crew Payroll Inbound";
        VMT: record VMT;
        DNVSetup: Record "DNV Integration Setup";
        CompanyMapping: record "Company Name Mapping";
        CuDNVCrewPayrollPost: Codeunit "DNV Crew Payroll Posting";
        CrewPayLine: record "PB Crew Payroll Dim Inb";
        DNVMapping: record "DNV Mapping";
        GlAccountNo: Code[20];
        GLEntry: Record "G/L Entry";
        ICCompanyNo: Text[50];
        ICFound: Boolean;
    begin
        DNVSetup.Get();
        //check Modify data
        DNVCrewPayroll.Reset();
        DNVCrewPayroll.SetFilter(Status, '<>%1', DNVCrewPayroll.Status::Cancel);
        DNVCrewPayroll.SetRange("Records Status", DNVCrewPayroll."Records Status"::Update);
        if DNVCrewPayroll.FindSet()then repeat DNVCrewPayroll.Status:=DNVCrewPayroll.Status::Cancel;
                DNVCrewPayroll."Error Description":='AUTO CANCEL- record status update is not allowed';
                DNVCrewPayroll.Modify();
            until DNVCrewPayroll.Next() = 0;
        Commit();
        //Check New and delete data
        DNVCrewPayroll.Reset();
        DNVCrewPayroll.SetFilter(Status, '=%1|%2', DNVCrewPayroll.Status::Error, DNVCrewPayroll.Status::Pending);
        DNVCrewPayroll.SetFilter("Records Status", '=%1|%2', DNVCrewPayroll."Records Status"::New, DNVCrewPayroll."Records Status"::Delete);
        if DNVCrewPayroll.FindSet()then repeat if DNVCrewPayroll."Records Status" = DNVCrewPayroll."Records Status"::New then CreateNewLines(DNVCrewPayroll)
                else
                    CreateReverseLines(DNVCrewPayroll);
            until DNVCrewPayroll.Next() = 0;
        Commit();
        DNVCrewPayroll.Reset();
        DNVCrewPayroll.SetFilter(Status, '=%1|%2|%3|%4', DNVCrewPayroll.Status::Error, DNVCrewPayroll.Status::Pending, DNVCrewPayroll.Status::"Finanace Company Processed", DNVCrewPayroll.Status::"Ship Shop Company Processed");
        if DNVCrewPayroll.FindSet()then repeat if DNVCrewPayroll.Status <> DNVCrewPayroll.Status::Cancel then begin
                    if UpperCase(DNVCrewPayroll."Crew Rank").Contains('CADET')then DNVCrewPayroll."Is Cadet":=true;
                    if 1 = 1 then begin
                        //if DNVCrewPayroll."Finance Company No" = '' then begin
                        ICCompanyNo:='';
                        GlAccountNo:='';
                        ICFound:=false;
                        CrewPayLine.Reset();
                        CrewPayLine.SetRange("Crew Payroll Entry No.", DNVCrewPayroll."Entry No.");
                        CrewPayLine.SetFilter("Total Amount", '<>%1', 0);
                        if CrewPayLine.FindSet()then repeat ICCompanyNo:='';
                                GlAccountNo:='';
                                DNVMapping.Reset();
                                DNVMapping.SetRange("Dimension code", CrewPayLine."Wage Dimension Code");
                                DNVMapping.SetRange("Wage Accounting Area Code", DNVCrewPayroll."Accounting Area");
                                DNVMapping.SetRange("Is Cadet", DNVCrewPayroll."Is Cadet");
                                if DNVMapping.FindSet()then begin
                                    ICCompanyNo:=DNVMapping.Company;
                                    GlAccountNo:=DNVMapping."Main account";
                                end;
                                if GlAccountNo = '' then begin
                                    DNVMapping.Reset();
                                    DNVMapping.SetRange("Dimension code", CrewPayLine."Wage Dimension Code");
                                    DNVMapping.SetRange("Is Cadet", DNVCrewPayroll."Is Cadet");
                                    if DNVMapping.FindSet()then begin
                                        ICCompanyNo:=DNVMapping.Company;
                                        GlAccountNo:=DNVMapping."Main account";
                                    end;
                                end;
                                if ICCompanyNo <> '' then ICCompanyNo:=ReturnCompanyName(ICCompanyNo);
                                if ICCompanyNo <> '' then begin
                                    DNVCrewPayroll."Finance Company No":=ICCompanyNo;
                                    CrewPayLine."IC Code":=ICCompanyNo;
                                    ICFound:=true;
                                end
                                else
                                begin
                                end;
                                CrewPayLine."IC Code":=ICCompanyNo;
                                CrewPayLine."GL Code":=GlAccountNo;
                                CrewPayLine.Modify();
                            until CrewPayLine.Next() = 0;
                        if not ICFound then begin
                            DNVCrewPayroll."Finance Company No":='N.A';
                            DNVCrewPayroll."Posted Document No Fin Company":='N.A';
                            DNVCrewPayroll."Posted In Fin Company":=true;
                        end;
                    end;
                    if 1 = 1 then begin
                        DNVCrewPayroll."Ship Sign Company No":=ReturnCompanyNamefromShortSign(DNVCrewPayroll."Ship Short Sign");
                    end;
                    DNVCrewPayroll.Modify();
                end;
            until DNVCrewPayroll.Next() = 0;
        Commit();
        // Finance Company Posting
        DNVCrewPayroll.Reset();
        DNVCrewPayroll.SetFilter(Status, '=%1|%2|%3', DNVCrewPayroll.Status::Pending, DNVCrewPayroll.Status::Error, DNVCrewPayroll.Status::"Ship Shop Company Processed");
        DNVCrewPayroll.SetRange("Finance Company No", CompanyName);
        DNVCrewPayroll.SetRange("Posted Document No Fin Company", '');
        DNVCrewPayroll.SetRange("Posted In Fin Company", false);
        if DNVCrewPayroll.FindSet()then repeat Commit();
                clear(CuDNVCrewPayrollPost);
                if CuDNVCrewPayrollPost.run(DNVCrewPayroll)then begin
                    DNVCrewPayroll."Posted In Fin Company":=true;
                    if DNVCrewPayroll."Posted In Ship Company" then DNVCrewPayroll.Status:=DNVCrewPayroll.Status::Processed
                    else
                        DNVCrewPayroll.Status:=DNVCrewPayroll.Status::"Finanace Company Processed";
                    DNVCrewPayroll."Error Description":='';
                    DNVCrewPayroll.Modify();
                end
                else
                begin
                    DNVCrewPayroll.Status:=DNVCrewPayroll.Status::Error;
                    DNVCrewPayroll."Error Description":=GetLastErrorText();
                    DNVCrewPayroll.Modify();
                end;
            until DNVCrewPayroll.Next() = 0;
        // Ship shop Company Posting
        DNVCrewPayroll.Reset();
        DNVCrewPayroll.SetFilter(Status, '=%1|%2|%3', DNVCrewPayroll.Status::Error, DNVCrewPayroll.Status::Pending, DNVCrewPayroll.Status::"Finanace Company Processed");
        DNVCrewPayroll.SetRange("Ship Sign Company No", CompanyName);
        DNVCrewPayroll.SetRange("Posted Document No Shp Company", '');
        DNVCrewPayroll.SetRange("Posted In Ship Company", false);
        if DNVCrewPayroll.FindSet()then repeat Commit();
                Clear(CuDNVCrewPayrollPost);
                if CuDNVCrewPayrollPost.run(DNVCrewPayroll)then begin
                    DNVCrewPayroll."Posted In Ship Company":=true;
                    if DNVCrewPayroll."Posted In Fin Company" then DNVCrewPayroll.Status:=DNVCrewPayroll.Status::Processed
                    else
                        DNVCrewPayroll.Status:=DNVCrewPayroll.Status::"Ship Shop Company Processed";
                    DNVCrewPayroll."Error Description":='';
                    DNVCrewPayroll.Modify();
                end
                else
                begin
                    DNVCrewPayroll.Status:=DNVCrewPayroll.Status::Error;
                    DNVCrewPayroll."Error Description":=GetLastErrorText();
                    DNVCrewPayroll.Modify();
                end;
            until DNVCrewPayroll.Next() = 0;
        DNVCrewPayroll.Reset();
        DNVCrewPayroll.SetFilter(Status, '<=%1|%2', DNVCrewPayroll.Status::Processed, DNVCrewPayroll.Status::"Finanace Company Processed");
        DNVCrewPayroll.SetRange("Posted Document No Fin Company", '');
        DNVCrewPayroll.SetRange("Finance Company No", CompanyName);
        if DNVCrewPayroll.FindSet()then repeat GLEntry.Reset();
                GLEntry.SetRange("DNV Crew Payroll Entry No", DNVCrewPayroll."Entry No.");
                GLEntry.SetRange(Reversed, false);
                if GLEntry.FindLast()then begin
                    DNVCrewPayroll."Posted Document No Fin Company":=GLEntry."Document No.";
                    DNVCrewPayroll.Modify();
                end;
            until DNVCrewPayroll.Next() = 0;
        DNVCrewPayroll.Reset();
        DNVCrewPayroll.SetFilter(Status, '<=%1|%2', DNVCrewPayroll.Status::Processed, DNVCrewPayroll.Status::"Ship Shop Company Processed");
        DNVCrewPayroll.SetRange("Posted Document No Shp Company", '');
        DNVCrewPayroll.SetRange("Ship Sign Company No", CompanyName);
        if DNVCrewPayroll.FindSet()then repeat GLEntry.Reset();
                GLEntry.SetRange("DNV Crew Payroll Entry No", DNVCrewPayroll."Entry No.");
                GLEntry.SetRange(Reversed, false);
                if GLEntry.FindLast()then begin
                    DNVCrewPayroll."Posted Document No Shp Company":=GLEntry."Document No.";
                    DNVCrewPayroll.Modify();
                end;
            until DNVCrewPayroll.Next() = 0;
    end;
    procedure CreateNewLines(var mCrewPayroll: Record "PB Crew Payroll Inbound")
    var
        CrewPayrLine: Record "PB Crew Payroll Dim Inb";
        CrewPayrLine_Org: Record "PB Crew Payroll Dim Inb";
        CrewPayHeader: Record "PB Crew Payroll Inbound";
    begin
        CrewPayHeader.Reset();
        CrewPayHeader.SetRange("Transaction Number", mCrewPayroll."Transaction Number");
        CrewPayHeader.SetFilter("Entry No.", '<%1', mCrewPayroll."Entry No.");
        if CrewPayHeader.FindLast()then begin
            if CrewPayHeader."Records Status" <> CrewPayHeader."Records Status"::Delete then begin
                mCrewPayroll.Status:=mCrewPayroll.Status::Cancel;
                mCrewPayroll."Error Description":='AUTO CANCEL- Transaction No sequence is not correct';
                mCrewPayroll.Modify();
                exit;
            end
            else
            begin
                if mCrewPayroll."Posting Date" = 0D then begin
                    mCrewPayroll."Posting Date":=CrewPayHeader."Created At";
                    mCrewPayroll.Modify();
                end;
            end;
        end
        else
        begin
            if mCrewPayroll."Posting Date" = 0D then begin
                mCrewPayroll."Posting Date":=mCrewPayroll."Created At";
                mCrewPayroll.Modify();
            end;
        end;
    end;
    procedure CreateReverseLines(var mCrewPayroll: Record "PB Crew Payroll Inbound")
    var
        CrewPayrLine: Record "PB Crew Payroll Dim Inb";
        CrewPayrLine_Org: Record "PB Crew Payroll Dim Inb";
        CrewPayHeader: Record "PB Crew Payroll Inbound";
    begin
        CrewPayrLine.Reset();
        CrewPayrLine.SetRange("Crew Payroll Entry No.", mCrewPayroll."Entry No.");
        if CrewPayrLine.FindSet()then begin
            CrewPayrLine.DeleteAll();
        end;
        CrewPayHeader.Reset();
        CrewPayHeader.SetRange("Transaction Number", mCrewPayroll."Transaction Number");
        CrewPayHeader.SetFilter("Entry No.", '<%1', mCrewPayroll."Entry No.");
        if CrewPayHeader.FindLast()then begin
            if CrewPayHeader."Records Status" <> CrewPayHeader."Records Status"::New then begin
                mCrewPayroll.Status:=mCrewPayroll.Status::Cancel;
                mCrewPayroll."Error Description":='AUTO CANCEL- Transaction No sequence is not correct';
                mCrewPayroll.Modify();
                exit;
            end;
            CrewPayrLine.Reset();
            CrewPayrLine_Org.Reset();
            CrewPayrLine_Org.SetRange("Crew Payroll Entry No.", CrewPayHeader."Entry No.");
            CrewPayrLine_Org.SetFilter("Total Amount", '<>%1', 0);
            if CrewPayrLine_Org.FindSet()then begin
                repeat CrewPayrLine.Init();
                    CrewPayrLine.TransferFields(CrewPayrLine_Org);
                    CrewPayrLine."Crew Payroll Entry No.":=mCrewPayroll."Entry No.";
                    CrewPayrLine."Total Amount":=-1 * CrewPayrLine_Org."Total Amount";
                    CrewPayrLine.Insert();
                until CrewPayrLine_Org.Next() = 0;
                mCrewPayroll."Created At":=DT2Date(mCrewPayroll.SystemCreatedAt);
                mCrewPayroll."Posting Date":=mCrewPayroll."Created At";
                mCrewPayroll."Crew Personnel Number":=CrewPayHeader."Crew Personnel Number";
                mCrewPayroll."Ship Short Sign":=CrewPayHeader."Ship Short Sign";
                mCrewPayroll."Currency Code":=CrewPayHeader."Currency Code";
                mCrewPayroll."Is Cadet":=CrewPayHeader."Is Cadet";
                mCrewPayroll."Is Paid Out":=CrewPayHeader."Is Paid Out";
                mCrewPayroll."Accounting Area":=CrewPayHeader."Accounting Area";
                mCrewPayroll."Crew Rank":=CrewPayHeader."Crew Rank";
                mCrewPayroll."Payment From":=CrewPayHeader."Payment From";
                mCrewPayroll."Payment To":=CrewPayHeader."Payment To";
                mCrewPayroll.Modify();
                mCrewPayroll."Lines Created":=true;
                mCrewPayroll."Linked Entry No.":=CrewPayHeader."Entry No.";
                mCrewPayroll.Modify();
            end
            else
            begin
                mCrewPayroll.Status:=mCrewPayroll.Status::Cancel;
                mCrewPayroll."Error Description":='AUTO CANCEL- Payroll Data not found';
                mCrewPayroll.Modify();
            end;
        end;
    end;
    procedure SplitCommaString(mstr: Text; mValue: Text)mFound: Boolean var
        SplitStrings: List of[Text];
        S: Text;
    begin
        SplitStrings:=mstr.Split(',');
        foreach S in SplitStrings do begin
            if s = mValue then exit(true);
        end;
        exit(false);
    end;
    procedure ReturnCompanyName(mPBCompanyCode: Text)mBCCompanyName: Text var
        VMT: record VMT;
        CompanyMapping: record "Company Name Mapping";
    begin
        CompanyMapping.Reset();
        CompanyMapping.SetRange("PB Company Code", mPBCompanyCode);
        IF CompanyMapping.FindSet()then exit(CompanyMapping."BC Company Name");
        exit('');
    end;
    procedure ReturnCompanyNamefromShortSign(mShipSign: Text)mBCCompanyName: Text var
        VMT: record VMT;
        CompanyMapping: record "Company Name Mapping";
    begin
        if mShipSign = '' then exit('');
        VMT.Reset();
        vmt.SetFilter(SHIPSIGN, mShipSign);
        IF NOT VMT.FindSet()THEN EXIT('');
        CompanyMapping.Reset();
        CompanyMapping.SetRange("PB Company Code", VMT.DBASE);
        IF CompanyMapping.FindSet()then exit(CompanyMapping."BC Company Name");
        exit('');
    end;
}
