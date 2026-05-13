page 50286 "HSBC API Inbound Error"
{
    ApplicationArea = All;
    Caption = 'HSBC API Inbound Error';
    PageType = List;
    SourceTable = "HSBC API Inbound Error Log";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ToolTip = 'Specifies the value of the Bank Account No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Statement Date"; Rec."Statement Date")
                {
                    ToolTip = 'Specifies the value of the Statement Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Error Msg"; Rec."Error Msg")
                {
                    ToolTip = 'Specifies the value of the Error Msg field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
