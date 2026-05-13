codeunit 50169 "DNV Committed Cost"
{
    trigger OnRun()
    var
        VMT: record VMT;
        DNVCommitedCost: record "PB Committed Cost Inbound";
        DNVSetup: record "DNV Integration Setup";
        CompanyMapping: record "Company Name Mapping";
        CUDNVCommitedCostPost: Codeunit 50121;
    begin
        DNVCommitedCost.Reset();
        DNVCommitedCost.SetFilter("Posting Date", '=%1', 0D);
        if DNVCommitedCost.FindSet()then repeat DNVCommitedCost."Posting Date":=DT2Date(DNVCommitedCost.SystemCreatedAt);
                DNVCommitedCost."Posting Date":=CalcDate('<-1M><+CM>', DNVCommitedCost."Posting Date");
                DNVCommitedCost.Modify();
            until DNVCommitedCost.Next() = 0;
        Commit();
        DNVSetup.Get();
        DNVCommitedCost.Reset();
        DNVCommitedCost.SetFilter(Status, '<>%1|%2', DNVCommitedCost.Status::Processed, DNVCommitedCost.Status::Cancel);
        if DNVCommitedCost.FindSet()then repeat if DNVCommitedCost."Company Name" = '' then begin
                    VMT.Reset();
                    vmt.SetFilter(SHIPSIGN, DNVCommitedCost."Asset ID");
                    if VMT.FindSet()then begin
                        CompanyMapping.Reset();
                        CompanyMapping.SetRange("PB Company Code", VMT.DBASE);
                        if CompanyMapping.FindSet()then DNVCommitedCost."Company Name":=CompanyMapping."BC Company Name"
                        else
                        begin
                            DNVCommitedCost.Status:=DNVCommitedCost.Status::Error;
                            DNVCommitedCost."Error Description":='Company mapping not found.';
                        end;
                    end
                    else
                    begin
                        DNVCommitedCost.Status:=DNVCommitedCost.Status::Error;
                        DNVCommitedCost."Error Description":='VMT mapping not found.';
                    end;
                    DNVCommitedCost.Modify();
                end;
                if not DNVCommitedCost."Dont Recalculate" then GetCostDetails(DNVCommitedCost."Entry No.");
            until DNVCommitedCost.Next() = 0;
        Commit();
        // Company Posting
        DNVCommitedCost.Reset();
        DNVCommitedCost.SetFilter(Status, '<>%1|%2', DNVCommitedCost.Status::Processed, DNVCommitedCost.Status::Cancel);
        DNVCommitedCost.SetRange("Company Name", CompanyName);
        if DNVCommitedCost.FindSet()then repeat Commit();
                clear(CUDNVCommitedCostPost);
                if CUDNVCommitedCostPost.run(DNVCommitedCost)then begin
                    DNVCommitedCost.Status:=DNVCommitedCost.Status::Processed;
                    DNVCommitedCost."Error Description":='';
                end
                else
                begin
                    DNVCommitedCost.Status:=DNVCommitedCost.Status::Error;
                    DNVCommitedCost."Error Description":=GetLastErrorText();
                end;
                DNVCommitedCost.Modify();
            until DNVCommitedCost.Next() = 0;
    end;
    procedure GetCostDetails(mEntryNo: Integer)
    var
        DNVCommittedCostDetails: record "DNV Commited Cost Details";
        TotalReceiptAmount: Decimal;
        TotalInvocieAmount: Decimal;
        TotalPOAmount: Decimal;
        PbCommitedCostInvocie: record "PB Committed Cost Invoice";
        PBCommittedCostInvLine: record "PB DNV Committed Cost Line";
    begin
        DNVCommittedCostDetails.Reset();
        DNVCommittedCostDetails.SetRange("Entry No.", mEntryNo);
        if DNVCommittedCostDetails.FindSet()then DNVCommittedCostDetails.DeleteAll();
        ;
        TotalInvocieAmount:=0;
        TotalPOAmount:=0;
        TotalReceiptAmount:=0;
        PBCommittedCostInvLine.Reset();
        PBCommittedCostInvLine.SetRange("Entry No", mEntryNo);
        if PBCommittedCostInvLine.FindSet()then repeat TotalPOAmount:=0;
                TotalReceiptAmount:=0;
                TotalPOAmount:=PBCommittedCostInvLine."Total Line Net Amount";
                if(PBCommittedCostInvLine."Quantity Received Shipped" <> 0) or (PBCommittedCostInvLine."Quantity Received Warehouse" <> 0)then begin
                    if PBCommittedCostInvLine."Quantity Received Shipped" > PBCommittedCostInvLine."Quantity Received Warehouse" then TotalReceiptAmount:=(PBCommittedCostInvLine."Quantity Received Shipped" * PBCommittedCostInvLine."Single Price")
                    else
                        TotalReceiptAmount:=PBCommittedCostInvLine."Quantity Received Warehouse" * PBCommittedCostInvLine."Single Price";
                    if PBCommittedCostInvLine."Line Discount Pct" <> 0 then TotalReceiptAmount:=TotalReceiptAmount - (TotalReceiptAmount * PBCommittedCostInvLine."Line Discount Pct" / 100);
                    if PBCommittedCostInvLine."Order Head Discount" <> 0 then TotalReceiptAmount:=TotalReceiptAmount - (TotalReceiptAmount * PBCommittedCostInvLine."Order Head Discount" / 100)end;
                DNVCommittedCostDetails.Reset();
                DNVCommittedCostDetails.SetRange("Entry No.", mEntryNo);
                DNVCommittedCostDetails.SetRange("Account Code", PBCommittedCostInvLine."Account code");
                if DNVCommittedCostDetails.FindSet()then begin
                    DNVCommittedCostDetails."Order Amount":=DNVCommittedCostDetails."Order Amount" + TotalPOAmount;
                    DNVCommittedCostDetails."Received Amount":=DNVCommittedCostDetails."Received Amount" + TotalReceiptAmount;
                    if DNVCommittedCostDetails."Received Amount" <= DNVCommittedCostDetails."Order Amount" then DNVCommittedCostDetails."Accrual Amount":=DNVCommittedCostDetails."Received Amount" - DNVCommittedCostDetails."Invoiced Amount"
                    else
                        DNVCommittedCostDetails."Accrual Amount":=DNVCommittedCostDetails."Order Amount" - DNVCommittedCostDetails."Invoiced Amount";
                    if DNVCommittedCostDetails."Accrual Amount" < 0 then DNVCommittedCostDetails."Accrual Amount":=0;
                    DNVCommittedCostDetails."Currency Code":=PBCommittedCostInvLine."Currency Code";
                    DNVCommittedCostDetails.Modify();
                end
                else
                begin
                    DNVCommittedCostDetails.Reset();
                    DNVCommittedCostDetails.Init();
                    DNVCommittedCostDetails."Entry No.":=mEntryNo;
                    DNVCommittedCostDetails."Account Code":=PBCommittedCostInvLine."Account code";
                    DNVCommittedCostDetails."Order Amount":=DNVCommittedCostDetails."Order Amount" + TotalPOAmount;
                    DNVCommittedCostDetails."Received Amount":=DNVCommittedCostDetails."Received Amount" + TotalReceiptAmount;
                    if DNVCommittedCostDetails."Received Amount" <= DNVCommittedCostDetails."Order Amount" then DNVCommittedCostDetails."Accrual Amount":=DNVCommittedCostDetails."Received Amount" - DNVCommittedCostDetails."Invoiced Amount"
                    else
                        DNVCommittedCostDetails."Accrual Amount":=DNVCommittedCostDetails."Order Amount" - DNVCommittedCostDetails."Invoiced Amount";
                    if DNVCommittedCostDetails."Accrual Amount" < 0 then DNVCommittedCostDetails."Accrual Amount":=0;
                    DNVCommittedCostDetails."Currency Code":=PBCommittedCostInvLine."Currency Code";
                    DNVCommittedCostDetails.Insert();
                end;
            until PBCommittedCostInvLine.Next() = 0;
        // Invoice
        PbCommitedCostInvocie.Reset();
        PbCommitedCostInvocie.SetRange("Entry No", mEntryNo);
        if PbCommitedCostInvocie.FindSet()then repeat DNVCommittedCostDetails.Reset();
                DNVCommittedCostDetails.SetRange("Entry No.", mEntryNo);
                DNVCommittedCostDetails.SetRange("Account Code", PBCommittedCostInvLine."Account code");
                DNVCommittedCostDetails.FindSet();
                DNVCommittedCostDetails."Invoiced Amount":=DNVCommittedCostDetails."Invoiced Amount" + PbCommitedCostInvocie."Invoiced Amount";
                if DNVCommittedCostDetails."Received Amount" <= DNVCommittedCostDetails."Order Amount" then DNVCommittedCostDetails."Accrual Amount":=DNVCommittedCostDetails."Received Amount" - DNVCommittedCostDetails."Invoiced Amount"
                else
                    DNVCommittedCostDetails."Accrual Amount":=DNVCommittedCostDetails."Order Amount" - DNVCommittedCostDetails."Invoiced Amount";
                if DNVCommittedCostDetails."Accrual Amount" < 0 then DNVCommittedCostDetails."Accrual Amount":=0;
                DNVCommittedCostDetails.Modify();
            until PbCommitedCostInvocie.Next() = 0 end;
}
