codeunit 50208 "Concur Auto Post GJ"
{
    trigger OnRun()
    var
        GenJnlLine: Record "Gen. Journal Line";
        ConcurAPISetup: Record "Concur API Setup";
        CurrentJnlBatchName: Text;
    begin
        if ConcurAPISetup.get()then begin
            GenJnlLine.Reset();
            GenJnlLine.SetRange("Journal Template Name", ConcurAPISetup."Concur Template Name");
            GenJnlLine.SetRange("Journal Batch Name", ConcurAPISetup."Concur Batch Name");
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
