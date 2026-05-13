reportextension 50100 "Check Ext" extends Check
{
    dataset
    {
        add(GenJnlLine)
        {
            column(Payee; g_rec_VendorBankAcc."Beneficiary Name")
            {
            }
            column(Posting_Date; "Posting Date")
            {
            }
            column(Description; Description)
            {
            }
            column(Amount; AmtToTxt(Amount))
            {
            }
            column(PESOS; g_txt_AmountTxt[1])
            {
            }
            column(Bank; g_txt_Bank)
            {
            }
            column(Prepared_by; "Prepared by")
            {
            }
            column(Certified_Correct_by; "Certified Correct by")
            {
            }
            column(Approved_by; "Approved by")
            {
            }
            column(AccountNo; g_rec_VendorBankAcc."Bank Account No.")
            {
            }
            column(PayTotheOrderOf; g_rec_VendorBankAcc."Beneficiary Name" + '' + g_rec_VendorBankAcc."Beneficiary Name 2" + '' + g_rec_VendorBankAcc."Beneficiary Name 3")
            {
            }
            column(TotAmount; g_dec_TotCheqAmt)
            {
            }
            column(M1; g_txt_SplitDate[1])
            {
            }
            column(M2; g_txt_SplitDate[2])
            {
            }
            column(D1; g_txt_SplitDate[3])
            {
            }
            column(D2; g_txt_SplitDate[4])
            {
            }
            column(Y1; g_txt_SplitDate[5])
            {
            }
            column(Y2; g_txt_SplitDate[6])
            {
            }
            column(Y3; g_txt_SplitDate[7])
            {
            }
            column(Y4; g_txt_SplitDate[8])
            {
            }
        }
        addlast(GenJnlLine)
        {
            dataitem(GLE; Integer)
            {
                DataItemTableView = sorting(Number);

                column(accountName; g_rec_GLETmp.Description)
                {
                }
                column(amounts; AmtToTxt(g_rec_GLETmp.Amount))
                {
                }
                column(isShow; g_rec_GLETmp."System-Created Entry")
                {
                }
                trigger OnPreDataItem()
                begin
                    GetGLEntries(GenJnlLine);
                    g_rec_GLETmp.Reset();
                    g_rec_GLETmp.SetCurrentKey("G/L Account No.", "Posting Date");
                    g_rec_GLETmp.SetAscending("G/L Account No.", false);
                    SetRange(Number, 1, 13);
                end;
                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then g_rec_GLETmp.FindFirst()
                    else
                        g_rec_GLETmp.Next();
                end;
            }
        }
        modify(GenJnlLine)
        {
        trigger OnAfterAfterGetRecord()
        begin
            GetApprover(GenJnlLine);
            if g_rec_VendorBankAcc.Get("Account No.", "Recipient Bank Account")then;
            GenAmountText(GenJnlLine);
            SplitDate(GenJnlLine."Posting Date");
            GetBank(GenJnlLine);
        end;
        }
    }
    rendering
    {
        layout("CheckVoucher.rdl")
        {
            Type = RDLC;
            LayoutFile = 'src/reportextension/CheckVoucher.rdl';
        }
    }
    var g_txt_AmountTxt2: array[2]of Text[80];
    g_txt_AmountTxt: array[2]of Text[80];
    g_rec_VendorBankAcc: Record "Vendor Bank Account";
    g_dec_TotCheqAmt: Decimal;
    g_txt_SplitDate: array[8]of Text[1];
    g_txt_Bank: Text;
    g_rec_GLETmp: Record "G/L Entry" temporary;
    local procedure GetApprover(var p_rec_GenJnlLine: Record "Gen. Journal Line")
    var
        l_rec_GJBatch: Record "Gen. Journal Batch";
    begin
        if l_rec_GJBatch.Get(p_rec_GenJnlLine."Journal Template Name", p_rec_GenJnlLine."Journal Batch Name")then;
        l_rec_GJBatch.TestField("Reviewer User");
        l_rec_GJBatch.TestField("Prepare User");
        if(l_rec_GJBatch."Approver A Grp User" = '') and (l_rec_GJBatch."Approver B Grp User" = '')then Error('Approver cannot be blank.');
        p_rec_GenJnlLine."Prepared by":=l_rec_GJBatch."Prepare User";
        p_rec_GenJnlLine."Certified Correct by":=l_rec_GJBatch."Reviewer User";
        p_rec_GenJnlLine."Approved by":=l_rec_GJBatch."Approver A Grp User";
        if p_rec_GenJnlLine."Approved by" = '' then p_rec_GenJnlLine."Approved by":=l_rec_GJBatch."Approver B Grp User";
        p_rec_GenJnlLine.Modify();
    end;
    local procedure GenAmountText(p_rec_GenJnlLine: Record "Gen. Journal Line")
    var
        l_cdu_AmtToTxt: Codeunit "Amount To Cheque Text";
        position: Integer;
    begin
        Clear(g_txt_AmountTxt);
        Clear(l_cdu_AmtToTxt);
        l_cdu_AmtToTxt.InitTextVariable();
        l_cdu_AmtToTxt.FormatNoText(g_txt_AmountTxt, p_rec_GenJnlLine.Amount, p_rec_GenJnlLine."Currency Code", p_rec_GenJnlLine);
        g_txt_AmountTxt[1]:=DelChr(g_txt_AmountTxt[1], '=', '*');
        position:=StrPos(g_txt_AmountTxt[1], ' PHP');
        if position <> 0 then g_txt_AmountTxt[1]:=DelStr(g_txt_AmountTxt[1], position, 4);
        if StrPos(g_txt_AmountTxt[1], '/100') = 0 then g_txt_AmountTxt[1]+=' ONLY';
    end;
    local procedure SplitDate(p_dat_Date: Date)
    var
        l_txt_Date: Text;
        letter: Char;
        index: Integer;
    begin
        Clear(g_txt_SplitDate);
        index:=1;
        l_txt_Date:=Format(p_dat_Date, 0, '<Month,2><Day,2><Year4>');
        foreach letter in l_txt_Date do begin
            g_txt_SplitDate[index]:=letter;
            index+=1;
        end;
    end;
    local procedure GetBank(p_rec_GenJnlLine: Record "Gen. Journal Line")
    var
        l_rec_BankAcc: Record "Bank Account";
        l_rec_Company: Record Company;
        l_txt_CompanyCode: Text;
    begin
        Clear(g_txt_Bank);
        if l_rec_Company.Get(CompanyName)then l_txt_CompanyCode:=l_rec_Company.Name;
        g_txt_Bank:=l_txt_CompanyCode + p_rec_GenJnlLine."Bal. Account No.";
    end;
    local procedure GetGLEntries(p_rec_GenJnlLine: Record "Gen. Journal Line")
    var
        l_rec_VendorEntry: Record "Vendor Ledger Entry";
        l_rec_GLE: Record "G/L Entry";
        VendorPostingAccNo: Code[20];
        LastEntryNo: Integer;
        i: Integer;
    begin
        VendorPostingAccNo:=GetVendorPostingAccNo(p_rec_GenJnlLine);
        g_rec_GLETmp.DeleteAll();
        l_rec_VendorEntry.Reset();
        l_rec_VendorEntry.SetRange("Applies-to ID", p_rec_GenJnlLine."Document No.");
        if l_rec_VendorEntry.FindFirst()then repeat l_rec_GLE.Reset();
                l_rec_GLE.SetRange("Posting Date", l_rec_VendorEntry."Posting Date");
                l_rec_GLE.SetRange("Document No.", l_rec_VendorEntry."Document No.");
                if l_rec_GLE.FindFirst()then repeat if l_rec_GLE.Count() <= 10 then begin
                            l_rec_GLE.CalcFields("G/L Account Name");
                            if l_rec_GLE."G/L Account No." <> VendorPostingAccNo then begin
                                g_rec_GLETmp.Reset();
                                g_rec_GLETmp.SetRange("G/L Account No.", l_rec_GLE."G/L Account No.");
                                if not g_rec_GLETmp.FindFirst()then begin
                                    Clear(g_rec_GLETmp);
                                    g_rec_GLETmp.Init();
                                    g_rec_GLETmp:=l_rec_GLE;
                                    g_rec_GLETmp.Description:=l_rec_GLE."G/L Account Name";
                                    g_rec_GLETmp."System-Created Entry":=true;
                                    g_rec_GLETmp.Insert();
                                end
                                else
                                begin
                                    g_rec_GLETmp.Amount+=l_rec_GLE.Amount;
                                    g_rec_GLETmp.Modify();
                                end;
                            end;
                        end
                        else if l_rec_GLE.Count() <= 13 then begin
                                l_rec_VendorEntry.CalcFields("Remaining Amount");
                                LastEntryNo:=GetLastEntryNo();
                                g_rec_GLETmp.Reset();
                                g_rec_GLETmp.SetRange("G/L Account Name", l_rec_VendorEntry."External Document No.");
                                if not g_rec_GLETmp.FindFirst()then begin
                                    Clear(g_rec_GLETmp);
                                    g_rec_GLETmp.Init();
                                    g_rec_GLETmp."Entry No.":=LastEntryNo + 1;
                                    g_rec_GLETmp.Description:=l_rec_VendorEntry."External Document No.";
                                    g_rec_GLETmp.Amount:=l_rec_VendorEntry."Remaining Amount";
                                    g_rec_GLETmp."System-Created Entry":=true;
                                    g_rec_GLETmp.Insert();
                                end
                                else
                                begin
                                    g_rec_GLETmp.Amount+=l_rec_VendorEntry."Remaining Amount";
                                    g_rec_GLETmp.Modify();
                                end;
                            end;
                    until l_rec_GLE.Next() = 0;
            until l_rec_VendorEntry.Next() = 0;
        LastEntryNo:=GetLastEntryNo();
        //
        g_rec_GLETmp.Reset();
        g_rec_GLETmp.Init();
        LastEntryNo+=1;
        g_rec_GLETmp."Entry No.":=LastEntryNo;
        g_rec_GLETmp.Description:=GetBankName(GenJnlLine);
        g_rec_GLETmp.Amount:=GenJnlLine.Amount * -1;
        g_rec_GLETmp."System-Created Entry":=true;
        g_rec_GLETmp.Insert();
        //Blank Lines
        for i:=0 to 12 - g_rec_GLETmp.Count()do begin
            g_rec_GLETmp.Reset();
            g_rec_GLETmp.Init();
            LastEntryNo+=1;
            g_rec_GLETmp."Entry No.":=LastEntryNo;
            g_rec_GLETmp."System-Created Entry":=false;
            g_rec_GLETmp.Insert();
        end;
    end;
    local procedure GetLastEntryNo(): Integer begin
        g_rec_GLETmp.Reset();
        g_rec_GLETmp.SetCurrentKey("Entry No.");
        if g_rec_GLETmp.FindLast()then exit(g_rec_GLETmp."Entry No.");
    end;
    local procedure GetVendorPostingAccNo(p_rec_PaymJnl: Record "Gen. Journal Line"): Code[20]var
        l_rec_Vendor: Record Vendor;
        l_rec_VendorPostingGp: Record "Vendor Posting Group";
    begin
        if l_rec_Vendor.get(p_rec_PaymJnl."Account No.")then;
        if l_rec_VendorPostingGp.get(l_rec_Vendor."Vendor Posting Group")then exit(l_rec_VendorPostingGp."Payables Account");
    end;
    local procedure GetBankName(p_rec_GenJnlLine: Record "Gen. Journal Line"): Text var
        l_rec_BankAcc: Record "Bank Account";
    begin
        if l_rec_BankAcc.Get(p_rec_GenJnlLine."Bal. Account No.")then exit(l_rec_BankAcc.Name);
    end;
    local procedure AmtToTxt(p_dec_Amt: Decimal): Text var
        l_txt_tmp: Text;
    begin
        Clear(l_txt_tmp);
        // p_dec_Amt := p_dec_Amt * -1;
        if p_dec_Amt < 0 then l_txt_tmp:='(' + Format(p_dec_Amt, 0, '<Precision,2:2><Integer Thousand><Decimals>') + ')'
        else
            l_txt_tmp:=Format(p_dec_Amt, 0, '<Precision,2:2><Integer Thousand><Decimals>');
        exit(l_txt_tmp);
    end;
}
