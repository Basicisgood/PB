page 50165 "Crew Payroll Dim Inb List"
{
    //ApplicationArea = All;
    Caption = 'Crew Payroll Dimension Inbound List';
    PageType = ListPart;
    SourceTable = "PB Crew Payroll Dim Inb";
    //UsageCategory = Lists;
    Editable = false;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("IC Code"; Rec."IC Code")
                {
                    ApplicationArea = All;
                }
                field("GL Code"; Rec."GL Code")
                {
                    ApplicationArea = All;
                }
                field("Wage Dimension Code"; Rec."Wage Dimension Code")
                {
                    ApplicationArea = All;
                }
                field("Wage Dimension Value"; Rec."Wage Dimension Value")
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
