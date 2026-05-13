codeunit 50106 PostGLLinefromStaging
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        ImportType: Enum "GL Import Type";
    begin
        CASE rec."Parameter String" OF 'GL': FindOpenStagingEntries(ImportType::GenJournal);
        'FA-GL': FindOpenStagingEntries(ImportType::FixedAsset);
        'IC-GL': FindOpenStagingEntries(ImportType::ICJournal);
        end;
    end;
    procedure FindOpenStagingEntries(ImportType: Enum "GL Import Type")
    var
        Staging: Record "Import Staging";
        LastDocNo: Code[20];
        LastTemp: Code[20];
        Lastbatch: Code[20];
        GLline: Record "Gen. Journal Line";
        CompanyNameMapping: Record "Company Name Mapping";
        ErrorText: text;
    begin
        CompanyNameMapping.Get(CompanyName);
        GJBuffer.Reset;
        GJBuffer.DeleteAll();
        CompanyNameMapping.TestField("PB Company Code");
        //"Vendor No.", "Item No.", "Variant Code"
        Staging.Reset();
        Staging.SetCurrentKey("Import Type", "Company Code", Status, "Journal Template", "Journal Batch", "Document No.");
        Staging.SetRange("Import Type", ImportType);
        Staging.SetRange("Company Code", CompanyNameMapping."PB Company Code");
        Staging.SetFilter(Status, '%1|%2', Staging.Status::Error, Staging.Status::Pending);
        // Staging.SetRange("Entry No.", 23171); //temporary
        If Staging.FindSet()then repeat IF NOT GJBuffer.GET(Staging."Company Code", Staging."Journal Template", Staging."Journal Batch", Staging."Document No.", Staging."Created By")then begin
                    GJBuffer.init;
                    GJBuffer."Company Code":=Staging."Company Code";
                    GJBuffer."Journal Template":=Staging."Journal Template";
                    GJBuffer."Journal Batch":=Staging."Journal Batch";
                    GJBuffer."Document No.":=Staging."Document No.";
                    GJBuffer."User Id":=Staging."Created By";
                    IF GJBuffer.Insert()then;
                end;
            Until Staging.Next() = 0;
        GJBuffer.Reset();
        IF GJBuffer.FINDFIRST()then repeat Staging.Reset();
                Staging.SetCurrentKey("Import Type", "Company Code", Status, "Journal Template", "Journal Batch", "Document No.", "Created By");
                Staging.SetRange("Import Type", ImportType);
                Staging.SetRange("Company Code", GJBuffer."Company Code");
                Staging.SetFilter(Status, '%1|%2', Staging.Status::Error, Staging.Status::Pending);
                Staging.SetRange("Journal Template", GJBuffer."Journal Template");
                Staging.SetRange("Journal Batch", GJBuffer."Journal Batch");
                Staging.SetRange("Document No.", GJBuffer."Document No.");
                Staging.SetRange("Created By", GJBuffer."User Id");
                //       Staging.SetRange("Entry No.", 23171); //temporary
                If Staging.FindSet()then begin
                    //repeat
                    Clear(CU_CreateJournal);
                    ClearLastError();
                    IF CU_CreateJournal.RUN(Staging)then;
                    ErrorText:=GetLastErrorText();
                    IF ErrorText = '' then UpdateStagingLineStatus(GJBuffer, '', true, CompanyNameMapping."PB Company Code", ImportType.AsInteger())
                    else
                        UpdateStagingLineStatus(GJBuffer, ErrorText, false, CompanyNameMapping."PB Company Code", ImportType.AsInteger());
                end;
                Commit();
            Until GJBuffer.Next() = 0;
    end;
    local procedure UpdateStagingLineStatus(var P_GJBuff: Record "GJ Staging Buffer" temporary; ErrorDesc: Text[250]; Processed_p: Boolean; P_CompName: Text; P_ImpType: Integer)
    var
        Staging: Record "Import Staging";
        Staging2: Record "Import Staging";
    begin
        Staging.Reset();
        Staging.SetCurrentKey("Company Code", Status, "Document No.");
        Staging.SetRange("Import Type", P_ImpType);
        Staging.SetRange("Company Code", P_CompName);
        Staging.SetFilter(Status, '%1|%2', Staging.Status::Error, Staging.Status::Pending);
        Staging.SetRange("Journal Template", P_GJBuff."Journal Template");
        Staging.SetRange("Journal Batch", P_GJBuff."Journal Batch");
        Staging.SetRange("Document No.", P_GJBuff."Document No.");
        Staging.SetRange("Created By", P_GJBuff."User Id");
        If Staging.FindSet()then repeat If Processed_p then begin
                    Staging2.GET(Staging."Entry No.");
                    Staging2.Status:=Staging2.Status::Processed;
                    Staging2."Error Description":='';
                end
                Else
                begin
                    Staging2.GET(Staging."Entry No.");
                    Staging2.Status:=Staging2.Status::Error;
                    Staging2."Error Description":=ErrorDesc;
                end;
                Staging2.Modify();
            until Staging.Next() = 0;
    end;
    var // TempDocumnetNo: Record "Item Vendor" temporary;
    GlSetup: Record "General Ledger Setup";
    lastLineNo: Integer;
    GenJnlline_g: Record "Gen. Journal Line";
    GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
    GenJnlPost: Codeunit "Gen. Jnl.-Post";
    GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    CU_CreateJournal: Codeunit "Create Journal Lines";
    GJBuffer: Record "GJ Staging Buffer" temporary;
}
