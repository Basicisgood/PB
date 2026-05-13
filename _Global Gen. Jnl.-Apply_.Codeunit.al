codeunit 50156 "Global Gen. Jnl.-Apply"
{
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    var
        IsHandled: Boolean;
        ReviewGenJnl: codeunit "Review Gen Jnl";
    begin
        GenJnlLine.Copy(Rec);
        IsHandled:=false;
        OnBeforeRun(GenJnlLine, IsHandled);
        if IsHandled then exit;
        ReviewGenJnl.CheckOutboundIfAlreadyExist(GenJnlLine."Bank Document No."); //TEC.VJ 18MAR2025
        GetCurrency();
        if GenJnlLine."Bal. Account Type" in[GenJnlLine."Bal. Account Type"::Customer, GenJnlLine."Bal. Account Type"::Vendor, GenJnlLine."Bal. Account Type"::Employee]then begin
            AccType:=GenJnlLine."Bal. Account Type";
            AccNo:=GenJnlLine."Bal. Account No.";
        end
        else
        begin
            AccType:=GenJnlLine."Account Type";
            AccNo:=GenJnlLine."Account No.";
        end;
        case AccType of AccType::Customer: ApplyCustomerLedgerEntry(GenJnlLine);
        AccType::Vendor: ApplyVendorLedgerEntry(GenJnlLine);
        AccType::Employee: ApplyEmployeeLedgerEntry(GenJnlLine);
        else
            Error(Text005, GenJnlLine.FieldCaption("Account Type"), GenJnlLine.FieldCaption("Bal. Account Type"));
        end;
        OnAfterRun(GenJnlLine);
        Rec:=GenJnlLine;
    end;
    var GenJnlLine: Record "Gen. Journal Line";
    GLSetup: Record "General Ledger Setup";
    Currency: Record Currency;
    CurrExchRate: Record "Currency Exchange Rate";
    PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
    AccNo: Code[20];
    CurrencyCode2: Code[10];
    EntrySelected: Boolean;
    AccType: Enum "Gen. Journal Account Type";
    Text000: Label 'You must specify %1 or %2.';
    ConfirmChangeQst: Label 'CurrencyCode in the %1 will be changed from %2 to %3.\Do you wish to continue?', Comment = '%1 = Table Name, %2 and %3 = Currency Code';
    UpdateInterruptedErr: Label 'The update has been interrupted to respect the warning.';
    Text005: Label 'The %1 or %2 must be Customer or Vendor.';
    Text006: Label 'All entries in one application must be in the same currency.';
    Text007: Label 'All entries in one application must be in the same currency or one or more of the EMU currencies. ';
    EarlierPostingDateErr: Label 'You cannot apply and post an entry to an entry with an earlier posting date. Instead, post the document of type %1 with the number %2 and then apply it to the document of type %3 with the number %4.', Comment = '%1 = Applying document type, %2 = Applying document number, %3 = Entry document type, %4 = Entry document number';
    local procedure SelectCustLedgEntry(var GenJnlLine: Record "Gen. Journal Line"; var CustomAppliesToId: Code[50])Selected: Boolean var
        CustLedgEntry: Record "Global Cust. Ledger entry";
        ApplyCustEntries: Page "Global Apply Customer Entries";
        PreviousAppliesToID: Code[50];
        IsHandled: Boolean;
    begin
        IsHandled:=false;
        OnBeforeSelectCustLedgEntry(GenJnlLine, AccNo, Selected, IsHandled, CustomAppliesToId);
        if IsHandled then exit(Selected);
        CustLedgEntry.SetCurrentKey("Customer No.", Open, Positive);
        CustLedgEntry.SetRange("Customer No.", AccNo);
        CustLedgEntry.SetRange(Open, true);
        OnSelectCustLedgEntryOnAfterSetFilters(CustLedgEntry, GenJnlLine);
        PreviousAppliesToID:=GenJnlLine."Applies-to ID"; //27DEC2024
        if GenJnlLine."Applies-to ID" = '' then GenJnlLine."Applies-to ID":=GenJnlLine."Document No.";
        if GenJnlLine."Applies-to ID" = '' then Error(Text000, GenJnlLine.FieldCaption("Document No."), GenJnlLine.FieldCaption("Applies-to ID"));
        ApplyCustEntries.SetGenJnlLine(GenJnlLine, GenJnlLine.FieldNo("Applies-to ID"));
        ApplyCustEntries.SetRecord(CustLedgEntry);
        ApplyCustEntries.SetTableView(CustLedgEntry);
        ApplyCustEntries.LookupMode(true);
        Selected:=ApplyCustEntries.RunModal() = ACTION::LookupOK;
        if not Selected then //27DEC2024
 GenJnlLine."Applies-to ID":=PreviousAppliesToID;
        CustomAppliesToId:=ApplyCustEntries.GetCustomAppliesToID(); //TEC.VJ
        Clear(ApplyCustEntries);
        OnAfterSelectCustLedgEntry(GenJnlLine, AccNo, Selected);
    end;
    local procedure SelectVendLedgEntry(var GenJnlLine: Record "Gen. Journal Line"; var CustomAppliesToId: Code[50])Selected: Boolean var
        VendLedgEntry: Record "Global Vendor Ledger Entry";
        ApplyVendEntries: Page "Global Apply Vendor Entries";
        IsHandled: Boolean;
        RecCompMapping: Record "Company Name Mapping";
    begin
        IsHandled:=false;
        OnBeforeSelectVendLedgEntry(GenJnlLine, AccNo, Selected, IsHandled, CustomAppliesToId);
        if IsHandled then exit(Selected);
        RecCompMapping.GET(CompanyName); //TEC-Sgarg- Added
        VendLedgEntry.SetCurrentKey("Vendor No.", Open, Positive);
        VendLedgEntry.SetRange("Vendor No.", AccNo);
        VendLedgEntry.SetRange(Open, true);
        VendLedgEntry.FilterGroup(2); //SGarg-Added
        //TEC-Sgarg- Code - Added >>
        IF RecCompMapping."Central payment company" <> '' then VendLedgEntry.SetFilter("Company Name", RecCompMapping."Central payment company")
        else
            VendLedgEntry.Setrange("Company Name", CompanyName);
        //TEC-Sgarg- Code - Added <<
        VendLedgEntry.FilterGroup(0); //SGarg-Added
        OnSelectVendLedgEntryOnAfterSetFilters(VendLedgEntry, GenJnlLine);
        if GenJnlLine."Applies-to ID" = '' then GenJnlLine."Applies-to ID":=GenJnlLine."Document No.";
        if GenJnlLine."Applies-to ID" = '' then Error(Text000, GenJnlLine.FieldCaption("Document No."), GenJnlLine.FieldCaption("Applies-to ID"));
        ApplyVendEntries.SetGenJnlLine(GenJnlLine, GenJnlLine.FieldNo("Applies-to ID"));
        ApplyVendEntries.SetRecord(VendLedgEntry);
        ApplyVendEntries.SetTableView(VendLedgEntry);
        ApplyVendEntries.LookupMode(true);
        Selected:=ApplyVendEntries.RunModal() = ACTION::LookupOK;
        CustomAppliesToId:=ApplyVendEntries.GetCustomAppliesToID();
        Clear(ApplyVendEntries);
        OnAfterSelectVendLedgEntry(GenJnlLine, AccNo, Selected);
    end;
    local procedure SelectEmplLedgEntry(var GenJnlLine: Record "Gen. Journal Line"; var CustomAppliesToId: Code[50])Selected: Boolean var
        EmplLedgEntry: Record "Global Employee Ledger Entry";
        ApplyEmplEntries: Page "Global Apply Employee Entries";
        IsHandled: Boolean;
        RecCompMapping: Record "Company Name Mapping";
    begin
        IsHandled:=false;
        OnBeforeSelectEmplLedgEntry(GenJnlLine, AccNo, Selected, IsHandled);
        if IsHandled then exit(Selected);
        RecCompMapping.GET(CompanyName); //TEC-Sgarg- Added
        EmplLedgEntry.SetCurrentKey("Employee No.", Open, Positive);
        EmplLedgEntry.SetRange("Employee No.", AccNo);
        EmplLedgEntry.SetRange(Open, true);
        //TEC-Sgarg- Code - Added >>
        EmplLedgEntry.FilterGroup(2);
        IF RecCompMapping."Central payment company" <> '' then EmplLedgEntry.SetFilter("Company Code", RecCompMapping."Central payment company")
        else
            EmplLedgEntry.Setrange("Company Code", CompanyName);
        EmplLedgEntry.FilterGroup(0);
        //TEC-Sgarg- Code - Added <<
        // OnSelectEmplLedgEntryOnAfterSetFilters(EmplLedgEntry, GenJnlLine);
        if GenJnlLine."Applies-to ID" = '' then GenJnlLine."Applies-to ID":=GenJnlLine."Document No.";
        if GenJnlLine."Applies-to ID" = '' then Error(Text000, GenJnlLine.FieldCaption("Document No."), GenJnlLine.FieldCaption("Applies-to ID"));
        ApplyEmplEntries.SetGenJnlLine(GenJnlLine, GenJnlLine.FieldNo("Applies-to ID"));
        ApplyEmplEntries.SetRecord(EmplLedgEntry);
        ApplyEmplEntries.SetTableView(EmplLedgEntry);
        ApplyEmplEntries.LookupMode(true);
        Selected:=ApplyEmplEntries.RunModal() = ACTION::LookupOK;
        CustomAppliesToId:=ApplyEmplEntries.GetCustomAppliesToID(); //TEC.VJ 27DEC2024
        Clear(ApplyEmplEntries);
        OnAfterSelectEmplLedgEntry(GenJnlLine, AccNo, Selected);
    end;
    local procedure UpdateCustLedgEntry(var CustLedgEntry: Record "Global Cust. Ledger entry")
    var
        IsHandled: Boolean;
    begin
        IsHandled:=false;
        OnBeforeUpdateCustLedgEntry(CustLedgEntry, GenJnlLine, IsHandled);
        if IsHandled then exit;
        CustLedgEntry.CalcFields("Remaining Amount");
        CustLedgEntry."Remaining Amount":=CurrExchRate.ExchangeAmount(CustLedgEntry."Remaining Amount", CustLedgEntry."Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
        CustLedgEntry."Remaining Amount":=Round(CustLedgEntry."Remaining Amount", Currency."Amount Rounding Precision");
        CustLedgEntry."Remaining Pmt. Disc. Possible":=CurrExchRate.ExchangeAmount(CustLedgEntry."Remaining Pmt. Disc. Possible", CustLedgEntry."Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
        CustLedgEntry."Remaining Pmt. Disc. Possible":=Round(CustLedgEntry."Remaining Pmt. Disc. Possible", Currency."Amount Rounding Precision");
        CustLedgEntry."Amount to Apply":=CurrExchRate.ExchangeAmount(CustLedgEntry."Amount to Apply", CustLedgEntry."Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
        CustLedgEntry."Amount to Apply":=Round(CustLedgEntry."Amount to Apply", Currency."Amount Rounding Precision");
    end;
    local procedure UpdateVendLedgEntry(var VendLedgEntry: Record "Global Vendor Ledger Entry")
    var
        IsHandled: Boolean;
    begin
        IsHandled:=false;
        OnBeforeUpdateVendLedgEntry(VendLedgEntry, GenJnlLine, IsHandled);
        if IsHandled then exit;
        VendLedgEntry.CalcFields("Remaining Amount");
        VendLedgEntry."Remaining Amount":=CurrExchRate.ExchangeAmount(VendLedgEntry."Remaining Amount", VendLedgEntry."Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
        VendLedgEntry."Remaining Amount":=Round(VendLedgEntry."Remaining Amount", Currency."Amount Rounding Precision");
        VendLedgEntry."Remaining Pmt. Disc. Possible":=CurrExchRate.ExchangeAmount(VendLedgEntry."Remaining Pmt. Disc. Possible", VendLedgEntry."Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
        VendLedgEntry."Remaining Pmt. Disc. Possible":=Round(VendLedgEntry."Remaining Pmt. Disc. Possible", Currency."Amount Rounding Precision");
        VendLedgEntry."Amount to Apply":=CurrExchRate.ExchangeAmount(VendLedgEntry."Amount to Apply", VendLedgEntry."Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
        VendLedgEntry."Amount to Apply":=Round(VendLedgEntry."Amount to Apply", Currency."Amount Rounding Precision");
        OnAfterUpdateVendLedgEntry(GenJnlLine, VendLedgEntry);
    end;
    local procedure UpdateEmployeeLedgEntry(var EmplLedgEntry: Record "Global Employee Ledger Entry")
    begin
        EmplLedgEntry.CalcFields("Remaining Amount");
        EmplLedgEntry."Remaining Amount":=CurrExchRate.ExchangeAmount(EmplLedgEntry."Remaining Amount", EmplLedgEntry."Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
        EmplLedgEntry."Remaining Amount":=Round(EmplLedgEntry."Remaining Amount", Currency."Amount Rounding Precision");
        EmplLedgEntry."Amount to Apply":=CurrExchRate.ExchangeAmount(EmplLedgEntry."Amount to Apply", EmplLedgEntry."Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
        EmplLedgEntry."Amount to Apply":=Round(EmplLedgEntry."Amount to Apply", Currency."Amount Rounding Precision");
    end;
    procedure CheckAgainstApplnCurrency(ApplnCurrencyCode: Code[10]; CompareCurrencyCode: Code[10]; AccType: Enum "Gen. Journal Account Type"; Message: Boolean): Boolean var
        Currency: Record Currency;
        Currency2: Record Currency;
        SalesSetup: Record "Sales & Receivables Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        CurrencyAppln: Option No, EMU, All;
    begin
        OnBeforeCheckAgainstApplnCurrency(ApplnCurrencyCode, CompareCurrencyCode);
        if ApplnCurrencyCode = CompareCurrencyCode then exit(true);
        case AccType of AccType::Customer: begin
            SalesSetup.Get();
            CurrencyAppln:=SalesSetup."Appln. between Currencies";
            case CurrencyAppln of CurrencyAppln::No: if ApplnCurrencyCode <> CompareCurrencyCode then if Message then Error(Text006)
                    else
                        exit(false);
            CurrencyAppln::EMU: begin
                GLSetup.Get();
                if not Currency.Get(ApplnCurrencyCode)then Currency."EMU Currency":=GLSetup."EMU Currency";
                if not Currency2.Get(CompareCurrencyCode)then Currency2."EMU Currency":=GLSetup."EMU Currency";
                if not Currency."EMU Currency" or not Currency2."EMU Currency" then if Message then Error(Text007)
                    else
                        exit(false);
            end;
            end;
        end;
        AccType::Vendor: begin
            PurchSetup.Get();
            CurrencyAppln:=PurchSetup."Appln. between Currencies";
            case CurrencyAppln of CurrencyAppln::No: if ApplnCurrencyCode <> CompareCurrencyCode then if Message then Error(Text006)
                    else
                        exit(false);
            CurrencyAppln::EMU: begin
                GLSetup.Get();
                if not Currency.Get(ApplnCurrencyCode)then Currency."EMU Currency":=GLSetup."EMU Currency";
                if not Currency2.Get(CompareCurrencyCode)then Currency2."EMU Currency":=GLSetup."EMU Currency";
                if not Currency."EMU Currency" or not Currency2."EMU Currency" then if Message then Error(Text007)
                    else
                        exit(false);
            end;
            end;
        end;
        end;
        exit(true);
    end;
    local procedure GetCurrency()
    begin
        if GenJnlLine."Currency Code" = '' then Currency.InitRoundingPrecision()
        else
        begin
            Currency.Get(GenJnlLine."Currency Code");
            Currency.TestField("Amount Rounding Precision");
        end;
    end;
    local procedure ApplyCustomerLedgerEntry(var GenJnlLine: Record "Gen. Journal Line")
    var
        CustLedgEntry: Record "Global Cust. Ledger entry";
        TempCustLedgEntry: Record "Global Cust. Ledger entry" temporary;
        AppliedAmount: Decimal;
        CustomAppliesToId: Code[50];
        IsHandled: Boolean;
        BankCharges: Decimal;
        IMOSSetup: Record "IMOS Setup";
        GenJnlLine2: Record "Gen. Journal Line";
    begin
        IMOSSetup.Get();
        GetAppliedCustomerEntries(TempCustLedgEntry, GenJnlLine);
        EntrySelected:=SelectCustLedgEntry(GenJnlLine, CustomAppliesToId);
        if not EntrySelected then exit;
        CustLedgEntry.Reset();
        CustLedgEntry.SetCurrentKey("Customer No.", Open, Positive);
        CustLedgEntry.SetRange("Customer No.", AccNo);
        CustLedgEntry.SetRange(Open, true);
        CustLedgEntry.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");
        CustLedgEntry.SetRange("Bank Document No. Applied", GenJnlLine."Bank Document No."); //TEC.VJ 06MAR2025
        OnAfterCustLedgEntrySetFilters(CustLedgEntry, GenJnlLine, AccNo);
        if CustLedgEntry.Find('-')then begin
            CurrencyCode2:=CustLedgEntry."Currency Code";
            if GenJnlLine.Amount = 0 then begin
                repeat BankCharges:=BankCharges + CustLedgEntry."Bank Charges Amount";
                    if not TempCustLedgEntry.Get(CustLedgEntry."Entry No.")then begin
                        DelPmtTolApllnDocNo(GenJnlLine, CustLedgEntry."Document No.");
                        OnApplyCustomerLedgerEntryOnBeforeCheckAgainstApplnCurrency(GenJnlLine, CustLedgEntry);
                        CheckAgainstApplnCurrency(CurrencyCode2, CustLedgEntry."Currency Code", AccType::Customer, true);
                        UpdateCustLedgEntry(CustLedgEntry);
                        IsHandled:=false;
                        OnBeforeFindCustApply(GenJnlLine, CustLedgEntry, GenJnlLine.Amount, IsHandled);
                        if not IsHandled then //pending
 //     if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(GenJnlLine, CustLedgEntry, 0, false) and
                            //       (Abs(CustLedgEntry."Amount to Apply") >=
                            //        Abs(CustLedgEntry."Remaining Amount" - CustLedgEntry.GetRemainingPmtDiscPossible(GenJnlLine."Posting Date")))
                            //    then
                            //         GenJnlLine.Amount := GenJnlLine.Amount - (CustLedgEntry."Amount to Apply" - CustLedgEntry.GetRemainingPmtDiscPossible(GenJnlLine."Posting Date"))
                            //     else
                            if CustLedgEntry."Document Type" <> CustLedgEntry."Document Type"::Payment then GenJnlLine.Amount:=GenJnlLine.Amount - CustLedgEntry."Amount to Apply" - CustLedgEntry."Over Receipt Amount"
                            else
                                GenJnlLine.Amount:=GenJnlLine.Amount - CustLedgEntry."Amount to Apply";
                    end
                    else
                        GetAppliedAmountOnCustLedgerEntry(TempCustLedgEntry, AppliedAmount);
                until CustLedgEntry.Next() = 0;
                TempCustLedgEntry.DeleteAll();
                if AppliedAmount <> 0 then GenJnlLine.Amount+=AppliedAmount;
                if(GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Customer) or (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor)then GenJnlLine.Amount:=-GenJnlLine.Amount;
                GenJnlLine.Validate(Amount);
            end
            else
                repeat OnApplyCustomerLedgerEntryOnBeforeCheckAgainstApplnCurrencyCustomerAmountNotZero(GenJnlLine, CustLedgEntry);
                    CheckAgainstApplnCurrency(CurrencyCode2, CustLedgEntry."Currency Code", AccType::Customer, true);
                until CustLedgEntry.Next() = 0;
            if GenJnlLine."Currency Code" <> CurrencyCode2 then if GenJnlLine.Amount = 0 then begin
                    IsHandled:=false;
                    OnApplyCustomerLedgerEntryOnBeforeConfirmUpdateCurrency(GenJnlLine, CustLedgEntry."Currency Code", IsHandled);
                    if not IsHandled then begin
                        ConfirmCurrencyUpdate(GenJnlLine, CustLedgEntry."Currency Code");
                        GenJnlLine."Currency Code":=CustLedgEntry."Currency Code";
                    end;
                end
                else
                begin
                    OnApplyCustomerLedgerEntryOnBeforeCheckAgainstApplnCurrencyCustomer(GenJnlLine, CustLedgEntry);
                    CheckAgainstApplnCurrency(GenJnlLine."Currency Code", CustLedgEntry."Currency Code", AccType::Customer, true);
                end;
            GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::" ";
            GenJnlLine."Applies-to Doc. No.":='';
            OnApplyCustomerLedgerEntryOnAfterSetCustomerAppliesToDocNo(GenJnlLine, CustLedgEntry);
        end
        else
            GenJnlLine."Applies-to ID":='';
        if(GenJnlLine."Applies-to ID" = '') and (CustomAppliesToId <> '')then GenJnlLine."Applies-to ID":=CustomAppliesToId;
        GenJnlLine.SetJournalLineFieldsFromApplication();
        UpdateAppliedAmountForCustomer(GenJnlLine); //TEC.VJ 06MAR2025
        OnApplyCustomerLedgerEntryOnBeforeModify(GenJnlLine, CustLedgEntry);
        if GenJnlLine.Modify()then;
        //Bank Charges
        if BankCharges <> 0 then begin
            GenJnlLine2.Reset();
            GenJnlLine2.Init();
            GenJnlLine2.TransferFields(GenJnlLine);
            GenJnlLine2."Line No.":=GenJnlLine."Line No." + 1000;
            GenJnlLine2.Validate("Account Type", GenJnlLine2."Account Type"::"G/L Account");
            GenJnlLine2.Validate("Account No.", IMOSSetup."Bank Charge GL Code");
            GenJnlLine2.Validate("Currency Code", GenJnlLine."Currency Code");
            GenJnlLine2.Validate(Amount, BankCharges);
            if not GenJnlLine2.Insert(true)then GenJnlLine2.Modify();
        end;
        if GenJnlLine.Amount <> 0 then //if not PaymentToleranceMgt.PmtTolGenJnl(GenJnlLine) then//VJ 19FEB2025
            exit;
    end;
    procedure SetVendApplIdAPI(GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Global Vendor Ledger Entry")
    var
        TempApplyingVendorLedgerEntry: Record "Global Vendor Ledger Entry" temporary;
        Vendor: Record Vendor;
        GenJnlApply: Codeunit "Gen. Jnl.-Apply";
        VendEntrySetApplID: Codeunit "Global Vend. Entry-SetAppl.ID";
        ApplnCurrencyCode: Code[10];
    begin
        if GenJournalLine."Applies-to ID" = '' then GenJournalLine."Applies-to ID":=GenJournalLine."Document No.";
        if GenJournalLine."Applies-to ID" = '' then Error(Text000, GenJournalLine.FieldCaption("Document No."), GenJournalLine.FieldCaption("Applies-to ID"));
        ApplnCurrencyCode:=GenJournalLine."Currency Code";
        TempApplyingVendorLedgerEntry."Posting Date":=GenJournalLine."Posting Date";
        TempApplyingVendorLedgerEntry."Document Type":=GenJournalLine."Document Type";
        TempApplyingVendorLedgerEntry."Document No.":=GenJournalLine."Document No.";
        if GenJournalLine."Bal. Account Type" = GenJournalLine."Bal. Account Type"::Vendor then begin
            TempApplyingVendorLedgerEntry."Vendor No.":=GenJournalLine."Bal. Account No.";
            Vendor.Get(TempApplyingVendorLedgerEntry."Vendor No.");
            TempApplyingVendorLedgerEntry.Description:=Vendor.Name;
        end
        else
        begin
            TempApplyingVendorLedgerEntry."Vendor No.":=GenJournalLine."Account No.";
            TempApplyingVendorLedgerEntry.Description:=GenJournalLine.Description;
        end;
        TempApplyingVendorLedgerEntry."Currency Code":=GenJournalLine."Currency Code";
        TempApplyingVendorLedgerEntry.Amount:=GenJournalLine.Amount;
        TempApplyingVendorLedgerEntry."Remaining Amount":=GenJournalLine.Amount;
        OnSetVendApplIdAPIOnBeforeCheckPostingDate(TempApplyingVendorLedgerEntry, GenJournalLine, VendorLedgerEntry);
        if TempApplyingVendorLedgerEntry."Posting Date" < VendorLedgerEntry."Posting Date" then Error(EarlierPostingDateErr, TempApplyingVendorLedgerEntry."Document Type", TempApplyingVendorLedgerEntry."Document No.", VendorLedgerEntry."Document Type", VendorLedgerEntry."Document No.");
        if TempApplyingVendorLedgerEntry."Entry No." <> 0 then begin
            OnSetVendApplIdAPIOnBeforeCheckAgainstApplnCurrency(GenJournalLine, VendorLedgerEntry);
            GenJnlApply.CheckAgainstApplnCurrency(ApplnCurrencyCode, VendorLedgerEntry."Currency Code", GenJournalLine."Account Type"::Vendor, true);
        end;
        VendorLedgerEntry.SetRange("Entry No.", VendorLedgerEntry."Entry No.");
        VendorLedgerEntry.SetRange("Vendor No.", VendorLedgerEntry."Vendor No.");
        VendEntrySetApplID.SetApplId(VendorLedgerEntry, TempApplyingVendorLedgerEntry, GenJournalLine."Applies-to ID", GenJnlLine."Bank Document No.");
    end;
    procedure ApplyVendorLedgerEntryAPI(var GenJournalLine: Record "Gen. Journal Line")
    var
        VendorLedgerEntry: Record "Global Vendor Ledger Entry";
        genjnl: Codeunit "Gen. Jnl.-Apply";
        TempVendorLedgerEntry: Record "Global Vendor Ledger Entry" temporary;
    begin
        GenJnlLine.Copy(GenJournalLine);
        GetCurrency();
        GenJnlLine.GetAccTypeAndNo(GenJnlLine, AccType, AccNo);
        GetAppliedVendorEntries(TempVendorLedgerEntry, GenJnlLine);
        GenJnlLine."Applies-to ID":=GenJnlLine."Document No.";
        VendorLedgerEntry.Reset();
        VendorLedgerEntry.SetCurrentKey("Vendor No.", Open, Positive);
        VendorLedgerEntry.SetRange("Vendor No.", AccNo);
        VendorLedgerEntry.SetRange(Open, true);
        VendorLedgerEntry.SetRange("Applies-to ID", GenJnlLine."Document No.");
        if VendorLedgerEntry.Find('-')then begin
            CurrencyCode2:=VendorLedgerEntry."Currency Code";
            if GenJnlLine.Amount = 0 then begin
                repeat if not TempVendorLedgerEntry.Get(VendorLedgerEntry."Entry No.")then begin
                        DelPmtTolApllnDocNo(GenJnlLine, VendorLedgerEntry."Document No.");
                        OnApplyVendorLedgerEntryAPIOnBeforeCheckAgainstApplnCurrencyAmountZero(GenJnlLine, VendorLedgerEntry);
                        CheckAgainstApplnCurrency(CurrencyCode2, VendorLedgerEntry."Currency Code", AccType::Vendor, true);
                        UpdateVendLedgEntry(VendorLedgerEntry);
                        //TEC.VJ COMMENTED
                        // if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(GenJnlLine, VendorLedgerEntry, 0, false) and
                        //    (Abs(VendorLedgerEntry."Amount to Apply") >=
                        //     Abs(VendorLedgerEntry."Remaining Amount" - VendorLedgerEntry.GetRemainingPmtDiscPossible(GenJnlLine."Posting Date")))
                        // then
                        //     GenJnlLine.Amount := GenJnlLine.Amount - (VendorLedgerEntry."Amount to Apply" - VendorLedgerEntry."Remaining Pmt. Disc. Possible")
                        // else
                        GenJnlLine.Amount:=GenJnlLine.Amount - VendorLedgerEntry."Amount to Apply";
                    end;
                until VendorLedgerEntry.Next() = 0;
                TempVendorLedgerEntry.DeleteAll();
                if(GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Customer) or (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor)then GenJnlLine.Amount:=-GenJnlLine.Amount;
                OnApplyVendorLedgerEntryAPIOnBeforeValidateAmount(GenJnlLine);
                GenJnlLine.Validate(Amount);
            end
            else
                repeat OnApplyVendorLedgerEntryAPIOnBeforeCheckAgainstApplnCurrencyAmountNonZero(GenJnlLine, VendorLedgerEntry);
                    CheckAgainstApplnCurrency(CurrencyCode2, VendorLedgerEntry."Currency Code", AccType::Vendor, true);
                until VendorLedgerEntry.Next() = 0;
            if GenJnlLine."Currency Code" <> CurrencyCode2 then if GenJnlLine.Amount = 0 then GenJnlLine."Currency Code":=VendorLedgerEntry."Currency Code"
                else
                begin
                    OnApplyVendorLedgerEntryAPIOnBeforeCheckAgainstApplnCurrencyDifferentCurrenciesAmountNonZero(GenJnlLine, VendorLedgerEntry);
                    CheckAgainstApplnCurrency(GenJnlLine."Currency Code", VendorLedgerEntry."Currency Code", AccType::Vendor, true);
                end;
            GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::" ";
            GenJnlLine."Applies-to Doc. No.":='';
            OnApplyVendorLedgerEntryOnAfterSetVendorAppliesToDocNo(GenJnlLine, VendorLedgerEntry);
        end
        else
            GenJnlLine."Applies-to ID":='';
        GenJnlLine.SetJournalLineFieldsFromApplication();
        if GenJnlLine.Modify()then;
        if GenJnlLine.Amount <> 0 then if not PaymentToleranceMgt.PmtTolGenJnl(GenJnlLine)then exit;
    end;
    procedure ApplyVendorLedgerEntry(var GenJnlLine: Record "Gen. Journal Line")
    var
        VendLedgEntry: Record "Global Vendor Ledger Entry";
        TempVendorLedgerEntry: Record "Global Vendor Ledger Entry" temporary;
        CustomAppliesToId: Code[50];
        IsHandled: Boolean;
    begin
        GetAppliedVendorEntries(TempVendorLedgerEntry, GenJnlLine);
        EntrySelected:=SelectVendLedgEntry(GenJnlLine, CustomAppliesToId);
        if not EntrySelected then exit;
        VendLedgEntry.Reset();
        VendLedgEntry.SetCurrentKey("Vendor No.", Open, Positive);
        VendLedgEntry.SetRange("Vendor No.", AccNo);
        VendLedgEntry.SetRange(Open, true);
        VendLedgEntry.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");
        VendLedgEntry.SetRange("Bank Document No. Applied", GenJnlLine."Bank Document No."); //VJ 13FEB2025
        OnAfterVendLedgEntrySetFilters(VendLedgEntry, GenJnlLine, AccNo);
        if VendLedgEntry.Find('-')then begin
            CurrencyCode2:=VendLedgEntry."Currency Code";
            if GenJnlLine.Amount = 0 then begin
                repeat if not TempVendorLedgerEntry.Get(VendLedgEntry."Entry No.")then begin
                        DelPmtTolApllnDocNo(GenJnlLine, VendLedgEntry."Document No.");
                        OnApplyVendorLedgerEntryOnBeforeCheckAgainstApplnCurrency(GenJnlLine, VendLedgEntry);
                        CheckAgainstApplnCurrency(CurrencyCode2, VendLedgEntry."Currency Code", AccType::Vendor, true);
                        UpdateVendLedgEntry(VendLedgEntry);
                        IsHandled:=false;
                        OnBeforeFindVendApply(GenJnlLine, VendLedgEntry, GenJnlLine.Amount, IsHandled);
                        if not IsHandled then //TEC.VJ COMMENTED
                            // if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(GenJnlLine, VendLedgEntry, 0, false) and
                            //    (Abs(VendLedgEntry."Amount to Apply") >=
                            //     Abs(VendLedgEntry."Remaining Amount" - VendLedgEntry.GetRemainingPmtDiscPossible(GenJnlLine."Posting Date")))
                            // then
                            //     GenJnlLine.Amount := GenJnlLine.Amount - (VendLedgEntry."Amount to Apply" - VendLedgEntry.GetRemainingPmtDiscPossible(GenJnlLine."Posting Date"))
                            // else
                            GenJnlLine.Amount:=GenJnlLine.Amount - VendLedgEntry."Amount to Apply";
                        GenJnlLine."Remit-to Code":=VendLedgEntry."Remit-to Code";
                    end;
                until VendLedgEntry.Next() = 0;
                TempVendorLedgerEntry.DeleteAll();
                if(GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Customer) or (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor)then GenJnlLine.Amount:=-GenJnlLine.Amount;
                OnApplyVendorLedgerEntryOnBeforeValidateAmount(GenJnlLine);
                GenJnlLine.Validate(Amount);
            end
            else
                repeat OnApplyVendorLedgerEntryOnBeforeCheckAgainstApplnCurrencyAmountNotZero(GenJnlLine, VendLedgEntry);
                    CheckAgainstApplnCurrency(CurrencyCode2, VendLedgEntry."Currency Code", AccType::Vendor, true);
                until VendLedgEntry.Next() = 0;
            if GenJnlLine."Currency Code" <> CurrencyCode2 then if GenJnlLine.Amount = 0 then begin
                    IsHandled:=false;
                    OnApplyVendorLedgerEntryOnBeforeConfirmUpdateCurrency(GenJnlLine, VendLedgEntry."Currency Code", IsHandled);
                    if not IsHandled then begin
                        ConfirmCurrencyUpdate(GenJnlLine, VendLedgEntry."Currency Code");
                        GenJnlLine."Currency Code":=VendLedgEntry."Currency Code";
                    end;
                end
                else
                begin
                    OnApplyVendorLedgerEntryOnBeforeCheckAgainstApplnCurrencyDifferentCurrenciesAmountNotZero(GenJnlLine, VendLedgEntry);
                    CheckAgainstApplnCurrency(GenJnlLine."Currency Code", VendLedgEntry."Currency Code", AccType::Vendor, true);
                end;
            GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::" ";
            GenJnlLine."Applies-to Doc. No.":='';
            OnApplyVendorLedgerEntryOnAfterSetGenJnlLineAppliesToDocNo(GenJnlLine, VendLedgEntry);
        end
        else
            GenJnlLine."Applies-to ID":='';
        if(GenJnlLine."Applies-to ID" = '') and (CustomAppliesToId <> '')then GenJnlLine."Applies-to ID":=CustomAppliesToId;
        GenJnlLine.SetJournalLineFieldsFromApplication();
        OnApplyVendorLedgerEntryOnBeforeModify(GenJnlLine, TempVendorLedgerEntry, VendLedgEntry);
        UpdateAppliedAmountForVendor(GenJnlLine); //#4 TEC.VJ 20012025
        if GenJnlLine.Modify()then;
        if GenJnlLine.Amount <> 0 then //if not PaymentToleranceMgt.PmtTolGenJnl(GenJnlLine) then //19FEB2025
            exit;
    end;
    procedure Recalculate(var GenJnl2: Record "Gen. Journal Line")
    var
        VendorLedgEntr: Record "Global Vendor Ledger Entry";
        TotalAmount: Decimal;
        CommonFunc: Codeunit "Common Functions";
        AmounttoApply: Page "Global Apply Vendor Entries";
        LCYAmount: Decimal;
        ValidExchRate: Boolean;
        GenJnl: Record "Gen. Journal Line";
        EmployeeLedgEntr: Record "Global Employee Ledger Entry";
        CustomerLedgEntr: Record "Global Cust. Ledger Entry";
    begin
        GenJnl.copy(GenJnl2);
        if GenJnl.FindSet()then repeat Clear(LCYAmount);
                if GenJnl."Account Type" = GenJnl."Account Type"::Vendor then begin
                    VendorLedgEntr.Reset();
                    VendorLedgEntr.SetRange("Applies-to ID", GenJnl."Document No.");
                    VendorLedgEntr.SetRange("Bank Document No. Applied", GenJnl."Bank Document No.");
                    VendorLedgEntr.SetFilter("Amount to Apply", '<>%1', 0);
                    if VendorLedgEntr.FindSet()then begin
                        repeat if VendorLedgEntr."Currency Code" <> GenJnl."Currency Code" then LCYAmount+=CurrExchRate.ApplnExchangeAmtFCYToFCY(GenJnl."Posting Date", VendorLedgEntr."Currency Code", GenJnl."Currency Code", VendorLedgEntr."Amount to Apply", ValidExchRate)
                            else
                                LCYAmount+=VendorLedgEntr."Amount to Apply";
                        until VendorLedgEntr.Next() = 0;
                        GenJnl.SetHideValidation(true);
                        GenJnl.Validate(Amount, -LCYAmount);
                        GenJnl.Validate("Applies-to ID", VendorLedgEntr."Applies-to ID");
                        if GenJnl.Amount <> GenJnl."Applied Amount" then GenJnl."Amount Mismatch":=true
                        else
                            GenJnl."Amount Mismatch":=false;
                        GenJnl.Modify();
                    end
                    else
                    begin
                        GenJnl.SetHideValidation(true);
                        GenJnl.Validate(Amount, 0);
                        GenJnl.Validate("Applies-to ID", '');
                        if GenJnl.Amount <> GenJnl."Applied Amount" then GenJnl."Amount Mismatch":=true
                        else
                            GenJnl."Amount Mismatch":=false;
                        GenJnl.Modify();
                    end;
                end
                else if GenJnl."Account Type" = GenJnl."Account Type"::Employee then begin
                        EmployeeLedgEntr.Reset();
                        EmployeeLedgEntr.SetRange("Applies-to ID", GenJnl."Document No.");
                        EmployeeLedgEntr.SetRange("Bank Document No. Applied", GenJnl."Bank Document No.");
                        EmployeeLedgEntr.SetFilter("Amount to Apply", '<>%1', 0);
                        if EmployeeLedgEntr.FindSet()then begin
                            repeat if EmployeeLedgEntr."Currency Code" <> GenJnl."Currency Code" then LCYAmount+=CurrExchRate.ApplnExchangeAmtFCYToFCY(GenJnl."Posting Date", EmployeeLedgEntr."Currency Code", GenJnl."Currency Code", EmployeeLedgEntr."Amount to Apply", ValidExchRate)
                                else
                                    LCYAmount+=EmployeeLedgEntr."Amount to Apply";
                            until EmployeeLedgEntr.Next() = 0;
                            GenJnl.SetHideValidation(true);
                            GenJnl.Validate(Amount, -LCYAmount);
                            GenJnl.Validate("Applies-to ID", EmployeeLedgEntr."Applies-to ID");
                            if GenJnl.Amount <> GenJnl."Applied Amount" then GenJnl."Amount Mismatch":=true
                            else
                                GenJnl."Amount Mismatch":=false;
                            GenJnl.Modify();
                        end
                        else
                        begin
                            GenJnl.SetHideValidation(true);
                            GenJnl.Validate(Amount, 0);
                            GenJnl.Validate("Applies-to ID", '');
                            if GenJnl.Amount <> GenJnl."Applied Amount" then GenJnl."Amount Mismatch":=true
                            else
                                GenJnl."Amount Mismatch":=false;
                            GenJnl.Modify();
                        end;
                    end //TEC.VJ 06MAR2025>>
                    else if GenJnl."Account Type" = GenJnl."Account Type"::Customer then begin
                            CustomerLedgEntr.Reset();
                            CustomerLedgEntr.SetRange("Applies-to ID", GenJnl."Document No.");
                            CustomerLedgEntr.SetRange("Bank Document No. Applied", GenJnl."Bank Document No.");
                            CustomerLedgEntr.SetFilter("Amount to Apply", '<>%1', 0);
                            if CustomerLedgEntr.FindSet()then begin
                                repeat if CustomerLedgEntr."Currency Code" <> GenJnl."Currency Code" then LCYAmount+=CurrExchRate.ApplnExchangeAmtFCYToFCY(GenJnl."Posting Date", CustomerLedgEntr."Currency Code", GenJnl."Currency Code", CustomerLedgEntr."Amount to Apply", ValidExchRate)
                                    else
                                        LCYAmount+=CustomerLedgEntr."Amount to Apply";
                                until CustomerLedgEntr.Next() = 0;
                                GenJnl.SetHideValidation(true);
                                GenJnl.Validate(Amount, -LCYAmount);
                                GenJnl.Validate("Applies-to ID", CustomerLedgEntr."Applies-to ID");
                                if GenJnl.Amount <> GenJnl."Applied Amount" then GenJnl."Amount Mismatch":=true
                                else
                                    GenJnl."Amount Mismatch":=false;
                                GenJnl.Modify();
                            end
                            else
                            begin
                                GenJnl.SetHideValidation(true);
                                GenJnl.Validate(Amount, 0);
                                GenJnl.Validate("Applies-to ID", '');
                                if GenJnl.Amount <> GenJnl."Applied Amount" then GenJnl."Amount Mismatch":=true
                                else
                                    GenJnl."Amount Mismatch":=false;
                                GenJnl.Modify();
                            end;
                        //TEC.VJ 06MAR2025<<
                        end;
            until GenJnl.Next() = 0;
    end;
    //#4 TEC.VJ 20012025>>
    procedure UpdateAppliedAmountForVendor(VAR GenJnl: Record "Gen. Journal Line")
    var
        VendorLedgEntr: Record "Global Vendor Ledger Entry";
        CommonFunc: Codeunit "Common Functions";
        ValidExchRate: Boolean;
        TtlLCYAmount: Decimal;
        LCYAmount: Decimal;
        ApplyEntries: Text; //#217 TEC.VJ 13022025
    begin
        Clear(LCYAmount);
        Clear(TtlLCYAmount);
        Clear(ApplyEntries);
        if GenJnl."Account Type" = GenJnl."Account Type"::Vendor then begin
            LCYAmount:=0;
            VendorLedgEntr.Reset();
            VendorLedgEntr.SetRange("Applies-to ID", GenJnl."Document No.");
            VendorLedgEntr.SetRange("Bank Document No. Applied", GenJnl."Bank Document No."); //VJ 23Jan2025
            VendorLedgEntr.SetFilter("Amount to Apply", '<>%1', 0);
            if VendorLedgEntr.FindSet()then begin
                repeat if VendorLedgEntr."Currency Code" <> GenJnl."Currency Code" then LCYAmount:=CurrExchRate.ApplnExchangeAmtFCYToFCY(GenJnl."Posting Date", VendorLedgEntr."Currency Code", GenJnl."Currency Code", VendorLedgEntr."Amount to Apply", ValidExchRate)
                    else
                        LCYAmount:=VendorLedgEntr."Amount to Apply";
                    TtlLCYAmount+=LCYAmount;
                    if ApplyEntries = '' then ApplyEntries:=VendorLedgEntr."External Document No." + ',$' + Format(ABS(LCYAmount))
                    else
                        ApplyEntries+=' / ' + VendorLedgEntr."External Document No." + ',$' + Format(ABS(LCYAmount));
                until VendorLedgEntr.Next() = 0;
                GenJnl.SetHideValidation(true);
                TtlLCYAmount:=Round(TtlLCYAmount, Currency."Amount Rounding Precision");
                //DC 02Apr2025 <<
                //GenJnl.Validate("Applied Amount", ABS(TtlLCYAmount));
                GenJnl.Validate("Applied Amount", -TtlLCYAmount);
                //DC 02Apr2025 >>
                if GenJnl.Amount <> GenJnl."Applied Amount" then GenJnl."Amount Mismatch":=true
                else
                    GenJnl."Amount Mismatch":=false;
                IF StrLen(ApplyEntries) > 2046 then //#217 TEC.VJ 13022025 
 GenJnl."Applied Entries to XML":=CopyStr(ApplyEntries, 1, 2046) + '..'
                ELSE
                    GenJnl."Applied Entries to XML":=ApplyEntries;
            end
            else
            begin
                GenJnl.SetHideValidation(true);
                GenJnl.Validate("Applied Amount", 0);
                if GenJnl.Amount <> GenJnl."Applied Amount" then GenJnl."Amount Mismatch":=true
                else
                    GenJnl."Amount Mismatch":=false;
                GenJnl."Applied Entries to XML":='';
            end;
        end;
    end;
    //#4 TEC.VJ <<
    //TEC.VJ 06MAR2025>>
    procedure UpdateAppliedAmountForCustomer(VAR GenJnl: Record "Gen. Journal Line")
    var
        CustomerLedgEntr: Record "Global Cust. Ledger Entry";
        ValidExchRate: Boolean;
        TtlLCYAmount: Decimal;
        LCYAmount: Decimal;
        ApplyEntries: Text; //#217 TEC.VJ 13022025
    begin
        Clear(LCYAmount);
        Clear(TtlLCYAmount);
        Clear(ApplyEntries);
        if GenJnl."Account Type" = GenJnl."Account Type"::Customer then begin
            LCYAmount:=0;
            CustomerLedgEntr.Reset();
            CustomerLedgEntr.SetRange("Applies-to ID", GenJnl."Document No.");
            CustomerLedgEntr.SetRange("Bank Document No. Applied", GenJnl."Bank Document No."); //VJ 23Jan2025
            CustomerLedgEntr.SetFilter("Amount to Apply", '<>%1', 0);
            if CustomerLedgEntr.FindSet()then begin
                repeat if CustomerLedgEntr."Currency Code" <> GenJnl."Currency Code" then LCYAmount:=CurrExchRate.ApplnExchangeAmtFCYToFCY(GenJnl."Posting Date", CustomerLedgEntr."Currency Code", GenJnl."Currency Code", CustomerLedgEntr."Amount to Apply", ValidExchRate)
                    else
                        LCYAmount:=CustomerLedgEntr."Amount to Apply";
                    TtlLCYAmount+=LCYAmount;
                    if ApplyEntries = '' then ApplyEntries:=CustomerLedgEntr."External Document No." + ',$' + Format(ABS(LCYAmount))
                    else
                        ApplyEntries+=' / ' + CustomerLedgEntr."External Document No." + ',$' + Format(ABS(LCYAmount));
                until CustomerLedgEntr.Next() = 0;
                GenJnl.SetHideValidation(true);
                TtlLCYAmount:=Round(TtlLCYAmount, Currency."Amount Rounding Precision");
                GenJnl.Validate("Applied Amount", TtlLCYAmount);
                if GenJnl.Amount <> GenJnl."Applied Amount" then GenJnl."Amount Mismatch":=true
                else
                    GenJnl."Amount Mismatch":=false;
                IF StrLen(ApplyEntries) > 2046 then //#217 TEC.VJ 13022025 
 GenJnl."Applied Entries to XML":=CopyStr(ApplyEntries, 1, 2046) + '..'
                ELSE
                    GenJnl."Applied Entries to XML":=ApplyEntries;
            end
            else
            begin
                GenJnl.SetHideValidation(true);
                GenJnl.Validate("Applied Amount", 0);
                if GenJnl.Amount <> GenJnl."Applied Amount" then GenJnl."Amount Mismatch":=true
                else
                    GenJnl."Amount Mismatch":=false;
                GenJnl."Applied Entries to XML":='';
            end;
        end;
    end;
    //TEC.VJ 06MAR2025<<
    procedure UpdateAppliedAmountForEmployee(VAR GenJnl: Record "Gen. Journal Line")
    var
        EmpLedgEntry: Record "Global Employee Ledger Entry";
        CommonFunc: Codeunit "Common Functions";
        LCYAmount: Decimal;
        TtlLCYAmount: Decimal;
        ValidExchRate: Boolean;
        ApplyEntries: Text; //#217 TEC.VJ 13022025
    begin
        Clear(LCYAmount);
        Clear(TtlLCYAmount);
        Clear(ApplyEntries);
        if GenJnl."Account Type" = GenJnl."Account Type"::Employee then begin
            EmpLedgEntry.Reset();
            EmpLedgEntry.SetRange("Employee No.", GenJnl."Account No.");
            EmpLedgEntry.SetRange("Applies-to ID", GenJnl."Document No.");
            EmpLedgEntry.SetRange("Bank Document No. Applied", GenJnl."Bank Document No."); //VJ 23Jan2025
            EmpLedgEntry.SetFilter("Amount to Apply", '<>%1', 0);
            EmpLedgEntry.SetRange(Open, true);
            if EmpLedgEntry.FindSet()then begin
                LCYAmount:=0;
                repeat if EmpLedgEntry."Currency Code" <> GenJnl."Currency Code" then LCYAmount:=CurrExchRate.ApplnExchangeAmtFCYToFCY(GenJnl."Posting Date", EmpLedgEntry."Currency Code", GenJnl."Currency Code", EmpLedgEntry."Amount to Apply", ValidExchRate)
                    else
                        LCYAmount:=EmpLedgEntry."Amount to Apply";
                    TtlLCYAmount+=LCYAmount;
                    if ApplyEntries = '' then ApplyEntries:=EmpLedgEntry."External Document No." + ',$' + Format(ABS(LCYAmount))
                    else
                        ApplyEntries+=' / ' + EmpLedgEntry."External Document No." + ',$' + Format(ABS(LCYAmount));
                until EmpLedgEntry.Next() = 0;
                GenJnl.SetHideValidation(true);
                TtlLCYAmount:=Round(TtlLCYAmount, Currency."Amount Rounding Precision");
                GenJnl.Validate("Applied Amount", -TtlLCYAmount);
                if GenJnl.Amount <> GenJnl."Applied Amount" then GenJnl."Amount Mismatch":=true
                else
                    GenJnl."Amount Mismatch":=false;
                IF StrLen(ApplyEntries) > 2046 then //#217 TEC.VJ 13022025 
 GenJnl."Applied Entries to XML":=CopyStr(ApplyEntries, 1, 2046) + '..'
                ELSE
                    GenJnl."Applied Entries to XML":=ApplyEntries;
            end
            else
            begin
                GenJnl.SetHideValidation(true);
                GenJnl.Validate("Applied Amount", 0);
                if GenJnl.Amount <> GenJnl."Applied Amount" then GenJnl."Amount Mismatch":=true
                else
                    GenJnl."Amount Mismatch":=false;
                GenJnl."Applied Entries to XML":='';
            end;
        end;
    end;
    local procedure ApplyEmployeeLedgerEntry(var GenJnlLine: Record "Gen. Journal Line")
    var
        // EmplLedgEntry: Record "Employee Ledger Entry";
        EmplLedgEntry: Record "Global Employee Ledger Entry";
        CustomAppliesToId: Code[50];
    begin
        EntrySelected:=SelectEmplLedgEntry(GenJnlLine, CustomAppliesToId);
        if not EntrySelected then exit;
        EmplLedgEntry.Reset();
        EmplLedgEntry.SetCurrentKey("Employee No.", Open, Positive);
        EmplLedgEntry.SetRange("Employee No.", AccNo);
        EmplLedgEntry.SetRange(Open, true);
        EmplLedgEntry.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");
        EmplLedgEntry.SetRange("Bank Document No. Applied", GenJnlLine."Bank Document No."); //VJ 23Jan2025
        if EmplLedgEntry.Find('-')then begin
            CurrencyCode2:=EmplLedgEntry."Currency Code";
            if GenJnlLine.Amount = 0 then begin
                repeat UpdateEmployeeLedgEntry(EmplLedgEntry);
                    // OnApplyEmployeeLedgerEntryOnBeforeUpdateAmount(GenJnlLine, EmplLedgEntry);
                    GenJnlLine.Amount:=GenJnlLine.Amount - EmplLedgEntry."Amount to Apply";
                until EmplLedgEntry.Next() = 0;
                if(GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Customer) or (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor) or (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Employee)then GenJnlLine.Amount:=-GenJnlLine.Amount;
                GenJnlLine.Validate(Amount);
            end;
            if GenJnlLine."Currency Code" <> CurrencyCode2 then if GenJnlLine.Amount = 0 then begin
                    ConfirmCurrencyUpdate(GenJnlLine, EmplLedgEntry."Currency Code");
                    GenJnlLine."Currency Code":=EmplLedgEntry."Currency Code" end;
            GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::" ";
            GenJnlLine."Applies-to Doc. No.":='';
        end
        else
            GenJnlLine."Applies-to ID":='';
        if(GenJnlLine."Applies-to ID" = '') and (CustomAppliesToId <> '')then GenJnlLine."Applies-to ID":=CustomAppliesToId;
        GenJnlLine.SetJournalLineFieldsFromApplication();
        UpdateAppliedAmountForEmployee(GenJnlLine); //VJ 23Jan2025
        if GenJnlLine.Modify()then;
    //  OnAfterApplyEmployeeLedgerEntry(GenJnlLine, EmplLedgEntry);
    end;
    local procedure GetAppliedCustomerEntries(var TempCustLedgerEntry: Record "Global Cust. Ledger entry" temporary; GenJournalLineSource: Record "Gen. Journal Line")
    var
        GenJournalLine: Record "Gen. Journal Line";
        CustLedgerEntry: Record "Global Cust. Ledger entry";
    begin
        if GenJournalLineSource.Amount <> 0 then exit;
        GenJournalLine.SetRange("Journal Template Name", GenJournalLineSource."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", GenJournalLineSource."Journal Batch Name");
        GenJournalLine.SetFilter("Line No.", '<>%1', GenJournalLineSource."Line No.");
        GenJournalLine.SetRange("Document No.", GenJournalLineSource."Document No.");
        if not GenJournalLine.IsEmpty()then begin
            CustLedgerEntry.SetCurrentKey("Customer No.", Open, Positive);
            CustLedgerEntry.SetRange("Customer No.", AccNo);
            CustLedgerEntry.SetRange(Open, true);
            CustLedgerEntry.SetRange("Applies-to ID", GenJournalLineSource."Document No.");
            if CustLedgerEntry.FindSet()then repeat TempCustLedgerEntry:=CustLedgerEntry;
                    TempCustLedgerEntry.Insert();
                until CustLedgerEntry.Next() = 0;
        end;
    end;
    local procedure GetAppliedVendorEntries(var TempVendorLedgerEntry: Record "Global Vendor Ledger Entry" temporary; GenJournalLineSource: Record "Gen. Journal Line")
    var
        GenJournalLine: Record "Gen. Journal Line";
        VendorLedgerEntry: Record "Global Vendor Ledger Entry";
    begin
        if GenJournalLineSource.Amount <> 0 then exit;
        GenJournalLine.SetRange("Journal Template Name", GenJournalLineSource."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", GenJournalLineSource."Journal Batch Name");
        GenJournalLine.SetFilter("Line No.", '<>%1', GenJournalLineSource."Line No.");
        GenJournalLine.SetRange("Document No.", GenJournalLineSource."Document No.");
        if not GenJournalLine.IsEmpty()then begin
            VendorLedgerEntry.SetCurrentKey("Vendor No.", Open, Positive);
            VendorLedgerEntry.SetRange("Vendor No.", AccNo);
            VendorLedgerEntry.SetRange(Open, true);
            VendorLedgerEntry.SetRange("Applies-to ID", GenJournalLineSource."Document No.");
            if VendorLedgerEntry.FindSet()then repeat TempVendorLedgerEntry:=VendorLedgerEntry;
                    TempVendorLedgerEntry.Insert();
                until VendorLedgerEntry.Next() = 0;
        end;
    end;
    local procedure ConfirmCurrencyUpdate(GenJournalLine: Record "Gen. Journal Line"; CurrencyCode: Code[10])
    var
        ConfirmManagement: Codeunit "Confirm Management";
    begin
        if not ConfirmManagement.GetResponseOrDefault(StrSubstNo(ConfirmChangeQst, GenJournalLine.TableCaption(), GenJournalLine."Currency Code", CurrencyCode), true)then Error(UpdateInterruptedErr);
    end;
    local procedure GetAppliedAmountOnCustLedgerEntry(CustLedgEntry: Record "Global Cust. Ledger entry"; var AppliedAmount: Decimal)
    var
        CustLedgEntry2: Record "Global Cust. Ledger entry";
    begin
        if CustLedgEntry."Amount to Apply" = 0 then exit;
        CustLedgEntry2.Get(CustLedgEntry."Entry No.");
        if CustLedgEntry2."Amount to Apply" = CustLedgEntry."Amount to Apply" then CalcAppliedAmountOnCustLedgerEntry(CustLedgEntry, AppliedAmount)
        else
            CalcAppliedAmountOnCustLedgerEntry(CustLedgEntry2, AppliedAmount);
    end;
    local procedure CalcAppliedAmountOnCustLedgerEntry(CustLedgEntry: Record "Global Cust. Ledger entry"; var AppliedAmount: Decimal)
    begin
        CustLedgEntry.CalcFields("Remaining Amount");
        //TEC.VJ COMMENTED    
        // if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(GenJnlLine, CustLedgEntry, 0, false) and
        //     (Abs(CustLedgEntry."Amount to Apply") >=
        //     Abs(CustLedgEntry."Remaining Amount" - CustLedgEntry."Remaining Pmt. Disc. Possible"))
        // then
        //     AppliedAmount := AppliedAmount - (CustLedgEntry."Amount to Apply" - CustLedgEntry."Remaining Pmt. Disc. Possible")
        // else
        AppliedAmount:=AppliedAmount - CustLedgEntry."Amount to Apply";
    end;
    //TEC.VJ 18DEC2024>>
    procedure DelPmtTolApllnDocNo(GenJnlLine: Record "Gen. Journal Line"; DocumentNo: Code[20])
    var
        AppliedCustLedgEntry: Record "Global Cust. Ledger entry";
        AppliedVendLedgEntry: Record "Global Vendor Ledger Entry";
    begin
        if(GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Customer) or (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor)then CODEUNIT.Run(CODEUNIT::"Exchange Acc. G/L Journal Line", GenJnlLine);
        if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer then begin
            AppliedCustLedgEntry.SetCurrentKey("Customer No.", Open, Positive);
            AppliedCustLedgEntry.SetRange("Customer No.", GenJnlLine."Account No.");
            AppliedCustLedgEntry.SetRange(Open, true);
            AppliedCustLedgEntry.SetRange("Document No.", DocumentNo);
            AppliedCustLedgEntry.LockTable();
            if AppliedCustLedgEntry.FindSet()then begin
                repeat AppliedCustLedgEntry."Accepted Payment Tolerance":=0;
                    AppliedCustLedgEntry."Accepted Pmt. Disc. Tolerance":=false;
                    AppliedCustLedgEntry.Modify();
                until AppliedCustLedgEntry.Next() = 0;
                Commit();
            end;
        end
        else if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor then begin
                AppliedVendLedgEntry.SetCurrentKey("Vendor No.", Open, Positive);
                AppliedVendLedgEntry.SetRange("Vendor No.", GenJnlLine."Account No.");
                AppliedVendLedgEntry.SetRange(Open, true);
                AppliedVendLedgEntry.SetRange("Document No.", DocumentNo);
                AppliedVendLedgEntry.LockTable();
                if AppliedVendLedgEntry.FindSet()then begin
                    repeat AppliedVendLedgEntry."Accepted Payment Tolerance":=0;
                        AppliedVendLedgEntry."Accepted Pmt. Disc. Tolerance":=false;
                        AppliedVendLedgEntry.Modify();
                    until AppliedVendLedgEntry.Next() = 0;
                    Commit();
                end;
            end;
    end;
    //TEC.VJ 18DEC2024<<
    [Scope('OnPrem')]
    procedure GetEntrySelected(): Boolean begin
        exit(EntrySelected);
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterRun(var GenJnlLine: Record "Gen. Journal Line")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterCustLedgEntrySetFilters(var CustLedgerEntry: Record "Global Cust. Ledger entry"; GenJournalLine: Record "Gen. Journal Line"; AccNo: Code[20])
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterVendLedgEntrySetFilters(var VendorLedgerEntry: Record "Global Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line"; AccNo: Code[20])
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterApplyEmployeeLedgerEntry(var GenJournalLine: Record "Gen. Journal Line"; EmployeeLedgerEntry: Record "Employee Ledger Entry")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterSelectCustLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; var AccNo: Code[20]; var Selected: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterSelectEmplLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; var AccNo: Code[20]; var Selected: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterSelectVendLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; var AccNo: Code[20]; var Selected: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnApplyCustomerLedgerEntryOnBeforeCheckAgainstApplnCurrency(var GenJournalLine: Record "Gen. Journal Line"; CustLedgerEntry: Record "Global Cust. Ledger entry")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnApplyCustomerLedgerEntryOnBeforeModify(var GenJnlLine: Record "Gen. Journal Line"; CustLedgerEntry: Record "Global Cust. Ledger entry")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnApplyVendorLedgerEntryOnBeforeCheckAgainstApplnCurrency(var GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Global Vendor Ledger Entry")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnApplyVendorLedgerEntryOnBeforeModify(var GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Global Vendor Ledger Entry"; VendorLedgerEntryLocal: Record "Global Vendor Ledger Entry")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnApplyEmployeeLedgerEntryOnBeforeUpdateAmount(var GenJournalLine: Record "Gen. Journal Line"; EmployeeLedgerEntry: Record "Employee Ledger Entry")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeRun(var GenJnlLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckAgainstApplnCurrency(var ApplnCurrencyCode: Code[10]; var CompareCurrencyCode: Code[10])
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindCustApply(GenJournalLine: Record "Gen. Journal Line"; CustLedgerEntry: Record "Global Cust. Ledger entry"; var Amount: Decimal; var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindVendApply(GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Global Vendor Ledger Entry"; var Amount: Decimal; var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeSelectCustLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; var AccNo: Code[20]; var Selected: Boolean; var IsHandled: Boolean; var CustomAppliesToId: Code[50])
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeSelectEmplLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; var AccNo: Code[20]; var Selected: Boolean; var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeSelectVendLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; var AccNo: Code[20]; var Selected: Boolean; var IsHandled: Boolean; var CustomAppliesToId: Code[50])
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnSelectCustLedgEntryOnAfterSetFilters(var CustLedgerEntry: Record "Global Cust. Ledger entry"; var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnSelectEmplLedgEntryOnAfterSetFilters(var EmployeeLedgerEntry: Record "Employee Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnSelectVendLedgEntryOnAfterSetFilters(var VendorLedgerEntry: Record "Global Vendor Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnApplyVendorLedgerEntryOnBeforeConfirmUpdateCurrency(var GenJournalLine: Record "Gen. Journal Line"; CurrencyCode: Code[10]; var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnApplyCustomerLedgerEntryOnBeforeConfirmUpdateCurrency(var GenJournalLine: Record "Gen. Journal Line"; CurrencyCode: Code[10]; var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnApplyCustomerLedgerEntryOnBeforeCheckAgainstApplnCurrencyCustomerAmountNotZero(GenJournalLine: Record "Gen. Journal Line"; CustLedgerEntry: Record "Global Cust. Ledger entry")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnApplyCustomerLedgerEntryOnBeforeCheckAgainstApplnCurrencyCustomer(GenJournalLine: Record "Gen. Journal Line"; CustLedgerEntry: Record "Global Cust. Ledger entry")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnSetVendApplIdAPIOnBeforeCheckAgainstApplnCurrency(GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Global Vendor Ledger Entry")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnApplyVendorLedgerEntryAPIOnBeforeCheckAgainstApplnCurrencyAmountZero(GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Global Vendor Ledger Entry")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnApplyVendorLedgerEntryAPIOnBeforeCheckAgainstApplnCurrencyAmountNonZero(GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Global Vendor Ledger Entry")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnApplyVendorLedgerEntryAPIOnBeforeCheckAgainstApplnCurrencyDifferentCurrenciesAmountNonZero(GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Global Vendor Ledger Entry")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnApplyVendorLedgerEntryOnAfterSetGenJnlLineAppliesToDocNo(var GenJournalLine: Record "Gen. Journal Line"; var VendorLedgerEntry: Record "Global Vendor Ledger Entry")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnApplyVendorLedgerEntryOnBeforeCheckAgainstApplnCurrencyAmountNotZero(GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Global Vendor Ledger Entry")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnApplyVendorLedgerEntryOnBeforeCheckAgainstApplnCurrencyDifferentCurrenciesAmountNotZero(GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Global Vendor Ledger Entry")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnApplyCustomerLedgerEntryOnAfterSetCustomerAppliesToDocNo(var GenJournalLine: Record "Gen. Journal Line"; var CustLedgerEntry: Record "Global Cust. Ledger entry")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnApplyVendorLedgerEntryOnAfterSetVendorAppliesToDocNo(var GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Global Vendor Ledger Entry")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateCustLedgEntry(var CustLedgerEntry: Record "Global Cust. Ledger entry"; GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateVendLedgEntry(var VendorLedgerEntry: Record "Global Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateVendLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; var VendorLedgerEntry: Record "Global Vendor Ledger Entry")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnApplyVendorLedgerEntryAPIOnBeforeValidateAmount(var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnApplyVendorLedgerEntryOnBeforeValidateAmount(var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnSetVendApplIdAPIOnBeforeCheckPostingDate(var TempApplyingVendorLedgerEntry: Record "Global Vendor Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; var VendorLedgerEntry: Record "Global Vendor Ledger Entry")
    begin
    end;
}
