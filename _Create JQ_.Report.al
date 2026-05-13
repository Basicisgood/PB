report 50112 "Create JQ"
{
    ApplicationArea = All;
    Caption = 'Create JQ';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Integer; Integer)
        {
            MaxIteration = 1;

            trigger OnAfterGetRecord()
            begin
                JQE.ChangeCompany('A');
                JQE.Init();
                JQE.ID:=CreateGuid();
                JQE."Object Type to Run":=JQE."Object Type to Run"::Codeunit;
                JQE.Validate("Object ID to Run", 50100);
                JQE."Recurring Job":=true;
                JQE.Status:=JQE.Status::Ready;
                JQE."No. of Minutes between Runs":=1;
                JQE.Validate("Run on Mondays", true);
                JQE.Validate("Run on fridays", true);
                JQE."Earliest Start Date/Time":=CurrentDateTime;
                JQE.insert;
            end;
        }
    }
    var JQE: Record "Job Queue Entry";
}
