codeunit 50115 "Split Purch. Invoice GL Entry"
{
    local procedure RunGenJnlPostLine(var GenJnlLine: Record "Gen. Journal Line"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"): Integer begin
        exit(GenJnlPostLine.RunWithCheck(GenJnlLine));
    end;
    var //GLMappingPosting: Record "GL Mapping Posting";
    GLSetup: Record "General Ledger Setup";
}
