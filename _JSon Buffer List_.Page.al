page 50155 "JSon Buffer List"
{
    ApplicationArea = All;
    Caption = 'JSon Buffer List';
    PageType = List;
    SourceTable = "JSON Buffer";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field(Depth; Rec.Depth)
                {
                    ApplicationArea = All;
                }
                field("Token type"; Rec."Token type")
                {
                    ApplicationArea = All;
                }
                field("Value"; Rec."Value")
                {
                    ApplicationArea = All;
                }
                field("Value Type"; Rec."Value Type")
                {
                    ApplicationArea = All;
                }
                field(Path; Rec.Path)
                {
                    ApplicationArea = All;
                }
                field("Value BLOB"; Rec."Value BLOB")
                {
                    ApplicationArea = All;
                }
                field("Object Number"; Rec."Object Number")
                {
                    ApplicationArea = All;
                }
                field(Error; Rec.Error)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
