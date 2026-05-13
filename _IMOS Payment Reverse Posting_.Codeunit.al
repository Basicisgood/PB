codeunit 50215 "IMOS Payment Reverse Posting"
{
    TableNo = "IMOS Payment Reversal Staging";

    trigger OnRun()
    var
        GLEntry: Record "G/L Entry";
        IMOSPayRevDetails: Record "IMOS Pay Reversal Details";
        IMOSSetup: Record "IMOS Setup";
        JnlPostBatch: Codeunit 50190;
        GenJnlLine: Record "Gen. Journal Line";
        TemplateCode: Code[10];
        BatchCode: Code[10];
        LineNo: Integer;
        CompanyMapping: record "Company Name Mapping";
        VMT: record VMT;
        GlSetup: Record "General Ledger Setup";
        lrec_Currency: Record Currency;
    begin
        IMOSSetup.Get();
        IMOSSetup.TestField("Default Payment Reversal Batch");
        IMOSSetup.TestField("Payment Reversal Batch");
        BatchCode:=IMOSSetup."Payment Reversal Batch";
        TemplateCode:=IMOSSetup."Default Payment Reversal Batch";
        GLEntry.Reset();
        GLEntry.SetCurrentKey("IMOS Transaction No");
        GLEntry.SetRange("IMOS Transaction No", Rec."Payment Transaction No.");
        GLEntry.SetRange(Reversed, false);
        if GLEntry.FindSet()then Error('Duplicate Transaction No');
        GLEntry.Reset();
        CompanyMapping.Get(CompanyName);
        VMT.Reset();
        vmt.SetRange(DBASE, CompanyMapping."PB Company Code");
        VMT.FindSet();
        IMOSPayRevDetails.Reset();
        IMOSPayRevDetails.SetRange("Entry No.", Rec."Entry No.");
        IMOSPayRevDetails.FindSet();
        GenJnlLine.Reset();
        GenJnlLine.setrange("Journal Template Name", TemplateCode);
        GenJnlLine.setrange("Journal Batch Name", BatchCode);
        if GenJnlLine.Findset then GenJnlLine.DeleteAll();
        LineNo:=0;
        repeat LineNo:=LineNo + 10000;
            GenJnlLine.Init();
            GenJnlLine."Journal Template Name":=TemplateCode;
            GenJnlLine."Journal Batch Name":=BatchCode;
            GenJnlLine.Validate("Document No.", Format(Rec."Entry No."));
            GenJnLLine.Validate("Posting Date", Rec."Act Date");
            GenJnlLine.Validate("Document Date", Rec."Act Date");
            GenJnlLine."Line No.":=LineNo;
            lrec_Currency.get(IMOSPayRevDetails."Currency code");
            if Rec."Payment Transaction Type" = 1 then begin
                GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::Vendor);
                GenJnlLine.Validate("Account No.", IMOSPayRevDetails."No.");
                GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                GenJnlLine.Validate("Bal. Account No.", IMOSPayRevDetails."COA No");
                GenJnlLine.Validate("Currency Code", IMOSPayRevDetails."Currency code");
                GenJnlLine.Validate(Amount, Round(IMOSPayRevDetails.Amount, 0.01, '='));
                GenJnlLine.Validate("Amount (LCY)", round(IMOSPayRevDetails."Amount LCY", 0.01, '='));
            end
            else if rec."Payment Transaction Type" = 2 then begin
                    GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::Customer);
                    GenJnlLine.Validate("Account No.", IMOSPayRevDetails."No.");
                    GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                    GenJnlLine.Validate("Bal. Account No.", IMOSPayRevDetails."COA No");
                    GenJnlLine.Validate("Currency Code", IMOSPayRevDetails."Currency code");
                    GenJnlLine.Validate(Amount, Round(-1 * IMOSPayRevDetails.Amount, 0.01, '='));
                    GenJnlLine.Validate("Amount (LCY)", round(-1 * IMOSPayRevDetails."Amount LCY", 0.01, '='));
                end
                else
                    Error('Invalid Payment Transaction Type');
            GenJnlLine."IMOS invoice":=true;
            GenJnlLine."IMOS Transaction No":=Rec."Payment Transaction No.";
            GenJnlLine.Validate("Shortcut Dimension 1 Code", vmt.SEGMENT);
            GenJnlLine.Validate("Shortcut Dimension 10 Code", IMOSPayRevDetails."Vessal Code");
            GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyMapping."PB Company Code");
            GenJnlLine.Validate("Shortcut Dimension 9 Code", IMOSPayRevDetails.Type);
            GenJnlLine.Validate("Shortcut Dimension 2 Code", TemplateCode);
            GenJnlLine.Description:=rec."External Reference Id";
            GenJnlLine."Invoice Link":='IMOS INV';
            GenJnlLine."External Document No.":=rec."Payment Transaction No.";
            GenJnlLine.Insert(true);
        //            GenJnlLine.Validate("Amount (LCY)", Round(GenJnlLine."Amount (LCY)", 0.01, '='));
        //          GenJnlLine.Modify();
        until IMOSPayRevDetails.Next() = 0;
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", TemplateCode);
        GenJnlLine.SetRange("Journal Batch Name", BatchCode);
        //GenJnlLine.SetRange("Document No.", DocumentNo);
        GenJnlLine.FindSet();
        JnlPostBatch.Run(GenJnlLine);
    end;
}
