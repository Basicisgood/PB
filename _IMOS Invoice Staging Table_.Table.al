table 50141 "IMOS Invoice Staging Table"
{
    Caption = 'IMOS Invoice Staging Table';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "_action"; Text[100])
        {
            Caption = 'Action';
        }
        field(3; Status; text[1])
        {
            Caption = 'Status';
        }
        field(4; "transNo"; Text[50])
        {
            Caption = 'Transaction No';
        }
        field(5; "transType"; Integer)
        {
        }
        field(6; "externalRefId"; Text[50])
        {
        }
        field(7; "billExternalRef"; Text[50])
        {
        }
        field(8; "vendorNo"; Integer)
        {
        }
        field(9; "vendorName"; Text[150])
        {
        }
        field(10; "vendorShortName"; text[50])
        {
        }
        field(11; "vendorExternalRef"; text[20])
        {
        }
        field(12; "vendorReferenceCode"; text[50])
        {
        }
        field(13; "vendorType"; Text[10])
        {
        }
        field(14; "vendorCountryCode"; Text[10])
        {
        }
        field(15; "vendorCrossRef"; text[20])
        {
        }
        field(16; "vendorCareOf"; Integer)
        {
        }
        field(17; "vendorCareOfRef"; Text[20])
        {
        }
        field(18; "vendorCareOfCountryCode"; Text[20])
        {
        }
        field(19; "invoiceNo"; Text[35])
        {
        }
        field(20; "revInvoiceNo"; Text[50])
        {
        }
        field(21; "purchaseOrderNo"; text[30])
        {
        }
        field(22; "memo"; Text[500])
        {
        }
        field(23; "billRemarks"; Text[500])
        {
        }
        field(24; "approval"; Text[100])
        {
        }
        field(25; "paymentTermsCode"; Text[20])
        {
        }
        field(26; "invoiceDate"; date)
        {
        }
        field(27; "entryDate"; date)
        {
        }
        field(28; "actDate"; date)
        {
        }
        field(29; "dueDate"; Date)
        {
        }
        field(30; "exchangeRateDate"; date)
        {
        }
        field(31; "receivedDate"; date)
        {
        }
        field(32; "approvalDate"; Text[30])
        {
        }
        field(33; "approvalDate2"; Text[30])
        {
        }
        field(34; "approvalDate3"; Text[30])
        {
        }
        field(35; "approvalComments"; Text[300])
        {
        }
        field(36; "approvalComments2"; Text[300])
        {
        }
        field(37; "approvalComments3"; Text[300])
        {
        }
        field(38; "remarks"; Text[300])
        {
        }
        field(39; "cpDate"; date)
        {
        }
        field(40; "aparCode"; Text[100])
        {
        }
        field(41; "currencyAmount"; Decimal)
        {
        }
        field(42; "currency"; code[10])
        {
        }
        field(43; "exchangeRate"; Decimal)
        {
            DecimalPlaces = 2: 10;
        }
        field(44; "baseCurrencyAmount"; Decimal)
        {
        }
        field(45; "oprTransNo"; Integer)
        {
        }
        field(46; "oprBillSource"; Text[100])
        {
        }
        field(47; "vatCurr"; code[10])
        {
        }
        field(48; "vatExchangeRate"; Decimal)
        {
            DecimalPlaces = 2: 10;
        }
        field(49; "vatExchangeRateDate"; Text[30])
        {
        }
        field(50; "remittanceSeq"; Integer)
        {
        }
        field(51; "remittanceCompNo"; Integer)
        {
        }
        field(52; "remittanceAccountNo"; Text[100])
        {
        }
        field(53; "remittanceBankName"; Text[150])
        {
        }
        field(54; "remittanceExternalRef"; Text[120])
        {
        }
        field(55; "remittanceSwiftCode"; Text[20])
        {
        }
        field(56; "remittanceFullName"; Text[100])
        {
        }
        field(57; "remittanceIban"; Text[50])
        {
        }
        field(58; "docNo"; Text[10])
        {
        }
        field(59; "companyBU"; Text[30])
        {
        }
        field(60; "counterpartyBU"; Text[10])
        {
        }
        field(61; "paymentAccountNo"; Text[20])
        {
        }
        field(62; "paymentBank"; Text[30])
        {
        }
        field(63; "paymentBankCode"; Text[20])
        {
        }
        field(64; "lastUserId"; Text[30])
        {
        }
        field(65; "lastModifiedDate"; Text[50])
        {
        }
        field(66; "tcCode"; Text[20])
        {
        }
        field(70; "IC Transaction"; Boolean)
        {
            Editable = false;
        }
        field(100; "BC Status";Enum EnumStatus)
        {
        }
        field(101; "Cancelled By"; Code[50])
        {
        }
        field(102; "Cancelled Datetime"; DateTime)
        {
        }
        field(103; "Error Description"; text[500])
        {
        }
        field(104; "BC Company Code"; code[50])
        {
        }
        field(105; "Posted Document No"; code[20])
        {
        }
        field(106; "Wrong Posting"; Boolean)
        {
        }
        field(107; "No of Lines in BC"; Integer)
        {
            Editable = false;
        }
        field(108; "No of Lines in IMOS"; Integer)
        {
            Editable = false;
        }
        field(109; "Amount Posted in BC"; Decimal)
        {
            Editable = false;
        }
        field(110; "Reversed in BC"; Boolean)
        {
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(tran; transNo)
        {
        }
        Key(K2; "BC Status", "BC Company Code", "Posted Document No")
        {
        }
    }
    trigger OnInsert()
    begin
    //CreateOutboundLogForIMOS(0);
    end;
    trigger OnModify()
    begin
        CreateOutboundLogForIMOS(1);
    end;
    procedure CreateOutboundLogForIMOS(P_Type: Option Insert, Update)
    var
        IMOSOutboundLog: Record "IMOS API Log";
    begin
        exit;
        IMOSOutboundLog.Init();
        IMOSOutboundLog."Entry No.":=0;
        IMOSOutboundLog."Table No.":=Database::"IMOS Invoice Staging Table";
        IMOSOutboundLog."Primary key":=IMOSOutboundLog."Primary key"::Invoice;
        IMOSOutboundLog."Primary key 2":=format(Rec."Entry No.");
        IMOSOutboundLog."Primary key 3":=rec.transNo;
        IMOSOutboundLog.Status:=IMOSOutboundLog.Status::Pending;
        IMOSOutboundLog.Insert(true);
    End;
}
