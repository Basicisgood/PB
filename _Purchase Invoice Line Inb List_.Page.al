page 50162 "Purchase Invoice Line Inb List"
{
    ApplicationArea = All;
    Caption = 'Invoice Lines';
    PageType = ListPart;
    SourceTable = "PB Purchase Invoice Line Inb";
    UsageCategory = Lists;
    Editable = false;

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
                field("Entry No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field(Discount; Rec.Discount)
                {
                    ApplicationArea = All;
                }
                field("Account Code"; Rec."Account Code")
                {
                    ApplicationArea = All;
                }
                field("Ship Code"; Rec."Ship Code")
                {
                    ApplicationArea = All;
                }
                field("Invoiced Quantity"; Rec."Invoiced Quantity")
                {
                    ApplicationArea = All;
                }
                field("Order Item Number"; Rec."Order Item Number")
                {
                    ApplicationArea = All;
                }
                field("Single Price"; Rec."Single Price")
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
                field("Tax Amount"; Rec."Tax Amount")
                {
                    ApplicationArea = All;
                }
                field("Tax Rate"; Rec."Tax Rate")
                {
                    ApplicationArea = All;
                }
            }
        // part(purchaseInvLineDim; "Purchase Inv Line Dim Inb List")
        // {
        //     Caption = 'Commitedcost Inbound Dimension';
        //     // EntityName = 'CommittedCostInbdim';
        //     // EntitySetName = 'CommittedCostInbdim';
        //     SubPageLink = "Purch Inv Line LineNo." = Field("Line No."), "Purch Inv Entry No." = field("Purch Inv Entry No.");
        // }
        }
    }
    actions
    {
        area(Processing)
        {
            action(PurchInvDim)
            {
                Caption = 'PurchInvLineDim';
                RunObject = page "Purchase Inv Line Dim Inb List";
                RunPageLink = LineId=field(SystemId);
                ApplicationArea = All;

                trigger OnAction()
                begin
                end;
            }
        }
    }
}
