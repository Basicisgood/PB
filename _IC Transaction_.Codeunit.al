codeunit 50200 "IC Transaction"
{
    //OnCreateOutboxJnlTransactionOnBeforeOutboxJnlTransactionInsert
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ICInboxOutboxMgt, OnInsertOutboxJnlLineOnBeforeICOutboxJnlLineInsert, '', false, false)]
    local procedure ICInboxOutboxMgt_OnInsertICOutboxJnlLine(var ICOutboxJnlLine: Record "IC Outbox Jnl. Line"; TempGenJournalLine: Record "Gen. Journal Line" temporary)
    begin
        ICOutboxJnlLine."Bank Document No.":=TempGenJournalLine."Bank Document No.";
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ICInboxOutboxMgt, OnOutboxJnlLineToInboxOnBeforeICInboxJnlLineInsert, '', false, false)]
    local procedure ICInboxOutboxMgt_OnOutboxJnlLineToInboxOnBeforeICInboxJnlLineInsert(var ICInboxJnlLine: Record "IC Inbox Jnl. Line"; var ICOutboxJnlLine: Record "IC Outbox Jnl. Line")
    begin
        ICInboxJnlLine."Bank Document No.":=ICOutboxJnlLine."Bank Document No.";
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ICInboxOutboxMgt, OnBeforeInsertGenJnlLine, '', false, false)]
    local procedure ICInboxOutboxMgt_OnBeforeInsertGenJnlLine(var GenJnlLine: Record "Gen. Journal Line"; ICInboxJnlLine: Record "IC Inbox Jnl. Line")
    begin
        GenJnlLine."Bank Document No.":=ICInboxJnlLine."Bank Document No.";
    end;
}
