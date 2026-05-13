page 50242 "Invoice Reversal API"
{
    APIGroup = 'InvoiceReversal';
    APIPublisher = 'InvoiceReversal';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'InvoiceReversalAPI';
    DelayedInsert = true;
    EntityName = 'InvoiceReversal';
    EntitySetName = 'InvoiceReversal';
    PageType = API;
    SourceTable = "Invoice Reversal API Inbound";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(entryNo; Rec."Entry No.")
                {
                    Caption = 'Entry No.';
                }
                field("datetime"; Rec."Datetime ")
                {
                    Caption = 'Datetime';
                }
                field(data; Rec.Data)
                {
                    Caption = 'Data';
                }
                field(Filename; Rec.Filename)
                {
                }
            }
        }
    }
}
