page 50150 "Committed Cost Inbound API"
{
    //    ApplicationArea = All;
    Caption = 'Committed Cost Inbound API';
    SourceTable = "PB Committed Cost Inbound";
    UsageCategory = Lists;
    PageType = API;
    APIPublisher = 'PB';
    APIGroup = 'app1';
    APIVersion = 'v2.0', 'v1.0';
    EntityCaption = 'committedCostInbound';
    EntitySetCaption = 'committedCostInbound';
    EntityName = 'committedCostInbound';
    EntitySetName = 'committedCostInbound';
    ODataKeyFields = SystemId;
    Extensible = false;
    DelayedInsert = true;
    ModifyAllowed = false;
    DeleteAllowed = false;

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
                field(AssetID; Rec."Asset ID")
                {
                    ApplicationArea = All;
                }
                field(OrderCode; Rec."Order Code")
                {
                    ApplicationArea = All;
                }
                field(OrderName; Rec."Order Name")
                {
                    ApplicationArea = All;
                }
                field("OrderAmount"; Rec."Order Amount")
                {
                    ApplicationArea = All;
                }
                field("OrderNetAmount"; Rec."Order Net Amount")
                {
                    ApplicationArea = All;
                }
            }
            part(pBInvoiceByCostCenter; "PB Invoice By Cost Center API")
            {
                //Multiplicity = ZeroOrOne;
                Caption = 'PB Invoice By Cost Center';
                EntityName = 'pBInvoiceByCostCenter';
                EntitySetName = 'pBInvoiceByCostCenter';
                SubPageLink = pBInvoiceByCostCenterID=Field(SystemId);
            //SubPageLink = ShipID = Field("Asset ID");
            // SubPageLink = "Line No" = Field("Entry No.");
            //SubPageLink = "Entry No" = field("Entry No.");
            }
            part(pBOrderLine; "PB Order Line API")
            {
                // Multiplicity = ZeroOrOne;
                Caption = 'Commitedcost Inbound Dimension';
                EntityName = 'pBOrderLine';
                EntitySetName = 'pBOrderLine';
                // SubPageLink = ShipID = Field("Asset ID");
                SubPageLink = PBOrderLineid=field(SystemId);
            // SubPageLink = "Line No" = Field("Entry No.");
            //SubPageLink = "Entry No" = field("Entry No.");
            }
        }
    }
}
