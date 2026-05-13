codeunit 50141 CitiOutboundCodeunit
{
    Permissions = tabledata "Citi Outbound Staging Table"=rmid;

    procedure CreateAndUpdateCitiStagingOutbound(var GenJnlLine: record "Gen. Journal Line"; CitiConnectCustomerID: Text[35])
    var
        CitiStagingTable: Record "Citi Outbound Staging Table";
        CitiOutbound: Codeunit CitiOutboundCodeunit;
    begin
        if(GenJnlLine."Source Code" = 'PAYMENTJNL')then begin
            CitiStagingTable.Reset();
            CitiStagingTable.SetRange("Bank Document No.", GenJnlLine."Bank Document No.");
            if Not CitiStagingTable.FindFirst()then begin
                CitiStagingTable.Init();
                CitiStagingTable."Bank Document No.":=GenJnlLine."Bank Document No.";
                CitiStagingTable."Document No.":=GenJnlLine."Document No.";
                CitiStagingTable.Insert();
                CitiStagingTable."Line No.":=GenJnlLine."Line No.";
                CopyPaymentJournalToCitiStaging(GenJnlLine, CitiConnectCustomerID, CitiStagingTable);
                //CitiOutbound.InsertHSBCSetupFromCitiInbound(GenJnlLine, CitiStagingTable, true);
                GenJnlLine.Modify();
            //10042024
            end
            else
            begin
                CopyPaymentJournalToCitiStaging(GenJnlLine, CitiConnectCustomerID, CitiStagingTable);
                //CitiOutbound.InsertHSBCSetupFromCitiInbound(GenJnlLine, CitiStagingTable, true);
                GenJnlLine.Modify();
            //10042024
            end;
        end
        else if(GenJnlLine."Source Code" = 'INTERCOMP')then begin
                CitiStagingTable.Reset();
                CitiStagingTable.SetRange("Bank Document No.", GenJnlLine."Bank Document No.");
                if Not CitiStagingTable.FindFirst()then begin
                    CitiStagingTable.Init();
                    CitiStagingTable."Bank Document No.":=GenJnlLine."Bank Document No.";
                    CitiStagingTable."Document No.":=GenJnlLine."Document No.";
                    CitiStagingTable.Insert();
                    CitiStagingTable."Line No.":=GenJnlLine."Line No.";
                    CopyICToCitiStaging(GenJnlLine, CitiConnectCustomerID, CitiStagingTable);
                    //CitiOutbound.InsertHSBCSetupFromCitiInbound(GenJnlLine, CitiStagingTable, true);
                    GenJnlLine.Modify();
                //10042024
                end
                else
                begin
                    CopyICToCitiStaging(GenJnlLine, CitiConnectCustomerID, CitiStagingTable);
                    //CitiOutbound.InsertHSBCSetupFromCitiInbound(GenJnlLine, CitiStagingTable, true);
                    GenJnlLine.Modify();
                //10042024
                end;
            end;
    end;
    procedure CopyPaymentJournalToCitiStaging(var PaymentJournal: record "Gen. Journal Line"; CitiConnectCustomerID: Text[35]; var CitiStagingTable: Record "Citi Outbound Staging Table")
    var
        BankVendorAccount: Record "Vendor Bank Account";
        CustBankAccount: Record "Customer Bank Account";
        EmpBankAccount: Record "Employee Bank Account";
        BankAccount: Record "Bank Account";
        CitiOutbound: Codeunit CitiOutboundCodeunit;
        PaymentMethod: Record "Payment Method";
        PaymentSetCode: Record "Payment Set Code";
    begin
        CitiStagingTable."Create Date Time":=CurrentDateTime;
        CitiStagingTable."Create Date":=DT2Date(CurrentDateTime);
        CitiStagingTable.Identification:=CitiConnectCustomerID;
        CitiStagingTable."Service Level":=PaymentJournal."Lavel Service Code";
        CitiStagingTable."Posting Date":=PaymentJournal."Posting Date";
        CitiStagingTable."Batch Id":=PaymentJournal."Bank Document No."; //VJ 15Nov2024 //31DEC2024
        CitiStagingTable."Purpose Code":=PaymentJournal."Purpose Code Preflix" + ' ' + PaymentJournal."Purpose Code"; //#272 TEC.VJ //VJ22NOV2024
        CitiStagingTable."Payment Purpose":=PaymentJournal."Payment Purpose"; //#145
        CitiStagingTable."Creditor IFSC Code":=PaymentJournal."IFSC Code"; //29nov2024
        CitiStagingTable."Word Link":=PaymentJournal."World Link"; //29nov2024
        CitiStagingTable."Source Code":=PaymentJournal."Source Code";
        CitiStagingTable."Trans. Amt.":=PaymentJournal."Trans. Amt.";
        CitiStagingTable."Trans. Currency":=PaymentJournal."Trans. Currency";
        CitiStagingTable."Exchange Rate":=PaymentJournal."Exchange Rate";
        CitiStagingTable."Journal Template Name":=PaymentJournal."Journal Template Name";
        CitiStagingTable."Journal Batch Name":=PaymentJournal."Journal Batch Name";
        CitiStagingTable."Account Type":=PaymentJournal."Account Type";
        CitiStagingTable."Account No.":=PaymentJournal."Account No.";
        CitiStagingTable."Bal. Account Type":=PaymentJournal."Bal. Account Type";
        CitiStagingTable."Bal. Account No.":=PaymentJournal."Bal. Account No.";
        // if PaymentJournal."Payment Method Code" <> '' then
        //     if PaymentMethod.Get(PaymentJournal."Payment Method Code") then
        //         CitiStagingTable."Payment Method" := PaymentMethod."Payment Method Bank XML";
        CitiStagingTable."Payment Method":=PaymentJournal."Payment Method Code";
        CitiStagingTable."Payment Method Bank XML":=PaymentJournal."Payment Method Bank XML";
        CitiStagingTable."Batch Type":=PaymentJournal."Batch Type";
        CitiStagingTable."Debtor To Receipt":=PaymentJournal."Message to Recipient";
        //VJ 19FEB2025 Start
        if(PaymentJournal."Purpose Code" = '') AND (PaymentJournal."Payment Purpose" = '') AND (PaymentJournal."Message to Recipient" = '')then CitiStagingTable."Debtor To Receipt":='-';
        //VJ 19FEB2025 End
        //#127 VJ
        // if (PaymentJournal."Message to Recipient" = '') and (PaymentJournal."Purpose Code" = '') and (PaymentJournal."Applied Entries to XML" = '') then
        //     CitiStagingTable."Debtor To Receipt" := '-';
        //code commented on 20Jan2025 to update the value same as PJ
        //#127 VJ
        CitiStagingTable.Amount:=PaymentJournal.Amount;
        CitiStagingTable.Currency:=PaymentJournal."Currency Code";
        CitiStagingTable."Instruction to Bank":=PaymentJournal."Instruction to Bank"; //VJ 02DEC2024
        CitiStagingTable."FPS Type":=PaymentJournal."FPS Type"; //VJ 02DEC2024
        CitiStagingTable."FPS No.":=PaymentJournal."FPS No."; //VJ 02DEC2024
        CitiStagingTable."Creditor Email Address 1":=PaymentJournal."Remittance Email 1";
        CitiStagingTable."Creditor Email Address 2":=PaymentJournal."Remittance Email 2";
        CitiStagingTable."Creditor Email Address 3":=PaymentJournal."Remittance Email 3";
        CitiStagingTable."Creditor Email Address 4":=PaymentJournal."Remittance Email 4";
        CitiStagingTable."Creditor Email Address 5":=PaymentJournal."Remittance Email 5";
        CitiStagingTable."Creditor Email Address 6":=PaymentJournal."Remittance Email 6";
        CitiStagingTable."Applied Entries to XML":=PaymentJournal."Applied Entries to XML";
        //#138 VJ
        if PaymentJournal."Charges Bearer" = PaymentJournal."Charges Bearer"::SHA then CitiStagingTable."Charges Bearer":=CitiStagingTable."Charges Bearer"::SHAR;
        if PaymentJournal."Charges Bearer" = PaymentJournal."Charges Bearer"::OUR then CitiStagingTable."Charges Bearer":=CitiStagingTable."Charges Bearer"::DEBT;
        if PaymentJournal."Charges Bearer" = PaymentJournal."Charges Bearer"::BEN then CitiStagingTable."Charges Bearer":=CitiStagingTable."Charges Bearer"::CRED;
        //#138 VJ
        AssginComInfoInCITI(CitiStagingTable);
        if BankAccount.Get(PaymentJournal."Bal. Account No.")then AssignBankAccountFieldsInCITI(CitiStagingTable, BankAccount);
        if CitiStagingTable.Currency = '' then CitiStagingTable.Currency:='USD';
        if PaymentJournal."Account Type" = PaymentJournal."Account Type"::Vendor then begin
            if BankVendorAccount.GET(PaymentJournal."Account No.", PaymentJournal."Recipient Bank Account")then AssginVendorBankAccInCITI(CitiStagingTable, BankVendorAccount, PaymentJournal);
        end
        else if PaymentJournal."Account Type" = PaymentJournal."Account Type"::"Bank Account" then begin //TEC.VJ 20112024
                if BankAccount.GET(PaymentJournal."Account No.")then //
 AssginBankAccInCITICredtr(CitiStagingTable, BankAccount, PaymentJournal);
            end
            else if PaymentJournal."Account Type" = PaymentJournal."Account Type"::Employee then begin //TEC.VJ 28112024
                    if EmpBankAccount.GET(PaymentJournal."Account No.", PaymentJournal."Employee Bank Account")then CopyEmployeeBankAccFieldsInCiti(CitiStagingTable, EmpBankAccount, PaymentJournal);
                end
                else //#242 TEC.VJ>>
 if PaymentJournal."Account Type" = PaymentJournal."Account Type"::Customer then if CustBankAccount.GET(PaymentJournal."Account No.", PaymentJournal."Recipient Bank Account")then AssginCustomerBankAccInCITI(CitiStagingTable, CustBankAccount, PaymentJournal);
        //#242 TEC.VJ<<
        //10042024
        CitiStagingTable."Country/Region Code":=BankAccount."Country/Region Code";
        CitiStagingTable.Modify();
        //>>VJ06DEC2024
        if PaymentSetCode.Get(PaymentJournal."Payment Set Code")then begin
            PaymentSetCode."Last Used Date":=Today;
            PaymentSetCode.Modify();
        end;
    //<<VJ06DEC2024
    end;
    //Assiged company info in citi staging
    procedure AssginComInfoInCITI(var CITIStagingTable: Record "Citi Outbound Staging Table")
    VAR
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.get();
        CITIStagingTable."Debtor Name":=CompanyInfo.Name;
        CITIStagingTable."Debtor Address":=CompanyInfo.Address;
        CITIStagingTable."Debtor Address 2":=CompanyInfo."Address 2";
        CITIStagingTable."Debtor Country":=CompanyInfo."Country/Region Code";
        CITIStagingTable."Debtor Post Code":=CompanyInfo."Post Code";
    end;
    //Copy fields from Bank Account into Citi Staging Table Debitors Fields
    procedure AssignBankAccountFieldsInCITI(var CITIStagingTable: Record "Citi Outbound Staging Table"; BankAccount: Record "Bank Account")
    begin
        CITIStagingTable."Debtor Bank Account":=BankAccount."Bank Account No.";
        if CITIStagingTable.Currency = '' then CITIStagingTable.Currency:=BankAccount."Currency Code";
        if CITIStagingTable.Currency = '' then CITIStagingTable.Currency:='USD';
        CITIStagingTable."Debtor Bank Clearing Code":=BankAccount."Bank Clearing Code";
        CITIStagingTable."Creditor ABA/BSB No.":=BankAccount."Bank Clearing Code"; //DC 03Apr2025
        //CITIStagingTable."Debtor SWIFT Code" := GetSwiftName(BankAccount."SWIFT Code");
        CITIStagingTable."Debtor SWIFT Code":=BankAccount."SWIFT Code"; //VJ09DEC2024
        CITIStagingTable."Debtor Bank Acc Name":=BankAccount.Name;
        CITIStagingTable."Debtor Bank Address":=BankAccount.Address;
        CITIStagingTable."Debtor Bank Address 2":=BankAccount."Address 2";
        CITIStagingTable."Debtor Bank Country":=BankAccount."Country/Region Code";
        CITIStagingTable."Debtor Bank Post Code":=BankAccount."Post Code";
        CITIStagingTable."Country/Region Code":=BankAccount."Country/Region Code";
        CITIStagingTable."Debtor ACH ID":=BankAccount."No.";
        CITIStagingTable."Debtor Currency Code":=BankAccount."Currency Code Custom"; //TEC.VJ 25112024
        CITIStagingTable."Debtor ABA Routing Code":=BankAccount."ABA Routing Code"; //TEC.VJ 27112024
        CitiStagingTable."Bank Integration Type":=BankAccount."Bank Integration Type";
        // CITIStagingTable."Debtor Name" := BankAccount."Bank Beneficiary Name";
        //#110>>
        CITIStagingTable."Debtor Name":=BankAccount."Account Holder Name";
        CITIStagingTable."Debtor Address":=BankAccount.Address;
        CITIStagingTable."Debtor Address 2":=BankAccount."Address 2";
    //#110<<
    end;
    //Copy fields from Vendor Bank Account into Citi Staging Table Creditor Fields
    procedure AssginVendorBankAccInCITI(var CITIStagingTable: Record "Citi Outbound Staging Table"; BankVendorAccount: Record "Vendor Bank Account"; var PaymentJournal: Record "Gen. Journal Line")
    var
        // CountryRegion: Record "Country/Region";
        Addrss: array[5]of text[35];
    begin
        // CountryRegion.Get(BankVendorAccount."Country/Region Code");//#272 TEC.VJ Commented
        // CITIStagingTable."Purpose Code" := CountryRegion."Purpose Code (Citi)  Prefix" + CITIStagingTable."Purpose Code";//#272 TEC.VJ Commented
        //#104 TEC.VJ>>
        // CITIStagingTable."Creditor Bank Account" := BankVendorAccount."Bank Account No.";
        if BankVendorAccount.IBAN <> '' then CITIStagingTable."Creditor IBAN Account":=BankVendorAccount.IBAN
        else
            // CITIStagingTable."Creditor IBAN Account" := BankVendorAccount."Bank Account No.";//#104 //TEC.VJ 16012025
            CITIStagingTable."Creditor Bank Account":=BankVendorAccount."Bank Account No."; //#104  //TEC.VJ 16012025
        //#104 TEC.VJ<<
        CITIStagingTable."Creditor Bank Acc Name":=BankVendorAccount."Beneficiary Name";
        //#215 TEC.VJ 12022025>>
        Addrss[1]:=BankVendorAccount."Beneficiary Name 2";
        Addrss[2]:=BankVendorAccount."Beneficiary Name 3";
        //Addrss[2] := BankVendorAccount.Address;
        Addrss[3]:=BankVendorAccount.Address;
        Addrss[4]:=BankVendorAccount."Address 2";
        Addrss[5]:=BankVendorAccount."Address 3";
        CompressArray(Addrss);
        CITIStagingTable."Creditor Address":=Addrss[1];
        CITIStagingTable."Creditor Address 2":=Addrss[2];
        CITIStagingTable."Creditor Address 3":=Addrss[3];
        //#215 TEC.VJ 12022025<<
        CITIStagingTable."Creditor Country":=BankVendorAccount."Country/Region Code";
        CITIStagingTable."Creditor Post Code":=BankVendorAccount."Post Code";
        IF BankVendorAccount."SWIFT Code" <> '' THEN //CITIStagingTable."Creditor Swift Code" := GetSwiftName(BankVendorAccount."SWIFT Code");
            CITIStagingTable."Creditor Swift Code":=BankVendorAccount."SWIFT Code"; //VJ09DEC2024
        CITIStagingTable."Creditor Bank Branch Code":=BankVendorAccount."Bank Branch No.";
        CITIStagingTable."Creditor Branch Code":=BankVendorAccount."Bank Branch No.";
        CITIStagingTable."Creditor Country":=BankVendorAccount."Country/Region Code";
        //CITIStagingTable."Creditor Currency Code" := BankVendorAccount."Currency Code";//TEC.VJ 25112024//VJ 15Jan2025 commented #159
        //if batch type is not CITI949 - it does not need to take. this field is not applied for others. 17Jan2025 #159
        if PaymentJournal."Batch Type" = PaymentJournal."Batch Type"::CITI949 then //VJ 15Jan2025 #159
 CITIStagingTable."Creditor Currency Code":=PaymentJournal."Trans. Currency"; //VJ 15Jan2025 #159
        CITIStagingTable."Creditor ABA/BSB No.":=BankVendorAccount."ABA/BSB No."; //TEC.VJ 25112024
        //#232 TEC.VJ>>
        // if not PaymentJournal."No Corresponding Bank for Pmt" then begin
        //     CITIStagingTable."Creditor Inter. Bank Acc. No" := BankVendorAccount."Correspondent Bank Account No.";//TEC.VJ 25112024
        //     CITIStagingTable."Creditor Inter. Bank Country" := BankVendorAccount."Corresp. Country/Region Code";//TEC.VJ 25112024
        //     CITIStagingTable."Creditor Inter. Bank SWIFT" := BankVendorAccount."Correspondent Swift Code";//TEC.VJ 25112024
        // end;
        CITIStagingTable."Creditor Inter. Bank Acc. No":=PaymentJournal."Intermediary Bank Account No";
        CITIStagingTable."Creditor Inter. Bank Country":=PaymentJournal."Intermediary Bank Country";
        CITIStagingTable."Creditor Inter. Bank SWIFT":=PaymentJournal."Intermediary Bank SWIFT / BIC";
    //#232 TEC.VJ<<
    // BankVendorAccount."Correspondent Bank Account No."
    end;
    //Copy fields from Bank Account into Citi Staging Table Creditor Fields
    //#242 TEC.VJ>>
    //Copy fields from Customer Bank Account into Citi Staging Table Creditor Fields
    procedure AssginCustomerBankAccInCITI(var CITIStagingTable: Record "Citi Outbound Staging Table"; CustomerBankAcc: Record "Customer Bank Account"; var PaymentJournal: Record "Gen. Journal Line")
    var
        CountryRegion: Record "Country/Region";
        Addrss: array[5]of text[35];
    begin
        // CountryRegion.Get(CustomerBankAcc."Country/Region Code");//#272 TEC.VJ Commented
        // CITIStagingTable."Purpose Code" := CountryRegion."Purpose Code (Citi)  Prefix" + CITIStagingTable."Purpose Code";//#272 TEC.VJ Commented
        if CustomerBankAcc.IBAN <> '' then CITIStagingTable."Creditor IBAN Account":=CustomerBankAcc.IBAN
        else
            CITIStagingTable."Creditor Bank Account":=CustomerBankAcc."Bank Account No."; //#104  //TEC.VJ 16012025
        CITIStagingTable."Creditor Bank Acc Name":=CustomerBankAcc."Beneficiary Name";
        Addrss[1]:=CustomerBankAcc."Beneficiary Name 2";
        Addrss[2]:=CustomerBankAcc."Beneficiary Name 3";
        Addrss[3]:=CustomerBankAcc.Address;
        Addrss[4]:=CustomerBankAcc."Address 2";
        Addrss[5]:=CustomerBankAcc."Address 3";
        CompressArray(Addrss);
        CITIStagingTable."Creditor Address":=Addrss[1];
        CITIStagingTable."Creditor Address 2":=Addrss[2];
        CITIStagingTable."Creditor Address 3":=Addrss[3];
        CITIStagingTable."Creditor Country":=CustomerBankAcc."Country/Region Code";
        CITIStagingTable."Creditor Post Code":=CustomerBankAcc."Post Code";
        IF CustomerBankAcc."SWIFT Code" <> '' THEN CITIStagingTable."Creditor Swift Code":=CustomerBankAcc."SWIFT Code";
        CITIStagingTable."Creditor Bank Branch Code":=CustomerBankAcc."Bank Branch No.";
        CITIStagingTable."Creditor Branch Code":=CustomerBankAcc."Bank Branch No.";
        CITIStagingTable."Creditor Country":=CustomerBankAcc."Country/Region Code";
        if PaymentJournal."Batch Type" = PaymentJournal."Batch Type"::CITI949 then CITIStagingTable."Creditor Currency Code":=PaymentJournal."Trans. Currency";
        CITIStagingTable."Creditor ABA/BSB No.":=CustomerBankAcc."ABA/BSB No.";
        CITIStagingTable."Creditor Inter. Bank Acc. No":=PaymentJournal."Intermediary Bank Account No";
        CITIStagingTable."Creditor Inter. Bank Country":=PaymentJournal."Intermediary Bank Country";
        CITIStagingTable."Creditor Inter. Bank SWIFT":=PaymentJournal."Intermediary Bank SWIFT / BIC";
    end;
    //#242 TEC.VJ<<
    //Copy fields from Bank Account into Citi Staging Table Creditor Fields
    procedure AssginBankAccInCITICredtr(var CITIStagingTable: Record "Citi Outbound Staging Table"; BankAccount: Record "Bank Account"; var PaymentJournal: Record "Gen. Journal Line")
    var
    begin
        //#104 TEC.VJ>> //#153 TEC.VJ Commented
        // if BankAccount.IBAN <> '' then
        //     CITIStagingTable."Creditor IBAN Account" := BankAccount.IBAN
        // else
        //     CITIStagingTable."Creditor IBAN Account" := BankAccount."Bank Account No.";//#104 TEC.VJ
        //#104 TEC.VJ<<
        CITIStagingTable."Creditor Bank Account":=BankAccount."Bank Account No."; //#153 TEC.VJ
        CITIStagingTable."Creditor Bank Acc Name":=BankAccount."Bank Beneficiary Name"; //#153 TEC.VJ
        CITIStagingTable."Creditor Address":=BankAccount.Address;
        CITIStagingTable."Creditor Address 2":=BankAccount."Address 2";
        CITIStagingTable."Creditor Country":=BankAccount."Country/Region Code";
        CITIStagingTable."Creditor Post Code":=BankAccount."Post Code";
        IF BankAccount."SWIFT Code" <> '' THEN //CITIStagingTable."Creditor Swift Code" := GetSwiftName(BankAccount."SWIFT Code");
            CITIStagingTable."Creditor Swift Code":=BankAccount."SWIFT Code"; //VJ09DEC2024
        CITIStagingTable."Creditor Bank Branch Code":=BankAccount."Bank Branch No.";
        CITIStagingTable."Creditor Branch Code":=BankAccount."Bank Branch No.";
        CITIStagingTable."Creditor Bank Clearing Code":=BankAccount."Bank Clearing Code";
        CITIStagingTable."Creditor ABA/BSB No.":=BankAccount."Bank Clearing Code"; //DC 03Apr2025
        CITIStagingTable."Creditor Country":=BankAccount."Country/Region Code";
        //if batch type is not CITI949 - it does not need to take. this field is not applied for others. 17Jan2025 #159
        //CITIStagingTable."Creditor Currency Code" := BankAccount."Currency Code Custom";//TEC.VJ 25112024
        // CitiStagingTable."Creditor Post Code" := EmpBankAccount."Post Code";
        //if batch type is not CITI949 - it does not need to take. this field is not applied for others. 17Jan2025 #159
        if PaymentJournal."Batch Type" = PaymentJournal."Batch Type"::CITI949 then //VJ 15Jan2025 #159
 CITIStagingTable."Creditor Currency Code":=PaymentJournal."Trans. Currency"; //VJ 15Jan2025 #159
    end;
    procedure GetSwiftName(SWIFTCode: Code[20]): Text[100]var
        SwiftCodeRec: Record "SWIFT Code";
    begin
        if SwiftCodeRec.Get(SwiftCode)then exit(SwiftCodeRec.Name);
    end;
    //Copy fields from IC Gen Jnl into Citi Staging Table
    procedure CopyICToCitiStaging(var ICGenJnl: record "Gen. Journal Line"; CitiConnectCustomerID: Text[35]; var CitiStagingTable: Record "Citi Outbound Staging Table")
    var
        BankAccount: Record "Bank Account";
        CitiOutbound: Codeunit CitiOutboundCodeunit;
        PaymentMethod: Record "Payment Method";
        ICPartner: Record "IC Partner";
        ICGenJnl2: Record "Gen. Journal Line";
        Bnk: Record "Bank Account Ledger Entry";
        BankAccNo: code[20];
    begin
        CitiStagingTable.Identification:=CitiConnectCustomerID;
        CitiStagingTable."Create Date":=DT2Date(ICGenJnl.SystemCreatedAt);
        CitiStagingTable."Create Date Time":=CurrentDateTime; //#155 TEC.VJ
        CitiStagingTable."Service Level":=ICGenJnl."Lavel Service Code"; //#77 TEC.VJ
        CitiStagingTable."Debtor To Receipt":=ICGenJnl."Message to Recipient"; //#77 TEC.VJ
        CitiStagingTable.Amount:=ABS(ICGenJnl.Amount); //#77 TEC.VJ
        CitiStagingTable."Line No.":=ICGenJnl."Line No.";
        CitiStagingTable."Payment Reference No.":=ICGenJnl."Payment Reference";
        CitiStagingTable."Posting Date":=ICGenJnl."Posting Date";
        //CitiStagingTable."Charge Bearer" := AssignChargeBearer(ICGenJnl."Charges Bearer");//VJ 28112024
        //CitiStagingTable."Charges Bearer" := ICGenJnl."Charges Bearer";//VJ 28112024
        //#138 VJ
        if ICGenJnl."Charges Bearer" = ICGenJnl."Charges Bearer"::SHA then CitiStagingTable."Charges Bearer":=CitiStagingTable."Charges Bearer"::SHAR;
        if ICGenJnl."Charges Bearer" = ICGenJnl."Charges Bearer"::OUR then CitiStagingTable."Charges Bearer":=CitiStagingTable."Charges Bearer"::DEBT;
        if ICGenJnl."Charges Bearer" = ICGenJnl."Charges Bearer"::BEN then CitiStagingTable."Charges Bearer":=CitiStagingTable."Charges Bearer"::CRED;
        //#138 VJ
        CitiStagingTable."Batch Id":=ICGenJnl."Bank Document No."; //VJ 15NOV2024 31DEC2024
        CitiStagingTable."Journal Template Name":=ICGenJnl."Journal Template Name";
        CitiStagingTable."Journal Batch Name":=ICGenJnl."Journal Batch Name";
        CitiStagingTable."Account Type":=ICGenJnl."Account Type";
        CitiStagingTable."Account No.":=ICGenJnl."Account No.";
        CitiStagingTable."Bal. Account Type":=ICGenJnl."Bal. Account Type";
        CitiStagingTable."Bal. Account No.":=ICGenJnl."Bal. Account No.";
        // if ICGenJnl."Payment Method Code" <> '' then
        //     if PaymentMethod.Get(ICGenJnl."Payment Method Code") then
        //         CitiStagingTable."Payment Method" := PaymentMethod."Payment Method Bank XML";
        CitiStagingTable."Payment Method":=ICGenJnl."Payment Method Code";
        CitiStagingTable."Payment Method Bank XML":=ICGenJnl."Payment Method Bank XML";
        CitiStagingTable.Currency:=ICGenJnl."Currency Code";
        CitiStagingTable."Batch Type":=ICGenJnl."Batch Type";
        CitiStagingTable."Bal. Account No.":=ICGenJnl."Bal. Account No.";
        AssginComInfoInCITI(CitiStagingTable);
        if BankAccount.Get(ICGenJnl."Account No.")then begin
            AssignBankAccountFieldsInCITI(CitiStagingTable, BankAccount);
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
                // if ICGenJnl2."PB Txf Bank Account" <> '' then //#293 TEC.VJ 02APR2025
                //     BankAccNo := ICGenJnl2."PB Txf Bank Account"
                // else
                BankAccNo:=ICGenJnl2."PB IC Account";
                //#276 TEC.VJ 18MAR2025<<
                if BankAccount.GET(BankAccNo)then AssginBankAccForIC(CitiStagingTable, BankAccount);
            end;
        end;
        //#77 TEC.VJ<<
        CitiStagingTable.Modify();
    end;
    //Copy fields from Bank account into Citi Staging Table in IC Transactions
    procedure AssginBankAccForIC(var CitiStagingTable: Record "Citi Outbound Staging Table"; BankAccount: Record "Bank Account")
    begin
        //#104 TEC.VJ>> //#155 TEC.VJ Commented
        // if BankAccount.IBAN <> '' then  
        // CITIStagingTable."Creditor Bank Account" := BankAccount."Bank Account No.";
        //     CITIStagingTable."Creditor IBAN Account" := BankAccount.IBAN
        // else
        //     CITIStagingTable."Creditor IBAN Account" := BankAccount."Bank Account No.";
        //#104 TEC.VJ<<
        CITIStagingTable."Creditor Bank Account":=BankAccount."Bank Account No."; //#316 TEC.VJ 23APR2025
        CitiStagingTable."Creditor Bank Acc Name":=BankAccount."Bank Beneficiary Name"; //#155 TEC.VJ
        CitiStagingTable."Creditor Address":=BankAccount.Address;
        CitiStagingTable."Creditor Address 2":=BankAccount."Address 2";
        CitiStagingTable."Creditor Country":=BankAccount."Country/Region Code";
        CitiStagingTable."Creditor Post Code":=BankAccount."Post Code";
        //CitiStagingTable."Creditor Swift Code" := GetSwiftName(BankAccount."SWIFT Code");
        CitiStagingTable."Creditor Swift Code":=BankAccount."SWIFT Code"; //VJ09DEC2024
        CitiStagingTable."Creditor Bank Branch Code":=BankAccount."Bank Branch No.";
        CitiStagingTable."Creditor Bank Clearing Code":=BankAccount."Bank Clearing Code";
        CITIStagingTable."Creditor ABA/BSB No.":=BankAccount."Bank Clearing Code"; //DC 03Apr2025
        CitiStagingTable."Creditor Country":=BankAccount."Country/Region Code";
        CitiStagingTable."Creditor IBAN Account":=BankAccount.IBAN; //TEC.VJ 10APR2025
        CitiStagingTable."Creditor ABA/BSB No.":=BankAccount."ABA Routing Code"; //TEC.VJ 10APR2025
    end;
    //copy fields from Employee bank account into Citi Staging Table
    procedure CopyEmployeeBankAccFieldsInCiti(var CitiStagingTable: Record "Citi Outbound Staging Table"; EmpBankAccount: Record "Employee Bank Account"; PaymentJournal: Record "Gen. Journal Line")
    var
        Addrss: array[5]of text[35];
    begin
        CitiStagingTable."Creditor Bank Account":=EmpBankAccount."Bank Account No.";
        CitiStagingTable."Creditor Bank Acc Name":=EmpBankAccount."Beneficiary Name";
        CitiStagingTable."Creditor IFSC Code":=EmpBankAccount."IFSC Code";
        //#216 TEC.VJ 12022025>>
        Addrss[1]:=EmpBankAccount."Beneficiary Name 2";
        Addrss[2]:=EmpBankAccount."Beneficiary Name 3"; //VJ 25FEB2025
        //Addrss[2] := EmpBankAccount.Address;
        Addrss[3]:=EmpBankAccount.Address;
        Addrss[4]:=EmpBankAccount."Address 2";
        Addrss[5]:=EmpBankAccount."Address 3";
        CompressArray(Addrss);
        CitiStagingTable."Creditor Address":=Addrss[1];
        CitiStagingTable."Creditor Address 2":=Addrss[2];
        CitiStagingTable."Creditor Address 3":=Addrss[3];
        //#216 TEC.VJ 12022025<<
        CitiStagingTable."Creditor IBAN Account":=EmpBankAccount.IBAN; //VJ 11042025 #369
        CitiStagingTable."Creditor Country":=EmpBankAccount."Country/Region Code";
        //CitiStagingTable."Creditor ABA/BSB No." := EmpBankAccount."ABA/BSB No."; // WW28JAN2025
        CitiStagingTable."Creditor ABA/BSB No.":=EmpBankAccount."ABA/BSB No."; //VJ 01Apr2025
        //VJ 28012025 Start
        /*
        if (EmpBankAccount."ABA/BSB No." <> '') and (EmpBankAccount."Swift Code" <> '') then
            CitiStagingTable."Creditor ABA/BSB No." := EmpBankAccount."ABA/BSB No.";
        if (EmpBankAccount."ABA/BSB No." = '') and (EmpBankAccount."Swift Code" <> '') then
            CitiStagingTable."Creditor ABA/BSB No." := EmpBankAccount."Swift Code";
        if (EmpBankAccount."ABA/BSB No." <> '') and (EmpBankAccount."Swift Code" = '') then
            CitiStagingTable."Creditor ABA/BSB No." := EmpBankAccount."ABA/BSB No.";
            */
        //commented on 03Feb2025 
        //VJ 28012025 End
        //CitiStagingTable."Creditor Swift Code" := GetSwiftName(EmpBankAccount."SWIFT Code");
        if(PaymentJournal."Batch Type" <> PaymentJournal."Batch Type"::CITI949) and (EmpBankAccount."Country/Region Code" <> 'ÍN')then //VJ 13Jan2025 add condition as walter request
 CitiStagingTable."Creditor Swift Code":=EmpBankAccount."SWIFT Code"; //VJ09DEC2024
        // CitiStagingTable."Creditor Post Code" := EmpBankAccount."Post Code";
        //if batch type is not CITI949 - it does not need to take. this field is not applied for others. 17Jan2025 #159
        if PaymentJournal."Batch Type" = PaymentJournal."Batch Type"::CITI949 then //VJ 15Jan2025 #159
 CITIStagingTable."Creditor Currency Code":=PaymentJournal."Trans. Currency"; //VJ 15Jan2025 #159
        //#232 TEC.VJ>>
        CITIStagingTable."Creditor Inter. Bank Acc. No":=PaymentJournal."Intermediary Bank Account No";
        CITIStagingTable."Creditor Inter. Bank Country":=PaymentJournal."Intermediary Bank Country";
        CITIStagingTable."Creditor Inter. Bank SWIFT":=PaymentJournal."Intermediary Bank SWIFT / BIC";
    //#232 TEC.VJ<<
    end;
    local procedure AssignChargeBearer(ChargesBearer: Option): text[4];
    begin
        if ChargesBearer = 0 then exit('DEBT')
        else if ChargesBearer = 1 then exit('CRED')
            else if ChargesBearer = 2 then exit('SHAR');
    end;
}
