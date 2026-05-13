codeunit 50120 "Create Purchase Invoice"
{
    trigger OnRun()
    begin
        // CreatePurchaseInvoice();
        ProcessInvoiceInterface();
    end;
    procedure ProcessInvoiceInterface()
    var
        ErrorText: Text[250];
        PurchaseInvBound: Record "PB Purchase Invoice Inbound";
        PurchaseInvBound2: Record "PB Purchase Invoice Inbound";
        PurchaseLine: Record "Purchase Line";
        LineNo: Integer;
        InternalRef: Code[35];
        RecVendor: Record Vendor;
        RecCurrency: Record Currency;
        RecItem: Record item;
        PostSO: Boolean;
        SONo: Code[20];
        LocationCode: Code[20];
        TempPurchaseHeader: Record "Purchase Header" temporary;
        PostPO: Boolean;
        Autopost: Boolean;
        IsDuplicate: Boolean;
        CurrentLineDuplicate: Boolean;
        ItemNo: code[20];
        PostingDecriptionTrue: Boolean;
        CurrExchRate: Record "Currency Exchange Rate";
        GLAccount: Record "G/L Account";
        Dimensions: Record Dimension;
        dimensionValue: Record "Dimension Value";
    begin
        ClearLogEntry(50131, 0);
        PurchaseInvBound.RESET;
        PurchaseInvBound.SetCurrentKey("Vendor No.");
        PurchaseInvBound.SetFilter("Vendor No.", '<>%1', '');
        PurchaseInvBound.SetFilter("Order Code", '<>%1', '');
        PurchaseInvBound.SetFilter(Status, '%1|%2', PurchaseInvBound.Status::Pending, PurchaseInvBound.Status::Error);
        PurchaseInvBound.SetFilter(Status, '<>%1|%2', PurchaseInvBound.Status::Processed, PurchaseInvBound.Status::Cancel);
        IF PurchaseInvBound.FINDSET THEN REPEAT ClearLogEntry(50131, PurchaseInvBound."Entry No.");
                CurrentLineDuplicate:=false;
                IsDuplicate:=false;
                If IsDuplicate = false then begin
                    Clear(IsError);
                    PurchaseHdr.Reset();
                    PurchaseLine.Reset();
                    LocationCode:='';
                    ItemNo:='';
                    if DNVSetup.Get()then;
                    if not RecVendor.get(PurchaseInvBound."Vendor No.")then CreateInboundErrorLogEntry(50131, PurchaseInvBound."Entry No.", StrSubstNo('Vendor code %1 does not exist', PurchaseInvBound."Vendor No."));
                    if not RecCurrency.get(PurchaseInvBound."Currency Code")then CreateInboundErrorLogEntry(50131, PurchaseInvBound."Entry No.", StrSubstNo('There is no Currency code found For %1 , Entry No.%2', PurchaseInvBound."Vendor No.", PurchaseInvBound."Entry No."));
                    if(PurchaseInvBound."Invoice Date" = 0D)then CreateInboundErrorLogEntry(50131, PurchaseInvBound."Entry No.", StrSubstNo('Invoice Date does not blank Vendor Invoice No :%1 Entry No. : %2', PurchaseInvBound."Order Code", PurchaseInvBound."Entry No."));
                    if(PurchaseInvBound."Booking Date" = 0D)then CreateInboundErrorLogEntry(50131, PurchaseInvBound."Entry No.", StrSubstNo('Booking Date does not blank Vendor Invoice No :%1 Entry No. : %2', PurchaseInvBound."Order Code", PurchaseInvBound."Entry No."));
                    if(PurchaseInvBound."Maturity Date" = 0D)then CreateInboundErrorLogEntry(50131, PurchaseInvBound."Entry No.", StrSubstNo('Maturity Date does not blank Vendor Invoice No :%1 Entry No. : %2', PurchaseInvBound."Order Code", PurchaseInvBound."Entry No."));
                    if PurchaseInvBound."Order Code" = '' then CreateInboundErrorLogEntry(50131, PurchaseInvBound."Entry No.", StrSubstNo('Vendor Invoice No. does not Blank Entry No. : %1', PurchaseInvBound."Entry No."));
                    purchaseInvBoundLine.Reset();
                    purchaseInvBoundLine.SetRange("Purch Inv Entry No.", PurchaseInvBound."Entry No.");
                    if purchaseInvBoundLine.Findset()then begin
                        repeat if not GLAccount.get(purchaseInvBoundLine."Account Code")then CreateInboundErrorLogEntry(50131, PurchaseInvBound."Entry No.", StrSubstNo('Item No. %1 does not exist For Entry No. %2', (purchaseInvBoundLine."Account Code"), PurchaseInvBound."Entry No."));
                            if purchaseInvBoundLine."Invoiced Quantity" = 0 then CreateInboundErrorLogEntry(50131, PurchaseInvBound."Entry No.", StrSubstNo('Invoiced Quantity does not Blank Entry No. : %1', PurchaseInvBound."Entry No."));
                            PBPurchaseInvLineDimInb.Reset();
                            PBPurchaseInvLineDimInb.SetRange("Purch Inv Entry No.", purchaseInvBoundLine."Purch Inv Entry No.");
                            PBPurchaseInvLineDimInb.SetRange("Purch Inv Line LineNo.", purchaseInvBoundLine."Line No.");
                            if PBPurchaseInvLineDimInb.FindSet()then repeat if not Dimensions.get(PBPurchaseInvLineDimInb."Ship Manager Id")then CreateInboundErrorLogEntry(50131, PurchaseInvBound."Entry No.", StrSubstNo('dimension Code %1 does not exist For Entry No. %2', (PBPurchaseInvLineDimInb."Ship Manager Id"), PurchaseInvBound."Entry No."));
                                    if not dimensionValue.get(PBPurchaseInvLineDimInb."Ship Manager Id", PBPurchaseInvLineDimInb."Dimension Code")then CreateInboundErrorLogEntry(50131, PurchaseInvBound."Entry No.", StrSubstNo('dimension Value %1 does not exist For Entry No. %2', (PBPurchaseInvLineDimInb."Dimension Code"), PurchaseInvBound."Entry No."));
                                until PBPurchaseInvLineDimInb.Next() = 0;
                        until purchaseInvBoundLine.Next() = 0;
                    end;
                    if PurchaseInvBound."Order Code" <> InternalRef then begin
                        if IsError = false then begin
                            PurchaseHdr.Init();
                            PurchaseHdr.Validate("Document Type", PurchaseHdr."Document Type"::Invoice);
                            PurchaseHdr."No.":='';
                            PurchaseHdr.Insert(true);
                            PurchaseHdr.Validate("Buy-from Vendor No.", PurchaseInvBound."Vendor No.");
                            PurchaseHdr.Validate("PB DNV invoice", true);
                            PurchaseHdr."PB Ship Manager ID":=PurchaseInvBound."Ship Manager";
                            PurchaseHdr.validate("Document Date", PurchaseInvBound."Invoice Date");
                            PurchaseHdr.validate("Posting Date", PurchaseInvBound."Booking Date");
                            PurchaseHdr.validate("Due Date", PurchaseInvBound."Maturity Date");
                            PurchaseHdr."Vendor Invoice No.":=PurchaseInvBound."Order Code";
                            PurchaseHdr."DNV Approved At":=PurchaseInvBound."Approved At";
                            PurchaseHdr."DNV Approved By":=PurchaseInvBound."Approved By";
                            PurchaseHdr.validate("Currency Code", PurchaseInvBound."Currency Code");
                            PurchaseHdr.validate("Currency Factor", PurchaseInvBound."Currency Exchange Rate");
                            PurchaseHdr."DNV Staging Entry No.":=PurchaseInvBound."Entry No.";
                            PurchaseHdr.Invoice:=true;
                            PurchaseHdr.Receive:=true;
                            PurchaseHdr.Modify();
                            TempPurchaseHeader.Init();
                            TempPurchaseHeader:=PurchaseHdr;
                            TempPurchaseHeader.Insert();
                        end;
                    end;
                end;
                InternalRef:=PurchaseInvBound."Order Code";
                TempPurchaseHeader.Reset();
                TempPurchaseHeader.SetRange(TempPurchaseHeader."Vendor Invoice No.", PurchaseInvBound."Order Code");
                if TempPurchaseHeader.IsEmpty then IsError:=true;
                if IsError = false then begin
                    purchaseInvBoundLine.Reset();
                    purchaseInvBoundLine.SetRange("Purch Inv Entry No.", PurchaseInvBound."Entry No.");
                    if purchaseInvBoundLine.Findset()then repeat begin
                            PurchaseLine.Init();
                            PurchaseLine.Validate("Document Type", PurchaseHdr."Document Type");
                            PurchaseLine.Validate("Document No.", PurchaseHdr."No.");
                            PurchaseLine.validate(Type, PurchaseLine.Type::"G/L Account");
                            LineNo:=LineNo + 10000;
                            PurchaseLine."Line No.":=LineNo;
                            PurchaseLine.Insert();
                            PurchaseLine.validate("No.", purchaseInvBoundLine."Account Code");
                            Purchaseline.Description:=Format(purchaseInvBoundLine."Ship Code" + '' + '814' + '' + purchaseInvBoundLine."Account Code" + '' + purchaseInvBound."Order Code" + purchaseInvBoundLine."Order Item Number");
                            PurchaseLine.Validate(Quantity, purchaseInvBoundLine."Invoiced Quantity");
                            PurchaseLine.validate("Direct Unit Cost", purchaseInvBoundLine."Single Price");
                            PurchaseLine.validate(Amount, purchaseInvBoundLine."Total Amount");
                            PurchaseLine."Dimension Set ID":=GetDimSetID(purchaseInvBoundLine."Purch Inv Entry No.");
                        end;
                            PurchaseLine.Modify();
                        until purchaseInvBoundLine.Next() = 0;
                    PurchaseHdr."posting Description":=purchaseInvBoundLine."Ship Code" + '814' + purchaseInvBoundLine."Account Code" + purchaseInvBound."Order Code";
                    PurchaseHdr.Modify();
                end;
                if IsError = false then begin
                    PurchaseInvBound.Status:=PurchaseInvBound.Status::Processed;
                    PurchaseInvBound."Purchase Order No.":=PurchaseHdr."No.";
                    PurchaseInvBound.Modify();
                    PostPO:=true;
                end
                else
                begin
                    PurchaseInvBound.Status:=PurchaseInvBound.Status::Error;
                    if PurchaseInvBound.Status = PurchaseInvBound.Status::Error then PurchaseInvBound.Modify();
                    PostPO:=false;
                end;
                if DNVSetup."Auto Post Invoice" then begin
                    if PostPO then begin
                        PurchaseInvBound2.Reset();
                        PurchaseInvBound2.SetRange("Order Code", PurchaseInvBound."Order Code");
                        if PurchaseInvBound2.FindLast()then repeat //Post Invoice
                                PostReceiptInvoice(TempPurchaseHeader, PurchaseInvBound);
                            until PurchaseInvBound2.Next = 0;
                    end;
                end;
            until PurchaseInvBound.next = 0;
    end;
    procedure ClearLogEntry(TableNo: Integer; EntryNo_p: Integer)
    begin
        //clear log
        ItemErrorLogEntry.Reset();
        ItemErrorLogEntry.SetRange("Inbound Table", TableNo);
        IF EntryNo_p <> 0 then ItemErrorLogEntry.SetRange("Inbound Entry No.", EntryNo_p);
        if ItemErrorLogEntry.FindFirst()then ItemErrorLogEntry.DeleteAll();
    end;
    procedure GetDimSetID(CommittedCostDimEntryNo: Integer): Integer var
        TempDimSetEnt: Record "Dimension Set Entry" temporary;
        DimensionMgmt: Codeunit DimensionManagement;
        DimSetID: Integer;
    begin
        TempDimSetEnt.DeleteAll();
        Clear(TempDimSetEnt);
        PBPurchaseInvLineDimInb.reset;
        PBPurchaseInvLineDimInb.setrange("Purch Inv Entry No.", CommittedCostDimEntryNo);
        if PBPurchaseInvLineDimInb.FindSet()then begin
            repeat if PBPurchaseInvLineDimInb."Dimension Code" <> '' THEN begin
                    TempDimSetEnt.Init();
                    TempDimSetEnt.Validate("Dimension Code", PBPurchaseInvLineDimInb."Ship Manager Id");
                    TempDimSetEnt.Validate("Dimension Value Code", PBPurchaseInvLineDimInb."Dimension Code");
                    if TempDimSetEnt.Insert()then;
                end;
            until PBPurchaseInvLineDimInb.Next() = 0;
        end;
        DimSetID:=DimensionMgmt.GetDimensionSetID(TempDimSetEnt);
        if DimSetID <> 0 then exit(DimSetID)
        ELSE
            exit(0);
    end;
    procedure PostReceiptInvoice(p_PH: Record "Purchase Header"; PurchaseInvoiceInbound: Record "PB Purchase Invoice Inbound")
    VAR
        ErrorText: Text;
        PBPurchaseInvInb: Record "PB Purchase Invoice Inbound";
        purch_post_rec: Codeunit "Purch.-Post";
    BEGIN
        IF PBPurchaseInvInb.Status = PBPurchaseInvInb.Status::Processed then exit
        Else
        begin
            ClearLastError();
            p_PH.Ship:=false;
            p_PH.Receive:=true;
            p_PH.Invoice:=true;
            Commit();
            IF NOT purch_post_rec.Run(p_PH)THEN begin
                ErrorText:=GetLastErrorText();
                PBPurchaseInvInb.Reset();
                PBPurchaseInvInb.SetRange("Entry No.", PurchaseInvoiceInbound."Entry No.");
                if PBPurchaseInvInb.FindFirst()then begin
                    PBPurchaseInvInb.ModifyAll(Status, PBPurchaseInvInb.Status::Error);
                    PBPurchaseInvInb.ModifyAll("Error Description", ErrorText);
                end;
            end
            else
            begin
                PurchaseInvBound.Status:=PurchaseInvBound.Status::Processed;
                PurchaseInvBound.Modify();
            end;
        end;
    end;
    local procedure CreateInboundErrorLogEntry(TableNo: Integer; EntryNo_p: Integer; ErrorText_p: Text)
    var
        LastEntryNo: Integer;
    begin
        ItemErrorLogEntry.Reset();
        if ItemErrorLogEntry.FindLast()then LastEntryNo:=ItemErrorLogEntry."Entry No."
        else
            LastEntryNo:=0;
        LastEntryNo:=LastEntryNo + 1;
        ItemErrorLogEntry.Init();
        ItemErrorLogEntry."Entry No.":=LastEntryNo;
        ItemErrorLogEntry."Inbound Table":=TableNo;
        ItemErrorLogEntry."Inbound Entry No.":=EntryNo_p;
        ItemErrorLogEntry."Error Text":=ErrorText_p;
        ItemErrorLogEntry.Insert();
        IsError:=true;
    end;
    var PurchaseHdr: record "Purchase Header";
    TempPurchaseHdr: record "Purchase Header";
    PurchaseLine: Record "Purchase Line";
    PurchaseInvBound: Record "PB Purchase Invoice Inbound";
    purchaseInvBoundLine: record "PB Purchase Invoice Line Inb";
    PurchasePost: Codeunit "Purch.-Post";
    VendorNo: code[20];
    PBPurchaseInvLineDimInb: Record "PB Purchase Inv. Line Dim Inb";
    DimSetID: Integer;
    SuccessTrue: Boolean;
    Item: Record Item;
    ItemErrorLogEntry: Record "Inbound Error Log Entry";
    i: Integer;
    IsError: Boolean;
    Location: Record Location;
    DNVSetup: Record "DNV Integration Setup";
}
