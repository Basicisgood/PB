page 50203 "Committed Cost Inbounds"
{
    ApplicationArea = All;
    Caption = 'Committed Cost Inbound List';
    PageType = List;
    SourceTable = "PB Committed Cost Inbound";
    UsageCategory = Lists;
    CardPageId = 50204;

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
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Company Name field.';
                }
                field("Posted Document No"; Rec."Posted Document No")
                {
                    ToolTip = 'Specifies the value of the Account Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Asset ID"; Rec."Asset ID")
                {
                    ToolTip = 'Specifies the value of the Asset ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Order Name"; Rec."Order Name")
                {
                    ToolTip = 'Specifies the value of the Order Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Order Code"; Rec."Order Code")
                {
                    ToolTip = 'Specifies the value of the Order Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Order Amount"; Rec."Order Amount")
                {
                    ToolTip = 'Specifies the value of the Order Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Order Net Amount"; Rec."Order Net Amount")
                {
                    ToolTip = 'Specifies the value of the Order Net Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Line Amount Total"; Rec."Line Amount Total")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Line Amount Total field.';
                }
                field("Net Line Amount Total"; Rec."Net Line Amount Total")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Net Line Amount Total field.';
                }
                field("Invoiced Amount"; Rec."Invoiced Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Invoiced Amount field.';
                }
                field("Received Amount"; Rec."Received Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Received Amount field.';
                }
                field("Accrual Amount"; Rec."Accrual Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Accrual Amount field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Error Description"; Rec."Error Description")
                {
                    ToolTip = 'Specifies the value of the Error Description field.', Comment = '%';
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
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Dont Recalculate"; Rec."Dont Recalculate")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Delete All Records")
            {
                ApplicationArea = all;
                Image = Create;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Delete All Records action.';

                trigger OnAction()
                var
                    PBCommitedCost: record 50130;
                    PBCommittedCostInvoice: Record "PB Committed Cost Invoice";
                    PbCommitedCostLine: record "PB DNV Committed Cost Line";
                begin
                    PBCommitedCost.Reset();
                    if PBCommitedCost.FindSet()then PBCommitedCost.DeleteAll();
                    PBCommittedCostInvoice.Reset();
                    if PBCommittedCostInvoice.FindSet()then PBCommittedCostInvoice.DeleteAll();
                    PbCommitedCostLine.Reset();
                    if PbCommitedCostLine.FindSet()then PbCommitedCostLine.DeleteAll();
                    Message('Deleted');
                end;
            }
            action("Reset All records")
            {
                ApplicationArea = all;
                Image = UndoFluent;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Reset All records action.';

                trigger OnAction()
                var
                    PBCommitedCost: record 50130;
                begin
                    PBCommitedCost.Reset();
                    if PBCommitedCost.FindSet()then repeat PBCommitedCost.Status:=PBCommitedCost.Status::Pending;
                            PBCommitedCost."Posted Document No":='';
                            PBCommitedCost."Error Description":='';
                            PBCommitedCost.Modify();
                        until PBCommitedCost.Next() = 0;
                end;
            }
            action("Details")
            {
                ApplicationArea = all;
                Image = ViewDetails;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = page "DNV Committed Cost Details";
                RunPageLink = "Entry No."=field("Entry No.");
                ToolTip = 'Executes the Details action.';

                trigger OnAction()
                var
                begin
                end;
            }
            action("Process")
            {
                ApplicationArea = all;
                Image = ViewDetails;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = codeunit 50169;
                ToolTip = 'Executes the Process action.';

                trigger OnAction()
                var
                begin
                end;
            }
        }
    }
}
