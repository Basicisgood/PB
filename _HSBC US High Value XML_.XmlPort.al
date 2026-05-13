xmlport 50104 "HSBC US High Value XML"
{
    Caption = 'HSBC US High Value';
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
    trigger OnBeforePassVariable()
    begin
        PmtInfId:=HSBC."Bank Document No.";
    end;
    }
    textelement(PmtMtd)
    {
    trigger OnBeforePassVariable()
    var
    begin
        PmtMtd:=HSBC."Payment Method Bank XML"; //11062024
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
    /*    textelement(DeCtrySubDvsn)
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
    /* textelement(PmtDbtrId)
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
                                            PmtDbtrOthrId := 'O01';
                                        end;
                                    }
                                }
                            }
                        } */
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
    textelement(ClrSysMmbId)
    {
    textelement(MmbId)
    {
    trigger OnBeforePassVariable()
    begin
        MmbId:=hsbc."Creditor Bank Clearing Code";
    end;
    }
    trigger OnBeforePassVariable()
    begin
        if HSBC."Creditor Bank Clearing Code" = '' then currXMLport.Skip();
    end;
    }
    textelement(BIC)
    {
    trigger OnBeforePassVariable()
    begin
        BIC:=HSBC."Debtor SWIFT Code";
        if BIC = '' then currXMLport.Skip();
    end;
    }
    textelement(DbtrAgtNm)
    {
    XmlName = 'Nm';

    trigger OnBeforePassVariable()
    begin
        DbtrAgtNm:=HSBC."Debtor Bank Acc Name";
        if DbtrAgtNm = '' then currXMLport.Skip();
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
        DbtrCtry:=HSBC."Debtor Bank Country" end;
    }
    }
    }
    }
    textelement(ChrgBr)
    {
    trigger OnBeforePassVariable()
    begin
        ChrgBr:=format(HSBC."Charges Bearer");
        if ChrgBr = '' then currXMLport.Skip();
    end;
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
    textelement(IntrmyAgt1)
    {
    textelement(FinInstnIdAgt1)
    {
    XmlName = 'FinInstnId';

    fieldelement(BIC;
    CdtTrfTxInf."Creditor Inter. Bank SWIFT")
    {
    }
    //}VJ---
    textelement(PstlAdrAgt1)
    {
    XmlName = 'PstlAdr';

    fieldelement(Ctry;
    CdtTrfTxInf."Creditor Inter. Bank Country")
    {
    }
    }
    } //VJ+++
    //VJ+++ start
    trigger OnBeforePassVariable()
    begin
        if(CdtTrfTxInf."Creditor Inter. Bank SWIFT" = '') and (CdtTrfTxInf."Creditor Inter. Bank Country" = '')then currXMLport.Skip();
    end;
    //VJ+++ end
    }
    textelement(IntrmyAgt1Acct)
    {
    textelement(idagt1)
    {
    XmlName = 'Id';

    //fieldelement(Othr; CdtTrfTxInf."Creditor Inter. Bank Country") { } //VJ 24DEC2024
    textelement(idagt1_Othr)
    {
    XmlName = 'Othr';

    fieldelement(Id;
    CdtTrfTxInf."Creditor Inter. Bank Acc. No")
    {
    }
    } //VJ 24DEC2024
    }
    trigger OnBeforePassVariable()
    begin
        //if CdtTrfTxInf."Creditor Inter. Bank Country" = '' then//VJ 24DEC2024
        if CdtTrfTxInf."Creditor Inter. Bank Acc. No" = '' then //VJ 24DEC2024
 currXMLport.Skip();
    end;
    }
    textelement(CdtrAgt)
    {
    textelement(CrFinInstnId)
    {
    XmlName = 'FinInstnId';

    textelement(cdtr_ClrSysMmbId)
    {
    XmlName = 'ClrSysMmbId';

    // textelement(cdtr_MmbId) //VJ 26122024 +++ to show mmbid under ClrSysMmbid
    // {
    //     XmlName = 'MmbId';//VJ 26122024 +++
    fieldelement(MmbId;
    CdtTrfTxInf."Creditor ABA/BSB No.")
    {
    }
    // trigger OnBeforePassVariable()
    // begin
    //     if CdtTrfTxInf."Creditor Country" = 'US' then
    //         MmbId := CdtTrfTxInf."Creditor ABA/BSB No."
    // end;
    // }
    trigger OnBeforePassVariable()
    begin
        //if (CdtTrfTxInf."Creditor Country" <> 'US') then
        //  currXMLport.Skip();
        if CdtTrfTxInf."Creditor ABA/BSB No." = '' then currXMLport.Skip();
    end;
    //}//VJ 26122024 +++
    }
    textelement(CdtrAgtBIC)
    {
    XmlName = 'BIC';

    trigger OnBeforePassVariable()
    begin
        if(CdtTrfTxInf."Creditor Country" <> 'US') or (CdtTrfTxInf."Creditor ABA/BSB No." = '')then CdtrAgtBIC:=CdtTrfTxInf."Creditor Swift Code"
        else
            currXMLport.Skip();
    end;
    }
    //TEC.VJ06102025---
    fieldelement(Nm;
    CdtTrfTxInf."Recipient Bank Name")
    {
    }
    //TEC.VJ06102025---
    textelement(CrPstlAdr)
    {
    XmlName = 'PstlAdr';

    fieldelement(CrCtry;
    CdtTrfTxInf."Creditor Country")
    {
    XmlName = 'Ctry';
    }
    }
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
    //  textelement(CtrySubDvsn) { }
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
    }
    textelement(InstrInf)
    {
    fieldelement(InstrForDbtrAgt;
    CdtTrfTxInf."Instruction to Bank")
    {
    }
    trigger OnBeforePassVariable()
    begin
        if CdtTrfTxInf."Instruction to Bank" = '' then currXMLport.Skip();
    end;
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
    textelement(RgltryRptg)
    {
    textelement(Dtls)
    {
    fieldelement(Inf;
    cdttrftxinf."Purpose Code")
    {
    trigger OnBeforePassField()
    begin
        if CdtTrfTxInf."Purpose Code" = '' then currXMLport.Skip();
    end;
    }
    }
    trigger OnBeforePassVariable()
    begin
        if cdttrftxinf."Purpose Code" = '' then currXMLport.Skip();
        if(cdttrftxinf."Creditor Country" <> 'CN') and (cdttrftxinf."Creditor Country" <> 'AE')then currXMLport.Skip();
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
