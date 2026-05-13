page 50228 "DNV Committed Cost Details"
{
    Caption = 'DNV Committed Cost Details';
    PageType = List;
    SourceTable = "DNV Commited Cost Details";
    //Editable = false;
    ApplicationArea = All;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Account Code"; Rec."Account Code")
                {
                    ToolTip = 'Specifies the value of the Account Code field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Order Amount"; Rec."Order Amount")
                {
                    ToolTip = 'Specifies the value of the Order Amount field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Received Amount"; Rec."Received Amount")
                {
                    ToolTip = 'Specifies the value of the Received Amount field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Invoiced Amount"; Rec."Invoiced Amount")
                {
                    ToolTip = 'Specifies the value of the Invoiced Amount field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Accrual Amount"; Rec."Accrual Amount")
                {
                    ApplicationArea = all;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                    ApplicationArea = all;
                }
            }
        }
    }
}
