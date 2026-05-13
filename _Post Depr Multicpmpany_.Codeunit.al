codeunit 50113 "Post Depr Multicpmpany"
{
    trigger OnRun()
    begin
        PostICGenLines();
    end;
    local procedure PostICGenLines()
    var
    begin
        DCL.Reset();
        DCL.SetRange("Company Code", CompanyName);
        DCL.SetRange("Depreciation Calculated", true);
        DCL.SetRange("Depreciation Posted", false);
        IF DCL.FindFirst()then begin
            FAJournalSetup.Reset();
            IF not FAJournalSetup.get(DCL.DeprBookCode, DCL."User ID")then FAJournalSetup.Get(dcl.DeprBookCode, '');
            FAJournalSetup.TestField("FA Jnl. Template Name");
            FAJournalSetup.TestField("FA Jnl. Batch Name");
            FAJournalSetup.TestField("Gen. Jnl. Template Name");
            FAJournalSetup.TestField("Gen. Jnl. Batch Name");
            GenJnlLn.Reset();
            GenJnlLn.SetRange("Journal Template Name", FAJournalSetup."Gen. Jnl. Template Name");
            GenJnlLn.SetRange("Journal Batch Name", FAJournalSetup."Gen. Jnl. Batch Name");
            If GenJnlLn.FindSet()then begin
                IF NOT Codeunit.Run(Codeunit::"Gen. Jnl.-Post Batch", GenJnlLn)then begin
                    Message('Not OK');
                end;
            end;
        end;
        ;
    end;
    var FAJournalSetup: Record "FA Journal Setup";
    FAJournalLine: Record "FA Journal Line";
    GenJnlLn: Record "Gen. Journal Line";
    DCL: Record "Depr. Calc. Log";
}
