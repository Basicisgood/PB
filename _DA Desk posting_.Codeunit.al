codeunit 50226 "DA Desk posting"
{
    TableNo = "Marcura Payment Staging";

    trigger OnRun()
    var
        MarcuraSetup: record "Marcura Setup";
        GenJnlLine: Record "Gen. Journal Line";
        JnlPostBatch: Codeunit 50190;
        LineNo: Integer;
        GLEntry: Record "G/L Entry";
        NewbatchName: Code[20];
        DocumtNo: Code[20];
        NoSeries: Codeunit "No. Series";
        GJBatch: Record "Gen. Journal Batch";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: record "Vendor Ledger Entry";
        GlobalVendLedgEntry: Record "Global Vendor Ledger Entry";
        GlobalCustLedgEntry: Record "Global Cust. Ledger entry";
        IMOSBank: Record "IMOS Bank Mapping";
        GLSetup: Record "General Ledger Setup";
    begin
        MarcuraSetup.Get();
        GLSetup.get;
        //        GLEntry.Reset();
        //      GLEntry.SetRange("Marcura Entry No", Rec."Entry No.");
        //    if GLEntry.FindFirst() then exit;
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Marcura Entry No", Rec."Entry No.");
        if GenJnlLine.FindSet()then exit;
        if Rec."BC Document No" = '' then error('BC Document No can not be blank');
        if rec."Account Type" = rec."Account Type"::Customer then begin
            CustLedgEntry.Reset();
            CustLedgEntry.ChangeCompany(rec."Target Company Code");
            CustLedgEntry.SetRange("Customer No.", rec."Customer/Vendor No");
            CustLedgEntry.SetRange("Document No.", Rec."BC Document No");
            if not CustLedgEntry.FindFirst()then Error('Customer Ledger Entry not found for Customer No: %1 and Document No: %2', rec."Customer/Vendor No", Rec."BC Document No")
            else
            begin
                if CustLedgEntry.Open = false then Error('Customer Ledger Entry is not open for Customer No: %1 and Document No: %2', rec."Customer/Vendor No", Rec."BC Document No");
            end;
        end
        else
        begin
            VendLedgEntry.Reset();
            VendLedgEntry.ChangeCompany(rec."Target Company Code");
            VendLedgEntry.SetRange("Vendor No.", rec."Customer/Vendor No");
            VendLedgEntry.SetRange("Document No.", Rec."BC Document No");
            if not VendLedgEntry.FindFirst()then Error('Vendor Ledger Entry not found for Vendor No: %1 and Document No: %2', rec."Customer/Vendor No", Rec."BC Document No")
            else
            begin
                if VendLedgEntry.Open = false then Error('Vendor Ledger Entry is not open for Vendor No: %1 and Document No: %2', rec."Customer/Vendor No", Rec."BC Document No");
            end;
        end;
        InsertNewBatch(Rec."Posting Date", MarcuraSetup."Payment Template Name", '', Rec."BC  Bank Code", NewbatchName);
        GJBatch.Reset();
        GJBatch.SetRange("Journal Template Name", MarcuraSetup."Payment Template Name");
        GJBatch.SetRange("Name", NewbatchName);
        GJBatch.FindSet();
        if GJBatch."No. Series" = '' then UpdateNoseries(GJBatch);
        GenJnlLine.Reset();
        GenJnlLine.Setrange("Journal Template Name", MarcuraSetup."Payment Template Name");
        //GenJnlLine.Setrange("Journal Batch Name", MarcuraSetup."Payment Batch Name");
        GenJnlLine.Setrange("Journal Batch Name", NewbatchName);
        if GenJnlLine.FindLast()then begin
            LineNo:=GenJnlLine."Line No.";
        end
        else
        begin
            LineNo:=10000;
        end;
        LineNo:=LineNo + 10000;
        GenJnlLine.Reset();
        GenJnlLine.Init();
        GenJnlLine.Validate("Journal Template Name", MarcuraSetup."Payment Template Name");
        GenJnlLine.Validate("Journal Batch Name", NewbatchName);
        GenJnlLine.Validate("Line No.", LineNo);
        GenJnlLine.Validate("Posting Date", Rec."Posting Date");
        //GenJnlLine.Validate("Document No.", Format(Rec."Entry No."));
        DocumtNo:=NoSeries.GetNextNo(GJBatch."No. Series");
        GenJnlLine.Validate("Document No.", DocumtNo);
        if Rec."Account Type" = Rec."Account Type"::Customer then begin
            GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::Customer);
        end
        else if Rec."Account Type" = Rec."Account Type"::Vendor then begin
                GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::Vendor);
                if rec."Payment Amount" > 0 then GenJnlLine.validate("Document Type", GenJnlLine."Document Type"::Payment)
                else
                    GenJnlLine.validate("Document Type", GenJnlLine."Document Type"::"Refund");
            end;
        GenJnlLine.Validate("Account No.", Rec."Customer/Vendor No");
        GenJnlLine.Validate("Currency Code", Rec."Payment Currency");
        GenJnlLine."IMOS Transaction No":=Rec."IMOS Transaction ID";
        GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"Bank Account";
        GenJnlLine.validate("Bal. Account No.", rec."BC  Bank Code");
        GenJnlLine.Validate("Amount", 1 * Rec."Payment Amount");
        GenJnlLine.Validate("Amount (LCY)", 1 * Rec."Debit Amount");
        GenJnlLine."Applied Amount":=GenJnlLine.Amount;
        GenJnlLine."Marcura Entry No":=Rec."Entry No.";
        GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyName);
        // GenJnlLine.Validate("Shortcut Dimension 2 Code", MarcuraSetup."Payment Batch Name");
        GenJnlLine.Validate("Shortcut Dimension 9 Code", Rec."Vendor Type");
        //GenJnlLine."Invoice Link" := 'Marcura Payment';
        GenJnlLine."External Document No.":=Rec."Bank Reference";
        GenJnlLine."IMOS invoice":=true;
        GenJnlLine."Auto Post":=true;
        GenJnlLine."Bank Document No.":=NoSeries.GetNextNo(GLSetup."Bank Document Nos.");
        IMOSBank.Reset();
        IMOSBank.SetRange("BC Bank Code", Rec."BC  Bank Code");
        IMOSBank.FindSet();
        GenJnlLine."IMOS Bank ID":=IMOSBank."IMOS Bank ID";
        GenJnlLine.Insert(true);
        //BC Application
        if Rec."Account Type" = Rec."Account Type"::Vendor then begin
            GlobalVendLedgEntry.Reset();
            GlobalVendLedgEntry.SetRange("Vendor No.", Rec."Customer/Vendor No");
            GlobalVendLedgEntry.SetRange("Document No.", Rec."BC Document No");
            GlobalVendLedgEntry.SetRange(Open, true);
            GlobalVendLedgEntry.FindSet();
            GlobalVendLedgEntry.Validate("Applies-to ID", GenJnlLine."Document No.");
            GlobalVendLedgEntry.Validate("Amount to Apply", -1 * GenJnlLine.Amount);
            GlobalVendLedgEntry."Bank Document No. Applied":=GenJnlLine."Bank Document No.";
            GlobalVendLedgEntry.Modify();
            GenJnlLine.Validate("Applies-to ID", GenJnlLine."Document No.");
            GenJnlLine.Modify();
        end;
        Rec."Posted Document No":=GenJnlLine."Document No.";
        Rec."Error Description":='';
        Rec.Status:=rec.Status::Processed;
        rec.Modify();
        exit;
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", MarcuraSetup."Payment Template Name");
        GenJnlLine.SetRange("Journal Batch Name", MarcuraSetup."Payment Batch Name");
        GenJnlLine.SetRange("Document No.", Format(Rec."Entry No."));
        GenJnlLine.FindSet();
        JnlPostBatch.Run(GenJnlLine);
    end;
    procedure InsertNewBatch(EntryBookedDate: Date; TemplateName: Code[10]; BatchName: Text[10]; BalBankAccNo: Code[20]; var NewBatchName: Code[20])
    var
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlBatch2: Record "Gen. Journal Batch";
        GenJnlBatch_From: Record "Gen. Journal Batch";
        NewDateWiseBatch: Code[10];
    begin
        Clear(NewBatchName);
        IF GenJnlBatch_From.Get(TemplateName, BatchName)THEN;
        NewDateWiseBatch:='M' + Format(EntryBookedDate, 0, '<Month,2><Day,2>');
        GenJnlBatch.Reset();
        GenJnlBatch.SetRange("Journal Template Name", TemplateName);
        GenJnlBatch.SetFilter(Name, '%1', NewDateWiseBatch);
        //GenJnlBatch.SetRange("Staging EntryValueDate", EntryBookedDate);
        GenJnlBatch.SetRange("Bal. Account Type", GenJnlBatch."Bal. Account Type"::"Bank Account");
        GenJnlBatch.SetFilter("Bal. Account No.", BalBankAccNo);
        if NOT GenJnlBatch.FindFirst()THEN BEGIN
            NewDateWiseBatch:='M' + Format(EntryBookedDate, 0, '<Month,2><Day,2>');
            InsertBatch(TemplateName, NewDateWiseBatch, BalBankAccNo, EntryBookedDate);
        //END
        END
        ELSE
            NewDateWiseBatch:=GenJnlBatch.Name;
        NewBatchName:=NewDateWiseBatch;
    end;
    procedure InsertBatch(GenTempName: Code[10]; NewBatchName: Code[10]; BalBankAccNo: Code[20]; EntryBookedDate: Date)
    var
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlTempl: Record "Gen. Journal Template";
    begin
        GenJnlTempl.Get(GenTempName);
        Clear(GenJnlBatch);
        GenJnlBatch.Init();
        GenJnlBatch."Journal Template Name":=GenTempName;
        GenJnlBatch.Name:=NewBatchName;
        GenJnlBatch.Description:='Marcura Payment';
        GenJnlBatch.Validate("Bal. Account Type", GenJnlBatch."Bal. Account Type"::"Bank Account");
        GenJnlBatch.Validate("Bal. Account No.", BalBankAccNo);
        GenJnlBatch."No. of Approved":=0;
        GenJnlBatch."No. of Pending":=0;
        GenJnlBatch."No. of Rejected":=0;
        GenJnlBatch."Total No.":=0;
        GenJnlBatch."Staging EntryValueDate":=EntryBookedDate;
        GenJnlBatch."Bypass API":=true;
        //GenJnlBatch."No. Series" := GenJnlTempl."No. Series";
        GenJnlBatch."Posting No. Series":=GenJnlTempl."Posting No. Series";
        if GenJnlBatch.Name <> 'DEFAULT' THEN GenJnlBatch."No Deletion After Post":=false;
        if GenJnlBatch.Insert(true)then;
    end;
    procedure UpdateNoseries(var GenJnlBatch_p: Record "Gen. Journal Batch")
    var
        Noseries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        GenJournalTemp: record "Gen. Journal Template";
        NoseriesStartingNo: Code[20];
        NoSeriesCode: Code[20];
        StartingNo: Code[10];
        page456: page 456;
        P457: page 457;
        //NoSeriesSetupImpl: Codeunit "No. Series - Setup Impl.";
        Implementation: Enum "No. Series Implementation";
    begin
        if GenJnlBatch_p.IsTemporary then exit;
        GenJournalTemp.Reset();
        GenJournalTemp.Get(GenJnlBatch_p."Journal Template Name");
        StartingNo:='0001';
        NoseriesStartingNo:=CompanyName + '-' + GenJnlBatch_p.Name + '-' + StartingNo;
        NoSeriesCode:=GenJnlBatch_p.Name;
        Noseries.Reset();
        Noseries.SetRange(Code, NoSeriesCode);
        if not Noseries.FindSet()then begin
            Noseries.Reset();
            Noseries.Init();
            Noseries.Code:=NoSeriesCode;
            Noseries.Description:=GenJournalTemp.Description;
            Noseries."Default Nos.":=true;
            Noseries."Manual Nos.":=true;
            Noseries.Insert();
        end;
        NoSeriesLine.Reset();
        NoSeriesLine.SetRange("Series Code", NoSeriesCode);
        if not NoSeriesLine.FindSet()then begin
            NoSeriesLine.Reset();
            NoSeriesLine.Init();
            NoSeriesLine."Series Code":=NoSeriesCode;
            NoSeriesLine."Line No.":=10000;
            NoSeriesLine.validate("Starting No.", NoseriesStartingNo);
            NoSeriesLine."Increment-by No.":=1;
            NoSeriesLine.Open:=true;
            NoSeriesLine.Validate(Implementation, NoSeriesLine.Implementation::Sequence);
            NoSeriesLine."Sequence Name":=Format(CreateGuid(), 0, 4);
            NoSeriesLine."Starting Sequence No.":=1;
            NoSeriesLine.Insert();
        end;
        GenJnlBatch_p."No. Series":=NoSeriesCode;
        GenJnlBatch_p.Modify();
    end;
}
