xmlport 50112 "Citi 403 XML"
{
    Caption = 'Citi 403';
    Direction = Export;
    Format = Xml;
    Encoding = UTF8;
    Namespaces = "" = 'urn:iso:std:iso:20022:tech:xsd:pain.001.001.03', "xsi" = 'http://www.w3.org/2001/XMLSchema-instance';
    UseDefaultNamespace = false;
    UseRequestPage = false;

    schema
    {
    textelement(document)
    {
    MinOccurs = Zero;
    XmlName = 'Document';

    textelement(cstmrcdttrfinitn)
    {
    MinOccurs = Zero;
    XmlName = 'CstmrCdtTrfInitn';

    textelement(grphdr)
    {
    MinOccurs = Zero;
    XmlName = 'GrpHdr';

    textelement(msgid)
    {
    MinOccurs = Zero;
    XmlName = 'MsgId';

    trigger OnBeforePassVariable()
    begin
        msgid:=CITI."Batch Id";
    end;
    }
    textelement(credttm)
    {
    MinOccurs = Zero;
    XmlName = 'CreDtTm';

    trigger OnBeforePassVariable()
    begin
        credttm:=Format(CITI."Create Date Time", 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2><Filler Character,0>:<Minutes,2>:<Seconds,2>');
    end;
    }
    textelement(nboftxs)
    {
    MinOccurs = Zero;
    XmlName = 'NbOfTxs';

    trigger OnBeforePassVariable()
    begin
        nboftxs:=Format(Count);
    end;
    }
    textelement(initgpty)
    {
    MinOccurs = Zero;
    XmlName = 'InitgPty';

    textelement(nm)
    {
    MinOccurs = Zero;
    XmlName = 'Nm';

    trigger OnBeforePassVariable()
    begin
        nm:=CITI."Debtor Name";
    end;
    }
    textelement(PstlAdr2)
    {
    XmlName = 'PstlAdr';

    textelement(DeCtry2)
    {
    XmlName = 'Adrline';

    trigger OnBeforePassVariable()
    begin
        DeCtry2:=CITI."Debtor Address";
    end;
    }
    }
    }
    }
    textelement(pmtinf)
    {
    MinOccurs = Zero;
    XmlName = 'PmtInf';

    textelement(pmtinfid)
    {
    MinOccurs = Zero;
    XmlName = 'PmtInfId';

    trigger OnBeforePassVariable()
    begin
        pmtinfid:=CITI."Batch Id";
    end;
    }
    textelement(pmtmtd)
    {
    MinOccurs = Zero;
    XmlName = 'PmtMtd';

    trigger OnBeforePassVariable()
    begin
        pmtmtd:=CITI."Payment Method Bank XML";
    end;
    }
    textelement(pmttpinf)
    {
    MinOccurs = Zero;
    XmlName = 'PmtTpInf';

    textelement(svclvl)
    {
    MinOccurs = Zero;
    XmlName = 'SvcLvl';

    textelement(cd)
    {
    MinOccurs = Zero;
    XmlName = 'Cd';

    trigger OnBeforePassVariable()
    begin
        cd:=Format(CITI."Service Level");
    end;
    }
    }
    //>>VJ06DEC2024 Commented
    // textelement(LclInstrm)
    // {
    //     textelement(Prtry)
    //     {
    //         trigger OnBeforePassVariable()
    //         begin
    //             Prtry := Format(CITI."Batch Type");
    //         end;
    //     }
    // }
    //>>VJ06DEC2024 Commented
    }
    textelement(reqdexctndt)
    {
    MinOccurs = Zero;
    XmlName = 'ReqdExctnDt';

    trigger OnBeforePassVariable()
    begin
        reqdexctndt:=Format(CITI."Posting Date", 0, 9);
    end;
    }
    textelement(dbtr)
    {
    MinOccurs = Zero;
    XmlName = 'Dbtr';

    textelement(dbtr_nm)
    {
    MinOccurs = Zero;
    XmlName = 'Nm';

    trigger OnBeforePassVariable()
    begin
        dbtr_nm:=CITI."Debtor Name";
    end;
    }
    //>>VJ 05DEC2024
    textelement(PstlAdr)
    {
    textelement(DeCtry)
    {
    XmlName = 'Adrline';

    trigger OnBeforePassVariable()
    begin
        DeCtry:=CITI."Debtor Address";
    end;
    }
    }
    //<<VJ 05DEC2024
    }
    textelement(dbtracct)
    {
    MinOccurs = Zero;
    XmlName = 'DbtrAcct';

    textelement(id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';

    textelement(othr)
    {
    MinOccurs = Zero;
    XmlName = 'Othr';

    textelement(othr_id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';

    trigger OnBeforePassVariable()
    begin
        othr_id:=CITI."Debtor Bank Account";
    end;
    }
    }
    }
    }
    textelement(dbtragt)
    {
    MinOccurs = Zero;
    XmlName = 'DbtrAgt';

    textelement(fininstnid)
    {
    MinOccurs = Zero;
    XmlName = 'FinInstnId';

    textelement(bic)
    {
    MinOccurs = Zero;
    XmlName = 'BIC';

    trigger OnBeforePassVariable()
    begin
        bic:=CITI."Debtor SWIFT Code";
    end;
    }
    /* textelement(pstladr)
                            {
                                MinOccurs = Zero;
                                XmlName = 'PstlAdr';
                                textelement(ctry)
                                {
                                    MinOccurs = Zero;
                                    XmlName = 'Ctry';
                                }
                            } */
    }
    }
    tableelement(cdttrftxinf;
    "Citi Outbound Staging Table")
    {
    MinOccurs = Zero;
    XmlName = 'CdtTrfTxInf';

    textelement(pmtid)
    {
    MinOccurs = Zero;
    XmlName = 'PmtId';

    fieldelement(endtoendid;
    cdttrftxinf."Bank Document No.")
    {
    MinOccurs = Zero;
    XmlName = 'EndToEndId';
    }
    }
    textelement(amt)
    {
    MinOccurs = Zero;
    XmlName = 'Amt';

    textelement(instdamt)
    {
    MinOccurs = Zero;
    XmlName = 'InstdAmt';

    fieldattribute(instdamt_ccy;
    cdttrftxinf.Currency)
    {
    Occurrence = Required;
    XmlName = 'Ccy';
    }
    trigger OnBeforePassVariable()
    begin
        instdamt:=Format(cdttrftxinf.Amount, 0, 9);
    end;
    }
    }
    textelement(cdtragt)
    {
    textelement(CrFinInstnId)
    {
    XmlName = 'FinInstnId';

    fieldelement(BIC;
    CdtTrfTxInf."Creditor Swift Code")
    {
    }
    textelement(cdtr_ClrSysMmbId)
    {
    XmlName = 'ClrSysMmbId';

    fieldelement(MmbId;
    CdtTrfTxInf."Creditor ABA/BSB No.")
    {
    }
    trigger OnBeforePassVariable()
    begin
        if(cdttrftxinf."Creditor ABA/BSB No." = '')then currXMLport.Skip();
    end;
    }
    textelement(CrPstlAdr)
    {
    XmlName = 'PstlAdr';

    fieldelement(CrCtry;
    CdtTrfTxInf."Creditor Country")
    {
    XmlName = 'Ctry';

    trigger OnBeforePassField()
    begin
        if CdtTrfTxInf."Creditor Country" = '' then currXMLport.Skip();
    end;
    }
    }
    }
    }
    textelement(cdtr)
    {
    MinOccurs = Zero;
    XmlName = 'Cdtr';

    fieldelement(cdtr_nm;
    cdttrftxinf."Creditor Bank Acc Name")
    {
    MinOccurs = Zero;
    XmlName = 'Nm';
    }
    textelement(cdtr_pstladr)
    {
    MinOccurs = Zero;
    XmlName = 'PstlAdr';

    /*   textelement(adrtp)
                                  {
                                      MinOccurs = Zero;
                                      XmlName = 'AdrTp';
                                  } */
    fieldelement(cdtr_pstladr_ctry;
    cdttrftxinf."Creditor Country")
    {
    MinOccurs = Zero;
    XmlName = 'Ctry';
    }
    fieldelement(adrline;
    cdttrftxinf."Creditor Address")
    {
    MinOccurs = Zero;
    XmlName = 'AdrLine';

    trigger OnBeforePassField()
    begin
        if cdttrftxinf."Creditor Address" = '' then currXMLport.Skip();
    end;
    }
    trigger OnBeforePassVariable()
    begin
        if(cdttrftxinf."Creditor Address" = '') and (cdttrftxinf."Creditor Country" = '')then currXMLport.Skip();
    end;
    }
    }
    textelement(cdtracct)
    {
    MinOccurs = Zero;
    XmlName = 'CdtrAcct';

    textelement(cdtracct_id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';

    fieldelement(IBAN;
    CdtTrfTxInf."Creditor IBAN Account")
    {
    trigger OnBeforePassField()
    begin
        if CdtTrfTxInf."Creditor IBAN Account" = '' then currXMLport.Skip();
    end;
    }
    textelement(id_othr)
    {
    MinOccurs = Zero;
    XmlName = 'Othr';

    fieldelement(id_othr_id;
    cdttrftxinf."Creditor Bank Account")
    {
    MinOccurs = Zero;
    XmlName = 'Id';
    }
    trigger OnBeforePassVariable()
    begin
        if CdtTrfTxInf."Creditor Bank Account" = '' then currXMLport.Skip();
    end;
    }
    }
    }
    textelement(RltdRmtInf1)
    {
    XmlName = 'RltdRmtInf';

    textelement(RmtLctnMtd1)
    {
    XmlName = 'RmtLctnMtd';

    trigger OnBeforePassVariable()
    begin
        RmtLctnMtd1:='EMAL';
    end;
    }
    fieldelement(RmtLctnElctrncAdr;
    cdttrftxinf."Creditor Email Address 1")
    {
    }
    trigger OnBeforePassVariable()
    begin
        if(CdtTrfTxInf."Creditor Email Address 1" = '')then currXMLport.Skip();
    end;
    }
    textelement(rmtinf)
    {
    MinOccurs = Zero;
    XmlName = 'RmtInf';

    textelement(ustrdn1)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if(g_txt_ustrd.Get(1) = '')then currXMLport.Skip();
        ustrdn1:=g_txt_ustrd.Get(1);
    end;
    }
    textelement(ustrdn2)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if(g_txt_ustrd.Get(2) = '')then currXMLport.Skip();
        ustrdn2:=g_txt_ustrd.Get(2);
    end;
    }
    textelement(ustrdn3)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if(g_txt_ustrd.Get(3) = '')then currXMLport.Skip();
        ustrdn3:=g_txt_ustrd.Get(3);
    end;
    }
    textelement(ustrdmail1)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if cdttrftxinf."Creditor Email Address 2" = '' then currXMLport.Skip();
        ustrdmail1:=StrSubstNo('/PMDD/EMAIL+%1', cdttrftxinf."Creditor Email Address 2");
    end;
    }
    textelement(ustrdmail2)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if cdttrftxinf."Creditor Email Address 3" = '' then currXMLport.Skip();
        ustrdmail2:=StrSubstNo('/PMDD/EMAIL+%1', cdttrftxinf."Creditor Email Address 3");
    end;
    }
    textelement(ustrdmail3)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if cdttrftxinf."Creditor Email Address 4" = '' then currXMLport.Skip();
        ustrdmail3:=StrSubstNo('/PMDD/EMAIL+%1', cdttrftxinf."Creditor Email Address 4");
    end;
    }
    textelement(ustrd3)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if cdttrftxinf."Applied Entries to XML" = '' then currXMLport.Skip();
        ustrd3:=StrSubstNo('/PMDD/Reference Date Description Amount(%1)', cdttrftxinf.Currency);
    end;
    }
    textelement(pmdd1)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(1) = '' then currXMLport.Skip();
        pmdd1:='/PMDD/' + g_txt_pmdd.Get(1);
    end;
    }
    textelement(pmdd2)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(2) = '' then currXMLport.Skip();
        pmdd2:='/PMDD/' + g_txt_pmdd.Get(2);
    end;
    }
    textelement(pmdd3)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(3) = '' then currXMLport.Skip();
        pmdd3:='/PMDD/' + g_txt_pmdd.Get(3);
    end;
    }
    textelement(pmdd4)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(4) = '' then currXMLport.Skip();
        pmdd4:='/PMDD/' + g_txt_pmdd.Get(4);
    end;
    }
    textelement(pmdd5)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(5) = '' then currXMLport.Skip();
        pmdd5:='/PMDD/' + g_txt_pmdd.Get(5);
    end;
    }
    textelement(pmdd6)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(6) = '' then currXMLport.Skip();
        pmdd6:='/PMDD/' + g_txt_pmdd.Get(6);
    end;
    }
    textelement(pmdd7)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(7) = '' then currXMLport.Skip();
        pmdd7:='/PMDD/' + g_txt_pmdd.Get(7);
    end;
    }
    textelement(pmdd8)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(8) = '' then currXMLport.Skip();
        pmdd8:='/PMDD/' + g_txt_pmdd.Get(8);
    end;
    }
    textelement(pmdd9)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(9) = '' then currXMLport.Skip();
        pmdd9:='/PMDD/' + g_txt_pmdd.Get(9);
    end;
    }
    textelement(pmdd10)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(10) = '' then currXMLport.Skip();
        pmdd10:='/PMDD/' + g_txt_pmdd.Get(10);
    end;
    }
    textelement(pmdd11)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(11) = '' then currXMLport.Skip();
        pmdd11:='/PMDD/' + g_txt_pmdd.Get(11);
    end;
    }
    textelement(pmdd12)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(12) = '' then currXMLport.Skip();
        pmdd12:='/PMDD/' + g_txt_pmdd.Get(12);
    end;
    }
    textelement(pmdd13)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(13) = '' then currXMLport.Skip();
        pmdd13:='/PMDD/' + g_txt_pmdd.Get(13);
    end;
    }
    textelement(pmdd14)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(14) = '' then currXMLport.Skip();
        pmdd14:='/PMDD/' + g_txt_pmdd.Get(14);
    end;
    }
    textelement(pmdd15)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(15) = '' then currXMLport.Skip();
        pmdd15:='/PMDD/' + g_txt_pmdd.Get(15);
    end;
    }
    textelement(pmdd16)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(16) = '' then currXMLport.Skip();
        pmdd16:='/PMDD/' + g_txt_pmdd.Get(16);
    end;
    }
    textelement(pmdd17)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(17) = '' then currXMLport.Skip();
        pmdd17:='/PMDD/' + g_txt_pmdd.Get(17);
    end;
    }
    textelement(pmdd18)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(18) = '' then currXMLport.Skip();
        pmdd18:='/PMDD/' + g_txt_pmdd.Get(18);
    end;
    }
    textelement(pmdd19)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(19) = '' then currXMLport.Skip();
        pmdd19:='/PMDD/' + g_txt_pmdd.Get(19);
    end;
    }
    textelement(pmdd20)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(20) = '' then currXMLport.Skip();
        pmdd20:='/PMDD/' + g_txt_pmdd.Get(20);
    end;
    }
    textelement(pmdd21)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(21) = '' then currXMLport.Skip();
        pmdd21:='/PMDD/' + g_txt_pmdd.Get(21);
    end;
    }
    textelement(pmdd22)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(22) = '' then currXMLport.Skip();
        pmdd22:='/PMDD/' + g_txt_pmdd.Get(22);
    end;
    }
    textelement(pmdd23)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(23) = '' then currXMLport.Skip();
        pmdd23:='/PMDD/' + g_txt_pmdd.Get(23);
    end;
    }
    textelement(pmdd24)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(24) = '' then currXMLport.Skip();
        pmdd24:='/PMDD/' + g_txt_pmdd.Get(24);
    end;
    }
    textelement(pmdd25)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(25) = '' then currXMLport.Skip();
        pmdd25:='/PMDD/' + g_txt_pmdd.Get(25);
    end;
    }
    textelement(pmdd26)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(26) = '' then currXMLport.Skip();
        pmdd26:='/PMDD/' + g_txt_pmdd.Get(26);
    end;
    }
    textelement(pmdd27)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(27) = '' then currXMLport.Skip();
        pmdd27:='/PMDD/' + g_txt_pmdd.Get(27);
    end;
    }
    textelement(pmdd28)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(28) = '' then currXMLport.Skip();
        pmdd28:='/PMDD/' + g_txt_pmdd.Get(28);
    end;
    }
    textelement(pmdd29)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(29) = '' then currXMLport.Skip();
        pmdd29:='/PMDD/' + g_txt_pmdd.Get(29);
    end;
    }
    textelement(pmdd30)
    {
    XmlName = 'Ustrd';

    trigger OnBeforePassVariable()
    begin
        if g_txt_pmdd.Get(30) = '' then currXMLport.Skip();
        pmdd30:='/PMDD/' + g_txt_pmdd.Get(30);
    end;
    }
    trigger OnBeforePassVariable()
    begin
        if(cdttrftxinf."Debtor To Receipt" = '') and (cdttrftxinf."Purpose Code" = '') and (cdttrftxinf."Payment Purpose" = '') and (cdttrftxinf."Applied Entries to XML" = '') and (cdttrftxinf."Creditor Email Address 2" = '') and (cdttrftxinf."Creditor Email Address 3" = '') and (cdttrftxinf."Creditor Email Address 4" = '')then currXMLport.Skip();
        SplitUstrd();
        SplitPMDD();
    end;
    }
    textelement(Purp)
    {
    textelement(Prtry)
    {
    trigger OnBeforePassVariable()
    begin
        Prtry:='23';
    end;
    }
    }
    /* textelement(rmtinf)
                        {
                            MinOccurs = Zero;
                            XmlName = 'RmtInf';
                            textelement(ustrd)
                            {
                                MinOccurs = Zero;
                                XmlName = 'Ustrd';
                            }
                        } */
    }
    }
    }
    }
    }
    procedure SetRecord(var CITIOut: Record "Citi Outbound Staging Table")
    begin
        CITI.DeleteAll();
        repeat CITI.Init();
            CITI:=CITIOut;
            CITI.Insert();
        until CITIOut.Next() = 0;
        Count:=CITI.Count();
        CITI.CalcSums(Amount);
    end;
    local procedure SplitUstrd()
    var
        l_txt_tmp: Text;
        i: Integer;
    begin
        l_txt_tmp:=cdttrftxinf."Purpose Code";
        if l_txt_tmp <> '' then l_txt_tmp+=' ';
        l_txt_tmp+=cdttrftxinf."Payment Purpose";
        if l_txt_tmp <> '' then l_txt_tmp+=' ';
        l_txt_tmp+=cdttrftxinf."Debtor To Receipt";
        for i:=1 to 3 do begin
            if StrLen(l_txt_tmp) > 35 then begin
                g_txt_ustrd.Add(CopyStr(l_txt_tmp, 1, 35));
                l_txt_tmp:=CopyStr(l_txt_tmp, 36);
            end
            else
            begin
                g_txt_ustrd.Add(l_txt_tmp);
                l_txt_tmp:='';
            end;
        end;
    end;
    local procedure SplitPMDD()
    var
        l_txt_tmp: Text;
        i: Integer;
    begin
        l_txt_tmp:=cdttrftxinf."Applied Entries to XML";
        for i:=1 to 30 do begin
            if StrLen(l_txt_tmp) > 70 then begin
                g_txt_pmdd.Add(CopyStr(l_txt_tmp, 1, 70));
                l_txt_tmp:=CopyStr(l_txt_tmp, 71);
            end
            else
            begin
                g_txt_pmdd.Add(l_txt_tmp);
                l_txt_tmp:='';
            end;
        end;
    end;
    var CITI: Record "Citi Outbound Staging Table" temporary;
    Count: Integer;
    g_txt_ustrd: List of[Text[35]];
    g_txt_pmdd: List of[Text[70]];
}
