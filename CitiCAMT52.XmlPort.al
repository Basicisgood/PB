xmlport 50111 CitiCAMT52
{
    Caption = 'CitiCAMT52';
    Direction = Import;
    Format = Xml;
    Encoding = UTF8;
    Namespaces = "" = 'urn:iso:std:iso:20022:tech:xsd:camt.052.001.02';
    UseDefaultNamespace = false;
    UseRequestPage = false;

    schema
    {
    textelement(document)
    {
    MinOccurs = Zero;
    XmlName = 'Document';

    textelement(bktocstmracctrpt)
    {
    MinOccurs = Zero;
    XmlName = 'BkToCstmrAcctRpt';

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
    textelement(msgrcpt)
    {
    MinOccurs = Zero;
    XmlName = 'MsgRcpt';

    textelement(nm)
    {
    MinOccurs = Zero;
    XmlName = 'Nm';
    }
    }
    textelement(addtlinf)
    {
    MinOccurs = Zero;
    XmlName = 'AddtlInf';
    }
    }
    textelement(rpt)
    {
    MinOccurs = Zero;
    XmlName = 'Rpt';

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
    textelement(rpt_credttm)
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

    textelement(acct_id_iban)
    {
    MinOccurs = Zero;
    XmlName = 'IBAN';
    }
    textelement(othr)
    {
    MinOccurs = Zero;
    XmlName = 'Othr';

    textelement(othr_id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';
    }
    textelement(schmenm)
    {
    MinOccurs = Zero;
    XmlName = 'SchmeNm';

    textelement(prtry)
    {
    MinOccurs = Zero;
    XmlName = 'Prtry';
    }
    }
    }
    }
    textelement(tp)
    {
    MinOccurs = Zero;
    XmlName = 'Tp';

    textelement(tp_prtry)
    {
    MinOccurs = Zero;
    XmlName = 'Prtry';
    }
    }
    textelement(ccy)
    {
    MinOccurs = Zero;
    XmlName = 'Ccy';
    }
    textelement(acct_nm)
    {
    MinOccurs = Zero;
    XmlName = 'Nm';
    }
    textelement(ownr)
    {
    MinOccurs = Zero;
    XmlName = 'Ownr';

    textelement(ownr_nm)
    {
    MinOccurs = Zero;
    XmlName = 'Nm';
    }
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
    textelement(fininstnid_nm)
    {
    MinOccurs = Zero;
    XmlName = 'Nm';
    }
    }
    textelement(brnchid)
    {
    MinOccurs = Zero;
    XmlName = 'BrnchId';

    textelement(brnchid_id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';
    }
    textelement(brnchid_nm)
    {
    MinOccurs = Zero;
    XmlName = 'Nm';
    }
    }
    }
    }
    textelement(bal)
    {
    MinOccurs = Zero;
    XmlName = 'Bal';

    textelement(bal_tp)
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
    textelement(amt)
    {
    MinOccurs = Zero;
    XmlName = 'Amt';

    textattribute(amt_ccy)
    {
    Occurrence = Required;
    XmlName = 'Ccy';
    }
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
    textelement(dttm)
    {
    MinOccurs = Zero;
    XmlName = 'DtTm';
    }
    }
    }
    textelement(txssummry)
    {
    MinOccurs = Zero;
    XmlName = 'TxsSummry';

    textelement(ttlntries)
    {
    MinOccurs = Zero;
    XmlName = 'TtlNtries';

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
    textelement(ttlnetntryamt)
    {
    MinOccurs = Zero;
    XmlName = 'TtlNetNtryAmt';
    }
    textelement(ttlntries_cdtdbtind)
    {
    MinOccurs = Zero;
    XmlName = 'CdtDbtInd';
    }
    }
    textelement(ttlcdtntries)
    {
    MinOccurs = Zero;
    XmlName = 'TtlCdtNtries';

    textelement(ttlcdtntries_nbofntries)
    {
    MinOccurs = Zero;
    XmlName = 'NbOfNtries';
    }
    textelement(ttlcdtntries_sum)
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
    textelement(ntry)
    {
    MinOccurs = Zero;
    XmlName = 'Ntry';

    textelement(ntry_amt)
    {
    MinOccurs = Zero;
    XmlName = 'Amt';

    textattribute(ntry_amt_ccy)
    {
    Occurrence = Required;
    XmlName = 'Ccy';
    }
    }
    textelement(ntry_cdtdbtind)
    {
    MinOccurs = Zero;
    XmlName = 'CdtDbtInd';
    }
    textelement(sts)
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
    textelement(acctsvcrref)
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
    textelement(bktxcd_prtry)
    {
    MinOccurs = Zero;
    XmlName = 'Prtry';

    textelement(prtry_cd)
    {
    MinOccurs = Zero;
    XmlName = 'Cd';
    }
    textelement(issr)
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

    textelement(pmtinfid)
    {
    MinOccurs = Zero;
    XmlName = 'PmtInfId';
    }
    }
    tableelement(txdtls;
    "Citi Inbound Staging")
    {
    MinOccurs = Zero;
    XmlName = 'TxDtls';

    textelement(refs)
    {
    MinOccurs = Zero;
    XmlName = 'Refs';

    fieldelement(refs_acctsvcrref;
    txdtls.TxAccountServicerRef)
    {
    MinOccurs = Zero;
    XmlName = 'AcctSvcrRef';
    }
    textelement(refs_pmtinfid)
    {
    MinOccurs = Zero;
    XmlName = 'PmtInfId';
    }
    textelement(instrid)
    {
    MinOccurs = Zero;
    XmlName = 'InstrId';
    }
    fieldelement(endtoendid;
    txdtls.TxEndtoEndId)
    {
    MinOccurs = Zero;
    XmlName = 'EndToEndId';
    }
    textelement(chqnb)
    {
    MinOccurs = Zero;
    XmlName = 'ChqNb';
    }
    textelement(clrsysref)
    {
    MinOccurs = Zero;
    XmlName = 'ClrSysRef';
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

    fieldelement(instdamt_amt;
    txdtls.EntryAmount)
    {
    MinOccurs = Zero;
    XmlName = 'Amt';

    fieldattribute(instdamt_amt_ccy;
    txdtls.EntryCurrency)
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

    fieldelement(txamt_amt;
    txdtls.TxAmt)
    {
    MinOccurs = Zero;
    XmlName = 'Amt';

    fieldattribute(txamt_amt_ccy;
    txdtls.TxCurrency)
    {
    Occurrence = Required;
    XmlName = 'Ccy';
    }
    }
    textelement(ccyxchg)
    {
    MinOccurs = Zero;
    XmlName = 'CcyXchg';

    textelement(srcccy)
    {
    MinOccurs = Zero;
    XmlName = 'SrcCcy';
    }
    textelement(trgtccy)
    {
    MinOccurs = Zero;
    XmlName = 'TrgtCcy';
    }
    fieldelement(xchgrate;
    txdtls.XChangeRate)
    {
    MinOccurs = Zero;
    XmlName = 'XchgRate';
    }
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
    textelement(chrgs_cdtdbtind)
    {
    MinOccurs = Zero;
    XmlName = 'CdtDbtInd';
    }
    textelement(chrgs_tp)
    {
    MinOccurs = Zero;
    XmlName = 'Tp';

    textelement(tp_cd)
    {
    MinOccurs = Zero;
    XmlName = 'Cd';
    }
    }
    }
    textelement(rltdpties)
    {
    MinOccurs = Zero;
    XmlName = 'RltdPties';

    textelement(dbtr)
    {
    MinOccurs = Zero;
    XmlName = 'Dbtr';

    textelement(dbtr_nm)
    {
    MinOccurs = Zero;
    XmlName = 'Nm';
    }
    textelement(dbtrpstladr)
    {
    MinOccurs = Zero;
    XmlName = 'PstlAdr';

    textelement(dbtradrtp)
    {
    MinOccurs = Zero;
    XmlName = 'AdrTp';
    }
    textelement(adrline)
    {
    MinOccurs = Zero;
    XmlName = 'AdrLine';
    }
    }
    textelement(ctctdtls)
    {
    MinOccurs = Zero;
    XmlName = 'CtctDtls';

    textelement(mobnb)
    {
    MinOccurs = Zero;
    XmlName = 'MobNb';
    }
    }
    }
    textelement(dbtracct)
    {
    MinOccurs = Zero;
    XmlName = 'DbtrAcct';

    textelement(dbtracct_id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';

    textelement(id_iban)
    {
    MinOccurs = Zero;
    XmlName = 'IBAN';
    }
    textelement(dbtrid_othr)
    {
    MinOccurs = Zero;
    XmlName = 'Othr';

    textelement(dbtrid_othr_id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';
    }
    textelement(dbtrothr_schmenm)
    {
    MinOccurs = Zero;
    XmlName = 'SchmeNm';

    textelement(dbtrschmenm_prtry)
    {
    MinOccurs = Zero;
    XmlName = 'Prtry';
    }
    }
    }
    }
    }
    textelement(ultmtdbtr)
    {
    MinOccurs = Zero;
    XmlName = 'UltmtDbtr';

    textelement(ultmtdbtr_id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';

    textelement(orgid)
    {
    MinOccurs = Zero;
    XmlName = 'OrgId';

    textelement(orgid_othr)
    {
    MinOccurs = Zero;
    XmlName = 'Othr';

    textelement(orgid_othr_id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';
    }
    textelement(othr_issr)
    {
    MinOccurs = Zero;
    XmlName = 'Issr';
    }
    }
    }
    }
    }
    textelement(cdtr)
    {
    MinOccurs = Zero;
    XmlName = 'Cdtr';

    textelement(cdtr_nm)
    {
    MinOccurs = Zero;
    XmlName = 'Nm';
    }
    textelement(cdtrpstladr)
    {
    MinOccurs = Zero;
    XmlName = 'PstlAdr';

    textelement(cdtradrtp)
    {
    MinOccurs = Zero;
    XmlName = 'AdrTp';
    }
    textelement(cdtradrline)
    {
    MinOccurs = Zero;
    XmlName = 'AdrLine';
    }
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

    textelement(iban)
    {
    MinOccurs = Zero;
    XmlName = 'IBAN';
    }
    textelement(id_othr)
    {
    MinOccurs = Zero;
    XmlName = 'Othr';

    textelement(id_othr_id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';
    }
    textelement(othr_schmenm)
    {
    MinOccurs = Zero;
    XmlName = 'SchmeNm';

    textelement(schmenm_prtry)
    {
    MinOccurs = Zero;
    XmlName = 'Prtry';
    }
    }
    }
    }
    }
    textelement(ultmtcdtr)
    {
    MinOccurs = Zero;
    XmlName = 'UltmtCdtr';

    textelement(ultmtcdtr_nm)
    {
    MinOccurs = Zero;
    XmlName = 'Nm';
    }
    textelement(ultmtcdtr_id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';

    textelement(id_orgid)
    {
    MinOccurs = Zero;
    XmlName = 'OrgId';

    textelement(bicorbei)
    {
    MinOccurs = Zero;
    XmlName = 'BICOrBEI';
    }
    textelement(id_orgid_othr)
    {
    MinOccurs = Zero;
    XmlName = 'Othr';

    textelement(id_orgid_othr_id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';
    }
    textelement(orgid_othr_issr)
    {
    MinOccurs = Zero;
    XmlName = 'Issr';
    }
    }
    }
    }
    }
    textelement(rltdpties_prtry)
    {
    MinOccurs = Zero;
    XmlName = 'Prtry';

    textelement(prtry_tp)
    {
    MinOccurs = Zero;
    XmlName = 'Tp';
    }
    textelement(pty)
    {
    MinOccurs = Zero;
    XmlName = 'Pty';

    textelement(pty_id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';

    textelement(pty_id_orgid)
    {
    MinOccurs = Zero;
    XmlName = 'OrgId';

    textelement(pty_id_orgid_othr)
    {
    MinOccurs = Zero;
    XmlName = 'Othr';

    textelement(pty_id_orgid_othr_id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';
    }
    textelement(id_orgid_othr_issr)
    {
    MinOccurs = Zero;
    XmlName = 'Issr';
    }
    }
    }
    }
    }
    }
    }
    textelement(rltdagts)
    {
    MinOccurs = Zero;
    XmlName = 'RltdAgts';

    textelement(dbtragt)
    {
    MinOccurs = Zero;
    XmlName = 'DbtrAgt';

    textelement(dbtragt_fininstnid)
    {
    MinOccurs = Zero;
    XmlName = 'FinInstnId';

    textelement(fininstnid_bic)
    {
    MinOccurs = Zero;
    XmlName = 'BIC';
    }
    textelement(fininstnid_clrsysmmbid)
    {
    MinOccurs = Zero;
    XmlName = 'ClrSysMmbId';

    textelement(clrsysmmbid_mmbid)
    {
    MinOccurs = Zero;
    XmlName = 'MmbId';
    }
    }
    textelement(dbtragt_fininstnid_nm)
    {
    MinOccurs = Zero;
    XmlName = 'Nm';
    }
    textelement(fininstnid_pstladr)
    {
    MinOccurs = Zero;
    XmlName = 'PstlAdr';

    textelement(pstladr_adrtp)
    {
    MinOccurs = Zero;
    XmlName = 'AdrTp';
    }
    textelement(pstladr_adrline)
    {
    MinOccurs = Zero;
    XmlName = 'AdrLine';
    }
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

    textelement(cdtragt_fininstnid_bic)
    {
    MinOccurs = Zero;
    XmlName = 'BIC';
    }
    textelement(cdtr_fininstnid_clrsysmmbid)
    {
    MinOccurs = Zero;
    XmlName = 'ClrSysMmbId';

    textelement(fini_clrsysmmbid_mmbid)
    {
    MinOccurs = Zero;
    XmlName = 'MmbId';
    }
    }
    textelement(cdtragt_fininstnid_nm)
    {
    MinOccurs = Zero;
    XmlName = 'Nm';
    }
    textelement(PstlAdr)
    {
    MinOccurs = Zero;

    textelement(AdrTp)
    {
    MinOccurs = Zero;
    }
    textelement(AdrLine1)
    {
    XmlName = 'AdrLine';
    MinOccurs = Zero;
    }
    }
    }
    }
    textelement(intrmyagt1)
    {
    MinOccurs = Zero;
    XmlName = 'IntrmyAgt1';

    textelement(intrmyagt1_fininstnid)
    {
    MinOccurs = Zero;
    XmlName = 'FinInstnId';

    textelement(intr_fininstnid_clrsysmmbid)
    {
    MinOccurs = Zero;
    XmlName = 'ClrSysMmbId';

    textelement(intr_fini_clrsysmmbid_mmbid)
    {
    MinOccurs = Zero;
    XmlName = 'MmbId';
    }
    }
    textelement(intrmyagt1_fininstnid_nm)
    {
    MinOccurs = Zero;
    XmlName = 'Nm';
    }
    textelement(intr_fininstnid_pstladr)
    {
    MinOccurs = Zero;
    XmlName = 'PstlAdr';

    textelement(intr_fininstnid_pstladr_adr)
    {
    MinOccurs = Zero;
    XmlName = 'AdrTp';
    }
    textelement(intr_fininstnid_pstladr_adr1)
    {
    MinOccurs = Zero;
    XmlName = 'AdrLine';
    }
    }
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
    textelement(cdtrrefinf)
    {
    MinOccurs = Zero;
    XmlName = 'CdtrRefInf';

    textelement(cdtrrefinf_tp)
    {
    MinOccurs = Zero;
    XmlName = 'Tp';

    textelement(tp_cdorprtry)
    {
    MinOccurs = Zero;
    XmlName = 'CdOrPrtry';

    textelement(cdorprtry_cd)
    {
    MinOccurs = Zero;
    XmlName = 'Cd';
    }
    textelement(cdorprtry_prtry)
    {
    MinOccurs = Zero;
    XmlName = 'Prtry';
    }
    }
    textelement(tp_issr)
    {
    MinOccurs = Zero;
    XmlName = 'Issr';
    }
    }
    textelement(ref)
    {
    MinOccurs = Zero;
    XmlName = 'Ref';
    }
    }
    }
    textelement(rltddts)
    {
    MinOccurs = Zero;
    XmlName = 'RltdDts';

    textelement(accptncdttm)
    {
    MinOccurs = Zero;
    XmlName = 'AccptncDtTm';
    }
    textelement(txdttm)
    {
    MinOccurs = Zero;
    XmlName = 'TxDtTm';
    }
    }
    textelement(addtltxinf)
    {
    MinOccurs = Zero;
    XmlName = 'AddtlTxInf';
    }
    trigger OnBeforeInsertRecord()
    begin
        if Evaluate(txdtls.CreateDate, rpt_credttm, 9)then;
        if Evaluate(txdtls.FromDate, frdttm, 9)then;
        if Evaluate(txdtls.ToDate, todttm, 9)then;
        txdtls."Bank Account":=othr_id;
        txdtls.Currency:=ccy;
        if Evaluate(txdtls.EntryBookedDate, bookgdt_dt, 9)then;
        if Evaluate(txdtls.EntryValueDate, valdt_dt, 9)then;
        txdtls.Source:=txdtls.Source::"52";
        if txdtls.EntryAmount = 0 then begin
            txdtls.EntryAmount:=txdtls.TxAmt;
            txdtls.EntryCurrency:=txdtls.TxCurrency;
        end;
        txdtls.EntryCrDrInd:=ntry_cdtdbtind;
        txdtls.EntryStatus:=sts;
        txdtls.EntryAccountServRef:=acctsvcrref;
        txdtls.EntryTransCode:=CopyStr(prtry_cd, 1, 3);
        txdtls.EntryIssuer:=issr;
        txdtls."Statement Id":=msgid;
    end;
    }
    }
    textelement(addtlntryinf)
    {
    MinOccurs = Zero;
    XmlName = 'AddtlNtryInf';

    trigger OnAfterAssignVariable()
    var
        l_rec_CITIInbound: Record "Citi Inbound Staging";
    begin
        l_rec_CITIInbound.Reset();
        l_rec_CITIInbound.SetRange(TxEndtoEndId, instrid);
        if l_rec_CITIInbound.FindFirst()then repeat l_rec_CITIInbound."Additional Entry Information":=addtlntryinf;
                l_rec_CITIInbound.Modify();
            until l_rec_CITIInbound.Next() = 0;
    end;
    }
    }
    }
    }
    }
    }
}
