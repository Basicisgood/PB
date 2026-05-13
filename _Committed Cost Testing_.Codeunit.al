codeunit 59000 "Committed Cost Testing"
{
    trigger OnRun()
    var
        CommittedCostInbound: Record "PB Committed Cost Inbound";
        CommittedCostInbound2: Record "PB Committed Cost Inbound";
    begin
        CommittedCostInbound.Reset();
        CommittedCostInbound.SetRange("Entry No.", 1, 20);
        CommittedCostInbound.FindSet();
        repeat CommittedCostInbound2.Reset();
            CommittedCostInbound2.Init();
            CommittedCostInbound2.TransferFields(CommittedCostInbound);
            CommittedCostInbound2."Entry No.":=0; // Reset Entry No. to allow insert
            CommittedCostInbound2.Insert(true);
        until CommittedCostInbound.Next() = 0;
    end;
}
