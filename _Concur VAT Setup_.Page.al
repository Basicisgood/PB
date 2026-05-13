page 50236 "Concur VAT Setup"
{
    ApplicationArea = All;
    Caption = 'Concur VAT Setup';
    PageType = List;
    SourceTable = "Concur VAT Setup";
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
                field("Ledger Account"; Rec."Ledger Account")
                {
                    ApplicationArea = All;
                }
                field("Tax Code"; Rec."Tax Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
