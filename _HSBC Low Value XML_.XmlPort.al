xmlport 50102 "HSBC Low Value XML"
{
    Caption = 'HSBC Low Value';
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
        CreDtTm:=Format(CurrentDateTime, 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>');
    end;
    }
    textelement(Authstn)
    {
    textelement(Cd)
    {
    trigger OnBeforePassVariable()
    begin
        Cd:='AUTH';
    end;
    }
    }
    textelement(NbOfTxs)
    {
    trigger OnBeforePassVariable()
    begin
        NbOfTxs:=Format(Count);
    end;
    }
    textelement(HdrCtrlSum)
    {
    XmlName = 'CtrlSum';

    trigger OnBeforePassVariable()
    begin
        HdrCtrlSum:=Format(HSBC.Amount, 0, '<Precision,2:2><Sign><Integer><Decimals>');
    end;
    }
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
    trigger OnBeforePassVariable()
    begin
        PmtInfId:=HSBC."Batch Id";
    end;
    }
    textelement(PmtMtd)
    {
    trigger OnBeforePassVariable()
    begin
        PmtMtd:=HSBC."Payment Method Bank XML";
    end;
    }
    textelement(BtchBookg)
    {
    trigger OnBeforePassVariable()
    begin
        BtchBookg:='false';
    end;
    }
    textelement(PmNbOfTxs)
    {
    XmlName = 'NbOfTxs';

    trigger OnBeforePassVariable()
    begin
        PmNbOfTxs:=Format(Count);
    end;
    }
    textelement(PmCtrlSum)
    {
    XmlName = 'CtrlSum';

    trigger OnBeforePassVariable()
    begin
        PmCtrlSum:=Format(HSBC.Amount, 0, '<Precision,2:2><Sign><Integer><Decimals>');
    end;
    }
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
    trigger OnBeforePassVariable()
    begin
        if Format(HSBC."Service Level") = '' then currXMLport.Skip();
    end;
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
        if PmtInfStrtNm = '' then currXMLport.Skip();
    end;
    }
    textelement(PmtInfTwnNm)
    {
    XmlName = 'TwnNm';

    trigger OnBeforePassVariable()
    begin
        PmtInfTwnNm:=HSBC."Debtor Address 2";
        if PmtInfTwnNm = '' then currXMLport.Skip();
    end;
    }
    /*        textelement(DeCtrySubDvsn)
                                   {
                                       XmlName = 'CtrySubDvsn';
                                   } */
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
        PmtDbtrOthrId:=HSBC."ACH Payment Set Code";
    // PmtDbtrOthrId := 'O01';
    end;
    }
    textelement(SchmeNm)
    {
    textelement(Prtry)
    {
    trigger OnBeforePassVariable()
    begin
        Prtry:='PSET';
    end;
    }
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
    textelement(Ccy)
    {
    trigger OnBeforePassVariable()
    begin
        Ccy:=HSBC."Debtor Currency Code";
        if Ccy = '' then currXMLport.Skip();
    end;
    }
    }
    textelement(DbtrAgt)
    {
    textelement(FinInstnId)
    {
    textelement(BIC)
    {
    trigger OnBeforePassVariable()
    begin
        BIC:=HSBC."Debtor SWIFT Code";
        if BIC = '' then currXMLport.Skip();
    end;
    }
    textelement(DbtrPstlAdr)
    {
    XmlName = 'PstlAdr';

    textelement(DbtrCtry)
    {
    XmlName = 'Ctry';

    trigger OnBeforePassVariable()
    begin
        DbtrCtry:=HSBC."Debtor Bank Country";
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
    trigger OnBeforePassField()
    begin
        if CdtTrfTxInf."Bank Document No." = '' then currXMLport.Skip();
    end;
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
    trigger OnBeforePassField()
    begin
        if CdtTrfTxInf.Currency = '' then currXMLport.Skip();
    end;
    }
    trigger OnBeforePassVariable()
    begin
        InstdAmt:=Format(CdtTrfTxInf.Amount, 0, '<Precision,2:2><Sign><Integer><Decimals>');
    end;
    }
    }
    textelement(ChrgBr)
    {
    trigger OnBeforePassVariable()
    begin
        ChrgBr:=Format(CdtTrfTxInf."Charges Bearer");
        if ChrgBr = '' then currXMLport.Skip();
    end;
    }
    textelement(CdtrAgt)
    {
    textelement(CrFinInstnId)
    {
    XmlName = 'FinInstnId';

    textelement(ClrSysMmbId)
    {
    fieldelement(MmbId;
    CdtTrfTxInf."Creditor ABA/BSB No.")
    {
    }
    }
    fieldelement(Nm;
    CdtTrfTxInf."Recipient Bank Name")
    {
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
    //TEC.VJ 13112025 Commented start
    // textelement(Nm_1)
    // {
    //     XmlName = 'Nm';
    //     fieldelement(Nm; CdtTrfTxInf."Recipient Bank Name")
    //     {
    //         XmlName = 'Nm';
    //     }
    // }
    //TEC.VJ 13112025 Commented end
    //TEC.VJ 13112025 Code added start
    //TEC.VJ 13112025 Code added end
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

    fieldelement(StrtNm;
    CdtTrfTxInf."Creditor Address")
    {
    trigger OnBeforePassField()
    begin
        if CdtTrfTxInf."Creditor Address" = '' then currXMLport.Skip();
    end;
    }
    fieldelement(TwnNm;
    CdtTrfTxInf."Creditor Address 2")
    {
    trigger OnBeforePassField()
    begin
        if CdtTrfTxInf."Creditor Address 2" = '' then currXMLport.Skip();
    end;
    }
    // textelement(CtrySubDvsn) { }
    fieldelement(Ctry;
    CdtTrfTxInf."Creditor Country")
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
    fieldelement(CdtrAcctCcy;
    CdtTrfTxInf."Creditor Currency Code")
    {
    XmlName = 'Ccy';

    trigger OnBeforePassField()
    begin
        if CdtTrfTxInf."Creditor Currency Code" = '' then currXMLport.Skip();
    end;
    }
    fieldelement(CdtrAcctNm;
    CdtTrfTxInf."Creditor Bank Acc Name")
    {
    XmlName = 'Nm';

    trigger OnBeforePassField()
    begin
        if CdtTrfTxInf."Creditor Bank Acc Name" = '' then currXMLport.Skip();
    end;
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
        if CdtTrfTxInf."Creditor Email Address 1" <> '' then RmtLctnMtd1:='EMAL';
    end;
    }
    fieldelement(RmtLctnElctrncAdr;
    CdtTrfTxInf."Creditor Email Address 1")
    {
    XmlName = 'RmtLctnElctrncAdr';
    }
    trigger OnBeforePassVariable()
    begin
        if CdtTrfTxInf."Creditor Email Address 1" = '' then currXMLport.Skip();
    end;
    }
    textelement(RltdRmtInf2)
    {
    XmlName = 'RltdRmtInf';

    textelement(RmtLctnMtd2)
    {
    XmlName = 'RmtLctnMtd';

    trigger OnBeforePassVariable()
    begin
        if CdtTrfTxInf."Creditor Email Address 2" <> '' then RmtLctnMtd2:='EMAL';
    end;
    }
    fieldelement(RmtLctnElctrncAdr2;
    CdtTrfTxInf."Creditor Email Address 2")
    {
    XmlName = 'RmtLctnElctrncAdr';
    }
    trigger OnBeforePassVariable()
    begin
        if CdtTrfTxInf."Creditor Email Address 2" = '' then currXMLport.Skip();
    end;
    }
    textelement(RltdRmtInf3)
    {
    XmlName = 'RltdRmtInf';

    textelement(RmtLctnMtd3)
    {
    XmlName = 'RmtLctnMtd';

    trigger OnBeforePassVariable()
    begin
        if CdtTrfTxInf."Creditor Email Address 3" <> '' then RmtLctnMtd3:='EMAL';
    end;
    }
    fieldelement(RmtLctnElctrncAdr3;
    CdtTrfTxInf."Creditor Email Address 3")
    {
    XmlName = 'RmtLctnElctrncAdr';
    }
    trigger OnBeforePassVariable()
    begin
        if CdtTrfTxInf."Creditor Email Address 3" = '' then currXMLport.Skip();
    end;
    }
    textelement(RltdRmtInf4)
    {
    XmlName = 'RltdRmtInf';

    textelement(RmtLctnMtd4)
    {
    XmlName = 'RmtLctnMtd';

    trigger OnBeforePassVariable()
    begin
        if CdtTrfTxInf."Creditor Email Address 4" <> '' then RmtLctnMtd4:='EMAL';
    end;
    }
    fieldelement(RmtLctnElctrncAdr4;
    CdtTrfTxInf."Creditor Email Address 4")
    {
    XmlName = 'RmtLctnElctrncAdr';
    }
    trigger OnBeforePassVariable()
    begin
        if CdtTrfTxInf."Creditor Email Address 4" = '' then currXMLport.Skip();
    end;
    }
    textelement(RltdRmtInf5)
    {
    XmlName = 'RltdRmtInf';

    textelement(RmtLctnMtd5)
    {
    XmlName = 'RmtLctnMtd';

    trigger OnBeforePassVariable()
    begin
        if CdtTrfTxInf."Creditor Email Address 5" <> '' then RmtLctnMtd5:='EMAL';
    end;
    }
    fieldelement(RmtLctnElctrncAdr5;
    CdtTrfTxInf."Creditor Email Address 5")
    {
    XmlName = 'RmtLctnElctrncAdr';
    }
    trigger OnBeforePassVariable()
    begin
        if CdtTrfTxInf."Creditor Email Address 5" = '' then currXMLport.Skip();
    end;
    }
    textelement(RltdRmtInf6)
    {
    XmlName = 'RltdRmtInf';

    textelement(RmtLctnMtd6)
    {
    XmlName = 'RmtLctnMtd';

    trigger OnBeforePassVariable()
    begin
        if CdtTrfTxInf."Creditor Email Address 6" <> '' then RmtLctnMtd6:='EMAL';
    end;
    }
    fieldelement(RmtLctnElctrncAdr6;
    CdtTrfTxInf."Creditor Email Address 6")
    {
    XmlName = 'RmtLctnElctrncAdr';
    }
    trigger OnBeforePassVariable()
    begin
        if CdtTrfTxInf."Creditor Email Address 6" = '' then currXMLport.Skip();
    end;
    }
    textelement(rmtinf)
    {
    MinOccurs = Zero;
    XmlName = 'RmtInf';

    fieldelement(ustrd;
    CdtTrfTxInf."Purpose Code")
    {
    MinOccurs = Zero;
    XmlName = 'Ustrd';

    trigger OnBeforePassField()
    begin
        if CdtTrfTxInf."Purpose Code" = '' then currXMLport.Skip();
    end;
    }
    fieldelement(ustrd_msgtorecipt;
    CdtTrfTxInf."Debtor To Receipt")
    {
    MinOccurs = Zero;
    XmlName = 'Ustrd';

    trigger OnBeforePassField()
    begin
        if CdtTrfTxInf."Debtor To Receipt" = '' then currXMLport.Skip();
    end;
    }
    fieldelement(ustrd_endtoendid;
    CdtTrfTxInf."Bank Document No.")
    {
    MinOccurs = Zero;
    XmlName = 'Ustrd';
    }
    trigger OnBeforePassVariable()
    begin
        // if (CdtTrfTxInf."Purpose Code" = '') and (CdtTrfTxInf."Debtor To Receipt" = '') then
        //     currXMLport.Skip();
        if(CdtTrfTxInf."Creditor Country" = 'CN') or (CdtTrfTxInf."Creditor Country" = 'AE')then currXMLport.Skip();
    end;
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
