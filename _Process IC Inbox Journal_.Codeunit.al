codeunit 50197 "Process IC Inbox Journal"
{
//     trigger OnRun()
//     begin
//         ICInbox.reset;
//         ICInbox.SetRange("Source Type", ICInbox."Source Type"::Journal);
//         ICInbox.SetRange("Line Action", ICInbox."Line Action"::Accept);
//     end;
//     var
//         ICInbox: Record "IC Inbox Transaction";
// 
// [EventSubscriber(ObjectType::Codeunit, 11, 'OnBeforeCheckDimensions', '', true, true)]
// local procedure OnBeforeCheckDimensions(var GenJnlLine: Record "Gen. Journal Line"; var CheckDone: Boolean)
// begin
//     IF GenJnlLine."IC Partner Transaction No." <> 0 then
//         CheckDone := true;
// end;
}
