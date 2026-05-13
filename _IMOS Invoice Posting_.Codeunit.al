codeunit 50174 "IMOS Invoice Posting"
{
    TableNo = "IMOS Invoice Staging Table";

    trigger OnRun()
    var
        //PbPurcchInv: Record "PB Purchase Invoice Inbound";
        VMT: record VMT;
        IMOSInvLine: record "IMOS Invoice Line";
        CompanyMapping: record "Company Name Mapping";
        GenJnlLine: record "Gen. Journal Line";
        Vendor: Record Vendor;
        Customer: record Customer;
        LineNo: Integer;
        InvoiceAmount: Decimal;
        VMTShipCode: record VMT;
        NoSeries: Codeunit "No. Series";
        GenTemp: Record "Gen. Journal Template";
        GlDescription: Text;
        GenJnLLine2: record "Gen. Journal Line";
        TemplateCode: Code[10];
        BatchCode: code[10];
        DocumentNo: code[20];
        GlSetup: record "General Ledger Setup";
        VendorTypeMapping: Record "Vendor Type Mapping";
        mVendorNo: Code[20];
        mVendorType: Code[20];
        mStrpos: Integer;
        ELE: Record "Employee Ledger Entry";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        mEntryNo: Integer;
        GLEntry: record "G/L Entry";
        InvAmountLCY: Decimal;
        IsCustomerTransaction: Boolean;
        IsVendorTransaction: Boolean;
        IsGlTransaction: Boolean;
        JnlPostBatch: Codeunit 50190;
        IMOSSetup: record "IMOS Setup";
        VesselTypeMapping: Record "IMOS Vessel type FD1 Linkage";
    begin
        GlSetup.get;
        IMOSSetup.Get();
        GLEntry.Reset();
        GLEntry.SetCurrentKey("IMOS Transaction No");
        GLEntry.SetRange("IMOS Transaction No", Rec.transNo);
        GLEntry.SetRange(Reversed, false);
        if GLEntry.FindSet()then Error('Duplicate Transaction No');
        GLEntry.Reset();
        CompanyMapping.get(CompanyName);
        rec.TestField(oprBillSource);
        TemplateCode:='I' + Rec.oprBillSource;
        BatchCode:='Default';
        //         //CompanyMapping.get(rec."Ship Sign Company No");
        CompanyMapping.get(CompanyName);
        GenTemp.get(TemplateCode);
        //         //GlDescription := rec."Order Code";
        if rec.transType = 1 then begin
            mVendorNo:='';
            mVendorType:='';
            mStrpos:=StrPos(rec.vendorExternalRef, '_');
            if mStrpos > 0 then begin
                mVendorNo:=CopyStr(rec.vendorExternalRef, 1, mStrpos - 1);
                mVendorType:=CopyStr(rec.vendorExternalRef, mStrpos + 1);
            end;
            if(mVendorNo = '') or (mVendorType = '')then Error('Invalid vendor No or Vendor Type');
            Vendor.Reset();
            if not Vendor.get(mVendorNo)then begin
                VendorTypeMapping.Reset();
                VendorTypeMapping.Setfilter("IMOS Company No", format(Rec.vendorNo));
                VendorTypeMapping.FindSet();
                Vendor.Reset();
                Vendor.get(VendorTypeMapping."Vendor/Customer No.");
            end;
        end
        else if Rec.transType = 2 then begin
                mVendorNo:='';
                mVendorType:='';
                mStrpos:=StrPos(rec.vendorExternalRef, '_');
                if mStrpos > 0 then begin
                    mVendorNo:=CopyStr(rec.vendorExternalRef, 1, mStrpos - 1);
                    mVendorType:=CopyStr(rec.vendorExternalRef, mStrpos + 1);
                end;
                if(mVendorNo = '') or (mVendorType = '')then Error('Invalid vendor No or Vendor Type');
                Customer.Reset();
                if not Customer.get(mVendorNo)then begin
                    VendorTypeMapping.Reset();
                    VendorTypeMapping.Setfilter("IMOS Company No", format(Rec.vendorNo));
                    VendorTypeMapping.FindSet();
                    Customer.Reset();
                    Customer.get(VendorTypeMapping."Vendor/Customer No.");
                end;
            end;
        CompanyMapping.Get(CompanyName);
        VMT.Reset();
        vmt.SetRange(DBASE, CompanyMapping."PB Company Code");
        VMT.FindSet();
        InvoiceAmount:=0;
        InvAmountLCY:=0;
        DocumentNo:='';
        //        DocumentNo := NoSeries.GetNextNo(GenTemp."No. Series");
        DocumentNo:=Format(rec."Entry No.");
        IMOSInvLine.Reset();
        IMOSInvLine.SetRange("Invoice Entry No.", rec."Entry No.");
        //        IMOSInvLine.SetFilter(currencyAmount, '<>%1', 0);
        IMOSInvLine.FindSet();
        GenJnlLine.Reset();
        GenJnlLine.setrange("Journal Template Name", TemplateCode);
        GenJnlLine.setrange("Journal Batch Name", BatchCode);
        if GenJnlLine.Findset then GenJnlLine.DeleteAll();
        LineNo:=0;
        repeat IsCustomerTransaction:=false;
            IsVendorTransaction:=false;
            IsGlTransaction:=false;
            Vendor.Reset();
            if(rec.transType = 5)then begin
                if(IMOSInvLine.deptCode = 'AP') or (IMOSInvLine.deptCode = 'AR')then begin
                    IsVendorTransaction:=true;
                    mVendorNo:='';
                    mVendorType:='';
                    mStrpos:=StrPos(IMOSInvLine.vendorExternalRef, '_');
                    if mStrpos > 0 then begin
                        mVendorNo:=CopyStr(IMOSInvLine.vendorExternalRef, 1, mStrpos - 1);
                        mVendorType:=CopyStr(IMOSInvLine.vendorExternalRef, mStrpos + 1);
                    end;
                    if(mVendorNo = '') or (mVendorType = '')then Error('Invalid vendor No or Vendor Type');
                    Vendor.Reset();
                    if Vendor.get(mVendorNo)then begin
                        IsVendorTransaction:=true;
                    end
                    else
                    begin
                        Customer.get(mVendorNo);
                        IsCustomerTransaction:=true;
                    end;
                end
                else
                    IsGlTransaction:=true;
            end
            else
                IsGlTransaction:=true;
            if rec.transType <> 2 then begin
                InvoiceAmount:=InvoiceAmount + IMOSInvLine.currencyAmount;
                InvAmountLCY:=InvAmountLCY + IMOSInvLine.baseCurrencyAmount;
            end
            else
            begin
                InvoiceAmount:=InvoiceAmount + (IMOSInvLine.currencyAmount);
                InvAmountLCY:=InvAmountLCY + (IMOSInvLine.baseCurrencyAmount);
            end;
            LineNo:=LineNo + 10000;
            GenJnlLine.Init();
            GenJnlLine."Journal Template Name":=TemplateCode;
            GenJnlLine."Journal Batch Name":=BatchCode;
            GenJnlLine.Validate("Document No.", DocumentNo);
            GenJnLLine.Validate("Posting Date", rec.actDate);
            GenJnlLine.Validate("Document Date", rec.invoiceDate);
            GenJnlLine."Line No.":=LineNo;
            if IsGlTransaction then begin
                GenJnlLine.validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
                GenJnlLine.Validate("Account No.", IMOSInvLine.ledgerCode);
            end
            else if IsCustomerTransaction then begin
                    GenJnlLine.validate("Account Type", GenJnlLine."Account Type"::Customer);
                    GenJnlLine.Validate("Account No.", Customer."No.");
                end
                else if IsVendorTransaction then begin
                        GenJnlLine.validate("Account Type", GenJnlLine."Account Type"::Vendor);
                        GenJnlLine.Validate("Account No.", Vendor."No.");
                    end;
            if IMOSInvLine.currencyAmount <> 0 then begin
                GenJnlLine.Validate("Currency Code", IMOSInvLine.currency); //             //if GlSetup."LCY Code" <> Rec."Currency Code" then
                if rec.transType <> 2 then begin
                    GenJnlLine.Validate(Amount, IMOSInvLine.currencyAmount);
                    GenJnlLine.Validate("Amount (LCY)", IMOSInvLine.baseCurrencyAmount);
                end
                else
                begin
                    GenJnlLine.Validate(Amount, -1 * IMOSInvLine.currencyAmount);
                    GenJnlLine.Validate("Amount (LCY)", -1 * IMOSInvLine.baseCurrencyAmount)end;
            end
            else
            begin
                GenJnlLine.Validate("Currency Code", GlSetup."LCY Code"); //             //if GlSetup."LCY Code" <> Rec."Currency Code" then
                if rec.transType <> 2 then begin
                    GenJnlLine.Validate(Amount, IMOSInvLine.baseCurrencyAmount);
                    GenJnlLine.Validate("Amount (LCY)", IMOSInvLine.baseCurrencyAmount);
                end
                else
                begin
                    //GenJnlLine.Validate(Amount, -1 * IMOSInvLine.currencyAmount);
                    GenJnlLine.Validate("Amount", -1 * IMOSInvLine.baseCurrencyAmount);
                    GenJnlLine.Validate("Amount (LCY)", -1 * IMOSInvLine.baseCurrencyAmount)end;
            end;
            if not VMT."Use FD1 Mapping" then GenJnlLine.Validate("Shortcut Dimension 1 Code", vmt.SEGMENT)
            else
            begin
                VesselTypeMapping.Reset();
                VesselTypeMapping.Get(IMOSInvLine.vesselType);
                GenJnlLine.Validate("Shortcut Dimension 1 Code", VesselTypeMapping."FD1 Dimension Value");
            end;
            GenJnlLine.Validate("Shortcut Dimension 10 Code", IMOSInvLine.vesselCode);
            GenJnlLine.Validate("Shortcut Dimension 3 Code", format(IMOSInvLine.voyageNo));
            if Rec.tcCode = '' then GenJnlLine.Validate("Shortcut Dimension 4 Code", format(IMOSInvLine.voyageTCICode))
            else
                GenJnlLine.Validate("Shortcut Dimension 4 Code", rec.tcCode);
            if GenJnlLine."Shortcut Dimension 4 Code" = '' then GenJnlLine.Validate("Shortcut Dimension 4 Code", IMOSSetup."FD4 Default VAlue");
            GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyMapping."PB Company Code");
            if rec.transType <> 5 then GenJnlLine.Validate("Shortcut Dimension 9 Code", IMOSInvLine.vendorType);
            if GenJnlLine."Shortcut Dimension 9 Code" = '' then begin
                if(rec.oprBillSource = 'TCIP') or (rec.oprBillSource = 'MACR') or (rec.oprBillSource = 'XJOU') or (rec.oprBillSource = 'VCST')then GenJnlLine.Validate("Shortcut Dimension 9 Code", IMOSSetup."FD9 Default Value");
            end;
            GenJnlLine.Validate("Shortcut Dimension 2 Code", TemplateCode);
            GenJnlLine.Description:=copystr(IMOSInvLine.description, 1, 100);
            GenJnlLine."Invoice Link":='IMOS INV'; //             //GenJnlLine."Ship Manager Id" := rec."Ship Manager";
            GenJnlLine."External Document No.":=rec.invoiceNo;
            GenJnlLine."IMOS invoice":=true;
            GenJnlLine."IMOS Transaction No":=IMOSInvLine.transNo;
            GenJnlLine."Remittance Company No":=format(rec.remittanceCompNo);
            GenJnlLine."Remittance Account No":=rec.remittanceAccountNo;
            GenJnlLine."Remittance Full Name":=rec.remittanceFullName;
            GenJnlLine."Original Invoice No":=rec.invoiceNo;
            GenJnlLine.Validate("Due Date", Rec.dueDate);
            GenJnlLine."Auto Post":=true;
            //             if InvoiceAmount < 0 then
            //                 GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo"
            //             else
            //                 GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice;
            GenJnlLine.Insert(true);
        until IMOSInvLine.Next() = 0;
        //if InvoiceAmount = 0 then Error('Data is not valid');
        if InvoiceAmount <> 0 then begin
            LineNo:=LineNo + 10000;
            GenJnlLine.Init();
            GenJnlLine."Journal Template Name":=TemplateCode;
            GenJnlLine."Journal Batch Name":=BatchCode;
            GenJnlLine.Validate("Document No.", DocumentNo);
            GenJnLLine.Validate("Posting Date", rec.actDate);
            GenJnlLine.Validate("Document Date", rec.invoiceDate);
            GenJnlLine."Line No.":=LineNo;
            if Rec.transType = 1 then begin
                GenJnlLine.validate("Account Type", GenJnlLine."Account Type"::Vendor);
                GenJnlLine.Validate("Account No.", Vendor."No.");
            end
            else if rec.transType = 2 then begin
                    GenJnlLine.validate("Account Type", GenJnlLine."Account Type"::Customer);
                    GenJnlLine.Validate("Account No.", Customer."No.");
                end;
            GenJnlLine.Validate("Currency Code", IMOSInvLine.currency);
            if Rec.transType <> 2 then begin
                GenJnlLine.Validate(Amount, -1 * InvoiceAmount);
                GenJnlLine.Validate("Amount (LCY)", -1 * InvAmountLCY);
            end
            else
            begin
                GenJnlLine.Validate(Amount, 1 * InvoiceAmount);
                GenJnlLine.Validate("Amount (LCY)", 1 * InvAmountLCY);
            end;
            if not VMT."Use FD1 Mapping" then GenJnlLine.Validate("Shortcut Dimension 1 Code", vmt.SEGMENT)
            else
            begin
                VesselTypeMapping.Reset();
                VesselTypeMapping.Get(IMOSInvLine.vesselType);
                GenJnlLine.Validate("Shortcut Dimension 1 Code", VesselTypeMapping."FD1 Dimension Value");
            end;
            GenJnlLine.Validate("Shortcut Dimension 10 Code", IMOSInvLine.vesselCode);
            GenJnlLine.Validate("Shortcut Dimension 3 Code", format(IMOSInvLine.voyageNo));
            if rec.tcCode = '' then GenJnlLine.Validate("Shortcut Dimension 4 Code", format(IMOSInvLine.voyageTCICode))
            else
                GenJnlLine.Validate("Shortcut Dimension 4 Code", format(rec.tcCode));
            if GenJnlLine."Shortcut Dimension 4 Code" = '' then GenJnlLine.Validate("Shortcut Dimension 4 Code", IMOSSetup."FD4 Default VAlue");
            GenJnlLine.Validate("Shortcut Dimension 8 Code", CompanyMapping."PB Company Code");
            if rec.transType <> 5 then GenJnlLine.Validate("Shortcut Dimension 9 Code", IMOSInvLine.vendorType);
            if GenJnlLine."Shortcut Dimension 9 Code" = '' then begin
                if(rec.oprBillSource = 'TCIP') or (rec.oprBillSource = 'MACR') or ((rec.oprBillSource = 'XJOU'))then GenJnlLine.Validate("Shortcut Dimension 9 Code", IMOSSetup."FD9 Default Value");
            end;
            GenJnlLine.Validate("Shortcut Dimension 2 Code", TemplateCode);
            GenJnlLine.Description:=Copystr(IMOSInvLine.description, 1, 100);
            //             //GenJnlLine."Ship Manager Id" := rec."Ship Manager";
            GenJnlLine."External Document No.":=rec.invoiceNo;
            GenJnlLine."Invoice Link":='IMOS INV';
            GenJnlLine."IMOS invoice":=true;
            GenJnlLine."IMOS Transaction No":=IMOSInvLine.transNo;
            GenJnlLine."Remittance Company No":=format(rec.remittanceCompNo);
            GenJnlLine."Remittance Account No":=rec.remittanceAccountNo;
            GenJnlLine."Remittance Full Name":=rec.remittanceFullName;
            GenJnlLine."Original Invoice No":=rec.invoiceNo;
            //             if InvoiceAmount < 0 then
            //                 GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo"
            //             else
            //                 GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice;
            GenJnlLine.Validate("Due Date", Rec.dueDate);
            GenJnlLine."Auto Post":=true;
            GenJnlLine.Insert(true);
        end;
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", TemplateCode);
        GenJnlLine.SetRange("Journal Batch Name", BatchCode);
        //GenJnlLine.SetRange("Document No.", DocumentNo);
        GenJnlLine.FindSet();
        JnlPostBatch.Run(GenJnlLine);
    //if not JnlPostBatch.Run(GenJnlLine) then begin
    //GLEntry.Reset();
    //GLEntry.SetRange("IMOS Transaction No", rec.transNo);
    //GLEntry.FindSet();
    //GLEntry.get(mEntryNo);
    // rec."Posted Document No" := GLEntry."Document No.";
    //end;
    //        rec."Posted Document No" := DocumentNo;
    //      repeat
    //            mEntryNo := GenJnlPostLine.RunWithCheck(GenJnlLine);
    //    until GenJnlLine.Next() = 0;
    end;
}
