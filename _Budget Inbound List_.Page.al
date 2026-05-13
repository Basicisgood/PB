page 50133 "Budget Inbound List"
{
    ApplicationArea = All;
    Caption = 'Budget Inbound List';
    PageType = List;
    SourceTable = "PB Budget Inbound";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
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
