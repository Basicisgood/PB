xmlport 50107 "HSBC Inbound CAMT 52"
{
    Caption = 'HSBC Inbound CAMT 52';
    Direction = Import;
    Format = Xml;
    Encoding = UTF8;
    Namespaces = "" = 'urn:iso:std:iso:20022:tech:xsd:camt.052.001.02', "xsi" = 'http://www.w3.org/2001/XMLSchema-instance';
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
    textelement(addtlinf)
    {
    MinOccurs = Zero;
    XmlName = 'AddtlInf';
    }
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
    textelement(ElctrncSeqNb)
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
    }
    textelement(bal_amt)
    {
    MinOccurs = Zero;
    XmlName = 'Amt';

    textattribute(bal_amt_ccy)
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
    fieldelement(amt;
    ntry.EntryAmount)
    {
    MinOccurs = Zero;
    XmlName = 'Amt';

    fieldattribute(amt_ccy;
    ntry.EntryCurrency)
    {
    Occurrence = Required;
    XmlName = 'Ccy';
    }
    }
    fieldelement(cdtdbtind;
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

    textelement(bookgdtdt)
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

    textelement(txdtls)
    {
    MinOccurs = Zero;
    XmlName = 'TxDtls';

    textelement(refs)
    {
    MinOccurs = Zero;
    XmlName = 'Refs';

    fieldelement(refs_acctsvcrref;
    ntry.TxAccountServicerRef)
    {
    MinOccurs = Zero;
    XmlName = 'AcctSvcrRef';
    }
    fieldelement(endtoendid;
    ntry.TxEndtoEndId)
    {
    MinOccurs = Zero;
    XmlName = 'EndToEndId';
    }
    textelement(TxId)
    {
    MinOccurs = Zero;
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
    textelement(TxAmt)
    {
    MinOccurs = Zero;

    textelement(TxAmt_Amt)
    {
    MinOccurs = Zero;
    XmlName = 'Amt';

    textattribute(TxAmt_Amt_Ccy)
    {
    XmlName = 'Ccy';
    }
    }
    }
    }
    textelement(Tx_BkTxCd)
    {
    MinOccurs = Zero;
    XmlName = 'BkTxCd';

    textelement(Tx_Prtry)
    {
    MinOccurs = Zero;
    XmlName = 'Prtry';

    textelement(Tx_Cd)
    {
    MinOccurs = Zero;
    XmlName = 'Cd';
    }
    textelement(Tx_Issr)
    {
    MinOccurs = Zero;
    XmlName = 'Issr';
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

    textelement(nm)
    {
    MinOccurs = Zero;
    XmlName = 'Nm';
    }
    }
    textelement(Cdtr)
    {
    MinOccurs = Zero;

    textelement(Cdtr_Nm)
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

    textelement(dbtragt)
    {
    MinOccurs = Zero;
    XmlName = 'DbtrAgt';

    textelement(dbtragt_fininstnid)
    {
    MinOccurs = Zero;
    XmlName = 'FinInstnId';

    textelement(fininstnid_nm)
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
        Evaluate(ntry.CreateDate, rpt_credttm, 9);
        Evaluate(ntry.FromDate, frdttm, 9);
        Evaluate(ntry.ToDate, todttm, 9);
        ntry."Bank Account":=othr_id;
        ntry.Currency:=ccy;
        if Evaluate(ntry.EntryBookingDate, dttm, 9)then;
        Evaluate(ntry.EntryBookedDate, bookgdtdt, 9);
        Evaluate(ntry.EntryValueDate, valdt_dt, 9);
        ntry.Source:=ntry.Source::"52";
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
}
