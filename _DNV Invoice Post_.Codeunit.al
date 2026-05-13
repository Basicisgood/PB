codeunit 50144 "DNV Invoice Post"
{
    TableNo = "PB Purchase Invoice Inbound";

    trigger OnRun()
    var
        //PbPurcchInv: Record "PB Purchase Invoice Inbound";
        VMT: record VMT;
        DNVSetup: Record "DNV Integration Setup";
        PBPurchInvLine: record "PB Purchase Invoice Line Inb";
        CompanyMapping: record "Company Name Mapping";
        GenJnlLine: record "Gen. Journal Line";
        vendor: Record Vendor;
        LineNo: Integer;
        InvoiceAmount: Decimal;
        VMTShipCode: record VMT;
        NoSeries: Codeunit "No. Series";
        GenTemp: Record "Gen. Journal Template";
        GlSetup: Record "General Ledger Setup";
        GlDescription: Text;
        GlAccountNo: Code[20];
        DryDockGL: Record "DNV Dry Dock GL Mapping";
        GenJnLLine2: record "Gen. Journal Line";
        CurrentaccountNo: code[20];
        //GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        mEntryNo: Integer;
        GLEntry: record "G/L Entry";
        DocNo: Code[20];
        CUPostGenJnl: Codeunit 50190;
    begin
        GlSetup.Get();
        DNVSetup.Get();
        CompanyMapping.get(CompanyName);
        CompanyMapping.TestField("Current Account No.");
        if(Rec."Posted Document No Fin Company" = '') and (rec."Finance Company No" = CompanyName)then begin
            GlEntry.Reset();
            GlEntry.SetCurrentKey("DNV Staging Entry No.", "Ship Manager Id");
            GlEntry.SetRange("DNV Staging Entry No.", Rec."Entry No.");
            GlEntry.SetRange("Ship Manager Id", rec."Ship Manager");
            GlEntry.SetRange(Reversed, false); //SGarg-Added- 24Jan2025
            if GLEntry.FindSet()then exit;
            CurrentaccountNo:='';
            CompanyMapping.get(rec."Ship Sign Company No");
            CompanyMapping.TestField("Current Account No.");
            CurrentaccountNo:=CompanyMapping."Current Account No.";
            CompanyMapping.get(CompanyName);
            CompanyMapping.TestField("Current Account No.");
            GenTemp.get(DNVSetup."Invoice Def. Gen. Jnl.Template");
            GlDescription:=rec."Order Code" + '  ';
            vendor.Reset();
            Vendor.SetRange("DNV Vendor No.", rec."Vendor No.");
            if not vendor.FindSet()then begin
                vendor.Reset();
                vendor.get(Rec."Vendor No.");
            end;
            VMT.Reset();
            vmt.SetRange(DBASE, CompanyMapping."PB Company Code");
            VMT.FindSet();
            InvoiceAmount:=0;
            PBPurchInvLine.Reset();
            PBPurchInvLine.SetRange("Purch Inv Entry No.", rec."Entry No.");
            PBPurchInvLine.SetFilter("Invoiced Quantity", '<>%1', 0);
            if PBPurchInvLine.FindSet()then repeat InvoiceAmount:=InvoiceAmount + PBPurchInvLine."Total Amount";
                    VMTShipCode.Reset();
                    VMTShipCode.Setfilter(SHIPSIGN, format(PBPurchInvLine."Ship Code"));
                    VMTShipCode.FindSet();
                    // GlDescription := DNVSetup."G/L Account Initials Sync" + PBPurchInvLine."Account Code" + '-' + rec."Order Code" + '-' + PBPurchInvLine."Order Item Number";
                    GlDescription:=PBPurchInvLine."Account Code" + ' ' + rec."Order Code" + '  ' + PBPurchInvLine."Order Item Number";
                    GlAccountNo:=DNVSetup."G/L Account Initials Sync" + PBPurchInvLine."Account Code";
                until PBPurchInvLine.Next() = 0;
            if InvoiceAmount = 0 then Error('Data is not valid');
            if InvoiceAmount <> 0 then begin
                GenJnlLine.Reset();
                GenJnlLine.setrange("Journal Template Name", DNVSetup."Invoice Def. Gen. Jnl.Template");
                GenJnlLine.setrange("Journal Batch Name", DNVSetup."Invoice Def. Gen. Jnl. Batch");
                if GenJnlLine.FindSet()then GenJnlLine.deleteall;
                LineNo:=0;
                LineNo:=LineNo + 10000;
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name":=DNVSetup."Invoice Def. Gen. Jnl.Template";
                GenJnlLine."Journal Batch Name":=DNVSetup."Invoice Def. Gen. Jnl. Batch";
                //      GenJnlLine.Validate("Document No.", NoSeries.GetNextNo(GenTemp."No. Series"));
                GenJnlLine.Validate("Document No.", format(rec."Entry No."));
                DocNo:=GenJnlLine."Document No.";
                GenJnlLine."Line No.":=LineNo;
                GenJnlLine.Validate("Posting Date", Rec."Approved At");
                GenJnlLine."Document Date":=Rec."Invoice Date";
                GenJnlLine.validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
                GenJnlLine.Validate("Account No.", CurrentaccountNo);
                GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::Vendor);
                GenJnlLine.Validate("Bal. Account No.", vendor."No.");
                //if GlSetup."LCY Code" <> Rec."Currency Code" then  //Sgarg- removed condition - 24Jan25
                GenJnlLine.Validate("Currency Code", rec."Currency Code");
                GenJnlLine.Validate(Amount, InvoiceAmount);
                GenJnlLine.Validate("Shortcut Dimension 1 Code", vmt.SEGMENT);
                GenJnlLine.Validate("Shortcut Dimension 2 Code", 'DINVO');
                GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyMapping."PB Company Code");
                GenJnlLine.Validate("Shortcut Dimension 9 Code", DNVSetup."Invoice Countrt Party Type"); // take fro msetup
                GenJnlLine.Validate("Shortcut Dimension 10 Code", VMTShipCode.VESSELCODE);
                GenJnlLine."Ship Manager Id":=rec."Ship Manager";
                GenJnlLine."DNV Staging Entry No.":=rec."Entry No.";
                GenJnlLine."PB DNV invoice":=true;
                GenJnlLine."Invoice Link":='DNV INV';
                GenJnlLine."Original Invoice No":=rec."Original Invoice No";
                GenJnlLine."External Document No.":=rec.Code;
                GenJnlLine.Description:=format(VMTShipCode.SHIPSIGN) + '  ' + GlDescription;
                // if InvoiceAmount < 0 then
                //   GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo"
                //else
                //  GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice;
                GenJnlLine."Auto Post":=true;
                GenJnlLine.Insert(true);
                //rec."Posted Document No Fin Company" := GenJnlLine."Document No.";
                //mEntryNo := GenJnlPostLine.RunWithCheck(GenJnlLine);
                //if mEntryNo <> 0 then
                //  GLEntry.get(mEntryNo);
                //rec."Posted Document No Fin Company" := GLEntry."Document No.";
                CUPostGenJnl.Run(GenJnlLine);
                rec.Modify();
            end;
        end;
        // Expenes Company Posting in ship company
        if(Rec."Posted Document No Shp Company" = '') and (rec."Ship Sign Company No" = CompanyName)then begin
            GlEntry.Reset();
            GlEntry.SetCurrentKey("DNV Staging Entry No.", "Ship Manager Id");
            GlEntry.SetRange("DNV Staging Entry No.", Rec."Entry No.");
            GlEntry.SetRange("Ship Manager Id", rec."Ship Manager");
            GlEntry.SetRange(Reversed, false); //SGarg-Added- 24Jan2025
            if GLEntry.FindSet()then exit;
            GenTemp.get(DNVSetup."Invoice Def. Gen. Jnl.Template");
            GlDescription:=rec."Order Code";
            CompanyMapping.get(rec."Finance Company No");
            CompanyMapping.TestField("Current Account No.");
            CurrentaccountNo:=CompanyMapping."Current Account No.";
            CompanyMapping.Reset();
            CompanyMapping.get(CompanyName);
            // vendor.Reset();
            //Vendor.SetRange("DNV Vendor No.", rec."Vendor No.");
            //vendor.FindSet();
            VMT.Reset();
            vmt.SetRange(DBASE, CompanyMapping."PB Company Code");
            VMT.FindSet();
            InvoiceAmount:=0;
            PBPurchInvLine.Reset();
            PBPurchInvLine.SetRange("Purch Inv Entry No.", rec."Entry No.");
            PBPurchInvLine.SetFilter("Invoiced Quantity", '<>%1', 0);
            if PBPurchInvLine.FindSet()then repeat InvoiceAmount:=InvoiceAmount + PBPurchInvLine."Total Amount";
                    VMTShipCode.Reset();
                    VMTShipCode.Setfilter(SHIPSIGN, format(PBPurchInvLine."Ship Code"));
                    VMTShipCode.FindSet();
                    GlDescription:=PBPurchInvLine."Account Code" + '  ' + rec."Order Code" + '  ' + PBPurchInvLine."Order Item Number";
                    GlAccountNo:=DNVSetup."G/L Account Initials Sync" + PBPurchInvLine."Account Code";
                until PBPurchInvLine.Next() = 0;
            if InvoiceAmount = 0 then Error('Data is not valid');
            if InvoiceAmount <> 0 then begin
                GenJnlLine.Reset();
                GenJnlLine.setrange("Journal Template Name", DNVSetup."Invoice Def. Gen. Jnl.Template");
                GenJnlLine.setrange("Journal Batch Name", DNVSetup."Invoice Def. Gen. Jnl. Batch");
                if GenJnlLine.FindSet()then GenJnlLine.deleteall;
                LineNo:=0;
                LineNo:=LineNo + 10000;
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name":=DNVSetup."Invoice Def. Gen. Jnl.Template";
                GenJnlLine."Journal Batch Name":=DNVSetup."Invoice Def. Gen. Jnl. Batch";
                //GenJnlLine.Validate("Document No.", NoSeries.GetNextNo(GenTemp."No. Series"));
                GenJnlLine.Validate("Document No.", format(Rec."Entry No."));
                DocNo:=GenJnlLine."Document No.";
                GenJnlLine."Line No.":=LineNo;
                GenJnlLine.Validate("Posting Date", Rec."Approved At");
                GenJnlLine."Document Date":=Rec."Invoice Date";
                GenJnlLine.validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
                GenJnlLine.Validate("Account No.", CurrentaccountNo);
                GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                GenJnlLine.Validate("Bal. Account No.", GlAccountNo);
                //if GlSetup."LCY Code" <> Rec."Currency Code" then   //Sgarg- removed condition - 24jan25
                GenJnlLine.Validate("Currency Code", rec."Currency Code");
                GenJnlLine.Validate(Amount, -1 * InvoiceAmount);
                GenJnlLine.Validate("Shortcut Dimension 1 Code", vmt.SEGMENT);
                GenJnlLine.Validate("Shortcut Dimension 2 Code", 'DINVO');
                GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyMapping."PB Company Code");
                GenJnlLine.Validate("Shortcut Dimension 9 Code", DNVSetup."Invoice Countrt Party Type"); // take fro msetup
                GenJnlLine.Validate("Shortcut Dimension 10 Code", VMTShipCode.VESSELCODE);
                GenJnlLine."Ship Manager Id":=rec."Ship Manager";
                GenJnlLine."DNV Staging Entry No.":=rec."Entry No.";
                GenJnlLine."Invoice Link":='DNV INV';
                GenJnlLine."PB DNV invoice":=true;
                GenJnlLine."Original Invoice No":=rec."Original Invoice No";
                GenJnlLine."External Document No.":=rec.Code;
                GenJnlLine.Description:=format(VMTShipCode.SHIPSIGN) + '  ' + GlDescription;
                //if InvoiceAmount < 0 then
                //  GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo"
                //else
                //  GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice;
                GenJnlLine."Auto Post":=true;
                GenJnlLine.Insert(true);
                // Dry Dock Handling
                DryDockGL.Reset();
                DryDockGL.SetRange("GL Account From", GlAccountNo);
                if DryDockGL.FindSet()then begin
                    GenJnLLine2.Reset();
                    LineNo:=LineNo + 10000;
                    GenJnLLine2.Init();
                    GenJnLLine2.TransferFields(GenJnlLine);
                    DocNo:=GenJnlLine."Document No.";
                    GenJnLLine2."Line No.":=LineNo;
                    GenJnLLine2.Validate("Account No.", DryDockGL."GL Account To");
                    GenJnLLine2.Validate(Amount, -1 * GenJnLLine.Amount);
                    GenJnlLine2.Validate("Currency Code", GenJnlLine."Currency Code");
                    GenJnlLine2.Validate("Shortcut Dimension 1 Code", vmt.SEGMENT);
                    GenJnlLine2.Validate("Shortcut Dimension 2 Code", 'TETRA');
                    GenJnlLine2.Validate("Shortcut Dimension 8 Code", CompanyMapping."PB Company Code");
                    GenJnlLine2.Validate("Shortcut Dimension 9 Code", DNVSetup."Invoice Countrt Party Type"); // take fro msetup
                    GenJnlLine2.Validate("Shortcut Dimension 10 Code", VMTShipCode.VESSELCODE);
                    GenJnlLine2."Ship Manager Id":=rec."Ship Manager";
                    GenJnlLine2."External Document No.":=rec.Code;
                    GenJnLLine2."Invoice Link":='DNV INV';
                    GenJnLLine2."DNV Staging Entry No.":=rec."Entry No.";
                    GenJnlLine2.Description:=format(VMTShipCode.SHIPSIGN) + '-' + GlDescription;
                    GenJnlLine."Auto Post":=true;
                    GenJnLLine2.Insert();
                end;
                //                rec."Posted Document No Shp Company" := GenJnlLine."Document No.";
                GenJnlLine.Reset();
                GenJnlLine.setrange("Journal Template Name", DNVSetup."Invoice Def. Gen. Jnl.Template");
                GenJnlLine.setrange("Journal Batch Name", DNVSetup."Invoice Def. Gen. Jnl. Batch");
                GenJnlLine.SetRange("Document No.", DocNo);
                GenJnlLine.FindSet();
                //repeat
                //  mEntryNo := GenJnlPostLine.RunWithCheck(GenJnlLine);
                //until GenJnlLine.Next() = 0;
                //if mEntryNo <> 0 then
                //  GLEntry.get(mEntryNo);
                //rec."Posted Document No Shp Company" := GLEntry."Document No.";
                CUPostGenJnl.Run(GenJnlLine);
                rec.Modify();
            end;
        end;
    end;
}
