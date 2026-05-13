page 50127 "Purchase Invoice Part"
{
    ApplicationArea = All;
    Caption = 'Purchase Invoice';
    PageType = ListPart;
    SourceTable = "Purchase Header";
    SourceTableView = sorting("No.", "Document Type");
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Invoices)
            {
                Caption = 'Invoices';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    var
                        PurchHdr: Record "Purchase Header";
                    begin
                        PurchHdr.SetRange("No.", Rec."No.");
                        Page.Run(Page::"Purchase Invoice", PurchHdr);
                    end;
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ToolTip = 'Specifies the name of the vendor who delivers the products.';
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the currency that is used on the entry.';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the sum of amounts on all the lines in the document. This will include invoice discounts.';
                    ApplicationArea = All;
                }
                field("DNV Staging Entry No."; Rec."DNV Staging Entry No.")
                {
                    ToolTip = 'Specifies the value of the DNV Staging Entry No. field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
