codeunit 50207 "Citi Inbound Codeunit V2"
{
    trigger OnRun()
    begin
        ProcessAllInboundLines(5);
    end;
    procedure ProcessAllInboundLines(Scenario: Integer)
    var
        CitiInbound: Record "Citi Inbound Staging";
        CitiInbound2: Record "Citi Inbound Staging";
    begin
        //Start VJ21072025
        StopOnError:=false;
        if g_CitiInbEntryNo <> 0 then StopOnError:=false;
        //End VJ21072025
        CitiInbound.Reset();
        UpdateDuplicateStatus();
        CitiInbound.SetRange(Processed, false);
        if g_CitiInbEntryNo <> 0 then // VJ21072025
 CitiInbound.SetRange("Entry No.", g_CitiInbEntryNo); // VJ21072025
        CitiInbound.Setfilter(Status, '%1|%2', CitiInbound.Status::Pending, CitiInbound.Status::Error); //VJ 17JAN2025
        IF CitiInbound.FindSet()then repeat FoundMAtch:=false;
                //3start
                if(Scenario = 3) or (Scenario = 5) and (not FoundMAtch)then begin
                    CitiInbound2.Reset();
                    CitiInbound2.SetRange("Entry No.", CitiInbound."Entry No.");
                    CitiInbound2.SetRange(EntryCrDrInd, 'CRDT');
                    CitiInbound2.SetFilter("Additional Entry Information", '=%1|%2|%3', '*' + 'Ret' + '*', '*' + 'Rtn' + '*', '*' + 'RETN' + '*'); //#135 TEC.VJ
                    CitiInbound2.SetRange(EntryStatus, 'BOOK');
                    CitiInbound2.SetFilter(Status, '<>%1&<>%2', CitiInbound2.Status::Success, CitiInbound2.Status::Created);
                    CitiInbound2.SetFilter(EntryTransCode, '195'); //27Feb2025
                    IF CitiInbound2.Findfirst()then CreateReturnPaymentJnl(CitiInbound2);
                end;
                //3end
                //2start
                if(Scenario = 2) or (Scenario = 5) and (not FoundMAtch)then begin
                    CitiInbound2.Reset();
                    CitiInbound2.SetRange("Entry No.", CitiInbound."Entry No.");
                    CitiInbound2.SetFilter(EntryTransCode, '<>%1', 'NTRF');
                    CitiInbound2.SetRange(EntryStatus, 'BOOK');
                    IF CitiInbound2.Findfirst()then CreateCash_GenJnl(CitiInbound2);
                end;
                //2end
                //1Start
                if(Scenario = 1) or (Scenario = 5) and (not FoundMAtch)then begin
                    CitiInbound2.Reset();
                    CitiInbound2.SetRange("Entry No.", CitiInbound."Entry No.");
                    CitiInbound2.SetRange(EntryStatus, 'BOOK');
                    CitiInbound2.SetFilter(Status, '<>%1&<>%2', CitiInbound2.Status::Success, CitiInbound2.Status::Created);
                    IF CitiInbound2.Findfirst()then UpdatePaymentJnl1(CitiInbound2);
                end;
                //1end
                //4start
                if(Scenario = 4) or (Scenario = 5) and (not FoundMAtch)then begin
                    CitiInbound2.Reset();
                    CitiInbound2.SetRange("Entry No.", CitiInbound."Entry No.");
                    CitiInbound2.SetRange(EntryStatus, 'BOOK');
                    CitiInbound2.SetFilter(Status, '<>%1&<>%2&<>%3', CitiInbound2.Status::Success, CitiInbound2.Status::Posted, CitiInbound2.Status::Created);
                    IF CitiInbound2.Findfirst()then CreatePaymentJnl(CitiInbound2);
                end;
            //4end
            until CitiInbound.Next() = 0;
    end;
    //TEC.VJ 17DEC2024>>
    procedure UpdatePaymentJnl1(var CitiInbound: Record "Citi Inbound Staging") //Scenario1
    var
        CitiInbound2: Record "Citi Inbound Staging";
        PaymentJnl: Record "Gen. Journal Line";
        PaymentJnl2: Record "Gen. Journal Line";
        GenJnlBostBatch: Codeunit "Gen. Jnl.-Post Batch";
        CitiOutboundStag: Record "Citi Outbound Staging Table";
        PostCitiInboundPaymentJnl: Codeunit "Post Citi Inbound Payment Jnl";
        FindRecord: Boolean;
    begin
        if TempGenJnlBatch.IsTemporary then TempGenJnlBatch.DeleteAll();
        BankApiSetup.Get();
        //BankApiSetup.TestField("Payment Jnl. Template Name");
        //BankApiSetup.TestField("Payment Jnl. Batch Name");
        CitiInbound2.Get(CitiInbound."Entry No.");
        Commit();
        if PostCitiInboundPaymentJnl.Run(CitiInbound)then begin
            CitiInbound2."Error Message":='';
            CitiInbound2.Processed:=true;
            CitiInbound2.Status:=CitiInbound2.Status::Posted; //VJ 17jan2025
            FoundMAtch:=true;
            CitiOutboundStag.Reset();
            CitiOutboundStag.SetRange("Bank Document No.", CitiInbound2.TxEndtoEndId);
            if CitiOutboundStag.FindSet()then begin
                CitiOutboundStag.Modifyall(Status, CitiOutboundStag.Status::Booked); //TEC.VJ 07012025
                TempBatchInsert(CitiOutboundStag); //28012025
            end;
        end
        ELSE
        begin
            FoundMAtch:=PostCitiInboundPaymentJnl.GetFoundMatch();
            CitiInbound2."Error Message":=GetLastErrorText();
            CitiInbound2.Status:=CitiInbound2.Status::Error; //VJ 17jan2025 //#324 GenJnl Lines Creating Duplicate // #335 TEC.VJ 
            // CitiInbound2.Status := CitiInbound2.Status::Created;//VJ 17jan2025 //#324 TEC.VJ  // #335 TEC.VJ 
            //28012025>>
            CitiOutboundStag.Reset();
            CitiOutboundStag.SetRange("Bank Document No.", CitiInbound2.TxEndtoEndId);
            if CitiOutboundStag.FindSet()then begin
                TempBatchInsert(CitiOutboundStag);
            end;
        //28012025<<
        end;
        //CitiInbound2.Modify();
        CitiInbound2."Executed Scenario":='Post Payment Scenario1'; //TEC.VJ 17062025
        if CitiInbound2.Modify()then; //handling of double modify which is also modifying on posting to update status field in inbound//15Apr2025
        UpdateGenJnlBatchFields(); //28012025
    end;
    //TEC.VJ 17DEC2024<<
    procedure CreateCash_GenJnl(var CitiInbound: Record "Citi Inbound Staging") //scenario2
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
        IsError: Boolean;
        AutoPost: Boolean;
        NewBatchName: Code[20];
        GLSetup: Record "General Ledger Setup";
        AmtLCY: Decimal;
        IsFundTransfer: Boolean;
    begin
        BankAPISetup.Get();
        GLSetup.Get();
        IsFundTransfer:=(StrPos(CitiInbound."Additional Entry Information", 'PBFUNDTRANSFER') <> 0); //VJ 25062025 added code
        LineNo:=0;
        IsError:=false;
        AutoPost:=false;
        //                if not BankCodeMapping.Get(CitiInbound.EntryTransCode) then begin
        BankCodeMapping.Reset();
        BankCodeMapping.SetRange(Code, CitiInbound.EntryTransCode);
        BankCodeMapping.SetRange("DBIT / CRDT", CitiInbound.EntryCrDrInd);
        //VJ 25062025 added code to find the correct bank code mapping because there might be two mapping for same EntryTransCode and it should find the correct one not always first
        if IsFundTransfer then BankCodeMapping.SetRange(PBFundTransfer, true)
        else
            BankCodeMapping.SetRange(PBFundTransfer, false);
        //VJ 25062025 added code to find the correct bank code mapping because there might be two mapping for same EntryTransCode and it should find the correct one not always first
        if not BankCodeMapping.FindFirst()then begin
            IsError:=true;
            CitiInbound."Error Message":='Bank Code mapping not found. Bank Code :' + CitiInbound.EntryTransCode;
            //Start VJ21072025
            if(StopOnError) AND (CitiInbound."Error Message" <> '')then CitiInbound.FieldError("Entry No.", CitiInbound."Error Message");
        //End VJ21072025
        end;
        IF BankCodeMapping."Account Type" = BankCodeMapping."Account Type"::Customer THEN begin
            //#296 TEC.VJ 03MAR2025<<
            // if CitiInbound."Additional Entry Information" = 'PBFUNDTRANSFER' then begin
            IF(StrPos(CitiInbound."Additional Entry Information", 'PBFUNDTRANSFER') <> 0)then begin //#347 TEC.VJ
                BankAPISetup.TestField("Bank Transfer Template Name");
                BankAPISetup.TestField("Bank Transfer Batch Name");
                TemplateName:=BankAPISetup."Bank Transfer Template Name";
                BatchName:=BankAPISetup."Bank Transfer Batch Name";
                if GLSetup."Auto Post Bank Transfer" then //#312 TEC.VJ 22APR2025
 AutoPost:=true;
            end
            else
            begin
                //#296 TEC.VJ 03MAR2025>>
                BankAPISetup.TestField("CaschRcpt Template Name");
                BankAPISetup.TestField("CaschRcpt Batch Name");
                TemplateName:=BankAPISetup."CaschRcpt Template Name";
                BatchName:=BankAPISetup."CaschRcpt Batch Name";
                if GLSetup."Auto Post Cash Rcpt." then //#252 TEC.VJ
 AutoPost:=true; //TEC.VJ 20012025
            end;
            SourceCode:='CASHRECJNL';
        end
        else if BankCodeMapping."Account Type" = BankCodeMapping."Account Type"::"G/L Account" then begin
                //#296 TEC.VJ 03MAR2025<<Added for GL 11Apr2025
                // if CitiInbound."Additional Entry Information" = 'PBFUNDTRANSFER' then begin
                IF(StrPos(CitiInbound."Additional Entry Information", 'PBFUNDTRANSFER') <> 0)then begin //#347 TEC.VJ
                    BankAPISetup.TestField("Bank Transfer Template Name");
                    BankAPISetup.TestField("Bank Transfer Batch Name");
                    TemplateName:=BankAPISetup."Bank Transfer Template Name";
                    BatchName:=BankAPISetup."Bank Transfer Batch Name";
                    if GLSetup."Auto Post Bank Transfer" then //#312 TEC.VJ 22APR2025
 AutoPost:=true;
                end
                else
                begin
                    //#296 TEC.VJ 03MAR2025>>
                    BankAPISetup.TestField("General Jnl. Template Name");
                    BankAPISetup.TestField("General Jnl. Batch Name");
                    TemplateName:=BankAPISetup."General Jnl. Template Name";
                    BatchName:=BankAPISetup."General Jnl. Batch Name";
                    if GLSetup."Auto Post Cash Rcpt." then //#252 TEC.VJ
 AutoPost:=true; //TEC.VJ 20012025
                end;
                SourceCode:='GENJNL';
            end;
        //#337 TEC.VJ 20MAY2025>> //To handle if template or batch exist or not.
        if not GenJnlBatch.Get(TemplateName, BatchName)then begin
            IsError:=true;
            CitiInbound."Error Message":=' General Batch not found .Template Name :' + TemplateName + 'Batch Name :' + BatchName;
            //Start VJ21072025
            if(StopOnError) AND (CitiInbound."Error Message" <> '')then CitiInbound.FieldError("Entry No.", CitiInbound."Error Message");
        //End VJ21072025
        end;
        //#337 TEC.VJ 20MAY2025<<
        BankAcc.Reset();
        BankAcc.SetRange("Bank Account No.", CitiInbound."Bank Account");
        if not BankAcc.FindFirst()then begin
            IsError:=true;
            CitiInbound."Error Message":='Bank Account not found , Bank Account :' + CitiInbound."Bank Account";
            //Start VJ21072025
            if(StopOnError) AND (CitiInbound."Error Message" <> '')then CitiInbound.FieldError("Entry No.", CitiInbound."Error Message");
        //End VJ21072025
        end;
        //#190 29012025>>
        IF(BankAPISetup."Split Inbound Date Wise") and (TemplateName <> '') and (IsError = false)THEN begin
            CommonFunc.InsertNewBatch(CitiInbound.EntryBookedDate, TemplateName, BatchName, BankAcc."No.", NewBatchName);
        end
        ELSE
            NewBatchName:=BatchName;
        //#190 29012025<<
        PaymentJnl.Reset();
        PaymentJnl.SetRange("Journal Template Name", TemplateName);
        PaymentJnl.SetRange("Journal Batch Name", NewBatchName);
        PaymentJnl.SetRange("Source Code", SourceCode);
        // PaymentJnl.SetFilter("Bank Document No.", '=%1', CitiInbound.TxEndtoEndId);//25012025
        PaymentJnl.SetFilter("External Document No.", '=%1', CitiInbound.TxEndtoEndId); //TEC.VJ #335  For Stop Duplicate Cash Rcpt lines creating
        //PaymentJnl.SetRange("Posting Date", CitiInbound.EntryValueDate); //RC 130325
        PaymentJnl.SetRange("Posting Date", CitiInbound.EntryBookedDate); //RC 130325
        PaymentJnl.SetRange("Inbound Entry No.", CitiInbound."Entry No."); //TEC.VG#05NOV2025
        IF not PaymentJnl.FindFirst()then begin
            GenJnlLine.Reset();
            GenJnlLine.SetRange("Journal Template Name", TemplateName);
            GenJnlLine.SetRange("Journal Batch Name", NewBatchName);
            IF GenJnlLine.Findlast()then LineNo:=GenJnlLine."Line No.";
            if not GenJnlBatch.GET(TemplateName, NewBatchName)then begin
                IsError:=true;
                CitiInbound."Error Message":=' General Batch not found .Template Name :' + TemplateName + 'Batch Name :' + NewBatchName;
                //Start VJ21072025
                if(StopOnError) AND (CitiInbound."Error Message" <> '')then CitiInbound.FieldError("Entry No.", CitiInbound."Error Message");
            //End VJ21072025
            end;
            //TEC.VJ 17012025>>
            IF NOT NoSeries.Get(GenJnlBatch."No. Series")THEN BEGIN
                IsError:=true;
                CitiInbound."Error Message":=' No Series not found . Code :' + GenJnlBatch."No. Series" + ' Template Name :' + TemplateName + ',Batch Name :' + NewBatchName;
                //Start VJ21072025
                if(StopOnError) AND (CitiInbound."Error Message" <> '')then CitiInbound.FieldError("Entry No.", CitiInbound."Error Message");
            //End VJ21072025
            END;
            //TEC.VJ 17012025<<
            if not IsError then begin
                GenJnlLine.Init();
                GenJnlLine.Validate("Journal Template Name", TemplateName);
                GenJnlLine.Validate("Journal Batch Name", NewBatchName);
                GenJnlLine."Line No.":=LineNo + 10000;
                GenJnlLine.Insert();
                //GenJnlLine.Validate("Posting Date", CitiInbound.EntryValueDate); //RC130325
                GenJnlLine.Validate("Posting Date", CitiInbound.EntryBookedDate); //C130325
                if SourceCode = 'CASHRECJNL' then GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Invoice);
                //VJ 17JAN2025 Start
                if CitiInbound.EntryCrDrInd = 'CRDT' then //GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment);
                    GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::" "); //#279 VJ 20032025
                //VJ 17JAN2025 end
                //DocumtNo := NoSMgmt.GetNextNo(NoSeries.Code, CitiInbound.EntryValueDate, true);//TEC.VJ 17012025
                DocumtNo:=NoSMgmt.GetNextNo(NoSeries.Code, CitiInbound.EntryBookedDate, true); //RC 130325
                GenJnlLine.Validate("Document No.", DocumtNo); //TEC.VJ 17012025
                GenJnlLine."External Document No.":=CitiInbound.TxEndtoEndId;
                GenJnlLine.Validate("Source Code", SourceCode);
                if(BankCodeMapping."Account Type" = BankCodeMapping."Account Type"::"G/L Account") AND (BankCodeMapping.PBFundTransfer) AND (StrPos(CitiInbound."Additional Entry Information", 'PBFUNDTRANSFER') <> 0)then begin //#352 TEC.VJ //#354
                    GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.Validate("Account No.", BankAPISetup."API Bank Dummy Account")end
                else
                begin
                    GenJnlLine.Validate("Account Type", BankCodeMapping."Account Type");
                    GenJnlLine.Validate("Account No.", BankCodeMapping."Account No.");
                end;
                GenJnlLine.Description:=CopyStr(CitiInbound."Additional Entry Information", 1, 100); //VJ#50 13dec24
                GenJnlLine."Bank Transaction Code":=BankCodeMapping.Code + ' ' + BankCodeMapping.Description; //VJ#50 13dec24
                GenJnlLine.Validate("Currency Code", CitiInbound.EntryCurrency);
                //#296 TEC.VJ>>
                // if (SourceCode = 'CASHRECJNL') AND (CitiInbound."Additional Entry Information" = 'PBFUNDTRANSFER') then begin
                if(SourceCode = 'CASHRECJNL') AND (StrPos(CitiInbound."Additional Entry Information", 'PBFUNDTRANSFER') <> 0)then begin //#347 TEC.VJ
                    GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                    GenJnlLine.Validate("Bal. Account No.", BankAPISetup."API Bank Dummy Account");
                end
                ELSE
                begin
                    GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
                    GenJnlLine.Validate("Bal. Account No.", BankAcc."No.");
                end;
                //#296 TEC.VJ<<
                //#348 TEC.VJ 11062025>>
                AmtLCY:=0;
                if CitiInbound.TxAmt <> 0 then AmtLCY:=CitiInbound.TxAmt
                else
                    AmtLCY:=CitiInbound.EntryAmount;
                //#348 TEC.VJ 11062025<<
                if CitiInbound.EntryCrDrInd = 'DBIT' then begin
                    GenJnlLine.Validate(Amount, CitiInbound.EntryAmount);
                    if GLSetup."LCY Code" = CitiInbound.Currency then //#348 TEC.VJ 29052025 //Discussed with Conor and let system calculate amount LCY
 GenJnlLine.Validate("Amount (LCY)", AmtLCY);
                end;
                if CitiInbound.EntryCrDrInd = 'CRDT' then begin
                    GenJnlLine.Validate(Amount, -CitiInbound.EntryAmount);
                    if GLSetup."LCY Code" = CitiInbound.Currency then //#348 TEC.VJ 29052025 //Discussed with Conor and let system calculate amount LCY
 GenJnlLine.Validate("Amount (LCY)", -AmtLCY);
                end;
                GenJnlLine."Auto Post":=AutoPost; //VJ15APR2025
                GenJnlLine."Inbound Entry No.":=CitiInbound."Entry No."; //TEC.VG#05NOV2025
                GenJnlLine.Modify();
                FoundMAtch:=true;
                CitiInbound."Error Message":='';
                CitiInbound."Journal Template Name":=TemplateName;
                CitiInbound."Journal Batch Name":=NewBatchName;
                //CitiInbound.Modify();
                Commit();
                // if BankAPISetup."Auto Post" then begin //TEC.VJ 20012025
                if AutoPost then begin //TEC.VJ 20012025
                    GenJnlLine2.Reset();
                    GenJnlLine2.SetRange("Document No.", GenJnlLine."Document No.");
                    if GenJnlLine2.FindSet()then;
                    Clear(GenJnlPostBatch);
                    if not GenJnlPostBatch.Run(GenJnlLine2)then begin
                        CitiInbound."Error Message":=GetLastErrorText();
                        //CitiInbound.Status := CitiInbound.Status::Error;//VJ 17jan2025 //#335 16MAY2025 COMMENTED
                        CitiInbound.Status:=CitiInbound.Status::Created; //TEC.VJ #335 16MAY2025 //Entries are created but not posted.
                        CitiInbound.Processed:=false;
                    end
                    else
                    begin
                        CitiInbound.Processed:=true;
                        // CitiInbound.Status := CitiInbound.Status::Created;//VJ 17jan2025
                        CitiInbound.Status:=CitiInbound.Status::Posted; //VJ 15Apr2025
                    end;
                end
                else
                begin
                    CitiInbound.Processed:=true;
                    CitiInbound.Status:=CitiInbound.Status::Created; //VJ 17jan2025
                end;
            end;
        end;
        CitiInbound."Executed Scenario":='Create ' + SourceCode + ' Scenario2'; //TEC.VJ 17062025
        CitiInbound.Modify();
    end;
    procedure CreateReturnPaymentJnl(var CitiInbound: Record "Citi Inbound Staging"): Boolean //Scenario3
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
        IsError: Boolean;
        VendLedgEntr: Record "Vendor Ledger Entry";
        EmpLedgerEntry: Record "Employee Ledger Entry";
        BankAccLedg: Record "Bank Account Ledger Entry";
        NewBatchName: Code[20];
        BankChargeAmount: Decimal;
        IsEmployee: Boolean;
        IsVendor: Boolean;
        GLSetup: Record "General Ledger Setup";
        Currency: Record Currency;
        CurrencyFactor: Decimal;
        CurrExchRate: Record "Currency Exchange Rate";
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
        BankAPISetup.TestField("Bank Charge Account No."); //VJ 27FEB2025
        LineNo:=0;
        IsError:=false;
        //#190 29012025>>#226 TEC.VJ
        TemplateName:=BankAPISetup."Return Template Name"; //#288 TEC.VJ 25032025
        BatchName:=BankAPISetup."Return Batch Name"; //#288 TEC.VJ 25032025
        //#337 TEC.VJ 20MAY2025>> //To handle if template or batch exist or not.
        if not GenJnlBatch.Get(TemplateName, BatchName)then begin
            IsError:=true;
            CitiInbound."Error Message":=' General Batch not found .Template Name :' + TemplateName + 'Batch Name :' + BatchName;
        end;
        //#337 TEC.VJ 20MAY2025<<
        BankAccLedg.Reset();
        BankAccLedg.SetRange("Bank Document No.", CitiInbound.TxEndtoEndId);
        if not BankAccLedg.FindFirst()then begin
            IsError:=true;
            CitiInbound."Error Message"+=' Bank Ledger not found .Bank Document No. :' + CitiInbound.TxEndtoEndId;
        end;
        if BankAccLedg."Bal. Account Type" = BankAccLedg."Bal. Account Type"::Vendor then begin
            VendLedgEntr.Reset();
            VendLedgEntr.SetRange("Bank Document No.", CitiInbound.TxEndtoEndId);
            if not VendLedgEntr.FindFirst()then begin
                IsError:=true;
                CitiInbound."Error Message"+=' Vendor Ledger not found .Bank Document No. :' + CitiInbound.TxEndtoEndId;
            end
            else
                IsVendor:=true;
            //Start VJ21072025
            if(StopOnError) AND (CitiInbound."Error Message" <> '')then CitiInbound.FieldError("Entry No.", CitiInbound."Error Message");
        //End VJ21072025
        end;
        //VJ27FEB2025
        if BankAccLedg."Bal. Account Type" = BankAccLedg."Bal. Account Type"::Employee then begin
            EmpLedgerEntry.Reset();
            EmpLedgerEntry.SetRange("Bank Document No.", CitiInbound.TxEndtoEndId);
            if not EmpLedgerEntry.FindFirst()then begin
                IsError:=true;
                CitiInbound."Error Message"+=' Employee Ledger not found .Bank Document No. :' + CitiInbound.TxEndtoEndId;
            end
            else
                IsEmployee:=true;
            //Start VJ21072025
            if(StopOnError) AND (CitiInbound."Error Message" <> '')then CitiInbound.FieldError("Entry No.", CitiInbound."Error Message");
        //End VJ21072025
        end;
        //BankChargeAmount := abs(CitiInbound.EntryAmount) - BankAccLedg.Amount;//#322 TEC.VJ 30APR2025
        BankChargeAmount:=ABS(CitiInbound.TxAmt) - ABS(BankAccLedg.Amount); //#322 TEC.VJ 30APR2025 Added Abs for amount mismatch and change entryamount to txamount
        //VJ 27FEB2025
        IF(BankAPISetup."Split Inbound Date Wise") and (TemplateName <> '') and (IsError = false)THEN begin
            CommonFunc.InsertNewBatch(CitiInbound.EntryBookedDate, TemplateName, BatchName, BankAccLedg."Bank Account No.", NewBatchName);
        end
        ELSE
            NewBatchName:=BatchName;
        //#190 29012025<<
        //#333 TEC.VJ 13MAY2025>>
        AutoPost:=false;
        if GLSetup."Auto Post Return Payment Jnl." then AutoPost:=true;
        //#333 TEC.VJ 13MAY2025<<
        PaymentJnl.Reset();
        PaymentJnl.SetRange("Journal Template Name", TemplateName);
        PaymentJnl.SetRange("Journal Batch Name", NewBatchName);
        // PaymentJnl.SetFilter("Bank Document No.", '=%1', CitiInbound.TxEndtoEndId);//25012025
        PaymentJnl.SetFilter("External Document No.", '=%1', CitiInbound.TxEndtoEndId); //TEC.VJ #335 Reference is stored in External Doc No.
        PaymentJnl.SetRange("Source Code", 'PAYMENTJNL');
        PaymentJnl.SetRange("Inbound Entry No.", CitiInbound."Entry No."); //TEC.VG#05NOV2025
        IF not PaymentJnl.FindFirst()then begin
            SourceCode:='PAYMENTJNL';
            GenJnlLine.Reset();
            GenJnlLine.SetRange("Journal Template Name", TemplateName);
            GenJnlLine.SetRange("Journal Batch Name", NewBatchName);
            IF GenJnlLine.Findlast()then LineNo:=GenJnlLine."Line No.";
            if not GenJnlBatch.GET(TemplateName, NewBatchName)then begin
                CitiInbound."Error Message":=' General Batch not found .Template Name :' + TemplateName + 'Batch Name :' + NewBatchName;
                IsError:=true;
                //Start VJ21072025
                if(StopOnError) AND (CitiInbound."Error Message" <> '')then CitiInbound.FieldError("Entry No.", CitiInbound."Error Message");
            //End VJ21072025
            end;
            //TEC.VJ 17012025>>
            IF NOT NoSeries.Get(GenJnlBatch."No. Series")THEN BEGIN
                IsError:=true;
                CitiInbound."Error Message":=' No Series not found . Code :' + GenJnlBatch."No. Series" + ' Template Name :' + TemplateName + ',Batch Name :' + NewBatchName;
                //Start VJ21072025
                if(StopOnError) AND (CitiInbound."Error Message" <> '')then CitiInbound.FieldError("Entry No.", CitiInbound."Error Message");
            //End VJ21072025
            END;
            //TEC.VJ 17012025<<
            if not IsError then begin
                // Insert employee / Vendor Entry
                LineNo:=LineNo + 10000;
                GenJnlLine.Init();
                GenJnlLine.Validate("Journal Template Name", TemplateName);
                GenJnlLine.Validate("Journal Batch Name", NewBatchName);
                GenJnlLine."Line No.":=LineNo;
                GenJnlLine.Insert();
                GenJnlLine.Validate("Posting Date", CitiInbound.EntryBookedDate);
                if IsVendor then GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Refund);
                // GenJnlLine.Validate("Document No.", CitiInbound.TxEndtoEndId);
                DocumtNo:=NoSMgmt.GetNextNo(NoSeries.Code, CitiInbound.EntryBookedDate, true); //TEC.VJ 17012025
                GenJnlLine."External Document No.":=CitiInbound.TxEndtoEndId;
                GenJnlLine."Document No.":=DocumtNo;
                GenJnlLine.Validate("Source Code", SourceCode);
                //GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::Vendor);
                //GenJnlLine.Validate("Account No.", VendLedgEntr."Vendor No.");
                GenJnlLine.Validate("Account Type", BankAccLedg."Bal. Account Type"); //VJ 27FEB2025
                GenJnlLine.Validate("Account No.", BankAccLedg."Bal. Account No."); //VJ 27FEB2025
                GenJnlLine.Validate("Currency Code", CitiInbound.EntryCurrency);
                //GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
                //GenJnlLine.Validate("Bal. Account No.", BankAccLedg."Bank Account No.");
                GenJnlLine.Validate(Amount, -CitiInbound.EntryAmount);
                GenJnlLine."Auto Post":=AutoPost; //VJ15APR2025
                GenJnlLine."Inbound Entry No.":=CitiInbound."Entry No."; //TEC.VG#05NOV2025
                GenJnlLine.Modify();
                // Insert bank charge entry
                IF BankChargeAmount <> 0 THEN BEGIN
                    LineNo:=LineNo + 10000;
                    GenJnlLine.Init();
                    GenJnlLine.Validate("Journal Template Name", TemplateName);
                    GenJnlLine.Validate("Journal Batch Name", NewBatchName);
                    GenJnlLine."Line No.":=LineNo;
                    GenJnlLine.Insert();
                    GenJnlLine.Validate("Posting Date", CitiInbound.EntryBookedDate);
                    if IsVendor then GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Refund);
                    GenJnlLine."Document No.":=DocumtNo;
                    // GenJnlLine.Validate("Document No.", CitiInbound.TxEndtoEndId);
                    //DocumtNo := NoSMgmt.GetNextNo(NoSeries.Code, CitiInbound.EntryBookedDate, true);//TEC.VJ 17012025
                    GenJnlLine."External Document No.":=CitiInbound.TxEndtoEndId;
                    GenJnlLine.Validate("Source Code", SourceCode);
                    GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.Validate("Account No.", BankAPISetup."Bank Charge Account No.");
                    GenJnlLine.Validate("Currency Code", CitiInbound.TxCurrency); //#322 Change Currency to txcurrency
                    //GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
                    //GenJnlLine.Validate("Bal. Account No.", BankAccLedg."Bank Account No.");
                    GenJnlLine.Validate(Amount, BankChargeAmount);
                    //#322 TEC.VJ 02MAY2025>>
                    if(GenJnlLine."Currency Code" <> GLSetup."LCY Code") and (GenJnlLine."Currency Code" <> '')then begin
                        Currency.GET(GenJnlLine."Currency Code");
                        CurrencyFactor:=CurrExchRate.ExchangeRate(GenJnlLine."Posting Date", GenJnlLine."Currency Code");
                        GenJnlLine.Validate("Amount (LCY)", ROUND(CurrExchRate.ExchangeAmtFCYToLCY(GenJnlLine."Posting Date", GenJnlLine."Currency Code", BankChargeAmount, CurrencyFactor), Currency."Amount Rounding Precision"));
                    end;
                    //#322 TEC.VJ 02MAY2025<<
                    GenJnlLine."Auto Post":=AutoPost; //VJ15APR2025
                    GenJnlLine.Modify();
                END;
                // Insert bank Entry
                LineNo:=LineNo + 10000;
                GenJnlLine.Init();
                GenJnlLine.Validate("Journal Template Name", TemplateName);
                GenJnlLine.Validate("Journal Batch Name", NewBatchName);
                GenJnlLine."Line No.":=LineNo;
                GenJnlLine.Insert();
                GenJnlLine.Validate("Posting Date", CitiInbound.EntryBookedDate);
                if IsVendor then GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Refund);
                GenJnlLine."Document No.":=DocumtNo;
                // GenJnlLine.Validate("Document No.", CitiInbound.TxEndtoEndId);
                //DocumtNo := NoSMgmt.GetNextNo(NoSeries.Code, CitiInbound.EntryBookedDate, true);//TEC.VJ 17012025
                GenJnlLine."External Document No.":=CitiInbound.TxEndtoEndId;
                GenJnlLine.Validate("Source Code", SourceCode);
                GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"Bank Account");
                GenJnlLine.Validate("Account No.", BankAccLedg."Bank Account No.");
                GenJnlLine.Validate("Currency Code", CitiInbound.EntryCurrency);
                //GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
                //GenJnlLine.Validate("Bal. Account No.", BankAccLedg."Bank Account No.");
                GenJnlLine.Validate(Amount, ABS(BankAccLedg.Amount));
                GenJnlLine."Auto Post":=AutoPost; //VJ15APR2025
                GenJnlLine.Modify();
                FoundMAtch:=true;
                CitiInbound."Error Message":='';
                CitiInbound."Journal Template Name":=TemplateName;
                CitiInbound."Journal Batch Name":=NewBatchName;
                //CitiInbound.Modify();
                Commit();
                if AutoPost then begin //#252 TEC.VJ
                    GenJnlLine2.Reset();
                    GenJnlLine2.SetRange("Document No.", GenJnlLine."Document No.");
                    if GenJnlLine2.FindSet()then;
                    Clear(GenJnlPostBatch);
                    if not GenJnlPostBatch.Run(GenJnlLine2)then begin
                        CitiInbound."Error Message":=GetLastErrorText();
                        // CitiInbound.Status := CitiInbound.Status::Error;//VJ 17jan2025
                        CitiInbound.Status:=CitiInbound.Status::Created; //vj17jan2025//#335 TEC.VJ CHANGED ERROR TO CREATED 
                        CitiInbound.Processed:=false;
                    end
                    else
                    begin
                        CitiInbound.Processed:=true;
                        CitiInbound.Status:=CitiInbound.Status::Posted; //VJ15APR2025
                    end;
                end
                else
                begin
                    CitiInbound.Processed:=true;
                    CitiInbound.Status:=CitiInbound.Status::Created; //VJ 17jan2025
                end;
            end;
        end;
        CitiInbound."Executed Scenario":='Create Return Payment Scenario3'; //TEC.VJ 17062025
        CitiInbound.Modify();
    end;
    //VJ 17Jan2025 Start
    procedure UpdateDuplicateStatus()
    var
        CitiInbound: Record "Citi Inbound Staging";
        CitiInbound2: Record "Citi Inbound Staging";
    begin
        CitiInbound.Reset();
        CitiInbound.SetRange(Status, CitiInbound.Status::Pending);
        IF CitiInbound.FindSet()THEN repeat CitiInbound2.Reset();
                //DC 17Mar2025 <<
                CitiInbound2.SetRange(TxEndtoEndId, CitiInbound.TxEndtoEndId);
                CitiInbound2.SetRange(EntryBookedDate, CitiInbound.EntryBookedDate); //RC130325
                CitiInbound2.SetRange(EntryAccountServRef, CitiInbound.EntryAccountServRef); //DC 09Mar25
                CitiInbound2.SETRANGE(EntryCrDrInd, CitiInbound.EntryCrDrInd); //DC 09MAR25
                CitiInbound2.SETRANGE(EntryTransCode, CitiInbound.EntryTransCode); //DC 12MAR25
                CitiInbound2.SetRange("Bank Account", CitiInbound."Bank Account"); //NT 20250729
                Citiinbound2.SETFILTER(Status, '=%1|%2', CitiInbound2.Status::Created, CitiInbound2.Status::Posted);
                if CitiInbound2.FindSet()then begin
                    CitiInbound.Status:=CitiInbound.Status::Duplicate; //RC 09Mar2025
                    CitiInbound.Modify(); //RC 09Mar2025
                //CitiInbound2.ModifyAll(Status, CitiInbound2.Status::Duplicate);
                end
                else
                begin
                    //DC 17Mar2025 >>
                    CitiInbound2.Reset();
                    //CitiInbound2.SetRange(Status, CitiInbound2.Status::Pending);//VJ 07MAR2025---
                    //CitiInbound2.Setfilter(Status, '%1|%2', CitiInbound2.Status::Pending, CitiInbound2.Status::Error);//VJ 07MAR2025+++ //DC 09MAR25
                    CitiInbound2.SetRange(TxEndtoEndId, CitiInbound.TxEndtoEndId);
                    //CitiInbound2.SetRange(EntryValueDate, CitiInbound.EntryValueDate); //RC130325
                    CitiInbound2.SetRange(EntryBookedDate, CitiInbound.EntryBookedDate); //RC130325
                    CitiInbound2.SetRange(EntryAccountServRef, CitiInbound.EntryAccountServRef); //DC 09Mar25
                    CitiInbound2.SetFilter("Entry No.", '<%1', CitiInbound."Entry No."); //DC 09Mar2025
                    CitiInbound2.SETRANGE(EntryCrDrInd, CitiInbound.EntryCrDrInd); //DC 09MAR25
                    CitiInbound2.SETRANGE(EntryTransCode, CitiInbound.EntryTransCode); //DC 12MAR25
                    if CitiInbound2.FindSet()then begin
                        CitiInbound.Status:=CitiInbound.Status::Duplicate; //RC 09Mar2025
                        CitiInbound.Modify(); //RC 09Mar2025
                    //CitiInbound2.ModifyAll(Status, CitiInbound2.Status::Duplicate);
                    end;
                end;
            until CitiInbound.Next() = 0;
    end;
    //VJ 17Jan2025 End
    //VJ 17Jan2025 Start
    procedure UpdateCancelStatus(CitiInbound_p: Record "Citi Inbound Staging")
    var
        CitiInbound: Record "Citi Inbound Staging";
    begin
        CitiInbound.Copy(CitiInbound_p);
        CitiInbound.Setfilter(Status, '%1|%2', CitiInbound.Status::Pending, CitiInbound.Status::Error);
        IF CitiInbound.FindSet()THEN CitiInbound.ModifyAll(Status, CitiInbound.Status::Cancelled);
    end;
    //VJ 17Jan2025 End
    //#189 TEC.VJ 25012025>>
    procedure CreatePaymentJnl(var CitiInbound: Record "Citi Inbound Staging") //scenario4
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
        IsError: Boolean;
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
        BankCodeMapping.SetRange(Code, CitiInbound.EntryTransCode);
        BankCodeMapping.SetRange("DBIT / CRDT", CitiInbound.EntryCrDrInd);
        if not BankCodeMapping.FindFirst()then begin
            IsError:=true;
            CitiInbound."Error Message":='Bank Code mapping not found. Bank Code :' + CitiInbound.EntryTransCode;
        end;
        IF BankCodeMapping."Account Type" = BankCodeMapping."Account Type"::Vendor THEN begin
            TemplateName:=BankAPISetup."TRP Payment Jnl. Template Name";
            BatchName:=BankAPISetup."TRP Payment Jnl. Batch Name";
            //#337 TEC.VJ 20MAY2025>> //To handle if template or batch exist or not.
            if not GenJnlBatch.Get(TemplateName, BatchName)then begin
                IsError:=true;
                CitiInbound."Error Message":=' General Batch not found .Template Name :' + TemplateName + 'Batch Name :' + BatchName;
                //Start VJ21072025
                if(StopOnError) AND (CitiInbound."Error Message" <> '')then CitiInbound.FieldError("Entry No.", CitiInbound."Error Message");
            //End VJ21072025
            end;
            //#337 TEC.VJ 20MAY2025<<
            SourceCode:='PAYMENTJNL';
            if GLSetup."Auto Post Payment Jnl." then //#252 TEC.VJ
 AutoPost:=true;
            BankAcc.Reset();
            BankAcc.SetRange("Bank Account No.", CitiInbound."Bank Account");
            if not BankAcc.FindFirst()then begin
                IsError:=true;
                CitiInbound."Error Message":=' Bank Account not found .Bank Account :' + CitiInbound."Bank Account";
                //Start VJ21072025
                if(StopOnError) AND (CitiInbound."Error Message" <> '')then CitiInbound.FieldError("Entry No.", CitiInbound."Error Message");
            //End VJ21072025
            end;
            //#190 29012025>>#226 TEC.VJ
            IF(BankAPISetup."Split Inbound Date Wise") and (TemplateName <> '') and (IsError = false)THEN begin
                CommonFunc.InsertNewBatch(CitiInbound.EntryBookedDate, TemplateName, BatchName, BankAcc."No.", NewBatchName);
            end
            ELSE
                NewBatchName:=BatchName;
            //#190 29012025<<
            PaymentJnl.Reset();
            PaymentJnl.SetRange("Journal Template Name", TemplateName);
            PaymentJnl.SetRange("Journal Batch Name", NewBatchName);
            PaymentJnl.SetRange("Source Code", SourceCode);
            // PaymentJnl.SetFilter("Bank Document No.", '=%1', CitiInbound.TxEndtoEndId);//TEC.VJ #335
            PaymentJnl.SetFilter("External Document No.", '=%1', CitiInbound.TxEndtoEndId); //TEC.VJ #335 Reference is stored in External Doc No.
            PaymentJnl.SetRange("Inbound Entry No.", CitiInbound."Entry No."); //TEC.VG#05NOV2025
            IF not PaymentJnl.FindFirst()then begin
                GenJnlLine.Reset();
                GenJnlLine.SetRange("Journal Template Name", TemplateName);
                GenJnlLine.SetRange("Journal Batch Name", NewBatchName);
                IF GenJnlLine.Findlast()then LineNo:=GenJnlLine."Line No.";
                if not GenJnlBatch.GET(TemplateName, NewBatchName)then begin
                    IsError:=true;
                    CitiInbound."Error Message":=' General Batch not found .Template Name :' + TemplateName + 'Batch Name :' + NewBatchName;
                    //Start VJ21072025
                    if(StopOnError) AND (CitiInbound."Error Message" <> '')then CitiInbound.FieldError("Entry No.", CitiInbound."Error Message");
                //End VJ21072025
                end;
                IF NOT NoSeries.Get(GenJnlBatch."No. Series")THEN BEGIN
                    IsError:=true;
                    CitiInbound."Error Message":=' No Series not found . Code :' + GenJnlBatch."No. Series" + ' Template Name :' + TemplateName + ',Batch Name :' + NewBatchName;
                    //Start VJ21072025
                    if(StopOnError) AND (CitiInbound."Error Message" <> '')then CitiInbound.FieldError("Entry No.", CitiInbound."Error Message");
                //End VJ21072025
                END;
                if not IsError then begin
                    GenJnlLine.Init();
                    GenJnlLine.Validate("Journal Template Name", TemplateName);
                    GenJnlLine.Validate("Journal Batch Name", NewBatchName);
                    GenJnlLine."Line No.":=LineNo + 10000;
                    GenJnlLine.Insert(true);
                    GenJnlLine.Validate("Posting Date", CitiInbound.EntryBookedDate);
                    GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment);
                    DocumtNo:=NoSMgmt.GetNextNo(NoSeries.Code, CitiInbound.EntryBookedDate, true);
                    GenJnlLine.Validate("Document No.", DocumtNo);
                    GenJnlLine."External Document No.":=CitiInbound.TxEndtoEndId;
                    GenJnlLine.Validate("Source Code", SourceCode); //TEC.VJ 26FEB2025
                    GenJnlLine.Validate("Account Type", BankCodeMapping."Account Type");
                    GenJnlLine.Validate("Account No.", BankCodeMapping."Account No.");
                    GenJnlLine.Description:=CopyStr(CitiInbound."Additional Entry Information", 1, 100);
                    GenJnlLine."Bank Transaction Code":=BankCodeMapping.Code + ' ' + BankCodeMapping.Description;
                    // GenJnlLine.Validate("Recipient Bank Account",'');//
                    // GenJnlLine.Validate("Employee Bank Account",'');//
                    GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
                    GenJnlLine.Validate("Bal. Account No.", BankAcc."No.");
                    //#212 TEC.VJ 11022025>>
                    if CitiInbound.TxAmt <> 0 then begin
                        //GenJnlLine.Validate("Currency Code", CitiInbound.TxCurrency);
                        GenJnlLine.Validate("Currency Code", CitiInbound.EntryCurrency);
                        AmtLCY:=CitiInbound.TxAmt;
                        if CitiInbound.EntryAmount <> 0 then LineAmt:=CitiInbound.EntryAmount
                        else
                            LineAmt:=CitiInbound.TxAmt;
                    end
                    else if CitiInbound.EntryAmount <> 0 then begin
                            GenJnlLine.Validate("Currency Code", CitiInbound.EntryCurrency);
                            LineAmt:=CitiInbound.EntryAmount;
                            if CitiInbound.TxAmt <> 0 then AmtLCY:=CitiInbound.TxAmt
                            else
                                AmtLCY:=CitiInbound.EntryAmount;
                        end;
                    if CitiInbound.EntryCrDrInd = 'DBIT' then begin
                        GenJnlLine.Validate(Amount, LineAmt);
                        if GLSetup."LCY Code" = CitiInbound.Currency then //#322 TEC.VJ 29052025 //Discussed with Conor and let system calculate amount LCY  
 GenJnlLine.Validate("Amount (LCY)", AmtLCY);
                    end;
                    if CitiInbound.EntryCrDrInd = 'CRDT' then begin
                        GenJnlLine.Validate(Amount, -LineAmt);
                        if GLSetup."LCY Code" = CitiInbound.Currency then //#322 TEC.VJ 29052025 //Discussed with Conor and let system calculate amount LCY  
 GenJnlLine.Validate("Amount (LCY)", -AmtLCY);
                    end;
                    //#212 TEC.VJ 11022025<<
                    GenJnlLine."Additional Entry Information":=CitiInbound."Additional Entry Information";
                    GenJnlLine."Creditor Name":=CitiInbound."Creditor Name";
                    GenJnlLine."Bypass API":=true;
                    GenJnlLine."Charges Bearer":=GenJnlLine."Charges Bearer"::OUR; //VJ 11FEB2025
                    GenJnlLine.Validate("Payment Method Code", ''); //VJ #222 14Feb2025
                    GenJnlLine."Auto Post":=AutoPost; //VJ15APR2025
                    GenJnlLine."Inbound Entry No.":=CitiInbound."Entry No."; //TEC.VG#05NOV2025
                    GenJnlLine.Modify();
                    FoundMAtch:=true;
                    CitiInbound."Error Message":='';
                    CitiInbound."Journal Template Name":=TemplateName;
                    CitiInbound."Journal Batch Name":=NewBatchName;
                    //CitiInbound.Modify();
                    Commit();
                    if(AutoPost)then begin
                        GenJnlLine2.Reset();
                        GenJnlLine2.SetRange("Document No.", GenJnlLine."Document No.");
                        if GenJnlLine2.FindSet()then;
                        Clear(GenJnlPostBatch);
                        if not GenJnlPostBatch.Run(GenJnlLine2)then begin
                            CitiInbound."Error Message":=GetLastErrorText();
                            // CitiInbound.Status := CitiInbound.Status::Error;
                            CitiInbound.Status:=CitiInbound.Status::Created; //TEC.VJ #335 16MAY2025 //Entries will created but not posted.
                            CitiInbound.Processed:=false;
                        end
                        else
                        begin
                            CitiInbound.Processed:=true;
                            // CitiInbound.Status := CitiInbound.Status::Created;
                            CitiInbound.Status:=CitiInbound.Status::Posted; //VJ15APR2025
                        end;
                    end
                    else
                    begin
                        CitiInbound.Processed:=true;
                        CitiInbound.Status:=CitiInbound.Status::Created;
                    end;
                end
                else
                    CitiInbound.Status:=CitiInbound.Status::Error;
            end;
        end;
        if IsError then CitiInbound.Status:=CitiInbound.Status::Error;
        CitiInbound."Executed Scenario":='Create Payment Jnl Scenario4'; //TEC.VJ 17062025
        CitiInbound.Modify();
    end;
    //#189 TEC.VJ 25012025<<
    local procedure TempBatchInsert(var CitiOutboundStag: Record "Citi Outbound Staging Table")
    begin
        TempGenJnlBatch.Init();
        TempGenJnlBatch."Journal Template Name":=CitiOutboundStag."Journal Template Name";
        TempGenJnlBatch.Name:=CitiOutboundStag."Journal Batch Name";
        if StopOnError then TempGenJnlBatch.Insert()
        else if TempGenJnlBatch.Insert()then;
    end;
    //28012025
    procedure UpdateGenJnlBatchFields()
    var
        CommonFunc: Codeunit "Common Functions";
    begin
        TempGenJnlBatch.Reset();
        if TempGenJnlBatch.FindSet()then repeat CommonFunc.UpdateGenjnlBatchFieldsForHSBC_Citi(TempGenJnlBatch."Journal Template Name", TempGenJnlBatch.Name);
            until TempGenJnlBatch.Next() = 0;
    end;
    //28012025
    //start VJ21072025 
    procedure SetEntryNoFromCitiInboundStaging(P_CitiInbEntryNo: Integer)
    begin
        Clear(g_CitiInbEntryNo);
        g_CitiInbEntryNo:=P_CitiInbEntryNo;
    end;
    //End VJ21072025
    var GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
    TempGenJnlBatch: Record "Gen. Journal Batch" temporary;
    NoSMgmt: Codeunit "No. Series";
    DocumtNo: Code[20];
    NoSeries: Record "No. Series";
    BankAPISetup: Record "Bank API Setup";
    CommonFunc: Codeunit "Common Functions";
    FoundMAtch: Boolean;
    g_CitiInbEntryNo: Integer; //VJ21072025
    StopOnError: Boolean; //VJ21072025
}
