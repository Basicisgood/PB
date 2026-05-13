codeunit 50100 "Common Functions"
{
    Permissions = tabledata "Vendor Ledger Entry"=RM,
        tabledata "Employee Ledger Entry"=RM,
        tabledata "Cust. Ledger Entry"=RM,
        tabledata "Approval Entry"=RM;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Vend. Entry-Edit", 'OnBeforeVendLedgEntryModify', '', false, false)]
    local procedure OnBeforeVendLedgEntryModify(FromVendLedgEntry: Record "Vendor Ledger Entry"; var VendLedgEntry: Record "Vendor Ledger Entry")
    var
        CuExternalDOcUpdate: Codeunit ExternalDocUpdate;
        cu90: Codeunit 90;
    begin
        if FromVendLedgEntry."External Document No." <> VendLedgEntry."External Document No." then CuExternalDOcUpdate.OnBeforeVendLedgEntryModify(VendLedgEntry, FromVendLedgEntry);
        VendLedgEntry."Payment Date":=FromVendLedgEntry."Payment Date";
        VendLedgEntry."External Document No.":=FromVendLedgEntry."External Document No.";
        VendLedgEntry."IMOS Transaction No":=FromVendLedgEntry."IMOS Transaction No";
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnAfterInitGLEntry, '', true, true)]
    local procedure OnAfterInitGLEntry(var GLEntry: Record "G/L Entry")
    var
        L_ConcurInboundMaster: Record "Concur Inbound Master";
        L_ConcurCashAdv: Record "Concur Cash Advance";
    //Sgarg - Added
    begin
        IF GLEntry.IsTemporary then exit;
        IF NOT GLEntry."Cash Advance" then begin
            IF(GLEntry."Report ID" <> '') AND (GLEntry."External Document No." <> '')then begin
                // IF L_ConcurInboundMaster.GET(GLEntry."Report ID", GLEntry."External Document No.", GLEntry."Ship Company Code") then begin
                IF L_ConcurInboundMaster.GET(GLEntry."Report ID", GLEntry."Original Ex Doc No.", GLEntry."Ship Company Code")then begin
                    IF(GLEntry."Is Ship Run") AND (L_ConcurInboundMaster."Ship Company Posted Doc No." = '')then begin
                        L_ConcurInboundMaster."Ship Company Posted Doc No.":=GLEntry."Document No.";
                        L_ConcurInboundMaster.Modify;
                    end
                    ELSE IF(NOT GLEntry."Is Ship Run") AND (L_ConcurInboundMaster."Fin Company Posted Doc No." = '')then begin
                            L_ConcurInboundMaster."Fin Company Posted Doc No.":=GLEntry."Document No.";
                            L_ConcurInboundMaster.Modify;
                        end;
                end;
            end;
        end
        else
        begin
            L_ConcurCashAdv.SetCurrentKey(CashAdvanceId);
            L_ConcurCashAdv.SetRange(CashAdvanceId, GLEntry."Report ID");
            IF L_ConcurCashAdv.FindFirst()then begin
                L_ConcurCashAdv."Posted Document No.":=GLEntry."Document No.";
                L_ConcurCashAdv.Modify();
            end;
        end;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnBeforeTrySendJournalLineApprovalRequests', '', false, false)]
    local procedure OnBeforeTrySendJournalLineApprovalRequests(var GenJournalLine: Record "Gen. Journal Line")
    var
        GenJnlBatch_l: Record "Gen. Journal Batch";
    begin
        exit;
        GenJnlBatch_l.Reset();
        GenJnlBatch_l.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name");
        GenJnlBatch_l.TestField("Review Status", GenJnlBatch_l."Review Status"::Reviewed);
    // IF NOT (UserId = GenJnlBatch_l."Reviewer User") then
    //     Error(ErrorUser);
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSendGeneralJournalBatchForApproval', '', false, false)]
    local procedure OnSendGeneralJournalBatchForApproval(var GenJournalBatch: Record "Gen. Journal Batch")
    var
        GenJnlBatch_l: Record "Gen. Journal Batch";
    begin
        exit;
        GenJnlBatch_l.Reset();
        GenJnlBatch_l.Get(GenJournalBatch."Journal Template Name", GenJournalBatch.Name);
        GenJnlBatch_l.TestField("Review Status", GenJnlBatch_l."Review Status"::Reviewed);
    // IF NOT (UserId = GenJournalBatch."Reviewer User") then
    //     Error(ErrorUser);
    end;
    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", OnAfterCopyGLEntryFromGenJnlLine, '', false, false)]
    local procedure "G/L Entry_OnAfterCopyGLEntryFromGenJnlLine"(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    var
        PBCommitedCost: Record "PB Committed Cost Inbound";
        PBCommitedCostDetails: Record "DNV Commited Cost Details";
    begin
        GLEntry."DNV Staging Entry No.":=GenJournalLine."DNV Staging Entry No.";
        GLEntry."Original Invoice No":=GenJournalLine."Original Invoice No";
        GLEntry."IMOS Bank ID":=GenJournalLine."IMOS Bank ID";
        GLEntry."DNV Crew Payroll Entry No":=GenJournalLine."DNV Crew Payroll Entry No";
        GLEntry."Central Payment Entry No":=GenJournalLine."Central Payment Entry No";
        GLEntry."Central Pay. Parent Entry No":=GenJournalLine."Central Pay. Parent Entry No";
        GLEntry."IMOS invoice":=GenJournalLine."IMOS invoice";
        GLEntry."IMOS Transaction No":=GenJournalLine."IMOS Transaction No";
        GLEntry."Remittance Account No":=GenJournalLine."Remittance Account No";
        GLEntry."Remittance Company No":=GenJournalLine."Remittance Company No";
        GLEntry."Remittance Full Name":=GenJournalLine."Remittance Full Name";
        GLEntry."Bank Document No.":=GenJournalLine."Bank Document No."; //TEC.VJ 18DEC2024
        GLEntry."Ship Manager Id":=GenJournalLine."Ship Manager Id";
        GLEntry."Manual Application Needed":=GenJournalLine."Manual Application Needed";
        GLEntry."Concur ID":=GenJournalLine."Concur ID"; //Sgarg-Added
        GLEntry."Report ID":=GenJournalLine."Report ID"; //Sgarg-Added
        GLEntry."Entry Id":=GenJournalLine."Entry Id"; //Sgarg-Added
        GLEntry."Original Ex Doc No.":=GenJournalLine."Original Ex Doc No."; //Created on 280525
        GLEntry."Receipt image ID":=GenJournalLine."Receipt image ID"; //Sgarg-
        GLEntry."Is Ship Run":=GenJournalLine."Is Ship Run"; //Sgarg
        GLEntry."Fin Company Code":=GenJournalLine."Fin Company Code"; //Sgarg
        GLEntry."Ship Company Code":=GenJournalLine."Ship Company Code"; //Sgarg
        GLEntry."Cash Advance":=GenJournalLine."Cash Advance"; //Sgarg
        GLEntry."GL Reval":=GenJournalLine."GL Reval"; //sgarg
        GLEntry."PB Concur invoice":=GenJournalLine."PB Concur invoice"; //#329 TEC.VJ 08MAY2025
        GLEntry."Marcura Entry No":=GenJournalLine."Marcura Entry No";
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnBeforeValidatePostingAndDocumentDate, '', false, false)]
    local procedure OnBeforeValidatePostingAndDocumentDate(var PurchaseHeader: Record "Purchase Header")
    begin
        If PurchaseHeader.Invoice then begin
            PurchaseHeader.TestField("Invoice Link");
        end;
    end;
    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure InsertGlobalVLE(var Rec: Record "Vendor Ledger Entry"; RunTrigger: Boolean)
    var
        GlobalVLE: Record "Global Vendor Ledger Entry";
    begin
        if IsTestCompany()then exit;
        if rec.IsTemporary then exit;
        GlobalVLE.Init();
        GlobalVLE.TransferFields(Rec);
        GlobalVLE."Company Name":=CompanyName;
        GlobalVLE.Insert();
    end;
    [EventSubscriber(ObjectType::Table, Database::"Detailed Cust. Ledg. Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure InsertGlobalDeVLE(var Rec: Record "Detailed Cust. Ledg. Entry"; RunTrigger: Boolean)
    var
        GlobalDeVLE: Record "GB Detailed Cust. Ledg. Entry";
    begin
        if IsTestCompany()then exit;
        if rec.IsTemporary then exit;
        GlobalDeVLE.Init();
        GlobalDeVLE.TransferFields(Rec);
        GlobalDeVLE."Company Name":=CompanyName;
        GlobalDeVLE.Insert();
    end;
    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", OnAfterModifyEvent, '', false, false)]
    local procedure ModifyGlobalVLE(var Rec: Record "Vendor Ledger Entry"; RunTrigger: Boolean)
    var
        GlobalVLE: Record "Global Vendor Ledger Entry";
    begin
        if IsTestCompany()then exit;
        if rec.IsTemporary then exit;
        if GlobalVLE.Get(Rec."Entry No.", CompanyName)then begin
            GlobalVLE.TransferFields(Rec);
            GlobalVLE.Modify(true); //VJ 11Feb2025
        end;
    end;
    [EventSubscriber(ObjectType::Table, Database::"Detailed Cust. Ledg. Entry", OnAfterModifyEvent, '', false, false)]
    local procedure ModifyGlobalDeVLE(var Rec: Record "Detailed Cust. Ledg. Entry"; RunTrigger: Boolean)
    var
        GlobalDeVLE: Record "GB Detailed Cust. Ledg. Entry";
    begin
        if IsTestCompany()then exit;
        if rec.IsTemporary then exit;
        GlobalDeVLE.Get(Rec."Entry No.", CompanyName);
        GlobalDeVLE.TransferFields(Rec);
        GlobalDeVLE.Modify();
    end;
    [EventSubscriber(ObjectType::Table, Database::"Employee Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure InsertGlobalELE(var Rec: Record "Employee Ledger Entry"; RunTrigger: Boolean)
    var
        GlobalELE: Record "Global Employee Ledger Entry";
    begin
        if IsTestCompany()then exit;
        if rec.IsTemporary then exit;
        GlobalELE.Init();
        GlobalELE.TransferFields(Rec);
        GlobalELE."Company Code":=CompanyName;
        GlobalELE.Insert();
    end;
    [EventSubscriber(ObjectType::Table, Database::"Employee Ledger Entry", OnAfterModifyEvent, '', false, false)]
    local procedure ModifyGlobalELE(var Rec: Record "Employee Ledger Entry"; RunTrigger: Boolean)
    var
        GlobalELE: Record "Global Employee Ledger Entry";
    begin
        if IsTestCompany()then exit;
        if rec.IsTemporary then exit;
        if GlobalELE.Get(Rec."Entry No.", CompanyName)then begin
            GlobalELE.TransferFields(Rec);
            GlobalELE.Modify();
        end end;
    [EventSubscriber(ObjectType::Table, Database::"Detailed Employee Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure InsertGlobalDELE(var Rec: Record "Detailed Employee Ledger Entry"; RunTrigger: Boolean)
    var
        GlobalDELE: Record "GB Det. Employee Ledger Entry";
    begin
        if IsTestCompany()then exit;
        if rec.IsTemporary then exit;
        GlobalDELE.Init();
        GlobalDELE.TransferFields(Rec);
        GlobalDELE."Company Code":=CompanyName;
        GlobalDELE.Insert();
    end;
    [EventSubscriber(ObjectType::Table, Database::"Detailed Employee Ledger Entry", OnAfterModifyEvent, '', false, false)]
    local procedure ModifyGlobalDELE(var Rec: Record "Detailed Employee Ledger Entry"; RunTrigger: Boolean)
    var
        GlobalDELE: Record "GB Det. Employee Ledger Entry";
    begin
        if IsTestCompany()then exit;
        if rec.IsTemporary then exit;
        GlobalDELE.Get(Rec."Entry No.", CompanyName);
        GlobalDELE.TransferFields(Rec);
        GlobalDELE.Modify();
    end;
    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure InsertGlobalCLE(var Rec: Record "Cust. Ledger Entry"; RunTrigger: Boolean)
    var
        GlobalVLE: Record "Global Cust. Ledger entry";
    begin
        if IsTestCompany()then exit;
        if rec.IsTemporary then exit;
        GlobalVLE.Init();
        GlobalVLE.TransferFields(Rec);
        GlobalVLE."Company Name":=CompanyName;
        GlobalVLE.Insert();
    end;
    [EventSubscriber(ObjectType::Table, Database::"Detailed Cust. Ledg. Entry", OnAfterModifyEvent, '', false, false)]
    local procedure ModifyGlobalDeCLE(var Rec: Record "Detailed Cust. Ledg. Entry"; RunTrigger: Boolean)
    var
        GlobalDeVLE: Record "GB Detailed Cust. Ledg. Entry";
    begin
        if IsTestCompany()then exit;
        if rec.IsTemporary then exit;
        GlobalDeVLE.get(Rec."Entry No.", CompanyName);
        GlobalDeVLE.TransferFields(Rec);
        GlobalDeVLE.Modify();
    end;
    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", OnAfterModifyEvent, '', false, false)]
    local procedure ModifyGlobalCLE(var Rec: Record "Cust. Ledger Entry"; RunTrigger: Boolean)
    var
        GlobalVLE: Record "Global Cust. Ledger entry";
    begin
        if IsTestCompany()then exit;
        if rec.IsTemporary then exit;
        GlobalVLE.get(Rec."Entry No.", CompanyName);
        GlobalVLE.TransferFields(Rec);
        GlobalVLE.Modify();
    end;
    [EventSubscriber(ObjectType::Table, Database::"Detailed Vendor Ledg. Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure InsertGlobalDeCLE(var Rec: Record "Detailed Vendor Ledg. Entry"; RunTrigger: Boolean)
    var
        GlobalDeVLE: Record "GB Detailed Vendor Ledg. Entry";
    begin
        if IsTestCompany()then exit;
        if rec.IsTemporary then exit;
        GlobalDeVLE.Init();
        GlobalDeVLE.TransferFields(Rec);
        GlobalDeVLE."Company Name":=CompanyName;
        GlobalDeVLE.Insert();
    end;
    [EventSubscriber(ObjectType::Table, Database::"G/l Entry", OnAfterModifyEvent, '', false, false)]
    local procedure ModifyGLE(var Rec: Record "G/L Entry"; var xRec: Record "G/L Entry"; RunTrigger: Boolean)
    var
        glSetup: Record "General Ledger Setup";
        DimSetEntry: record "Dimension Set Entry";
        VLE: record "Vendor Ledger Entry";
        CLE: record "Cust. Ledger Entry";
        ELE: record "Employee Ledger Entry";
        GVLE: record "Global Vendor Ledger Entry";
        GCLE: record "Global Cust. Ledger entry";
        GELE: record "Global Employee Ledger Entry";
    begin
        if xRec."Dimension Set ID" <> rec."Dimension Set ID" then begin
            rec."Shortcut Dimension 3 Code_PB":='';
            rec."Shortcut Dimension 4 Code_PB":='';
            rec."Shortcut Dimension 5 Code_PB":='';
            rec."Shortcut Dimension 6 Code_PB":='';
            rec."Shortcut Dimension 7 Code_PB":='';
            rec."Shortcut Dimension 8 Code_PB":='';
            rec."Shortcut Dimension 9 Code_PB":='';
            rec."Shortcut Dimension 10 Code_PB":='';
            rec."Shortcut Dimension 11 Code_PB":='';
            rec."Shortcut Dimension 12 Code_PB":='';
            rec."Shortcut Dimension 13 Code_PB":='';
            rec."Shortcut Dimension 14 Code_PB":='';
            rec."Shortcut Dimension 15 Code_PB":='';
            DimSetEntry.Reset();
            DimSetEntry.SetRange("Dimension Set ID", rec."Dimension Set ID");
            if DimSetEntry.FindSet()then repeat if DimSetEntry."Dimension Code" = glSetup."Shortcut Dimension 3 Code" then rec."Shortcut Dimension 3 Code_PB":=DimSetEntry."Dimension Value Code";
                    if DimSetEntry."Dimension Code" = glSetup."Shortcut Dimension 4 Code" then rec."Shortcut Dimension 4 Code_PB":=DimSetEntry."Dimension Value Code";
                    if DimSetEntry."Dimension Code" = glSetup."Shortcut Dimension 5 Code" then rec."Shortcut Dimension 5 Code_PB":=DimSetEntry."Dimension Value Code";
                    if DimSetEntry."Dimension Code" = glSetup."Shortcut Dimension 6 Code" then rec."Shortcut Dimension 6 Code_PB":=DimSetEntry."Dimension Value Code";
                    if DimSetEntry."Dimension Code" = glSetup."Shortcut Dimension 7 Code" then rec."Shortcut Dimension 7 Code_PB":=DimSetEntry."Dimension Value Code";
                    if DimSetEntry."Dimension Code" = glSetup."Shortcut Dimension 8 Code" then rec."Shortcut Dimension 8 Code_PB":=DimSetEntry."Dimension Value Code";
                    if DimSetEntry."Dimension Code" = glSetup."Shortcut Dimension 9 Code" then rec."Shortcut Dimension 9 Code_PB":=DimSetEntry."Dimension Value Code";
                    if DimSetEntry."Dimension Code" = glSetup."Shortcut Dimension 10 Code" then rec."Shortcut Dimension 10 Code_PB":=DimSetEntry."Dimension Value Code";
                    if DimSetEntry."Dimension Code" = glSetup."Shortcut Dimension 11 Code" then rec."Shortcut Dimension 11 Code_PB":=DimSetEntry."Dimension Value Code";
                    if DimSetEntry."Dimension Code" = glSetup."Shortcut Dimension 12 Code" then rec."Shortcut Dimension 12 Code_PB":=DimSetEntry."Dimension Value Code";
                    if DimSetEntry."Dimension Code" = glSetup."Shortcut Dimension 13 Code" then rec."Shortcut Dimension 13 Code_PB":=DimSetEntry."Dimension Value Code";
                    if DimSetEntry."Dimension Code" = glSetup."Shortcut Dimension 14 Code" then rec."Shortcut Dimension 14 Code_PB":=DimSetEntry."Dimension Value Code";
                    if DimSetEntry."Dimension Code" = glSetup."Shortcut Dimension 15 Code" then rec."Shortcut Dimension 15 Code_PB":=DimSetEntry."Dimension Value Code";
                    rec.Modify();
                    // Vendor  Global Vendor
                    if VLE.Get(Rec."Entry No.")then begin
                        vle."Shortcut Dimension 3 Code_PB":=Rec."Shortcut Dimension 3 Code_PB";
                        vle."Shortcut Dimension 4 Code_PB":=Rec."Shortcut Dimension 4 Code_PB";
                        vle."Shortcut Dimension 5 Code_PB":=Rec."Shortcut Dimension 5 Code_PB";
                        vle."Shortcut Dimension 6 Code_PB":=Rec."Shortcut Dimension 6 Code_PB";
                        vle."Shortcut Dimension 7 Code_PB":=Rec."Shortcut Dimension 7 Code_PB";
                        vle."Shortcut Dimension 8 Code_PB":=Rec."Shortcut Dimension 8 Code_PB";
                        vle."Shortcut Dimension 9 Code_PB":=Rec."Shortcut Dimension 9 Code_PB";
                        vle."Shortcut Dimension 10 Code_PB":=Rec."Shortcut Dimension 10 Code_PB";
                        vle."Shortcut Dimension 11 Code_PB":=Rec."Shortcut Dimension 11 Code_PB";
                        vle."Shortcut Dimension 12 Code_PB":=Rec."Shortcut Dimension 12 Code_PB";
                        vle."Shortcut Dimension 13 Code_PB":=Rec."Shortcut Dimension 13 Code_PB";
                        vle."Shortcut Dimension 14 Code_PB":=Rec."Shortcut Dimension 14 Code_PB";
                        vle."Shortcut Dimension 15 Code_PB":=Rec."Shortcut Dimension 15 Code_PB";
                        vle.Modify();
                        if GVLE.Get(Rec."Entry No.", CompanyName)then begin
                            GVLE."Shortcut Dimension 3 Code_PB":=Rec."Shortcut Dimension 3 Code_PB";
                            GVLE."Shortcut Dimension 4 Code_PB":=Rec."Shortcut Dimension 4 Code_PB";
                            GVLE."Shortcut Dimension 5 Code_PB":=Rec."Shortcut Dimension 5 Code_PB";
                            GVLE."Shortcut Dimension 6 Code_PB":=Rec."Shortcut Dimension 6 Code_PB";
                            GVLE."Shortcut Dimension 7 Code_PB":=Rec."Shortcut Dimension 7 Code_PB";
                            GVLE."Shortcut Dimension 8 Code_PB":=Rec."Shortcut Dimension 8 Code_PB";
                            GVLE."Shortcut Dimension 9 Code_PB":=Rec."Shortcut Dimension 9 Code_PB";
                            GVLE."Shortcut Dimension 10 Code_PB":=Rec."Shortcut Dimension 10 Code_PB";
                            GVLE."Shortcut Dimension 11 Code_PB":=Rec."Shortcut Dimension 11 Code_PB";
                            GVLE."Shortcut Dimension 12 Code_PB":=Rec."Shortcut Dimension 12 Code_PB";
                            GVLE."Shortcut Dimension 13 Code_PB":=Rec."Shortcut Dimension 13 Code_PB";
                            GVLE."Shortcut Dimension 14 Code_PB":=Rec."Shortcut Dimension 14 Code_PB";
                            GVLE."Shortcut Dimension 15 Code_PB":=Rec."Shortcut Dimension 15 Code_PB";
                            GVLE.Modify(true);
                        end;
                        //Customer and global Customer
                        if CLE.Get(Rec."Entry No.")then begin
                            CLE."Shortcut Dimension 3 Code_PB":=Rec."Shortcut Dimension 3 Code_PB";
                            CLE."Shortcut Dimension 4 Code_PB":=Rec."Shortcut Dimension 4 Code_PB";
                            CLE."Shortcut Dimension 5 Code_PB":=Rec."Shortcut Dimension 5 Code_PB";
                            CLE."Shortcut Dimension 6 Code_PB":=Rec."Shortcut Dimension 6 Code_PB";
                            CLE."Shortcut Dimension 7 Code_PB":=Rec."Shortcut Dimension 7 Code_PB";
                            CLE."Shortcut Dimension 8 Code_PB":=Rec."Shortcut Dimension 8 Code_PB";
                            CLE."Shortcut Dimension 9 Code_PB":=Rec."Shortcut Dimension 9 Code_PB";
                            CLE."Shortcut Dimension 10 Code_PB":=Rec."Shortcut Dimension 10 Code_PB";
                            CLE."Shortcut Dimension 11 Code_PB":=Rec."Shortcut Dimension 11 Code_PB";
                            CLE."Shortcut Dimension 12 Code_PB":=Rec."Shortcut Dimension 12 Code_PB";
                            CLE."Shortcut Dimension 13 Code_PB":=Rec."Shortcut Dimension 13 Code_PB";
                            CLE."Shortcut Dimension 14 Code_PB":=Rec."Shortcut Dimension 14 Code_PB";
                            CLE."Shortcut Dimension 15 Code_PB":=Rec."Shortcut Dimension 15 Code_PB";
                            CLE.Modify();
                            if GCLE.Get(Rec."Entry No.", CompanyName)then begin
                                GCLE."Shortcut Dimension 3 Code_PB":=Rec."Shortcut Dimension 3 Code_PB";
                                GCLE."Shortcut Dimension 4 Code_PB":=Rec."Shortcut Dimension 4 Code_PB";
                                GCLE."Shortcut Dimension 5 Code_PB":=Rec."Shortcut Dimension 5 Code_PB";
                                GCLE."Shortcut Dimension 6 Code_PB":=Rec."Shortcut Dimension 6 Code_PB";
                                GCLE."Shortcut Dimension 7 Code_PB":=Rec."Shortcut Dimension 7 Code_PB";
                                GCLE."Shortcut Dimension 8 Code_PB":=Rec."Shortcut Dimension 8 Code_PB";
                                GCLE."Shortcut Dimension 9 Code_PB":=Rec."Shortcut Dimension 9 Code_PB";
                                GCLE."Shortcut Dimension 10 Code_PB":=Rec."Shortcut Dimension 10 Code_PB";
                                GCLE."Shortcut Dimension 11 Code_PB":=Rec."Shortcut Dimension 11 Code_PB";
                                GCLE."Shortcut Dimension 12 Code_PB":=Rec."Shortcut Dimension 12 Code_PB";
                                GCLE."Shortcut Dimension 13 Code_PB":=Rec."Shortcut Dimension 13 Code_PB";
                                GCLE."Shortcut Dimension 14 Code_PB":=Rec."Shortcut Dimension 14 Code_PB";
                                GCLE."Shortcut Dimension 15 Code_PB":=Rec."Shortcut Dimension 15 Code_PB";
                                GCLE.Modify();
                            end;
                        end;
                        //Employee and global Employee
                        if ELE.Get(Rec."Entry No.")then begin
                            ELE."Shortcut Dimension 3 Code_PB":=Rec."Shortcut Dimension 3 Code_PB";
                            ELE."Shortcut Dimension 4 Code_PB":=Rec."Shortcut Dimension 4 Code_PB";
                            ELE."Shortcut Dimension 5 Code_PB":=Rec."Shortcut Dimension 5 Code_PB";
                            ELE."Shortcut Dimension 6 Code_PB":=Rec."Shortcut Dimension 6 Code_PB";
                            ELE."Shortcut Dimension 7 Code_PB":=Rec."Shortcut Dimension 7 Code_PB";
                            ELE."Shortcut Dimension 8 Code_PB":=Rec."Shortcut Dimension 8 Code_PB";
                            ELE."Shortcut Dimension 9 Code_PB":=Rec."Shortcut Dimension 9 Code_PB";
                            ELE."Shortcut Dimension 10 Code_PB":=Rec."Shortcut Dimension 10 Code_PB";
                            ELE."Shortcut Dimension 11 Code_PB":=Rec."Shortcut Dimension 11 Code_PB";
                            ELE."Shortcut Dimension 12 Code_PB":=Rec."Shortcut Dimension 12 Code_PB";
                            ELE."Shortcut Dimension 13 Code_PB":=Rec."Shortcut Dimension 13 Code_PB";
                            ELE."Shortcut Dimension 14 Code_PB":=Rec."Shortcut Dimension 14 Code_PB";
                            ELE."Shortcut Dimension 15 Code_PB":=Rec."Shortcut Dimension 15 Code_PB";
                            ELE.Modify();
                            if GELE.Get(Rec."Entry No.", CompanyName)then begin
                                GELE."Shortcut Dimension 3 Code_PB":=Rec."Shortcut Dimension 3 Code_PB";
                                GELE."Shortcut Dimension 4 Code_PB":=Rec."Shortcut Dimension 4 Code_PB";
                                GELE."Shortcut Dimension 5 Code_PB":=Rec."Shortcut Dimension 5 Code_PB";
                                GELE."Shortcut Dimension 6 Code_PB":=Rec."Shortcut Dimension 6 Code_PB";
                                GELE."Shortcut Dimension 7 Code_PB":=Rec."Shortcut Dimension 7 Code_PB";
                                GELE."Shortcut Dimension 8 Code_PB":=Rec."Shortcut Dimension 8 Code_PB";
                                GELE."Shortcut Dimension 9 Code_PB":=Rec."Shortcut Dimension 9 Code_PB";
                                GELE."Shortcut Dimension 10 Code_PB":=Rec."Shortcut Dimension 10 Code_PB";
                                GELE."Shortcut Dimension 11 Code_PB":=Rec."Shortcut Dimension 11 Code_PB";
                                GELE."Shortcut Dimension 12 Code_PB":=Rec."Shortcut Dimension 12 Code_PB";
                                GELE."Shortcut Dimension 13 Code_PB":=Rec."Shortcut Dimension 13 Code_PB";
                                GELE."Shortcut Dimension 14 Code_PB":=Rec."Shortcut Dimension 14 Code_PB";
                                GELE."Shortcut Dimension 15 Code_PB":=Rec."Shortcut Dimension 15 Code_PB";
                                GELE.Modify();
                            end;
                        end;
                    end;
                until DimSetEntry.Next() = 0;
        end;
    end;
    [EventSubscriber(ObjectType::Table, Database::Vendor, OnBeforeValidateEvent, Name, false, false)]
    local procedure OnBeforeValidateEvent_Vendor_Name(var Rec: Record Vendor)
    var
        Vendor_l: Record Vendor;
        NameDuplicate: Label '%1 already exist for record %2';
    begin
        Vendor_l.Reset();
        Vendor_l.SetRange(Name, Rec.Name);
        If Vendor_l.FindFirst()then Message(NameDuplicate, Vendor_l.Name, Vendor_l."No.");
    end;
    [EventSubscriber(ObjectType::Table, Database::Customer, OnBeforeValidateEvent, Name, false, false)]
    local procedure OnBeforeValidateEvent_Customer_Name(var Rec: Record Customer)
    var
        Cust_l: Record Customer;
        NameDuplicate: Label '%1 already exist for record %2';
    begin
        Cust_l.Reset();
        Cust_l.SetRange(Name, Rec.Name);
        If Cust_l.FindFirst()then Message(NameDuplicate, Cust_l.Name, Cust_l."No.");
    end;
    procedure IsTestCompany(): Boolean var
        CompanyNameMapping: Record "Company Name Mapping";
    begin
        CompanyNameMapping.Get(CompanyName);
        exit(CompanyNameMapping."Test Company");
    end;
    procedure IsMasterCompany(): Boolean var
        CompanyNameMapping: Record "Company Name Mapping";
    begin
        CompanyNameMapping.Get(CompanyName);
        exit(CompanyNameMapping."Master Data Company");
    end;
    procedure CreateBankDocuemntNo(var GenJournalLine: Record "Gen. Journal Line")
    var
        NoSeriesMgmt: Codeunit "No. Series";
        l_GLSetup: Record "General Ledger Setup";
        GenJnlBatch: Record "Gen. Journal Batch";
    begin
        l_GLSetup.Get();
        if GenJnlBatch.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name") and (GenJnlBatch."Bank Transfer" = false) and (GenJournalLine."Source Code" = 'INTERCOMP')then exit; //#274 TEC.VJ 18MAR2025
        IF l_GLSetup."Bank Document Nos." = '' then exit;
        if(GenJournalLine."Bank Document No." <> '')then exit;
        if(GenJournalLine."Source Code" = 'INTERCOMP') and (CheckIfRequiredToGenerate(GenJournalLine) = false)then exit; //#274 TEC.VJ 19MAR2025
        GenJournalLine."Bank Document No.":=NoSeriesMgmt.GetNextNo(l_GLSetup."Bank Document Nos.", GenJournalLine."Posting Date");
    end;
    procedure CheckIfRequiredToGenerate(var GenJournalLine: Record "Gen. Journal Line"): Boolean var
        GenJournalLine2: Record "Gen. Journal Line";
    begin
        GenJournalLine2.Reset();
        GenJournalLine2.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenJournalLine2.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        // GenJournalLine2.SetFilter("Line No.", '<%1', GenJournalLine."Line No.");
        GenJournalLine2.SetRange("Document No.", GenJournalLine."Document No.");
        GenJournalLine2.SetFilter("Bank Document No.", '<>%1', '');
        if GenJournalLine2.FindLast()then begin
            GenJournalLine."Bank Document No.":=GenJournalLine2."Bank Document No.";
            exit(false);
        end
        else
        begin
            exit(true);
        end;
    end;
    //TEC.VJ 23012025>>
    procedure UpdateAppliedEntryXMLField(var GenJournalLine: Record "Gen. Journal Line")
    var
        AmttoApply: Text;
        ApplyEntries: Text[2048];
        VendorLedgerEntry2: Record "Global Vendor Ledger Entry";
        CustomerLedgerEntry2: Record "Global Cust. Ledger entry";
        EmpLedgerEntry: Record "Global Employee Ledger Entry";
        ValidExchRate: Boolean;
        LCYAmount: Decimal;
        CurrExchRate: Record "Currency Exchange Rate";
        NewAppliedStr: Text;
    begin
        Clear(AmttoApply);
        Clear(ApplyEntries);
        if GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor then begin
            VendorLedgerEntry2.Reset();
            VendorLedgerEntry2.SetRange("Applies-to ID", GenJournalLine."Document No.");
            VendorLedgerEntry2.SetRange("Bank Document No. Applied", GenJournalLine."Bank Document No."); //TEC-Sgarg- Added this filter
            VendorLedgerEntry2.SetFilter("Amount to Apply", '<>%1', 0);
            if VendorLedgerEntry2.FindSet()then repeat LCYAmount:=0; //TEC.VJ 04MAR2025
                    if VendorLedgerEntry2."Currency Code" <> GenJournalLine."Currency Code" then LCYAmount+=CurrExchRate.ApplnExchangeAmtFCYToFCY(GenJournalLine."Posting Date", VendorLedgerEntry2."Currency Code", GenJournalLine."Currency Code", VendorLedgerEntry2."Amount to Apply", ValidExchRate)
                    else
                        LCYAmount+=VendorLedgerEntry2."Amount to Apply";
                    AmttoApply:=Format(-LCYAmount);
                    if ApplyEntries = '' then ApplyEntries:=VendorLedgerEntry2."External Document No." + ',$' + AmttoApply
                    else
                    begin
                        NewAppliedStr:=' / ' + VendorLedgerEntry2."External Document No." + ',$' + AmttoApply;
                        if StrLen(ApplyEntries + NewAppliedStr) < 2048 then ApplyEntries+=' / ' + VendorLedgerEntry2."External Document No." + ',$' + AmttoApply;
                    end;
                until VendorLedgerEntry2.Next() = 0;
        end
        ELSE //TEC.VJ 06MAR2025>>
            if GenJournalLine."Account Type" = GenJournalLine."Account Type"::Customer then begin
                CustomerLedgerEntry2.Reset();
                CustomerLedgerEntry2.SetRange("Applies-to ID", GenJournalLine."Document No.");
                CustomerLedgerEntry2.SetRange("Bank Document No. Applied", GenJournalLine."Bank Document No."); //TEC-Sgarg- Added this filter
                CustomerLedgerEntry2.SetFilter("Amount to Apply", '<>%1', 0);
                if CustomerLedgerEntry2.FindSet()then repeat LCYAmount:=0; //TEC.VJ 04MAR2025
                        if CustomerLedgerEntry2."Currency Code" <> GenJournalLine."Currency Code" then LCYAmount+=CurrExchRate.ApplnExchangeAmtFCYToFCY(GenJournalLine."Posting Date", CustomerLedgerEntry2."Currency Code", GenJournalLine."Currency Code", CustomerLedgerEntry2."Amount to Apply", ValidExchRate)
                        else
                            LCYAmount+=CustomerLedgerEntry2."Amount to Apply";
                        AmttoApply:=Format(-LCYAmount);
                        if ApplyEntries = '' then ApplyEntries:=CustomerLedgerEntry2."External Document No." + ',$' + AmttoApply
                        else
                        begin
                            NewAppliedStr:=' / ' + CustomerLedgerEntry2."External Document No." + ',$' + AmttoApply;
                            if StrLen(ApplyEntries + NewAppliedStr) < 2048 then ApplyEntries+=' / ' + CustomerLedgerEntry2."External Document No." + ',$' + AmttoApply;
                        end;
                    until CustomerLedgerEntry2.Next() = 0;
            end;
        //TEC.VJ 06MAR2025<<
        IF StrLen(ApplyEntries) > 2048 then //TEC-Sgarg - Added this length condition
 GenJournalLine."Applied Entries to XML":=CopyStr(ApplyEntries, 1, 2046) + '..'
        else
            GenJournalLine."Applied Entries to XML":=ApplyEntries;
    end;
    //TEC.VJ 23012025<<
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", OnBeforeCode, '', false, false)]
    local procedure "Gen. Jnl.-Post Batch_OnBeforeCode"(var GenJournalLine: Record "Gen. Journal Line"; PreviewMode: Boolean; CommitIsSuppressed: Boolean)
    var
    begin
        if GenJournalLine."Source Code" = 'PURCHJNL' then GenJournalLine.TestField("Invoice Link");
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ICInboxOutboxMgt, OnCreateOutboxJnlTransactionOnBeforeOutboxJnlTransactionInsert, '', false, false)]
    local procedure ICInboxOutboxMgt_OnCreateOutboxJnlTransactionOnBeforeOutboxJnlTransactionInsert(var OutboxJnlTransaction: Record "IC Outbox Transaction"; var TempGenJnlLine: Record "Gen. Journal Line" temporary)
    begin
        if TempGenJnlLine."PB IC Account" <> '' then OutboxJnlTransaction."PB IC Account No":=TempGenJnlLine."PB IC Account";
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ICInboxOutboxMgt, OnBeforeICInboxTransInsert, '', false, false)]
    local procedure ICInboxOutboxMgt_OnBeforeICInboxTransInsert(var ICInboxTransaction: Record "IC Inbox Transaction"; ICOutboxTransaction: Record "IC Outbox Transaction")
    begin
        ICInboxTransaction."PB Account No":=ICOutboxTransaction."PB IC Account No";
    end;
    //PS002 Start
    [EventSubscriber(ObjectType::codeunit, codeunit::ICInboxOutboxMgt, 'OnInsertICOutboxJnlLine', '', false, false)]
    local procedure OnInsertICOutboxJnlLine(TempGenJournalLine: Record "Gen. Journal Line" temporary; var ICOutboxJnlLine: Record "IC Outbox Jnl. Line")
    var
        l_GenJnlLine: Record "Gen. Journal Line";
        ICOutboxJnlLine1: Record "IC Outbox Jnl. Line";
        l_GLAcc: Record "G/L Account";
        GenJnlBatch: record "Gen. Journal Batch";
        BankAPISetup: Record "Bank API Setup";
    begin
        if(ICOutboxJnlLine."Account Type" = ICOutboxJnlLine."Account Type"::"G/L Account") or (ICOutboxJnlLine."Account Type" = ICOutboxJnlLine."Account Type"::"Bank Account")then begin
            /*
            ICOutboxJnlLine1.reset;
            ICOutboxJnlLine1.SetRange("Transaction No.", ICOutboxJnlLine."Transaction No.");
            ICOutboxJnlLine1.SetRange("IC Partner Code", ICOutboxJnlLine."IC Partner Code");
            ICOutboxJnlLine1.SetRange("Transaction Source", ICOutboxJnlLine."Transaction Source");
            ICOutboxJnlLine1.SetRange("Account Type", ICOutboxJnlLine1."Account Type"::"IC Partner");
            ICOutboxJnlLine1.SetRange("Account No.", ICOutboxJnlLine."IC Partner Code");
            if ICOutboxJnlLine1.FindFirst() then begin
                ICOutboxJnlLine.Amount := ICOutboxJnlLine1.Amount * -1;
                ICOutboxJnlLine.Modify();
            end;
            
            ICOutboxJnlLine1.reset;
            ICOutboxJnlLine1.SetRange("Transaction No.", ICOutboxJnlLine."Transaction No.");
            ICOutboxJnlLine1.SetRange("IC Partner Code", ICOutboxJnlLine."IC Partner Code");
            ICOutboxJnlLine1.SetRange("Transaction Source", ICOutboxJnlLine."Transaction Source");
            ICOutboxJnlLine1.SetRange("Account Type", ICOutboxJnlLine1."Account Type"::"G/L Account");
            ICOutboxJnlLine1.SetRange("Account No.", ICOutboxJnlLine."Account No.");
            if ICOutboxJnlLine1.FindFirst() then
                ICOutboxJnlLine1.Delete();
            */
            ICOutboxJnlLine.Delete();
        end
        else
        begin
            //GenJnlBatch.Get(TempGenJournalLine."Journal Template Name", TempGenJournalLine."Journal Batch Name");
            l_GenJnlLine.Reset();
            l_GenJnlLine.SetRange("Journal Template Name", TempGenJournalLine."Journal Template Name");
            l_GenJnlLine.SetRange("Journal Batch Name", TempGenJournalLine."Journal Batch Name");
            l_GenJnlLine.SetRange("Account Type", l_GenJnlLine."Account Type"::"IC Partner");
            l_GenJnlLine.Setrange("Account No.", ICOutboxJnlLine."Account No.");
            //if GenJnlBatch."No. Series" <> '' then
            //    l_GenJnlLine.SetRange("Document No.", TempGenJournalLine."Document No.")
            //else
            l_GenJnlLine.SetRange("Document No.", TempGenJournalLine."Original Document No.");
            if l_GenJnlLine.FindFirst()then begin
                ICOutboxJnlLine."Currency Code":=l_GenJnlLine."Currency Code";
                //PS003 Start
                ICOutboxJnlLine."IC Dimension 1":=l_GenJnlLine."IC Dimension 1";
                ICOutboxJnlLine."IC Dimension 2":=l_GenJnlLine."IC Dimension 2";
                ICOutboxJnlLine."IC Dimension 3":=l_GenJnlLine."IC Dimension 3";
                ICOutboxJnlLine."IC Dimension 4":=l_GenJnlLine."IC Dimension 4";
                ICOutboxJnlLine."IC Dimension 5":=l_GenJnlLine."IC Dimension 5";
                ICOutboxJnlLine."IC Dimension 6":=l_GenJnlLine."IC Dimension 6";
                ICOutboxJnlLine."IC Dimension 7":=l_GenJnlLine."IC Dimension 7";
                ICOutboxJnlLine."IC Dimension 8":=l_GenJnlLine."IC Dimension 8";
                ICOutboxJnlLine."IC Dimension 9":=l_GenJnlLine."IC Dimension 9";
                ICOutboxJnlLine."IC Dimension 10":=l_GenJnlLine."IC Dimension 10";
                ICOutboxJnlLine."IC Dimension 11":=l_GenJnlLine."IC Dimension 11";
                ICOutboxJnlLine."IC Dimension 12":=l_GenJnlLine."IC Dimension 12";
                //PS003 End
                ICOutboxJnlLine.Modify();
                ICOutboxJnlLine1.Init();
                ICOutboxJnlLine1:=ICOutboxJnlLine;
                //if GenJnlBatch."No. Series" <> '' then
                //    ICOutboxJnlLine1."Document No." := TempGenJournalLine."Document No."
                //else
                ICOutboxJnlLine1."Document No.":=TempGenJournalLine."Original Document No.";
                ICOutboxJnlLine1."Line No.":=ICOutboxJnlLine."Line No." + 10000;
                //#294 TEC.VJ 03APR2025>>
                if l_GenJnlLine."API Bank Account Indicator" then begin
                    BankAPISetup.Get();
                    BankAPISetup.TestField("API Bank Dummy Account");
                    ICOutboxJnlLine1."Account Type":=ICOutboxJnlLine1."Account Type"::"G/L Account";
                    ICOutboxJnlLine1.validate("Account No.", BankAPISetup."API Bank Dummy Account");
                //#294 TEC.VJ 03APR2025<<
                end
                else
                begin
                    if l_GenJnlLine."PB IC Account Type" = l_GenJnlLine."PB IC Account Type"::"Bank Account" then ICOutboxJnlLine1."Account Type":=ICOutboxJnlLine1."Account Type"::"Bank Account"
                    else
                        ICOutboxJnlLine1."Account Type":=ICOutboxJnlLine1."Account Type"::"G/L Account";
                    ICOutboxJnlLine1.validate("Account No.", l_GenJnlLine."PB IC Account");
                end;
                //
                ICOutboxJnlLine1.Description:=l_GenJnlLine.Description;
                ICOutboxJnlLine1.Amount:=ICOutboxJnlLine.Amount * -1;
                ICOutboxJnlLine1."Due Date":=0D;
                ICOutboxJnlLine1."Currency Code":=l_GenJnlLine."Currency Code";
                ICOutboxJnlLine1.insert;
                if ICOutboxJnlLine1."Account No." = '' then Error('Ic Account No Cant be blank');
            end;
        end;
    end;
    //PS002 End
    //PS003 Start
    [EventSubscriber(ObjectType::codeunit, codeunit::ICInboxOutboxMgt, 'OnOutboxJnlLineToInboxOnBeforeICInboxJnlLineInsert', '', false, false)]
    local procedure OnOutboxJnlLineToInboxOnBeforeICInboxJnlLineInsert(var ICInboxJnlLine: Record "IC Inbox Jnl. Line"; var ICOutboxJnlLine: Record "IC Outbox Jnl. Line")
    begin
        ICInboxJnlLine."IC Dimension 1":=ICOutboxJnlLine."IC Dimension 1";
        ICInboxJnlLine."IC Dimension 2":=ICOutboxJnlLine."IC Dimension 2";
        ICInboxJnlLine."IC Dimension 3":=ICOutboxJnlLine."IC Dimension 3";
        ICInboxJnlLine."IC Dimension 4":=ICOutboxJnlLine."IC Dimension 4";
        ICInboxJnlLine."IC Dimension 5":=ICOutboxJnlLine."IC Dimension 5";
        ICInboxJnlLine."IC Dimension 6":=ICOutboxJnlLine."IC Dimension 6";
        ICInboxJnlLine."IC Dimension 7":=ICOutboxJnlLine."IC Dimension 7";
        ICInboxJnlLine."IC Dimension 8":=ICOutboxJnlLine."IC Dimension 8";
        ICInboxJnlLine."IC Dimension 9":=ICOutboxJnlLine."IC Dimension 9";
        ICInboxJnlLine."IC Dimension 10":=ICOutboxJnlLine."IC Dimension 10";
        ICInboxJnlLine."IC Dimension 11":=ICOutboxJnlLine."IC Dimension 11";
        ICInboxJnlLine."IC Dimension 12":=ICOutboxJnlLine."IC Dimension 12";
        ICInboxJnlLine."Currency Code":=ICOutboxJnlLine."Currency Code";
        ICInboxJnlLine."PB IC Journal Template Name":=ICOutboxJnlLine."PB IC Journal Template Name";
        ICInboxJnlLine."PB IC Journal Batch Name":=ICOutboxJnlLine."PB IC Journal Batch Name";
    end;
    [EventSubscriber(ObjectType::Table, Database::"Handled IC Inbox Jnl. Line", OnAfterInsertEvent, '', false, false)]
    local procedure OnAfterInsertHandledICInboxJnlLine(var Rec: Record "Handled IC Inbox Jnl. Line")
    var
        HandledICOutboxJnlLine: Record "Handled IC Outbox Jnl. Line";
        ICOutboxJnlLine: Record "IC Outbox Jnl. Line";
    begin
        HandledICOutboxJnlLine.reset;
        HandledICOutboxJnlLine.ChangeCompany(rec."IC Partner Code");
        HandledICOutboxJnlLine.SetRange("Transaction No.", Rec."Transaction No.");
        HandledICOutboxJnlLine.SetRange("IC Partner Code", CompanyName);
        HandledICOutboxJnlLine.SetRange("Transaction Source", HandledICOutboxJnlLine."Transaction Source"::"Created by Current Company");
        HandledICOutboxJnlLine.SetRange("Account Type", HandledICOutboxJnlLine."Account Type"::"IC Partner");
        HandledICOutboxJnlLine.SetRange("Account No.", CompanyName);
        if HandledICOutboxJnlLine.FindFirst()then begin
            rec."Currency Code":=HandledICOutboxJnlLine."Currency Code";
            rec.Modify();
        end
        else
        begin
            ICOutboxJnlLine.reset;
            ICOutboxJnlLine.ChangeCompany(rec."IC Partner Code");
            ICOutboxJnlLine.SetRange("Transaction No.", Rec."Transaction No.");
            ICOutboxJnlLine.SetRange("IC Partner Code", CompanyName);
            ICOutboxJnlLine.SetRange("Transaction Source", ICOutboxJnlLine."Transaction Source"::"Created by Current Company");
            ICOutboxJnlLine.SetRange("Account Type", ICOutboxJnlLine."Account Type"::"IC Partner");
            ICOutboxJnlLine.SetRange("Account No.", CompanyName);
            if ICOutboxJnlLine.FindFirst()then begin
                rec."Currency Code":=ICOutboxJnlLine."Currency Code";
                rec.Modify();
            end;
        end;
    end;
    [EventSubscriber(ObjectType::Table, Database::"IC Inbox Jnl. Line", OnAfterInsertEvent, '', false, false)]
    local procedure OnAfterInsertICInboxJnlLine(var Rec: Record "IC Inbox Jnl. Line")
    var
        HandledICOutboxJnlLine: Record "IC Outbox Jnl. Line";
        ICOutboxJnlLine: Record "IC Outbox Jnl. Line";
    begin
        HandledICOutboxJnlLine.reset;
        HandledICOutboxJnlLine.ChangeCompany(rec."IC Partner Code");
        HandledICOutboxJnlLine.SetRange("Transaction No.", Rec."Transaction No.");
        HandledICOutboxJnlLine.SetRange("IC Partner Code", CompanyName);
        HandledICOutboxJnlLine.SetRange("Transaction Source", HandledICOutboxJnlLine."Transaction Source"::"Created by Current Company");
        HandledICOutboxJnlLine.SetRange("Account Type", HandledICOutboxJnlLine."Account Type"::"IC Partner");
        HandledICOutboxJnlLine.SetRange("Account No.", CompanyName);
        if HandledICOutboxJnlLine.FindFirst()then begin
            rec."Currency Code":=HandledICOutboxJnlLine."Currency Code";
            rec.Modify();
        end
        else
        begin
            ICOutboxJnlLine.reset;
            ICOutboxJnlLine.ChangeCompany(rec."IC Partner Code");
            ICOutboxJnlLine.SetRange("Transaction No.", Rec."Transaction No.");
            ICOutboxJnlLine.SetRange("IC Partner Code", CompanyName);
            ICOutboxJnlLine.SetRange("Transaction Source", ICOutboxJnlLine."Transaction Source"::"Created by Current Company");
            ICOutboxJnlLine.SetRange("Account Type", ICOutboxJnlLine."Account Type"::"IC Partner");
            ICOutboxJnlLine.SetRange("Account No.", CompanyName);
            if ICOutboxJnlLine.FindFirst()then begin
                rec."Currency Code":=ICOutboxJnlLine."Currency Code";
                rec.Modify();
            end;
        end;
    end;
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnAfterInsertEvent, '', false, false)]
    local procedure OnAfterInsertICGenJnlLine(var Rec: Record "Gen. Journal Line")
    var
        HandledICOutboxJnlLine: Record "Handled IC Outbox Jnl. Line";
        GLSetup: Record "General Ledger Setup";
        ICOutboxJnlLine: Record "IC Outbox Jnl. Line";
        CurrExchRate: Record "Currency Exchange Rate";
        CUrrFactor: decimal;
        GenJnlTemplate: Record "Gen. Journal Template";
        ICSetup: Record "IC Setup";
    begin
        if not rec.IsTemporary then begin
            GLSetup.get;
            HandledICOutboxJnlLine.reset;
            HandledICOutboxJnlLine.ChangeCompany(rec."IC Partner Code");
            HandledICOutboxJnlLine.SetRange("Transaction No.", Rec."IC Partner Transaction No.");
            HandledICOutboxJnlLine.SetRange("IC Partner Code", CompanyName);
            HandledICOutboxJnlLine.SetRange("Transaction Source", HandledICOutboxJnlLine."Transaction Source"::"Created by Current Company");
            HandledICOutboxJnlLine.SetRange("Account Type", HandledICOutboxJnlLine."Account Type"::"IC Partner");
            HandledICOutboxJnlLine.SetRange("Account No.", CompanyName);
            if HandledICOutboxJnlLine.FindFirst()then begin
                rec."Currency Code":=HandledICOutboxJnlLine."Currency Code";
                if Rec."Document No." = '' then rec."Document No.":=HandledICOutboxJnlLine."Document No.";
                if(rec."Currency Code" <> GLSetup."LCY Code") and (rec."Currency Code" <> '')then begin
                    CurrFactor:=CurrExchRate.ExchangeRate(rec."Posting Date", rec."Currency Code");
                    rec."Amount (LCY)":=round(CurrExchRate.ExchangeAmtFCYToLCY(rec."posting Date", rec."Currency Code", rec.Amount, CurrFactor));
                end;
                rec.modify;
            end;
            ICOutboxJnlLine.reset;
            ICOutboxJnlLine.ChangeCompany(rec."IC Partner Code");
            ICOutboxJnlLine.SetRange("Transaction No.", Rec."IC Partner Transaction No.");
            ICOutboxJnlLine.SetRange("IC Partner Code", CompanyName);
            ICOutboxJnlLine.SetRange("Transaction Source", ICOutboxJnlLine."Transaction Source"::"Created by Current Company");
            ICOutboxJnlLine.SetRange("Account Type", ICOutboxJnlLine."Account Type"::"IC Partner");
            ICOutboxJnlLine.SetRange("Account No.", CompanyName);
            if ICOutboxJnlLine.FindFirst()then begin
                rec."Currency Code":=ICOutboxJnlLine."Currency Code";
                if Rec."Document No." = '' then rec."Document No.":=HandledICOutboxJnlLine."Document No.";
                if(rec."Currency Code" <> GLSetup."LCY Code") and (rec."Currency Code" <> '')then begin
                    CurrFactor:=CurrExchRate.ExchangeRate(rec."Posting Date", rec."Currency Code");
                    rec."Amount (LCY)":=round(CurrExchRate.ExchangeAmtFCYToLCY(rec."posting Date", rec."Currency Code", rec.Amount, CurrFactor));
                end;
                rec.modify;
            end;
            if(rec."IC Partner Transaction No." <> 0) and (rec."Currency Code" = '')then begin
                rec."Currency Code":=GLSetup."LCY Code";
                rec.Modify();
            end;
            if GenJnlTemplate.get(rec."Journal Template Name")then begin
                if GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany then begin
                    ICSetup.Get();
                    rec."PB IC Journal Template Name":=rec."Journal Template Name"; //DC  14Mar2025
                    rec."PB IC Journal Batch Name":=ICSetup."Default IC Gen. Jnl. Batch"; //DC  14Mar2025
                    rec."Original Document No.":=Rec."Document No.";
                    rec.Modify();
                end;
            end;
        end;
    end;
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnAfterModifyEvent, '', false, false)]
    local procedure OnAfterModifyICGenJnlLine(var Rec: Record "Gen. Journal Line")
    var
        HandledICOutboxJnlLine: Record "Handled IC Outbox Jnl. Line";
        GLSetup: Record "General Ledger Setup";
        ICOutboxJnlLine: Record "IC Outbox Jnl. Line";
        CurrExchRate: Record "Currency Exchange Rate";
        CUrrFactor: decimal;
        GenJnlTemplate: Record "Gen. Journal Template";
        ICSetup: Record "IC Setup";
    begin
        if not rec.IsTemporary then begin
            GLSetup.get;
            if GenJnlTemplate.get(rec."Journal Template Name")then begin
                if GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany then begin
                    if rec."Document No." <> rec."Original Document No." then begin
                        rec."Original Document No.":=Rec."Document No.";
                        rec.Modify();
                    end;
                end;
            end;
        end;
    end;
    [EventSubscriber(ObjectType::codeunit, codeunit::ICInboxOutboxMgt, 'OnCreateJournalLinesOnBeforeModify', '', false, false)]
    local procedure OnCreateJournalLinesOnBeforeModify(ICInboxJnlLine: Record "IC Inbox Jnl. Line"; var GenJournalLine: Record "Gen. Journal Line")
    var
        icinboxtrans: Page "IC Inbox Transactions";
    begin
        if ICInboxJnlLine."IC Dimension 1" <> '' then GenJournalLine.Validate("Shortcut Dimension 1 Code", ICInboxJnlLine."IC Dimension 1");
        if ICInboxJnlLine."IC Dimension 2" <> '' then GenJournalLine.Validate("Shortcut Dimension 2 Code", ICInboxJnlLine."IC Dimension 2");
        if ICInboxJnlLine."IC Dimension 3" <> '' then GenJournalLine.Validate("Shortcut Dimension 3 Code", ICInboxJnlLine."IC Dimension 3");
        if ICInboxJnlLine."IC Dimension 4" <> '' then GenJournalLine.Validate("Shortcut Dimension 4 Code", ICInboxJnlLine."IC Dimension 4");
        if ICInboxJnlLine."IC Dimension 5" <> '' then GenJournalLine.Validate("Shortcut Dimension 5 Code", ICInboxJnlLine."IC Dimension 5");
        if ICInboxJnlLine."IC Dimension 6" <> '' then GenJournalLine.Validate("Shortcut Dimension 6 Code", ICInboxJnlLine."IC Dimension 6");
        if ICInboxJnlLine."IC Dimension 7" <> '' then GenJournalLine.Validate("Shortcut Dimension 7 Code", ICInboxJnlLine."IC Dimension 7");
        if ICInboxJnlLine."IC Dimension 8" <> '' then GenJournalLine.Validate("Shortcut Dimension 8 Code", ICInboxJnlLine."IC Dimension 8");
        if ICInboxJnlLine."IC Dimension 9" <> '' then GenJournalLine.Validate("Shortcut Dimension 9 Code", ICInboxJnlLine."IC Dimension 9");
        if ICInboxJnlLine."IC Dimension 10" <> '' then GenJournalLine.Validate("Shortcut Dimension 10 Code", ICInboxJnlLine."IC Dimension 10");
        if ICInboxJnlLine."IC Dimension 11" <> '' then GenJournalLine.Validate("Shortcut Dimension 11 Code", ICInboxJnlLine."IC Dimension 11");
        if ICInboxJnlLine."IC Dimension 12" <> '' then GenJournalLine.Validate("Shortcut Dimension 12 Code", ICInboxJnlLine."IC Dimension 12");
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ICInboxOutboxMgt, 'OnInsertOutboxJnlLineOnBeforeICOutboxJnlLineInsert', '', false, false)]
    local procedure OnInsertOutboxJnlLineOnBeforeICOutboxJnlLineInsert(TempGenJournalLine: Record "Gen. Journal Line" temporary; var ICOutboxJnlLine: Record "IC Outbox Jnl. Line")
    var
        icsetup: Record "IC Setup";
    begin
        if TempGenJournalLine."PB IC Journal Template Name" <> '' then ICOutboxJnlLine."PB IC Journal Template Name":=TempGenJournalLine."PB IC Journal Template Name"
        else
        begin
            ICSetup.Get();
            ICOutboxJnlLine."PB IC Journal Template Name":=icsetup."Default IC Gen. Jnl. Template";
        end;
        if TempGenJournalLine."PB IC Journal Batch Name" <> '' then ICOutboxJnlLine."PB IC Journal Batch Name":=TempGenJournalLine."PB IC Journal Batch Name"
        else
        begin
            icsetup.Get();
            ICOutboxJnlLine."PB IC Journal Batch Name":=TempGenJournalLine."PB IC Journal Batch Name";
        end;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ICInboxOutboxMgt, 'OnBeforeInsertGenJnlLine', '', false, false)]
    local procedure OnBeforeInsertGenJnlLine(ICInboxJnlLine: Record "IC Inbox Jnl. Line"; var GenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlTemplate: Record "Gen. Journal Template";
        NoSeries: Codeunit "No. Series";
        GenJnlLine1: Record "Gen. Journal Line";
    begin
        if ICInboxJnlLine."PB IC Journal Template Name" <> '' then GenJnlLine."Journal Template Name":=ICInboxJnlLine."PB IC Journal Template Name";
        if ICInboxJnlLine."PB IC Journal Batch Name" <> '' then GenJnlLine."Journal Batch Name":=ICInboxJnlLine."PB IC Journal Batch Name";
        GenJnlLine."IC Partner Code":=ICInboxJnlLine."IC Partner Code";
        GenJnlTemplate.get(GenJnlLine."Journal Template Name");
        GenJnlLine."Posting No. Series":=GenJnlTemplate."Posting No. Series";
        //GenJnlLine."Document No." := NoSeries.GetNextNo(GenJnlTemplate."Posting No. Series");
        GenJnlLine."Document No.":='';
        GenJnlLine1.reset;
        GenJnlLine1.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
        GenJnlLine1.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
        if GenJnlLine1.FindLast()then GenJnlLine."Line No.":=GenJnlLine1."Line No." + 10000
        else
            GenJnlLine."Line No.":=10000;
    end;
    //PS003 End
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnBeforeSkipRenumberDocumentNo, '', false, false)]
    local procedure OnBeforeSkipRenumberDocumentNo(var IsHandled: Boolean; var Result: Boolean)
    begin
        IsHandled:=true;
        Result:=false;
    end;
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnAfterCopyGenJnlLineFromPurchHeader, '', false, false)]
    local procedure "Gen. Journal Line_OnAfterCopyGenJnlLineFromPurchHeader"(PurchaseHeader: Record "Purchase Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."PB DNV invoice":=PurchaseHeader."PB DNV invoice";
    end;
    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", OnAfterCopyVendLedgerEntryFromGenJnlLine, '', false, false)]
    local procedure "Vendor Ledger Entry_OnAfterCopyVendLedgerEntryFromGenJnlLine"(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        VendorLedgerEntry."PB DNV invoice":=GenJournalLine."PB DNV invoice";
        VendorLedgerEntry."Original Invoice No":=GenJournalLine."Original Invoice No";
        VendorLedgerEntry."PB Concur Invoice":=GenJournalLine."PB Concur invoice"; //PS006
        VendorLedgerEntry."IMOS Transaction No":=GenJournalLine."IMOS Transaction No";
        VendorLedgerEntry."IMOS Transaction":=GenJournalLine."IMOS invoice";
        VendorLedgerEntry."Remittance Company No":=GenJournalLine."Remittance Company No";
        VendorLedgerEntry."CP External Document No":=GenJournalLine."CP External Document No";
        VendorLedgerEntry."Remittance Account No":=GenJournalLine."Remittance Account No";
        VendorLedgerEntry."Remittance Full Name":=GenJournalLine."Remittance Full Name";
        VendorLedgerEntry."IMOS Bank ID":=GenJournalLine."IMOS Bank ID";
        VendorLedgerEntry."Bank Document No.":=GenJournalLine."Bank Document No."; //TEC.VJ 18DEC2024
    end;
    //>>TEC.VJ 25Nov2024
    //>>TE.VJ 30DEC2024
    [EventSubscriber(ObjectType::Table, Database::"Bank Account Ledger Entry", OnAfterCopyFromGenJnlLine, '', false, false)]
    local procedure "Bank Account Ledger Entry_OnAfterCopyBankAccLedgerEntryFromGenJnlLine"(GenJournalLine: Record "Gen. Journal Line"; var BankAccountLedgerEntry: Record "Bank Account Ledger Entry")
    begin
        BankAccountLedgerEntry."Bank Document No.":=GenJournalLine."Bank Document No.";
    end;
    //>>TEC.VJ 30DEC2024
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnBeforeSetCurrencyCode, '', false, false)]
    local procedure "Gen. Journal Line_OnBeforeSetCurrencyCode"(var GenJournalLine: Record "Gen. Journal Line"; AccType2: Enum "Gen. Journal Account Type"; AccNo2: Code[20]; var Result: Boolean; var IsHandled: Boolean)
    var
        BankAcc: Record "Bank Account";
    begin
        GenJournalLine."Currency Code":='';
        if AccNo2 <> '' then if AccType2 = AccType2::"Bank Account" then if BankAcc.Get(AccNo2)then GenJournalLine."Currency Code":=BankAcc."Currency Code Custom";
        Result:=GenJournalLine."Currency Code" <> '';
        IsHandled:=true;
    end;
    //<<TEC.VJ 25Nov2024
    //>>TEC.VJ 27Nov2024
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnAfterSetupNewLine, '', false, false)]
    local procedure "Gen. Journal Line_OnAfterSetupNewLine"(var GenJournalLine: Record "Gen. Journal Line"; GenJournalTemplate: Record "Gen. Journal Template"; GenJournalBatch: Record "Gen. Journal Batch"; LastGenJournalLine: Record "Gen. Journal Line"; Balance: Decimal; BottomLine: Boolean)
    var
        PaymentMethod: Record "Payment Method";
    begin
        GenJournalLine."Payment Method Code":=GenJournalBatch."Payment Method Code";
        GenJournalLine."Bypass API":=GenJournalBatch."Bypass API"; //#226
    // if PaymentMethod.get(GenJournalLine."Payment Method Code") then begin//VT commented as Requested by Parco//02012025
    //     if PaymentMethod."Export ifile" then
    //         GenJournalLine."No Corresponding Bank for Pmt" := true
    //     else
    //         GenJournalLine."No Corresponding Bank for Pmt" := false;
    // end
    // else
    //     GenJournalLine."No Corresponding Bank for Pmt" := false; //VT commented as Requested by Parco//02012025
    end;
    //>>TEC.VJ 27Nov2024
    //PS006 Start
    //PS006 End
    //PS005 Start
    [EventSubscriber(ObjectType::Table, Database::Employee, OnAfterValidateEvent, "Company E-Mail", false, false)]
    local procedure "Employee_OnAfterValidateCompanyEMail"(var Rec: Record Employee)
    begin
        rec."Login ID":=rec."Company E-Mail";
    end;
    [EventSubscriber(ObjectType::Table, Database::Employee, OnAfterInsertEvent, '', false, false)]
    local procedure "Employee_OnAfterInsert"(var Rec: Record Employee)
    begin
        rec."Concur Personal Emp ID":=rec."No.";
        rec."Concur Vendor ID":=rec."No.";
        rec."Concur Cash Adv. Account code":=rec."No.";
    end;
    [EventSubscriber(ObjectType::Table, Database::Employee, OnAfterValidateEvent, "Integrate to Concur", false, false)]
    local procedure "Employee_OnAfterValidateIntegrateToConcur"(var Rec: Record Employee)
    begin
        if rec."Integrate to Concur" then rec."Concur Corp Card ID":=rec."No." + 'CC'
        else
            rec."Concur Corp Card ID":='';
    end;
    /*
    [EventSubscriber(ObjectType::Table, Database::"Default Dimension", OnAfterValidateEvent, "Dimension Value Code", false, false)]
    local procedure "DefDimension_OnAfterValidateDimValCode"(var Rec: Record "Default Dimension")
    var
        Employee: Record Employee;
        GLSetup: Record "General Ledger Setup";
    begin
        glsetup.get;
        if rec."Table ID" = 5200 then
            if Employee.get(rec."No.") and (rec."Dimension Code" = GLSetup."Shortcut Dimension 8 Code") then begin
                if rec."Dimension Value Code" <> '' then begin
                    Employee.Company := rec."Dimension Value Code";
                    Employee.Modify();
                end
                else begin
                    Employee.Company := '';
                    Employee.Modify();
                end;
            end;
    end;
    */
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnAfterInitEmployeeLedgerEntry, '', false, false)]
    local procedure OnAfterInitEmployeeLedgerEntry(GenJournalLine: Record "Gen. Journal Line"; var EmployeeLedgerEntry: Record "Employee Ledger Entry")
    begin
        EmployeeLedgerEntry."External Document No.":=GenJournalLine."External Document No."; //PS008
    end;
    //PS005 End
    //#230 TEC.VJ 29FEBB2025 Commented>>
    //VJ#45 11DEC2024 Start
    // [EventSubscriber(ObjectType::Codeunit, codeunit::"Gen. Jnl.-Apply", OnAfterUpdateVendLedgEntry, '', false, false)]
    // local procedure OnAfterUpdateVendLedgEntry(var VendorLedgerEntry: Record "Vendor Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line")
    // var
    // begin
    //     GenJournalLine."External Document No." := VendorLedgerEntry."External Document No.";
    // end;
    // [EventSubscriber(ObjectType::Table, database::"Gen. Journal Line", OnLookUpAppliesToDocVendOnAfterUpdateDocumentTypeAndAppliesTo, '', false, false)]
    // local procedure OnLookUpAppliesToDocVendOnAfterUpdateDocumentTypeAndAppliesTo(var GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Vendor Ledger Entry")
    // var
    // begin
    //     GenJournalLine."External Document No." := VendorLedgerEntry."External Document No.";
    // end;
    //#230 TEC.VJ 29FEBB2025 Commented<<
    //VJ#45 11DEC2024 End
    //VJ#55 Start OnAfterAccountNoOnValidateGetVendorAccount
    [EventSubscriber(ObjectType::Table, database::"Gen. Journal Line", OnAfterAccountNoOnValidateGetVendorAccount, '', false, false)]
    local procedure OnAfterAccountNoOnValidateGetVendorAccount(var GenJournalLine: Record "Gen. Journal Line")
    var
        l_GenJournalBatch: record "Gen. Journal Batch";
        VendBankAcc: Record "Vendor Bank Account";
        CustomerBankAcc: Record "Customer Bank Account";
    begin
        l_GenJournalBatch.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name");
        GenJournalLine.validate("Payment Method Code", l_GenJournalBatch."Payment Method Code");
        //#103 TEC.VJ>>
        if GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor then begin
            VendBankAcc.Reset();
            VendBankAcc.SetRange("Vendor No.", GenJournalLine."Account No.");
            VendBankAcc.SetRange("Is Default", true);
            if VendBankAcc.FindFirst()then GenJournalLine.Validate("Recipient Bank Account", VendBankAcc.Code);
        end;
        //#103 TEC.VJ<<
        //#242 TEC.VJ 03MARCH2025>>
        if GenJournalLine."Account Type" = GenJournalLine."Account Type"::Customer then begin
            CustomerBankAcc.Reset();
            CustomerBankAcc.SetRange("Customer No.", GenJournalLine."Account No.");
            CustomerBankAcc.SetRange("Is Default", true);
            if CustomerBankAcc.FindFirst()then GenJournalLine.Validate("Recipient Bank Account", CustomerBankAcc.Code);
        end;
    //#242 TEC.VJ 03MARCH2025<<
    end;
    //VJ#55 End
    [EventSubscriber(ObjectType::Table, database::"Gen. Journal Line", OnValidateAccountNoOnAfterAssignValue, '', false, false)]
    local procedure OnValidateAccountNoOnAfterAssignValue(var GenJournalLine: Record "Gen. Journal Line")
    var
        ReviewGenJnl: Codeunit "Review Gen Jnl";
    begin
        if(GenJournalLine."Source Code" <> 'PAYMENTJNL') AND (GenJournalLine."Source Code" <> 'INTERCOMP')then //#76
 exit;
        //#384 VJ 22072025
        if GenJournalLine."Skip BankDoc Checking" then exit;
        //#384 VJ 22072025
        //if ((not GenJournalLine."Bypass API") AND (GenJournalLine."Source Code" = 'INTERCOMP')) OR (GenJournalLine."Source Code" = 'PAYMENTJNL') then  //VJ 07FEB2025 //VJ 11FEB2025 Changed after discuss with Walter
        if(GenJournalLine."Source Code" = 'INTERCOMP') OR (GenJournalLine."Source Code" = 'PAYMENTJNL')then //VJ 25Mar2025 removed bypass api checking from intercompany journal
 CreateBankDocuemntNo(GenJournalLine);
        ReviewGenJnl.RunBankDocumentNoChecking(GenJournalLine); //VJ 05March2025
    end;
    [EventSubscriber(ObjectType::Report, Report::"Suggest Employee Payments", OnBeforeUpdateGnlJnlLineDimensionsFromTempBuffer, '', false, false)]
    local procedure "Suggest Employee Payments_OnBeforeUpdateGnlJnlLineDimensionsFromTempBuffer"(var GenJournalLine: Record "Gen. Journal Line"; TempEmplPaymentBuffer: Record "Employee Payment Buffer" temporary)
    begin
        CreateBankDocuemntNo(GenJournalLine);
    end;
    //VJ 20dec2024 Start DF
    [EventSubscriber(ObjectType::Table, database::"Gen. Journal Line", OnAfterAccountNoOnValidateGetEmployeeAccount, '', false, false)]
    local procedure OnAfterAccountNoOnValidateGetEmployeeAccount(var GenJournalLine: Record "Gen. Journal Line"; var Employee: Record Employee)
    var
        EmpBankAcc: Record "Employee Bank Account";
    begin
        EmpBankAcc.Reset();
        EmpBankAcc.SetRange("Employee No.", Employee."No.");
        EmpBankAcc.SetRange("Is Default", true);
        if EmpBankAcc.FindFirst()then GenJournalLine.Validate("Employee Bank Account", EmpBankAcc.Code);
    end;
    //VJ 20dec2024 End
    //#108 TEC.VJ>>
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Global Gen. Jnl.-Apply", OnAfterUpdateVendLedgEntry, '', false, false)]
    local procedure OnAfterUpdateGlobalVendLedgEntry(var VendorLedgerEntry: Record "Global Vendor Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line")
    var
        ApplyEntries: Text[200];
        NewApplyEntries: Text[200];
    begin
        ApplyEntries:='';
        //GenJournalLine."External Document No." := VendorLedgerEntry."External Document No."; //#230 TEC.VJ Commented
        UpdateAppliedEntryXMLField(GenJournalLine);
    end;
    //#108 TEC.VJ<<
    //>>VJ 04Feb2025 #198
    //[EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnAfterClearCustVendApplnEntry, '', false, false)]
    procedure "Gen. Journal Line_OnAfterClearCustVendApplnEntry"(var GenJournalLine: Record "Gen. Journal Line")
    var
        GVendLedger: Record "Global Vendor Ledger Entry";
        GEmpLedger: Record "Global Employee Ledger Entry";
        GCustLedger: Record "Global Cust. Ledger entry";
        VLE: record "Vendor Ledger Entry";
        ELE: record "Employee Ledger Entry";
        CLE: record "Cust. Ledger Entry";
    begin
        if GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor then begin
            GVendLedger.Reset();
            GVendLedger.SetCurrentKey("Vendor No.", Open);
            GVendLedger.SetRange("Vendor No.", GenJournalLine."Account No.");
            GVendLedger.SetRange("Applies-to ID", GenJournalLine."Document No."); //#344 TEC.VJ 30052025 GENJNl LINES ALL APPLIED ENTIES CLAER ISSUE
            GVendLedger.SetRange("Bank Document No. Applied", GenJournalLine."Bank Document No.");
            if GVendLedger.FindSet(true)then repeat GVendLedger."Bank Document No. Applied":='';
                    GVendLedger."Applies-to ID":='';
                    GVendLedger."Accepted Pmt. Disc. Tolerance":=false;
                    GVendLedger."Accepted Payment Tolerance":=0;
                    GVendLedger."Amount to Apply":=0;
                    if GenJournalLine."On Hold" = GVendLedger."On Hold" then begin
                        GVendLedger."On Hold":='';
                        GenJournalLine."On Hold":='';
                    end;
                    GVendLedger.Modify();
                    if GVendLedger."Company Name" = CompanyName then begin
                        VLE.Reset();
                        VLE.Get(GVendLedger."Entry No.");
                        VLE."Applies-to ID":='';
                        vle."Bank Document No. Applied":='';
                        vle."Amount to Apply":=0;
                        vle.Modify();
                    end;
                until GVendLedger.Next() = 0;
        end;
        //07022025 VJ>>
        if GenJournalLine."Account Type" = GenJournalLine."Account Type"::Employee then begin
            GEmpLedger.Reset();
            GEmpLedger.SetCurrentKey("Employee No.", Open);
            GEmpLedger.SetRange("Employee No.", GenJournalLine."Account No.");
            GEmpLedger.SetRange("Applies-to ID", GenJournalLine."Document No."); //#344 TEC.VJ 30052025 GENJNl LINES ALL APPLIED ENTIES CLAER ISSUE
            GEmpLedger.SetRange("Bank Document No. Applied", GenJournalLine."Bank Document No.");
            if GEmpLedger.FindSet(true)then repeat GEmpLedger."Bank Document No. Applied":='';
                    GEmpLedger."Applies-to ID":='';
                    GEmpLedger."Amount to Apply":=0;
                    GEmpLedger.Modify();
                    if GEmpLedger."Company Code" = CompanyName then begin
                        ele.Get(GEmpLedger."Entry No.");
                        ele."Applies-to ID":='';
                        ele."Bank Document No. Applied":='';
                        ele."Amount to Apply":=0;
                        ele.Modify();
                    end until GEmpLedger.Next() = 0;
        end;
        //07022025 VJ<<
        //TEC.VJ 06MAR2025>>
        if GenJournalLine."Account Type" = GenJournalLine."Account Type"::Customer then begin
            GCustLedger.Reset();
            GCustLedger.SetCurrentKey("Customer No.", Open);
            GCustLedger.SetRange("Customer No.", GenJournalLine."Account No.");
            GCustLedger.SetRange("Applies-to ID", GenJournalLine."Document No."); //#344 TEC.VJ 30052025 GENJNl LINES ALL APPLIED ENTIES CLAER ISSUE
            GCustLedger.SetRange("Bank Document No. Applied", GenJournalLine."Bank Document No.");
            if GCustLedger.FindSet(true)then repeat GCustLedger."Bank Document No. Applied":='';
                    GCustLedger."Applies-to ID":='';
                    GCustLedger."Accepted Pmt. Disc. Tolerance":=false;
                    GCustLedger."Accepted Payment Tolerance":=0;
                    GCustLedger."Amount to Apply":=0;
                    if GenJournalLine."On Hold" = GCustLedger."On Hold" then begin
                        GCustLedger."On Hold":='';
                        GenJournalLine."On Hold":='';
                    end;
                    GCustLedger.Modify();
                    if GCustLedger."Company Name" = CompanyName then begin
                        CLE.Reset();
                        CLE.Get(GCustLedger."Entry No.");
                        CLE."Applies-to ID":='';
                        CLE."Bank Document No. Applied":='';
                        CLE."Amount to Apply":=0;
                        CLE.Modify();
                    end;
                until GCustLedger.Next() = 0;
        end;
    //TEC.VJ 06MAR2025<<
    end;
    //TEC.VJ 13022025>>
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnFindFirstVendLedgEntryWithAppliesToIDOnAfterSetFilters, '', false, false)]
    local procedure "Gen. Journal Line_OnFindFirstVendLedgEntryWithAppliesToIDOnAfterSetFilters"(var GenJournalLine: Record "Gen. Journal Line"; var VendLedgEntry: Record "Vendor Ledger Entry")
    var
        GlobalVendLedgEntry: Record "Global Vendor Ledger Entry";
    begin
        VendLedgEntry.SetRange("Bank Document No. Applied", GenJournalLine."Bank Document No.");
    // GlobalVendLedgEntry.Reset();
    // GlobalVendLedgEntry.SetRange("Bank Document No. Applied", GenJournalLine."Bank Document No.");
    // if GlobalVendLedgEntry.FindFirst() then begin
    //     GlobalVendLedgEntry.Modifyall("Bank Document No. Applied", '');
    //     GlobalVendLedgEntry.ModifyAll("Applies-to ID", '');
    // end;
    end;
    //TEC.VJ 13022025<<
    //<<VJ 04Feb2025 #198
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Vend. Entry-Edit", OnRunOnAfterVendLedgEntryMofidy, '', false, false)]
    // local procedure "Vend. Entry-Edit_OnRunOnAfterVendLedgEntryMofidy"(var VendorLedgerEntry: Record "Vendor Ledger Entry")
    // var
    //     GlobalVendLEdger: Record "Global Vendor Ledger Entry";
    // begin
    //     GlobalVendLEdger.Reset();
    //     GlobalVendLEdger.SetRange("Applies-to ID", '');
    // end;
    //VJ 07Feb2025 Start
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnAfterRenumberAppliesToID, '', false, false)]
    local procedure "Gen. Journal Line_OnAfterRenumberAppliesToID"(AccountNo: Code[20]; AccountType: Enum "Gen. Journal Account Type"; GenJournalLine: Record "Gen. Journal Line"; NewAppliesToID: Code[50]; OriginalAppliesToID: Code[50])
    var
        GlobalVendLEdger: Record "Global Vendor Ledger Entry";
        GlobalCustLedger: Record "Global Cust. Ledger entry";
        GlobalEmpLEdger: Record "Global Employee Ledger Entry";
        EmpLedgEntry: Record "Employee Ledger Entry";
        EmpLedgEntry2: Record "Employee Ledger Entry";
    begin
        if AccountType = AccountType::Vendor then begin
            GlobalVendLEdger.Reset();
            GlobalVendLEdger.SetRange("Applies-to ID", OriginalAppliesToID);
            GlobalVendLEdger.SetRange("Bank Document No. Applied", GenJournalLine."Bank Document No.");
            if not GlobalVendLEdger.IsEmpty then GlobalVendLEdger.ModifyAll("Applies-to ID", NewAppliesToID);
        end;
        if AccountType = AccountType::Customer then begin
            GlobalCustLedger.Reset();
            GlobalCustLedger.SetRange("Applies-to ID", OriginalAppliesToID);
            GlobalCustLedger.SetRange("Bank Document No. Applied", GenJournalLine."Bank Document No.");
            if not GlobalCustLedger.IsEmpty then GlobalCustLedger.ModifyAll("Applies-to ID", NewAppliesToID);
        end;
    // if AccountType = AccountType::Employee then begin
    //     EmpLedgEntry.SetRange("Employee No.", GenJournalLine."Account No.");
    //     EmpLedgEntry.SetRange("Applies-to ID", OriginalAppliesToID);
    //     if EmpLedgEntry.FindSet() then
    //         repeat
    //             EmpLedgEntry2.Get(EmpLedgEntry."Entry No.");
    //             EmpLedgEntry2."Applies-to ID" := NewAppliesToID;
    //             CODEUNIT.Run(CODEUNIT::"Empl. Entry-Edit", EmpLedgEntry2);
    //         until EmpLedgEntry.Next() = 0;
    //     GlobalEmpLEdger.Reset();
    //     GlobalEmpLEdger.SetRange("Applies-to ID", OriginalAppliesToID);
    //     GlobalEmpLEdger.SetRange("Bank Document No. Applied", GenJournalLine."Bank Document No.");
    //     if not GlobalEmpLEdger.IsEmpty then
    //         GlobalEmpLEdger.ModifyAll("Applies-to ID", NewAppliesToID);
    // end;
    end;
    //VJ 07Feb2025 End
    //13FEB2025 TEC.VJ>> //Update applied to id for renumber case
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnBeforeRenumberAppliesToID, '', false, false)]
    local procedure "Gen. Journal Line_OnBeforeRenumberAppliesToID"(GenJournalLine: Record "Gen. Journal Line"; OriginalAppliesToID: Code[50]; NewAppliesToID: Code[50]; AccountType: Enum "Gen. Journal Account Type"; AccountNo: Code[20])
    var
        GlobalEmpLEdger: Record "Global Employee Ledger Entry";
        EmpLedgEntry: Record "Employee Ledger Entry";
        EmpLedgEntry2: Record "Employee Ledger Entry";
    begin
        if GenJournalLine."Account Type" <> GenJournalLine."Account Type"::Employee then Exit;
        EmpLedgEntry.SetRange("Employee No.", GenJournalLine."Account No.");
        EmpLedgEntry.SetRange("Applies-to ID", OriginalAppliesToID);
        if EmpLedgEntry.FindSet()then repeat EmpLedgEntry2.Get(EmpLedgEntry."Entry No.");
                EmpLedgEntry2."Applies-to ID":=NewAppliesToID;
                CODEUNIT.Run(CODEUNIT::"Empl. Entry-Edit", EmpLedgEntry2);
            until EmpLedgEntry.Next() = 0;
        GlobalEmpLEdger.Reset();
        GlobalEmpLEdger.SetRange("Applies-to ID", OriginalAppliesToID);
        GlobalEmpLEdger.SetRange("Bank Document No. Applied", GenJournalLine."Bank Document No.");
        if not GlobalEmpLEdger.IsEmpty then GlobalEmpLEdger.ModifyAll("Applies-to ID", NewAppliesToID);
        GenJournalLine."Applies-to ID":=NewAppliesToID;
        GenJournalLine.Modify();
    end;
    // 13FEB2025 TEC.VJ<<
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnRenumberAppliesToIDOnAfterVendLedgEntrySetFilters, '', false, false)]
    local procedure "Gen. Journal Line_OnRenumberAppliesToIDOnAfterVendLedgEntrySetFilters"(var GenJournalLine: Record "Gen. Journal Line"; AccNo: Code[20]; var VendLedgEntry: Record "Vendor Ledger Entry")
    begin
        VendLedgEntry.Setrange("Bank Document No. Applied", GenJournalLine."Bank Document No.")end;
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnAfterInitDefaultDimensionSources, '', false, false)]
    local procedure "Gen. Journal Line_OnAfterInitDefaultDimensionSources"(var GenJournalLine: Record "Gen. Journal Line"; var DefaultDimSource: List of[Dictionary of[Integer, Code[20]]]; FromFieldNo: Integer)
    var
        DimSetEntry: Record "Dimension Set Entry";
        GenLedSetup: record "General Ledger Setup";
    begin
        exit;
        Message('%1', GenJournalLine."Dimension Set ID");
        GenLedSetup.Get;
        if GenJournalLine."Dimension Set ID" <> 0 then begin
            DimSetEntry.Reset();
            DimSetEntry.SetRange("Dimension Set ID", GenJournalLine."Dimension Set ID");
            if DimSetEntry.FindSet()then repeat IF GenLedSetup."Shortcut Dimension 9 Code" = DimSetEntry."Dimension Code" then GenJournalLine."Shortcut Dimension 9 Code":=DimSetEntry."Dimension Value Code";
                    IF GenLedSetup."Shortcut Dimension 10 Code" = DimSetEntry."Dimension Code" then GenJournalLine."Shortcut Dimension 10 Code":=DimSetEntry."Dimension Value Code";
                    IF GenLedSetup."Shortcut Dimension 11 Code" = DimSetEntry."Dimension Code" then GenJournalLine."Shortcut Dimension 11 Code":=DimSetEntry."Dimension Value Code";
                    IF GenLedSetup."Shortcut Dimension 12 Code" = DimSetEntry."Dimension Code" then GenJournalLine."Shortcut Dimension 12 Code":=DimSetEntry."Dimension Value Code";
                    IF GenLedSetup."Shortcut Dimension 13 Code" = DimSetEntry."Dimension Code" then GenJournalLine."Shortcut Dimension 13 Code":=DimSetEntry."Dimension Value Code";
                    IF GenLedSetup."Shortcut Dimension 14 Code" = DimSetEntry."Dimension Code" then GenJournalLine."Shortcut Dimension 14 Code":=DimSetEntry."Dimension Value Code";
                    IF GenLedSetup."Shortcut Dimension 15 Code" = DimSetEntry."Dimension Code" then GenJournalLine."Shortcut Dimension 15 Code":=DimSetEntry."Dimension Value Code";
                //GenJournalLine.Modify();
                until DimSetEntry.Next() = 0;
        end;
    end;
    //PS009 Start
    [EventSubscriber(ObjectType::Table, database::"Concur inbound financial Expen", OnAfterInsertEvent, '', false, false)]
    local procedure OnAfterInsertConcurInboundFinancialExpense(var Rec: Record "Concur inbound financial Expen")
    var
        GetIdentity: Codeunit "Concur Get Identity";
        attendeeid: Text;
        GetAttendee: Codeunit "Concur Expense Attendee Resp.";
        GetAttendeeInfo: Codeunit "Concur Get Attendee Info";
    begin
        if not Rec.IsTemporary then begin
            GetIdentity.GetIdentity(true, Rec);
            attendeeid:=GetAttendee.GetExpenseAttendee(true, Rec);
            if AttendeeID <> '' then GetAttendeeInfo.GetAttendeeInfo(true, AttendeeID);
        end;
    end;
    //PS009 End
    //PS005 Start
    [EventSubscriber(ObjectType::Table, database::Employee, OnAfterInsertEvent, '', false, false)]
    local procedure OnAfterInsertEmployee(var Rec: Record Employee)
    var
        DimensionValue: Record "Dimension Value";
        DefaultDimension: Record "Default Dimension";
        GLSetup: Record "General Ledger Setup";
    begin
        if not Rec.IsTemporary then begin
            GLSetup.get;
            DimensionValue.ChangeCompany(rec.Company);
            DefaultDimension.ChangeCompany(Rec.Company);
            if not DimensionValue.get(GLSetup."Shortcut Dimension 6 Code", Rec."No.")then begin
                DimensionValue.Init();
                DimensionValue."Dimension Code":=GLSetup."Shortcut Dimension 6 Code";
                DimensionValue.Code:=rec."No.";
                if Rec.FullName() <> '' then //TEC.VJ 16JUNE2025
 DimensionValue.Name:=Rec.FullName()
                else
                    DimensionValue.Name:=Rec."No.";
                DimensionValue.Insert(true);
            end;
            if not DefaultDimension.get(5200, Rec."No.", GLSetup."Shortcut Dimension 6 Code")then begin
                DefaultDimension.Init();
                DefaultDimension."Table ID":=5200;
                DefaultDimension."No.":=rec."No.";
                DefaultDimension."Dimension Code":=GLSetup."Shortcut Dimension 6 Code";
                DefaultDimension."Dimension Value Code":=rec."No.";
                DefaultDimension.Insert(true);
            end;
        end;
    end;
    //PS005 End
    //#134 TEC.VJ>>
    [EventSubscriber(ObjectType::Table, Database::"Bank Account Ledger Entry", OnAfterCopyFromGenJnlLine, '', false, false)]
    local procedure "Bank Account Ledger Entry_OnAfterCopyFromGenJnlLine"(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        GenJournal: Record "Gen. Journal Line";
    begin
        if GenJournalLine."Source Code" <> 'INTERCOMP' then EXIT;
        GenJournal.Reset();
        GenJournal.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenJournal.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenJournal.SetRange("Document No.", GenJournalLine."Document No.");
        GenJournal.SetRange("Account Type", GenJournal."Account Type"::"IC Partner");
        GenJournal.SetRange("PB IC Account Type", GenJournal."PB IC Account Type"::"Bank Account");
        IF GenJournal.FindFirst()then BEGIN
            BankAccountLedgerEntry."Bal. Account Type":=GenJournal."Bal. Account Type"::"Bank Account";
            BankAccountLedgerEntry."Bal. Account No.":=GenJournal."PB IC Account";
        END;
    end;
    //#134 TEC.VJ<<
    [EventSubscriber(ObjectType::Table, Database::"Employee Ledger Entry", OnAfterCopyEmployeeLedgerEntryFromGenJnlLine, '', false, false)]
    local procedure "Employee Ledger Entry_OnAfterCopyEmployeeLedgerEntryFromGenJnlLine"(var EmployeeLedgerEntry: Record "Employee Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        GLSetup: Record "General Ledger Setup";
        DimeSetEntry: record "Dimension Set Entry";
    begin
        GLSetup.Get();
        employeeLedgerEntry."PB Concur Invoice":=GenJournalLine."PB Concur invoice";
        //VT20-12-2024 >>
        EmployeeLedgerEntry."Concur ID":=GenJournalLine."Concur ID";
        EmployeeLedgerEntry."Entry Id":=GenJournalLine."Entry Id";
        EmployeeLedgerEntry."Receipt image ID":=GenJournalLine."Receipt image ID";
        EmployeeLedgerEntry."Bank Document No.":=GenJournalLine."Bank Document No.";
        EmployeeLedgerEntry."Report ID":=GenJournalLine."Report ID"; //Sgarg
        //VT20-12-2024 <<
        EmployeeLedgerEntry."Payment Method Code":=GenJournalLine."Payment Method Code"; //TEC.VJ 13022025
        EmployeeLedgerEntry."Employee Bank Account":=GenJournalLine."Employee Bank Account"; // Norman 13feb2025
        EmployeeLedgerEntry."Payment Method Code":=GenJournalLine."Payment Method Code"; // Norman 13feb2025
        EmployeeLedgerEntry."Cash Advance":=GenJournalLine."Cash Advance"; //TEC.VJ 14MAY2025
        DimeSetEntry.Reset();
        DimeSetEntry.SetRange("Dimension Set ID", GenJournalLine."Dimension Set ID");
        if DimeSetEntry.FindSet()then repeat if GLSetup."Shortcut Dimension 3 Code" = DimeSetEntry."Dimension Code" then EmployeeLedgerEntry."Shortcut Dimension 3 Code_PB":=DimeSetEntry."Dimension Value Code";
                if GLSetup."Shortcut Dimension 4 Code" = DimeSetEntry."Dimension Code" then EmployeeLedgerEntry."Shortcut Dimension 4 Code_PB":=DimeSetEntry."Dimension Value Code";
                if GLSetup."Shortcut Dimension 5 Code" = DimeSetEntry."Dimension Code" then EmployeeLedgerEntry."Shortcut Dimension 5 Code_PB":=DimeSetEntry."Dimension Value Code";
                if GLSetup."Shortcut Dimension 6 Code" = DimeSetEntry."Dimension Code" then EmployeeLedgerEntry."Shortcut Dimension 6 Code_PB":=DimeSetEntry."Dimension Value Code";
                if GLSetup."Shortcut Dimension 7 Code" = DimeSetEntry."Dimension Code" then EmployeeLedgerEntry."Shortcut Dimension 7 Code_PB":=DimeSetEntry."Dimension Value Code";
                if GLSetup."Shortcut Dimension 8 Code" = DimeSetEntry."Dimension Code" then EmployeeLedgerEntry."Shortcut Dimension 8 Code_PB":=DimeSetEntry."Dimension Value Code";
                if GLSetup."Shortcut Dimension 9 Code" = DimeSetEntry."Dimension Code" then EmployeeLedgerEntry."Shortcut Dimension 9 Code_PB":=DimeSetEntry."Dimension Value Code";
                if GLSetup."Shortcut Dimension 10 Code" = DimeSetEntry."Dimension Code" then EmployeeLedgerEntry."Shortcut Dimension 10 Code_PB":=DimeSetEntry."Dimension Value Code";
                if GLSetup."Shortcut Dimension 11 Code" = DimeSetEntry."Dimension Code" then EmployeeLedgerEntry."Shortcut Dimension 11 Code_PB":=DimeSetEntry."Dimension Value Code";
                if GLSetup."Shortcut Dimension 12 Code" = DimeSetEntry."Dimension Code" then EmployeeLedgerEntry."Shortcut Dimension 12 Code_PB":=DimeSetEntry."Dimension Value Code";
                if GLSetup."Shortcut Dimension 13 Code" = DimeSetEntry."Dimension Code" then EmployeeLedgerEntry."Shortcut Dimension 13 Code_PB":=DimeSetEntry."Dimension Value Code";
                if GLSetup."Shortcut Dimension 14 Code" = DimeSetEntry."Dimension Code" then EmployeeLedgerEntry."Shortcut Dimension 14 Code_PB":=DimeSetEntry."Dimension Value Code";
                if GLSetup."Shortcut Dimension 15 Code" = DimeSetEntry."Dimension Code" then EmployeeLedgerEntry."Shortcut Dimension 15 Code_PB":=DimeSetEntry."Dimension Value Code";
            until DimeSetEntry.Next() = 0;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnPostEmployeeOnBeforeEmployeeLedgerEntryInsert, '', false, false)]
    local procedure "Gen. Jnl.-Post Line_OnPostEmployeeOnBeforeEmployeeLedgerEntryInsert"(var GenJnlLine: Record "Gen. Journal Line"; var EmployeeLedgerEntry: Record "Employee Ledger Entry"; GLRegister: Record "G/L Register")
    var
        GLSetup: Record "General Ledger Setup";
        DimeSetEntry: record "Dimension Set Entry";
    begin
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Cust. Entry-Edit", OnBeforeCustLedgEntryModify, '', false, false)]
    local procedure "Cust. Entry-Edit_OnBeforeCustLedgEntryModify"(var CustLedgEntry: Record "Cust. Ledger Entry"; FromCustLedgEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgEntry."Over Receipt Amount":=FromCustLedgEntry."Over Receipt Amount";
        CustLedgEntry."Bank Charges Amount":=FromCustLedgEntry."Bank Charges Amount";
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnApplyVendLedgEntryOnBeforeOldVendLedgEntryModify, '', false, false)]
    local procedure "Gen. Jnl.-Post Line_OnApplyVendLedgEntryOnBeforeOldVendLedgEntryModify"(GenJnlLine: Record "Gen. Journal Line"; var OldVendLedgEntry: Record "Vendor Ledger Entry"; var NewCVLedgEntryBuf: Record "CV Ledger Entry Buffer"; AppliedAmount: Decimal)
    var
        IMOSOutboundLog: Record "IMOS API Log";
        Log: Record "IMOS API Log";
    begin
        //TEC.VJ 19FEB2025>>
        if OldVendLedgEntry."Bank Document No. Applied" <> '' then OldVendLedgEntry."Bank Document No. Applied":='';
        //TEC.VJ 19FEB2025<<
        if(GenJnlLine."Document Type" = GenJnlLine."Document Type"::Payment) or (GenJnlLine."Document Type" = GenJnlLine."Document Type"::Refund) or (GenJnlLine."Document Type" = GenJnlLine."Document Type"::Payment) or (OldVendLedgEntry."Document Type" = OldVendLedgEntry."Document Type"::Payment) or (OldVendLedgEntry."Document Type" = OldVendLedgEntry."Document Type"::Refund) or (OldVendLedgEntry."Document Type" = OldVendLedgEntry."Document Type"::Payment)then if(OldVendLedgEntry."IMOS Transaction") or (GenJnlLine."IMOS invoice") or (OldVendLedgEntry."IMOS Transaction No" <> '') or (GenJnlLine."IMOS Transaction No" <> '')then begin
                IMOSOutboundLog.Init();
                IMOSOutboundLog."Table No.":=Database::"Vendor Ledger Entry";
                IMOSOutboundLog."Company Code":=CompanyName;
                IMOSOutboundLog."Primary key 2":=NewCVLedgEntryBuf."Document No.";
                IMOSOutboundLog."Primary key 3":=OldVendLedgEntry."Document No.";
                IMOSOutboundLog."Payment Amount":=AppliedAmount;
                IMOSOutboundLog."Entry Type":=IMOSOutboundLog."Entry Type"::Insert;
                IMOSOutboundLog.Status:=IMOSOutboundLog.Status::Pending;
                IMOSOutboundLog."Bank Document No.":=GenJnlLine."Bank Document No.";
                IMOSOutboundLog.Insert(true);
            end;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnApplyEmplLedgEntryOnBeforeOldEmplLedgEntryModify, '', false, false)]
    local procedure "Gen. Jnl.-Post Line_OnApplyEmplLedgEntryOnBeforeOldEmplLedgEntryModify"(GenJnlLine: Record "Gen. Journal Line"; var OldEmplLedgEntry: Record "Employee Ledger Entry"; var NewCVLedgEntryBuf: Record "CV Ledger Entry Buffer"; AppliedAmount: Decimal)
    begin
        //TEC.VJ 19FEB2025>>
        if OldEmplLedgEntry."Bank Document No. Applied" <> '' then OldEmplLedgEntry."Bank Document No. Applied":='';
    //TEC.VJ 19FEB2025<<
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnApplyCustLedgerEntryOnBeforeSetCompleted, '', false, false)]
    local procedure "Gen. Jnl.-Post Line_OnApplyCustLedgerEntryOnBeforeSetCompleted"(var GenJournalLine: Record "Gen. Journal Line"; var OldCustLedgEntry: Record "Cust. Ledger Entry"; var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; AppliedAmount: Decimal)
    var
        IMOSOutboundLog: Record "IMOS API Log";
        Log: Record "IMOS API Log";
    begin
        if(GenJournalLine."Document Type" = GenJournalLine."Document Type"::Payment) or (GenJournalLine."Document Type" = GenJournalLine."Document Type"::Refund) or (GenJournalLine."Document Type" = GenJournalLine."Document Type"::Payment) or (OldCustLedgEntry."Document Type" = OldCustLedgEntry."Document Type"::Payment) or (OldCustLedgEntry."Document Type" = OldCustLedgEntry."Document Type"::Refund) or (OldCustLedgEntry."Document Type" = OldCustLedgEntry."Document Type"::Payment)then if(OldCustLedgEntry."IMOS Transaction") or (GenJournalLine."IMOS invoice") or (OldCustLedgEntry."IMOS Transaction No" <> '') or (GenJournalLine."IMOS Transaction No" <> '')then begin
                //Message('%1--%2--%3--%4--%5--%6', OldCustLedgEntry."Document No.", NewCVLedgerEntryBuffer."Document No.", AppliedAmount, OldCustLedgEntry."Over Receipt Amount", OldCustLedgEntry."IMOS Transaction No", GenJournalLine."IMOS Bank ID");
                IMOSOutboundLog.Init();
                IMOSOutboundLog."Table No.":=Database::"Cust. Ledger Entry";
                IMOSOutboundLog."Company Code":=CompanyName;
                IMOSOutboundLog."Primary key 2":=NewCVLedgerEntryBuffer."Document No.";
                IMOSOutboundLog."Primary key 3":=OldCustLedgEntry."Document No.";
                IMOSOutboundLog."Payment Amount":=AppliedAmount;
                //IMOSOutboundLog."Over Receipt Amount" := OldCustLedgEntry."Over Receipt Amount";
                IMOSOutboundLog."Bank Charge Amount":=OldCustLedgEntry."Bank Charges Amount";
                IMOSOutboundLog."Entry Type":=IMOSOutboundLog."Entry Type"::Insert;
                IMOSOutboundLog.Status:=IMOSOutboundLog.Status::Pending;
                IMOSOutboundLog."Bank Document No.":=GenJournalLine."Bank Document No.";
                IMOSOutboundLog.Insert(true);
            end;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnPostBankAccOnAfterBankAccLedgEntryInsert, '', false, false)]
    local procedure "Gen. Jnl.-Post Line_OnPostBankAccOnAfterBankAccLedgEntryInsert"(var Sender: Codeunit "Gen. Jnl.-Post Line"; var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; BankAccount: Record "Bank Account")
    var
        CPH: Record "PB Central Payment History";
        GenJnlGUID: Text[100];
        GrapMgmt: Codeunit "Graph Mgt - General Tools";
        IMOSbankMapping: Record "IMOS Bank Mapping";
        IMOSBankID: Text[30];
    begin
        IMOSBankID:='';
        IMOSbankMapping.Reset();
        IMOSbankMapping.SetRange("BC Bank Code", BankAccountLedgerEntry."Bank Account No.");
        if IMOSbankMapping.FindSet()then IMOSBankID:=IMOSbankMapping."IMOS Bank ID";
        if IMOSBankID = '' then exit;
        GenJnlGUID:=GrapMgmt.GetIdWithoutBrackets(GenJournalLine.SystemId);
        cph.Reset();
        CPH.SetRange("Source Company", CompanyName);
        CPH.SetRange("Source Document No", BankAccountLedgerEntry."Document No.");
        //cph.SetRange("Gen Jnl Line GUIID", GenJnlGUID);
        //CPH.SetRange("Bank ID", '');
        if CPH.FindSet()then repeat cph."Bank ID":=IMOSBankID;
                cph.Modify();
            until cph.Next() = 0;
        ;
    end;
    procedure UpdateGenjnlBatchFieldsForHSBC_Citi(TemplateName: Code[10]; BatchName: Code[10])
    var
        GenJnlBatch: Record "Gen. Journal Batch";
        HSBCOutbound: Record "HSBC Outbound Staging Table";
        CitiOutbound: Record "Citi Outbound Staging Table";
    begin
        //No. of Approved Records in HSBC & Citi>>
        if GenJnlBatch.Get(TemplateName, BatchName)then begin
            clear(GenJnlBatch."No. of Approved");
            HSBCOutbound.Reset();
            HSBCOutbound.SetRange("Journal Template Name", GenJnlBatch."Journal Template Name");
            HSBCOutbound.SetRange("Journal Batch Name", GenJnlBatch.Name);
            HSBCOutbound.SetFilter(Status, '=%1|%2', HSBCOutbound.Status::Approved, HSBCOutbound.Status::Booked); //TEC.VJ 10022025
            if HSBCOutbound.FindSet()then GenJnlBatch."No. of Approved":=HSBCOutbound.Count;
            CitiOutbound.Reset();
            CitiOutbound.SetRange("Journal Template Name", GenJnlBatch."Journal Template Name");
            CitiOutbound.SetRange("Journal Batch Name", GenJnlBatch.Name);
            CitiOutbound.SetFilter(Status, '=%1|%2', CitiOutbound.Status::Approved, CitiOutbound.Status::Booked); //TEC.VJ 10022025
            if CitiOutbound.FindSet()then GenJnlBatch."No. of Approved"+=CitiOutbound.Count;
            //No. of Approved Records in HSBC & Citi<<
            //No. of Rejected Records in HSBC & Citi>>
            clear(GenJnlBatch."No. of Rejected");
            HSBCOutbound.SetFilter(Status, '=%1|%2', HSBCOutbound.Status::Rejected, HSBCOutbound.Status::FAIL);
            if HSBCOutbound.FindSet()then GenJnlBatch."No. of Rejected":=HSBCOutbound.Count;
            CitiOutbound.SetFilter(Status, '=%1|%2', CitiOutbound.Status::Rejected, CitiOutbound.Status::FAIL);
            if CitiOutbound.FindSet()then GenJnlBatch."No. of Rejected"+=CitiOutbound.Count;
            //No. of Rejected Records in HSBC & Citi<<
            //No. of Pending Records in HSBC & Citi>>
            clear(GenJnlBatch."No. of Pending");
            HSBCOutbound.SetFilter(Status, '=%1|%2', HSBCOutbound.Status::Pending, HSBCOutbound.Status::Sent);
            if HSBCOutbound.FindSet()then GenJnlBatch."No. of Pending":=HSBCOutbound.Count;
            CitiOutbound.SetFilter(Status, '=%1|%2', CitiOutbound.Status::Pending, CitiOutbound.Status::Sent);
            if CitiOutbound.FindSet()then GenJnlBatch."No. of Pending"+=CitiOutbound.Count;
            //No. of Pending Records in HSBC & Citi<<
            GenJnlBatch."Total No.":=GenJnlBatch."No. of Approved" + GenJnlBatch."No. of Rejected" + GenJnlBatch."No. of Pending";
            GenJnlBatch.Modify();
        end;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnPostBankAccOnBeforeBankAccLedgEntryInsert, '', false, false)]
    local procedure "Gen. Jnl.-Post Line_OnPostBankAccOnBeforeBankAccLedgEntryInsert"(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; BankAccount: Record "Bank Account"; var TempGLEntryBuf: Record "G/L Entry" temporary; var NextTransactionNo: Integer; GLRegister: Record "G/L Register"; Balancing: Boolean)
    begin
        BankAccountLedgerEntry."Currency Code":=GenJournalLine."Currency Code";
        BankAccountLedgerEntry.Amount:=GenJournalLine.Amount;
        BankAccountLedgerEntry."Remaining Amount":=BankAccountLedgerEntry.Amount;
    end;
    [EventSubscriber(ObjectType::Table, Database::"Global Vendor Ledger Entry", OnBeforeModifyEvent, '', false, false)]
    local procedure "GlobalVendorLedger_OnAfterModifyEvent"(var Rec: Record "Global Vendor Ledger Entry"; var xRec: Record "Global Vendor Ledger Entry")
    var
    begin
    // if Rec."Applies-to ID" <> xRec."Applies-to ID" then
    //   Error('global applies to id modify');
    end;
    //#218 12022025 VG>>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", OnBeforeCommit, '', false, false)]
    local procedure "Gen. Jnl.-Post Batch_OnBeforeCommit"(GLRegNo: Integer; var GenJournalLine: Record "Gen. Journal Line"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine2: Record "Gen. Journal Line";
        GenTemplate: Record "Gen. Journal Template";
    begin
        GenJnlLine2.Reset();
        GenJnlLine2.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenJnlLine2.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        if not GenJnlLine2.FindFirst()then begin
            if GenJnlBatch.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name")then // if GenTemplate.get(GenJournalLine."Journal Template Name") and (GenTemplate."Source Code" = 'PAYMENTJNL') then
                if GenTemplate.get(GenJournalLine."Journal Template Name") and (not GenJnlBatch."No Deletion After Post")then //TEC.VJ 19MAR2025 //#280
 GenJnlBatch.Delete(false);
        end;
    end;
    //#218 12022025 VG<<
    //14FEB2025 TEC.VJ>>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Vend. Entry-SetAppl.ID", OnAfterUpdateVendLedgerEntry, '', false, false)]
    local procedure "Vend. Entry-SetAppl.ID_OnAfterUpdateVendLedgerEntry"(var VendorLedgerEntry: Record "Vendor Ledger Entry"; var TempVendLedgEntry: Record "Vendor Ledger Entry" temporary; ApplyingVendLedgEntry: Record "Vendor Ledger Entry"; AppliesToID: Code[50])
    begin
        if AppliesToID = '' then begin
            VendorLedgerEntry."Bank Document No. Applied":='';
            VendorLedgerEntry.Modify(false);
        end;
    end;
    // [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnBeforeClearCustVendApplnEntry, '', false, false)]
    // local procedure "Gen. Journal Line_OnBeforeClearCustVendApplnEntry"(var GenJournalLine: Record "Gen. Journal Line"; xGenJournalLine: Record "Gen. Journal Line"; AccType: Enum "Gen. Journal Account Type"; AccNo: Code[20])
    // begin
    //     IF GenJournalLine."Account No." <> xGenJournalLine."Account No." then
    //         GenJournalLine.Validate(Amount, 0);
    // end;
    //14FEB2025 TEC.VJ<<
    // [EventSubscriber(ObjectType::Page, Page::"Global Apply Vendor Entries", OnAfterGetCurrRecordEvent, '', false, false)]
    // local procedure GlobalApplyVendorEntries(var Rec: Record "Global Vendor Ledger Entry")
    // begin
    //     Message('Current Record %1', rec."Entry No.");
    // end;
    // [EventSubscriber(ObjectType::Table, Database::"Global Vendor Ledger Entry", OnAfterValidateEvent, "Amount to Apply", false, false)]
    // local procedure OnAfterValidateEvent(var Rec: Record "Global Vendor Ledger Entry")
    // begin
    //     Message('Current Record %1....%2', rec."Entry No.", Rec."Amount to Apply");
    // end;
    //>>21Feb2025 VJ Start
    procedure UpdatePostingNoSeries(GenJournalLine: Record "Gen. Journal Line")
    var
        GenTemp: Record "Gen. Journal Template";
        GenJrnLine: Record "Gen. Journal Line";
    begin
        GenTemp.Get(GenJournalLine."Journal Template Name");
        GenTemp.TestField("Posting No. Series");
        GenJrnLine.copy(GenJournalLine);
        GenJrnLine.ModifyAll("Posting No. Series", GenTemp."Posting No. Series", false);
    end;
    //>>21Feb2025 VJ End
    //#226 TEC.VJ 19FEB2025>>
    procedure InsertNewBatch(EntryBookedDate: Date; TemplateName: Code[10]; BatchName: Text[10]; BalBankAccNo: Code[20]; var NewBatchName: Code[20])
    var
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlBatch2: Record "Gen. Journal Batch";
        GenJnlBatch_From: Record "Gen. Journal Batch";
        NewDateWiseBatch: Code[10];
    begin
        Clear(NewBatchName);
        IF GenJnlBatch_From.Get(TemplateName, BatchName)THEN;
        NewDateWiseBatch:=Format(EntryBookedDate, 0, '<Month,2><Day,2>');
        GenJnlBatch.Reset();
        GenJnlBatch.SetRange("Journal Template Name", TemplateName);
        GenJnlBatch.SetFilter(Name, '%1', NewDateWiseBatch + '*');
        GenJnlBatch.SetRange("Staging EntryValueDate", EntryBookedDate);
        GenJnlBatch.SetRange("Bal. Account Type", GenJnlBatch."Bal. Account Type"::"Bank Account");
        GenJnlBatch.SetFilter("Bal. Account No.", BalBankAccNo);
        if NOT GenJnlBatch.FindFirst()THEN BEGIN
            IF NOT GenJnlBatch2.Get(TemplateName, NewDateWiseBatch + 'A')then NewDateWiseBatch:=Format(EntryBookedDate, 0, '<Month,2><Day,2>') + 'A'
            ELSE IF NOT GenJnlBatch2.Get(TemplateName, NewDateWiseBatch + 'B')then NewDateWiseBatch:=Format(EntryBookedDate, 0, '<Month,2><Day,2>') + 'B'
                ELSE IF NOT GenJnlBatch2.Get(TemplateName, NewDateWiseBatch + 'C')then NewDateWiseBatch:=Format(EntryBookedDate, 0, '<Month,2><Day,2>') + 'C'
                    ELSE IF NOT GenJnlBatch2.Get(TemplateName, NewDateWiseBatch + 'D')then NewDateWiseBatch:=Format(EntryBookedDate, 0, '<Month,2><Day,2>') + 'D'
                        //Start TEC.VG#05NOV2025
                        ELSE IF NOT GenJnlBatch2.Get(TemplateName, NewDateWiseBatch + 'E')then NewDateWiseBatch:=Format(EntryBookedDate, 0, '<Month,2><Day,2>') + 'E'
                            ELSE IF NOT GenJnlBatch2.Get(TemplateName, NewDateWiseBatch + 'F')then NewDateWiseBatch:=Format(EntryBookedDate, 0, '<Month,2><Day,2>') + 'F'
                                ELSE IF NOT GenJnlBatch2.Get(TemplateName, NewDateWiseBatch + 'G')then NewDateWiseBatch:=Format(EntryBookedDate, 0, '<Month,2><Day,2>') + 'G'
                                    ELSE IF NOT GenJnlBatch2.Get(TemplateName, NewDateWiseBatch + 'H')then NewDateWiseBatch:=Format(EntryBookedDate, 0, '<Month,2><Day,2>') + 'H';
            //End TEC.VG#05NOV2025
            //INSERT NEW BATCH
            InsertBatch(GenJnlBatch_From, NewDateWiseBatch, BalBankAccNo, EntryBookedDate);
        //END
        END
        ELSE
            NewDateWiseBatch:=GenJnlBatch.Name;
        NewBatchName:=NewDateWiseBatch;
    end;
    procedure InsertBatch(BatchFrom: Record "Gen. Journal Batch"; NewBatchName: Code[10]; BalBankAccNo: Code[20]; EntryBookedDate: Date)
    var
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlTempl: Record "Gen. Journal Template";
    begin
        GenJnlTempl.Get(BatchFrom."Journal Template Name");
        Clear(GenJnlBatch);
        GenJnlBatch.Init();
        GenJnlBatch:=BatchFrom;
        GenJnlBatch.Name:=NewBatchName;
        GenJnlBatch.Validate("Bal. Account Type", GenJnlBatch."Bal. Account Type"::"Bank Account");
        GenJnlBatch.Validate("Bal. Account No.", BalBankAccNo);
        GenJnlBatch."No. of Approved":=0;
        GenJnlBatch."No. of Pending":=0;
        GenJnlBatch."No. of Rejected":=0;
        GenJnlBatch."Total No.":=0;
        GenJnlBatch."Staging EntryValueDate":=EntryBookedDate;
        GenJnlBatch."Bypass API":=true;
        GenJnlBatch."No. Series":=GenJnlTempl."No. Series";
        GenJnlBatch."Posting No. Series":=GenJnlTempl."Posting No. Series";
        if GenJnlBatch.Name <> 'DEFAULT' THEN GenJnlBatch."No Deletion After Post":=false; //#336 TEC.VJ 16MAY2025
        if GenJnlBatch.Insert(true)then;
    end;
    //#226 TEC.VJ 19FEB2025<<
    //TEC.VJ 27FEB2025>> Change Inbound Status to Posted
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnBeforeFinishPosting, '', false, false)]
    local procedure "Gen. Jnl.-Post Line_OnAfterGLFinishPosting"(sender: Codeunit "Gen. Jnl.-Post Line"; var GenJournalLine: Record "Gen. Journal Line"; var TempGLEntryBuf: Record "G/L Entry" temporary)
    var
        CitiInbound: Record "Citi Inbound Staging";
        HSBCInbound: Record "HSBC Inbound Staging";
        BankAcc: Record "Bank Account";
    begin
        // if (GenJournalLine."Source Code" <> 'PAYMENTJNL') AND (GenJournalLine."Source Code" <> 'INTERCOMP') THEN EXIT;//TEC.VJ 20032025 Commented
        IF GenJournalLine."Auto Post" THEN EXIT;
        HSBCInbound.Reset();
        HSBCInbound.SetRange(TxEndtoEndId, GenJournalLine."External Document No.");
        if HSBCInbound.FindFirst()then begin
            HSBCInbound.Status:=HSBCInbound.Status::Posted;
            HSBCInbound.Modify();
        end
        else
        begin
            CitiInbound.Reset();
            CitiInbound.SetRange(TxEndtoEndId, GenJournalLine."External Document No.");
            if CitiInbound.FindFirst()then begin
                CitiInbound.Status:=CitiInbound.Status::Posted;
                CitiInbound.Modify();
            end end;
    end;
    //TEC.VJ 27FEB2025<<
    [EventSubscriber(ObjectType::Table, Database::"Dimension Value", 'OnAfterInsertEvent', '', false, false)]
    local procedure InsertDimensionValue(var Rec: Record "Dimension Value"; RunTrigger: Boolean)
    var
        GlSetup: record "General Ledger Setup";
    begin
        GlSetup.Get();
        if GlSetup."Shortcut Dimension 9 Code" = rec."Dimension Code" then Rec."Global Dimension No.":=9;
        if GlSetup."Shortcut Dimension 10 Code" = rec."Dimension Code" then Rec."Global Dimension No.":=10;
        if GlSetup."Shortcut Dimension 11 Code" = rec."Dimension Code" then Rec."Global Dimension No.":=11;
        if GlSetup."Shortcut Dimension 12 Code" = rec."Dimension Code" then Rec."Global Dimension No.":=12;
        if GlSetup."Shortcut Dimension 13 Code" = rec."Dimension Code" then Rec."Global Dimension No.":=13;
        if GlSetup."Shortcut Dimension 14 Code" = rec."Dimension Code" then Rec."Global Dimension No.":=14;
        if GlSetup."Shortcut Dimension 15 Code" = rec."Dimension Code" then Rec."Global Dimension No.":=15;
    end;
    [EventSubscriber(ObjectType::Table, Database::"Dimension Value", OnAfterModifyEvent, '', false, false)]
    local procedure ModifyDimValue(var Rec: Record "Dimension value"; RunTrigger: Boolean)
    var
        GlSetup: record "General Ledger Setup";
    begin
        GlSetup.Get();
        if GlSetup."Shortcut Dimension 9 Code" = rec."Dimension Code" then Rec."Global Dimension No.":=9;
        if GlSetup."Shortcut Dimension 10 Code" = rec."Dimension Code" then Rec."Global Dimension No.":=10;
        if GlSetup."Shortcut Dimension 11 Code" = rec."Dimension Code" then Rec."Global Dimension No.":=11;
        if GlSetup."Shortcut Dimension 12 Code" = rec."Dimension Code" then Rec."Global Dimension No.":=12;
        if GlSetup."Shortcut Dimension 13 Code" = rec."Dimension Code" then Rec."Global Dimension No.":=13;
        if GlSetup."Shortcut Dimension 14 Code" = rec."Dimension Code" then Rec."Global Dimension No.":=14;
        if GlSetup."Shortcut Dimension 15 Code" = rec."Dimension Code" then Rec."Global Dimension No.":=15;
    end;
    //TEC.VJ 01042025>>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnPostApprovalEntriesOnAfterApprovalEntrySetFilters, '', false, false)]
    local procedure "Approvals Mgmt._OnPostApprovalEntriesOnAfterApprovalEntrySetFilters"(var ApprovalEntry: Record "Approval Entry"; TableNo: Integer)
    var
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlline: Record "Gen. Journal Line";
    begin
        if TableNo <> Database::"Gen. Journal Batch" then exit;
        if not ApprovalEntry.FindFirst()then exit;
        if GenJnlBatch.Get(ApprovalEntry."Record ID to Approve")then begin
            GenJnlline.Reset();
            GenJnlline.SetRange("Journal Template Name", GenJnlBatch."Journal Template Name");
            GenJnlline.SetRange("Journal Batch Name", GenJnlBatch."Name");
            GenJnlline.SetRange("Source Code", 'PAYMENTJNL');
            if GenJnlline.FindFirst()then begin
                GenJnlBatch."Partially Posted":=true;
                GenJnlBatch.Modify();
            end;
        end;
    end;
    //TEC.VJ 01042025<<
    //#295 TEC.VJ >>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Record Restriction Mgt.", 'OnBeforeGenJournalLineCheckGenJournalLinePostRestrictions', '', false, false)]
    local procedure RecordRestrictionMgt_OnBeforeGenJournalLineCheckGenJournalLinePostRestrictions(var GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    var
        RestrictedRecord: Record "Restricted Record";
        RecRef: RecordRef;
        ErrorMessage: Text;
        GenJnlBatchApprovalStatus: Text[20];
        EnabledGenJnlBatchWorkflowsExist: Boolean;
        ApprovalMgmt: Codeunit "Approvals Mgmt.";
    begin
        EnabledGenJnlBatchWorkflowsExist:=true;
        ApprovalMgmt.GetGenJnlBatchApprovalStatus(GenJournalLine, GenJnlBatchApprovalStatus, EnabledGenJnlBatchWorkflowsExist);
        IF(GenJnlBatchApprovalStatus = 'Imposed restriction')then begin
            RecRef.GetTable(GenJournalLine);
            if RecRef.IsTemporary then exit;
            if RestrictedRecord.IsEmpty()then exit;
            RestrictedRecord.SetRange("Record ID", RecRef.RecordId);
            if RestrictedRecord.FINDSET()then BEGIN
                RestrictedRecord.DeleteAll();
            END end;
    End;
    //#295 TEC.VJ <<
    //VJ15APR2025>>
    [EventSubscriber(ObjectType::Table, Database::"Posted Gen. Journal Line", OnBeforeInsertFromGenJournalLine, '', false, false)]
    local procedure "Posted Gen. Journal Line_OnBeforeInsertFromGenJournalLine"(var Sender: Record "Posted Gen. Journal Line"; GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    begin
        Sender."Auto Post":=GenJournalLine."Auto Post";
    end;
    //VJ15APR2025<<
    procedure UndoApproval(GenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlBatch_var: Record "Gen. Journal Batch";
        ApprovalEntry: Record "Approval Entry";
    begin
        GenJnlBatch_var.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
        ApprovalEntry.Reset();
        ApprovalEntry.SetRange("Table ID", Database::"Gen. Journal Batch");
        ApprovalEntry.SetRange("Record ID to Approve", GenJnlBatch_var.RecordId);
        ApprovalEntry.FindSet();
        ApprovalEntry.ModifyAll(Status, ApprovalEntry.Status::Canceled);
        GenJnlBatch_var.Validate("Review Status", GenJnlBatch_var."Review Status"::" ");
        GenJnlBatch_var.Reviewed:=false;
        GenJnlBatch_var.Modify();
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnPostDtldVendLedgEntriesOnBeforeCreateGLEntriesForTotalAmounts, '', false, false)]
    local procedure "Gen. Jnl.-Post Line_OnPostDtldVendLedgEntriesOnBeforeCreateGLEntriesForTotalAmounts"(var Sender: Codeunit "Gen. Jnl.-Post Line"; var VendPostingGr: Record "Vendor Posting Group"; var DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer"; GenJournalLine: Record "Gen. Journal Line"; var TempDimensionPostingBuffer: Record "Dimension Posting Buffer" temporary; AdjAmountBuf: array[4]of Decimal; SavedEntryNo: Integer; LedgEntryInserted: Boolean; var IsHandled: Boolean)
    begin
    end;
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Batch", OnAfterSetupNewBatch, '', false, false)]
    local procedure "Gen. Journal Batch_OnAfterSetupNewBatch"(var GenJnlBatch: Record "Gen. Journal Batch")
    begin
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ICInboxOutboxMgt, OnBeforeInsertGenJnlLine, '', false, false)]
    local procedure ICInboxOutboxMgt_OnBeforeInsertGenJnlLine(var GenJnlLine: Record "Gen. Journal Line"; ICInboxJnlLine: Record "IC Inbox Jnl. Line")
    begin
        //#291 VJ 23MAY2025 added condtion
        if GenJnlLine."IC Partner Transaction No." <> 0 then begin
            //if (GenJnlLine."Account Type" = GenJnlLine."Account Type"::"Bank Account") AND (GenJnlLine."Source Code" = 'INTERCOMP') AND (GenJnlLine."Bypass API") then begin
            if(GenJnlLine."Account Type" = GenJnlLine."Account Type"::"Bank Account") AND (GenJnlLine."Source Code" = 'INTERCOMP')then begin //Bypass API condition is only in source company and not in target company//03June2025
                GenJnlLine.Validate("IC Account Type", GenJnlLine."IC Account Type"::"Bank Account");
                GenJnlLine.Validate("IC Account No.", '');
            end;
        end;
    //#291 VJ 23MAY2025 added condtion
    end;
    var ErrorUser: Label 'User does not match with General Journal Batch approval user';
    CU80: Codeunit 12;
    P615: page 615;
    Cu427: Codeunit 427;
    CU12: Codeunit 12;
    cu432: Codeunit 432;
    DocNo: code[20];
}
