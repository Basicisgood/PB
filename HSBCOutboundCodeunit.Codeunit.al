codeunit 50132 HSBCOutboundCodeunit
{
    Permissions = tabledata "HSBC Outbound Staging Table"=rm;

    trigger OnRun()
    begin
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnApproveApprovalRequest, '', false, false)]
    local procedure "Approvals Mgmt._OnApproveApprovalRequest"(var ApprovalEntry: Record "Approval Entry")
    var
        Recid: RecordId;
        RecordRef: RecordRef;
        BatchName51: FieldRef;
        TemplateName1: FieldRef;
    begin
        if ApprovalEntry."Table ID" = 232 then CreateStagingDataFromPaymentJournalBatch(ApprovalEntry);
    end;
    procedure CreateStagingDataFromPaymentJournalBatch(approvalentry: Record "Approval Entry")
    var
        vendor: Record Vendor;
        Pk1: Code[20];
        Pk2: Code[20];
        Str1: text;
        Str2: text;
        Recid: RecordId;
        RecordRef: RecordRef;
        BatchName51: FieldRef;
        TemplateName1: FieldRef;
        SourceCode: code[20];
        ApprovalEntry2: Record "Approval Entry";
    begin
        //TEC.VJ 07APR2025>>
        ApprovalEntry2.Reset();
        ApprovalEntry2.SetRange("Table ID", approvalentry."Table ID");
        ApprovalEntry2.SetRange("Record ID to Approve", approvalentry."Record ID to Approve");
        approvalentry2.SetFilter(Status, '<>%1', ApprovalEntry2.Status::Approved);
        if ApprovalEntry2.FindFirst()then exit;
        //TEC.VJ 07APR2025<<
        Recid:=ApprovalEntry."Record ID to Approve";
        RecordRef.get(Recid);
        TemplateName1:=RecordRef.Field(1);
        BatchName51:=RecordRef.Field(2);
        InsertStagingData(TemplateName1.Value, BatchName51.Value);
    end;
    procedure CopyPaymentJournalToHSBCStaging(var PaymentJournal: record "Gen. Journal Line"; HSBCConnectCustomerID: Text[35]; var HSBCStagingTable: Record "HSBC Outbound Staging Table")
    var
        BankVendorAccount: Record "Vendor Bank Account";
        CustomerBankAcc: Record "Customer Bank Account";
        EmpBankAccount: Record "Employee Bank Account";
        BankAccount: Record "Bank Account";
        CitiOutbound: Codeunit CitiOutboundCodeunit;
        PaymentMethod: Record "Payment Method";
        PaymentSetCode: Record "Payment Set Code";
    begin
        HSBCStagingTable."Line No.":=PaymentJournal."Line No.";
        HSBCStagingTable.Identification:=HSBCConnectCustomerID;
        //if PaymentJournal."Payment Method Code" <> '' then
        //  if PaymentMethod.Get(PaymentJournal."Payment Method Code") then
        //HSBCStagingTable."Payment Method Bank XML" := PaymentMethod."Payment Method Bank XML";
        HSBCStagingTable."Payment Method Bank XML":=PaymentJournal."Payment Method Bank XML";
        HSBCStagingTable."Payment Purpose":=PaymentJournal."Payment Purpose"; //#145
        HSBCStagingTable."Payment Method":=PaymentJournal."Payment Method Code";
        HSBCStagingTable."Service Level":=PaymentJournal."Lavel Service Code";
        HSBCStagingTable."Posting Date":=CreateDateTime(PaymentJournal."Posting Date", Time);
        AssignComInfoInHSBC(HSBCStagingTable);
        if BankAccount.Get(PaymentJournal."Bal. Account No.")then AssignBankAccountFieldsInHSBC(HSBCStagingTable, BankAccount);
        HSBCStagingTable.Amount:=PaymentJournal.Amount;
        HSBCStagingTable.Currency:=PaymentJournal."Currency Code";
        HSBCStagingTable."Purpose Code":=PaymentJournal."Purpose Code Preflix" + ' ' + PaymentJournal."Purpose Code"; //#272 TEC.VJ
        //#393 05092025 VJ
        if HSBCStagingTable."Purpose Code" = ' ' then HSBCStagingTable."Purpose Code":='';
        //#393 05092025 VJ
        HSBCStagingTable."Creditor IFSC Code":=PaymentJournal."IFSC Code"; //VJ 29nov2024
        HSBCStagingTable."Word Link":=PaymentJournal."World Link"; //VJ 29nov2024
        HSBCStagingTable."Source Code":=PaymentJournal."Source Code";
        HSBCStagingTable."Trans. Amt.":=PaymentJournal."Trans. Amt.";
        HSBCStagingTable."Trans. Currency":=PaymentJournal."Trans. Currency";
        HSBCStagingTable."Exchange Rate":=PaymentJournal."Exchange Rate";
        HSBCStagingTable."ACH Payment Set Code":=PaymentJournal."Payment Set Code"; //TEC.VJ 27NOV2024
        HSBCStagingTable."Journal Template Name":=PaymentJournal."Journal Template Name";
        HSBCStagingTable."Journal Batch Name":=PaymentJournal."Journal Batch Name";
        HSBCStagingTable."Account Type":=PaymentJournal."Account Type";
        HSBCStagingTable."Account No.":=PaymentJournal."Account No.";
        HSBCStagingTable."Bal. Account Type":=PaymentJournal."Bal. Account Type";
        HSBCStagingTable."Bal. Account No.":=PaymentJournal."Bal. Account No.";
        //#138 VJ
        if PaymentJournal."Charges Bearer" = PaymentJournal."Charges Bearer"::SHA then HSBCStagingTable."Charges Bearer":=HSBCStagingTable."Charges Bearer"::SHAR;
        if PaymentJournal."Charges Bearer" = PaymentJournal."Charges Bearer"::OUR then HSBCStagingTable."Charges Bearer":=HSBCStagingTable."Charges Bearer"::DEBT;
        if PaymentJournal."Charges Bearer" = PaymentJournal."Charges Bearer"::BEN then HSBCStagingTable."Charges Bearer":=HSBCStagingTable."Charges Bearer"::CRED;
        //#138 VJ
        HSBCStagingTable."Batch Type":=PaymentJournal."Batch Type";
        HSBCStagingTable."Instruction to Bank":=PaymentJournal."Instruction to Bank"; //VJ 02DEC2024
        HSBCStagingTable."FPS Type":=PaymentJournal."FPS Type"; //VJ 02DEC2024
        HSBCStagingTable."FPS No.":=PaymentJournal."FPS No."; //VJ 02DEC2024
        HSBCStagingTable."Creditor Email Address 1":=PaymentJournal."Remittance Email 1";
        HSBCStagingTable."Creditor Email Address 2":=PaymentJournal."Remittance Email 2";
        HSBCStagingTable."Creditor Email Address 3":=PaymentJournal."Remittance Email 3";
        HSBCStagingTable."Creditor Email Address 4":=PaymentJournal."Remittance Email 4";
        HSBCStagingTable."Creditor Email Address 5":=PaymentJournal."Remittance Email 5";
        HSBCStagingTable."Creditor Email Address 6":=PaymentJournal."Remittance Email 6";
        HSBCStagingTable."Applied Entries to XML":=PaymentJournal."Applied Entries to XML";
        HSBCStagingTable."Debtor To Receipt":=PaymentJournal."Message to Recipient";
        if HSBCStagingTable.Currency = '' then HSBCStagingTable.Currency:='USD';
        if PaymentJournal."Account Type" = PaymentJournal."Account Type"::Vendor then begin
            if BankVendorAccount.GET(PaymentJournal."Account No.", PaymentJournal."Recipient Bank Account")then //
 AssignVendorBankAcc(HSBCStagingTable, BankVendorAccount, PaymentJournal);
        end
        else if PaymentJournal."Account Type" = PaymentJournal."Account Type"::"Bank Account" then begin //TEC.VJ 20112024
                if BankAccount.GET(PaymentJournal."Account No.")then //
 AssignBankAccInHSBCCredtr(HSBCStagingTable, BankAccount);
            end
            else if PaymentJournal."Account Type" = PaymentJournal."Account Type"::Employee then begin //TEC.VJ 28112024
                    if EmpBankAccount.GET(PaymentJournal."Account No.", PaymentJournal."Employee Bank Account")then //
 CopyEmployeeBankAccFieldsInHSBC(HSBCStagingTable, EmpBankAccount, PaymentJournal);
                end
                else //#242 TEC.VJ>> 
                    if PaymentJournal."Account Type" = PaymentJournal."Account Type"::Customer then begin
                        if CustomerBankAcc.GET(PaymentJournal."Account No.", PaymentJournal."Recipient Bank Account")then //
 AssignCustomerBankAcc(HSBCStagingTable, CustomerBankAcc, PaymentJournal);
                    end;
        //#242 TEC.VJ<< 
        HSBCStagingTable."Country/Region Code":=BankAccount."Country/Region Code";
        HSBCStagingTable.Modify();
        if PaymentSetCode.Get(PaymentJournal."Payment Set Code")then begin
            PaymentSetCode."Last Used Date":=Today;
            PaymentSetCode.Modify();
        end;
    end;
    procedure CopyICToHSBCStaging(var ICGenJnl: record "Gen. Journal Line"; HSBCConnectCustomerID: Text[35]; var HSBCStagingTable: Record "HSBC Outbound Staging Table")
    var
        BankAccount: Record "Bank Account";
        CitiOutbound: Codeunit CitiOutboundCodeunit;
        PaymentMethod: Record "Payment Method";
        ICGenJnl2: Record "Gen. Journal Line";
        ICPartner: Record "IC Partner";
        BankAccNo: code[20];
    begin
        HSBCStagingTable.Identification:=HSBCConnectCustomerID;
        HSBCStagingTable."Create Date":=DT2Date(ICGenJnl.SystemCreatedAt);
        HSBCStagingTable."Line No.":=ICGenJnl."Line No.";
        HSBCStagingTable.Amount:=ABS(ICGenJnl.Amount); //#77 TEC.VJ
        HSBCStagingTable."Service Level":=ICGenJnl."Lavel Service Code"; //#77 TEC.VJ
        HSBCStagingTable."Debtor To Receipt":=ICGenJnl."Message to Recipient"; //#77 TEC.VJ
        HSBCStagingTable."Source Code":=ICGenJnl."Source Code";
        HSBCStagingTable."Payment Reference No.":=ICGenJnl."Payment Reference";
        HSBCStagingTable."Posting Date":=CreateDateTime(ICGenJnl."Posting Date", Time);
        // if ICGenJnl."Payment Method Code" <> '' then
        //     if PaymentMethod.Get(ICGenJnl."Payment Method Code") then
        //         HSBCStagingTable."Payment Method Bank XML" := PaymentMethod."Payment Method Bank XML";
        HSBCStagingTable."Payment Method Bank XML":=ICGenJnl."Payment Method Bank XML";
        HSBCStagingTable."Payment Method":=ICGenJnl."Payment Method Code";
        HSBCStagingTable."Journal Template Name":=ICGenJnl."Journal Template Name";
        HSBCStagingTable."Journal Batch Name":=ICGenJnl."Journal Batch Name";
        HSBCStagingTable."Account Type":=ICGenJnl."Account Type";
        HSBCStagingTable."Account No.":=ICGenJnl."Account No.";
        HSBCStagingTable."Bal. Account Type":=ICGenJnl."Bal. Account Type";
        HSBCStagingTable."Bal. Account No.":=ICGenJnl."Bal. Account No.";
        HSBCStagingTable.Currency:=ICGenJnl."Currency Code";
        HSBCStagingTable."Batch Type":=ICGenJnl."Batch Type";
        AssignComInfoInHSBC(HSBCStagingTable);
        if BankAccount.Get(ICGenJnl."Account No.")then begin
            AssignBankAccountFieldsInHSBC(HSBCStagingTable, BankAccount);
        end;
        //#77 TEC.VJ>>
        ICGenJnl2.Reset();
        ICGenJnl2.SetRange("Journal Template Name", ICGenJnl."Journal Template Name");
        ICGenJnl2.SetRange("Journal Batch Name", ICGenJnl."Journal Batch Name");
        ICGenJnl2.SetRange("Document No.", ICGenJnl."Document No.");
        ICGenJnl2.SetRange("Account Type", ICGenJnl2."Account Type"::"IC Partner");
        if ICGenJnl2.FindFirst()then begin
            Clear(BankAccount);
            ICPartner.Get(ICGenJnl2."Account No.");
            if BankAccount.ChangeCompany(ICPartner."Inbox Details")then begin
                //#276 TEC.VJ 18MAR2025>>
                // if ICGenJnl2."PB Txf Bank Account" <> '' then//#293 TEC.VJ 02APR2025 Commented
                //    BankAccNo := ICGenJnl2."PB Txf Bank Account"
                // else
                BankAccNo:=ICGenJnl2."PB IC Account";
                //#276 TEC.VJ 18MAR2025<<
                if BankAccount.GET(BankAccNo)then AssignBankAccForHSBCCredtrIC(HSBCStagingTable, BankAccount);
            end;
        end;
        HSBCStagingTable.Modify();
    //#77 TEC.VJ<<
    end;
    procedure GetBatchNo2(TotalLines: Integer; IncrementBy: integer): Integer var
        Completed: Boolean;
        Int500: Integer;
        Int: Integer;
    begin
        Completed:=false;
        Int:=2;
        while(Completed = false)do begin
            Int500+=IncrementBy;
            if Not(TotalLines > Int500)then begin
                Completed:=true;
                exit(Int);
            end;
            Int+=1;
        end;
    end;
    procedure InsertHSBCBatchSetup(HSBCStagingTable: Record "HSBC Outbound Staging Table"; BatchNo: Text)
    var
        HSBCSetupTable: Record "HSBC Batch Setup";
    begin
        HSBCSetupTable.Init();
        HSBCSetupTable."Batch Type":=HSBCStagingTable."Batch Type";
        HSBCSetupTable."Batch No.":=BatchNo;
        HSBCSetupTable."Value Date":=DT2Date(HSBCStagingTable."Posting Date");
        HSBCSetupTable."Bal. Account No.":=HSBCStagingTable."Bal. Account No.";
        HSBCSetupTable."Country/Region Code":=HSBCStagingTable."Country/Region Code";
        HSBCSetupTable."Bank Integration Type":=HSBCSetupTable."Bank Integration Type"::HSBC; //TEC.VJ 13-112-25 Added code because it was not updating earlier
        HSBCSetupTable.Insert();
    end;
    //procedure GetNewBatchNo(BatchType: Option "HK Lower Value","HK Upper Value","US Lower Value","US Upper Value"): Text;
    procedure GetNewBatchNo(BatchType: Enum "Batch Type"): Text;
    var
        BankAPISetup: Record "Bank API Setup";
        NoSerMgmt: Codeunit "No. Series";
        BatchNo: Text;
    begin
        BankAPISetup.Get();
        if BatchType = BatchType::"HK Lower Value" then begin
            BankAPISetup.TestField("HKLV No. Series");
            BatchNo:=NoSerMgmt.GetNextNo(BankAPISetup."HKLV No. Series", Today, true);
            exit(BatchNo);
        end;
        if BatchType = BatchType::"HK Upper Value" then begin
            BankAPISetup.TestField("HKUV No. Series");
            BatchNo:=NoSerMgmt.GetNextNo(BankAPISetup."HKUV No. Series", Today, true);
            exit(BatchNo);
        end;
        if BatchType = BatchType::"US Lower Value" then begin
            BankAPISetup.TestField("USLV No. Series");
            BatchNo:=NoSerMgmt.GetNextNo(BankAPISetup."USLV No. Series", Today, true);
            exit(BatchNo);
        end;
        if BatchType = BatchType::"US Upper Value" then begin
            BankAPISetup.TestField("USUV No. Series");
            BatchNo:=NoSerMgmt.GetNextNo(BankAPISetup."USUV No. Series", Today, true);
            exit(BatchNo);
        end;
    end;
    procedure InsertHSBCSetupFromHSBCInbound(var PaymentJournal: record "Gen. Journal Line"; var HSBCStagingTable: Record "HSBC Outbound Staging Table"; RunModify: Boolean; p_NewBatchNo: Boolean)
    var
        HSBCStagingTable2: Record "HSBC Outbound Staging Table";
        TotalLines: Integer;
        BatchNo: Text;
        TempBatchNo: Text;
        HSBCBatchSetup: Record "HSBC Batch Setup";
    begin
        HSBCBatchSetup.Reset();
        HSBCBatchSetup.SetCurrentKey("Batch Type", "Value Date", "Batch No.");
        HSBCBatchSetup.SetRange("Batch Type", HSBCStagingTable."Batch Type");
        HSBCBatchSetup.SetRange("Value Date", DT2Date(HSBCStagingTable."Posting Date"));
        // HSBCBatchSetup.SetFilter("Country/Region Code", HSBCStagingTable."Country/Region Code");
        if HSBCStagingTable."Bank Integration Type" = HSBCStagingTable."Bank Integration Type"::HSBC then HSBCBatchSetup.SetRange("Bal. Account No.", PaymentJournal."Bal. Account No.") //TEC.VJ 24DEC2024
        else if HSBCStagingTable."Bank Integration Type" = HSBCStagingTable."Bank Integration Type"::Citi then begin
                HSBCBatchSetup.SetRange("Bal. Account No.", HSBCStagingTable."Debtor Bank Account");
            end;
        if(HSBCBatchSetup.FindLast()) and (p_NewBatchNo = false)then begin
            //#358 TEC.VJ 24JUNE2025>>
            //Commented By #395 TEC.VJ 27OCT2025
            // if (HSBCStagingTable."Batch Type" = HSBCStagingTable."Batch Type"::"HK Lower Value") and (HSBCStagingTable."Bank Integration Type" = HSBCStagingTable."Bank Integration Type"::HSBC) and (HSBCStagingTable."Bank Document No." <> '') then
            //    TempBatchNo := HSBCStagingTable."Bank Document No."
            // else
            //Commented By #395 TEC.VJ 27OCT2025
            TempBatchNo:=HSBCBatchSetup."Batch No.";
            //#358 TEC.VJ 24JUNE2025<<
            HSBCBatchSetup.CalcFields("HSBC No. of Records");
            if HSBCBatchSetup."HSBC No. of Records" <= 500 then BatchNo:=TempBatchNo
            else
            begin
                BatchNo:=TempBatchNo + '_' + Format(GetBatchNo2(TotalLines, 500));
                InsertHSBCBatchSetup(HSBCStagingTable, BatchNo);
            end;
        end
        else
        begin
            //#358 TEC.VJ 24JUNE2025<<
            //NT_ 21OCT2025<<
            /*   if (HSBCStagingTable."Batch Type" = HSBCStagingTable."Batch Type"::"HK Lower Value") and (HSBCStagingTable."Bank Integration Type" = HSBCStagingTable."Bank Integration Type"::HSBC) and (HSBCStagingTable."Bank Document No." <> '') then
                  BatchNo := HSBCStagingTable."Bank Document No."
              else */
            //NT_ 21OCT2025>>
            BatchNo:=GetNewBatchNo(HSBCStagingTable."Batch Type");
            //#358 TEC.VJ 24JUNE2025>> 
            //BatchNo += '_' + format(CurrentDateTime, 0, '<Day,2><Month,2><Year>_<Hours24,2><Minutes,2><Seconds,2>');//TEC.VJ 02DEC2024
            InsertHSBCBatchSetup(HSBCStagingTable, BatchNo);
        end;
        if RunModify then begin
            HSBCStagingTable2.Get(HSBCStagingTable."Bank Document No.");
            HSBCStagingTable2."Batch Id":=BatchNo;
            HSBCStagingTable2.Modify();
        end;
        PaymentJournal."Batch No.":=BatchNo;
    end;
    procedure AssignComInfoInHSBC(var HSBCStagingTable: Record "HSBC Outbound Staging Table")
    var
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.get();
        HSBCStagingTable."Debtor Name":=CompanyInfo.Name;
        HSBCStagingTable."Debtor Address":=CompanyInfo.Address;
        HSBCStagingTable."Debtor Address 2":=CompanyInfo."Address 2";
        HSBCStagingTable."Debtor Country":=CompanyInfo."Country/Region Code";
        HSBCStagingTable."Debtor Post Code":=CompanyInfo."Post Code";
    end;
    procedure AssignBankAccountFieldsInHSBC(var HSBCStagingTable: Record "HSBC Outbound Staging Table"; BankAccount: Record "Bank Account")
    begin
        HSBCStagingTable."Debtor Bank Account":=BankAccount."Bank Account No.";
        if HSBCStagingTable.Currency = '' then HSBCStagingTable.Currency:=BankAccount."Currency Code";
        HSBCStagingTable."Debtor Currency Code":=BankAccount."Currency Code Custom"; //TEC.VJ 25112024
        if HSBCStagingTable.Currency = '' then HSBCStagingTable.Currency:='USD';
        HSBCStagingTable."Debtor Bank Clearing Code":=BankAccount."Bank Clearing Code";
        if BankAccount."SWIFT Code" <> '' then //HSBCStagingTable."Debtor SWIFT Code" := GetSwiftName(BankAccount."SWIFT Code");
            HSBCStagingTable."Debtor SWIFT Code":=BankAccount."SWIFT Code"; //VJ09DEC2024
        // HSBCStagingTable."Debtor Bank Acc Name" := BankAccount.Name; 
        HSBCStagingTable."Debtor Bank Acc Name":=BankAccount."Account Holder Name"; //NT10FEB2026
        HSBCStagingTable."Debtor Bank Address":=BankAccount.Address;
        HSBCStagingTable."Debtor Bank Address 2":=BankAccount."Address 2";
        HSBCStagingTable."Debtor Bank Country":=BankAccount."Country/Region Code";
        HSBCStagingTable."Debtor Bank Post Code":=BankAccount."Post Code";
        HSBCStagingTable."Country/Region Code":=BankAccount."Country/Region Code";
        HSBCStagingTable."Debtor ACH ID":=BankAccount."No.";
        HSBCStagingTable."Debtor ABA Routing Code":=BankAccount."ABA Routing Code"; //TEC.VJ 27/NOV/2024
        //#110>>
        // HSBCStagingTable."Debtor Name" := BankAccount."Bank Beneficiary Name";
        HSBCStagingTable."Debtor Name":=BankAccount."Account Holder Name";
        HSBCStagingTable."Debtor Address":=BankAccount.Address;
        HSBCStagingTable."Debtor Address 2":=BankAccount."Address 2";
        //#110<<
        HSBCStagingTable."Bank Integration Type":=BankAccount."Bank Integration Type";
    end;
    procedure AssignBankAccForHSBCCredtrIC(var HSBCStagingTable: Record "HSBC Outbound Staging Table"; BankAccount: Record "Bank Account")
    begin
        //#104 TEC.VJ>> //#155 TEC.VJ Commented
        // HSBCStagingTable."Creditor Bank Account" := BankAccount."Bank Account No.";
        // if BankAccount.IBAN <> '' then
        //     HSBCStagingTable."Creditor IBAN Account" := BankAccount.IBAN
        // else
        //     HSBCStagingTable."Creditor IBAN Account" := BankAccount."Bank Account No.";
        //#104 TEC.VJ<<
        // HSBCStagingTable."Creditor Bank Acc Name" := BankAccount.Name;
        HSBCStagingTable."Creditor Bank Account":=BankAccount."Bank Account No."; //#316 TEC.VJ 23APR2025
        HSBCStagingTable."Creditor Bank Acc Name":=BankAccount."Bank Beneficiary Name"; //#155 TEC.VJ
        HSBCStagingTable."Creditor Address":=BankAccount.Address;
        HSBCStagingTable."Creditor Address 2":=BankAccount."Address 2";
        HSBCStagingTable."Creditor Country":=BankAccount."Country/Region Code";
        HSBCStagingTable."Creditor Post Code":=BankAccount."Post Code";
        //HSBCStagingTable."Creditor Swift Code" := GetSwiftName(BankAccount."SWIFT Code");
        HSBCStagingTable."Creditor Swift Code":=BankAccount."SWIFT Code"; //VJ09DEC2024
        HSBCStagingTable."Creditor Bank Branch Code":=BankAccount."Bank Branch No.";
        HSBCStagingTable."Creditor Bank Clearing Code":=BankAccount."Bank Clearing Code";
        HSBCStagingTable."Creditor Country":=BankAccount."Country/Region Code";
        HSBCStagingTable."Creditor Currency Code":=BankAccount."Currency Code Custom"; //TEC.VJ 25112024
        HSBCStagingTable."Creditor IBAN Account":=BankAccount.IBAN; //TEC.VJ 10APR2025 
        HSBCStagingTable."Creditor ABA/BSB No.":=BankAccount."ABA Routing Code"; //TEC.VJ 10APR2025
    end;
    procedure AssignVendorBankAcc(var HSBCStagingTable: Record "HSBC Outbound Staging Table"; BankVendorAccount: Record "Vendor Bank Account"; PaymentJournal: Record "Gen. Journal Line")
    var
        // CountryRegion: Record "Country/Region";
        BankAccount: record "Bank Account";
        Addrss: array[5]of text[35];
    begin
        // CountryRegion.Get(BankVendorAccount."Country/Region Code");//#272 TEC.VJ Commented
        // HSBCStagingTable."Purpose Code" := CountryRegion."Purpose Code (HSBC)  Prefix" + HSBCStagingTable."Purpose Code";//#272 TEC.VJ Commented
        //#104 TEC.VJ>>
        // HSBCStagingTable."Creditor Bank Account" := BankVendorAccount."Bank Account No.";
        if BankVendorAccount.IBAN <> '' then HSBCStagingTable."Creditor IBAN Account":=BankVendorAccount.IBAN
        else
            // HSBCStagingTable."Creditor IBAN Account" := BankVendorAccount."Bank Account No.";//TEC.VJ 16012025
            HSBCStagingTable."Creditor Bank Account":=BankVendorAccount."Bank Account No."; //TEC.VJ 16012025
        //#104 TEC.VJ<<
        HSBCStagingTable."Creditor Bank Acc Name":=BankVendorAccount."Beneficiary Name";
        //#215 TEC.VJ 12022025>>
        Addrss[1]:=BankVendorAccount."Beneficiary Name 2";
        Addrss[2]:=BankVendorAccount."Beneficiary Name 3";
        //Addrss[2] := BankVendorAccount.Address;
        Addrss[3]:=BankVendorAccount.Address;
        Addrss[4]:=BankVendorAccount."Address 2";
        Addrss[5]:=BankVendorAccount."Address 3";
        CompressArray(Addrss);
        HSBCStagingTable."Creditor Address":=Addrss[1];
        HSBCStagingTable."Creditor Address 2":=Addrss[2];
        HSBCStagingTable."Creditor Address 3":=Addrss[3];
        //#215 TEC.VJ 12022025<<
        HSBCStagingTable."Creditor Country":=BankVendorAccount."Country/Region Code";
        HSBCStagingTable."Creditor Post Code":=BankVendorAccount."Post Code";
        //HSBCStagingTable."Creditor Swift Code" := GetSwiftName(BankVendorAccount."SWIFT Code");
        HSBCStagingTable."Creditor Swift Code":=BankVendorAccount."SWIFT Code"; //VJ09DEC2024
        HSBCStagingTable."Creditor Country":=BankVendorAccount."Country/Region Code";
        HSBCStagingTable."Creditor Bank Branch Code":=BankVendorAccount."Bank Branch No."; //
        HSBCStagingTable."Creditor Bank Clearing Code":=BankVendorAccount."Bank Clearing Code";
        //HSBCStagingTable."Creditor Currency Code" := BankVendorAccount."Currency Code";//TEC.VJ 25112024 //VJ 15Jan2025 commented #159
        //if batch type is not CITI949 - it does not need to take. this field is not applied for others. 17Jan2025 that is only for citi not hsbc
        //if PaymentJournal."Batch Type" = PaymentJournal."Batch Type"::CITI949 then
        //  HSBCStagingTable."Creditor Currency Code" := PaymentJournal."Trans. Currency";//VJ 15Jan2025 //#159
        if PaymentJournal."Account Type" = PaymentJournal."Account Type"::"Bank Account" then begin
            BankAccount.get(PaymentJournal."Account No.");
            HSBCStagingTable."Creditor ABA/BSB No.":=BankAccount."Bank Clearing Code";
        end
        else
            HSBCStagingTable."Creditor ABA/BSB No.":=BankVendorAccount."ABA/BSB No."; //TEC.VJ 25112024
        HSBCStagingTable."Recipient Bank Name":=BankVendorAccount.Name; //TEC.VJ06102025
        //#232 TEC.VJ>>
        // if not PaymentJournal."No Corresponding Bank for Pmt" then begin
        //     HSBCStagingTable."Creditor Inter. Bank Acc. No" := BankVendorAccount."Correspondent Bank Account No.";//TEC.VJ 25112024
        //     HSBCStagingTable."Creditor Inter. Bank Country" := BankVendorAccount."Corresp. Country/Region Code";//TEC.VJ 25112024
        //     HSBCStagingTable."Creditor Inter. Bank SWIFT" := BankVendorAccount."Correspondent Swift Code";//TEC.VJ 25112024
        // end;
        HSBCStagingTable."Creditor Inter. Bank Acc. No":=PaymentJournal."Intermediary Bank Account No";
        HSBCStagingTable."Creditor Inter. Bank Country":=PaymentJournal."Intermediary Bank Country";
        HSBCStagingTable."Creditor Inter. Bank SWIFT":=PaymentJournal."Intermediary Bank SWIFT / BIC";
    //#232 TEC.VJ<<
    // BankVendorAccount."Correspondent Bank Account No."
    end;
    //#242 TEC.VJ>>
    procedure AssignCustomerBankAcc(var HSBCStagingTable: Record "HSBC Outbound Staging Table"; CustomerBankAcc: Record "Customer Bank Account"; PaymentJournal: Record "Gen. Journal Line")
    var
        // CountryRegion: Record "Country/Region";
        BankAccount: record "Bank Account";
        Addrss: array[5]of text[35];
    begin
        // CountryRegion.Get(CustomerBankAcc."Country/Region Code");//#272 TEC.VJ Commented
        // HSBCStagingTable."Purpose Code" := CountryRegion."Purpose Code (HSBC)  Prefix" + HSBCStagingTable."Purpose Code";//#272 TEC.VJ Commented
        if CustomerBankAcc.IBAN <> '' then HSBCStagingTable."Creditor IBAN Account":=CustomerBankAcc.IBAN
        else
            HSBCStagingTable."Creditor Bank Account":=CustomerBankAcc."Bank Account No."; //TEC.VJ 16012025
        HSBCStagingTable."Creditor Bank Acc Name":=CustomerBankAcc."Beneficiary Name";
        Addrss[1]:=CustomerBankAcc."Beneficiary Name 2";
        Addrss[2]:=CustomerBankAcc."Beneficiary Name 3";
        Addrss[3]:=CustomerBankAcc.Address;
        Addrss[4]:=CustomerBankAcc."Address 2";
        Addrss[5]:=CustomerBankAcc."Address 3";
        CompressArray(Addrss);
        HSBCStagingTable."Creditor Address":=Addrss[1];
        HSBCStagingTable."Creditor Address 2":=Addrss[2];
        HSBCStagingTable."Creditor Address 3":=Addrss[3];
        HSBCStagingTable."Creditor Country":=CustomerBankAcc."Country/Region Code";
        HSBCStagingTable."Creditor Post Code":=CustomerBankAcc."Post Code";
        HSBCStagingTable."Creditor Swift Code":=CustomerBankAcc."SWIFT Code";
        HSBCStagingTable."Creditor Country":=CustomerBankAcc."Country/Region Code";
        HSBCStagingTable."Creditor Bank Branch Code":=CustomerBankAcc."Bank Branch No."; //
        HSBCStagingTable."Creditor Bank Clearing Code":=CustomerBankAcc."Bank Clearing Code";
        if PaymentJournal."Account Type" = PaymentJournal."Account Type"::"Bank Account" then begin
            BankAccount.get(PaymentJournal."Account No.");
            HSBCStagingTable."Creditor ABA/BSB No.":=BankAccount."Bank Clearing Code";
        end
        else
            HSBCStagingTable."Creditor ABA/BSB No.":=CustomerBankAcc."ABA/BSB No.";
        HSBCStagingTable."Creditor Inter. Bank Acc. No":=PaymentJournal."Intermediary Bank Account No";
        HSBCStagingTable."Creditor Inter. Bank Country":=PaymentJournal."Intermediary Bank Country";
        HSBCStagingTable."Creditor Inter. Bank SWIFT":=PaymentJournal."Intermediary Bank SWIFT / BIC";
        HSBCStagingTable."Recipient Bank Name":=CustomerBankAcc.Name; //TEC.VJ06102025
    end;
    procedure AssignBankAccInHSBCCredtr(var HSBCStagingTable: Record "HSBC Outbound Staging Table"; BankAccount: Record "Bank Account")
    var
        Bankved: page "Vendor Bank Account Card";
    begin
        //#104 TEC.VJ>>
        // HSBCStagingTable."Creditor Bank Account" := BankAccount."Bank Account No.";
        // if BankAccount.IBAN <> '' then //#153 TEC.VJ Commented
        //     HSBCStagingTable."Creditor IBAN Account" := BankAccount.IBAN
        // else
        //     HSBCStagingTable."Creditor IBAN Account" := BankAccount."Bank Account No.";
        //#104 TEC.VJ<<
        HSBCStagingTable."Creditor Bank Account":=BankAccount."Bank Account No."; //#153 TEC.VJ
        HSBCStagingTable."Creditor Bank Acc Name":=BankAccount."Bank Beneficiary Name"; //#153 TEC.VJ
        HSBCStagingTable."Creditor Address":=BankAccount.Address;
        HSBCStagingTable."Creditor Address 2":=BankAccount."Address 2";
        HSBCStagingTable."Creditor Country":=BankAccount."Country/Region Code";
        HSBCStagingTable."Creditor Post Code":=BankAccount."Post Code";
        //HSBCStagingTable."Creditor Swift Code" := GetSwiftName(BankAccount."SWIFT Code");
        HSBCStagingTable."Creditor Swift Code":=BankAccount."SWIFT Code"; //VJ09DEC2024
        HSBCStagingTable."Creditor Bank Branch Code":=BankAccount."Bank Branch No."; //
        HSBCStagingTable."Creditor Bank Clearing Code":=BankAccount."Bank Clearing Code";
        HSBCStagingTable."Creditor ABA/BSB No.":=BankAccount."Bank Clearing Code"; //VJ 20Jan2025
        HSBCStagingTable."Recipient Bank Name":=BankAccount.Name; //TEC.VJ06102025
    // HSBCStagingTable."Creditor Email Address 1" := BankAccount."Email Address 1";
    // HSBCStagingTable."Creditor Email Address 2" := BankAccount."Email Address 2";
    // HSBCStagingTable."Creditor Email Address 3" := BankAccount."Email Address 3";
    // HSBCStagingTable."Creditor Email Address 4" := BankAccount."Email Address 4";
    // HSBCStagingTable."Creditor Email Address 5" := BankAccount."Email Address 5";
    // BankAccount."Correspondent Bank Account No."
    end;
    //copy fields from Employee bank account into HSBC Staging Table
    procedure CopyEmployeeBankAccFieldsInHSBC(var HSBCStagingTable: Record "HSBC Outbound Staging Table"; EmpBankAccount: Record "Employee Bank Account"; PaymentJnl: Record "Gen. Journal Line")
    var
        Bankved: page "Vendor Bank Account Card";
        Addrss: array[5]of text[35];
    begin
        HSBCStagingTable."Creditor Bank Account":=EmpBankAccount."Bank Account No.";
        HSBCStagingTable."Creditor Bank Acc Name":=EmpBankAccount."Beneficiary Name";
        //#216 TEC.VJ 12022025>>
        Addrss[1]:=EmpBankAccount."Beneficiary Name 2";
        Addrss[2]:=EmpBankAccount."Beneficiary Name 3"; //VJ 25Feb2025
        //Addrss[2] := EmpBankAccount.Address;
        Addrss[3]:=EmpBankAccount.Address;
        Addrss[4]:=EmpBankAccount."Address 2";
        Addrss[5]:=EmpBankAccount."Address 3";
        CompressArray(Addrss);
        HSBCStagingTable."Creditor Address":=Addrss[1];
        HSBCStagingTable."Creditor Address 2":=Addrss[2];
        HSBCStagingTable."Creditor Address 3":=Addrss[3];
        //#216 TEC.VJ 12022025<<
        HSBCStagingTable."Creditor Country":=EmpBankAccount."Country/Region Code";
        HSBCStagingTable."Creditor Post Code":=EmpBankAccount."Post Code";
        //HSBCStagingTable."Creditor Swift Code" := GetSwiftName(EmpBankAccount."SWIFT Code");
        HSBCStagingTable."Creditor Swift Code":=EmpBankAccount."SWIFT Code"; //VJ09DEC2024
        //        HSBCStagingTable."Creditor IFSC Code" := EmpBankAccount."IFSC Code";
        HSBCStagingTable."Creditor IBAN Account":=EmpBankAccount.IBAN; //VJ 11042025 #369
        //VJ 28012025 Start
        if(EmpBankAccount."ABA/BSB No." <> '') and (EmpBankAccount."Swift Code" <> '')then HSBCStagingTable."Creditor ABA/BSB No.":=EmpBankAccount."ABA/BSB No.";
        if(EmpBankAccount."ABA/BSB No." = '') and (EmpBankAccount."Swift Code" <> '')then HSBCStagingTable."Creditor ABA/BSB No.":=EmpBankAccount."Swift Code";
        if(EmpBankAccount."ABA/BSB No." <> '') and (EmpBankAccount."Swift Code" = '')then HSBCStagingTable."Creditor ABA/BSB No.":=EmpBankAccount."ABA/BSB No.";
        //VJ 28012025 End
        //#232 TEC.VJ>>
        HSBCStagingTable."Creditor Inter. Bank Acc. No":=PaymentJnl."Intermediary Bank Account No";
        HSBCStagingTable."Creditor Inter. Bank Country":=PaymentJnl."Intermediary Bank Country";
        HSBCStagingTable."Creditor Inter. Bank SWIFT":=PaymentJnl."Intermediary Bank SWIFT / BIC";
        //#232 TEC.VJ<<
        HSBCStagingTable."Recipient Bank Name":=EmpBankAccount."Bank Name"; //TEC.VJ06102025
    end;
    procedure GetSwiftName(SWIFTCode: Code[20]): Text[100]var
        SwiftCodeRec: Record "SWIFT Code";
    begin
        if SwiftCodeRec.Get(SwiftCode)then exit(SwiftCodeRec.Name);
    end;
    procedure InsertStagingData(TemplateName1: Code[20]; BatchName51: Code[20])
    var
        PaymentJournal: record "Gen. Journal Line";
        HSBCStagingTable: Record "HSBC Outbound Staging Table";
        CITIStagingTable: Record "Citi Outbound Staging Table";
        BankAccount: Record "Bank Account";
        SalesSetup: Record "Sales & Receivables Setup";
        CompanyInfo: Record "Company Information";
        CitiOutbound: Codeunit CitiOutboundCodeunit;
        NewBatchNo: Boolean;
    begin
        NewBatchNo:=true;
        SalesSetup.Get();
        CompanyInfo.Get();
        PaymentJournal.Reset();
        PaymentJournal.SetRange("Journal Template Name", TemplateName1);
        PaymentJournal.SetRange("Journal Batch Name", BatchName51);
        PaymentJournal.SetFilter("Source Code", '=%1', 'PAYMENTJNL');
        PaymentJournal.SetRange("Bypass API", false);
        if PaymentJournal.FindSet()then repeat VerifyBeforeApprove(PaymentJournal); //#128 TEC.VJ
                if BankAccount.get(PaymentJournal."Bal. Account No.")then;
                //AssignBankDocumentNo(PaymentJournal);//VJ#47 12DEC2024 //VJ 21Jan2025_commented
                if BankAccount."Bank Integration Type" = BankAccount."Bank Integration Type"::HSBC then begin
                    HSBCStagingTable.Reset();
                    //HSBCStagingTable.SetRange("Document No.", PaymentJournal."Document No.");
                    HSBCStagingTable.SetRange("Bank Document No.", PaymentJournal."Bank Document No.");
                    if not HSBCStagingTable.FindFirst()then begin
                        HSBCStagingTable.Init();
                        HSBCStagingTable."Bank Document No.":=PaymentJournal."Bank Document No.";
                        HSBCStagingTable."Document No.":=PaymentJournal."Document No.";
                        HSBCStagingTable.Insert();
                        CopyPaymentJournalToHSBCStaging(PaymentJournal, SalesSetup."HSBC Connect CustomerID", HSBCStagingTable);
                        InsertHSBCSetupFromHSBCInbound(PaymentJournal, HSBCStagingTable, true, NewBatchNo); //create batch no.
                        PaymentJournal.Modify();
                        NewBatchNo:=false; //NT_ 26-02-2026  //NT_ 21-04-2026 uncomment
                    end;
                end
                else //10042024
                    // AssignBankDocumentNo(PaymentJournal);//VJ#47 12DEC2024//VJ 21Jan2025_commented
                    if BankAccount."Bank Integration Type" = BankAccount."Bank Integration Type"::Citi then begin
                        CITIStagingTable.Reset();
                        //CITIStagingTable.SetRange("Document No.", PaymentJournal."Document No.");
                        CITIStagingTable.SetRange("Bank Document No.", PaymentJournal."Bank Document No.");
                        if not CITIStagingTable.FindFirst()then begin
                            CITIStagingTable.Init();
                            CITIStagingTable."Bank Document No.":=PaymentJournal."Bank Document No.";
                            CITIStagingTable."Document No.":=PaymentJournal."Document No.";
                            CITIStagingTable.Insert();
                            CitiOutbound.CopyPaymentJournalToCitiStaging(PaymentJournal, SalesSetup."Citi Connect CustomerID", CitiStagingTable);
                            //CitiOutbound.InsertHSBCSetupFromCitiInbound(PaymentJournal, CITIStagingTable, true);
                            PaymentJournal.Modify();
                        end;
                    end;
            until PaymentJournal.Next() = 0;
        PaymentJournal.SetFilter("Source Code", '=%1', 'INTERCOMP');
        //PaymentJournal.SetFilter(Amount, '>%1', 0);
        PaymentJournal.SetRange("Bypass API", false);
        if PaymentJournal.FindSet()then repeat //VerifyBeforeApprove(PaymentJournal);//#128 TEC.VJ
                if PaymentJournal."Account Type" = PaymentJournal."Account Type"::"Bank Account" then if BankAccount.get(PaymentJournal."Account No.")then;
                if BankAccount."Bank Integration Type" = BankAccount."Bank Integration Type"::HSBC then begin
                    HSBCStagingTable.Reset();
                    HSBCStagingTable.SetRange("Bank Document No.", PaymentJournal."Bank Document No."); //03012025
                    if not HSBCStagingTable.FindFirst()then begin
                        HSBCStagingTable.Init();
                        HSBCStagingTable."Bank Document No.":=PaymentJournal."Bank Document No."; //03012025
                        HSBCStagingTable."Document No.":=PaymentJournal."Document No.";
                        HSBCStagingTable.Insert();
                        CopyICToHSBCStaging(PaymentJournal, SalesSetup."HSBC Connect CustomerID", HSBCStagingTable);
                        InsertHSBCSetupFromHSBCInbound(PaymentJournal, HSBCStagingTable, true, NewBatchNo);
                        NewBatchNo:=false; //NT_ 26-02-2026 //NT_ 21-04-2026 uncomment
                        PaymentJournal.Modify();
                    end;
                end
                else //10042024
                    if BankAccount."Bank Integration Type" = BankAccount."Bank Integration Type"::Citi then begin
                        CITIStagingTable.Reset();
                        CITIStagingTable.SetRange("Bank Document No.", PaymentJournal."Bank Document No."); //#155 TEC.VJ
                        if not CITIStagingTable.FindFirst()then begin
                            CITIStagingTable.Init();
                            CITIStagingTable."Bank Document No.":=PaymentJournal."Bank Document No."; //#155 TEC.VJ
                            CITIStagingTable."Document No.":=PaymentJournal."Document No."; //#155 TEC.VJ
                            CITIStagingTable.Insert();
                            CitiOutbound.CopyICToCitiStaging(PaymentJournal, SalesSetup."Citi Connect CustomerID", CitiStagingTable);
                            //CitiOutbound.InsertHSBCSetupFromCitiInbound(PaymentJournal, CITIStagingTable, true);// no need to create batch for Citi and use document no. as batch
                            PaymentJournal.Modify();
                        end;
                    end;
            until PaymentJournal.Next() = 0;
    end;
    procedure AssignBankDocumentNo(var p_PaymentJournal: Record "Gen. Journal Line")
    var
        l_PaymentJournal: Record "Gen. Journal Line";
        l_GLSetup: Record "General Ledger Setup";
        l_BankDocNo: Code[20];
        NoSeriesMgmt: Codeunit "No. Series";
    begin
        if p_PaymentJournal."Bank Document No." <> '' then exit;
        l_GLSetup.Get();
        l_GLSetup.TestField("Bank Document Nos.");
        l_BankDocNo:=NoSeriesMgmt.GetNextNo(l_GLSetup."Bank Document Nos.");
        p_PaymentJournal."Bank Document No.":=l_BankDocNo;
    // l_PaymentJournal.Reset();
    // l_PaymentJournal.SetRange("Journal Template Name", p_PaymentJournal."Journal Template Name");
    // l_PaymentJournal.SetRange("Journal Batch Name", p_PaymentJournal."Journal Batch Name");
    // l_PaymentJournal.SetRange("Document No.", p_PaymentJournal."Document No.");
    // IF l_PaymentJournal.FindFirst() then
    //     l_PaymentJournal.ModifyAll("Bank Document No.", l_BankDocNo);
    end;
    //#128 TEC.VJ>>
    procedure VerifyBeforeApprove(var PaymentJournal: record "Gen. Journal Line")
    var
        HSBCOutbound: Record "HSBC Outbound Staging Table";
    begin
        //vj 05March2025 Start 
        HSBCOutbound.Reset();
        HSBCOutbound.SetRange("Bank Document No.", PaymentJournal."Bank Document No.");
        if HSBCOutbound.FindFirst()then Error('HSBC Outbound already exist for Bank Document No.:%1', PaymentJournal."Bank Document No.");
        //vj 05March2025 End
        case PaymentJournal."Batch Type" of "Batch Type"::"HK Upper Value", "Batch Type"::"US Upper Value", "Batch Type"::CITI392, "Batch Type"::CITI391, "Batch Type"::CITI403, "Batch Type"::CITI393: begin
            TestMandotoryFields(PaymentJournal);
        end;
        "Batch Type"::"HK Lower Value": begin
            TestMandotoryFields(PaymentJournal);
            PaymentJournal.TestField("Payment Set Code");
        end;
        "Batch Type"::CITI949: begin
            TestMandotoryFields(PaymentJournal);
            //PaymentJournal.TestField("Payment Set Code");//VJ 10JAN2025
            PaymentJournal.TestField("Purpose Code");
            PaymentJournal.TestField("IFSC Code");
        end;
        // ExpressionOrRange:
        end;
    end;
    //#128 TEC.VJ<<
    local procedure TestMandotoryFields(var PaymentJournal: record "Gen. Journal Line")
    begin
        if PaymentJournal."Account Type" <> PaymentJournal."Account Type"::Customer then PaymentJournal.TestField("Document Type");
        PaymentJournal.TestField("Posting Date");
        PaymentJournal.TestField("Document No.");
        PaymentJournal.TestField("Bank Document No.");
        PaymentJournal.TestField("Account Type");
        PaymentJournal.TestField("Account No.");
        PaymentJournal.TestField("Description");
        PaymentJournal.TestField("Payment Method Code");
        PaymentJournal.TestField("Amount");
        //PaymentJournal.TestField("Charges Bearer");
        PaymentJournal.TestField("Bal. Account Type");
        PaymentJournal.TestField("Bal. Account No.");
        PaymentJournal.TestField("Shortcut Dimension 1 Code");
        PaymentJournal.TestField("Shortcut Dimension 2 Code");
        PaymentJournal.TestField("Shortcut Dimension 8 Code");
    end;
    //>>#138 start
    procedure GetChargesBearerConversion(p_ChrgesBearer: text[30]): text begin
    end;
//<<#138 End VJ 07Jan24
}
