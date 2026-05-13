report 50119 "AutoPost ICAction PB"
{
    ApplicationArea = All;
    Caption = 'AutoPost ICAction PB';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem(HandledIC; "Handled IC Inbox Trans.")
        {
            DataItemTableView = sorting("Transaction No.", "IC Partner Code", "Transaction Source", "Document Type")where("IC Source Type"=filter("Journal"), Status=filter("Accepted"));

            trigger OnPreDataItem()
            begin
            // Error('%1', HandledIC.Count);
            end;
            trigger OnAfterGetRecord()
            var
                GJL: Record "Gen. Journal Line";
                ICsetup: Record "IC Setup";
                CU50190: Codeunit 50190;
                HandledIC2: Record "Handled IC Inbox Trans.";
                HandledICLine: Record "Handled IC Inbox Jnl. Line";
            begin
                if ICsetup.Get()then;
                HandledICLine.reset;
                HandledICLine.SetRange("Transaction No.", HandledIC."Transaction No.");
                HandledICLine.SetRange("IC Partner Code", HandledIC."IC Partner Code");
                HandledICLine.SetRange("Transaction Source", HandledIC."Transaction Source");
                HandledICLine.FindFirst();
                GJL.reset;
                //GJL.SetRange("Journal Template Name", ICsetup."Default IC Gen. Jnl. Template");
                //GJL.SetRange("Journal Batch Name", ICsetup."Default IC Gen. Jnl. Batch");
                GJL.SetRange("Journal Template Name", HandledICLine."PB IC Journal Template Name");
                GJL.SetRange("Journal Batch Name", HandledICLine."PB IC Journal Batch Name");
                GJL.SetRange("IC Partner Transaction No.", HandledIC."Transaction No.");
                IF GJL.FindSet()then begin
                    ClearLastError();
                    clear(CU50190);
                    IF NOT CU50190.Run(GJL)then begin
                        HandledIC2.GET(HandledIC."Transaction No.", HandledIC."IC Partner Code", HandledIC."Transaction Source", HandledIC."Document Type");
                        HandledIC2."Error Msg":=GetLastErrorText();
                        HandledIC2.Modify();
                    end;
                end;
            end;
        }
    }
}
