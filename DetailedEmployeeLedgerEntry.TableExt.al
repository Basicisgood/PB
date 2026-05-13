tableextension 50140 DetailedEmployeeLedgerEntry extends "Detailed Employee Ledger Entry"
{ //PS006
    fields
    {
    }
    trigger OnAfterInsert()
    begin
        InvoiceDocNo:='';
        PaymentDocNo:='';
        if(Rec."Entry Type" = Rec."Entry Type"::Application) and (not Rec.Unapplied)then begin
            //>>>>For Payment Record>>>>
            empLedgerEntry.Reset();
            empLedgerEntry.SetRange(empLedgerEntry."Entry No.", Rec."employee Ledger Entry No.");
            empLedgerEntry.SetRange(empLedgerEntry."Document Type", empLedgerEntry."Document Type"::Payment);
            if empLedgerEntry.FindFirst()then begin
                FindInvoiceDocumentNo();
            end;
            //>>>>For Invoice Record>>>>
            empLedgerEntry2.Reset();
            empLedgerEntry2.SetRange(empLedgerEntry2."Entry No.", Rec."employee Ledger Entry No.");
            //empLedgerEntry2.SetRange(empLedgerEntry2."Document Type", empLedgerEntry2."Document Type"::Invoice);
            empLedgerEntry2.SetRange("PB Concur invoice", true);
            if empLedgerEntry2.FindFirst()then begin
                GLSetup.get;
                apisetup.get;
                DimSetEntry.Reset();
                DimSetEntry.SetRange("Dimension Set ID", EmpLedgerEntry2."Dimension Set ID");
                DimSetEntry.SetRange("Dimension Code", GLSetup."Global Dimension 2 Code");
                if DimSetEntry.FindFirst()then if DimSetEntry."Dimension Value Code" = APISetup."Default Concur Dimension" then begin
                        FindPaymentDocumentNo();
                    end;
            end;
        end;
    end;
    procedure CreateOutboundLog(P_Type: Option Insert, Update)
    var
        OutboundLog: Record "Concur Outbound Log";
        EmpLedgerEntry2: Record "Employee Ledger Entry";
        Log: Record "Concur Outbound Log";
    begin
        Log.reset;
        Log.SetCurrentKey("Table No.", "Primary key", Status);
        Log.SetRange("Table No.", 5222);
        Log.SetRange("Primary key", Format(PaymentDocNo));
        Log.SetRange("Primary key 2", InvoiceDocNo);
        Log.SetFilter(Status, '<>%1', Log.Status::Success);
        IF Not Log.FindFirst()then begin
            OutboundLog.Init();
            OutboundLog."Table No.":=5222;
            OutboundLog."Table Name":=EmpLedgerEntry2.TableName;
            OutboundLog."Primary key":=Format(PaymentDocNo);
            OutboundLog."Primary key 2":=InvoiceDocNo;
            OutboundLog."Entry Type":=P_Type;
            OutboundLog.Status:=OutboundLog.Status::Pending;
            OutboundLog."Company Name":=CompanyName;
            OutboundLog.Insert(true);
        End;
    end;
    local procedure FindInvoiceDocumentNo()
    begin
        PaymentDocNo:=empLedgerEntry."Document No.";
        DetailempLedgerentry1.Reset();
        DetailempLedgerentry1.SetRange("Entry Type", DetailempLedgerentry1."Entry Type"::Application);
        DetailempLedgerentry1.SetRange("Document No.", Rec."Document No.");
        if Rec."Transaction No." <> 0 then DetailempLedgerentry1.SetRange("Transaction No.", Rec."Transaction No.");
        if Rec."Application No." <> 0 then DetailempLedgerentry1.SetRange("Application No.", Rec."Application No.");
        if Rec."Applied Empl. Ledger Entry No." <> 0 then DetailempLedgerentry1.SetRange("Applied empl. Ledger Entry No.", Rec."Applied empl. Ledger Entry No.");
        DetailempLedgerentry1.SetRange(Unapplied, false);
        if DetailempLedgerentry1.FindSet()then repeat empLedgerEntry2.Reset();
                //empLedgerEntry2.SetRange(empLedgerEntry2."Document Type", empLedgerEntry2."Document Type"::Invoice);
                empLedgerEntry2.SetRange(empLedgerEntry2."Entry No.", DetailempLedgerentry1."employee Ledger Entry No.");
                EmpLedgerEntry2.SetRange("PB Concur Invoice", true);
                if empLedgerEntry2.FindFirst()then begin
                    GLSetup.get;
                    apisetup.get;
                    DimSetEntry.Reset();
                    DimSetEntry.SetRange("Dimension Set ID", EmpLedgerEntry2."Dimension Set ID");
                    DimSetEntry.SetRange("Dimension Code", GLSetup."Global Dimension 2 Code");
                    if DimSetEntry.FindFirst()then if DimSetEntry."Dimension Value Code" = APISetup."Default Concur Dimension" then begin
                            InvoiceDocNo:=empLedgerEntry2."Document No.";
                            CreateOutboundLog(1);
                        end;
                end;
            until DetailempLedgerentry1.Next() = 0;
    end;
    local procedure FindPaymentDocumentNo()
    begin
        InvoiceDocNo:=empLedgerEntry2."Document No."; //insert invoice doc no
        DetailempLedgerentry2.Reset();
        DetailempLedgerentry2.SetRange("Entry Type", DetailempLedgerentry2."Entry Type"::Application);
        DetailempLedgerentry2.SetRange("Document No.", Rec."Document No.");
        if Rec."Transaction No." <> 0 then DetailempLedgerentry2.SetRange("Transaction No.", Rec."Transaction No.");
        if Rec."Application No." <> 0 then DetailempLedgerentry2.SetRange("Application No.", Rec."Application No.");
        if Rec."Applied empl. Ledger Entry No." <> 0 then DetailempLedgerentry2.SetRange("Applied empl. Ledger Entry No.", Rec."Applied empl. Ledger Entry No.");
        DetailempLedgerentry2.SetRange(Unapplied, false);
        if DetailempLedgerentry2.FindSet()then begin
            repeat empLedgerEntry.Reset();
                empLedgerEntry.SetRange(empLedgerEntry."Entry No.", DetailempLedgerentry2."employee Ledger Entry No.");
                empLedgerEntry.SetRange(empLedgerEntry."Document Type", empLedgerEntry."Document Type"::Payment);
                if empLedgerEntry.FindFirst()then begin
                    PaymentDocNo:=empLedgerEntry."Document No.";
                    CreateOutboundLog(1);
                end;
            until DetailempLedgerentry2.Next() = 0;
        end;
    end;
    var PaymentDocNo: code[50];
    InvoiceDocNo: code[50];
    DetailEmpLedgerentry1: Record "Detailed Employee Ledger Entry";
    DetailEmpLedgerentry2: Record "Detailed Employee Ledger Entry";
    EmpLedgerEntry: Record "Employee Ledger Entry";
    EmpLedgerEntry2: Record "Employee Ledger Entry";
    ConcurTab: Record "Concur Outbound Log";
    DimSetEntry: Record "Dimension Set Entry";
    GLSetup: Record "General Ledger Setup";
    APISetup: Record "Concur API Setup";
}
