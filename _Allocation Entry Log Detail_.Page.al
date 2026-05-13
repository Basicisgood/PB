page 50208 "Allocation Entry Log Detail"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Allocation Entry Log Detail";
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Rule No."; Rec."Rule No.")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ApplicationArea = All;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Run Date"; Rec."Run Date")
                {
                    ApplicationArea = All;
                }
                field("Data From Date"; Rec."Data From Date")
                {
                    ApplicationArea = All;
                }
                field("Data To Date"; Rec."Data To Date")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Sum Amount"; Rec."Sum Amount")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 9 Code"; Rec."Shortcut Dimension 9 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 10 Code"; Rec."Shortcut Dimension 10 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 11 Code"; Rec."Shortcut Dimension 11 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 12 Code"; Rec."Shortcut Dimension 12 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 13 Code"; Rec."Shortcut Dimension 13 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 14 Code"; Rec."Shortcut Dimension 14 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 15 Code"; Rec."Shortcut Dimension 15 Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                end;
            }
        }
    }
    var myInt: Integer;
}
