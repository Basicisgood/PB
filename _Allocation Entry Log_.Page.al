page 50207 "Allocation Entry Log"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Allocation Entry Log";
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
                field("Posting Date"; Rec."Posting Date")
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
                field("Execute Run System Date"; Rec."Execute Run System Date")
                {
                    ApplicationArea = All;
                }
                field("Exeucted by"; Rec."Exeucted by")
                {
                    ApplicationArea = All;
                }
            }
            part("Allocation Entry Log Detail"; "Allocation Entry Log Detail")
            {
                Caption = 'Log Detail';
                SubPageLink = "Rule No."=field("Rule No."), "Line No."=Field("Line No.");
                ApplicationArea = All;
            }
        }
    }
    var myInt: Integer;
}
