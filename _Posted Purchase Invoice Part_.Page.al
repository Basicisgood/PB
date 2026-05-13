page 50128 "Posted Purchase Invoice Part"
{
    ApplicationArea = All;
    Caption = 'Posted Purchase Invoice';
    PageType = ListPart;
    SourceTable = "Purch. Inv. Header";
    SourceTableView = sorting("Order No.")where("Order No."=filter(<>''));
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater("Posted Invoices")
            {
                Caption = 'Posted Invoices';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    var
                        PostedPurchHdr: Record "Purch. Inv. Header";
                    begin
                        PostedPurchHdr.SetRange("Order No.", Rec."No.");
                        Page.Run(Page::"Posted Purchase Invoice", PostedPurchHdr);
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
