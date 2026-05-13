xmlport 50103 "HSBC US Low Value XML"
{
    Caption = 'HSBC US Low Value';
    Direction = Export;
    Format = Xml;
    Encoding = UTF8;
    Namespaces = "" = 'urn:iso:std:iso:20022:tech:xsd:pain.001.001.03', "xsi" = 'http://www.w3.org/2001/XMLSchema-instance';
    UseDefaultNamespace = false;
    UseRequestPage = false;

    schema
    {
    textelement(Document)
    {
    textelement(CstmrCdtTrfInitn)
    {
    textelement(GrpHdr)
    {
    textelement(MsgId)
    {
    trigger OnBeforePassVariable()
    begin
        MsgId:=HSBC."Batch Id";
    end;
    }
    textelement(CreDtTm)
    {
    trigger OnBeforePassVariable()
    begin
        CreDtTm:=Format("CurrentDateTime", 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>');
    end;
    }
    /*  textelement(Authstn)
                     {
                         textelement(Cd) { }
                     } */
    textelement(NbOfTxs)
    {
    trigger OnBeforePassVariable()
    begin
        NbOfTxs:=Format(Count);
    end;
    }
    /* textelement(HdrCtrlSum)
                    {
                        XmlName = 'CtrlSum';
                        trigger OnBeforePassVariable()
                        begin
                            HdrCtrlSum := Format(HSBC.Amount, 0, '<Precision,2:2><Sign><Integer><Decimals>');
                        end;
                    } */
    textelement(InitgPty)
    {
    textelement(Id)
    {
    textelement(OrgId)
    {
    textelement(Othr)
    {
    textelement(HdrId)
    {
    XmlName = 'Id';

    trigger OnBeforePassVariable()
    begin
        HdrId:=HSBC.Identification;
    end;
    }
    }
    }
    }
    }
    }
    textelement(PmtInf)
    {
    textelement(PmtInfId)
    {
    }
    textelement(PmtMtd)
    {
    trigger OnBeforePassVariable()
    begin
        PmtMtd:=HSBC."Payment Method Bank XML";
    end;
    }
    /*  textelement(BtchBookg)
                     {
                         trigger OnBeforePassVariable()
                         begin
                             BtchBookg := 'false';
                         end;
                     }
                     textelement(PmNbOfTxs)
                     {
                         XmlName = 'NbOfTxs';
                         trigger OnBeforePassVariable()
                         begin
                             PmNbOfTxs := Format(Count);
                         end;
                     }
                     textelement(PmCtrlSum)
                     {
                         XmlName = 'CtrlSum';
                         trigger OnBeforePassVariable()
                         begin
                             PmCtrlSum := Format(HSBC.Amount, 0, '<Precision,2:2><Sign><Integer><Decimals>');
                         end;
                     } */
    textelement(PmtTpInf)
    {
    textelement(SvcLvl)
    {
    textelement(SlCd)
    {
    XmlName = 'Cd';

    trigger OnBeforePassVariable()
    begin
        SlCd:=Format(HSBC."Service Level");
    end;
    }
    }
    textelement(LclInstrm)
    {
    textelement(PmtTpInfPrtry)
    {
    XmlName = 'Prtry';
    }
    }
    }
    textelement(ReqdExctnDt)
    {
    trigger OnBeforePassVariable()
    begin
        ReqdExctnDt:=Format(HSBC."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>');
    end;
    }
    textelement(Dbtr)
    {
    textelement(Nm)
    {
    trigger OnBeforePassVariable()
    begin
        Nm:=HSBC."Debtor Name";
    end;
    }
    textelement(PstlAdr)
    {
    textelement(PmtInfStrtNm)
    {
    XmlName = 'StrtNm';

    trigger OnBeforePassVariable()
    begin
        PmtInfStrtNm:=HSBC."Debtor Address";
    end;
    }
    textelement(PmtInfTwnNm)
    {
    XmlName = 'TwnNm';

    trigger OnBeforePassVariable()
    begin
        PmtInfTwnNm:=HSBC."Debtor Address 2";
    end;
    }
    textelement(DeCtrySubDvsn)
    {
    XmlName = 'CtrySubDvsn';
    }
    textelement(DeCtry)
    {
    XmlName = 'Ctry';

    trigger OnBeforePassVariable()
    begin
        DeCtry:=HSBC."Debtor Country";
    end;
    }
    }
    textelement(PmtDbtrId)
    {
    XmlName = 'Id';

    textelement(PmtDbtrOrgId)
    {
    XmlName = 'OrgId';

    textelement(PmtDbtrOthr)
    {
    XmlName = 'Othr';

    textelement(PmtDbtrOthrId)
    {
    XmlName = 'Id';

    trigger OnBeforePassVariable()
    begin
        // PmtDbtrOthrId := HSBC."Debitor ACH ID";
        PmtDbtrOthrId:='O01';
    end;
    }
    }
    }
    }
    }
    textelement(DbtrAcct)
    {
    textelement(DbId)
    {
    XmlName = 'Id';

    textelement(DbOthr)
    {
    XmlName = 'Othr';

    textelement(PmtInfDbId)
    {
    XmlName = 'Id';

    trigger OnBeforePassVariable()
    begin
        PmtInfDbId:=HSBC."Debtor Bank Account";
    end;
    }
    }
    }
    }
    textelement(DbtrAgt)
    {
    textelement(FinInstnId)
    {
    textelement(DbtrAgtClrSysMmbId)
    {
    XmlName = 'ClrSysMmbId';

    textelement(DbtrAgtMmbId)
    {
    XmlName = 'MmbId';

    trigger OnBeforePassVariable()
    begin
        DbtrAgtMmbId:=HSBC."Debtor Bank Clearing Code";
    end;
    }
    }
    textelement(DbtrPstlAdr)
    {
    XmlName = 'PstlAdr';

    textelement(DbtrCtry)
    {
    XmlName = 'Ctry';

    trigger OnBeforePassVariable()
    begin
        DbtrCtry:=HSBC."Debtor Country";
    end;
    }
    }
    }
    }
    tableelement(CdtTrfTxInf;
    "HSBC Outbound Staging Table")
    {
    textelement(PmtId)
    {
    fieldelement(InstrId;
    CdtTrfTxInf."Bank Document No.")
    {
    }
    fieldelement(EndToEndId;
    CdtTrfTxInf."Bank Document No.")
    {
    }
    }
    textelement(Amt)
    {
    textelement(InstdAmt)
    {
    fieldattribute(Ccy;
    CdtTrfTxInf.Currency)
    {
    }
    trigger OnBeforePassVariable()
    begin
        InstdAmt:=Format(CdtTrfTxInf.Amount, 0, '<Precision,2:2><Sign><Integer><Decimals>');
    end;
    }
    }
    /*  textelement(ChrgBr)
                         {
                             trigger OnBeforePassVariable()
                             begin
                                 ChrgBr := Format(CdtTrfTxInf.ChrgBr);
                             end;
                         } */
    textelement(CdtrAgt)
    {
    textelement(CrFinInstnId)
    {
    XmlName = 'FinInstnId';

    textelement(ClrSysMmbId)
    {
    fieldelement(MmbId;
    CdtTrfTxInf."Creditor Bank Clearing Code")
    {
    }
    }
    textelement(CrPstlAdr)
    {
    XmlName = 'PstlAdr';

    fieldelement(CrCtry;
    CdtTrfTxInf."Creditor Country")
    {
    XmlName = 'Ctry';
    }
    }
    //TEC.VJ06102025---
    fieldelement(Nm;
    CdtTrfTxInf."Recipient Bank Name")
    {
    }
    //TEC.VJ06102025---
    }
    }
    textelement(Cdtr)
    {
    fieldelement(CrNm;
    CdtTrfTxInf."Creditor Bank Acc Name")
    {
    XmlName = 'Nm';
    }
    textelement(CrPstl)
    {
    XmlName = 'PstlAdr';

    textelement(StrtNm)
    {
    }
    textelement(TwnNm)
    {
    }
    textelement(CtrySubDvsn)
    {
    }
    textelement(Ctry)
    {
    }
    }
    }
    textelement(CdtrAcct)
    {
    textelement(CrDd)
    {
    XmlName = 'Id';

    fieldelement(IBAN;
    CdtTrfTxInf."Creditor IBAN Account")
    {
    trigger OnBeforePassField()
    begin
        if CdtTrfTxInf."Creditor IBAN Account" = '' then currXMLport.Skip();
    end;
    }
    textelement(CrOthr)
    {
    XmlName = 'Othr';

    fieldelement(CrBankNo;
    CdtTrfTxInf."Creditor Bank Account")
    {
    XmlName = 'Id';
    }
    trigger OnBeforePassVariable()
    begin
        if CdtTrfTxInf."Creditor Bank Account" = '' then currXMLport.Skip();
    end;
    }
    }
    /*   fieldelement(CdtrAcctCcy; CdtTrfTxInf."Creditor Currency Code")
                              {
                                  XmlName = 'Ccy';
                              }
                              fieldelement(CdtrAcctNm; CdtTrfTxInf."Creditor Bank Acc Name")
                              {
                                  XmlName = 'Nm';
                              } */
    }
    textelement(rmtinf)
    {
    MinOccurs = Zero;
    XmlName = 'RmtInf';

    fieldelement(ustrd_endtoendid;
    CdtTrfTxInf."Bank Document No.")
    {
    MinOccurs = Zero;
    XmlName = 'Ustrd';
    }
    }
    }
    }
    }
    }
    }
    procedure SetRecord(var HSBCOut: Record "HSBC Outbound Staging Table")
    begin
        HSBC.DeleteAll();
        repeat HSBC.Init();
            HSBC:=HSBCOut;
            HSBC.Insert();
        until HSBCOut.Next() = 0;
        Count:=HSBC.Count();
        HSBC.CalcSums(Amount);
    end;
    var HSBC: Record "HSBC Outbound Staging Table" temporary;
    Count: Integer;
}
