page 50258 "IMOS Payment Reversal Details"
{
    ApplicationArea = All;
    Caption = 'IMOS Payment Reversal Details';
    PageType = ListPart;
    SourceTable = "IMOS Pay Reversal Details";
    //UsageCategory = Lists;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

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
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("COA No"; Rec."COA No")
                {
                    ApplicationArea = all;
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Vessal Code"; Rec."Vessal Code")
                {
                    ToolTip = 'Specifies the value of the Vessal Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Currency code"; Rec."Currency code")
                {
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Amount LCY"; Rec."Amount LCY")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}
