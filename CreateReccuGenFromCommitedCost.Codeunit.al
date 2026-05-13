codeunit 50121 CreateReccuGenFromCommitedCost
{
    TableNo = "PB Committed Cost Inbound";

    trigger OnRun()
    var
        p283: page 283;
        ErrorText: Text[1024];
        LineNo: Integer;
        InhandStock: Decimal;
        AdjustmentStock: Decimal;
        DocNo: Code[20];
        //PbcommittedCostInb: Record "PB Committed Cost Inbound";
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
        Customer: Record Customer;
        GLAccount: Record "G/L Account";
        Currency: Record "Currency";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        // DefaultCustomerSetup: Record "Default Customer Setup";
        PaymentMethod: Record "Payment Method";
        //PostedSalesInvoice: Record "Sales Invoice Header";
        ReqFreq: DateFormula;
        Description: text[20];
        OrderCode: text[50];
        DNVCommittedCostDetails: record "DNV Commited Cost Details";
        GlDescription: Text;
        VMT: record VMT;
        CompanyMapping: record "Company Name Mapping";
        l_cdu_GenPost: Codeunit "Gen. Jnl.-Post Line";
        TotalGLAmount: Decimal;
        TotalGLAmountLCY: Decimal;
        mEntryNo: Integer;
        GlEntry: Record "G/L Entry";
    begin
        CompanyMapping.Reset();
        CompanyMapping.SetRange("BC Company Name", CompanyName);
        CompanyMapping.FindSet();
        VMT.Reset();
        vmt.SetFilter(SHIPSIGN, format(rec."Asset ID"));
        vmt.FindSet();
        DNVSetup.Get();
        DNVSetup.TestField("Recurring Gen. Jnl. Batch");
        DNVSetup.TestField("Recurring Gen. Jnl. Template");
        DNVSetup.TestField("Accrual No Series");
        DNVSetup.TestField("Commited Cost Bal. Account No.");
        Evaluate(ReqFreq, '1D');
        LineNo:=GetLastLineNoJournal(DNVSetup."Recurring Gen. Jnl. Template", DNVSetup."Recurring Gen. Jnl. Batch");
        TotalGLAmount:=0;
        TotalGLAmountLCY:=0;
        //PbcommittedCostInb.SetFilter(Status, '<>%1|%2', PbcommittedCostInb.Status::Processed, PbcommittedCostInb.Status::Cancel);
        //        PbcommittedCostInb.SetFilter(Status, '%1|%2', PbcommittedCostInb.Status::Pending, PbcommittedCostInb.Status::Error);
        //PbcommittedCostInb.Setfilter("Asset ID", '<>%1', '');
        DNVCommittedCostDetails.Reset();
        DNVCommittedCostDetails.SetRange("Entry No.", rec."Entry No.");
        DNVCommittedCostDetails.SetFilter("Accrual Amount", '>%1', 0);
        if DNVCommittedCostDetails.FindSet()then begin
            //LineNo := 0;
            DocNo:=format(Rec."Entry No.");
            GenJournalLine.Reset();
            GenJournalLine.SETRANGE("Journal Template Name", DNVSetup."Recurring Gen. Jnl. Template");
            GenJournalLine.SETRANGE("Journal Batch Name", DNVSetup."Recurring Gen. Jnl. Batch");
            IF NOT GenJournalLine.FindLast()THEN LineNo:=0
            else
                LineNo:=GenJournalLine."Line No.";
            repeat LineNo:=LineNo + 10000;
                GlDescription:=rec."Asset ID" + '  ' + DNVCommittedCostDetails."Account Code" + '  ' + rec."Order Code";
                GenJournalLine.Init();
                GenJournalLine."Journal Template Name":=DNVSetup."Recurring Gen. Jnl. Template";
                GenJournalLine."Journal Batch Name":=DNVSetup."Recurring Gen. Jnl. Batch";
                GenJournalLine."Line No.":=LineNo;
                GenJournalLine."Document No.":=DocNo;
                GenJournalLine.Validate("Recurring Method", GenJournalLine."Recurring Method"::"RF Reversing Fixed");
                GenJournalLine.Validate("Recurring Frequency", ReqFreq);
                GenJournalLine.Validate("Account Type", GenJournalLine."Account Type"::"G/L Account");
                GenJournalLine.Validate("Account No.", DNVSetup."G/L Account Initials Sync" + DNVCommittedCostDetails."Account Code");
                GenJournalLine."External Document No.":=rec."Order Code";
                GenJournalLine.Validate(Description, GlDescription);
                GenJournalLine.Validate("Document Type", GenJournalLine."Document Type"::" ");
                GenJournalLine.VALIDATE("Posting Date", Rec."Posting Date");
                GenJournalLine.VALIDATE("Document Date", rec."Posting Date");
                GenJournalLine.VALIDATE("Currency Code", DNVCommittedCostDetails."Currency Code");
                GenJournalLine.validate(Amount, DNVCommittedCostDetails."Accrual Amount");
                //GenJournalLine.Validate("Bal. Account Type", GenJournalLine."Bal. Account Type"::"G/L Account");
                //GenJournalLine.Validate("Bal. Account No.", DNVSetup."Commited Cost Bal. Account No.");//06112024
                GenJournalLine.Validate("DNV Staging Entry No.", rec."Entry No.");
                GenJournalLine.Validate("Shortcut Dimension 1 Code", vmt.SEGMENT);
                GenJournalLine.Validate("Shortcut Dimension 2 Code", 'DACCR');
                GenJournalLine.Validate("Shortcut Dimension 8 Code", CompanyMapping."PB Company Code");
                GenJournalLine.Validate("Shortcut Dimension 9 Code", DNVSetup."Invoice Countrt Party Type"); // take fro msetup
                GenJournalLine.Validate("Shortcut Dimension 10 Code", VMT.VESSELCODE);
                GenJournalLine.validate("Expiration Date", Today);
                GenJournalLine.Insert(true);
                TotalGLAmount:=TotalGLAmount + GenJournalLine.Amount;
                TotalGLAmountLCY:=TotalGLAmountLCY + GenJournalLine."Amount (LCY)";
                DNVCommittedCostDetails."Document No.":=DocNo;
                DNVCommittedCostDetails.Modify();
            until DNVCommittedCostDetails.Next() = 0;
            if TotalGLAmount <> 0 then begin
                LineNo:=LineNo + 10000;
                GenJournalLine.Init();
                GenJournalLine."Journal Template Name":=DNVSetup."Recurring Gen. Jnl. Template";
                GenJournalLine."Journal Batch Name":=DNVSetup."Recurring Gen. Jnl. Batch";
                GenJournalLine."Line No.":=LineNo;
                GenJournalLine."Document No.":=DocNo;
                GenJournalLine.Validate("Recurring Method", GenJournalLine."Recurring Method"::"RF Reversing Fixed");
                GenJournalLine.Validate("Recurring Frequency", ReqFreq);
                GenJournalLine.Validate("Account Type", GenJournalLine."Account Type"::"G/L Account");
                GenJournalLine.Validate("Account No.", DNVSetup."Commited Cost Bal. Account No.");
                GenJournalLine.Validate(Description, GlDescription);
                GenJournalLine.Validate("Document Type", GenJournalLine."Document Type"::" ");
                GenJournalLine.VALIDATE("Posting Date", rec."Posting Date");
                GenJournalLine.VALIDATE("Document Date", rec."Posting Date");
                GenJournalLine.VALIDATE("Currency Code", DNVCommittedCostDetails."Currency Code");
                GenJournalLine."External Document No.":=rec."Order Code";
                GenJournalLine.validate(Amount, -1 * TotalGLAmount);
                GenJournalLine.Validate("Amount (LCY)", -1 * TotalGLAmountLCY);
                //GenJournalLine.Validate("Bal. Account Type", GenJournalLine."Bal. Account Type"::"G/L Account");
                //GenJournalLine.Validate("Bal. Account No.", DNVSetup."Commited Cost Bal. Account No.");//06112024
                GenJournalLine.Validate("DNV Staging Entry No.", rec."Entry No.");
                GenJournalLine.Validate("Shortcut Dimension 1 Code", vmt.SEGMENT);
                GenJournalLine.Validate("Shortcut Dimension 2 Code", 'DACCR');
                GenJournalLine.Validate("Shortcut Dimension 8 Code", CompanyMapping."PB Company Code");
                GenJournalLine.Validate("Shortcut Dimension 9 Code", DNVSetup."Invoice Countrt Party Type"); // take fro msetup
                GenJournalLine.Validate("Shortcut Dimension 10 Code", VMT.VESSELCODE);
                GenJournalLine.Insert(true);
            end;
            //if not DNVSetup."Auto Post Recurring Journal" then
            //
            if DNVSetup."Auto Post Recurring Journal" then begin
                Clear(l_cdu_GenPost);
                GenJournalLine.Reset();
                GenJournalLine.SETRANGE("Journal Template Name", DNVSetup."Recurring Gen. Jnl. Template");
                GenJournalLine.SETRANGE("Journal Batch Name", DNVSetup."Recurring Gen. Jnl. Batch");
                GenJnlPostBatch.Run(GenJournalLine);
                GenJournalLine.Reset();
                GenJournalLine.SETRANGE("Journal Template Name", DNVSetup."Recurring Gen. Jnl. Template");
                GenJournalLine.SETRANGE("Journal Batch Name", DNVSetup."Recurring Gen. Jnl. Batch");
                if GenJournalLine.FindSet()then GenJournalLine.DeleteAll();
                GlEntry.Reset();
                GlEntry.SetCurrentKey("DNV Staging Entry No.");
                GlEntry.SetRange("DNV Staging Entry No.", rec."Entry No.");
                GlEntry.SetRange("External Document No.", Rec."Order Code");
                if GlEntry.FindLast()then begin
                    rec."Posted Document No":=GlEntry."Document No.";
                    rec.Modify();
                end;
            end;
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
    var CommintedCost: Record "PB Committed Cost Inbound";
    VendorNo: code[20];
    LineNo: Integer;
    SuccessTrue: Boolean;
    DimSetID: Integer;
    Item: Record Item;
    ItemErrorLogEntry: Record "Inbound Error Log Entry";
    i: Integer;
    IsError: Boolean;
    Location: Record Location;
    DNVSetup: Record "DNV Integration Setup";
    mpae: page 283;
}
