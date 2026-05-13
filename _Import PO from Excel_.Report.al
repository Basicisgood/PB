report 50102 "Import PO from Excel"
{
    Caption = 'Import Purchase Order from Excel';
    ProcessingOnly = true;
    UseRequestPage = false;
    ApplicationArea = all;
    UsageCategory = Tasks;

    dataset
    {
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    trigger OnPreReport()
    begin
        ImportFromExcel();
    end;
    trigger OnPostReport()
    begin
        CreatePurchaseOrder();
    end;
    local procedure ImportFromExcel()
    var
        ExcelImportFunctions: Codeunit "Excel Custom Functions";
        ExcelBuffer: Record "Excel Buffer" temporary;
        InS: InStream;
        Filename: Text;
        Row: Integer;
        LastRow: Integer;
        AccountTypeText: Text;
    begin
        if UploadIntoStream('Upload Excel File', '', '', Filename, InS)then begin
            ExcelBuffer.OpenBookStream(InS, 'Sheet1');
            ExcelBuffer.ReadSheet();
            // ExcelBuffer.setrange("Column No.", 4);
            ExcelBuffer.FindLast();
            LastRow:=ExcelBuffer."Row No.";
            ExcelBuffer.Reset();
            POLineTemp.Reset();
            POLineTemp.DeleteAll();
            GlSetup.Reset();
            GlSetup.Get();
            LineNo_G:=0;
            for row:=2 to LastRow do begin
                LineNo_G+=10000;
                POLineTemp.Init();
                POLineTemp."Document Type":=POLineTemp."Document Type"::Order;
                POLineTemp."Document No.":=ExcelImportFunctions.GetText(ExcelBuffer, 'A', row); //PO No.
                POLineTemp."Line No.":=LineNo_G;
                POLineTemp."Buy-from Vendor No.":=ExcelImportFunctions.GetText(ExcelBuffer, 'B', row); // Vendor No.
                POLineTemp."Planned Receipt Date":=ExcelImportFunctions.GetDate(ExcelBuffer, 'C', row); //Posting Date
                POLineTemp."Expected Receipt Date":=ExcelImportFunctions.GetDate(ExcelBuffer, 'D', row); // Order Date
                POLineTemp."IC Item Reference No.":=ExcelImportFunctions.GetText(ExcelBuffer, 'E', row); // Vendor Ord No. //35 length
                POLineTemp."Inv. Discount Amount":=ExcelImportFunctions.GetDecimal(ExcelBuffer, 'F', row); //Discount Amount - line
                POLineTemp."Currency Code":=ExcelImportFunctions.GetText(ExcelBuffer, 'G', row); // Currency //35 length
                AccountTypeText:=ExcelImportFunctions.GetText(ExcelBuffer, 'H', row); //Type - line
                GetAccountType(POLineTemp, AccountTypeText);
                POLineTemp."No.":=ExcelImportFunctions.GetText(ExcelBuffer, 'I', row); //No - Line
                POLineTemp.Description:=ExcelImportFunctions.GetText(ExcelBuffer, 'J', row); //Vendor Name
                POLineTemp.Quantity:=ExcelImportFunctions.GetDecimal(ExcelBuffer, 'K', row); // Qty - Line
                POLineTemp."Direct Unit Cost":=ExcelImportFunctions.GetDecimal(ExcelBuffer, 'L', row); //Direct Unit Cost - line
                POLineTemp."Line Discount Amount":=ExcelImportFunctions.GetDecimal(ExcelBuffer, 'M', row); // Line Disc Amt - line
                POLineTemp."Line Discount %":=ExcelImportFunctions.GetDecimal(ExcelBuffer, 'N', row); //Discount Amount - line
                POLineTemp."Shortcut Dimension 1 Code":=ExcelImportFunctions.GetText(ExcelBuffer, 'O', row); //GD1
                POLineTemp."Shortcut Dimension 2 Code":=ExcelImportFunctions.GetText(ExcelBuffer, 'P', row); //GD2
                POLineTemp."Shortcut Dimension 3 Code":=ExcelImportFunctions.GetText(ExcelBuffer, 'Q', row); //SD3
                POLineTemp."Shortcut Dimension 4 Code":=ExcelImportFunctions.GetText(ExcelBuffer, 'R', row); //SD4
                POLineTemp."Shortcut Dimension 5 Code":=ExcelImportFunctions.GetText(ExcelBuffer, 'S', row); //SD5
                POLineTemp."Shortcut Dimension 6 Code":=ExcelImportFunctions.GetText(ExcelBuffer, 'T', row); //SD6
                POLineTemp."Shortcut Dimension 7 Code":=ExcelImportFunctions.GetText(ExcelBuffer, 'U', row); //Sd7
                POLineTemp."Shortcut Dimension 8 Code":=ExcelImportFunctions.GetText(ExcelBuffer, 'V', row); //SD8
                POLineTemp."Shortcut Dimension 9 Code":=ExcelImportFunctions.GetText(ExcelBuffer, 'W', row); //SD9
                POLineTemp."Shortcut Dimension 10 Code":=ExcelImportFunctions.GetText(ExcelBuffer, 'X', row); //SD10
                POLineTemp."Shortcut Dimension 11 Code":=ExcelImportFunctions.GetText(ExcelBuffer, 'Y', row); //GD1 - line
                POLineTemp."Shortcut Dimension 12 Code":=ExcelImportFunctions.GetText(ExcelBuffer, 'Z', row); // GD2 - line
                POLineTemp.Insert();
            end;
        end;
    end;
    local procedure GetAccountType(var PurchLine_p: Record "Purchase Line"; AccountTypeText: Text)
    begin
        case AccountTypeText of '': PurchLine_p.Type:=PurchLine_p.Type::" ";
        'Allocation Account': PurchLine_p.Type:=PurchLine_p.Type::"Allocation Account";
        'Charge (Item)': PurchLine_p.Type:=PurchLine_p.Type::"Charge (Item)";
        'Fixed Asset': PurchLine_p.Type:=PurchLine_p.Type::"Fixed Asset";
        'G/L Account': PurchLine_p.Type:=PurchLine_p.Type::"G/L Account";
        'Item': PurchLine_p.Type:=PurchLine_p.Type::Item;
        'Resource': PurchLine_p.Type:=PurchLine_p.Type::Resource;
        end;
    end;
    local procedure CreatePurchaseOrder()
    begin
        POLineTemp.Reset();
        IF POLineTemp.Count <= 0 then exit;
        IF POLineTemp.FindSet()then repeat If PurchHeaderExistAlready(POLineTemp."Document No.")then begin
                    InsertPurchLine(POLineTemp);
                end
                Else
                begin
                    InsertPurchHeader(POLineTemp);
                    InsertPurchLine(POLineTemp);
                end;
            until POLineTemp.Next() = 0;
    end;
    local procedure PurchHeaderExistAlready(DocumentNo: Code[20]): boolean var
        PurchaseHdr_l: Record "Purchase Header";
    begin
        PurchaseHdr_l.Reset();
        PurchaseHdr_l.SetRange("Document Type", PurchaseHdr_l."Document Type"::Order);
        PurchaseHdr_l.SetRange("Import Ref No.", DocumentNo);
        exit(NOT PurchaseHdr_l.IsEmpty);
    end;
    local procedure InsertPurchLine(var POLineTemp_p: Record "Purchase Line")
    var
        PurchLine_l: Record "Purchase Line";
    begin
        PurchLine_l.init();
        PurchLine_l."Document Type":=POLineTemp_p."Document Type";
        PurchLine_l."Document No.":=PurchHeader_l."No.";
        PurchLine_l."Line No.":=POLineTemp_p."Line No.";
        PurchLine_l.Validate(Type, POLineTemp_p.Type);
        PurchLine_l.Validate("No.", POLineTemp_p."No.");
        PurchLine_l.Validate("Location Code", POLineTemp_p."Location Code");
        PurchLine_l.Validate(Quantity, POLineTemp_p.Quantity);
        PurchLine_l.Validate("Direct Unit Cost", POLineTemp_p."Direct Unit Cost");
        PurchLine_l.Validate("Line Discount Amount", POLineTemp_p."Line Discount Amount");
        PurchLine_l.Validate("Inv. Discount Amount", POLineTemp_p."Inv. Discount Amount");
        PurchLine_l.Validate("Shortcut Dimension 1 Code", POLineTemp_p."Shortcut Dimension 1 Code");
        PurchLine_l.Validate("Shortcut Dimension 2 Code", POLineTemp_p."Shortcut Dimension 2 Code");
        PurchLine_l.Insert();
    end;
    local procedure InsertPurchHeader(var POLineTemp_p: Record "Purchase Line")
    var
    begin
        // POLineTemp_p."Document No." //PO No.
        // POLineTemp_p."Buy-from Vendor No." // Vendor No.
        // POLineTemp_p.Description //Vendor Name
        // POLineTemp_p."Planned Receipt Date"  //Posting Date
        // POLineTemp_p."Expected Receipt Date"  // Order Date
        // POLineTemp_p."Item Reference No." //Vendor Inv NO. //35 length
        // POLineTemp_p."IC Item Reference No."  // Vendor Ord No. //35 length
        // POLineTemp_p."Promised Receipt Date"  // Due date
        // POLineTemp_p."Shortcut Dimension 1 Code"   //GD1
        // POLineTemp_p."Shortcut Dimension 2 Code"  //GD2
        PurchHeader_l.Init();
        PurchHeader_l."Document Type":=PurchHeader_l."Document Type"::Order;
        //PurchHeader_l.Validate("No.", POLineTemp_p."Document No.");
        PurchHeader_l."No.":='';
        PurchHeader_l.Insert(true);
        PurchHeader_l.Validate("Buy-from Vendor No.", POLineTemp_p."Buy-from Vendor No.");
        PurchHeader_l."Buy-from Vendor Name":=POLineTemp_p.Description;
        PurchHeader_l.Validate("Posting Date", POLineTemp_p."Planned Receipt Date");
        PurchHeader_l.Validate("Order Date", POLineTemp_p."Expected Receipt Date");
        PurchHeader_l."Vendor Order No.":=CopyStr(POLineTemp_p."IC Item Reference No.", 1, 35);
        PurchHeader_l.Validate("Invoice Discount Value", POLineTemp_p."Inv. Discount Amount");
        PurchHeader_l.Validate("Shortcut Dimension 1 Code", POLineTemp_p."Shortcut Dimension 1 Code");
        PurchHeader_l.Validate("Shortcut Dimension 2 Code", POLineTemp_p."Shortcut Dimension 2 Code");
        CreateDimensions(POLineTemp_p);
        IF NewDimSetID <> 0 then PurchHeader_l.Validate("Dimension Set ID", NewDimSetID);
        PurchHeader_l."Import Ref No.":=POLineTemp_p."Document No.";
        PurchHeader_l.Modify();
    end;
    local procedure CreateDimensions(var PurchLine_l: Record "Purchase Line")
    begin
        //Insert Dimension --  
        TempDimSetEntry.DeleteAll();
        IF DimValue_l.GET(GlSetup."Global Dimension 1 Code", PurchLine_l."Shortcut Dimension 1 Code")then begin
            TempDimSetEntry."Dimension Code":=DimValue_l."Dimension Code";
            TempDimSetEntry."Dimension Value Code":=DimValue_l.Code;
            TempDimSetEntry."Dimension Value ID":=DimValue_l."Dimension Value ID";
            TempDimSetEntry.INSERT(TRUE);
        end;
        IF DimValue_l.GET(GlSetup."Global Dimension 2 Code", PurchLine_l."Shortcut Dimension 2 Code")then begin
            TempDimSetEntry."Dimension Code":=DimValue_l."Dimension Code";
            TempDimSetEntry."Dimension Value Code":=DimValue_l.Code;
            TempDimSetEntry."Dimension Value ID":=DimValue_l."Dimension Value ID";
            TempDimSetEntry.INSERT(TRUE);
        end;
        IF DimValue_l.GET(GlSetup."Shortcut Dimension 3 Code", PurchLine_l."Shortcut Dimension 3 Code")then begin
            TempDimSetEntry."Dimension Code":=DimValue_l."Dimension Code";
            TempDimSetEntry."Dimension Value Code":=DimValue_l.Code;
            TempDimSetEntry."Dimension Value ID":=DimValue_l."Dimension Value ID";
            TempDimSetEntry.INSERT(TRUE);
        end;
        if DimValue_l.GET(GlSetup."Shortcut Dimension 4 Code", PurchLine_l."Shortcut Dimension 4 Code")then begin
            TempDimSetEntry."Dimension Code":=DimValue_l."Dimension Code";
            TempDimSetEntry."Dimension Value Code":=DimValue_l.Code;
            TempDimSetEntry."Dimension Value ID":=DimValue_l."Dimension Value ID";
            TempDimSetEntry.INSERT(TRUE);
        end;
        if DimValue_l.GET(GlSetup."Shortcut Dimension 5 Code", PurchLine_l."Shortcut Dimension 5 Code")then begin
            TempDimSetEntry."Dimension Code":=DimValue_l."Dimension Code";
            TempDimSetEntry."Dimension Value Code":=DimValue_l.Code;
            TempDimSetEntry."Dimension Value ID":=DimValue_l."Dimension Value ID";
            TempDimSetEntry.INSERT(TRUE);
        end;
        if DimValue_l.GET(GlSetup."Shortcut Dimension 6 Code", PurchLine_l."Shortcut Dimension 6 Code")then begin
            TempDimSetEntry."Dimension Code":=DimValue_l."Dimension Code";
            TempDimSetEntry."Dimension Value Code":=DimValue_l.Code;
            TempDimSetEntry."Dimension Value ID":=DimValue_l."Dimension Value ID";
            TempDimSetEntry.INSERT(TRUE);
        end;
        If DimValue_l.GET(GlSetup."Shortcut Dimension 7 Code", PurchLine_l."Shortcut Dimension 7 Code")then begin
            TempDimSetEntry."Dimension Code":=DimValue_l."Dimension Code";
            TempDimSetEntry."Dimension Value Code":=DimValue_l.Code;
            TempDimSetEntry."Dimension Value ID":=DimValue_l."Dimension Value ID";
            TempDimSetEntry.INSERT(TRUE);
        end;
        if DimValue_l.GET(GlSetup."Shortcut Dimension 8 Code", PurchLine_l."Shortcut Dimension 8 Code")then begin
            TempDimSetEntry."Dimension Code":=DimValue_l."Dimension Code";
            TempDimSetEntry."Dimension Value Code":=DimValue_l.Code;
            TempDimSetEntry."Dimension Value ID":=DimValue_l."Dimension Value ID";
            TempDimSetEntry.INSERT(TRUE);
        end;
        if DimValue_l.GET(GlSetup."Shortcut Dimension 9 Code", PurchLine_l."Shortcut Dimension 9 Code")then begin
            TempDimSetEntry."Dimension Code":=DimValue_l."Dimension Code";
            TempDimSetEntry."Dimension Value Code":=DimValue_l.Code;
            TempDimSetEntry."Dimension Value ID":=DimValue_l."Dimension Value ID";
            TempDimSetEntry.INSERT(TRUE);
        end;
        if DimValue_l.GET(GlSetup."Shortcut Dimension 10 Code", PurchLine_l."Shortcut Dimension 10 Code")then begin
            TempDimSetEntry."Dimension Code":=DimValue_l."Dimension Code";
            TempDimSetEntry."Dimension Value Code":=DimValue_l.Code;
            TempDimSetEntry."Dimension Value ID":=DimValue_l."Dimension Value ID";
            TempDimSetEntry.INSERT(TRUE);
        end;
        if DimValue_l.GET(GlSetup."Shortcut Dimension 11 Code", PurchLine_l."Shortcut Dimension 11 Code")then begin
            TempDimSetEntry."Dimension Code":=DimValue_l."Dimension Code";
            TempDimSetEntry."Dimension Value Code":=DimValue_l.Code;
            TempDimSetEntry."Dimension Value ID":=DimValue_l."Dimension Value ID";
            TempDimSetEntry.INSERT(TRUE);
        end;
        if DimValue_l.GET(GlSetup."Shortcut Dimension 12 Code", PurchLine_l."Shortcut Dimension 12 Code")then begin
            TempDimSetEntry."Dimension Code":=DimValue_l."Dimension Code";
            TempDimSetEntry."Dimension Value Code":=DimValue_l.Code;
            TempDimSetEntry."Dimension Value ID":=DimValue_l."Dimension Value ID";
            TempDimSetEntry.INSERT(TRUE);
        end;
        NewDimSetID:=DimMgt.GetDimensionSetID(TempDimSetEntry);
    end;
    var GlSetup: Record "General Ledger Setup";
    POLineTemp: Record "Purchase Line" temporary;
    PurchHeader: Record "Purchase Header";
    PurchLine: Record "Purchase Line";
    LineNo_G: Integer;
    DimValue_l: Record "Dimension Value";
    TempDimSetEntry: Record "Dimension Set Entry" temporary;
    NewDimSetID: Integer;
    DimMgt: Codeunit DimensionManagement;
    PurchHeader_l: Record "Purchase Header";
    DocNo_g: Code[20];
}
