xmlport 50110 CitiCAMT53
{
    Caption = 'CitiCAMT53';
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
    textelement(MsgPgntn)
    {
    MinOccurs = Zero;

    textelement(PgNb)
    {
    MinOccurs = Zero;
    }
    textelement(LastPgInd)
    {
    MinOccurs = Zero;
    }
    }
    textelement(addtlinf)
    {
    MinOccurs = Zero;
    XmlName = 'AddtlInf';
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
    textelement(rptgsrc)
    {
    MinOccurs = Zero;
    XmlName = 'RptgSrc';

    textelement(cd)
    {
    MinOccurs = Zero;
    XmlName = 'Cd';
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

    textelement(iban)
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

    textelement(cdorprtry_cd)
    {
    MinOccurs = Zero;
    XmlName = 'Cd';
    }
    }
    }
    textelement(CdtLine)
    {
    MinOccurs = Zero;

    textelement(Incl)
    {
    MinOccurs = Zero;
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
        case cdorprtry_cd of 'OPAV': Evaluate(g_dec_OPAV, amt);
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

    textelement(ntryref)
    {
    MinOccurs = Zero;
    XmlName = 'NtryRef';
    }
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
    textelement(RvslInd)
    {
    MinOccurs = Zero;
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
    textelement(bktxcd_issr)
    {
    MinOccurs = Zero;
    XmlName = 'Issr';
    /* trigger OnAfterAssignField()
                                    begin
                                        if ntry.EntryIssuer = 'CITI' then
                                            ntry."MSC DESC" := prtry_cd;
                                        if ntry.EntryIssuer = 'BAI' then
                                            ntry.EntryTransCode := CopyStr(prtry_cd, 1, 3);
                                    end; */
    }
    }
    }
    textelement(ntrydtls)
    {
    MinOccurs = Zero;
    XmlName = 'NtryDtls';

    textelement(Btch)
    {
    MinOccurs = Zero;

    textelement(pmtinfid)
    {
    MinOccurs = Zero;
    XmlName = 'PmtInfId';
    }
    textelement(NbOfTxs)
    {
    MinOccurs = Zero;
    }
    textelement(TtlAmt)
    {
    MinOccurs = Zero;

    textattribute(Btch_Ccy)
    {
    XmlName = 'Ccy';
    }
    }
    textelement(Btch_CdtDbtInd)
    {
    XmlName = 'CdtDbtInd';
    MinOccurs = Zero;
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

    textelement(RefsMsgId)
    {
    XmlName = 'MsgId';
    MinOccurs = Zero;
    }
    textelement(refs_acctsvcrref)
    {
    MinOccurs = Zero;
    XmlName = 'AcctSvcrRef';

    trigger OnAfterAssignVariable()
    begin
        txdtls.TxAccountServicerRef:=refs_acctsvcrref;
    end;
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
    textelement(TxId)
    {
    MinOccurs = Zero;
    }
    textelement(MndtId)
    {
    MinOccurs = Zero;
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
    textelement(refs_prtry)
    {
    MinOccurs = Zero;
    XmlName = 'Prtry';

    textelement(prtry_tp)
    {
    MinOccurs = Zero;
    XmlName = 'Tp';
    }
    textelement(ref)
    {
    MinOccurs = Zero;
    XmlName = 'Ref';
    }
    }
    trigger OnAfterAssignVariable()
    begin
        txdtls.TxReference:=refs;
    end;
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
    textelement(inst_ccyxchg)
    {
    MinOccurs = Zero;
    XmlName = 'CcyXchg';

    textelement(xchgrate)
    {
    MinOccurs = Zero;
    XmlName = 'XchgRate';
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
    textelement(CtrctId)
    {
    MinOccurs = Zero;
    }
    }
    }
    }
    textelement(BkTxCd1)
    {
    XmlName = 'BkTxCd';
    MinOccurs = Zero;

    textelement(Prtry1)
    {
    XmlName = 'Prtry';
    MinOccurs = Zero;

    textelement(Cd1)
    {
    XmlName = 'Cd';
    MinOccurs = Zero;
    }
    textelement(Issr)
    {
    MinOccurs = Zero;
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
    textelement(pstladr)
    {
    MinOccurs = Zero;
    XmlName = 'PstlAdr';

    textelement(adrtp)
    {
    MinOccurs = Zero;
    XmlName = 'AdrTp';
    }
    textelement(PstlAdr_Ctry)
    {
    MinOccurs = Zero;
    XmlName = 'Ctry';
    }
    textelement(adrline)
    {
    MinOccurs = Zero;
    XmlName = 'AdrLine';
    }
    }
    textelement(dbtr_id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';

    textelement(orgid)
    {
    MinOccurs = Zero;
    XmlName = 'OrgId';

    textelement(bicorbei)
    {
    MinOccurs = Zero;
    XmlName = 'BICOrBEI';
    }
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
    textelement(prvtid)
    {
    MinOccurs = Zero;
    XmlName = 'PrvtId';

    textelement(prvtid_othr)
    {
    MinOccurs = Zero;
    XmlName = 'Othr';

    textelement(prvtid_othr_id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';
    }
    textelement(prvtid_othr_issr)
    {
    MinOccurs = Zero;
    XmlName = 'Issr';
    }
    }
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

    textelement(schmenm_cd)
    {
    MinOccurs = Zero;
    XmlName = 'Cd';
    }
    textelement(schmenm_prtry)
    {
    MinOccurs = Zero;
    XmlName = 'Prtry';
    }
    }
    }
    }
    textelement(dbtracct_ccy)
    {
    MinOccurs = Zero;
    XmlName = 'Ccy';
    }
    }
    textelement(ultmtdbtr)
    {
    MinOccurs = Zero;
    XmlName = 'UltmtDbtr';

    textelement(ultmtdbtr_nm)
    {
    MinOccurs = Zero;
    XmlName = 'Nm';
    }
    textelement(ultmtdbtr_id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';

    textelement(id_orgid)
    {
    MinOccurs = Zero;
    XmlName = 'OrgId';

    textelement(orgid_bicorbei)
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
    textelement(id_prvtid)
    {
    MinOccurs = Zero;
    XmlName = 'PrvtId';

    textelement(id_prvtid_othr)
    {
    MinOccurs = Zero;
    XmlName = 'Othr';

    textelement(id_prvtid_othr_id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';
    }
    textelement(id_prvtid_othr_issr)
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

    fieldelement(cdtr_nm;
    txdtls."Creditor Name")
    {
    MinOccurs = Zero;
    XmlName = 'Nm';
    }
    textelement(cdtr_pstladr)
    {
    MinOccurs = Zero;
    XmlName = 'PstlAdr';

    textelement(pstladr_adrtp)
    {
    MinOccurs = Zero;
    XmlName = 'AdrTp';
    }
    textelement(ctry)
    {
    MinOccurs = Zero;
    XmlName = 'Ctry';
    }
    textelement(pstladr_adrline)
    {
    MinOccurs = Zero;
    XmlName = 'AdrLine';
    }
    }
    textelement(cdtr_id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';

    textelement(cdtr_id_orgid)
    {
    MinOccurs = Zero;
    XmlName = 'OrgId';

    textelement(id_orgid_bicorbei)
    {
    MinOccurs = Zero;
    XmlName = 'BICOrBEI';
    }
    textelement(cdtr_id_orgid_othr)
    {
    MinOccurs = Zero;
    XmlName = 'Othr';

    textelement(cdtr_id_orgid_othr_id)
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
    textelement(cdtr_id_prvtid)
    {
    MinOccurs = Zero;
    XmlName = 'PrvtId';

    textelement(cdtr_id_prvtid_othr)
    {
    MinOccurs = Zero;
    XmlName = 'Othr';

    textelement(cdtr_id_prvtid_othr_id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';
    }
    textelement(cdtr_id_prvtid_othr_issr)
    {
    MinOccurs = Zero;
    XmlName = 'Issr';
    }
    }
    }
    }
    textelement(cdtr_ctctdtls)
    {
    MinOccurs = Zero;
    XmlName = 'CtctDtls';

    textelement(ctctdtls_othr)
    {
    MinOccurs = Zero;
    XmlName = 'Othr';
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

    textelement(cdtracct_id_iban)
    {
    MinOccurs = Zero;
    XmlName = 'IBAN';
    }
    textelement(cdtracct_id_othr)
    {
    MinOccurs = Zero;
    XmlName = 'Othr';

    textelement(cdtracct_id_othr_id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';
    }
    textelement(id_othr_schmenm)
    {
    MinOccurs = Zero;
    XmlName = 'SchmeNm';

    textelement(othr_schmenm_cd)
    {
    MinOccurs = Zero;
    XmlName = 'Cd';
    }
    textelement(othr_schmenm_prtry)
    {
    MinOccurs = Zero;
    XmlName = 'Prtry';
    }
    }
    }
    }
    textelement(cdtracct_ccy)
    {
    MinOccurs = Zero;
    XmlName = 'Ccy';
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

    textelement(ultmtcdtr_id_orgid)
    {
    MinOccurs = Zero;
    XmlName = 'OrgId';

    textelement(ultmtcdtr_id_orgid_bicorbei)
    {
    MinOccurs = Zero;
    XmlName = 'BICOrBEI';
    }
    textelement(ultmtcdtr_id_orgid_othr)
    {
    MinOccurs = Zero;
    XmlName = 'Othr';

    textelement(ultmtcdtr_id_orgid_othr_id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';
    }
    textelement(ultm_id_orgid_othr_issr)
    {
    MinOccurs = Zero;
    XmlName = 'Issr';
    }
    }
    }
    textelement(ultmtcdtr_id_prvtid)
    {
    MinOccurs = Zero;
    XmlName = 'PrvtId';

    textelement(ultmtcdtr_id_prvtid_othr)
    {
    MinOccurs = Zero;
    XmlName = 'Othr';

    textelement(ultmtcdtr_id_prvtid_othr_id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';
    }
    textelement(ultm_id_prvtid_othr_issr)
    {
    MinOccurs = Zero;
    XmlName = 'Issr';
    }
    }
    }
    }
    textelement(ultmtcdtr_ctctdtls)
    {
    MinOccurs = Zero;
    XmlName = 'CtctDtls';

    textelement(ultmtcdtr_ctctdtls_othr)
    {
    MinOccurs = Zero;
    XmlName = 'Othr';
    }
    }
    }
    textelement(rltdpties_prtry)
    {
    MinOccurs = Zero;
    XmlName = 'Prtry';

    textelement(rltdpties_prtry_tp)
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
    textelement(pty_id_orgid_othr_issr)
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

    textelement(fininstnid_pstladr_adrtp)
    {
    MinOccurs = Zero;
    XmlName = 'AdrTp';
    }
    textelement(fin_PstlAdr_Ctry)
    {
    MinOccurs = Zero;
    XmlName = 'Ctry';
    }
    textelement(fininstnid_pstladr_adrline)
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
    textelement(cdtragt_ClrSysMmbId)
    {
    XmlName = 'ClrSysMmbId';
    MinOccurs = Zero;

    textelement(cdtragt_MmbId)
    {
    XmlName = 'MmbId';
    MinOccurs = Zero;
    }
    }
    fieldelement(cdtragt_fininstnid_nm;
    txdtls."Creditor Agent Name")
    {
    MinOccurs = Zero;
    XmlName = 'Nm';
    }
    textelement(cdtragt_fininstnid_pstladr)
    {
    MinOccurs = Zero;
    XmlName = 'PstlAdr';

    textelement(cdtr_fininstnid_pstladr_adr)
    {
    MinOccurs = Zero;
    XmlName = 'AdrTp';
    }
    textelement(cdtr_fininstnid_pstladr_adr1)
    {
    MinOccurs = Zero;
    XmlName = 'AdrLine';
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

    textelement(intrmyagt1_fininstnid_bic)
    {
    MinOccurs = Zero;
    XmlName = 'BIC';
    }
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
    textelement(Purp)
    {
    MinOccurs = Zero;

    textelement(Purp_Cd)
    {
    XmlName = 'Cd';
    MinOccurs = Zero;
    }
    textelement(purp_prtry)
    {
    MinOccurs = Zero;
    XmlName = 'Prtry';
    }
    }
    textelement(rltdrmtinf)
    {
    MinOccurs = Zero;
    XmlName = 'RltdRmtInf';

    textelement(rmtid)
    {
    MinOccurs = Zero;
    XmlName = 'RmtId';
    }
    textelement(rmtlctnmtd)
    {
    MinOccurs = Zero;
    XmlName = 'RmtLctnMtd';
    }
    textelement(rmtlctnelctrncadr)
    {
    MinOccurs = Zero;
    XmlName = 'RmtLctnElctrncAdr';
    }
    textelement(rmtlctnpstladr)
    {
    MinOccurs = Zero;
    XmlName = 'RmtLctnPstlAdr';

    textelement(rmtlctnpstladr_nm)
    {
    MinOccurs = Zero;
    XmlName = 'Nm';
    }
    textelement(adr)
    {
    MinOccurs = Zero;
    XmlName = 'Adr';

    textelement(adr_adrtp)
    {
    MinOccurs = Zero;
    XmlName = 'AdrTp';
    }
    textelement(dept)
    {
    MinOccurs = Zero;
    XmlName = 'Dept';
    }
    textelement(subdept)
    {
    MinOccurs = Zero;
    XmlName = 'SubDept';
    }
    textelement(strtnm)
    {
    MinOccurs = Zero;
    XmlName = 'StrtNm';
    }
    textelement(bldgnb)
    {
    MinOccurs = Zero;
    XmlName = 'BldgNb';
    }
    textelement(pstcd)
    {
    MinOccurs = Zero;
    XmlName = 'PstCd';
    }
    textelement(twnnm)
    {
    MinOccurs = Zero;
    XmlName = 'TwnNm';
    }
    textelement(ctrysubdvsn)
    {
    MinOccurs = Zero;
    XmlName = 'CtrySubDvsn';
    }
    textelement(adr_ctry)
    {
    MinOccurs = Zero;
    XmlName = 'Ctry';
    }
    textelement(adr_adrline)
    {
    MinOccurs = Zero;
    XmlName = 'AdrLine';
    }
    }
    }
    }
    textelement(rmtinf)
    {
    MinOccurs = Zero;
    XmlName = 'RmtInf';

    // fieldelement(Ustrd; txdtls."Remittance Information")
    // {
    //     MinOccurs = Zero;
    //     XmlName = 'Ustrd';
    // }
    textelement(ustrd)
    {
    XmlName = 'Ustrd';
    MinOccurs = Zero;

    trigger OnAfterAssignVariable()
    begin
        txdtls."Remittance Information":=ustrd;
    end;
    }
    textelement(strd)
    {
    MinOccurs = Zero;
    XmlName = 'Strd';

    textelement(rfrddocinf)
    {
    MinOccurs = Zero;
    XmlName = 'RfrdDocInf';

    textelement(rfrddocinf_tp)
    {
    MinOccurs = Zero;
    XmlName = 'Tp';

    textelement(tp_cdorprtry)
    {
    MinOccurs = Zero;
    XmlName = 'CdOrPrtry';

    textelement(tp_cdorprtry_cd)
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
    textelement(nb)
    {
    MinOccurs = Zero;
    XmlName = 'Nb';
    }
    textelement(rltddt)
    {
    MinOccurs = Zero;
    XmlName = 'RltdDt';
    }
    }
    textelement(rfrddocamt)
    {
    MinOccurs = Zero;
    XmlName = 'RfrdDocAmt';

    textelement(duepyblamt)
    {
    MinOccurs = Zero;
    XmlName = 'DuePyblAmt';

    textattribute(duepyblamt_ccy)
    {
    Occurrence = Required;
    XmlName = 'Ccy';
    }
    }
    textelement(dscntapldamt)
    {
    MinOccurs = Zero;
    XmlName = 'DscntApldAmt';

    textattribute(dscntapldamt_ccy)
    {
    Occurrence = Required;
    XmlName = 'Ccy';
    }
    }
    textelement(cdtnoteamt)
    {
    MinOccurs = Zero;
    XmlName = 'CdtNoteAmt';

    textattribute(cdtnoteamt_ccy)
    {
    Occurrence = Required;
    XmlName = 'Ccy';
    }
    }
    textelement(adjstmntamtandrsn)
    {
    MinOccurs = Zero;
    XmlName = 'AdjstmntAmtAndRsn';

    textelement(adjstmntamtandrsn_amt)
    {
    MinOccurs = Zero;
    XmlName = 'Amt';

    textattribute(adjstmntamtandrsn_amt_ccy)
    {
    Occurrence = Required;
    XmlName = 'Ccy';
    }
    }
    textelement(adjstmntamtandrsn_cdtdbtind)
    {
    MinOccurs = Zero;
    XmlName = 'CdtDbtInd';
    }
    textelement(rsn)
    {
    MinOccurs = Zero;
    XmlName = 'Rsn';
    }
    textelement(adjstmntamtandrsn_addtlinf)
    {
    MinOccurs = Zero;
    XmlName = 'AddtlInf';
    }
    }
    textelement(rmtdamt)
    {
    MinOccurs = Zero;
    XmlName = 'RmtdAmt';

    textattribute(rmtdamt_ccy)
    {
    Occurrence = Required;
    XmlName = 'Ccy';
    }
    }
    }
    textelement(cdtrrefinf)
    {
    MinOccurs = Zero;
    XmlName = 'CdtrRefInf';

    textelement(cdtrrefinf_tp)
    {
    MinOccurs = Zero;
    XmlName = 'Tp';

    textelement(cdtrrefinf_tp_cdorprtry)
    {
    MinOccurs = Zero;
    XmlName = 'CdOrPrtry';

    textelement(cdtrrefinf_tp_cdorprtry_cd)
    {
    MinOccurs = Zero;
    XmlName = 'Cd';
    }
    textelement(tp_cdorprtry_prtry)
    {
    MinOccurs = Zero;
    XmlName = 'Prtry';
    }
    }
    textelement(cdtrrefinf_tp_issr)
    {
    MinOccurs = Zero;
    XmlName = 'Issr';
    }
    }
    textelement(cdtrrefinf_ref)
    {
    MinOccurs = Zero;
    XmlName = 'Ref';
    }
    }
    textelement(invcr)
    {
    MinOccurs = Zero;
    XmlName = 'Invcr';

    textelement(invcr_nm)
    {
    MinOccurs = Zero;
    XmlName = 'Nm';
    }
    textelement(invcr_pstladr)
    {
    MinOccurs = Zero;
    XmlName = 'PstlAdr';

    textelement(invcr_pstladr_adrtp)
    {
    MinOccurs = Zero;
    XmlName = 'AdrTp';
    }
    textelement(pstladr_dept)
    {
    MinOccurs = Zero;
    XmlName = 'Dept';
    }
    textelement(pstladr_subdept)
    {
    MinOccurs = Zero;
    XmlName = 'SubDept';
    }
    textelement(pstladr_strtnm)
    {
    MinOccurs = Zero;
    XmlName = 'StrtNm';
    }
    textelement(pstladr_bldgnb)
    {
    MinOccurs = Zero;
    XmlName = 'BldgNb';
    }
    textelement(pstladr_pstcd)
    {
    MinOccurs = Zero;
    XmlName = 'PstCd';
    }
    textelement(pstladr_twnnm)
    {
    MinOccurs = Zero;
    XmlName = 'TwnNm';
    }
    textelement(pstladr_ctrysubdvsn)
    {
    MinOccurs = Zero;
    XmlName = 'CtrySubDvsn';
    }
    textelement(invvcr_pstladr_ctry)
    {
    MinOccurs = Zero;
    XmlName = 'Ctry';
    }
    textelement(invcr_pstladr_adrline)
    {
    MinOccurs = Zero;
    XmlName = 'AdrLine';
    }
    }
    textelement(invcr_id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';

    textelement(invcr_id_orgid)
    {
    MinOccurs = Zero;
    XmlName = 'OrgId';

    textelement(invcr_id_orgid_bicorbei)
    {
    MinOccurs = Zero;
    XmlName = 'BICOrBEI';
    }
    textelement(invcr_id_orgid_othr)
    {
    MinOccurs = Zero;
    XmlName = 'Othr';

    textelement(invcr_id_orgid_othr_id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';
    }
    textelement(orgid_othr_schmenm)
    {
    MinOccurs = Zero;
    XmlName = 'SchmeNm';

    textelement(orgid_othr_schmenm_cd)
    {
    MinOccurs = Zero;
    XmlName = 'Cd';
    }
    textelement(orgid_othr_schmenm_prtry)
    {
    MinOccurs = Zero;
    XmlName = 'Prtry';
    }
    }
    textelement(invcr_id_orgid_othr_issr)
    {
    MinOccurs = Zero;
    XmlName = 'Issr';
    }
    }
    }
    textelement(invcr_id_prvtid)
    {
    MinOccurs = Zero;
    XmlName = 'PrvtId';

    textelement(dtandplcofbirth)
    {
    MinOccurs = Zero;
    XmlName = 'DtAndPlcOfBirth';

    textelement(birthdt)
    {
    MinOccurs = Zero;
    XmlName = 'BirthDt';
    }
    textelement(prvcofbirth)
    {
    MinOccurs = Zero;
    XmlName = 'PrvcOfBirth';
    }
    textelement(cityofbirth)
    {
    MinOccurs = Zero;
    XmlName = 'CityOfBirth';
    }
    textelement(ctryofbirth)
    {
    MinOccurs = Zero;
    XmlName = 'CtryOfBirth';
    }
    }
    textelement(invcr_id_prvtid_othr)
    {
    MinOccurs = Zero;
    XmlName = 'Othr';

    textelement(invcr_id_prvtid_othr_id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';
    }
    textelement(prvtid_othr_schmenm)
    {
    MinOccurs = Zero;
    XmlName = 'SchmeNm';

    textelement(prvtid_othr_schmenm_cd)
    {
    MinOccurs = Zero;
    XmlName = 'Cd';
    }
    textelement(prvtid_othr_schmenm_prtry)
    {
    MinOccurs = Zero;
    XmlName = 'Prtry';
    }
    }
    textelement(invcr_id_prvtid_othr_issr)
    {
    MinOccurs = Zero;
    XmlName = 'Issr';
    }
    }
    }
    }
    textelement(ctryofres)
    {
    MinOccurs = Zero;
    XmlName = 'CtryOfRes';
    }
    }
    textelement(invcee)
    {
    MinOccurs = Zero;
    XmlName = 'Invcee';

    textelement(invcee_nm)
    {
    MinOccurs = Zero;
    XmlName = 'Nm';
    }
    textelement(invcee_pstladr)
    {
    MinOccurs = Zero;
    XmlName = 'PstlAdr';

    textelement(invcee_pstladr_adrtp)
    {
    MinOccurs = Zero;
    XmlName = 'AdrTp';
    }
    textelement(invcee_pstladr_dept)
    {
    MinOccurs = Zero;
    XmlName = 'Dept';
    }
    textelement(invcee_pstladr_subdept)
    {
    MinOccurs = Zero;
    XmlName = 'SubDept';
    }
    textelement(invcee_pstladr_strtnm)
    {
    MinOccurs = Zero;
    XmlName = 'StrtNm';
    }
    textelement(invcee_pstladr_bldgnb)
    {
    MinOccurs = Zero;
    XmlName = 'BldgNb';
    }
    textelement(invcee_pstladr_pstcd)
    {
    MinOccurs = Zero;
    XmlName = 'PstCd';
    }
    textelement(invcee_pstladr_twnnm)
    {
    MinOccurs = Zero;
    XmlName = 'TwnNm';
    }
    textelement(invcee_pstladr_ctrysubdvsn)
    {
    MinOccurs = Zero;
    XmlName = 'CtrySubDvsn';
    }
    textelement(invcee_pstladr_ctry)
    {
    MinOccurs = Zero;
    XmlName = 'Ctry';
    }
    textelement(invcee_pstladr_adrline)
    {
    MinOccurs = Zero;
    XmlName = 'AdrLine';
    }
    }
    textelement(invcee_id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';

    textelement(invcee_id_orgid)
    {
    MinOccurs = Zero;
    XmlName = 'OrgId';

    textelement(invcee_id_orgid_bicorbei)
    {
    MinOccurs = Zero;
    XmlName = 'BICOrBEI';
    }
    textelement(invcee_id_orgid_othr)
    {
    MinOccurs = Zero;
    XmlName = 'Othr';

    textelement(invcee_id_orgid_othr_id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';
    }
    textelement(id_orgid_othr_schmenm)
    {
    MinOccurs = Zero;
    XmlName = 'SchmeNm';

    textelement(id_orgid_othr_schmenm_cd)
    {
    MinOccurs = Zero;
    XmlName = 'Cd';
    }
    textelement(id_orgid_othr_schmenm_prtry)
    {
    MinOccurs = Zero;
    XmlName = 'Prtry';
    }
    }
    textelement(invcee_id_orgid_othr_issr)
    {
    MinOccurs = Zero;
    XmlName = 'Issr';
    }
    }
    }
    textelement(invcee_id_prvtid)
    {
    MinOccurs = Zero;
    XmlName = 'PrvtId';

    textelement(prvtid_dtandplcofbirth)
    {
    MinOccurs = Zero;
    XmlName = 'DtAndPlcOfBirth';

    textelement(dtandplcofbirth_birthdt)
    {
    MinOccurs = Zero;
    XmlName = 'BirthDt';
    }
    textelement(dtandplcofbirth_prvcofbirth)
    {
    MinOccurs = Zero;
    XmlName = 'PrvcOfBirth';
    }
    textelement(dtandplcofbirth_cityofbirth)
    {
    MinOccurs = Zero;
    XmlName = 'CityOfBirth';
    }
    textelement(dtandplcofbirth_ctryofbirth)
    {
    MinOccurs = Zero;
    XmlName = 'CtryOfBirth';
    }
    }
    textelement(invcee_id_prvtid_othr)
    {
    MinOccurs = Zero;
    XmlName = 'Othr';

    textelement(invcee_id_prvtid_othr_id)
    {
    MinOccurs = Zero;
    XmlName = 'Id';
    }
    textelement(id_prvtid_othr_schmenm)
    {
    MinOccurs = Zero;
    XmlName = 'SchmeNm';

    textelement(id_prvtid_othr_schmenm_cd)
    {
    MinOccurs = Zero;
    XmlName = 'Cd';
    }
    textelement(id_prvtid_othr_schmenm_prtr)
    {
    MinOccurs = Zero;
    XmlName = 'Prtry';
    }
    }
    textelement(invcee_id_prvtid_othr_issr)
    {
    MinOccurs = Zero;
    XmlName = 'Issr';
    }
    }
    }
    }
    textelement(invcee_ctryofres)
    {
    MinOccurs = Zero;
    XmlName = 'CtryOfRes';
    }
    textelement(invcee_ctctdtls)
    {
    MinOccurs = Zero;
    XmlName = 'CtctDtls';

    textelement(ctctdtls_nm)
    {
    MinOccurs = Zero;
    XmlName = 'Nm';
    }
    textelement(phnenb)
    {
    MinOccurs = Zero;
    XmlName = 'PhneNb';
    }
    textelement(ctctdtls_mobnb)
    {
    MinOccurs = Zero;
    XmlName = 'MobNb';
    }
    textelement(faxnb)
    {
    MinOccurs = Zero;
    XmlName = 'FaxNb';
    }
    textelement(emailadr)
    {
    MinOccurs = Zero;
    XmlName = 'EmailAdr';
    }
    textelement(invcee_ctctdtls_othr)
    {
    MinOccurs = Zero;
    XmlName = 'Othr';
    }
    }
    }
    textelement(addtlrmtinf)
    {
    MinOccurs = Zero;
    XmlName = 'AddtlRmtInf';
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
    textelement(startdt)
    {
    MinOccurs = Zero;
    XmlName = 'StartDt';
    }
    textelement(txdttm)
    {
    MinOccurs = Zero;
    XmlName = 'TxDtTm';
    }
    textelement(rltddts_prtry)
    {
    MinOccurs = Zero;
    XmlName = 'Prtry';

    textelement(rltddts_prtry_tp)
    {
    MinOccurs = Zero;
    XmlName = 'Tp';
    }
    }
    }
    textelement(rtrinf)
    {
    MinOccurs = Zero;
    XmlName = 'RtrInf';

    textelement(rtrinf_rsn)
    {
    MinOccurs = Zero;
    XmlName = 'Rsn';

    textelement(rsn_cd)
    {
    MinOccurs = Zero;
    XmlName = 'Cd';
    }
    textelement(rsn_prtry)
    {
    MinOccurs = Zero;
    XmlName = 'Prtry';
    }
    }
    textelement(rtrinf_addtlinf)
    {
    MinOccurs = Zero;
    XmlName = 'AddtlInf';
    }
    }
    textelement(addtltxinf)
    {
    MinOccurs = Zero;
    XmlName = 'AddtlTxInf';
    }
    trigger OnBeforeInsertRecord()
    begin
        if Evaluate(txdtls.CreateDate, stmt_credttm, 9)then;
        if Evaluate(txdtls.FromDate, frdttm, 9)then;
        if Evaluate(txdtls.ToDate, todttm, 9)then;
        if Evaluate(txdtls.EntryBookedDate, bookgdt_dt, 9)then;
        if Evaluate(txdtls.EntryValueDate, valdt_dt, 9)then;
        txdtls."Bank Account":=othr_id;
        txdtls.Currency:=ccy;
        txdtls.Source:=txdtls.Source::"53";
        txdtls."Entry Reference":=ntryref;
        if txdtls.EntryAmount = 0 then begin
            txdtls.EntryAmount:=txdtls.TxAmt;
            txdtls.EntryCurrency:=txdtls.TxCurrency;
        end;
        txdtls.EntryCrDrInd:=ntry_cdtdbtind;
        txdtls.EntryStatus:=sts;
        txdtls.EntryAccountServRef:=acctsvcrref;
        txdtls.EntryIssuer:=bktxcd_issr;
        if bktxcd_issr = 'CITI' then txdtls."MSC DESC":=prtry_cd;
        if bktxcd_issr = 'BAI' then txdtls.EntryTransCode:=CopyStr(prtry_cd, 1, 3);
        txdtls."Opening Available":=g_dec_OPAV;
        txdtls."Opening Booked":=g_dec_OPBD;
        txdtls."Closing Booked":=g_dec_CLBD;
        txdtls."Closing Available":=g_dec_CLAV;
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
        l_rec_CITIInbound.SetRange("Entry Reference", ntryref);
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
    var g_dec_OPAV: Decimal;
    g_dec_OPBD: Decimal;
    g_dec_CLBD: Decimal;
    g_dec_CLAV: Decimal;
}
