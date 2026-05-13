codeunit 50225 "Concur Advance Auto Post"
{
    trigger OnRun()
    var
        GenJnlLine: Record "Gen. Journal Line";
        ConcurAPISetup: Record "Concur API Setup";
        CurrentJnlBatchName: Text;
    begin
        if ConcurAPISetup.get()then begin
            GenJnlLine.Reset();
            GenJnlLine.SetRange("Journal Template Name", ConcurAPISetup."Cash Advance Template Name");
            GenJnlLine.SetRange("Journal Batch Name", ConcurAPISetup."Cash Advance Batch Name");
            if GenJnlLine.FindSet()then begin
                GenJnlLine.SendToPosting(Codeunit::"Gen. Jnl.-Post");
            // CurrentJnlBatchName := GenJnlLine.GetRangeMax("Journal Batch Name");
            /*  if IsSimplePage then
                     if GeneralLedgerSetup."Post with Job Queue" then
                         NewDocumentNo()
                     else
                         SetDataForSimpleModeOnPost();
                 SetJobQueueVisibility(); */
            end;
        end;
    end;
}
