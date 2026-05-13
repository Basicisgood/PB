codeunit 50107 "HSBC XML File"
{
    trigger OnRun()
    begin
    end;
    var myInt: Integer;
    procedure XMLBasedTesting(JnlTemlateName: Code[20]; JournalBathName: Code[20])
    var
        XMLDoc: XmlDocument;
        XMLDec: XmlDeclaration;
        RootNode: XmlElement;
        parentNode: XmlElement;
        GprHdr: XmlElement;
        paymentJnl: Record "Gen. Journal Line";
        Fieldcaption: Text;
        XMLtxt: XmlText;
        Childnode: XmlElement;
        TempBlob: Codeunit "Temp Blob";
        Instr: InStream;
        Outstr: OutStream;
        Readtext: Text;
        WriteTxt: Text;
        Authstn: XmlElement;
        InitgPty: XmlElement;
        Id: XmlElement;
        OrgId: XmlElement;
        Othr: XmlElement;
        PmtInf: XmlElement;
        PmtTpInf: XmlElement;
        SvcLvl: XmlElement;
        Dbtr: XmlElement;
        PstlAdr: XmlElement;
        DbtrAcct: XmlElement;
        DbtrAgt: XmlElement;
        FinInstnId: XmlElement;
        CdtTrfTxInf: XmlElement;
        PmtId: XmlElement;
        Amt: XmlElement;
        CdtrAgt: XmlElement;
        Cdtr: XmlElement;
        CdtrAcct: XmlElement;
        RltdRmtInf: XmlElement;
        CountNoofTrns: Integer;
        PaymntJnl: Record "Gen. Journal Line";
        CountCtrlSum: Decimal;
        BankAccount: Record "Bank Account";
        VendorBankAccount: Record "Vendor Bank Account";
        Vend: Record Vendor;
        VendLedgEntry: Record "Vendor Ledger Entry";
        PaymentJournal: Record "Gen. Journal Line";
        ModifyPaymentJnl: Record "Gen. Journal Line";
        StartDocNo: Code[20];
        EndDocNo: Code[20];
        Companyinfo: Record "Company Information";
        DocLabel: Text;
        NameSpaceUrl: Text;
        PaymentJnlCount: Record "Gen. Journal Line";
        InstrForCdtrAgt: XmlElement;
        RmtInf: XmlElement;
        parentNode1: XmlElement;
        ClrSysMmbId: XmlElement;
        MmbId: XmlElement;
    begin
        DocLabel:='http://www.w3.org/2001/XMLSchema-instance';
        NameSpaceUrl:='urn:iso:std:iso:20022:tech:xsd:pain.001.001.03';
        Companyinfo.get();
        XMLDoc:=XmlDocument.Create();
        XMLDec:=XmlDeclaration.Create('1.0', 'UTF-8', 'yes');
        XMLDoc.SetDeclaration(XMLDec);
        RootNode:=XmlElement.Create('Document', NameSpaceUrl);
        //RootNode.InnerText('', '');
        //RootNode.SetAttribute('xmlns', NameSpaceUrl);
        RootNode.Add(XmlAttribute.CreateNamespaceDeclaration('xsi', DocLabel));
        // RootNode.Add(XmlAttribute.CreateNamespaceDeclaration('', DocLabel));
        //XMLDoc.Add(RootNode);
        //RootNode.Add(parentNode);
        //RootNode.Add(XmlAttribute.Create('xmlns', NameSpaceUrl));
        //RootNode.Add(XmlAttribute.CreateNamespaceDeclaration('urn:iso:std:iso:20022:tech:xsd:pain.001.001.03'));
        //RootNode.Attributes.
        //RootNode.SetAttribute('xmlns:xsl', DocLabel);
        // RootNode.SetAttribute('xmlns:xsi', '"http://www.w3.org/2001/XMLSchema-instance"');
        CountNoofTrns:=0;
        CountCtrlSum:=0;
        paymentJnl.Reset();
        PaymntJnl.SetRange("Document Type", PaymntJnl."Document Type"::Payment);
        PaymntJnl.SetRange("Journal Template Name", JnlTemlateName);
        PaymntJnl.SetRange("Journal Batch Name", JournalBathName);
        //PaymntJnl.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
        //PaymntJnl.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
        //paymentJnl.SetRange("Bal. Account No.",);
        if PaymntJnl.FindFirst()then;
        CountNoofTrns:=PaymntJnl.Count;
        PaymntJnl.CalcSums(Amount);
        CountCtrlSum:=PaymntJnl.Amount;
        parentNode:=XmlElement.Create('CstmrCdtTrfInitn', NameSpaceUrl);
        //parentNode.SetAttribute('', '');
        // parentNode.Attributes().Remove('"xmlns="');
        RootNode.Add(parentNode);
        XMLDoc.Add(RootNode);
        //RootNode.RemoveAllAttributes();
        GprHdr:=XmlElement.Create('GrpHdr', NameSpaceUrl);
        parentNode.Add(GprHdr);
        //Add MsgId 2.0
        Childnode:=XmlElement.Create('MsgId', NameSpaceUrl);
        XMLtxt:=XmlText.Create(PaymntJnl."Document No.");
        Childnode.Add(XMLtxt);
        GprHdr.Add(Childnode);
        Childnode:=XmlElement.Create('CreDtTm', NameSpaceUrl);
        XMLtxt:=XmlText.Create(format(DT2DATE(CURRENTDATETIME), 0, 9) + 'T' + format(Time, 0, '<Hours24,2>:<Minutes,2>:<Seconds,2>'));
        Childnode.Add(XMLtxt);
        GprHdr.Add(Childnode);
        // Authstn 2.0
        Authstn:=XmlElement.Create('Authstn', NameSpaceUrl);
        GprHdr.Add(Authstn);
        Childnode:=XmlElement.Create('Cd', NameSpaceUrl);
        XMLtxt:=XmlText.Create('FDET');
        Childnode.Add(XMLtxt);
        Authstn.Add(Childnode);
        // NbOfTxs 2.0
        Childnode:=XmlElement.Create('NbOfTxs', NameSpaceUrl);
        XMLtxt:=XmlText.Create(format(CountNoofTrns));
        Childnode.Add(XMLtxt);
        GprHdr.Add(Childnode);
        // CtrlSum 2.0
        Childnode:=XmlElement.Create('CtrlSum', NameSpaceUrl);
        XMLtxt:=XmlText.Create(Format(CountCtrlSum, 0, 1));
        Childnode.Add(XMLtxt);
        GprHdr.Add(Childnode);
        // InitgPty 2.0
        InitgPty:=XmlElement.Create('InitgPty', NameSpaceUrl);
        GprHdr.Add(InitgPty);
        Childnode:=XmlElement.Create('nm', NameSpaceUrl);
        XMLtxt:=XmlText.Create('Test INSURANCE CO');
        Childnode.Add(XMLtxt);
        InitgPty.Add(Childnode);
        // Id 3.0
        Id:=XmlElement.Create('Id', NameSpaceUrl);
        InitgPty.Add(Id);
        // OrgId 4.0
        OrgId:=XmlElement.Create('OrgId', NameSpaceUrl);
        Id.Add(OrgId);
        // Othr 5.0
        Othr:=XmlElement.Create('Othr', NameSpaceUrl);
        OrgId.Add(Othr);
        Childnode:=XmlElement.Create('Id', NameSpaceUrl);
        XMLtxt:=XmlText.Create('ABC00103005');
        Childnode.Add(XMLtxt);
        Othr.Add(Childnode);
        PaymntJnl.Reset();
        paymentJnl.SetRange("Document Type", paymentJnl."Document Type"::Payment);
        paymentJnl.SetRange("Journal Template Name", JnlTemlateName);
        paymentJnl.SetRange("Journal Batch Name", JournalBathName);
        paymentJnl.SetRange(HSBC, false);
        if paymentJnl.FindSet()then repeat PaymntJnl.SetRange("Document Type", PaymntJnl."Document Type"::Payment);
                PaymntJnl.SetRange("Journal Template Name", JnlTemlateName);
                PaymntJnl.SetRange("Journal Batch Name", JournalBathName);
                PaymntJnl.SetRange("Bal. Account No.", paymentJnl."Bal. Account No.");
                if PaymntJnl.FindFirst()then;
                //CountNoofTrns := PaymntJnl.Count;
                //PaymntJnl.CalcSums(Amount);
                //CountCtrlSum := PaymntJnl.Amount;
                // 0.0
                //Fieldcaption := pmtJnl.FieldCaption('Document');
                //Add GprHdr 1.0
                /*GprHdr := XmlElement.Create('GrpHdr');
                parentNode.Add(GprHdr);
                //Add MsgId 2.0
                Childnode := XmlElement.Create('MsgId');
                XMLtxt := XmlText.Create(paymentJnl."Document No.");
                Childnode.Add(XMLtxt);
                GprHdr.Add(Childnode);

                Childnode := XmlElement.Create('CreDtTm');
                XMLtxt := XmlText.Create(format(DT2DATE(CURRENTDATETIME), 0, 9) + 'T' + format(Time, 0, '<Hours24,2>:<Minutes,2>:<Seconds,2>'));
                Childnode.Add(XMLtxt);
                GprHdr.Add(Childnode);

                // Authstn 2.0
                Authstn := XmlElement.Create('Authstn');
                GprHdr.Add(Authstn);

                Childnode := XmlElement.Create('Cd');
                XMLtxt := XmlText.Create('ILEV');
                Childnode.Add(XMLtxt);
                Authstn.Add(Childnode);

                // NbOfTxs 2.0
                Childnode := XmlElement.Create('NbOfTxs');
                XMLtxt := XmlText.Create(format(CountNoofTrns));
                Childnode.Add(XMLtxt);
                GprHdr.Add(Childnode);

                // CtrlSum 2.0
                Childnode := XmlElement.Create('CtrlSum');
                XMLtxt := XmlText.Create(Format(CountCtrlSum, 0, 1));
                Childnode.Add(XMLtxt);
                GprHdr.Add(Childnode);

                // InitgPty 2.0
                InitgPty := XmlElement.Create('InitgPty');
                GprHdr.Add(InitgPty);

                // Id 3.0
                Id := XmlElement.Create('Id');
                InitgPty.Add(Id);

                // OrgId 4.0
                OrgId := XmlElement.Create('OrgId');
                Id.Add(OrgId);

                // Othr 5.0
                Othr := XmlElement.Create('Othr');
                OrgId.Add(Othr);

                Childnode := XmlElement.Create('Id');
                XMLtxt := XmlText.Create('ABC00103005');
                Childnode.Add(XMLtxt);
                Othr.Add(Childnode);*/
                //Add PmtInf 1.0
                PmtInf:=XmlElement.Create('PmtInf', NameSpaceUrl);
                parentNode.Add(PmtInf);
                Childnode:=XmlElement.Create('PmtInfId', NameSpaceUrl);
                XMLtxt:=XmlText.Create(paymentJnl."External Document No.");
                Childnode.Add(XMLtxt);
                PmtInf.Add(Childnode);
                Childnode:=XmlElement.Create('PmtMtd', NameSpaceUrl);
                XMLtxt:=XmlText.Create(paymentJnl."Payment Method Code");
                Childnode.Add(XMLtxt);
                PmtInf.Add(Childnode);
                /*Childnode := XmlElement.Create('BtchBookg', NameSpaceUrl);
                XMLtxt := XmlText.Create('false');
                Childnode.Add(XMLtxt);
                PmtInf.Add(Childnode);*/
                Childnode:=XmlElement.Create('NbOfTxs', NameSpaceUrl);
                XMLtxt:=XmlText.Create(Format(CountNoofTrns));
                Childnode.Add(XMLtxt);
                PmtInf.Add(Childnode);
                Childnode:=XmlElement.Create('CtrlSum', NameSpaceUrl);
                XMLtxt:=XmlText.Create(Format(CountCtrlSum, 0, 1));
                Childnode.Add(XMLtxt);
                PmtInf.Add(Childnode);
                //Add PmtTpInf 1.2
                PmtTpInf:=XmlElement.Create('PmtTpInf', NameSpaceUrl);
                PmtInf.Add(PmtTpInf);
                Childnode:=XmlElement.Create('InstrPrty', NameSpaceUrl);
                XMLtxt:=XmlText.Create(Format(paymentJnl."Order Importance"));
                Childnode.Add(XMLtxt);
                PmtTpInf.Add(Childnode);
                //Add SvcLvl 1.2.1
                SvcLvl:=XmlElement.Create('SvcLvl', NameSpaceUrl);
                PmtTpInf.Add(SvcLvl);
                Childnode:=XmlElement.Create('Cd', NameSpaceUrl);
                XMLtxt:=XmlText.Create(Format(paymentJnl."Lavel Service Code"));
                Childnode.Add(XMLtxt);
                SvcLvl.Add(Childnode);
                Childnode:=XmlElement.Create('ReqdExctnDt', NameSpaceUrl);
                XMLtxt:=XmlText.Create(FORMAT(Today, 0, '<Year4>-<Month,2>-<Day,2>'));
                Childnode.Add(XMLtxt);
                PmtInf.Add(Childnode);
                // Dbtr
                BankAccount.get(paymentJnl."Bal. Account No.");
                Dbtr:=XmlElement.Create('Dbtr', NameSpaceUrl);
                PmtInf.Add(Dbtr);
                //BankAccount.TestField("Bank Account Name");
                paymentJnl.TestField("Bank Account Name");
                Childnode:=XmlElement.Create('Nm', NameSpaceUrl);
                XMLtxt:=XmlText.Create(paymentJnl."Bank Account Name");
                Childnode.Add(XMLtxt);
                Dbtr.Add(Childnode);
                PstlAdr:=XmlElement.Create('PstlAdr', NameSpaceUrl);
                Dbtr.Add(PstlAdr);
                //BankAccount.TestField("Company Address");
                Companyinfo.TestField(Address);
                Childnode:=XmlElement.Create('StrtNm', NameSpaceUrl);
                //if BankAccount.Address <> '' then
                XMLtxt:=XmlText.Create(Companyinfo.Address);
                //else
                //XMLtxt := XmlText.Create('N/A');
                Childnode.Add(XMLtxt);
                PstlAdr.Add(Childnode);
                //BankAccount.TestField("Company Address 2");
                Companyinfo.TestField("Address 2");
                Childnode:=XmlElement.Create('TwnNm', NameSpaceUrl);
                //XMLtxt := XmlText.Create(BankAccount."Company Address 2");
                XMLtxt:=XmlText.Create(Companyinfo."Address 2");
                Childnode.Add(XMLtxt);
                PstlAdr.Add(Childnode);
                //BankAccount.TestField("Company City");
                Companyinfo.TestField(City);
                Childnode:=XmlElement.Create('CtrySubDvsn', NameSpaceUrl);
                //XMLtxt := XmlText.Create(BankAccount."Company City");
                XMLtxt:=XmlText.Create(Companyinfo.City);
                Childnode.Add(XMLtxt);
                PstlAdr.Add(Childnode);
                //BankAccount.TestField("Company Country/Region Code");
                Companyinfo.TestField("Country/Region Code");
                Childnode:=XmlElement.Create('Ctry', NameSpaceUrl);
                //XMLtxt := XmlText.Create(BankAccount."Company Country/Region Code");
                XMLtxt:=XmlText.Create(Companyinfo."Country/Region Code");
                Childnode.Add(XMLtxt);
                PstlAdr.Add(Childnode);
                DbtrAcct:=XmlElement.Create('DbtrAcct', NameSpaceUrl);
                PmtInf.Add(DbtrAcct);
                Id:=XmlElement.Create('Id', NameSpaceUrl);
                DbtrAcct.Add(Id);
                Othr:=XmlElement.Create('Othr', NameSpaceUrl);
                Id.Add(Othr);
                BankAccount.TestField("Bank Account No.");
                Childnode:=XmlElement.Create('Id', NameSpaceUrl);
                XMLtxt:=XmlText.Create(BankAccount."Bank Account No.");
                Childnode.Add(XMLtxt);
                Othr.Add(Childnode);
                Childnode:=XmlElement.Create('Ccy', NameSpaceUrl);
                XMLtxt:=XmlText.Create(paymentJnl."Currency Code");
                Childnode.Add(XMLtxt);
                DbtrAcct.Add(Childnode);
                // DbtrAgt
                DbtrAgt:=XmlElement.Create('DbtrAgt', NameSpaceUrl);
                PmtInf.Add(DbtrAgt);
                // FinInstnId
                FinInstnId:=XmlElement.Create('FinInstnId', NameSpaceUrl);
                DbtrAgt.Add(FinInstnId);
                BankAccount.TestField("SWIFT Code");
                Childnode:=XmlElement.Create('BIC', NameSpaceUrl);
                XMLtxt:=XmlText.Create(BankAccount."SWIFT Code");
                Childnode.Add(XMLtxt);
                FinInstnId.Add(Childnode);
                ClrSysMmbId:=XmlElement.Create('ClrSysMmbId', NameSpaceUrl);
                FinInstnId.Add(ClrSysMmbId);
                Childnode:=XmlElement.Create('MmbId', NameSpaceUrl);
                XMLtxt:=XmlText.Create('004');
                Childnode.Add(XMLtxt);
                ClrSysMmbId.Add(Childnode);
                PstlAdr:=XmlElement.Create('PstlAdr', NameSpaceUrl);
                FinInstnId.Add(PstlAdr);
                BankAccount.TestField(Address);
                Childnode:=XmlElement.Create('StrtNm', NameSpaceUrl);
                XMLtxt:=XmlText.Create(BankAccount.Address);
                Childnode.Add(XMLtxt);
                PstlAdr.Add(Childnode);
                BankAccount.TestField("Address 2");
                Childnode:=XmlElement.Create('TwnNm', NameSpaceUrl);
                XMLtxt:=XmlText.Create(BankAccount."Address 2");
                Childnode.Add(XMLtxt);
                PstlAdr.Add(Childnode);
                BankAccount.TestField(City);
                Childnode:=XmlElement.Create('CtrySubDvsn', NameSpaceUrl);
                XMLtxt:=XmlText.Create(BankAccount.City);
                Childnode.Add(XMLtxt);
                PstlAdr.Add(Childnode);
                BankAccount.TestField("Country/Region Code");
                Childnode:=XmlElement.Create('Ctry', NameSpaceUrl);
                if BankAccount.Address <> '' then XMLtxt:=XmlText.Create(BankAccount."Country/Region Code")
                else
                    XMLtxt:=XmlText.Create('N/A');
                Childnode.Add(XMLtxt);
                PstlAdr.Add(Childnode);
                // CdtTrfTxInf
                PaymentJournal.SetRange("Document Type", paymentJnl."Document Type");
                PaymentJournal.SetRange("Bal. Account No.", paymentJnl."Bal. Account No.");
                PaymentJournal.SetRange("Journal Template Name", paymentJnl."Journal Template Name");
                PaymentJournal.SetRange("Journal Batch Name", paymentJnl."Journal Batch Name");
                if PaymentJournal.FindSet()then repeat CdtTrfTxInf:=XmlElement.Create('CdtTrfTxInf', NameSpaceUrl);
                        PmtInf.Add(CdtTrfTxInf);
                        PmtId:=XmlElement.Create('PmtId', NameSpaceUrl);
                        CdtTrfTxInf.Add(PmtId);
                        VendLedgEntry.Reset();
                        VendLedgEntry.SetRange("Applies-to ID", PaymentJournal."Document No.");
                        if VendLedgEntry.FindFirst()then StartDocNo:=VendLedgEntry."Document No."
                        else
                            StartDocNo:='0';
                        Childnode:=XmlElement.Create('InstrId', NameSpaceUrl);
                        XMLtxt:=XmlText.Create(Format(StartDocNo));
                        Childnode.Add(XMLtxt);
                        PmtId.Add(Childnode);
                        VendLedgEntry.Reset();
                        VendLedgEntry.SetRange("Applies-to ID", PaymentJournal."Document No.");
                        if VendLedgEntry.FindLast()then EndDocNo:=VendLedgEntry."Document No."
                        else
                            EndDocNo:='0';
                        Childnode:=XmlElement.Create('EndToEndId', NameSpaceUrl);
                        XMLtxt:=XmlText.Create(Format(EndDocNo));
                        Childnode.Add(XMLtxt);
                        PmtId.Add(Childnode);
                        Amt:=XmlElement.Create('Amt', NameSpaceUrl);
                        CdtTrfTxInf.Add(Amt);
                        Childnode:=XmlElement.Create('InstdAmt', NameSpaceUrl);
                        //Childnode.SetAttribute('Ccy', paymentJnl."Currency Code");
                        //XMLtxt := XmlText.Create(Format(paymentJnl."Amount (LCY)"));
                        Childnode.SetAttribute('Ccy', PaymentJournal."Currency Code");
                        XMLtxt:=XmlText.Create(Format(PaymentJournal.Amount, 0, 1));
                        Childnode.Add(XMLtxt);
                        Amt.Add(Childnode);
                        Childnode:=XmlElement.Create('ChrgBr', NameSpaceUrl);
                        //XMLtxt := XmlText.Create(format(paymentJnl."Charges Bearer"));
                        XMLtxt:=XmlText.Create(format(PaymentJournal."Charges Bearer"));
                        Childnode.Add(XMLtxt);
                        CdtTrfTxInf.Add(Childnode);
                        PaymentJournal.TestField("Recipient Bank Account");
                        VendorBankAccount.Get(PaymentJournal."Account No.", PaymentJournal."Recipient Bank Account");
                        Vend.Get(VendorBankAccount."Vendor No.");
                        CdtrAgt:=XmlElement.Create('CdtrAgt', NameSpaceUrl);
                        CdtTrfTxInf.Add(CdtrAgt);
                        FinInstnId:=XmlElement.Create('FinInstnId', NameSpaceUrl);
                        CdtrAgt.Add(FinInstnId);
                        VendorBankAccount.TestField("SWIFT Code");
                        Childnode:=XmlElement.Create('BIC', NameSpaceUrl);
                        XMLtxt:=XmlText.Create(VendorBankAccount."SWIFT Code");
                        Childnode.Add(XMLtxt);
                        FinInstnId.Add(Childnode);
                        //VendorBankAccount.TestField(VendorBankAccount.Name);
                        PaymentJournal.TestField("Vendor Bank Account Name");
                        Childnode:=XmlElement.Create('Nm', NameSpaceUrl);
                        XMLtxt:=XmlText.Create(PaymentJournal."Vendor Bank Account Name");
                        Childnode.Add(XMLtxt);
                        FinInstnId.Add(Childnode);
                        PstlAdr:=XmlElement.Create('PstlAdr', NameSpaceUrl);
                        FinInstnId.Add(PstlAdr);
                        Childnode:=XmlElement.Create('Ctry', NameSpaceUrl);
                        XMLtxt:=XmlText.Create(VendorBankAccount."Country/Region Code");
                        Childnode.Add(XMLtxt);
                        PstlAdr.Add(Childnode);
                        Cdtr:=XmlElement.Create('Cdtr', NameSpaceUrl);
                        CdtTrfTxInf.Add(Cdtr);
                        Vend.TestField(Name);
                        Childnode:=XmlElement.Create('Nm', NameSpaceUrl);
                        XMLtxt:=XmlText.Create(Vend.Name);
                        Childnode.Add(XMLtxt);
                        Cdtr.Add(Childnode);
                        PstlAdr:=XmlElement.Create('PstlAdr', NameSpaceUrl);
                        Cdtr.Add(PstlAdr);
                        VendorBankAccount.TestField(Address);
                        Childnode:=XmlElement.Create('StrtNm', NameSpaceUrl);
                        XMLtxt:=XmlText.Create(VendorBankAccount.Address);
                        Childnode.Add(XMLtxt);
                        PstlAdr.Add(Childnode);
                        VendorBankAccount.TestField("Address 2");
                        Childnode:=XmlElement.Create('TwnNm', NameSpaceUrl);
                        XMLtxt:=XmlText.Create(VendorBankAccount."Address 2");
                        Childnode.Add(XMLtxt);
                        PstlAdr.Add(Childnode);
                        Childnode:=XmlElement.Create('CtrySubDvsn', NameSpaceUrl);
                        XMLtxt:=XmlText.Create('CENTRAL');
                        Childnode.Add(XMLtxt);
                        PstlAdr.Add(Childnode);
                        VendorBankAccount.TestField("Country/Region Code");
                        Childnode:=XmlElement.Create('Ctry', NameSpaceUrl);
                        XMLtxt:=XmlText.Create(VendorBankAccount."Country/Region Code");
                        Childnode.Add(XMLtxt);
                        PstlAdr.Add(Childnode);
                        CdtrAcct:=XmlElement.Create('CdtrAcct', NameSpaceUrl);
                        CdtTrfTxInf.Add(CdtrAcct);
                        Id:=XmlElement.Create('Id', NameSpaceUrl);
                        CdtrAcct.Add(Id);
                        Othr:=XmlElement.Create('Othr', NameSpaceUrl);
                        Id.Add(Othr);
                        VendorBankAccount.TestField("Bank Account No.");
                        Childnode:=XmlElement.Create('Id', NameSpaceUrl);
                        XMLtxt:=XmlText.Create(VendorBankAccount."Bank Account No.");
                        Childnode.Add(XMLtxt);
                        Othr.Add(Childnode);
                        if PaymentJournal."Instruction to Bank" <> '' then begin
                            InstrForCdtrAgt:=XmlElement.Create('InstrForCdtrAgt', NameSpaceUrl);
                            CdtTrfTxInf.Add(InstrForCdtrAgt);
                            Childnode:=XmlElement.Create('InstrInf', NameSpaceUrl);
                            XMLtxt:=XmlText.Create(PaymentJournal."Instruction to Bank");
                            Childnode.Add(XMLtxt);
                            InstrForCdtrAgt.Add(Childnode);
                        end;
                        if PaymentJournal."Remittance Email 1" <> '' then begin
                            RltdRmtInf:=XmlElement.Create('RltdRmtInf', NameSpaceUrl);
                            CdtTrfTxInf.Add(RltdRmtInf);
                            /*InstrForCdtrAgt := XmlElement.Create('InstrForCdtrAgt');
                            RltdRmtInf.Add(InstrForCdtrAgt);

                            Childnode := XmlElement.Create('InstrInf');
                            XMLtxt := XmlText.Create(PaymentJournal."Instruction to Bank");
                            Childnode.Add(XMLtxt);
                            InstrForCdtrAgt.Add(Childnode);*/
                            Childnode:=XmlElement.Create('RmtLctnMtd', NameSpaceUrl);
                            XMLtxt:=XmlText.Create('EMAL');
                            Childnode.Add(XMLtxt);
                            RltdRmtInf.Add(Childnode);
                            Childnode:=XmlElement.Create('RmtLctnElctrncAdr', NameSpaceUrl);
                            XMLtxt:=XmlText.Create(PaymentJournal."Remittance Email 1");
                            Childnode.Add(XMLtxt);
                            RltdRmtInf.Add(Childnode);
                        end;
                        if PaymentJournal."Remittance Email 2" <> '' then begin
                            RltdRmtInf:=XmlElement.Create('RltdRmtInf', NameSpaceUrl);
                            CdtTrfTxInf.Add(RltdRmtInf);
                            Childnode:=XmlElement.Create('RmtLctnMtd', NameSpaceUrl);
                            XMLtxt:=XmlText.Create('EMAL');
                            Childnode.Add(XMLtxt);
                            RltdRmtInf.Add(Childnode);
                            Childnode:=XmlElement.Create('RmtLctnElctrncAdr', NameSpaceUrl);
                            XMLtxt:=XmlText.Create(PaymentJournal."Remittance Email 2");
                            Childnode.Add(XMLtxt);
                            RltdRmtInf.Add(Childnode);
                        end;
                        if PaymentJournal."Remittance Email 3" <> '' then begin
                            RltdRmtInf:=XmlElement.Create('RltdRmtInf', NameSpaceUrl);
                            CdtTrfTxInf.Add(RltdRmtInf);
                            Childnode:=XmlElement.Create('RmtLctnMtd', NameSpaceUrl);
                            XMLtxt:=XmlText.Create('EMAL');
                            Childnode.Add(XMLtxt);
                            RltdRmtInf.Add(Childnode);
                            Childnode:=XmlElement.Create('RmtLctnElctrncAdr', NameSpaceUrl);
                            XMLtxt:=XmlText.Create(PaymentJournal."Remittance Email 3");
                            Childnode.Add(XMLtxt);
                            RltdRmtInf.Add(Childnode);
                        end;
                        if PaymentJournal."Remittance Email 4" <> '' then begin
                            RltdRmtInf:=XmlElement.Create('RltdRmtInf', NameSpaceUrl);
                            CdtTrfTxInf.Add(RltdRmtInf);
                            Childnode:=XmlElement.Create('RmtLctnMtd', NameSpaceUrl);
                            XMLtxt:=XmlText.Create('EMAL');
                            Childnode.Add(XMLtxt);
                            RltdRmtInf.Add(Childnode);
                            Childnode:=XmlElement.Create('RmtLctnElctrncAdr', NameSpaceUrl);
                            XMLtxt:=XmlText.Create(PaymentJournal."Remittance Email 4");
                            Childnode.Add(XMLtxt);
                            RltdRmtInf.Add(Childnode);
                        end;
                        if PaymentJournal."Remittance Email 5" <> '' then begin
                            RltdRmtInf:=XmlElement.Create('RltdRmtInf', NameSpaceUrl);
                            CdtTrfTxInf.Add(RltdRmtInf);
                            Childnode:=XmlElement.Create('RmtLctnMtd', NameSpaceUrl);
                            XMLtxt:=XmlText.Create('EMAL');
                            Childnode.Add(XMLtxt);
                            RltdRmtInf.Add(Childnode);
                            Childnode:=XmlElement.Create('RmtLctnElctrncAdr', NameSpaceUrl);
                            XMLtxt:=XmlText.Create(PaymentJournal."Remittance Email 5");
                            Childnode.Add(XMLtxt);
                            RltdRmtInf.Add(Childnode);
                        end;
                        if PaymentJournal."Remittance Email 6" <> '' then begin
                            RltdRmtInf:=XmlElement.Create('RltdRmtInf', NameSpaceUrl);
                            CdtTrfTxInf.Add(RltdRmtInf);
                            Childnode:=XmlElement.Create('RmtLctnMtd', NameSpaceUrl);
                            XMLtxt:=XmlText.Create('EMAL');
                            Childnode.Add(XMLtxt);
                            RltdRmtInf.Add(Childnode);
                            Childnode:=XmlElement.Create('RmtLctnElctrncAdr', NameSpaceUrl);
                            XMLtxt:=XmlText.Create(PaymentJournal."Remittance Email 6");
                            Childnode.Add(XMLtxt);
                            RltdRmtInf.Add(Childnode);
                        end;
                        /* PaymentJournal.TestField("Comment to bank");
                         Childnode := XmlElement.Create('Ustrd');
                         XMLtxt := XmlText.Create(PaymentJournal."Comment to bank");
                         Childnode.Add(XMLtxt);
                         RltdRmtInf.Add(Childnode);*/
                        RmtInf:=XmlElement.Create('RmtInf', NameSpaceUrl);
                        CdtTrfTxInf.Add(RmtInf);
                        PaymentJournal.TestField("Comment to bank");
                        Childnode:=XmlElement.Create('Ustrd', NameSpaceUrl);
                        XMLtxt:=XmlText.Create(PaymentJournal."Comment to bank");
                        Childnode.Add(XMLtxt);
                        RmtInf.Add(Childnode);
                        PaymentJournal.HSBC:=true;
                        PaymentJournal.Modify();
                    until PaymentJournal.Next() = 0;
            /* parentNode := XmlElement.Create('Payment');
             RootNode.Add(parentNode);
             //Fieldcaption := pmtJnl.FieldCaption("Journal Template Name");
             Childnode := XmlElement.Create('Journal_Template_Name');
             XMLtxt := XmlText.Create(pmtJnl."Journal Template Name");
             Childnode.Add(XMLtxt);
             parentNode.Add(Childnode);

             parentNode := XmlElement.Create('Payment');
             RootNode.Add(parentNode);
             //Fieldcaption := pmtJnl.FieldCaption("Journal Batch Name");
             Childnode := XmlElement.Create('Journal_Batch_Name');
             XMLtxt := XmlText.Create(pmtJnl."Journal Batch Name");
             Childnode.Add(XMLtxt);
             parentNode.Add(Childnode);

             parentNode := XmlElement.Create('Payment');
             RootNode.Add(parentNode);
             //Fieldcaption := pmtJnl.FieldCaption("Account No.");
             Childnode := XmlElement.Create('Account_No');
             XMLtxt := XmlText.Create(pmtJnl."Account No.");
             Childnode.Add(XMLtxt);
             parentNode.Add(Childnode);*/
            until paymentJnl.Next() = 0;
        TempBlob.CreateInStream(Instr);
        TempBlob.CreateOutStream(Outstr);
        XMLDoc.WriteTo(Outstr);
        Outstr.WriteText(WriteTxt);
        Instr.ReadText(WriteTxt);
        Readtext:='Payment.XML';
        DownloadFromStream(Instr, '', '', '', Readtext);
        ModifyPaymentJnl.SetRange("Document Type", ModifyPaymentJnl."Document Type"::Payment);
        if ModifyPaymentJnl.FindSet()then repeat ModifyPaymentJnl.HSBC:=false;
                ModifyPaymentJnl.Modify();
            until ModifyPaymentJnl.Next() = 0;
    end;
}
