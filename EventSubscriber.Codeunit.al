codeunit 50212 EventSubscriber
{
    //VJ20FEB2025+++
    [EventSubscriber(ObjectType::Page, Page::Navigate, OnBeforeShowRecords, '', false, false)]
    local procedure OnBeforeShowRecords(var IsHandled: Boolean; var TempDocumentEntry: Record "Document Entry" temporary; DocNoFilter: Text; PostingDateFilter: Text);
    begin
        CitiInboundStaging.Reset();
        CitiInboundStaging.SetCurrentKey(TxEndtoEndId, EntryBookedDate);
        CitiInboundStaging.SetFilter(TxEndtoEndId, DocNoFilter);
        // CitiInboundStaging.SetFilter(EntryBookedDate, PostingDateFilter);//TEC.VJ 26JUNE2025 dates are different in entries
        CitiOutBoundStaging.Reset();
        CitiOutBoundStaging.SetCurrentKey("Bank Document No.", "Posting Date");
        CitiOutBoundStaging.SetFilter("Bank Document No.", DocNoFilter);
        // CitiOutBoundStaging.SetFilter("Posting Date", PostingDateFilter);//TEC.VJ 26JUNE2025
        HSBCInboundStaging.Reset();
        HSBCInboundStaging.SetCurrentKey(TxEndtoEndId, EntryBookedDate);
        HSBCInboundStaging.SetFilter(TxEndtoEndId, DocNoFilter);
        // HSBCInboundStaging.SetFilter(EntryBookedDate, PostingDateFilter);//TEC.VJ 26JUNE2025
        HSBCOutboundStaging.Reset();
        HSBCOutboundStaging.SetCurrentKey("Bank Document No.", "Posting Date");
        HSBCOutboundStaging.SetFilter("Bank Document No.", DocNoFilter);
        // HSBCOutboundStaging.SetFilter("Posting Date", PostingDateFilter);//TEC.VJ 26JUNE2025
        GLOBALVendLedEntry.Reset();
        GLOBALVendLedEntry.SetCurrentKey("Bank Document No.", "Posting Date");
        GLOBALVendLedEntry.SetFilter("Bank Document No.", DocNoFilter);
        // GLOBALVendLedEntry.SetFilter("Posting Date", PostingDateFilter);//TEC.VJ 26JUNE2025
        GLOBALEmpLedEntry.Reset();
        GLOBALEmpLedEntry.SetCurrentKey("Bank Document No.", "Posting Date");
        GLOBALEmpLedEntry.SetFilter("Bank Document No.", DocNoFilter);
        // GLOBALEmpLedEntry.SetFilter("Posting Date", PostingDateFilter);//TEC.VJ 26JUNE2025
        case TempDocumentEntry."Table ID" of Database::"Citi Inbound Staging": begin
            IsHandled:=true;
            PAGE.Run(PAGE::"Citi Inbound Staging", CitiInboundStaging);
        end;
        Database::"Citi Outbound Staging Table": begin
            IsHandled:=true;
            Page.Run(Page::"Citi Outbound Staging", CitiOutBoundStaging);
        end;
        Database::"HSBC Inbound Staging": begin
            IsHandled:=true;
            Page.Run(Page::"HSBC Inbound Staging", HSBCInboundStaging);
        end;
        Database::"HSBC Outbound Staging Table": begin
            IsHandled:=true;
            Page.Run(Page::"HSBC Outbound Staging", HSBCOutboundStaging);
        end;
        Database::"Global Vendor Ledger Entry": begin
            IsHandled:=true;
            Page.Run(Page::"Global Vendor Ledger Entries", GLOBALVendLedEntry);
        end;
        Database::"Global Employee Ledger Entry": begin
            IsHandled:=true;
            Page.Run(Page::"Global Employee Ledger Entries", GLOBALEmpLedEntry);
        end;
        end;
    end;
    [EventSubscriber(ObjectType::Page, Page::Navigate, 'OnAfterNavigateFindRecords', '', false, false)]
    local procedure OnAfterNavigateFindRecords(var DocumentEntry: Record "Document Entry" temporary; DocNoFilter: Text; PostingDateFilter: Text);
    begin
        CitiInbStaging(DocumentEntry, DocNoFilter, PostingDateFilter);
        CitiOutStaging(DocumentEntry, DocNoFilter, PostingDateFilter);
        HSBCInbStaging(DocumentEntry, DocNoFilter, PostingDateFilter);
        HSBCOutStaging(DocumentEntry, DocNoFilter, PostingDateFilter);
        GlobalVenLedEnties(DocumentEntry, DocNoFilter, PostingDateFilter);
        GlobalEmpLedEnties(DocumentEntry, DocNoFilter, PostingDateFilter);
    end;
    local procedure CitiInbStaging(var Rec: Record "Document Entry" temporary; DocNoFilter: Text; PostingDateFilter: Text)
    var
    begin
        if(DocNoFilter = '') and (PostingDateFilter = '')then exit;
        if CitiInboundStaging.ReadPermission()then begin
            CitiInboundStaging.Reset();
            CitiInboundStaging.SetFilter(TxEndtoEndId, DocNoFilter);
            // CitiInboundStaging.SetFilter(EntryBookedDate, PostingDateFilter);//TEC.VJ 26JUNE2025 dates are different in entries
            //Navigate.InsertIntoDocEntry(Rec, DATABASE::"Citi Inbound Staging", CitiInboundStagingText, CitiInboundStaging.Count);
            Rec.InsertIntoDocEntry(DATABASE::"Citi Inbound Staging", Enum::"Document Entry Document Type"::" ", CitiInboundStagingText, CitiInboundStaging.Count);
        end;
    end;
    local procedure CitiOutStaging(var Rec: Record "Document Entry" temporary; DocNoFilter: Text; PostingDateFilter: Text)
    var
    begin
        if(DocNoFilter = '') and (PostingDateFilter = '')then exit;
        if CitiOutBoundStaging.ReadPermission()then begin
            CitiOutBoundStaging.Reset();
            CitiOutBoundStaging.SetFilter("Bank Document No.", DocNoFilter);
            // CitiOutBoundStaging.SetFilter("Posting Date", PostingDateFilter);//TEC.VJ 26JUNE2025 dates are different in entries
            //Navigate.InsertIntoDocEntry(Rec, DATABASE::"Citi Outbound Staging Table", CitiOutBoundStagingText, CitiOutBoundStaging.Count);
            Rec.InsertIntoDocEntry(DATABASE::"Citi Outbound Staging Table", Enum::"Document Entry Document Type"::" ", CitiOutBoundStagingText, CitiOutBoundStaging.Count);
        end;
    end;
    local procedure HSBCInbStaging(var Rec: Record "Document Entry" temporary; DocNoFilter: Text; PostingDateFilter: Text)
    var
    begin
        if(DocNoFilter = '') and (PostingDateFilter = '')then exit;
        if HSBCInboundStaging.ReadPermission()then begin
            HSBCInboundStaging.Reset();
            HSBCInboundStaging.SetFilter(TxEndtoEndId, DocNoFilter);
            // HSBCInboundStaging.SetFilter(EntryValueDate, PostingDateFilter);//TEC.VJ 26JUNE2025 dates are different in entries
            //Navigate.InsertIntoDocEntry(Rec, DATABASE::"HSBC Inbound Staging", HSBCInboundStagingText, HSBCInboundStaging.Count);
            Rec.InsertIntoDocEntry(DATABASE::"HSBC Inbound Staging", Enum::"Document Entry Document Type"::" ", HSBCInboundStagingText, HSBCInboundStaging.Count);
        end;
    end;
    local procedure HSBCOutStaging(var Rec: Record "Document Entry" temporary; DocNoFilter: Text; PostingDateFilter: Text)
    var
    begin
        if(DocNoFilter = '') and (PostingDateFilter = '')then exit;
        if HSBCOutboundStaging.ReadPermission()then begin
            HSBCOutboundStaging.Reset();
            HSBCOutboundStaging.SetFilter("Bank Document No.", DocNoFilter);
            // HSBCOutboundStaging.SetFilter("Posting Date", PostingDateFilter);//TEC.VJ 26JUNE2025 dates are different in entries
            //Navigate.InsertIntoDocEntry(Rec, DATABASE::"HSBC Outbound Staging Table", HSBCOutboundStagingText, HSBCOutboundStaging.Count);
            Rec.InsertIntoDocEntry(DATABASE::"HSBC Outbound Staging Table", Enum::"Document Entry Document Type"::" ", HSBCOutboundStagingText, HSBCOutboundStaging.Count);
        end;
    end;
    local procedure GlobalVenLedEnties(var Rec: Record "Document Entry" temporary; DocNoFilter: Text; PostingDateFilter: Text)
    var
    begin
        if(DocNoFilter = '') and (PostingDateFilter = '')then exit;
        if GLOBALVendLedEntry.ReadPermission()then begin
            GLOBALVendLedEntry.Reset();
            GLOBALVendLedEntry.SetFilter("Bank Document No.", DocNoFilter);
            // GLOBALVendLedEntry.SetFilter("Posting Date", PostingDateFilter);//TEC.VJ 26JUNE2025 dates are different in entries
            //Navigate.InsertIntoDocEntry(Rec, DATABASE::"Global Vendor Ledger Entry", GLOBALVendLedEntryText, GLOBALVendLedEntry.Count);
            Rec.InsertIntoDocEntry(DATABASE::"Global Vendor Ledger Entry", Enum::"Document Entry Document Type"::" ", GLOBALVendLedEntryText, GLOBALVendLedEntry.Count);
        end;
    end;
    local procedure GlobalEmpLedEnties(var Rec: Record "Document Entry" temporary; DocNoFilter: Text; PostingDateFilter: Text)
    var
    begin
        if(DocNoFilter = '') and (PostingDateFilter = '')then exit;
        if GLOBALEmpLedEntry.ReadPermission()then begin
            GLOBALEmpLedEntry.Reset();
            GLOBALEmpLedEntry.SetFilter("Bank Document No.", DocNoFilter);
            // GLOBALEmpLedEntry.SetFilter("Posting Date", PostingDateFilter);//TEC.VJ 26JUNE2025 dates are different in entries
            //Navigate.InsertIntoDocEntry(Rec, DATABASE::"Global Employee Ledger Entry", GLOBALEmpLedEntryText, GLOBALEmpLedEntry.Count);
            Rec.InsertIntoDocEntry(DATABASE::"Global Employee Ledger Entry", Enum::"Document Entry Document Type"::" ", GLOBALEmpLedEntryText, GLOBALEmpLedEntry.Count);
        end;
    end;
    //NT_ 06-11-2025 >>
    [EventSubscriber(ObjectType::Table, Database::"Reversal Entry", OnBeforeReverseEntries, '', false, false)]
    local procedure ErrorIfAppliedEntries(Number: Integer)
    var
        SelectedOneDetailedGLEntryCZA: Record "Detailed G/L Entry PB";
        SelectedTwoDetailedGLEntryCZA: Record "Detailed G/L Entry PB";
        GLEntry: Record "G/L Entry";
        IsApplied: Boolean;
    begin
        IsApplied:=false;
        GLEntry.Reset();
        GLEntry.SetRange("Transaction No.", Number);
        GLEntry.FindFirst();
        SelectedOneDetailedGLEntryCZA.SetCurrentKey("G/L Entry No.", "Posting Date");
        SelectedOneDetailedGLEntryCZA.SetRange("G/L Entry No.", GLEntry."Entry No.");
        SelectedOneDetailedGLEntryCZA.SetFilter("Applied G/L Entry No.", '<>0');
        SelectedOneDetailedGLEntryCZA.SetRange(Unapplied, false);
        if SelectedOneDetailedGLEntryCZA.FindSet()then repeat if SelectedOneDetailedGLEntryCZA."G/L Entry No." = SelectedOneDetailedGLEntryCZA."Applied G/L Entry No." then begin
                    SelectedTwoDetailedGLEntryCZA.SetRange("Applied G/L Entry No.", SelectedOneDetailedGLEntryCZA."Applied G/L Entry No.");
                    SelectedTwoDetailedGLEntryCZA.SetRange(Unapplied, false);
                    if SelectedTwoDetailedGLEntryCZA.FindSet()then repeat if SelectedTwoDetailedGLEntryCZA."G/L Entry No." <> SelectedTwoDetailedGLEntryCZA."Applied G/L Entry No." then IsApplied:=true;
                        until SelectedTwoDetailedGLEntryCZA.Next() = 0;
                end
                else
                    IsApplied:=true;
            until SelectedOneDetailedGLEntryCZA.Next() = 0;
        if IsApplied then Error('Applied Entries found. Must unapply entries before reverse transaction.');
    end;
    //NT_ 06-11-2025 <<
    var CitiInboundStaging: Record "Citi Inbound Staging";
    CitiOutBoundStaging: Record "Citi Outbound Staging Table";
    CitiInboundStagingText: Label 'Citi Inbound Staging';
    CitiOutBoundStagingText: Label 'Citi Outbound Staging Table';
    Navigate: Page Navigate;
    HSBCInboundStaging: Record "HSBC Inbound Staging";
    HSBCInboundStagingText: Label 'HSBC Inbound Staging';
    HSBCOutboundStaging: Record "HSBC Outbound Staging Table";
    HSBCOutboundStagingText: Label 'HSBC Outbound Staging Table';
    GLOBALCustLedEntry: Record "Global Cust. Ledger entry";
    GLOBALCustLedEntryText: Label 'Global Cust. Ledger entry';
    GLOBALVendLedEntry: Record "Global Vendor Ledger Entry";
    GLOBALVendLedEntryText: Label 'Global Vendor Ledger Entry';
    GLOBALEmpLedEntry: Record "Global Employee Ledger Entry";
    GLOBALEmpLedEntryText: Label 'Global Employee Ledger Entry';
}
