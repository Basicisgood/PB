codeunit 50178 "Central Payment IC Process"
{
    Permissions = tabledata "G/L Entry"=m;

    trigger OnRun()
    var
        CentralpaymentHistory: Record "PB Central Payment History";
        CentralpaymentHistory2: Record "PB Central Payment History";
        CUCEntrPayProcess: Codeunit "IC Central Payment Posting";
        GLEntry: Record "G/L Entry";
        IMOSSetup: Record "IMOS Setup";
    begin
        IMOSSetup.Get();
        CentralpaymentHistory.Reset();
        CentralpaymentHistory.SetRange("Source Gl Entry Document No", '');
        if CentralpaymentHistory.FindSet()then begin
            repeat CentralpaymentHistory."Source Gl Entry Document No":=CentralpaymentHistory."Source Document No";
                CentralpaymentHistory.Modify();
            until CentralpaymentHistory.Next() = 0;
        end;
        Commit();
        CentralpaymentHistory.Reset();
        CentralpaymentHistory.SetFilter(Status, '=%1|%2|%3', CentralpaymentHistory.Status::Pending, CentralpaymentHistory.Status::Error, CentralpaymentHistory.Status::"Target Company Processed");
        CentralpaymentHistory.SetRange("Source Company", CompanyName);
        CentralpaymentHistory.SetRange("Source Processed Document No.", '');
        CentralpaymentHistory.SetRange("Posted in Source Company", false);
        CentralpaymentHistory.SetFilter(FD1, '=%1', '');
        if CentralpaymentHistory.FindSet()then repeat GLEntry.Reset();
                GLEntry.SetRange("Document No.", CentralpaymentHistory."Source Gl Entry Document No");
                GLEntry.SetFilter("Global Dimension 1 Code", '<>%1', '');
                if GLEntry.FindSet()then begin
                    CentralpaymentHistory.FD1:=GLEntry."Global Dimension 1 Code";
                    CentralpaymentHistory.Modify();
                end;
            until CentralpaymentHistory.Next = 0;
        Commit();
        CentralpaymentHistory.Reset();
        CentralpaymentHistory.SetFilter(Status, '=%1|%2|%3', CentralpaymentHistory.Status::Pending, CentralpaymentHistory.Status::Error, CentralpaymentHistory.Status::"Target Company Processed");
        CentralpaymentHistory.SetRange("Source Company", CompanyName);
        CentralpaymentHistory.SetRange("Source Processed Document No.", '');
        CentralpaymentHistory.SetRange("Posted in Source Company", false);
        if CentralpaymentHistory.FindSet()then begin
            repeat if CentralpaymentHistory."Source Gl Entry Document No" = '' then begin
                    CentralpaymentHistory."Source Gl Entry Document No":=CentralpaymentHistory."Source Document No";
                end;
                if(CentralpaymentHistory."Source Company" = CompanyName) and (CentralpaymentHistory."Bank Charges" <> 0)then begin
                    GLEntry.Reset();
                    GLEntry.SetRange("Document No.", CentralpaymentHistory."Source Gl Entry Document No");
                    GLEntry.SetRange("G/L Account No.", IMOSSetup."Bank Charge GL Code");
                    if GLEntry.FindSet()then begin
                        CentralpaymentHistory.FD10:=GLEntry."Shortcut Dimension 10 Code_PB";
                        CentralpaymentHistory.FD3:=GLEntry."Shortcut Dimension 3 Code_PB";
                        CentralpaymentHistory.FD4:=GLEntry."Shortcut Dimension 4 Code_PB";
                        CentralpaymentHistory.FD5:=GLEntry."Shortcut Dimension 5 Code_PB";
                        CentralpaymentHistory.FD1:=GLEntry."Global Dimension 1 Code" end;
                end;
                CentralpaymentHistory.Modify();
                Commit();
                clear(CUCEntrPayProcess);
                if CUCEntrPayProcess.run(CentralpaymentHistory)then begin
                    CentralpaymentHistory."Posted in Source Company":=true;
                    if(CentralpaymentHistory."Posted in Target Company")then CentralpaymentHistory.Status:=CentralpaymentHistory.Status::Processed
                    else
                        CentralpaymentHistory.Status:=CentralpaymentHistory.Status::"Source Copmpany Processed";
                    CentralpaymentHistory."Error Description":='';
                    CentralpaymentHistory.Modify();
                    CentralpaymentHistory2.Reset();
                    CentralpaymentHistory2.SetRange("Source Gl Entry Document No", CentralpaymentHistory."Source Gl Entry Document No");
                    CentralpaymentHistory2.Setrange("Target Company", CentralpaymentHistory."Target Company");
                    CentralpaymentHistory2.SetFilter("Entry No.", '<>%1', CentralpaymentHistory."Entry No.");
                    if CentralpaymentHistory2.FindSet()then repeat CentralpaymentHistory2."Posted in Source Company":=CentralpaymentHistory."Posted in Source Company";
                            CentralpaymentHistory2.Status:=CentralpaymentHistory.Status;
                            CentralpaymentHistory2."Error Description":=CentralpaymentHistory."Error Description";
                            CentralpaymentHistory2.Modify();
                        until CentralpaymentHistory2.Next() = 0;
                end
                else
                begin
                    CentralpaymentHistory.Status:=CentralpaymentHistory.Status::Error;
                    CentralpaymentHistory."Error Description":=GetLastErrorText();
                    CentralpaymentHistory.Modify();
                end;
            until CentralpaymentHistory.Next() = 0;
        end;
        CentralpaymentHistory.Reset();
        CentralpaymentHistory.SetFilter(Status, '=%1|%2|%3', CentralpaymentHistory.Status::Pending, CentralpaymentHistory.Status::Error, CentralpaymentHistory.Status::"Source Copmpany Processed");
        CentralpaymentHistory.SetRange("Target Company", CompanyName);
        CentralpaymentHistory.SetRange("Target Processed Document No.", '');
        CentralpaymentHistory.SetRange("Posted in Target Company", false);
        if CentralpaymentHistory.FindSet()then begin
            repeat Commit();
                clear(CUCEntrPayProcess);
                if CUCEntrPayProcess.run(CentralpaymentHistory)then begin
                    CentralpaymentHistory."Posted in Target Company":=true;
                    if(CentralpaymentHistory."Posted in Source Company")then CentralpaymentHistory.Status:=CentralpaymentHistory.Status::Processed
                    else
                        CentralpaymentHistory.Status:=CentralpaymentHistory.Status::"Target Company Processed";
                    CentralpaymentHistory."Error Description":='';
                    CentralpaymentHistory.Modify();
                end
                else
                begin
                    CentralpaymentHistory.Status:=CentralpaymentHistory.Status::Error;
                    CentralpaymentHistory."Error Description":=GetLastErrorText();
                    CentralpaymentHistory.Modify();
                end;
            until CentralpaymentHistory.Next() = 0;
        end;
        //Update the posted document no
        CentralpaymentHistory.Reset();
        CentralpaymentHistory.SetFilter(Status, '=%1|%2', CentralpaymentHistory.Status::Processed, CentralpaymentHistory.Status::"Target Company Processed");
        CentralpaymentHistory.SetRange("Target Company", CompanyName);
        CentralpaymentHistory.SetRange("Target Processed Document No.", '');
        CentralpaymentHistory.SetRange("Posted in Target Company", true);
        if CentralpaymentHistory.FindSet()then repeat GLEntry.Reset();
                GLEntry.SetCurrentKey("Central Payment Entry No");
                GLEntry.SetRange("Central Payment Entry No", CentralpaymentHistory."Entry No.");
                GLEntry.SetRange(Reversed, false);
                IF GLEntry.FindSet()then begin
                    CentralpaymentHistory."Target Processed Document No.":=GLEntry."Document No.";
                    CentralpaymentHistory.Modify();
                end;
            until CentralpaymentHistory.Next() = 0;
        CentralpaymentHistory.Reset();
        CentralpaymentHistory.SetFilter(Status, '=%1|%2', CentralpaymentHistory.Status::Processed, CentralpaymentHistory.Status::"Source Copmpany Processed");
        CentralpaymentHistory.SetRange("Source Company", CompanyName);
        CentralpaymentHistory.SetRange("Source Processed Document No.", '');
        CentralpaymentHistory.SetRange("Posted in Source Company", true);
        if CentralpaymentHistory.FindSet()then repeat GLEntry.Reset();
                GLEntry.SetCurrentKey("Central Payment Entry No");
                GLEntry.SetRange("Central Payment Entry No", CentralpaymentHistory."Entry No.");
                GLEntry.SetRange(Reversed, false);
                IF GLEntry.FindSet()then begin
                    CentralpaymentHistory."Source Processed Document No.":=GLEntry."Document No.";
                    if GLEntry."Manual Application Needed" then CentralpaymentHistory."Error Description":='Manual Application is required';
                    CentralpaymentHistory.Modify();
                end
                else
                begin
                    CentralpaymentHistory2.Reset();
                    CentralpaymentHistory2.SetRange("Source Gl Entry Document No", CentralpaymentHistory."Source Gl Entry Document No");
                    CentralpaymentHistory2.SetRange("Target Company", CentralpaymentHistory."Target Company");
                    CentralpaymentHistory2.SetFilter("Source Processed Document No.", '<>%1', '');
                    if CentralpaymentHistory2.FindSet()then begin
                        CentralpaymentHistory."Source Processed Document No.":=CentralpaymentHistory2."Source Processed Document No.";
                        CentralpaymentHistory.Modify();
                    end end;
            until CentralpaymentHistory.Next() = 0;
    end;
}
