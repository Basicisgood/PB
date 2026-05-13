page 50163 "Purchase Inv Line Dim Inb List"
{
    ApplicationArea = All;
    Caption = 'Purchase Invoice Line Dimension Inbound Subpage';
    PageType = ListPart;
    SourceTable = "PB Purchase Inv. Line Dim Inb";
    UsageCategory = Lists;

    //Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Purch Inv Entry No."; Rec."Purch Inv Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Purch Inv Line Entry No."; Rec."Purch Inv Line LineNo.")
                {
                    ApplicationArea = All;
                }
                field("Entry No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Code 2"; Rec."Code 2")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Dimension Code"; Rec."Dimension Code")
                {
                    ApplicationArea = All;
                }
                field("Ship Manager Id"; Rec."Ship Manager Id")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
