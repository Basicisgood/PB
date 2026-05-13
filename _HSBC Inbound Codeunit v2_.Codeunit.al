codeunit 50206 "HSBC Inbound Codeunit v2"
{
    trigger OnRun()
    begin
        ProcessAllInboundLines(5);
    end;
    procedure ProcessAllInboundLines(Scenario: Integer)
    var
        HSBCInbound: Record "HSBC Inbound Staging";
        HSBCInbound2: Record "HSBC Inbound Staging";
    begin
        HSBCInbound.Reset();
        UpdateDuplicateStatus();
        ValidateEntryTransCode();
        HSBCInbound.SetRange(Processed, false);
        HSBCInbound.SetRange(Status, HSBCInbound.Status::Pending); //VJ 17JAN2025
        IF HSBCInbound.FindSet()then repeat IsError:=false;
                FoundMAtch:=false;
                //2start
                if(Scenario = 2) or (Scenario = 5) and (not FoundMAtch)then begin
                    HSBCInbound2.Reset();
                    HSBCInbound2.SetRange("Entry No.", HSBCInbound."Entry No.");
                    HSBCInbound2.SetFilter(EntryTransCode, '<>%1', 'NTRF');
                    HSBCInbound2.SetRange(EntryStatus, 'BOOK');
                    IF HSBCInbound2.Findfirst()then CreateCash_GenJnl(HSBCInbound2);
                end;
                //2end
                //3start
                if(Scenario = 3) or (Scenario = 5) and (not FoundMAtch)then begin
                    HSBCInbound2.Reset();
                    HSBCInbound2.SetRange("Entry No.", HSBCInbound."Entry No.");
                    HSBCInbound2.SetRange(EntryCrDrInd, 'CRDT');
                    // HSBCInbound2.SetFilter("Additional Entry Information", '=%1|%2|%3', '*' + 'Ret' + '*', '*' + 'Rtn' + '*', '*' + 'RETN' + '*');//#135 TEC.VJ //#275 TEC.VJ
                    HSBCInbound2.SetFilter(EntryRevInd, '@' + 'true'); //#275 TEC.VJ
                    HSBCInbound2.SetRange(EntryStatus, 'BOOK');
                    HSBCInbound2.Setfilter(Status, '<>%1&<>%2', HSBCInbound2.Status::Success, HSBCInbound2.Status::Created);
                    IF HSBCInbound2.Findfirst()then CreateReturnPaymentJnl(HSBCInbound2);
                end;
                //3end
                //1start
                if(Scenario = 1) or (Scenario = 5) and (not FoundMAtch)then begin
                    HSBCInbound2.Reset();
                    HSBCInbound2.SetRange("Entry No.", HSBCInbound."Entry No.");
                    HSBCInbound2.SetRange(EntryStatus, 'BOOK');
                    HSBCInbound2.Setfilter(Status, '<>%1&<>%2', HSBCInbound2.Status::Success, HSBCInbound2.Status::Created);
                    IF HSBCInbound2.Findfirst()then UpdatePaymentJnl1(HSBCInbound2);
                end;
                //1end
                //4Start
                if(Scenario = 4) or (Scenario = 5) and (not FoundMAtch)then begin
                    HSBCInbound2.Reset();
                    HSBCInbound2.SetRange("Entry No.", HSBCInbound."Entry No.");
                    HSBCInbound2.SetRange(EntryStatus, 'BOOK');
                    HSBCInbound2.Setfilter(Status, '<>%1&<>%2&<>%3', HSBCInbound2.Status::Success, HSBCInbound2.Status::Posted, HSBCInbound2.Status::Created); //VJ 11Sept2025 added created condition because cash receipt entries matching this scenraio after creating cash receipt
                    IF HSBCInbound2.Findfirst()then if CreatePaymentJnl(HSBCInbound2)then;
                end;
            //4end
            until HSBCInbound.Next() = 0;
    end;
    procedure UpdatePaymentJnl1(HSBCInbound: Record "HSBC Inbound Staging") //scenario1
    var
        HSBCInbound2: Record "HSBC Inbound Staging";
        GenJnlBatch: Record "Gen. Journal Batch";
        HSBCOutboundStag: Record "HSBC Outbound Staging Table";
        PostHSBCInboundPaymentJnl: Codeunit "Post HSBC Inbound Payment Jnl";
    begin
        if TempGenJnlBatch.IsTemporary then TempGenJnlBatch.DeleteAll();
        BankApiSetup.Get();
        BankApiSetup.TestField("Payment Jnl. Template Name");
        BankApiSetup.TestField("Payment Jnl. Batch Name");
        Commit();
        HSBCInbound2.Get(HSBCInbound."Entry No.");
        if PostHSBCInboundPaymentJnl.Run(HSBCInbound)then begin
            HSBCInbound2."Error Message":='';
            HSBCInbound2.Processed:=true;
            HSBCInbound2.Status:=HSBCInbound2.Status::Posted;
            FoundMAtch:=true;
            //##DC if it is low value, need to use batch ID to get all, high value ok
            //NT_ 22-04-2026 >>
            HSBCOutboundStag.Reset();
            HSBCOutboundStag.SetRange("Batch Id", HSBCInbound.TxEndtoEndId);
            if HSBCOutboundStag.FindSet()then begin
                HSBCOutboundStag.Modifyall(Status, HSBCOutboundStag.Status::Booked); //TEC.VJ 07012025
                TempBatchInsert(HSBCOutboundStag); //28012025
            end;
            //NT_ 22-04-2026 <<
            HSBCOutboundStag.Reset();
            HSBCOutboundStag.SetRange("Bank Document No.", HSBCInbound.TxEndtoEndId);
            if HSBCOutboundStag.FindSet()then begin
                HSBCOutboundStag.Modifyall(Status, HSBCOutboundStag.Status::Booked); //TEC.VJ 07012025
                TempBatchInsert(HSBCOutboundStag); //28012025
            end;
        end
        else
        begin
            FoundMAtch:=PostHSBCInboundPaymentJnl.GetFoundMatch();
            //28012025>>
            HSBCOutboundStag.Reset();
            HSBCOutboundStag.SetRange("Bank Document No.", HSBCInbound.TxEndtoEndId);
            if HSBCOutboundStag.FindSet()then begin
                TempBatchInsert(HSBCOutboundStag);
            end;
            //28012025<<
            HSBCInbound2."Error Message":=GetLastErrorText();
            HSBCInbound2.Status:=HSBCInbound.Status::Error; //VJ17JAN2025 //#324 TEC.VJ// #335 TEC.VJ 
        // HSBCInbound2.Status := HSBCInbound.Status::Created;//#324 GenJnl Lines Creating Duplicate// #335 TEC.VJ 
        end;
        //HSBCInbound2.Modify();
        HSBCInbound2."Executed Scenario":='Post Payment Scenario1'; //TEC.VJ 17062025
        if HSBCInbound2.Modify()then; //handling of double modify which is also modifying on posting to update status field in inbound//15Apr2025
        UpdateGenJnlBatchFields();
    end;
    //TEC.VJ 17DEC2024>>
    procedure UpdateGenJnlBatchFields()
    var
        CommonFunc: Codeunit "Common Functions";
    begin
        TempGenJnlBatch.Reset();
        if TempGenJnlBatch.FindSet()then repeat CommonFunc.UpdateGenjnlBatchFieldsForHSBC_Citi(TempGenJnlBatch."Journal Template Name", TempGenJnlBatch.Name);
            until TempGenJnlBatch.Next() = 0;
    end;
    //TEC.VJ 17DEC2024<<
    procedure CreateCash_GenJnl(HSBCInbound: Record "HSBC Inbound Staging") //scenario2
    //creating cash receipt journal and general journal
    var
        PaymentJnl: Record "Gen. Journal Line";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlBostBatch: Codeunit "Gen. Jnl.-Post Batch";
        LineNo: Integer;
        BankCodeMapping: Record "Inbound Transfer Mapping";
        TemplateName: Code[20];
        BatchName: Code[20];
        SourceCode: Code[20];
        BankAcc: Record "Bank Account";
        AutoPost: Boolean;
        NewBatchName: Code[20];
        GLSetup: Record "General Ledger Setup";
        IsFundTransfer: Boolean;
    begin
        BankAPISetup.Get();
        GLSetup.Get();
        IsFundTransfer:=(StrPos(HSBCInbound."Additional Entry Information", 'PBFUNDTRANSFER') <> 0); //VJ 25062025 Moved the code to above
        LineNo:=0;
        IsError:=false;
        AutoPost:=false;
        BankCodeMapping.Reset();
        BankCodeMapping.SetRange(Code, HSBCInbound.EntryTransCode);
        BankCodeMapping.SetRange("DBIT / CRDT", HSBCInbound.EntryCrDrInd);
        //VJ 25062025 added code to find the correct bank code mapping because there might be two mapping for same EntryTransCode and it should find the correct one not always first
        if IsFundTransfer then BankCodeMapping.SetRange(PBFundTransfer, true)
        else
            BankCodeMapping.SetRange(PBFundTransfer, false);
        //VJ 25062025 added code to find the correct bank code mapping because there might be two mapping for same EntryTransCode and it should find the correct one not always first
        if not BankCodeMapping.FindFirst()then begin
            IsError:=true;
            HSBCInbound."Error Message":='Bank Code mapping not found. Bank Code :' + HSBCInbound.EntryTransCode;
        end;
        IF BankCodeMapping."Account Type" = BankCodeMapping."Account Type"::Customer THEN begin
            //#296 TEC.VJ 03MAR2025>>
            // if HSBCInbound."Additional Entry Information" = 'PBFUNDTRANSFER' then begin
            //#347 TEC.VJ>>
            //            IsFundTransfer := (StrPos(HSBCInbound."Additional Entry Information", 'PBFUNDTRANSFER') <> 0); //VJ 25062025 Moved the code to above
            //#347 TEC.VJ<<
            IF IsFundTransfer then begin //#347 TEC.VJ
                BankAPISetup.TestField("Bank Transfer Template Name");
                BankAPISetup.TestField("Bank Transfer Batch Name");
                TemplateName:=BankAPISetup."Bank Transfer Template Name";
                BatchName:=BankAPISetup."Bank Transfer Batch Name";
                if GLSetup."Auto Post Bank Transfer" then //#312 TEC.VJ 22APR2025
 AutoPost:=true;
            end
            else
            begin
                //#296 TEC.VJ 03MAR2025<<
                BankAPISetup.TestField("CaschRcpt Template Name");
                BankAPISetup.TestField("CaschRcpt Batch Name");
                TemplateName:=BankAPISetup."CaschRcpt Template Name";
                BatchName:=BankAPISetup."CaschRcpt Batch Name";
                if GLSetup."Auto Post Cash Rcpt." then //#252 TEC.VJ
 AutoPost:=true; //#173 TEC.VJ 20012025
            end;
            SourceCode:='CASHRECJNL';
        end
        else if BankCodeMapping."Account Type" = BankCodeMapping."Account Type"::"G/L Account" then begin
                //#296 TEC.VJ 03MAR2025>> Added for GL 11Apr2025
                // if HSBCInbound."Additional Entry Information" = 'PBFUNDTRANSFER' then begin
                //#347 TEC.VJ>>
                // IF (StrPos(HSBCInbound."Additional Entry Information", 'PBFUNDTRANSFER') <> 0) then begin 
                IsFundTransfer:=(StrPos(HSBCInbound."Additional Entry Information", 'PBFUNDTRANSFER') <> 0);
                // Reverse logic for specific Bank Code
                // IF BankCodeMapping.Code = '108' THEN
                //     IsFundTransfer := NOT IsFundTransfer; reverted changeds 13062025
                //#347 TEC.VJ<<
                IF IsFundTransfer then begin //#347 TEC.VJ
                    BankAPISetup.TestField("Bank Transfer Template Name");
                    BankAPISetup.TestField("Bank Transfer Batch Name");
                    TemplateName:=BankAPISetup."Bank Transfer Template Name";
                    BatchName:=BankAPISetup."Bank Transfer Batch Name";
                    if GLSetup."Auto Post Bank Transfer" then //#312 TEC.VJ 22APR2025
 AutoPost:=true;
                end
                else
                begin
                    //#296 TEC.VJ 03MAR2025<<
                    BankAPISetup.TestField("General Jnl. Template Name");
                    BankAPISetup.TestField("General Jnl. Batch Name");
                    TemplateName:=BankAPISetup."General Jnl. Template Name";
                    BatchName:=BankAPISetup."General Jnl. Batch Name";
                    if GLSetup."Auto Post Cash Rcpt." then //#252 TEC.VJ
 AutoPost:=true; //#173 TEC.VJ 20012025
                end;
                SourceCode:='GENJNL';
            end;
        //#337 TEC.VJ 20MAY2025>> //To handle if template or batch exist or not.
        if not GenJnlBatch.Get(TemplateName, BatchName)then begin
            IsError:=true;
            HSBCInbound."Error Message":=' General Batch not found .Template Name :' + TemplateName + 'Batch Name :' + BatchName;
        end;
        //#337 TEC.VJ 20MAY2025<<
        BankAcc.Reset();
        BankAcc.SetRange("Bank Account No.", HSBCInbound."Bank Account");
        if not BankAcc.FindFirst()then begin
            IsError:=true;
            HSBCInbound."Error Message":=' Bank Account not found .Bank Account :' + HSBCInbound."Bank Account";
        end;
        //#190 29012025>>#226 TEC.VJ
        IF(BankAPISetup."Split Inbound Date Wise") and (TemplateName <> '') and (IsError = false)THEN begin
            CommFunc.InsertNewBatch(HSBCInbound.EntryBookedDate, TemplateName, BatchName, BankAcc."No.", NewBatchName);
        end
        ELSE
            NewBatchName:=BatchName;
        //#190 29012025<<
        PaymentJnl.Reset();
        PaymentJnl.SetRange("Journal Template Name", TemplateName); //#190 29012025
        PaymentJnl.SetRange("Journal Batch Name", NewBatchName); //#190 29012025
        PaymentJnl.SetRange("Source Code", SourceCode); //#190 29012025
        // PaymentJnl.SetFilter("Bank Document No.", '=%1', HSBCInbound.TxEndtoEndId);//TEC.VJ 25012025
        PaymentJnl.SetFilter("External Document No.", '=%1', HSBCInbound.TxEndtoEndId); //TEC.VJ #335  For Stop Duplicate Cash Rcpt lines creating
        //PaymentJnl.SetRange("Posting Date", HSBCInbound.EntryValueDate); //RC130325
        PaymentJnl.SetRange("Posting Date", HSBCInbound.EntryBookedDate); //RC 13032025
        PaymentJnl.SetRange("Inbound Entry No.", HSBCInbound."Entry No."); //TEC.VG#05NOV2025
        IF not PaymentJnl.FindFirst()then begin
            GenJnlLine.Reset();
            GenJnlLine.SetRange("Journal Template Name", TemplateName);
            GenJnlLine.SetRange("Journal Batch Name", NewBatchName);
            IF GenJnlLine.Findlast()then LineNo:=GenJnlLine."Line No.";
            if not GenJnlBatch.GET(TemplateName, NewBatchName)then begin
                IsError:=true;
                HSBCInbound."Error Message":=' General Batch not found .Template Name :' + TemplateName + 'Batch Name :' + NewBatchName;
            end;
            //TEC.VJ 17012025>>
            IF NOT NoSeries.Get(GenJnlBatch."No. Series")THEN BEGIN
                IsError:=true;
                HSBCInbound."Error Message":=' No Series not found . Code :' + GenJnlBatch."No. Series" + ' Template Name :' + TemplateName + ',Batch Name :' + NewBatchName;
            END;
            //TEC.VJ 17012025<<
            if not IsError then begin
                GenJnlLine.Init();
                GenJnlLine.Validate("Journal Template Name", TemplateName);
                GenJnlLine.Validate("Journal Batch Name", NewBatchName);
                GenJnlLine."Line No.":=LineNo + 10000;
                GenJnlLine.Insert();
                // GenJnlLine.Validate("Posting Date", HSBCInbound.EntryValueDate); RC 130325
                GenJnlLine.Validate("Posting Date", HSBCInbound.EntryBookedDate); //RC 130325
                if SourceCode = 'CASHRECJNL' then GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Invoice);
                //VJ 17Jan2025
                if HSBCInbound.EntryCrDrInd = 'CRDT' then //GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment);
                    GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::" "); //#279 VJ20032025
                //VJ 17Jan2025
                // DocumtNo := NoSMgmt.GetNextNo(NoSeries.Code, HSBCInbound.EntryValueDate, true);//TEC.VJ 17012025
                DocumtNo:=NoSMgmt.GetNextNo(NoSeries.Code, HSBCInbound.EntryBookedDate, true); //RC 130325
                GenJnlLine.Validate("Document No.", DocumtNo); //TEC.VJ 17012025
                GenJnlLine."External Document No.":=HSBCInbound.TxEndtoEndId;
                GenJnlLine.Validate("Source Code", SourceCode);
                if(BankCodeMapping."Account Type" = BankCodeMapping."Account Type"::"G/L Account") AND (BankCodeMapping.PBFundTransfer) AND (StrPos(HSBCInbound."Additional Entry Information", 'PBFUNDTRANSFER') <> 0)then begin //#352 TEC.VJ //#354 17June2025
                    GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.Validate("Account No.", BankAPISetup."API Bank Dummy Account")end
                else
                begin
                    GenJnlLine.Validate("Account Type", BankCodeMapping."Account Type");
                    GenJnlLine.Validate("Account No.", BankCodeMapping."Account No.");
                end;
                GenJnlLine.Description:=CopyStr(HSBCInbound."Additional Entry Information", 1, 100); //VJ#50 13dec24
                GenJnlLine."Bank Transaction Code":=BankCodeMapping.Code + ' ' + BankCodeMapping.Description; //VJ#50 13dec24
                GenJnlLine.Validate("Currency Code", HSBCInbound.EntryCurrency);
                //#296 TEC.VJ>>
                // if (SourceCode = 'CASHRECJNL') AND (HSBCInbound."Additional Entry Information" = 'PBFUNDTRANSFER') then begin
                if(SourceCode = 'CASHRECJNL') AND (StrPos(HSBCInbound."Additional Entry Information", 'PBFUNDTRANSFER') <> 0)then begin //#347 TEC.VJ
                    GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                    GenJnlLine.Validate("Bal. Account No.", BankAPISetup."API Bank Dummy Account");
                end
                ELSE
                begin
                    GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
                    GenJnlLine.Validate("Bal. Account No.", BankAcc."No.");
                end;
                //#296 TEC.VJ<<
                if HSBCInbound.EntryCrDrInd = 'DBIT' then GenJnlLine.Validate(Amount, HSBCInbound.EntryAmount);
                if HSBCInbound.EntryCrDrInd = 'CRDT' then GenJnlLine.Validate(Amount, -HSBCInbound.EntryAmount);
                GenJnlLine."Auto Post":=AutoPost; //15Apr2025
                GenJnlLine."Inbound Entry No.":=HSBCInbound."Entry No."; //TEC.VG#05NOV2025
                GenJnlLine.Modify();
                FoundMAtch:=true;
                HSBCInbound."Error Message":='';
                HSBCInbound."Journal Template Name":=TemplateName;
                HSBCInbound."Journal Batch Name":=NewBatchName;
                //HSBCInbound.Modify();
                Commit();
                // if BankAPISetup."Auto Post" then begin //#173 TEC.VJ 20012025
                if(AutoPost)then begin
                    GenJnlLine2.Reset();
                    GenJnlLine2.SetRange("Document No.", GenJnlLine."Document No.");
                    if GenJnlLine2.FindSet()then;
                    Clear(GenJnlPostBatch);
                    if not GenJnlPostBatch.Run(GenJnlLine2)then begin
                        HSBCInbound."Error Message":=GetLastErrorText();
                        // HSBCInbound.Status := HSBCInbound.Status::Error; //vj17jan2025 //TEC.VJ #335
                        HSBCInbound.Status:=HSBCInbound.Status::Created; //TEC.VJ #335 16MAY2025 //Entries will created but not posted.
                        HSBCInbound.Processed:=false;
                    end
                    else
                    begin
                        HSBCInbound.Processed:=true;
                        HSBCInbound.Status:=HSBCInbound.Status::Posted; //VJ15Apr2025
                    end;
                end
                else
                begin
                    HSBCInbound.Processed:=true;
                    HSBCInbound.Status:=HSBCInbound.Status::Created; //vj17jan2025
                end;
            end;
        end
        else
            HSBCInbound."Error Message":=StrSubstNo('Payment Journal Already exist template %1 batch %2 line no. %3', PaymentJnl."Journal Template Name", PaymentJnl."Journal Batch Name", PaymentJnl."Line No."); //VJ 11Sept2025 to update error if payment journal exist.
        HSBCInbound."Executed Scenario":='Create ' + SourceCode + ' Scenario2'; //TEC.VJ 17062025
        HSBCInbound.Modify();
    end;
    procedure CreateReturnPaymentJnl(HSBCInbound: Record "HSBC Inbound Staging") //scenario3
    var
        PaymentJnl: Record "Gen. Journal Line";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlBostBatch: Codeunit "Gen. Jnl.-Post Batch";
        LineNo: Integer;
        TemplateName: Code[20];
        BatchName: Code[20];
        SourceCode: Code[20];
        BankAcc: Record "Bank Account";
        VendLedgEntr: Record "Vendor Ledger Entry";
        BankAccLedg: Record "Bank Account Ledger Entry";
        ChargeLine: Boolean;
        NewBatchName: Code[20];
        GLSetup: Record "General Ledger Setup";
        AutoPost: Boolean;
    begin
        BankAPISetup.Get();
        GLSetup.Get();
        //#288 TEC.VJ 25032025>>
        // BankAPISetup.TestField("Payment Jnl. Template Name");
        // BankAPISetup.TestField("Payment Jnl. Batch Name");
        BankAPISetup.TestField("Return Template Name");
        BankAPISetup.TestField("Return Batch Name");
        //#288 TEC.VJ 25032025<<
        BankAPISetup.TestField("Bank Charge Account No."); //VJ #112
        //BankAPISetup.TestField("Bank Charge Template Name");//VJ #112
        //BankAPISetup.TestField("Bank Charge Batch Name");//VJ #112
        LineNo:=0;
        IsError:=false;
        ChargeLine:=false;
        //#190 29012025>>
        TemplateName:=BankAPISetup."Return Template Name"; //#288 TEC.VJ 25032025
        BatchName:=BankAPISetup."Return Batch Name"; //#288 TEC.VJ 25032025
        //#337 TEC.VJ 20MAY2025>> //To handle if template or batch exist or not.
        if not GenJnlBatch.Get(TemplateName, BatchName)then begin
            IsError:=true;
            HSBCInbound."Error Message":=' General Batch not found .Template Name :' + TemplateName + 'Batch Name :' + BatchName;
        end;
        //#337 TEC.VJ 20MAY2025<<
        BankAccLedg.Reset();
        BankAccLedg.SetRange("Bank Document No.", HSBCInbound.TxEndtoEndId);
        if BankAccLedg.FindFirst()then begin
            IF(BankAPISetup."Split Inbound Date Wise") and (TemplateName <> '') and (IsError = false)THEN begin
                CommFunc.InsertNewBatch(HSBCInbound.EntryBookedDate, TemplateName, BatchName, BankAcc."No.", NewBatchName);
            end
            ELSE
                NewBatchName:=BatchName;
        end;
        //#190 29012025<<
        //#333 TEC.VJ 13MAY2025>>
        AutoPost:=false;
        if GLSetup."Auto Post Return Payment Jnl." then AutoPost:=true;
        //#333 TEC.VJ 13MAY2025<<
        PaymentJnl.Reset();
        PaymentJnl.SetRange("Journal Template Name", TemplateName);
        PaymentJnl.SetRange("Journal Batch Name", NewBatchName);
        // PaymentJnl.SetFilter("Bank Document No.", '=%1', HSBCInbound.TxEndtoEndId);//TEC.VJ 25012025//TEC.VJ #335 
        PaymentJnl.SetFilter("External Document No.", '=%1', HSBCInbound.TxEndtoEndId); //TEC.VJ #335 Reference is stored in External Doc No.
        PaymentJnl.SetRange("Source Code", 'PAYMENTJNL');
        PaymentJnl.SetRange("Inbound Entry No.", HSBCInbound."Entry No."); //TEC.VG#05NOV2025
        IF not PaymentJnl.FindFirst()then begin
            SourceCode:='PAYMENTJNL';
            GenJnlLine.Reset();
            GenJnlLine.SetRange("Journal Template Name", TemplateName);
            GenJnlLine.SetRange("Journal Batch Name", NewBatchName);
            IF GenJnlLine.Findlast()then LineNo:=GenJnlLine."Line No.";
            if not GenJnlBatch.GET(TemplateName, NewBatchName)then begin
                HSBCInbound."Error Message":=' General Batch not found .Template Name :' + TemplateName + 'Batch Name :' + NewBatchName;
                IsError:=true;
            end;
            //TEC.VJ 17012025>>
            IF NOT NoSeries.Get(GenJnlBatch."No. Series")THEN BEGIN
                IsError:=true;
                HSBCInbound."Error Message":=' No Series not found . Code :' + GenJnlBatch."No. Series" + ' Template Name :' + TemplateName + ',Batch Name :' + NewBatchName;
            END;
            //TEC.VJ 17012025<<
            VendLedgEntr.Reset();
            VendLedgEntr.SetRange("Bank Document No.", HSBCInbound.TxEndtoEndId); //#112 TEC.VJ
            if not VendLedgEntr.FindSet()then begin
                IsError:=true;
                HSBCInbound."Error Message"+=' Vendor Ledger not found .Bank Document No. :' + HSBCInbound.TxEndtoEndId;
            end
            else
            begin
                //#112 TEC.VJ>>
                VendLedgEntr.CalcFields("Original Amount");
                IF VendLedgEntr."Original Amount" <> HSBCInbound.EntryAmount THEN if BankAPISetup."Bank Charge Account No." = '' then begin
                        IsError:=true;
                        HSBCInbound."Error Message"+=' Bank Charge Account No. must have a value. :' + HSBCInbound.TxEndtoEndId;
                    end;
            //#112 TEC.VJ<<
            end;
            BankAccLedg.Reset();
            BankAccLedg.SetRange("Bank Document No.", HSBCInbound.TxEndtoEndId);
            if not BankAccLedg.FindFirst()then begin
                IsError:=true;
                HSBCInbound."Error Message"+=' Bank Ledger not found .Bank Document No. :' + HSBCInbound.TxEndtoEndId;
            end;
            if not IsError then begin
                InsertGenJnlLine(HSBCInbound, GenJnlLine, LineNo, TemplateName, NewBatchName, SourceCode, GenJnlLine."Account Type"::Vendor, VendLedgEntr."Vendor No.", BankAccLedg."Bank Account No.", HSBCInbound.EntryAmount, ChargeLine, AutoPost);
                //VJ #112 Start
                //TemplateName := BankAPISetup."Bank Charge Template Name"; //VJ 19MAR2025 Because bank charge should go into same template and batch of return entry
                //BatchName := BankAPISetup."Bank Charge Batch Name";
                //#190 29012025>>
                IF(BankAPISetup."Split Inbound Date Wise") and (TemplateName <> '')THEN begin
                    CommFunc.InsertNewBatch(HSBCInbound.EntryBookedDate, TemplateName, BatchName, BankAccLedg."Bank Account No.", NewBatchName);
                end
                ELSE
                    NewBatchName:=BatchName;
                //#190 29012025<<
                GenJnlLine.Reset();
                GenJnlLine.SetRange("Journal Template Name", TemplateName);
                GenJnlLine.SetRange("Journal Batch Name", NewBatchName);
                IF GenJnlLine.Findlast()then LineNo:=GenJnlLine."Line No.";
                //LineNo := LineNo + 10000;
                ChargeLine:=true;
                IF VendLedgEntr."Original Amount" <> HSBCInbound.EntryAmount THEN InsertGenJnlLine(HSBCInbound, GenJnlLine, LineNo, TemplateName, NewBatchName, SourceCode, GenJnlLine."Account Type"::"G/L Account", BankAPISetup."Bank Charge Account No.", BankAccLedg."Bank Account No.", VendLedgEntr."Original Amount" - HSBCInbound.EntryAmount, ChargeLine, AutoPost);
                //VJ #112 End
                HSBCInbound."Error Message":='';
                HSBCInbound."Journal Template Name":=TemplateName;
                HSBCInbound."Journal Batch Name":=NewBatchName;
                //HSBCInbound.Modify();
                Commit();
                if AutoPost then begin //#252 TEC.VJ
                    GenJnlLine2.Reset();
                    GenJnlLine2.SetRange("Document No.", GenJnlLine."Document No.");
                    if GenJnlLine2.FindSet()then;
                    Clear(GenJnlPostBatch);
                    if not GenJnlPostBatch.Run(GenJnlLine2)then begin
                        HSBCInbound."Error Message":=GetLastErrorText();
                        // HSBCInbound.Status := HSBCInbound.Status::Error; //vj17jan2025
                        HSBCInbound.Status:=HSBCInbound.Status::Created; //vj17jan2025//#335 TEC.VJ CHANGED ERROR TO CREATED 
                        HSBCInbound.Processed:=false;
                    end
                    else
                    begin
                        HSBCInbound.Processed:=true;
                        HSBCInbound.Status:=HSBCInbound.Status::Posted; //VJ15APR2025//VJ17JAN2025
                    end;
                end
                else
                begin
                    HSBCInbound.Processed:=true;
                    HSBCInbound.Status:=HSBCInbound.Status::Created; //VJ17JAN2025
                end;
            end;
        end;
        HSBCInbound."Executed Scenario":='Create Return Payment Scenario3'; //TEC.VJ 17062025
        HSBCInbound.Modify();
    end;
    //#189 TEC.VJ 25012025>>
    procedure CreatePaymentJnl(HSBCInbound: Record "HSBC Inbound Staging"): Boolean //scenario4
 var
        PaymentJnl: Record "Gen. Journal Line";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlBostBatch: Codeunit "Gen. Jnl.-Post Batch";
        LineNo: Integer;
        BankCodeMapping: Record "Inbound Transfer Mapping";
        TemplateName: Code[20];
        BatchName: Code[20];
        NewBatchName: Code[20];
        SourceCode: Code[20];
        BankAcc: Record "Bank Account";
        AutoPost: Boolean;
        LineAmt: Decimal;
        AmtLCY: Decimal;
        GLSetup: Record "General Ledger Setup";
    begin
        BankAPISetup.Get();
        GLSetup.Get();
        BankAPISetup.TestField("TRP Payment Jnl. Template Name");
        BankAPISetup.TestField("TRP Payment Jnl. Batch Name");
        LineNo:=0;
        IsError:=false;
        AutoPost:=false;
        LineAmt:=0;
        AmtLCY:=0;
        BankCodeMapping.Reset();
        BankCodeMapping.SetRange(Code, HSBCInbound.EntryTransCode);
        BankCodeMapping.SetRange("DBIT / CRDT", HSBCInbound.EntryCrDrInd);
        if not BankCodeMapping.FindFirst()then begin
            IsError:=true;
            HSBCInbound."Error Message":=StrSubstNo('Bank Code mapping not found. Bank Code : %1 DBIT/CRDT %2', HSBCInbound.EntryTransCode, HSBCInbound.EntryCrDrInd);
            HSBCInbound.Status:=HSBCInbound.Status::Error;
        end;
        IF BankCodeMapping."Account Type" = BankCodeMapping."Account Type"::Vendor THEN begin
            TemplateName:=BankAPISetup."TRP Payment Jnl. Template Name";
            BatchName:=BankAPISetup."TRP Payment Jnl. Batch Name";
            //#337 TEC.VJ 20MAY2025>> //To handle if template or batch exist or not.
            if not GenJnlBatch.Get(TemplateName, BatchName)then begin
                IsError:=true;
                HSBCInbound."Error Message":=' General Batch not found .Template Name :' + TemplateName + 'Batch Name :' + BatchName;
            end;
            //#337 TEC.VJ 20MAY2025<<
            SourceCode:='PAYMENTJNL';
            if GLSetup."Auto Post Payment Jnl." then //#252 TEC.VJ
 AutoPost:=true;
            BankAcc.Reset();
            BankAcc.SetRange("Bank Account No.", HSBCInbound."Bank Account");
            if not BankAcc.FindFirst()then begin
                IsError:=true;
                HSBCInbound."Error Message":=' Bank Account not found .Bank Account :' + HSBCInbound."Bank Account";
            end;
            //#190 29012025>>
            IF(BankAPISetup."Split Inbound Date Wise") and (TemplateName <> '') and (IsError = false)THEN begin
                CommFunc.InsertNewBatch(HSBCInbound.EntryBookedDate, TemplateName, BatchName, BankAcc."No.", NewBatchName);
            end
            ELSE
                NewBatchName:=BatchName;
            //#190 29012025<<
            PaymentJnl.Reset();
            PaymentJnl.SetRange("Journal Template Name", TemplateName);
            PaymentJnl.SetRange("Journal Batch Name", NewBatchName);
            PaymentJnl.SetRange("Source Code", 'PAYMENTJNL');
            // PaymentJnl.SetFilter("Bank Document No.", '=%1', HSBCInbound.TxEndtoEndId);//TEC.VJ #335
            PaymentJnl.SetFilter("External Document No.", '=%1', HSBCInbound.TxEndtoEndId); //TEC.VJ #335 Reference is stored in External Doc No.
            PaymentJnl.SetRange("Inbound Entry No.", HSBCInbound."Entry No."); //TEC.VG#05NOV2025
            IF not PaymentJnl.FindFirst()then begin
                GenJnlLine.Reset();
                GenJnlLine.SetRange("Journal Template Name", TemplateName);
                GenJnlLine.SetRange("Journal Batch Name", NewBatchName);
                IF GenJnlLine.Findlast()then LineNo:=GenJnlLine."Line No.";
                if not GenJnlBatch.GET(TemplateName, NewBatchName)then begin
                    IsError:=true;
                    HSBCInbound."Error Message":=' General Batch not found .Template Name :' + TemplateName + ' Batch Name :' + NewBatchName;
                end;
                //  else begin
                //     IF NOT NoSeries.Get(GenJnlBatch."No. Series") THEN BEGIN
                //         IsError := true;
                //         HSBCInbound."Error Message" := ' No Series not found . Code :' + GenJnlBatch."No. Series";
                //     END;
                // end;
                IF NOT NoSeries.Get(GenJnlBatch."No. Series")THEN BEGIN
                    IsError:=true;
                    HSBCInbound."Error Message":=' No Series not found . Code :' + GenJnlBatch."No. Series" + ' Template Name :' + TemplateName + ',Batch Name :' + NewBatchName;
                END;
                if not IsError then begin
                    GenJnlLine.Init();
                    GenJnlLine.Validate("Journal Template Name", TemplateName);
                    GenJnlLine.Validate("Journal Batch Name", NewBatchName);
                    GenJnlLine."Line No.":=LineNo + 10000;
                    GenJnlLine.Insert(true);
                    GenJnlLine.Validate("Posting Date", HSBCInbound.EntryBookedDate);
                    GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment);
                    DocumtNo:=NoSMgmt.GetNextNo(NoSeries.Code, HSBCInbound.EntryBookedDate, true);
                    GenJnlLine.Validate("Document No.", DocumtNo);
                    GenJnlLine."External Document No.":=HSBCInbound.TxEndtoEndId;
                    GenJnlLine.Validate("Source Code", SourceCode);
                    GenJnlLine.Validate("Account Type", BankCodeMapping."Account Type");
                    GenJnlLine.Validate("Account No.", BankCodeMapping."Account No.");
                    GenJnlLine.Description:=CopyStr(HSBCInbound."Additional Entry Information", 1, 100);
                    GenJnlLine."Bank Transaction Code":=BankCodeMapping.Code + ' ' + BankCodeMapping.Description;
                    // GenJnlLine.Validate("Recipient Bank Account",'');//
                    // GenJnlLine.Validate("Employee Bank Account",'');//
                    //#212 TEC.VJ 11022025>>
                    GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
                    GenJnlLine.Validate("Bal. Account No.", BankAcc."No.");
                    if(HSBCInbound.TxAmt <> 0) and (HSBCInbound.TxCurrency <> '')then begin
                        GenJnlLine.Validate("Currency Code", HSBCInbound.TxCurrency);
                        LineAmt:=HSBCInbound.TxAmt;
                        if HSBCInbound.EntryCurrency = GLSetup."LCY Code" then AmtLCY:=HSBCInbound.EntryAmount;
                    end
                    else
                    begin
                        GenJnlLine.Validate("Currency Code", HSBCInbound.EntryCurrency);
                        LineAmt:=HSBCInbound.EntryAmount;
                        if HSBCInbound.EntryCurrency = GLSetup."LCY Code" then AmtLCY:=HSBCInbound.EntryAmount;
                    end;
                    if HSBCInbound.EntryCrDrInd = 'DBIT' then begin
                        GenJnlLine.Validate(Amount, LineAmt);
                        if AmtLCY <> 0 then if GLSetup."LCY Code" = HSBCInbound.Currency then //#322 TEC.VJ 29052025 //Discussed with Conor and let system calculate amount LCY  
 GenJnlLine.Validate("Amount (LCY)", AmtLCY);
                    end
                    else if HSBCInbound.EntryCrDrInd = 'CRDT' then begin
                            GenJnlLine.Validate(Amount, -LineAmt);
                            if AmtLCY <> 0 then if GLSetup."LCY Code" = HSBCInbound.Currency then //#322 TEC.VJ 29052025 //Discussed with Conor and let system calculate amount LCY  
 GenJnlLine.Validate("Amount (LCY)", -AmtLCY);
                        end;
                    GenJnlLine."Additional Entry Information":=HSBCInbound."Additional Entry Information";
                    GenJnlLine."Creditor Name":=HSBCInbound."Creditor Name";
                    GenJnlLine."Bypass API":=true;
                    GenJnlLine."Charges Bearer":=GenJnlLine."Charges Bearer"::OUR; //VJ 11FEB2025
                    GenJnlLine.Validate("Payment Method Code", ''); //VJ #222 14Feb2025
                    GenJnlLine."Auto Post":=true; //VJ15APR2025
                    GenJnlLine."Inbound Entry No.":=HSBCInbound."Entry No."; //TEC.VG#05NOV2025
                    GenJnlLine.Modify();
                    FoundMAtch:=true;
                    HSBCInbound."Error Message":='';
                    HSBCInbound."Journal Template Name":=TemplateName;
                    HSBCInbound."Journal Batch Name":=NewBatchName;
                    //HSBCInbound.Modify();
                    Commit();
                    if(AutoPost)then begin
                        GenJnlLine2.Reset();
                        GenJnlLine2.SetRange("Document No.", GenJnlLine."Document No.");
                        if GenJnlLine2.FindSet()then;
                        Clear(GenJnlPostBatch);
                        if not GenJnlPostBatch.Run(GenJnlLine2)then begin
                            HSBCInbound."Error Message":=GetLastErrorText();
                            // HSBCInbound.Status := HSBCInbound.Status::Error;
                            HSBCInbound.Status:=HSBCInbound.Status::Created; //vj17jan2025//#335 TEC.VJ CHANGED ERROR TO CREATED 
                            HSBCInbound.Processed:=false;
                        end
                        else
                        begin
                            HSBCInbound.Processed:=true;
                            HSBCInbound.Status:=HSBCInbound.Status::Posted; //VJ15APR2025
                        end;
                    end
                    else
                    begin
                        HSBCInbound.Processed:=true;
                        HSBCInbound.Status:=HSBCInbound.Status::Created;
                    end;
                end;
            end;
        end;
        if IsError then HSBCInbound.Status:=HSBCInbound.Status::Error;
        HSBCInbound."Executed Scenario":='Create Payment Jnl Scenario4'; //TEC.VJ 17062025
        HSBCInbound.Modify();
    end;
    //#189 TEC.VJ 25012025<<
    local procedure InsertGenJnlLine(HSBCInbound: Record "HSBC Inbound Staging"; var GenJnlLine: Record "Gen. Journal Line"; var LineNo: Integer; TemplateName: Code[20]; BatchName: Code[20]; SourceCode: Code[20]; AccType: Enum "Gen. Journal Account Type"; AccNo: code[20]; BalAccNo: code[20]; Amount: decimal; p_ChargeLine: Boolean; AutoPost: boolean)
    begin
        GenJnlLine.Init();
        GenJnlLine.Validate("Journal Template Name", TemplateName);
        GenJnlLine.Validate("Journal Batch Name", BatchName);
        GenJnlLine."Line No.":=LineNo + 10000;
        GenJnlLine.Insert();
        //GenJnlLine.Validate("Posting Date", HSBCInbound.EntryValueDate); //RC130325
        GenJnlLine.Validate("Posting Date", HSBCInbound.EntryBookedDate); //RC 130325
        if not p_ChargeLine then GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Refund);
        // GenJnlLine.Validate("Document No.", HSBCInbound.TxEndtoEndId);
        // DocumtNo := NoSMgmt.GetNextNo(NoSeries.Code, HSBCInbound.EntryValueDate, true);//TEC.VJ 17012025
        DocumtNo:=NoSMgmt.GetNextNo(NoSeries.Code, HSBCInbound.EntryBookedDate, true); //RC 13032025
        GenJnlLine."External Document No.":=HSBCInbound.TxEndtoEndId;
        GenJnlLine.Description:=CopyStr(HSBCInbound."Additional Entry Information", 1, 100); //TEC.VJ #112
        GenJnlLine.Validate("Source Code", SourceCode);
        GenJnlLine.Validate("Account Type", AccType);
        GenJnlLine.Validate("Account No.", AccNo);
        GenJnlLine.Validate("Currency Code", HSBCInbound.EntryCurrency);
        GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
        GenJnlLine.Validate("Bal. Account No.", BalAccNo);
        GenJnlLine.Validate(Amount, Amount);
        GenJnlLine."Auto Post":=AutoPost; //VJ15APR2025
        GenJnlLine."Inbound Entry No.":=HSBCInbound."Entry No."; //TEC.VG#05NOV2025
        GenJnlLine.Modify();
        FoundMAtch:=true;
    end;
    //VJ 17Jan2025 Start
    procedure UpdateDuplicateStatus()
    var
        HSBCInbound: Record "HSBC Inbound Staging";
        HSBCInbound2: Record "HSBC Inbound Staging";
        TransactionCodeMapping: Record "Inbound Transfer Mapping";
    begin
        HSBCInbound.Reset();
        HSBCInbound.SetRange(Status, HSBCInbound.Status::Pending);
        IF HSBCInbound.FindSet()THEN repeat TransactionCodeMapping.RESET;
                TransactionCodeMapping.SETRANGE(Code, HSBCInbound.EntryTransCode);
                IF TransactionCodeMapping.FINDSET THEN;
                HSBCInbound2.Reset();
                HSBCInbound2.SetRange(TxEndtoEndId, HSBCInbound.TxEndtoEndId);
                HSBCInbound2.SetRange(EntryBookedDate, HSBCInbound.EntryBookedDate); //RC 130325
                HSBCInbound2.SetRange(EntryAccountServRef, HSBCInbound.EntryAccountServRef); //Rajan 08Mar25
                HSBCInbound2.SETRANGE(EntryCrDrInd, HSBCInbound.EntryCrDrInd); //DC 09MAR25
                HSBCInbound2.SETRANGE(EntryTransCode, HSBCInbound.EntryTransCode); //DC 12MAR25
                HSBCInbound2.SetRange("Bank Account", HSBCInbound."Bank Account"); //NT 20250729
                HSBCInbound2.SETFILTER(Status, '=%1|%2', HSBCInbound2.Status::Created, HSBCInbound2.Status::Posted);
                IF TransactionCodeMapping."Check Duplicate Include Currency" then HSBCInbound2.SETRANGE(EntryCurrency, HSBCInbound.EntryCurrency);
                if HSBCInbound2.FindSet()then begin
                    HSBCInbound.Status:=HSBCInbound.Status::Duplicate; //Rajan 08Mar25
                    HSBCInbound.Modify(); //Rajan 08Mar25
                //HSBCInbound2.ModifyAll(Status, HSBCInbound2.Status::Duplicate); //Rajan 08Mar25
                end
                else
                begin
                    HSBCInbound2.Reset();
                    //HSBCInbound2.SetRange(Status, HSBCInbound2.Status::Pending); //Rajan 08Mar25
                    HSBCInbound2.SetRange(TxEndtoEndId, HSBCInbound.TxEndtoEndId);
                    //HSBCInbound2.SetRange(EntryValueDate, HSBCInbound.EntryValueDate);//RC 130325
                    HSBCInbound2.SetRange(EntryBookedDate, HSBCInbound.EntryBookedDate); //RC 130325
                    HSBCInbound2.SetRange(EntryAccountServRef, HSBCInbound.EntryAccountServRef); //Rajan 08Mar25
                    HSBCInbound2.SETRANGE(EntryCrDrInd, HSBCInbound.EntryCrDrInd); //DC 09MAR25
                    HSBCInbound2.SETRANGE(EntryTransCode, HSBCInbound.EntryTransCode); //DC 12MAR25
                    //HSBCInbound2.SetFilter("Entry No.", '>%1', HSBCInbound."Entry No.");//Rajan 08Mar25
                    HSBCInbound2.SetFilter("Entry No.", '<%1', HSBCInbound."Entry No."); //Rajan 08Mar25
                    IF TransactionCodeMapping."Check Duplicate Include Currency" then HSBCInbound2.SETRANGE(EntryCurrency, HSBCInbound.EntryCurrency);
                    if HSBCInbound2.FindSet()then begin
                        HSBCInbound.Status:=HSBCInbound.Status::Duplicate; //Rajan 08Mar25
                        HSBCInbound.Modify(); //Rajan 08Mar25
                    //HSBCInbound2.ModifyAll(Status, HSBCInbound2.Status::Duplicate); //Rajan 08Mar25
                    end;
                end;
            until HSBCInbound.Next() = 0;
    end;
    //VJ 17Jan2025 End
    //VJ 17Jan2025 Start
    procedure UpdateCancelStatus(HsbcInbound_p: Record "HSBC Inbound Staging")
    var
        HSBCInbound: Record "HSBC Inbound Staging";
    begin
        HSBCInbound.Copy(HsbcInbound_p);
        HSBCInbound.Setfilter(Status, '%1|%2', HSBCInbound.Status::Pending, HSBCInbound.Status::Error);
        IF HSBCInbound.FindSet()THEN HSBCInbound.ModifyAll(Status, HSBCInbound.Status::Cancelled);
    end;
    //VJ 17Jan2025 End
    //28012025>>
    local procedure TempBatchInsert(var HSBCOutboundStag: Record "HSBC Outbound Staging Table")
    begin
        TempGenJnlBatch.Init();
        TempGenJnlBatch."Journal Template Name":=HSBCOutboundStag."Journal Template Name";
        TempGenJnlBatch.Name:=HSBCOutboundStag."Journal Batch Name";
        if TempGenJnlBatch.Insert()then;
    end;
    //28012025<<
    //16Sept2025<<Start
    local procedure ValidateEntryTransCode()
    var
        HSBCInbound: Record "HSBC Inbound Staging";
        HSBCInbound2: Record "HSBC Inbound Staging";
        BankMappingCode: Record "Inbound Transfer Mapping";
    begin
        BankMappingCode.Reset();
        BankMappingCode.SetRange("Mark as Cancel", true);
        if BankMappingCode.FindSet()then begin
            repeat HSBCInbound.Reset();
                HSBCInbound.SetRange(EntryTransCode, BankMappingCode.Code);
                HSBCInbound.Setfilter(Status, '%1|%2', HSBCInbound.Status::Pending, HSBCInbound.Status::Error);
                if HSBCInbound.FindSet()then repeat HSBCInbound2.get(HSBCInbound."Entry No.");
                        HSBCInbound2.Status:=HSBCInbound2.Status::Cancelled;
                        HSBCInbound2."Error Message":=StrSubstNo('Mapping %1 marked as cancel. Entry cancelled.', BankMappingCode.Code);
                        if HSBCInbound2.Modify()then;
                    until HSBCInbound.Next() = 0;
            until BankMappingCode.Next() = 0;
        end;
    end;
    //16Sept2025<<End
    var GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
    TempGenJnlBatch: Record "Gen. Journal Batch" temporary;
    NoSMgmt: Codeunit "No. Series";
    DocumtNo: Code[20];
    NoSeries: Record "No. Series";
    BankAPISetup: Record "Bank API Setup";
    IsError: Boolean;
    CommFunc: Codeunit "Common Functions";
    FoundMAtch: Boolean;
}
