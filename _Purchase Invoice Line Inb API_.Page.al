page 50160 "Purchase Invoice Line Inb API"
{
    //ApplicationArea = All;
    Caption = 'Purchase Invoice Line Inbound API';
    PageType = API;
    SourceTable = "PB Purchase Invoice Line Inb";
    UsageCategory = Lists;
    // Editable = false;
    APIPublisher = 'PB';
    APIGroup = 'app1';
    APIVersion = 'v2.0', 'v1.0';
    EntityName = 'purchaseInvoiceLineInb';
    EntitySetName = 'purchaseInvoiceLineInb';
    ODataKeyFields = SystemId;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(id; Rec.SystemId)
                {
                    ApplicationArea = All;
                }
                field(PurchInvEntryNo; Rec."Purch Inv Entry No.")
                {
                    ApplicationArea = All;
                }
                field(HeaderId; Rec."Header Id")
                {
                    ApplicationArea = All;
                }
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field(Discount; Rec.Discount)
                {
                    ApplicationArea = All;
                }
                field(AccountCode; Rec."Account Code")
                {
                    ApplicationArea = All;
                }
                field(ShipCode; Rec."Ship Code")
                {
                    ApplicationArea = All;
                }
                field(InvoicedQuantity; Rec."Invoiced Quantity")
                {
                    ApplicationArea = All;
                }
                field(OrderItemNumber; Rec."Order Item Number")
                {
                    ApplicationArea = All;
                }
                field(SinglePrice; Rec."Single Price")
                {
                    ApplicationArea = All;
                }
                field(TotalAmount; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
                field("TotalPrice"; Rec."Total Price")
                {
                    ApplicationArea = All;
                }
                field(TaxAmount; Rec."Tax Amount")
                {
                    ApplicationArea = All;
                }
                field(TaxRate; Rec."Tax Rate")
                {
                    ApplicationArea = All;
                }
            }
        //part(purchaseInvoiceLineDimInb; "Purchase Inv Line Dim Inb API")
        // {
        //   Caption = 'Purchase Invoice Lines';
        // EntityName = 'purchaseInvoiceLineDimInb';
        //EntitySetName = 'purchaseInvoiceLineDimInb';
        //SubPageLink = LineId = Field(SystemId);
        //}
        }
    }
    var IsDeepInsert: Boolean;
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean var
        PurchInvHdrInbound: Record "PB Purchase Invoice Inbound";
        PurchInvLineInbound: Record "PB Purchase Invoice Line Inb";
    begin
        PurchInvHdrInbound.GetBySystemId(Rec."Header Id");
        Rec."Purch Inv Entry No.":=PurchInvHdrInbound."Entry No.";
        PurchInvLineInbound.SetRange("Purch Inv Entry No.", Rec."Purch Inv Entry No.");
        if PurchInvLineInbound.FindLast()then Rec."Line No.":=PurchInvLineInbound."Line No." + 10000
        else
            Rec."Line No.":=10000;
    end;
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        PurchaseInvoiceInbound: Record "PB Purchase Invoice Inbound";
    begin
        IsDeepInsert:=IsNullGuid(Rec."Header Id");
        PurchaseInvoiceInbound.GetBySystemId(Rec."Header Id");
        Rec."Purch Inv Entry No.":=PurchaseInvoiceInbound."Entry No.";
    end;
}
