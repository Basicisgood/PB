page 50104 "PB Invoice By Cost Center API"
{
    APIGroup = 'app1';
    APIPublisher = 'PB';
    APIVersion = 'v2.0', 'v1.0';
    ApplicationArea = All;
    Caption = 'PB Invoice By Cost Center API';
    EntityName = 'pBInvoiceByCostCenter';
    EntitySetName = 'pBInvoiceByCostCenter';
    PageType = API;
    SourceTable = "PB Committed Cost Invoice";
    DelayedInsert = true;
    ODataKeyFields = SystemId;

    //ODataKeyFields = ShipID, "Line No";
    //UsageCategory = Lists;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                //     field(shipID; Rec.ShipID)
                //   {
                //     Caption = 'ShipID';
                // }
                field(invoicedAccountCode; Rec."Invoiced Account code")
                {
                    Caption = 'Invoiced Account code';
                }
                field(SystemId; Rec.SystemId)
                {
                    Visible = false;
                }
                field(invoicedAmount; Rec."Invoiced Amount")
                {
                    Caption = 'Invoiced Amount';
                }
                field(lineNo; Rec."Line No")
                {
                    Caption = 'Line No';
                    Visible = false;
                }
            }
        }
    }
    var IsDeepInsert: Boolean;
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean var
        PBIBCC: Record "PB Committed Cost Invoice";
    begin
        // PurchInvHdrInbound.GetBySystemId(Rec."Account code");
        //  Rec."Purch Inv Entry No." := PurchInvHdrInbound."Entry No.";
        PBIBCC.SetRange("Entry No", Rec."Entry No");
        if PBIBCC.FindLast()then Rec."Line No":=PBIBCC."Line No" + 10000
        else
            Rec."Line No":=10000;
    end;
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        PBIBCC: Record "PB Committed Cost Inbound";
    begin
        IsDeepInsert:=IsNullGuid(Rec.pBInvoiceByCostCenterID);
        PBIBCC.GetBySystemId(Rec.pBInvoiceByCostCenterID);
        Rec."Entry No":=PBIBCC."Entry No.";
    end;
}
