codeunit 50179 "Global Vendor/Emp Application"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", OnBeforeProcessLines, '', false, false)]
    local procedure "Gen. Jnl.-Post Batch_OnBeforeProcessLines"(var GenJournalLine: Record "Gen. Journal Line"; PreviewMode: Boolean; CommitIsSuppressed: Boolean)
    var
        GVLE: Record "Global Vendor Ledger Entry";
        GVLE2: Record "Global Vendor Ledger Entry";
        GELE: Record "Global Employee Ledger Entry";
        GELE2: Record "Global Employee Ledger Entry";
        GCLE: Record "Global Cust. Ledger entry";
        GCLE2: Record "Global Cust. Ledger entry";
    begin
        IF PreviewMode then exit;
        IF GenJournalLine.FindFirst()then repeat IF GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor then begin
                    GVLE.reset;
                    GVLE.SetRange("Applies-to ID", GenJournalLine."Document No.");
                    GVLE.SetRange("Bank Document No. Applied", GenJournalLine."Bank Document No.");
                    IF GVLE.FindFirst()then repeat IF uppercase(GVLE."Company Name") <> UpperCase(CompanyName)then begin
                                InsertInCentralPaymentHistory(GVLE, GenJournalLine);
                                GVLE2.GET(GVLE."Entry No.", GVLE."Company Name");
                            //GVLE2."Applies-to ID" := '';
                            //GVLE2."Amount to Apply" := 0;
                            //GVLE2."Bank Document No. Applied" := ''; //VJ 11Feb2025
                            //GVLE2.Modify();
                            end;
                        until GVLE.Next() = 0;
                end
                else IF GenJournalLine."Account Type" = GenJournalLine."Account Type"::Employee then begin
                        GELE.reset;
                        GELE.SetRange("Applies-to ID", GenJournalLine."Document No.");
                        GELE.SetRange("Bank Document No. Applied", GenJournalLine."Bank Document No.");
                        IF GELE.FindFirst()then repeat IF uppercase(GELE."Company Code") <> UpperCase(CompanyName)then begin
                                    InsertInCentralPaymentHistoryEmployee(GELE, GenJournalLine);
                                    GELE2.GET(GVLE."Entry No.", GELE."Company Code");
                                //GELE2."Applies-to ID" := '';
                                //GELE2."Amount to Apply" := 0;
                                //GELE2."Bank Document No. Applied" := '';//VJ 11FEB2025
                                //GELE2.Modify();
                                end;
                            until GELE.Next() = 0;
                    end
                    else IF GenJournalLine."Account Type" = GenJournalLine."Account Type"::Customer then begin
                            GCLE.reset;
                            GCLE.SetRange("Applies-to ID", GenJournalLine."Document No.");
                            GCLE.SetRange("Bank Document No. Applied", GenJournalLine."Bank Document No."); //TEC.VJ06MAR2025
                            GCLE.SetRange("Customer No.", GenJournalLine."Account No.");
                            IF GCLE.FindFirst()then repeat IF uppercase(GCLE."Company Name") <> UpperCase(CompanyName)then begin
                                        InsertinCentralPaymentHistory_Customer(GCLE, GenJournalLine);
                                        GCLE2.GET(GCLE."Entry No.", GCLE."Company Name");
                                        //GCLE2."Applies-to ID" := '';
                                        //GCLE2."Amount to Apply" := 0;
                                        //GCLE2."Bank Document No. Applied" := '';//VJ 11FEB2025//TEC.VJ 06MAR2025
                                        GCLE2."Over Receipt Amount":=0;
                                        GCLE2."Bank Charges Amount":=0;
                                        GCLE2.Modify();
                                    end;
                                until GCLE.Next() = 0;
                        end;
            until GenJournalLine.Next() = 0;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", OnAfterCheckDocumentNo, '', false, false)]
    local procedure "Gen. Jnl.-Post Batch_OnAfterCheckDocumentNo"(var GenJournalLine: Record "Gen. Journal Line"; LastDocNo: Code[20]; LastPostedDocNo: Code[20])
    var
        CPH: record "PB Central Payment History";
        GenJnlGUID: Text[100];
        GrapMgmt: Codeunit "Graph Mgt - General Tools";
    begin
        if LastPostedDocNo = '' then exit;
        GenJnlGUID:=GrapMgmt.GetIdWithoutBrackets(GenJournalLine.SystemId);
        CPH.Reset();
        CPH.SetRange("Source Company", CompanyName);
        CPH.SetRange("Gen Jnl Line GUIID", GenJnlGUID);
        if cph.FindSet()then repeat CPH."Source Gl Entry Document No":=LastPostedDocNo;
                cph.Modify();
            until cph.Next() = 0;
    end;
    procedure InsertinCentralPaymentHistory(P_GVLE: Record "Global Vendor Ledger Entry"; P_GJL: Record "Gen. Journal Line")
    var
        CPH: Record "PB Central Payment History";
        BankAccountLedgEntry: record "Bank Account Ledger Entry";
        GraphMgmtTool: Codeunit "Graph Mgt - General Tools";
    begin
        CPH.Init();
        CPH."Entry No.":=0;
        cph."No.":=P_GVLE."Vendor No.";
        CPH."Source Company":=CompanyName;
        CPH."Source Document No":=P_GJL."Document No.";
        CPH.Amount:=P_GVLE."Amount to Apply";
        cph."Exchange Rate":=P_GJL."Currency Factor";
        CPH."Currency Code":=P_GVLE."Currency Code";
        CPH."Target Company":=P_GVLE."Company Name";
        CPH."Applied Document No.":=P_GVLE."Document No.";
        CPH."Creation DatenTime":=CurrentDateTime;
        CPH."Posting Date":=P_GJL."Posting Date";
        CPH."Document Date":=P_GJL."Document Date";
        CPH."Gen Jnl Line GUIID":=GraphMgmtTool.GetIdWithoutBrackets(P_GJL.SystemId);
        cph."Bank Document No.":=P_GJL."Bank Document No.";
        cph."Invoice External No.":=P_GVLE."External Document No.";
        if P_GVLE."IMOS Transaction No" <> '' then CPH."IMOS Transaction No":=P_GVLE."IMOS Transaction No";
        CPH."Entry Type":=CPH."Entry Type"::Vendor;
        cph."Bank ID":=P_GJL."IMOS Bank ID";
        if cph."Bank ID" = '' then begin
            BankAccountLedgEntry.Reset();
            BankAccountLedgEntry.SetRange("Document No.", CPH."Source Document No");
            if BankAccountLedgEntry.FindSet()then cph."Bank ID":=BankAccountLedgEntry."Bank Account No.";
        end;
        CPH.Insert();
    end;
    procedure InsertinCentralPaymentHistory_Customer(P_GCLE: Record "Global Cust. Ledger entry"; P_GJL: Record "Gen. Journal Line")
    var
        CPH: Record "PB Central Payment History";
        BankAccountLedgEntry: record "Bank Account Ledger Entry";
        GraphMgmtTool: Codeunit "Graph Mgt - General Tools";
    begin
        CPH.Init();
        CPH."Entry No.":=0;
        cph."No.":=P_GCLE."Customer No.";
        CPH."Source Company":=CompanyName;
        CPH."Source Document No":=P_GJL."Document No.";
        CPH.Amount:=P_GCLE."Amount to Apply";
        cph."Exchange Rate":=P_GJL."Currency Factor";
        CPH."Currency Code":=P_GCLE."Currency Code";
        CPH."Target Company":=P_GCLE."Company Name";
        CPH."Applied Document No.":=P_GCLE."Document No.";
        CPH."Creation DatenTime":=CurrentDateTime;
        if CPH.Amount > 0 then CPH."Over Receipt Amount":=P_GCLE."Over Receipt Amount";
        CPH."Bank Charges":=P_GCLE."Bank Charges Amount";
        CPH."Posting Date":=P_GJL."Posting Date";
        cph."Document Date":=P_GJL."Document Date";
        CPH."Gen Jnl Line GUIID":=GraphMgmtTool.GetIdWithoutBrackets(P_GJL.SystemId);
        cph."Bank Document No.":=P_GJL."Bank Document No.";
        cph."Invoice External No.":=P_GCLE."External Document No.";
        cph."Bank ID":=P_GJL."IMOS Bank ID";
        if P_GCLE."IMOS Transaction No" <> '' then CPH."IMOS Transaction No":=P_GCLE."IMOS Transaction No";
        CPH."Entry Type":=CPH."Entry Type"::Customer;
        if cph."Bank ID" = '' then begin
            BankAccountLedgEntry.Reset();
            BankAccountLedgEntry.SetRange("Document No.", CPH."Source Document No");
            if BankAccountLedgEntry.FindSet()then cph."Bank ID":=BankAccountLedgEntry."Bank Account No.";
        end;
        CPH.Insert();
    end;
    procedure InsertinCentralPaymentHistoryEmployee(P_GELE: Record "Global Employee Ledger Entry"; P_GJL: Record "Gen. Journal Line")
    var
        CPH: Record "PB Central Payment History";
        GraphMgmtTool: Codeunit "Graph Mgt - General Tools";
    begin
        CPH.Init();
        CPH."Entry No.":=0;
        cph."No.":=P_GELE."Employee No.";
        CPH."Source Company":=CompanyName;
        CPH."Source Document No":=P_GJL."Document No.";
        cph."Exchange Rate":=P_GJL."Currency Factor";
        CPH.Amount:=P_GELE."Amount to Apply";
        CPH."Currency Code":=P_GELE."Currency Code";
        CPH."Target Company":=P_GELE."Company Code";
        CPH."Applied Document No.":=P_GELE."Document No.";
        CPH."Creation DatenTime":=CurrentDateTime;
        CPH."Posting Date":=P_GJL."Posting Date";
        cph."Document Date":=P_GJL."Document Date";
        CPH."Entry Type":=CPH."Entry Type"::Employee;
        cph."Gen Jnl Line GUIID":=GraphMgmtTool.GetIdWithoutBrackets(P_GELE.SystemId);
        CPH.Insert();
    end;
    procedure GetLastEntryNo(): Integer var
        CPH: Record "PB Central Payment History";
    begin
        IF CPH.FindLast()then exit(CPH."Entry No.")
        else
            exit(0);
    end;
}
