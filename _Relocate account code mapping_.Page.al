page 50216 "Relocate account code mapping"
{
    ApplicationArea = All;
    Caption = 'Relocate account code mapping';
    PageType = List;
    SourceTable = "Relocate account code mapping";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("DNV Code"; Rec."DNV Code")
                {
                    ToolTip = 'Specifies the value of the DNV Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ToolTip = 'Specifies the value of the Account Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Balance Account No"; Rec."Balance Account No")
                {
                    ToolTip = 'Specifies the value of the Bal. account no field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
