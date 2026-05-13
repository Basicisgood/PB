codeunit 50123 CreateGenJournlFromCrewPayroll
{
    trigger OnRun()
    begin
        // GetGnlJnlLineRecord();
        ProcessPbCrewPayroll();
    end;
    procedure ProcessPbCrewPayroll()
    var
        ErrorText: Text[1024];
        LineNo: Integer;
        InhandStock: Decimal;
        AdjustmentStock: Decimal;
        DocNo: Code[20];
        PBCrewPayrollInb: Record "PB Crew Payroll Inbound";
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
        Customer: Record Customer;
        GLAccount: Record "G/L Account";
        Currency: Record "Currency";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        CustomerNo: Code[20];
        PaymentMethod: Record "Payment Method";
        ReqFreq: DateFormula;
        Description: text[20];
        OrderCode: text[50];
    begin
        ClearLogEntry(50132, 0);
        if DNVSetup.Get()then;
        DNVSetup.TestField("Default Gen. Jnl. Template");
        DNVSetup.TestField("Default Gen. Jnl. Batch");
        Evaluate(ReqFreq, '1M');
        LineNo:=GetLastLineNoJournal(DNVSetup."Default Gen. Jnl. Template", DNVSetup."Default Gen. Jnl. Batch");
        PBCrewPayrollInb.RESET;
        PBCrewPayrollInb.SetFilter(Status, '<>%1|%2', PBCrewPayrollInb.Status::Processed, PBCrewPayrollInb.Status::Cancel);
        PBCrewPayrollInb.SetFilter(Status, '%1|%2', PBCrewPayrollInb.Status::Pending, PBCrewPayrollInb.Status::Error);
        IF PBCrewPayrollInb.FINDSET THEN REPEAT ClearLogEntry(50132, PBCrewPayrollInb."Entry No.");
                Clear(IsError);
                // IF NOT GLAccount.GET(PBCrewPayrollInb."Account Code") THEN BEGIN
                //     ErrorText := 'G/L Account Code does not exist : Account Code ' + PBCrewPayrollInb."Account Code";
                //     CreateInboundErrorLogEntry(50132, PBCrewPayrollInb."Entry No.", ErrorText);
                // end;
                // IF NOT GLAccount.GET(PBCrewPayrollInb."Item Name") THEN BEGIN
                //     ErrorText := 'Balance Account Code does not exist : Item Name ' + PBCrewPayrollInb."Item Name";
                //     CreateInboundErrorLogEntry(50132, PBCrewPayrollInb."Entry No.", ErrorText);
                // end;
                if not Currency.get(PBCrewPayrollInb."Currency Code")then begin
                    ErrorText:='Currency Code does not exist : Currency Code' + PBCrewPayrollInb."Currency Code";
                    CreateInboundErrorLogEntry(50132, PBCrewPayrollInb."Entry No.", ErrorText);
                end;
                // if PBCrewPayrollInb."Delivered Quantity" = 0 then begin
                //     ErrorText := 'Delivered Quantity does not Blank : Entry No.' + Format(PBCrewPayrollInb."Entry No.");
                //     CreateInboundErrorLogEntry(50132, PBCrewPayrollInb."Entry No.", ErrorText);
                // end;
                // if PBCrewPayrollInb."Invoiced Quantity" = 0 then begin
                //     ErrorText := 'Invoiced Quantity Code does not Blank :Entry No.' + format(PBCrewPayrollInb."Entry No.");
                //     CreateInboundErrorLogEntry(50132, PBCrewPayrollInb."Entry No.", ErrorText);
                // end;
                // if PBCrewPayrollInb."Single Price" = 0 then begin
                //     ErrorText := 'Single Price does not 0 : Entry No.' + Format(PBCrewPayrollInb."Entry No.");
                //     CreateInboundErrorLogEntry(50132, PBCrewPayrollInb."Entry No.", ErrorText);
                // end;
                if IsError = false then begin
                    GenJournalLine.Reset();
                    GenJournalLine.SETRANGE("Journal Template Name", DNVSetup."Default Gen. Jnl. Template");
                    GenJournalLine.SETRANGE("Journal Batch Name", DNVSetup."Default Gen. Jnl. Batch");
                    GenJournalLine.SetRange("DNV Staging Entry No.", PBCrewPayrollInb."Entry No."); //
                    IF NOT GenJournalLine.FindFirst()THEN begin
                        LineNo:=LineNo + 10000;
                        GenJournalLine.Init();
                        GenJournalLine."Journal Template Name":=DNVSetup."Default Gen. Jnl. Template";
                        GenJournalLine."Journal Batch Name":=DNVSetup."Default Gen. Jnl. Batch";
                        GenJournalLine."Line No.":=LineNo;
                        IF GenJournalBatch.GET(DNVSetup."Default Gen. Jnl. Template", DNVSetup."Default Gen. Jnl. Batch")THEN IF GenJournalBatch."Posting No. Series" = '' THEN DocNo:=''
                            ELSE
                            BEGIN
                                DocNo:=NoSeriesMgt.GetNextNo(GenJournalBatch."Posting No. Series", WorkDate, true);
                                CLEAR(NoSeriesMgt);
                            END;
                        GenJournalLine."Document No.":=DocNo;
                        GenJournalLine.Validate("Account Type", GenJournalLine."Account Type"::"G/L Account");
                        GenJournalLine.Validate("Account Type", GenJournalLine."Account Type"::"G/L Account");
                        GenJournalLine.Validate(Description, Description);
                        GenJournalLine.Validate("Document Type", GenJournalLine."Document Type"::" ");
                        GenJournalLine.VALIDATE("Posting Date", Today);
                        GenJournalLine.VALIDATE("Document Date", Today);
                        GenJournalLine.VALIDATE("Currency Code", PBCrewPayrollInb."Currency Code");
                        GenJournalLine.Validate("Bal. Account Type", GenJournalLine."Bal. Account Type"::"G/L Account");
                        GenJournalLine.Validate("DNV Staging Entry No.", PBCrewPayrollInb."Entry No.");
                        GenJournalLine.Insert(true);
                    end;
                    Commit();
                end;
                If IsError = false then begin
                    PBCrewPayrollInb.Status:=PBCrewPayrollInb.Status::Processed;
                    PBCrewPayrollInb.Modify();
                end;
                if IsError = true then begin
                    PBCrewPayrollInb.Status:=PBCrewPayrollInb.Status::Error;
                    PBCrewPayrollInb.Modify();
                end;
            until PBCrewPayrollInb.Next() = 0;
        if IsError = false then begin
            if DNVSetup."Auto Post Recurring Journal" then begin
                Clear(GenJnlPostBatch);
                GenJournalLine.Reset();
                GenJournalLine.SetRange("Journal Template Name", DNVSetup."Default Gen. Jnl. Template");
                GenJournalLine.SetRange("Journal Batch Name", DNVSetup."Default Gen. Jnl. Batch");
                if GenJournalLine.FindSet()then begin
                    if Not GenJnlPostBatch.RUN(GenJournalLine)then PBCrewPayrollInb."Error Description":=GetLastErrorText();
                end end;
        end;
    end;
    procedure GetLastLineNoJournal(TemplateCode: Code[10]; BatchName: Code[20])LineNo: Integer var
        Item_Journals_Line_Rec: Record "Gen. Journal Line";
    begin
        Item_Journals_Line_Rec.Reset();
        Item_Journals_Line_Rec.SETRANGE("Journal Template Name", TemplateCode);
        Item_Journals_Line_Rec.SETRANGE("Journal Batch Name", BatchName);
        if Item_Journals_Line_Rec.FindLast()then exit(Item_Journals_Line_Rec."Line No.")
        else
            exit(0);
    end;
    local procedure ClearLogEntry(TableNo: Integer; EntryNo_p: Integer)
    begin
        //clear log
        ItemErrorLogEntry.Reset();
        ItemErrorLogEntry.SetRange("Inbound Table", TableNo);
        IF EntryNo_p <> 0 then ItemErrorLogEntry.SetRange("Inbound Entry No.", EntryNo_p);
        if ItemErrorLogEntry.FindFirst()then ItemErrorLogEntry.DeleteAll();
    end;
    local procedure CreateInboundErrorLogEntry(TableNo: Integer; EntryNo_p: Integer; ErrorText_p: Text)
    var
        LastEntryNo: Integer;
    begin
        ItemErrorLogEntry.Reset();
        if ItemErrorLogEntry.FindLast()then LastEntryNo:=ItemErrorLogEntry."Entry No."
        else
            LastEntryNo:=0;
        LastEntryNo:=LastEntryNo + 1;
        ItemErrorLogEntry.Init();
        ItemErrorLogEntry."Entry No.":=LastEntryNo;
        ItemErrorLogEntry."Inbound Table":=TableNo;
        ItemErrorLogEntry."Inbound Entry No.":=EntryNo_p;
        ItemErrorLogEntry."Error Text":=ErrorText_p;
        ItemErrorLogEntry.Insert();
        IsError:=true;
    end;
    procedure GetGnlJnlLineRecord()
    var
        GenjnlPost: Codeunit "Gen. Jnl.-Post";
        CrewPayrollDim: Record "PB Crew Payroll Dim Inb";
        AmountDim1: Decimal;
        AmountDim2: Decimal;
        AmountDim3: Decimal;
        CountLines: Integer;
    begin
        CrewPayrollInb.Reset();
        CrewPayrollInb.SetFilter("Status", '%1|%2', CrewPayrollInb."Status"::Pending, CrewPayrollInb."Status"::Error);
        if CrewPayrollInb.FindSet()then begin
            repeat AmountDim1:=0;
                AmountDim2:=0;
                AmountDim3:=0;
                CountLines:=0;
                CrewPayrollDimInb.Reset();
                CrewPayrollDimInb.SetRange("Crew Payroll Entry No.", CrewPayrollInb."Entry No."); //Main line
                CrewPayrollDimInb.SetFilter("Wage Dimension Code", '@D*');
                if CrewPayrollDimInb.FindSet()then begin
                    repeat AmountDim1+=-(CrewPayrollDimInb."Total Amount"); //For 'D'
                        CountLines:=1; //Added
                    until CrewPayrollDimInb.Next() = 0;
                    CreateGnlJnlLines(AmountDim1, CrewPayrollInb);
                end;
                CrewPayrollDimInb.Reset();
                CrewPayrollDimInb.SetRange("Crew Payroll Entry No.", CrewPayrollInb."Entry No.");
                CrewPayrollDimInb.SetFilter("Wage Dimension Code", '005');
                if CrewPayrollDimInb.FindSet()then begin
                    repeat AmountDim2+=-(CrewPayrollDimInb."Total Amount"); //For '005'
                        CountLines:=2; //Added
                    until CrewPayrollDimInb.Next() = 0;
                    CreateGnlJnlLines(AmountDim2, CrewPayrollInb);
                end;
                CrewPayrollDimInb.Reset();
                CrewPayrollDimInb.SetRange("Crew Payroll Entry No.", CrewPayrollInb."Entry No.");
                CrewPayrollDimInb.SetFilter("Wage Dimension Code", '<>%1&<>%2', '005', '@D*');
                if CrewPayrollDimInb.FindSet()then begin
                    repeat AmountDim3+=-(CrewPayrollDimInb."Total Amount"); //For all cases
                        CountLines:=3; //Added
                    until CrewPayrollDimInb.Next() = 0;
                    CreateGnlJnlLines(AmountDim3, CrewPayrollInb);
                end;
                if CountLines = TempCount then begin
                    CrewPayrollInb."Status":=CrewPayrollInb."Status"::Processed;
                    CrewPayrollInb.Modify();
                    GenJnlLine:=TempGenJnlLine;
                    Message('Posted');
                end
                else
                begin
                    CrewPayrollInb."Status":=CrewPayrollInb."Status"::Error;
                    CrewPayrollInb."Error Description":=GetLastErrorText();
                    CrewPayrollInb.Modify();
                    Message('There is an Error in Record Whose Entry No. is  %1', CrewPayrollInb."Entry No.");
                end;
            until CrewPayrollInb.Next() = 0;
        end;
    end;
    procedure CreateGnlJnlLines(var TAmount: Decimal; Stagingtab: Record "PB Crew Payroll Inbound")
    var
        GenJnlLine2: Record "Gen. Journal Line";
        DocumentNo: Code[20];
    begin
        GenJnlLine2.Reset();
        GenJnlLine2.SetRange("Journal Template Name", 'GENERAL');
        GenJnlLine2.SetRange("Journal Batch Name", 'DEFAULT');
        if GenJnlLine2.FindLast()then begin
            LineNo:=GenJnlLine2."Line No.";
        end
        else
            LineNo:=0;
        TempGenJnlLine.Init();
        TempGenJnlLine.Validate("Journal Template Name", 'GENERAL');
        TempGenJnlLine.Validate("Journal Batch Name", 'DEFAULT');
        TempGenJnlLine.Validate("Line No.", LineNo + 10000);
        TempGenJnlLine.Validate("Posting Date", WorkDate());
        DocumentNo:=NoSeries.GetNextNo('GJNL-GEN', Today, true); //New
        TempGenJnlLine.Validate("Document No.", DocumentNo); ///////////////////////////////////////////////
        TempGenJnlLine.Validate("Account No.", '1220'); //From G/L account Mapping table
        TempGenJnlLine.Validate("Account Type", TempGenJnlLine."Account Type"::"G/L Account");
        TempGenJnlLine.Validate(Description, CrewPayrollInb."Ship Short Sign" + CrewPayrollDimInb."Wage Dimension Value" + ' ' + Format(CrewPayrollInb."Payment From") + '-' + Format(CrewPayrollInb."Payment To"));
        TempGenJnlLine.Validate(Amount, TAmount);
        if TempGenJnlLine.Insert()then begin
            TempCount+=TempGenJnlLine.Count; //added
        end;
    end;
    var GenJnlLine: Record "Gen. Journal Line";
    TempGenJnlLine: Record "Gen. Journal Line" temporary;
    CrewPayrollInb: Record "PB Crew Payroll Inbound";
    CrewPayrollDimInb: Record "PB Crew Payroll Dim Inb";
    TempCount: Integer;
    NoSeries: Codeunit "No. Series";
    CommintedCost: Record "PB Crew Payroll Inbound";
    PBCommittedCosInbDim: record "PB Crew Payroll Dim Inb";
    VendorNo: code[20];
    LineNo: Integer;
    SuccessTrue: Boolean;
    DimSetID: Integer;
    Item: Record Item;
    ItemErrorLogEntry: Record "Inbound Error Log Entry";
    i: Integer;
    IsError: Boolean;
    NoSeriesMgt: Codeunit "No. Series";
    Location: Record Location;
    DNVSetup: Record "DNV Integration Setup";
}
