tableextension 50112 DetailVendLedgerEntry extends "Detailed Vendor Ledg. Entry"
{
    fields
    {
    }
    trigger OnAfterInsert()
    begin
        InvoiceDocNo:='';
        PaymentDocNo:='';
        if(Rec."Entry Type" = Rec."Entry Type"::Application) and (not Rec.Unapplied)then begin
            //>>>>For Payment Record>>>>
            vendLedgerEntry.Reset();
            vendLedgerEntry.SetRange(vendLedgerEntry."Entry No.", Rec."Vendor Ledger Entry No.");
            //vendLedgerEntry.SetRange(vendLedgerEntry."Document Type", vendLedgerEntry."Document Type"::Payment);
            if vendLedgerEntry.FindFirst()then begin
                FindInvoiceDocumentNo();
            end;
            //>>>>For Invoice Record>>>>
            vendLedgerEntry2.Reset();
            vendLedgerEntry2.SetRange(vendLedgerEntry2."Entry No.", Rec."Vendor Ledger Entry No.");
            vendLedgerEntry2.SetRange(vendLedgerEntry2."Document Type", vendLedgerEntry2."Document Type"::Invoice);
            vendLedgerEntry2.SetRange("PB DNV invoice", true);
            if vendLedgerEntry2.FindFirst()then begin
                FindPaymentDocumentNo();
            end;
            //>>>>For Invoice Record>>>>
            vendLedgerEntry2.Reset();
            vendLedgerEntry2.SetRange(vendLedgerEntry2."Entry No.", Rec."Vendor Ledger Entry No.");
            //    vendLedgerEntry2.SetRange(vendLedgerEntry2."Document Type", vendLedgerEntry2."Document Type"::Invoice);
            vendLedgerEntry2.SetRange("IMOS Transaction", true);
            if vendLedgerEntry2.FindFirst()then begin
                FindPaymentDocumentNoIMOS();
            end;
            //PS006 Start
            vendLedgerEntry2.Reset();
            vendLedgerEntry2.SetRange(vendLedgerEntry2."Entry No.", Rec."Vendor Ledger Entry No.");
            vendLedgerEntry2.SetRange(vendLedgerEntry2."Document Type", vendLedgerEntry2."Document Type"::Invoice);
            vendLedgerEntry2.SetRange("PB Concur invoice", true);
            if vendLedgerEntry2.FindFirst()then begin
                FindPaymentDocumentNoConcur();
            end;
        //PS006 End
        end;
    end;
    procedure CreateOutboundLog(P_Type: Option Insert, Update)
    var
        OutboundLog: Record "DNV Outbound Log";
        vendLedgerEntry2: Record "Vendor Ledger Entry";
        Log: Record "DNV Outbound Log";
    begin
        exit;
        Log.reset;
        Log.SetCurrentKey("Table No.", "Primary key", Status);
        Log.SetRange("Table No.", 25);
        Log.SetRange("Primary key", Format(PaymentDocNo));
        Log.SetRange("Primary key 2", InvoiceDocNo);
        Log.SetFilter(Status, '<>%1', Log.Status::Success);
        IF Not Log.FindFirst()then begin
            OutboundLog.Init();
            OutboundLog."Table No.":=25;
            OutboundLog."Primary key":=Format(PaymentDocNo);
            OutboundLog."Primary key 2":=InvoiceDocNo;
            OutboundLog."Entry Type":=P_Type;
            OutboundLog.Status:=OutboundLog.Status::Pending;
            OutboundLog."Company Name":=CompanyName;
            OutboundLog.Insert(true);
        End;
    end;
    //TEC.VJ 13092024>>
    procedure CreateOutboundLogForIMOS(P_Type: Option Insert, Update)
    var
        IMOSOutboundLog: Record "IMOS API Log";
        Log: Record "IMOS API Log";
    begin
        exit;
        Log.reset;
        Log.SetCurrentKey("Table No.", "Primary key", Status);
        Log.SetRange("Table No.", Database::"Vendor Ledger Entry");
        Log.SetRange("Primary key 2", Format(PaymentDocNo));
        Log.SetRange("Primary key 3", InvoiceDocNo);
        Log.SetFilter(Status, '<>%1', Log.Status::Success);
        IF Not Log.FindFirst()then begin
            IMOSOutboundLog.Init();
            IMOSOutboundLog."Table No.":=Database::"Vendor Ledger Entry";
            IMOSOutboundLog."Company Code":=CompanyName;
            IMOSOutboundLog."Primary key 2":=Format(PaymentDocNo);
            IMOSOutboundLog."Primary key 3":=InvoiceDocNo;
            IMOSOutboundLog."Entry Type":=P_Type;
            IMOSOutboundLog.Status:=IMOSOutboundLog.Status::Pending;
            IMOSOutboundLog.Insert(true);
        End;
    end;
    //TEC.VJ 13092024<<
    local procedure FindInvoiceDocumentNo()
    begin
        PaymentDocNo:=vendLedgerEntry."Document No.";
        DetailVendLedgerentry1.Reset();
        DetailVendLedgerentry1.SetRange("Entry Type", DetailVendLedgerentry1."Entry Type"::Application);
        DetailVendLedgerentry1.SetRange("Document No.", Rec."Document No.");
        if Rec."Transaction No." <> 0 then DetailVendLedgerentry1.SetRange("Transaction No.", Rec."Transaction No.");
        if Rec."Application No." <> 0 then DetailVendLedgerentry1.SetRange("Application No.", Rec."Application No.");
        if Rec."Applied Vend. Ledger Entry No." <> 0 then DetailVendLedgerentry1.SetRange("Applied Vend. Ledger Entry No.", Rec."Applied Vend. Ledger Entry No.");
        DetailVendLedgerentry1.SetRange(Unapplied, false);
        if DetailVendLedgerentry1.FindSet()then repeat vendLedgerEntry2.Reset();
                //vendLedgerEntry2.SetRange(vendLedgerEntry2."Document Type", vendLedgerEntry2."Document Type"::Invoice);
                vendLedgerEntry2.SetRange(vendLedgerEntry2."Entry No.", DetailVendLedgerentry1."Vendor Ledger Entry No.");
                vendLedgerEntry2.SetRange("PB DNV invoice", true);
                if vendLedgerEntry2.FindFirst()then begin
                    InvoiceDocNo:=vendLedgerEntry2."Document No.";
                    CreateOutboundLog(1);
                end;
                vendLedgerEntry2.Reset();
                //vendLedgerEntry2.SetRange(vendLedgerEntry2."Document Type", vendLedgerEntry2."Document Type"::Invoice);
                vendLedgerEntry2.SetRange(vendLedgerEntry2."Entry No.", DetailVendLedgerentry1."Vendor Ledger Entry No.");
                vendLedgerEntry2.SetRange("IMOS Transaction", true);
                if vendLedgerEntry2.FindFirst()then begin
                    InvoiceDocNo:=vendLedgerEntry2."Document No.";
                    CreateOutboundLogForIMOS(1);
                end;
                //PS006 Start
                vendLedgerEntry2.Reset();
                vendLedgerEntry2.SetRange(vendLedgerEntry2."Document Type", vendLedgerEntry2."Document Type"::Invoice);
                vendLedgerEntry2.SetRange(vendLedgerEntry2."Entry No.", DetailVendLedgerentry1."Vendor Ledger Entry No.");
                vendLedgerEntry2.SetRange("PB concur invoice", true);
                if vendLedgerEntry2.FindFirst()then begin
                    InvoiceDocNo:=vendLedgerEntry2."Document No.";
                    CreateOutboundLogforConcur(1);
                end;
            //PS006 End
            until DetailVendLedgerentry1.Next() = 0;
    //CreateOutboundLogForIMOS(1);        
    end;
    local procedure FindPaymentDocumentNo()
    begin
        InvoiceDocNo:=vendLedgerEntry2."Document No."; //insert invoice doc no
        DetailVendLedgerentry2.Reset();
        DetailVendLedgerentry2.SetRange("Entry Type", DetailVendLedgerentry2."Entry Type"::Application);
        DetailVendLedgerentry2.SetRange("Document No.", Rec."Document No.");
        if Rec."Transaction No." <> 0 then DetailVendLedgerentry2.SetRange("Transaction No.", Rec."Transaction No.");
        if Rec."Application No." <> 0 then DetailVendLedgerentry2.SetRange("Application No.", Rec."Application No.");
        if Rec."Applied Vend. Ledger Entry No." <> 0 then DetailVendLedgerentry2.SetRange("Applied Vend. Ledger Entry No.", Rec."Applied Vend. Ledger Entry No.");
        DetailVendLedgerentry2.SetRange(Unapplied, false);
        if DetailVendLedgerentry2.FindSet()then begin
            repeat vendLedgerEntry.Reset();
                vendLedgerEntry.SetRange(vendLedgerEntry."Entry No.", DetailVendLedgerentry2."Vendor Ledger Entry No.");
                vendLedgerEntry.SetRange(vendLedgerEntry."Document Type", vendLedgerEntry."Document Type"::Payment);
                if vendLedgerEntry.FindFirst()then begin
                    PaymentDocNo:=vendLedgerEntry."Document No.";
                    CreateOutboundLog(1);
                //CreateOutboundLogForIMOS(1);
                end;
            until DetailVendLedgerentry2.Next() = 0;
        end;
    end;
    local procedure FindPaymentDocumentNoIMOS()
    begin
        InvoiceDocNo:=vendLedgerEntry2."Document No."; //insert invoice doc no
        DetailVendLedgerentry2.Reset();
        DetailVendLedgerentry2.SetRange("Entry Type", DetailVendLedgerentry2."Entry Type"::Application);
        DetailVendLedgerentry2.SetRange("Document No.", Rec."Document No.");
        if Rec."Transaction No." <> 0 then DetailVendLedgerentry2.SetRange("Transaction No.", Rec."Transaction No.");
        if Rec."Application No." <> 0 then DetailVendLedgerentry2.SetRange("Application No.", Rec."Application No.");
        if Rec."Applied Vend. Ledger Entry No." <> 0 then DetailVendLedgerentry2.SetRange("Applied Vend. Ledger Entry No.", Rec."Applied Vend. Ledger Entry No.");
        DetailVendLedgerentry2.SetRange(Unapplied, false);
        if DetailVendLedgerentry2.FindSet()then begin
            repeat vendLedgerEntry.Reset();
                vendLedgerEntry.SetRange(vendLedgerEntry."Entry No.", DetailVendLedgerentry2."Vendor Ledger Entry No.");
                vendLedgerEntry.SetRange(vendLedgerEntry."Document Type", vendLedgerEntry."Document Type"::Payment);
                if vendLedgerEntry.FindFirst()then begin
                    PaymentDocNo:=vendLedgerEntry."Document No.";
                    //CreateOutboundLog(1);
                    CreateOutboundLogForIMOS(1);
                end;
            until DetailVendLedgerentry2.Next() = 0;
        end;
    end;
    //PS006 Start
    local procedure FindPaymentDocumentNoConcur()
    begin
        InvoiceDocNo:=vendLedgerEntry2."Document No."; //insert invoice doc no
        DetailVendLedgerentry2.Reset();
        DetailVendLedgerentry2.SetRange("Entry Type", DetailVendLedgerentry2."Entry Type"::Application);
        DetailVendLedgerentry2.SetRange("Document No.", Rec."Document No.");
        if Rec."Transaction No." <> 0 then DetailVendLedgerentry2.SetRange("Transaction No.", Rec."Transaction No.");
        if Rec."Application No." <> 0 then DetailVendLedgerentry2.SetRange("Application No.", Rec."Application No.");
        if Rec."Applied Vend. Ledger Entry No." <> 0 then DetailVendLedgerentry2.SetRange("Applied Vend. Ledger Entry No.", Rec."Applied Vend. Ledger Entry No.");
        DetailVendLedgerentry2.SetRange(Unapplied, false);
        if DetailVendLedgerentry2.FindSet()then begin
            repeat vendLedgerEntry.Reset();
                vendLedgerEntry.SetRange(vendLedgerEntry."Entry No.", DetailVendLedgerentry2."Vendor Ledger Entry No.");
                vendLedgerEntry.SetRange(vendLedgerEntry."Document Type", vendLedgerEntry."Document Type"::Payment);
                if vendLedgerEntry.FindFirst()then begin
                    PaymentDocNo:=vendLedgerEntry."Document No.";
                    CreateOutboundLogforConcur(1);
                end;
            until DetailVendLedgerentry2.Next() = 0;
        end;
    end;
    procedure CreateOutboundLogforConcur(P_Type: Option Insert, Update)
    var
        OutboundLog: Record "Concur Outbound Log";
        VendorLedgerEntry2: Record "Vendor Ledger Entry";
        Log: Record "Concur Outbound Log";
    begin
        Log.reset;
        Log.SetCurrentKey("Table No.", "Primary key", Status);
        Log.SetRange("Table No.", 25);
        Log.SetRange("Primary key", Format(PaymentDocNo));
        Log.SetRange("Primary key 2", InvoiceDocNo);
        Log.SetFilter(Status, '<>%1', Log.Status::Success);
        IF Not Log.FindFirst()then begin
            OutboundLog.Init();
            OutboundLog."Table No.":=25;
            OutboundLog."Table Name":=VendorLedgerEntry2.TableName;
            OutboundLog."Primary key":=Format(PaymentDocNo);
            OutboundLog."Primary key 2":=InvoiceDocNo;
            OutboundLog."Entry Type":=P_Type;
            OutboundLog.Status:=OutboundLog.Status::Pending;
            OutboundLog."Company Name":=CompanyName;
            OutboundLog.Insert(true);
        End;
    end;
    //PS006 End
    var DetailVendLedgerentry1: Record "Detailed Vendor Ledg. Entry";
    DetailVendLedgerentry2: Record "Detailed Vendor Ledg. Entry";
    vendLedgerEntry: Record "Vendor Ledger Entry";
    vendLedgerEntry2: Record "Vendor Ledger Entry";
    DVNTab: Record "DNV Outbound Log";
    PaymentDocNo: code[50];
    InvoiceDocNo: code[50];
}
