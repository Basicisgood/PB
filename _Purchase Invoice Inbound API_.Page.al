page 50151 "Purchase Invoice Inbound API"
{
    //   ApplicationArea = All;
    Caption = 'Purchase Invoice Inbound API';
    PageType = API;
    SourceTable = "PB Purchase Invoice Inbound";
    // Editable = false;
    APIPublisher = 'PB';
    APIGroup = 'app1';
    APIVersion = 'v2.0', 'v1.0';
    ODataKeyFields = SystemId;
    EntityName = 'PurchaseInvoiceInbound';
    EntitySetName = 'PurchaseInvoiceInbound';
    DelayedInsert = true;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(id; rec.SystemId)
                {
                    ApplicationArea = All;
                }
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(BookingDate; Rec."Booking Date")
                {
                    ApplicationArea = All;
                }
                field(ApprovedAt; Rec."Approved At")
                {
                    ApplicationArea = All;
                }
                field(ApprovedBy; Rec."Approved By")
                {
                    ApplicationArea = All;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field(CurrencyExchangeRate; Rec."Currency Exchange Rate")
                {
                    ApplicationArea = All;
                }
                field(DiscountPer; Rec."Discount %")
                {
                    ApplicationArea = All;
                }
                field(InvoiceDate; Rec."Invoice Date")
                {
                    ApplicationArea = All;
                }
                field(MaturityDate; Rec."Maturity Date")
                {
                    ApplicationArea = All;
                }
                field(ShipManager; Rec."Ship Manager")
                {
                    ApplicationArea = All;
                }
                field(InvoiceStatus; Rec."Invoice-Status")
                {
                    ApplicationArea = ALl;
                }
                field(VendorNo; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
                field(OrderCode; Rec."Order Code")
                {
                    ApplicationArea = All;
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                    ApplicationArea = all;
                }
                field(errorDescription; Rec."Error Description")
                {
                    Caption = 'Error Description';
                    ApplicationArea = all;
                }
                field(cancelledByUser; Rec."Cancelled by User")
                {
                    Caption = 'Cancelled by User';
                    ApplicationArea = all;
                }
                field(cancelledDateTime; Rec."Cancelled Date time")
                {
                    Caption = 'Cancelled Date time';
                    ApplicationArea = all;
                }
            }
            part(purchaseInvoiceLineInb; "Purchase Invoice Line Inb API")
            {
                Caption = 'Purchase Invoice Lines';
                EntityName = 'purchaseInvoiceLineInb';
                EntitySetName = 'purchaseInvoiceLineInb';
                SubPageLink = "Header Id"=Field(SystemId);
            }
        }
    }
}
