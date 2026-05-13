codeunit 50101 "Process Allocation Rules"
{
    TableNo = "Allocation Rule";

    trigger OnRun()
    begin
        ProcessRule(Rec);
    end;
    local procedure ProcessRule(Rec: Record "Allocation Rule")
    var
    begin
        IF NOT Confirm('Are you sure you want to Process the journal', false)then Exit;
        StartDate:=CalcDate('-CM', Today);
        EndDate:=CalcDate('CM', Today);
        SourceAmount:=FindSourceAmount(Rec);
        FindDestination(Rec);
    end;
    local procedure FindSourceAmount(Rec: Record "Allocation Rule"): Decimal var
        AllocationSource_Dim: Record "Allocation Source";
        GLEntry: Record "G/L Entry";
        GlAcc_l: Record "G/L Account";
        DimSetEntry_Temp: Record "Dimension Set Entry" temporary;
        Dimvalue_l: Record "Dimension Value";
        DimMgt: Codeunit "DimensionManagement";
        LineNo_l: Integer;
        DimWiseAmount: Decimal;
    begin
        AllocationSource.Reset();
        AllocationSource.SetRange(Rule, Rec.Rule);
        AllocationSource.SetRange("Field Setting", AllocationSource."Field Setting"::"Main Account");
        AllocationSource.SetFilter("Source Criteria", '<>%1', '');
        If NOT AllocationSource.FindFirst()then exit;
        AllocationSource_Dim.Reset();
        AllocationSource_Dim.SetRange(Rule, Rec.Rule);
        AllocationSource_Dim.SetRange("Field Setting", AllocationSource_Dim."Field Setting"::"Financial Dimension");
        IF NOT AllocationSource_Dim.FindFirst()then exit;
        GenJnlLine_Temp.Reset();
        GenJnlLine_Temp.DeleteAll();
        Dimvalue_l.Reset();
        Dimvalue_l.SetRange("Dimension Code", AllocationSource_Dim.Name);
        Dimvalue_l.SetFilter(Code, AllocationSource_Dim."Source Criteria");
        If Dimvalue_l.FindSet()then repeat DimWiseAmount:=0;
                // GlAcc_l.Reset();
                // GlAcc_l.SetFilter("No.", AllocationSource."Source Criteria");
                // If GlAcc_l.FindSet() then
                //     repeat
                GLEntry.Reset();
                GLEntry.SetCurrentKey("G/L Account No.", "Posting Date");
                GLEntry.SetFilter("G/L Account No.", AllocationSource."Source Criteria"); //GlAcc_l."No.");
                GLEntry.SetRange("Posting Date", StartDate, EndDate);
                If GLEntry.FindSet()then repeat DimSetEntry_Temp.Reset();
                        DimMgt.GetDimensionSet(DimSetEntry_Temp, GLEntry."Dimension Set ID");
                        DimSetEntry_Temp.Reset();
                        DimSetEntry_Temp.SetRange("Dimension Set ID", GLEntry."Dimension Set ID");
                        DimSetEntry_Temp.SetRange("Dimension Code", Dimvalue_l."Dimension Code");
                        DimSetEntry_Temp.SetRange("Dimension Value Code", Dimvalue_l.Code);
                        IF not DimSetEntry_Temp.IsEmpty then begin
                            DimWiseAmount+=GLEntry.Amount;
                        end;
                    until GLEntry.Next() = 0;
                IF NOT(DimWiseAmount = 0)then begin
                    LineNo_l+=10000;
                    GenJnlLine_Temp.Init();
                    GenJnlLine_Temp."Line No.":=LineNo_l;
                    GenJnlLine_Temp."Account No.":=AllocationSource."Source Criteria";
                    GenJnlLine_Temp.Amount:=DimWiseAmount;
                    GenJnlLine_Temp."Document No.":=Dimvalue_l."Dimension Code";
                    GenJnlLine_Temp."Bal. Account No.":=Dimvalue_l.Code;
                    GenJnlLine_Temp."Incoming Document Entry No.":=Dimvalue_l."Dimension Value ID";
                    GenJnlLine_Temp.Insert();
                end;
            // Until GlAcc_l.Next() = 0;
            until Dimvalue_l.Next() = 0;
        exit(GLEntry.Amount);
    end;
    local procedure FindDestination(Rec: Record "Allocation Rule")
    var
        AllocationDestination: Record "Allocation Destination";
    begin
        AllocationDestination.Reset();
        AllocationDestination.SetRange(Rule, Rec.Rule);
        If AllocationDestination.FindFirst()then begin
            GenJnlLine_Temp.Reset();
            IF GenJnlLine_Temp.FindSet()then repeat CreateICJournal(AllocationDestination);
                until GenJnlLine_Temp.Next() = 0;
        end;
    end;
    local procedure CreateICJournal(AllocationDestination_p: Record "Allocation Destination")
    var
        lastLineNo: Integer;
        ICPartner: Record "IC Partner";
        ICCOA: Record "IC G/L Account";
        GenJnlPost: Codeunit "Gen. Jnl.-Post Batch";
        LastGLEntryNo: Integer;
        DimValue_l: Record "Dimension Value";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        NewDimSetID: Integer;
        DimMgt: Codeunit DimensionManagement;
    begin
        ICPartner.Reset();
        ICPartner.Get(AllocationDestination_p.Company);
        ICPartner.TestField("Receivables Account");
        ICPartner.TestField("Payables Account");
        GetICSetup();
        ICSetup.TestField("Default IC Gen. Jnl. Template");
        ICSetup.TestField("Default IC Gen. Jnl. Batch");
        ICGenJnl.Reset();
        ICGenJnl.SetRange("Journal Template Name", ICSetup."Default IC Gen. Jnl. Template");
        ICGenJnl.SetRange("Journal Batch Name", ICSetup."Default IC Gen. Jnl. Batch");
        If ICGenJnl.FindLast()then lastLineNo:=ICGenJnl."Line No.";
        TempDimSetEntry.Reset();
        TempDimSetEntry.DeleteAll();
        lastLineNo+=10000;
        ICGenJnl.Init();
        ICGenJnl."Journal Template Name":=ICSetup."Default IC Gen. Jnl. Template";
        ICGenJnl."Journal Batch Name":=ICSetup."Default IC Gen. Jnl. Batch";
        ICGenJnl.Validate("Posting Date", Today);
        ICGenJnl."Line No.":=lastLineNo;
        ICGenJnl."Account Type":=ICGenJnl."Account Type"::"G/L Account";
        ICGenJnl.Validate("Account No.", ICPartner."Payables Account");
        ICGenJnl.Validate(Amount, GenJnlLine_Temp.Amount);
        ICGenJnl.Validate("Document No.", 'Alloc005');
        ICGenJnl.Validate("Bal. Account Type", ICGenJnl."Bal. Account Type"::"IC Partner");
        ICGenJnl.Validate("Bal. Account No.", AllocationDestination_p.Company);
        ICGenJnl.Validate("IC Account No.", AllocationDestination_p."To Account");
        ICGenJnl.Validate("Alloc. Rule", AllocationDestination_p.Rule);
        //ICGenJnl."PB IC Journal Template Name" := ICSetup."Default IC Gen. Jnl. Template";
        //ICgenJnl."PB IC Journal Batch Name" := ICSEtup."Default IC Gen. Jnl. Batch";
        //Insert Dimension --    
        DimValue_l.GET(GenJnlLine_Temp."Document No.", GenJnlLine_Temp."Bal. Account No.");
        TempDimSetEntry."Dimension Code":=DimValue_l."Dimension Code";
        TempDimSetEntry."Dimension Value Code":=DimValue_l.Code;
        TempDimSetEntry."Dimension Value ID":=DimValue_l."Dimension Value ID";
        TempDimSetEntry.INSERT(TRUE);
        NewDimSetID:=DimMgt.GetDimensionSetID(TempDimSetEntry);
        ICGenJnl.Validate("Dimension Set ID", NewDimSetID);
        ICGenJnl.Insert();
        Codeunit.Run(Codeunit::"Gen. Jnl.-Post Batch", ICGenJnl)// ICGenJnl.SendToPosting(Codeunit::"Gen. Jnl.-Post");
    // LastGLEntryNo := GenJnlPost.RunWithCheck(ICGenJnl);
    // GenJnlPost.Run(ICGenJnl);
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ICInboxOutboxMgt, OnInsertOutboxJnlLineOnBeforeICOutboxJnlLineInsert, '', false, false)]
    local procedure OnInsertOutboxJnlLineOnBeforeICOutboxJnlLineInsert(var ICOutboxJnlLine: Record "IC Outbox Jnl. Line"; TempGenJournalLine: Record "Gen. Journal Line" temporary)
    var
        InOutBoxJnlLineDim: Record "IC Inbox/Outbox Jnl. Line Dim.";
        AllocSource_l: Record "Allocation Source";
        AllocDest_l: Record "Allocation Destination";
        DimeSetEntry_l: Record "Dimension Set Entry";
        ToDimCode: Code[20];
        ToDimValue: Code[20];
    begin
        If TempGenJournalLine."Alloc. Rule" = '' then exit;
        ICOutboxJnlLine."Alloc. Rule":=TempGenJournalLine."Alloc. Rule";
        AllocationSource.Reset();
        AllocationSource.SetRange(Rule, TempGenJournalLine."Alloc. Rule");
        AllocationSource.SetRange("Field Setting", AllocationSource."Field Setting"::"Financial Dimension");
        IF AllocationSource.FindFirst()then begin
            DimeSetEntry_l.Reset();
            IF DimeSetEntry_l.Get(TempGenJournalLine."Dimension Set ID", AllocationSource.Name)then begin
                IF AllocationSource."Source Criteria".Contains(DimeSetEntry_l."Dimension Value Code")then begin
                    AllocDest_l.Reset();
                    AllocDest_l.SetRange(Rule, TempGenJournalLine."Alloc. Rule");
                    If AllocDest_l.FindFirst()then begin
                    /*
                        If AllocationSource.Name = AllocDest_l."Dimension 1 Code" then begin
                            ToDimCode := AllocDest_l."Dimension 1 Code";
                            ToDimValue := AllocDest_l."Dimension 1 Value";
                        end;
                        If AllocationSource.Name = AllocDest_l."Dimension 2 Code" then begin
                            ToDimCode := AllocDest_l."Dimension 2 Code";
                            ToDimValue := AllocDest_l."Dimension 2 Value";
                        end;
                        If AllocationSource.Name = AllocDest_l."Dimension 3 Code" then begin
                            ToDimCode := AllocDest_l."Dimension 3 Code";
                            ToDimValue := AllocDest_l."Dimension 3 Value";
                        end;
                        If AllocationSource.Name = AllocDest_l."Dimension 4 Code" then begin
                            ToDimCode := AllocDest_l."Dimension 4 Code";
                            ToDimValue := AllocDest_l."Dimension 4 Value";
                        end;
                        If AllocationSource.Name = AllocDest_l."Dimension 5 Code" then begin
                            ToDimCode := AllocDest_l."Dimension 5 Code";
                            ToDimValue := AllocDest_l."Dimension 5 Value";
                        end;
                        If AllocationSource.Name = AllocDest_l."Dimension 6 Code" then begin
                            ToDimCode := AllocDest_l."Dimension 6 Code";
                            ToDimValue := AllocDest_l."Dimension 6 Value";
                        end;
                        If AllocationSource.Name = AllocDest_l."Dimension 7 Code" then begin
                            ToDimCode := AllocDest_l."Dimension 7 Code";
                            ToDimValue := AllocDest_l."Dimension 7 Value";
                        end;
                        If AllocationSource.Name = AllocDest_l."Dimension 8 Code" then begin
                            ToDimCode := AllocDest_l."Dimension 8 Code";
                            ToDimValue := AllocDest_l."Dimension 8 Value";
                        end;
                        */
                    end;
                end
                Else
                    exit;
            end
            Else
                exit;
        end
        Else
            exit;
        InOutBoxJnlLineDim.Init();
        InOutBoxJnlLineDim."Table ID":=Database::"IC Outbox Jnl. Line";
        InOutBoxJnlLineDim."IC Partner Code":=TempGenJournalLine."IC Partner Code";
        InOutBoxJnlLineDim."Transaction No.":=ICOutboxJnlLine."Transaction No.";
        InOutBoxJnlLineDim."Transaction Source":=ICOutboxJnlLine."Transaction Source";
        InOutBoxJnlLineDim."Line No.":=ICOutboxJnlLine."Line No.";
        InOutBoxJnlLineDim."Dimension Code":=ToDimCode;
        InOutBoxJnlLineDim."Dimension Value Code":=ToDimValue;
        InOutBoxJnlLineDim.Insert();
    end;
    procedure GetICSetup()
    begin
        if RecordHasBeenRead then exit;
        ICSetup.Get();
        RecordHasBeenRead:=true;
    end;
    var AllocationSource: Record "Allocation Source";
    SourceAmount: Decimal;
    StartDate: Date;
    EndDate: Date;
    ICSetup: Record "IC Setup";
    RecordHasBeenRead: Boolean;
    ICGenJnl: Record "Gen. Journal Line";
    GenJnlLine_Temp: Record "Gen. Journal Line" temporary;
}
