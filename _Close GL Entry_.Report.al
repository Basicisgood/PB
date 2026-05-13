report 50169 "Close GL Entry"
{
    ApplicationArea = All;
    Caption = 'Close GL Entry';
    UsageCategory = ReportsAndAnalysis;
    //  UseRequestPage = false;
    ProcessingOnly = true;
    Permissions = tabledata "G/L Entry"=rm;

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            RequestFilterFields = "Entry No.";
            DataItemTableView = sorting("Entry No.")where("Entry No."=filter(5872|5873|6842|6843|6867));
            MaxIteration = 5;

            trigger OnAfterGetRecord()
            begin
                Message('%1', "Entry No.");
                "G/L Entry"."Closed PB":=false;
                "G/L Entry".Modify();
            end;
            trigger OnPostDataItem()
            begin
                Message('Patch Done');
            end;
        }
    }
    var PDate: date;
    Cu17: Codeunit 17;
    GLE: Record "G/L Entry";
    DGLE: Record "Detailed G/L Entry PB";
    DGLE2: Record "Detailed G/L Entry PB";
    Win: Dialog;
}
