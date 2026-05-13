pageextension 50121 "Sales & Receivable Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Allow Multiple Posting Groups")
        {
            field("HSBC Connect CustomerID"; Rec."HSBC Connect CustomerID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the HSBC Connect CustomerID field.', Comment = '%';
            }
            field("Citi Connect CustomerID"; Rec."Citi Connect CustomerID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Citi Connect CustomerID field.', Comment = '%';
            }
            field("Word Link"; Rec."Word Link")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Word Link field.', Comment = '%';
            }
        }
    }
}
