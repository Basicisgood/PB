codeunit 50194 "AutoPost_ConcurJournal"
{
    trigger OnRun()
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        APISetup: Record "Concur API Setup";
    begin
        apiSetup.Get();
        apiSetup.TestField("Concur Template Name");
        apiSetup.TestField("Concur Batch Name");
        // Set filters for the General Journal batch and template you want to post
        GenJnlLine.SetRange("Journal Template Name", APISetup."Concur Accr. Template Name"); // Replace 'GENERAL' with your template name
        GenJnlLine.SetRange("Journal Batch Name", APISetup."Concur Batch Name"); // Replace 'DEFAULT' with your batch name
        if GenJnlLine.FindSet()then begin
            repeat // Check for required fields before posting
                GenJnlLine.TestField("Posting Date");
                GenJnlLine.TestField("Account No.");
                // begin
                // Post the journal line
                GenJnlPostLine.Run(GenJnlLine);
            until GenJnlLine.Next() = 0;
        end
        else
        begin
            Error('No lines found in the specified General Journal.');
        end;
    end;
}
