codeunit 50145 "Create Journal Lines"
{
    TableNo = "Import Staging";

    trigger OnRun()
    begin
        CreateGenJournal(rec);
    end;
    local procedure CreateGenJournal(var StaginGl_p: Record "Import Staging"): Boolean var
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        LastGLEntryNo: Integer;
        Noseries: Codeunit "No. Series";
        GJB: Record "Gen. Journal Batch";
        GJT: Record "Gen. Journal Template";
        NewDocNo: Code[20];
    begin
        TempGJL.deleteAll;
        GJT.GET(StaginGl_p."Journal Template");
        IF NOT GJB.GET(StaginGl_p."Journal Template", StaginGl_p."Journal Batch")then begin
            GJB.Init();
            GJB."Journal Template Name":=StaginGl_p."Journal Template";
            GJB.Name:=StaginGl_p."Journal Batch";
            GJB.Description:=StaginGl_p."Batch Description";
            GJB."No. Series":=GJT."No. Series";
            GJB.Insert();
        end;
        GenJnlline_g.Reset();
        GenJnlline_g.SetRange("Journal Template Name", StaginGl_p."Journal Template");
        GenJnlline_g.SetRange("Journal Batch Name", StaginGl_p."Journal Batch");
        IF GenJnlline_g.FindLast()then lastLineNo:=GenJnlline_g."Line No."
        Else
            lastLineNo:=0;
        IF StaginGl_p.FindFirst()then repeat TempGJL.InitNewLine(StaginGl_p."Posting Date", StaginGl_p."Posting Date", 0D, '', '', '', 0, '');
                TempGJL."Journal Template Name":=StaginGl_p."Journal Template";
                TempGJL."Journal Batch Name":=StaginGl_p."Journal Batch";
                TempGJL.Validate("Document No.", StaginGl_p."Document No.");
                lastLineNo:=lastLineNo + 10000;
                TempGJL."Line No.":=lastLineNo;
                TempGJL.Validate("Account Type", StaginGl_p."Account Type");
                TempGJL.Validate("Account No.", StaginGl_p."Account No.");
                TempGJL.Description:=StaginGl_p.Description;
                if TempGJL."Account Type" = StaginGl_p."Account Type"::"Fixed Asset" then begin
                    //  GenJnlline_g.Validate("Depreciation Book Code", StaginGl_p."Depreciation Book Code");
                    TempGJL.Validate("FA Posting Type", StaginGl_p."FA Posting Type");
                    TempGJL."FA Posting Date":=StaginGl_p."FA Posting Date";
                    TempGJL."Salvage Value":=StaginGl_p."Salvage Value";
                end;
                TempGJL.Validate(Amount, StaginGl_p.Amount);
                If StaginGl_p."Currency Code" <> '' then begin
                    TempGJL.Validate("Currency Code", StaginGl_p."Currency Code");
                    IF StaginGl_p."Amount LCY" <> 0 then TempGJL.Validate("Amount (LCY)", StaginGl_p."Amount LCY");
                end;
                TempGJL."External Document No.":=StaginGl_p."External Doc No.";
                TempGJL.Validate("Bal. Account Type", StaginGl_p."Bal. Acc. Type");
                TempGJL.Validate("Bal. Account No.", StaginGl_p."Bal. Acc. No.");
                TempGJL.Validate("Shortcut Dimension 1 Code", StaginGl_p."Global Dimension 1");
                TempGJL.Validate("Shortcut Dimension 2 Code", StaginGl_p."Global Dimension 2");
                GlSetup.Get();
                NewDimSetID:=0;
                CreateDimensions(StaginGl_p);
                IF NewDimSetID <> 0 then TempGJL.Validate("Dimension Set ID", NewDimSetID);
                if StaginGl_p."Import Type" = StaginGl_p."Import Type"::ICJournal then begin
                    TempGJL."PB IC Account Type":=StaginGl_p."PB IC Account Type".AsInteger();
                    TempGJL."PB IC Account":=StaginGl_p."PB IC Account No.";
                    if(TempGJL."Account Type" in[TempGJL."Account Type"::"G/L Account", TempGJL."Account Type"::"Bank Account"]) and (TempGJL."Account No." <> '')then begin //#314 TEC.VJ 22APR2025
                        TempGJL."IC Account Type":=TempGJL."Account Type";
                        TempGJL."IC Account No.":=TempGJL."Account No.";
                    end;
                    TempGJL."IC Dimension 1":=StaginGl_p."IC Global Dimension 1";
                    TempGJL."IC Dimension 2":=StaginGl_p."IC Global Dimension 2";
                    TempGJL."IC Dimension 3":=StaginGl_p."IC Shortcut Dimension 3";
                    TempGJL."IC Dimension 4":=StaginGl_p."IC Shortcut Dimension 4";
                    TempGJL."IC Dimension 5":=StaginGl_p."IC Shortcut Dimension 5";
                    TempGJL."IC Dimension 6":=StaginGl_p."IC Shortcut Dimension 6";
                    TempGJL."IC Dimension 7":=StaginGl_p."IC Shortcut Dimension 7";
                    TempGJL."IC Dimension 8":=StaginGl_p."IC Shortcut Dimension 8";
                    TempGJL."IC Dimension 9":=StaginGl_p."IC Shortcut Dimension 9";
                    TempGJL."IC Dimension 10":=StaginGl_p."IC Shortcut Dimension 10";
                    TempGJL."IC Dimension 11":=StaginGl_p."IC Shortcut Dimension 11";
                    TempGJL."IC Dimension 12":=StaginGl_p."IC Shortcut Dimension 12";
                end;
                TempGJL."Document No.":=StaginGl_p."Document No."; //PS099
                TempGJL.Insert(true);
            until StaginGl_p.Next() = 0;
        //PS099 Start
        /*
        IF TempGJL.FindFirst() then begin
            NewDocNo := Noseries.GetNextNo(GJB."No. Series", Today);
            repeat
                GenJnlline_g.TransferFields(TempGJL);
                GenJnlline_g."Document No." := NewDocNo;
                GenJnlline_g.insert;
            until TempGJL.Next() = 0;
        end;
        */
        //PS099 End
        IF TempGJL.FindFirst()then begin
            repeat GenJnlline_g.TransferFields(TempGJL);
                GenJnlline_g.insert;
            until TempGJL.Next() = 0;
        end;
    end;
    local procedure CreateDimensions(Staging_p: Record "Import Staging")
    begin
        //Insert Dimension --    
        TempDimSetEntry.Reset();
        TempDimSetEntry.DeleteAll();
        IF(NOT(Staging_p."Global Dimension 1" = ''))then begin
            DimValue_l.GET(GlSetup."Global Dimension 1 Code", Staging_p."Global Dimension 1");
            TempDimSetEntry."Dimension Code":=DimValue_l."Dimension Code";
            TempDimSetEntry."Dimension Value Code":=DimValue_l.Code;
            TempDimSetEntry."Dimension Value ID":=DimValue_l."Dimension Value ID";
            TempDimSetEntry.INSERT(TRUE);
        end;
        IF(NOT(Staging_p."Global Dimension 2" = ''))then begin
            DimValue_l.GET(GlSetup."Global Dimension 2 Code", Staging_p."Global Dimension 2");
            TempDimSetEntry."Dimension Code":=DimValue_l."Dimension Code";
            TempDimSetEntry."Dimension Value Code":=DimValue_l.Code;
            TempDimSetEntry."Dimension Value ID":=DimValue_l."Dimension Value ID";
            TempDimSetEntry.INSERT(TRUE);
        end;
        IF(NOT(Staging_p."Shortcut Dimension 3" = ''))then begin
            DimValue_l.GET(GlSetup."Shortcut Dimension 3 Code", Staging_p."Shortcut Dimension 3");
            TempDimSetEntry."Dimension Code":=DimValue_l."Dimension Code";
            TempDimSetEntry."Dimension Value Code":=DimValue_l.Code;
            TempDimSetEntry."Dimension Value ID":=DimValue_l."Dimension Value ID";
            TempDimSetEntry.INSERT(TRUE);
        end;
        IF(NOT(Staging_p."Shortcut Dimension 4" = ''))then begin
            DimValue_l.GET(GlSetup."Shortcut Dimension 4 Code", Staging_p."Shortcut Dimension 4");
            TempDimSetEntry."Dimension Code":=DimValue_l."Dimension Code";
            TempDimSetEntry."Dimension Value Code":=DimValue_l.Code;
            TempDimSetEntry."Dimension Value ID":=DimValue_l."Dimension Value ID";
            TempDimSetEntry.INSERT(TRUE);
        end;
        IF(NOT(Staging_p."Shortcut Dimension 5" = ''))then begin
            DimValue_l.GET(GlSetup."Shortcut Dimension 5 Code", Staging_p."Shortcut Dimension 5");
            TempDimSetEntry."Dimension Code":=DimValue_l."Dimension Code";
            TempDimSetEntry."Dimension Value Code":=DimValue_l.Code;
            TempDimSetEntry."Dimension Value ID":=DimValue_l."Dimension Value ID";
            TempDimSetEntry.INSERT(TRUE);
        end;
        IF(NOT(Staging_p."Shortcut Dimension 6" = ''))then begin
            DimValue_l.GET(GlSetup."Shortcut Dimension 6 Code", Staging_p."Shortcut Dimension 6");
            TempDimSetEntry."Dimension Code":=DimValue_l."Dimension Code";
            TempDimSetEntry."Dimension Value Code":=DimValue_l.Code;
            TempDimSetEntry."Dimension Value ID":=DimValue_l."Dimension Value ID";
            TempDimSetEntry.INSERT(TRUE);
        end;
        IF(NOT(Staging_p."Shortcut Dimension 7" = ''))then begin
            DimValue_l.GET(GlSetup."Shortcut Dimension 7 Code", Staging_p."Shortcut Dimension 7");
            TempDimSetEntry."Dimension Code":=DimValue_l."Dimension Code";
            TempDimSetEntry."Dimension Value Code":=DimValue_l.Code;
            TempDimSetEntry."Dimension Value ID":=DimValue_l."Dimension Value ID";
            TempDimSetEntry.INSERT(TRUE);
        end;
        IF(NOT(Staging_p."Shortcut Dimension 8" = ''))then begin
            DimValue_l.GET(GlSetup."Shortcut Dimension 8 Code", Staging_p."Shortcut Dimension 8");
            TempDimSetEntry."Dimension Code":=DimValue_l."Dimension Code";
            TempDimSetEntry."Dimension Value Code":=DimValue_l.Code;
            TempDimSetEntry."Dimension Value ID":=DimValue_l."Dimension Value ID";
            TempDimSetEntry.INSERT(TRUE);
        end;
        IF(NOT(Staging_p."Shortcut Dimension 9" = ''))then begin
            DimValue_l.GET(GlSetup."Shortcut Dimension 9 Code", Staging_p."Shortcut Dimension 9");
            TempDimSetEntry."Dimension Code":=DimValue_l."Dimension Code";
            TempDimSetEntry."Dimension Value Code":=DimValue_l.Code;
            TempDimSetEntry."Dimension Value ID":=DimValue_l."Dimension Value ID";
            TempDimSetEntry.INSERT(TRUE);
        end;
        IF(NOT(Staging_p."Shortcut Dimension 10" = ''))then begin
            DimValue_l.GET(GlSetup."Shortcut Dimension 10 Code", Staging_p."Shortcut Dimension 10");
            TempDimSetEntry."Dimension Code":=DimValue_l."Dimension Code";
            TempDimSetEntry."Dimension Value Code":=DimValue_l.Code;
            TempDimSetEntry."Dimension Value ID":=DimValue_l."Dimension Value ID";
            TempDimSetEntry.INSERT(TRUE);
        end;
        IF(NOT(Staging_p."Shortcut Dimension 11" = ''))then begin
            DimValue_l.GET(GlSetup."Shortcut Dimension 11 Code", Staging_p."Shortcut Dimension 11");
            TempDimSetEntry."Dimension Code":=DimValue_l."Dimension Code";
            TempDimSetEntry."Dimension Value Code":=DimValue_l.Code;
            TempDimSetEntry."Dimension Value ID":=DimValue_l."Dimension Value ID";
            TempDimSetEntry.INSERT(TRUE);
        end;
        IF(NOT(Staging_p."Shortcut Dimension 12" = ''))then begin
            DimValue_l.GET(GlSetup."Shortcut Dimension 12 Code", Staging_p."Shortcut Dimension 12");
            TempDimSetEntry."Dimension Code":=DimValue_l."Dimension Code";
            TempDimSetEntry."Dimension Value Code":=DimValue_l.Code;
            TempDimSetEntry."Dimension Value ID":=DimValue_l."Dimension Value ID";
            TempDimSetEntry.INSERT(TRUE);
        end;
        NewDimSetID:=DimMgt.GetDimensionSetID(TempDimSetEntry);
    end;
    var GenJnlline_g: Record "Gen. Journal Line";
    TempGJL: Record "Gen. Journal Line" temporary;
    lastLineNo: Integer;
    TempDimSetEntry: Record "Dimension Set Entry" temporary;
    NewDimSetID: Integer;
    DimMgt: Codeunit DimensionManagement;
    DimValue_l: Record "Dimension Value";
    GlSetup: Record "General Ledger Setup";
}
