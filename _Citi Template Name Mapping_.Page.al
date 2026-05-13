page 50280 "Citi Template Name Mapping"
{
    ApplicationArea = All;
    Caption = 'Citi Template Name Mapping';
    PageType = List;
    SourceTable = "Citi Template Name Mapping";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("CAMT52 Template Name"; Rec."CAMT52 Template Name")
                {
                    ToolTip = 'Specifies the value of the CAMT52 Template Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("CAMT53 Template Name"; Rec."CAMT53 Template Name")
                {
                    ToolTip = 'Specifies the value of the CAMT53 Template Name field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
