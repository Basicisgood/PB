codeunit 50102 "Auto Post IC Gen Jnl"
{
    trigger OnRun()
    begin
        PostICGenLines();
    end;
    local procedure PostICGenLines()
    var
    begin
        ICSetup.Get();
        ICSetup.TestField("Default IC Gen. Jnl. Template");
        ICSetup.TestField("Default IC Gen. Jnl. Batch");
        ICGenJnl.Reset();
        ICGenJnl.SetRange("Journal Template Name", ICSetup."Default IC Gen. Jnl. Template");
        ICGenJnl.SetRange("Journal Batch Name", ICSetup."Default IC Gen. Jnl. Batch");
        If ICGenJnl.FindSet()then begin
            IF NOT Codeunit.Run(Codeunit::"Gen. Jnl.-Post Batch", ICGenJnl)then begin
                Message('Not OK');
            end;
        end;
    end;
    var ICSetup: Record "IC Setup";
    ICGenJnl: Record "Gen. Journal Line";
}
