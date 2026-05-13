xmlport 50108 "HSBC Inbound CAMT 53"
{
    Caption = 'HSBC Inbound CAMT 53';
    Direction = Import;
    Format = Xml;
    Encoding = UTF8;
    Namespaces = "" = 'urn:iso:std:iso:20022:tech:xsd:camt.053.001.02';
    UseDefaultNamespace = false;
    UseRequestPage = false;

    schema
    {
    textelement(document)
    {
    MinOccurs = Zero;
    XmlName = 'Document';

    textelement(bktocstmrstmt)
    {
    MinOccurs = Zero;
    XmlName = 'BkToCstmrStmt';

    textelement(grphdr)
    {
    MinOccurs = Zero;
    XmlName = 'GrpHdr';

    textelement(msgid)
    {
    MinOccurs = Zero;
    XmlName = 'MsgId';
    }
    textelement(credttm)
    {
    MinOccurs = Zero;
    XmlName = 'CreDtTm';
    }
    textelement(msgpgntn)
    {
    MinOccurs = Zero;
    XmlName = 'MsgPgntn';

    textelement(pgnb)
    {
    MinOccurs = Zero;
    XmlName = 'PgNb';
    }
    textelement(lastpgind)
    {
    MinOccurs = Zero;
    XmlName = 'LastPgInd';
    }
    }
    }
    textelement(stmt)
    {
    MinOccurs = Zero;
    XmlName = 'Stmt';

    textelement(id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';
    }
    textelement(elctrncseqnb)
    {
    MinOccurs = Zero;
    XmlName = 'ElctrncSeqNb';
    }
    textelement(stmt_credttm)
    {
    MinOccurs = Zero;
    XmlName = 'CreDtTm';
    }
    textelement(frtodt)
    {
    MinOccurs = Zero;
    XmlName = 'FrToDt';

    textelement(frdttm)
    {
    MinOccurs = Zero;
    XmlName = 'FrDtTm';
    }
    textelement(todttm)
    {
    MinOccurs = Zero;
    XmlName = 'ToDtTm';
    }
    }
    textelement(acct)
    {
    MinOccurs = Zero;
    XmlName = 'Acct';

    textelement(acct_id)
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
    }
    }
    }
    textelement(ccy)
    {
    MinOccurs = Zero;
    XmlName = 'Ccy';
    }
    textelement(svcr)
    {
    MinOccurs = Zero;
    XmlName = 'Svcr';

    textelement(fininstnid)
    {
    MinOccurs = Zero;
    XmlName = 'FinInstnId';

    textelement(bic)
    {
    MinOccurs = Zero;
    XmlName = 'BIC';
    }
    }
    }
    }
    textelement(bal)
    {
    MinOccurs = Zero;
    XmlName = 'Bal';

    textelement(tp)
    {
    MinOccurs = Zero;
    XmlName = 'Tp';

    textelement(cdorprtry)
    {
    MinOccurs = Zero;
    XmlName = 'CdOrPrtry';

    textelement(cd)
    {
    MinOccurs = Zero;
    XmlName = 'Cd';
    }
    }
    }
    textelement(cdtline)
    {
    MinOccurs = Zero;
    XmlName = 'CdtLine';

    textelement(incl)
    {
    MinOccurs = Zero;
    XmlName = 'Incl';
    }
    }
    textelement(amt)
    {
    MinOccurs = Zero;
    XmlName = 'Amt';

    textattribute(amt_ccy)
    {
    Occurrence = Required;
    XmlName = 'Ccy';
    }
    trigger OnAfterAssignVariable()
    begin
        case cd of 'OPAV': Evaluate(g_dec_OPAV, amt);
        'OPBD': Evaluate(g_dec_OPBD, amt);
        'CLBD': Evaluate(g_dec_CLBD, amt);
        'CLAV': Evaluate(g_dec_CLAV, amt);
        end;
    end;
    }
    textelement(cdtdbtind)
    {
    MinOccurs = Zero;
    XmlName = 'CdtDbtInd';
    }
    textelement(dt)
    {
    MinOccurs = Zero;
    XmlName = 'Dt';

    textelement(dt_dt)
    {
    MinOccurs = Zero;
    XmlName = 'Dt';
    }
    }
    }
    textelement(txssummry)
    {
    MinOccurs = Zero;
    XmlName = 'TxsSummry';

    textelement(ttlcdtntries)
    {
    MinOccurs = Zero;
    XmlName = 'TtlCdtNtries';

    textelement(nbofntries)
    {
    MinOccurs = Zero;
    XmlName = 'NbOfNtries';
    }
    textelement(sum)
    {
    MinOccurs = Zero;
    XmlName = 'Sum';
    }
    }
    textelement(ttldbtntries)
    {
    MinOccurs = Zero;
    XmlName = 'TtlDbtNtries';

    textelement(ttldbtntries_nbofntries)
    {
    MinOccurs = Zero;
    XmlName = 'NbOfNtries';
    }
    textelement(ttldbtntries_sum)
    {
    MinOccurs = Zero;
    XmlName = 'Sum';
    }
    }
    }
    tableelement(ntry;
    "HSBC Inbound Staging")
    {
    MinOccurs = Zero;
    XmlName = 'Ntry';

    fieldelement(ntryref;
    ntry."Entry Reference")
    {
    MinOccurs = Zero;
    XmlName = 'NtryRef';
    }
    fieldelement(ntry_amt;
    ntry.entryamount)
    {
    MinOccurs = Zero;
    XmlName = 'Amt';

    fieldattribute(ntry_amt_ccy;
    ntry.EntryCurrency)
    {
    Occurrence = Required;
    XmlName = 'Ccy';
    }
    }
    fieldelement(ntry_cdtdbtind;
    ntry.EntryCrDrInd)
    {
    MinOccurs = Zero;
    XmlName = 'CdtDbtInd';
    }
    fieldelement(rvslind;
    ntry.EntryRevInd)
    {
    MinOccurs = Zero;
    XmlName = 'RvslInd';
    }
    fieldelement(sts;
    ntry.EntryStatus)
    {
    MinOccurs = Zero;
    XmlName = 'Sts';
    }
    textelement(bookgdt)
    {
    MinOccurs = Zero;
    XmlName = 'BookgDt';

    textelement(bookgdt_dt)
    {
    MinOccurs = Zero;
    XmlName = 'Dt';
    }
    textelement(bookgdt_dttm)
    {
    MinOccurs = Zero;
    XmlName = 'DtTm';
    }
    }
    textelement(valdt)
    {
    MinOccurs = Zero;
    XmlName = 'ValDt';

    textelement(valdt_dt)
    {
    MinOccurs = Zero;
    XmlName = 'Dt';
    }
    }
    fieldelement(acctsvcrref;
    ntry.EntryAccountServRef)
    {
    MinOccurs = Zero;
    XmlName = 'AcctSvcrRef';
    }
    textelement(bktxcd)
    {
    MinOccurs = Zero;
    XmlName = 'BkTxCd';

    textelement(domn)
    {
    MinOccurs = Zero;
    XmlName = 'Domn';

    textelement(domn_cd)
    {
    MinOccurs = Zero;
    XmlName = 'Cd';
    }
    textelement(fmly)
    {
    MinOccurs = Zero;
    XmlName = 'Fmly';

    textelement(fmly_cd)
    {
    MinOccurs = Zero;
    XmlName = 'Cd';
    }
    textelement(subfmlycd)
    {
    MinOccurs = Zero;
    XmlName = 'SubFmlyCd';
    }
    }
    }
    textelement(prtry)
    {
    MinOccurs = Zero;
    XmlName = 'Prtry';

    fieldelement(prtry_cd;
    ntry.EntryTransCode)
    {
    MinOccurs = Zero;
    XmlName = 'Cd';
    }
    fieldelement(issr;
    ntry.EntryIssuer)
    {
    MinOccurs = Zero;
    XmlName = 'Issr';
    }
    }
    }
    textelement(ntrydtls)
    {
    MinOccurs = Zero;
    XmlName = 'NtryDtls';

    textelement(btch)
    {
    MinOccurs = Zero;
    XmlName = 'Btch';

    fieldelement(btch_msgid;
    ntry.EntryMessageId)
    {
    MinOccurs = Zero;
    XmlName = 'MsgId';
    }
    fieldelement(pmtinfid;
    ntry.EntryPmtInfid)
    {
    MinOccurs = Zero;
    XmlName = 'PmtInfId';
    }
    textelement(nboftxs)
    {
    MinOccurs = Zero;
    XmlName = 'NbOfTxs';
    }
    textelement(ttlamt)
    {
    MinOccurs = Zero;
    XmlName = 'TtlAmt';

    textattribute(ttlamt_ccy)
    {
    Occurrence = Required;
    XmlName = 'Ccy';
    }
    }
    textelement(btch_cdtdbtind)
    {
    MinOccurs = Zero;
    XmlName = 'CdtDbtInd';
    }
    }
    textelement(txdtls)
    {
    MinOccurs = Zero;
    XmlName = 'TxDtls';

    fieldelement(refs;
    ntry.TxReference)
    {
    MinOccurs = Zero;
    XmlName = 'Refs';

    fieldelement(refs_msgid;
    ntry.TxMessageId)
    {
    MinOccurs = Zero;
    XmlName = 'MsgId';
    }
    fieldelement(refs_acctsvcrref;
    ntry.TxAccountServicerRef)
    {
    MinOccurs = Zero;
    XmlName = 'AcctSvcrRef';
    }
    fieldelement(refs_pmtinfid;
    ntry.TxPmtInfid)
    {
    MinOccurs = Zero;
    XmlName = 'PmtInfId';
    }
    fieldelement(instrid;
    ntry.TxInstructionID)
    {
    MinOccurs = Zero;
    XmlName = 'InstrId';
    }
    fieldelement(endtoendid;
    ntry.TxEndtoEndId)
    {
    MinOccurs = Zero;
    XmlName = 'EndToEndId';
    }
    textelement(txid)
    {
    MinOccurs = Zero;
    XmlName = 'TxId';
    }
    textelement(mndtid)
    {
    MinOccurs = Zero;
    XmlName = 'MndtId';
    }
    textelement(chqnb)
    {
    MinOccurs = Zero;
    XmlName = 'ChqNb';
    }
    }
    textelement(amtdtls)
    {
    MinOccurs = Zero;
    XmlName = 'AmtDtls';

    textelement(instdamt)
    {
    MinOccurs = Zero;
    XmlName = 'InstdAmt';

    textelement(instdamt_amt)
    {
    MinOccurs = Zero;
    XmlName = 'Amt';

    textattribute(instdamt_amt_ccy)
    {
    Occurrence = Required;
    XmlName = 'Ccy';
    }
    }
    }
    textelement(txamt)
    {
    MinOccurs = Zero;
    XmlName = 'TxAmt';

    textelement(txamt_amt)
    {
    MinOccurs = Zero;
    XmlName = 'Amt';

    textattribute(txamt_amt_ccy)
    {
    Occurrence = Required;
    XmlName = 'Ccy';
    }
    }
    }
    }
    textelement(txdtls_bktxcd)
    {
    MinOccurs = Zero;
    XmlName = 'BkTxCd';

    textelement(bktxcd_prtry)
    {
    MinOccurs = Zero;
    XmlName = 'Prtry';

    fieldelement(bktxcd_prtry_cd;
    ntry.TxTransCode)
    {
    MinOccurs = Zero;
    XmlName = 'Cd';
    }
    fieldelement(prtry_issr;
    ntry.TxIssuer)
    {
    MinOccurs = Zero;
    XmlName = 'Issr';
    }
    }
    }
    textelement(chrgs)
    {
    MinOccurs = Zero;
    XmlName = 'Chrgs';

    textelement(chrgs_amt)
    {
    MinOccurs = Zero;
    XmlName = 'Amt';

    textattribute(chrgs_amt_ccy)
    {
    Occurrence = Required;
    XmlName = 'Ccy';
    }
    }
    }
    textelement(rltdpties)
    {
    MinOccurs = Zero;
    XmlName = 'RltdPties';

    textelement(Dbtr)
    {
    textelement(DbtrNm)
    {
    MinOccurs = Zero;
    XmlName = 'Nm';
    }
    }
    textelement(cdtr)
    {
    MinOccurs = Zero;
    XmlName = 'Cdtr';

    fieldelement(nm;
    ntry.TxName)
    {
    MinOccurs = Zero;
    XmlName = 'Nm';
    }
    }
    }
    textelement(rltdagts)
    {
    MinOccurs = Zero;
    XmlName = 'RltdAgts';

    textelement(DbtrAgt)
    {
    textelement(DbtrAgt_FinInstnId)
    {
    MinOccurs = Zero;
    XmlName = 'FinInstnId';

    textelement(DbtrAgt_clrsysmmbid)
    {
    MinOccurs = Zero;
    XmlName = 'ClrSysMmbId';

    textelement(DbtrAgt_mmbid)
    {
    MinOccurs = Zero;
    XmlName = 'MmbId';
    }
    }
    textelement(DbtrAgt_FinInstnId_Nm)
    {
    MinOccurs = Zero;
    XmlName = 'Nm';
    }
    }
    }
    textelement(cdtragt)
    {
    MinOccurs = Zero;
    XmlName = 'CdtrAgt';

    textelement(cdtragt_fininstnid)
    {
    MinOccurs = Zero;
    XmlName = 'FinInstnId';

    textelement(clrsysmmbid)
    {
    MinOccurs = Zero;
    XmlName = 'ClrSysMmbId';

    textelement(mmbid)
    {
    MinOccurs = Zero;
    XmlName = 'MmbId';
    }
    }
    }
    }
    }
    textelement(purp)
    {
    MinOccurs = Zero;
    XmlName = 'Purp';

    textelement(purp_cd)
    {
    MinOccurs = Zero;
    XmlName = 'Cd';
    }
    textelement(cdtracct)
    {
    MinOccurs = Zero;
    XmlName = 'CdtrAcct';

    textelement(cdtracct_id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';

    textelement(id_othr)
    {
    MinOccurs = Zero;
    XmlName = 'Othr';

    fieldelement(id_othr_id;
    ntry."Creditor Account Number")
    {
    MinOccurs = Zero;
    XmlName = 'Id';
    }
    }
    }
    }
    }
    textelement(rtrinf)
    {
    MinOccurs = Zero;
    XmlName = 'RtrInf';

    textelement(rsn)
    {
    MinOccurs = Zero;
    XmlName = 'Rsn';

    textelement(rsn_prtry)
    {
    MinOccurs = Zero;
    XmlName = 'Prtry';
    }
    }
    }
    textelement(rmtinf)
    {
    MinOccurs = Zero;
    XmlName = 'RmtInf';

    textelement(ustrd)
    {
    MinOccurs = Zero;
    XmlName = 'Ustrd';
    }
    }
    }
    }
    fieldelement(addtlntryinf;
    ntry."Additional Entry Information")
    {
    MinOccurs = Zero;
    XmlName = 'AddtlNtryInf';

    trigger OnAfterAssignField()
    begin
        ExtractOCMT(ntry."Additional Entry Information");
        ExtractEXCH(ntry."Additional Entry Information");
    end;
    }
    trigger OnBeforeInsertRecord()
    begin
        if Evaluate(ntry.CreateDate, stmt_credttm, 9)then;
        if Evaluate(ntry.FromDate, frdttm, 9)then;
        if Evaluate(ntry.ToDate, todttm, 9)then;
        if Evaluate(ntry.EntryBookingDate, bookgdt_dttm, 9)then;
        if Evaluate(ntry.EntryBookedDate, bookgdt_dt, 9)then;
        if Evaluate(ntry.EntryValueDate, valdt_dt, 9)then;
        ntry."Bank Account":=othr_id;
        ntry.Currency:=ccy;
        ntry.Source:=ntry.Source::"53";
        ntry."Opening Available":=g_dec_OPAV;
        ntry."Opening Booked":=g_dec_OPBD;
        ntry."Closing Booked":=g_dec_CLBD;
        ntry."Closing Available":=g_dec_CLAV;
        ntry.MsgId:=msgid;
    end;
    }
    }
    }
    }
    }
    local procedure ExtractOCMT(str: Text)
    var
        start: Integer;
        tmp: text;
        amtTxt: Text;
    begin
        start:=STRPOS(str, '/OCMT/');
        if start = 0 then exit;
        start+=STRLEN('/OCMT/');
        tmp:=COPYSTR(str, start, STRLEN(str) - start);
        ntry.TxCurrency:=COPYSTR(tmp, 1, 3);
        tmp:=COPYSTR(tmp, 4, STRLEN(tmp) - 4);
        start:=STRPOS(tmp, '/');
        amtTxt:=COPYSTR(tmp, 1, start - 1);
        amtTxt:=CONVERTSTR(amtTxt, ',', '.');
        amtTxt:=amtTxt.Replace('&#13;', '');
        EVALUATE(ntry.TxAmt, amtTxt);
    end;
    local procedure ExtractEXCH(str: Text)
    var
        start: Integer;
        tmp: text;
        amtTxt: Text;
    begin
        start:=STRPOS(str, '/EXCH/');
        if start = 0 then exit;
        start+=STRLEN('/EXCH/');
        tmp:=COPYSTR(str, start, STRLEN(str) - start);
        start:=STRPOS(tmp, '/');
        if start = 0 then amtTxt:='0'
        else
        begin
            amtTxt:=COPYSTR(tmp, 1, start - 1);
            amtTxt:=CONVERTSTR(amtTxt, ',', '.');
            amtTxt:=amtTxt.Replace('&#13;', '');
        end;
        Evaluate(ntry.XChangeRate, amtTxt);
    end;
    var g_dec_OPAV: Decimal;
    g_dec_OPBD: Decimal;
    g_dec_CLBD: Decimal;
    g_dec_CLAV: Decimal;
}
