page 50116 "Banking Trans. Code Mapping"
{
    ApplicationArea = All;
    Caption = 'Banking Transaction Code Mapping';
    PageType = List;
    SourceTable = "Inbound Transfer Mapping";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ToolTip = 'Specifies the value of the Account Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("DBIT / CRDT"; Rec."DBIT / CRDT")
                {
                    ToolTip = 'Specifies the value of the DBIT / CRDT field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Check Duplicate Include Currency"; Rec."Check Duplicate Include Currency")
                {
                    ApplicationArea = all;
                }
                field(PBFundTransfer; Rec.PBFundTransfer)
                {
                    ToolTip = 'Specifies the value of the PBFundTransfer field.', Comment = '%'; //#354
                }
                field("Mark as Cancel"; Rec."Mark as Cancel")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}
