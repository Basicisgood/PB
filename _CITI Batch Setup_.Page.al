page 50212 "CITI Batch Setup"
{
    ApplicationArea = All;
    Caption = 'CITI Batch Setup';
    PageType = List;
    SourceTable = "HSBC Batch Setup";
    UsageCategory = Lists;
    SourceTableView = where("Bank Integration Type"=filter(Citi));

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Batch Type"; Rec."Batch Type")
                {
                    ToolTip = 'Specifies the value of the Batch Type field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Batch No."; Rec."Batch No.")
                {
                    ToolTip = 'Specifies the value of the Batch No. field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("No. of Records"; Rec."CITI No. of Records")
                {
                    ToolTip = 'Specifies the value of the No. of Records field.', Comment = '%';
                    ApplicationArea = all;
                    LookupPageId = "CITI Outbound Staging";
                }
                field(Processed; Rec.Processed)
                {
                    ToolTip = 'Specifies the value of the Processed field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Value Date"; Rec."Value Date")
                {
                    ToolTip = 'Specifies the value of the Value Date field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ToolTip = 'Specifies the value of the Country/Region Code field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Bank Integration Type"; Rec."Bank Integration Type")
                {
                    ToolTip = 'Specifies the value of the Bank Integration Type field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ToolTip = 'Specifies the value of the Bal. Account No. field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Bank Log Entry No."; Rec."Bank Log Entry No.")
                {
                    ToolTip = 'Specifies the value of the Bank Log Entry No. field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
