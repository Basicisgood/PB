page 50161 "Purchase Inv Line Dim Inb API"
{
    //   ApplicationArea = All;
    Caption = 'Purchase Invoice Line Dimension Inbound API';
    PageType = API;
    SourceTable = "PB Purchase Inv. Line Dim Inb";
    UsageCategory = Lists;
    // Editable = false;
    APIPublisher = 'PB';
    APIGroup = 'app1';
    APIVersion = 'v2.0', 'v1.0';
    EntityName = 'purchaseInvoiceLineDimInb';
    EntitySetName = 'purchaseInvoiceLineDimInb';
    ODataKeyFields = SystemId;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(dimid; Rec.SystemId)
                {
                    ApplicationArea = All;
                }
                field(PurchInvEntryNo; Rec."Purch Inv Entry No.")
                {
                    ApplicationArea = All;
                }
                field(PurchInvLineLineNo; Rec."Purch Inv Line LineNo.")
                {
                    ApplicationArea = All;
                }
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field(invLineid; Rec.LineId)
                {
                    ApplicationArea = All;
                }
                field(Code2; Rec."Code 2")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(DimensionCode; Rec."Dimension Code")
                {
                    ApplicationArea = All;
                }
                field(ShipManagerId; Rec."Ship Manager Id")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean var
        PurchInvLineInb: Record "PB Purchase Invoice Line Inb";
        PurchInvLineDimInb: Record "PB Purchase Inv. Line Dim Inb";
    begin
        PurchInvLineInb.GetBySystemId(Rec.LineId);
        Rec."Purch Inv Entry No.":=PurchInvLineInb."Purch Inv Entry No.";
        Rec."Purch Inv Line LineNo.":=PurchInvLineInb."Line No.";
        PurchInvLineDimInb.Reset();
        PurchInvLineDimInb.SetRange("Purch Inv Entry No.", Rec."Purch Inv Entry No.");
        PurchInvLineDimInb.SetRange("Purch Inv Line LineNo.", Rec."Purch Inv Line LineNo.");
        if PurchInvLineDimInb.FindLast()then Rec."Line No.":=PurchInvLineDimInb."Line No." + 10000
        else
            Rec."Line No.":=10000;
    end;
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        PurchaseInvLineInb: Record "PB Purchase Invoice Line Inb";
    begin
        PurchaseInvLineInb.GetBySystemId(Rec.LineId);
        Rec."Purch Inv Entry No.":=PurchaseInvLineInb."Purch Inv Entry No.";
        Rec."Purch Inv Line LineNo.":=PurchaseInvLineInb."Line No.";
    end;
}
