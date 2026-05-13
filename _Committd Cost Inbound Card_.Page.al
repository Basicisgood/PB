page 50204 "Committd Cost Inbound Card"
{
    ApplicationArea = All;
    Caption = 'Committd Cost Inbound Card';
    PageType = Card;
    SourceTable = "PB Committed Cost Inbound";
    Editable = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Account Code"; Rec."Account Code")
                {
                    ToolTip = 'Specifies the value of the Account Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Asset ID"; Rec."Asset ID")
                {
                    ToolTip = 'Specifies the value of the Asset ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Cancelled Date time"; Rec."Cancelled Date time")
                {
                    ToolTip = 'Specifies the value of the Cancelled Date time field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Cancelled by User"; Rec."Cancelled by User")
                {
                    ToolTip = 'Specifies the value of the Cancelled by User field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Error Description"; Rec."Error Description")
                {
                    ToolTip = 'Specifies the value of the Error Description field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Order Amount"; Rec."Order Amount")
                {
                    ToolTip = 'Specifies the value of the Order Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Order Code"; Rec."Order Code")
                {
                    ToolTip = 'Specifies the value of the Order Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Order Name"; Rec."Order Name")
                {
                    ToolTip = 'Specifies the value of the Order Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Order Net Amount"; Rec."Order Net Amount")
                {
                    ToolTip = 'Specifies the value of the Order Net Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
            part(PBInvoiceByCostCenter; "DNV Committed Cost by Invoice")
            {
                SubPageLink = "Entry No"=field("Entry No.");
                UpdatePropagation = Both;
                ApplicationArea = All;
            }
            part(PBOrderLines; "PB Order Line Subpage")
            {
                SubPageLink = "Entry No"=field("Entry No.");
                UpdatePropagation = Both;
                ApplicationArea = All;
            }
        }
    }
}
