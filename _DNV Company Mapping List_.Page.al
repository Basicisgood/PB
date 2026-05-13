page 50119 "DNV Company Mapping List"
{
    ApplicationArea = All;
    Caption = 'DNV Mapping List';
    PageType = List;
    SourceTable = "DNV Mapping";
    UsageCategory = Lists;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Company; Rec.Company)
                {
                    ToolTip = 'Specifies the value of the Company field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Dimension code"; Rec."Dimension code")
                {
                    ToolTip = 'Specifies the value of the Dimension code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Dimension name"; Rec."Dimension name")
                {
                    ToolTip = 'Specifies the value of the Dimension name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Is Cadet"; Rec."Is Cadet")
                {
                    ToolTip = 'Specifies the value of the Is Cadet field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Main account"; Rec."Main account")
                {
                    ToolTip = 'Specifies the value of the Main account field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Main account Name"; Rec."Main account Name")
                {
                    ToolTip = 'Specifies the value of the Main account Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Wage Accounting Area Code"; Rec."Wage Accounting Area Code")
                {
                    ToolTip = 'Specifies the value of the Wage Accounting Area Code field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
