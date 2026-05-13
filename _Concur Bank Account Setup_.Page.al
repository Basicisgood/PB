page 50235 "Concur Bank Account Setup"
{
    ApplicationArea = All;
    Caption = 'Concur Bank Account Setup';
    PageType = List;
    SourceTable = "Concur Bank Acc Setup";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("BC Company"; Rec."BC Company")
                {
                    ApplicationArea = All;
                }
                field("Bank Account"; Rec."Bank Account")
                {
                    ApplicationArea = All;
                }
                field("Report Name"; Rec."Report Name")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Bank Account Name"; Rec."Bank Account Name")
                {
                    ApplicationArea = All;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = All;
                }
                field("Cash Advance Bank Account"; Rec."Cash Advance Bank Account")
                {
                    ApplicationArea = All;
                }
                field("Concur LCY Bank"; Rec."Concur LCY Bank")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
