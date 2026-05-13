page 50153 "Budget Inbound API"
{
    ApplicationArea = All;
    Caption = 'Budget Inbound API';
    PageType = API;
    SourceTable = "PB Budget Inbound";
    UsageCategory = Lists;
    //Editable = false;
    APIPublisher = 'PB';
    APIGroup = 'app1';
    APIVersion = 'v2.0', 'v1.0';
    EntityName = 'BudgetInbound';
    EntitySetName = 'BudgetInbound';
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field(Dimension; Rec.Dimension)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
