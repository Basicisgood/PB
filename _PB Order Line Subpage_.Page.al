page 50205 "PB Order Line Subpage"
{
    ApplicationArea = All;
    Caption = 'PB Order Line Subpage';
    PageType = ListPart;
    SourceTable = "PB DNV Committed Cost Line";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Account code"; Rec."Account code")
                {
                    ToolTip = 'Specifies the value of the Account code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Is Critical"; Rec."Is Critical")
                {
                    ToolTip = 'Specifies the value of the Is Critical field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Item Drawing Number"; Rec."Item Drawing Number")
                {
                    ToolTip = 'Specifies the value of the Item Drawing Number field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Item Name"; Rec."Item Name")
                {
                    ToolTip = 'Specifies the value of the Item Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Item Number"; Rec."Item Number")
                {
                    ToolTip = 'Specifies the value of the Item Number field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Item Part Number"; Rec."Item Part Number")
                {
                    ToolTip = 'Specifies the value of the Item Part Number field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Line Discount Pct"; Rec."Line Discount Pct")
                {
                    ToolTip = 'Specifies the value of the Line Discount Pct field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ToolTip = 'Specifies the value of the Order Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Order Head Discount"; Rec."Order Head Discount")
                {
                    ToolTip = 'Specifies the value of the Order Head Discount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Order Item Number"; Rec."Order Item Number")
                {
                    ToolTip = 'Specifies the value of the Order Item Number field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Unit Of Measure code"; Rec."Unit Of Measure code")
                {
                    ToolTip = 'Specifies the value of the Unit Of Measure code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Quantity Ordered"; Rec."Quantity Ordered")
                {
                    ToolTip = 'Specifies the value of the Quantity Ordered field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Quantity Received Warehouse"; Rec."Quantity Received Warehouse")
                {
                    ToolTip = 'Specifies the value of the Quantity Received Warehouse field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Quantiy Received Shipped"; Rec."Quantity Received Shipped")
                {
                    ToolTip = 'Specifies the value of the Quantiy Received Shipped field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(ShipID; Rec.ShipID)
                {
                    ToolTip = 'Specifies the value of the ShipID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Single Price"; Rec."Single Price")
                {
                    ToolTip = 'Specifies the value of the Single Price field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Total Line Amount"; Rec."Total Line Amount")
                {
                    ToolTip = 'Specifies the value of the Total Line Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Total Line Net Amount"; Rec."Total Line Net Amount")
                {
                    ToolTip = 'Specifies the value of the Total Line Net Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
