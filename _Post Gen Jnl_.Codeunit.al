codeunit 50190 "Post Gen Jnl"
{
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    begin
        GenJnlPostBatch.RUN(rec);
    end;
    var GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
}
