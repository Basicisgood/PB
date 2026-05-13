page 50255 "DBS Report Setup"
{
    ApplicationArea = All;
    Caption = 'DBS Report Setup';
    PageType = List;
    SourceTable = "DBS Report Setup";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Column Name"; Rec."Column Name")
                {
                    ToolTip = 'Specifies the value of the Column Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(FD1; Rec.FD1)
                {
                    ToolTip = 'Specifies the value of the FD1 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Account Group"; Rec."Account Group")
                {
                    ToolTip = 'Specifies the value of the Account Group field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
