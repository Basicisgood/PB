page 50202 "PB Order Line API"
{
    APIGroup = 'app1';
    APIPublisher = 'PB';
    ApplicationArea = All;
    Caption = 'PB Order Line API';
    DelayedInsert = true;
    //    EntityName = 'pBOrderLine';
    //  EntitySetName = 'pBOrderLine';
    EntityName = 'pBOrderLine';
    EntitySetName = 'pBOrderLine';
    APIVersion = 'v2.0', 'v1.0';
    PageType = API;
    ODataKeyFields = SystemId;
    SourceTable = "PB DNV Committed Cost Line";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(ShipID; Rec.ShipID)
                {
                    Visible = false;
                }
                field(PBOrderLineid; Rec.PBOrderLineid)
                {
                }
                field(accountCode; Rec."Account code")
                {
                    Caption = 'Account code';
                }
                field(currencyCode; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                }
                field("SinglePrice"; Rec."Single Price")
                {
                    Caption = 'Direct Unit Cost';
                }
                field("IsCritical"; Rec."Is Critical")
                {
                    Caption = 'IsCritical';
                }
                field(itemDrawingNumber; Rec."Item Drawing Number")
                {
                    Caption = 'Item Drawing Number';
                }
                field(itemNumber; Rec."Item Number")
                {
                    Caption = 'Item Number';
                }
                field(itemPartNumber; Rec."Item Part Number")
                {
                    Caption = 'Item Part Number';
                }
                field(lineDiscountPct; Rec."Line Discount Pct")
                {
                    Caption = 'Line Discount Pct';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No';
                }
                field("ItemName"; Rec."Item Name")
                {
                    Caption = 'Name';
                }
                field(orderDate; Rec."Order Date")
                {
                    Caption = 'Order Date';
                }
                field(orderHeadDiscount; Rec."Order Head Discount")
                {
                    Caption = 'Order Head Discount';
                }
                field(orderItemNumber; Rec."Order Item Number")
                {
                    Caption = 'Order Item Number';
                }
                field("QuantityOrdered"; Rec."Quantity Ordered")
                {
                    Caption = 'QuantityOrdered';
                }
                field(quantityReceivedWarehouse; Rec."Quantity Received Warehouse")
                {
                    Caption = 'Quantity Received Warehouse';
                }
                field(quantityReceivedShipped; Rec."Quantity Received Shipped")
                {
                    Caption = 'Quantity Received Shipped';
                }
                field(shipCode; Rec.ShipID)
                {
                    Caption = 'ShipCode';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(totalLineAmount; Rec."Total Line Amount")
                {
                    Caption = 'Total Line Amount';
                }
                field(totalLineNetAmount; Rec."Total Line Net Amount")
                {
                    Caption = 'Total Line Net Amount';
                }
                field(unitOfMEasureCode; Rec."Unit Of MEasure code")
                {
                    Caption = 'Unit Of MEasure code';
                }
            }
        }
    }
    var IsDeepInsert: Boolean;
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean var
        PBOrderLine: Record "PB DNV Committed Cost Line";
    begin
        // PurchInvHdrInbound.GetBySystemId(Rec."Account code");
        //  Rec."Purch Inv Entry No." := PurchInvHdrInbound."Entry No.";
        PBOrderLine.SetRange("Entry No", Rec."Entry No");
        if PBOrderLine.FindLast()then Rec."Line No.":=PBOrderLine."Line No." + 10000
        else
            Rec."Line No.":=10000;
    // Rec."Account code" := 
    end;
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        PurchaseInvoiceInbound: Record "PB Purchase Invoice Inbound";
        PBcommitedcostinbound: Record "PB Committed Cost Inbound";
    begin
        IsDeepInsert:=IsNullGuid(Rec.PBOrderLineid);
        PBcommitedcostinbound.GetBySystemId(Rec.PBOrderLineid);
        Rec."Entry No":=PBcommitedcostinbound."Entry No.";
    end;
}
