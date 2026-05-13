codeunit 50112 "PaymentJournalPageEvents "
{
    Permissions = tabledata "Employee Ledger Entry"=RM,
        tabledata "Vendor Ledger Entry"=rm,
        tabledata "Cust. Ledger Entry"=rm,
        tabledata "Global Vendor Ledger Entry"=rm,
        tabledata "Global Employee Ledger Entry"=rm,
        tabledata "Global Cust. Ledger entry"=rm;

    [EventSubscriber(ObjectType::Page, Page::"Payment Journal", 'OnBeforeActionEvent', SendApprovalRequestJournalLine, false, false)]
    local procedure OnBeforeActionEventSendApprovalRequestJournalLine(var Rec: Record "Gen. Journal Line")
    var
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
    begin
        GenJnlPost.Preview(Rec);
    end;
    // [EventSubscriber(ObjectType::Page, Page::"Payment Journal", 'OnBeforeActionEvent', 'SendApprovalRequestJournalBatch', false, false)]
    [EventSubscriber(ObjectType::Page, Page::"Payment Journal", 'OnBeforeActionEvent', SendForReview, false, false)] //TEC.VJ
    local procedure OnBeforeActionEventSendApprovalRequestJournalBatch(var Rec: Record "Gen. Journal Line")
    var
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
    begin
    // GenJnlPost.Preview(Rec);
    end;
    // [EventSubscriber(ObjectType::Page, Page::"Payment Journal", OnDeleteRecordEvent, '', false, false)]
    // local procedure OnDeleteRecordEvent(var Rec: Record "Gen. Journal Line"; var AllowDelete: Boolean)
    // var
    //     VLEOtherComp: Record "Vendor Ledger Entry";
    //     VLEOtherComp_2: Record "Vendor Ledger Entry";       
    // begin
    //     If not AllowDelete then
    //         exit;
    //     If (not (Rec."Company Code" = '')) and (NOT (Rec."Company Code" = CompanyName)) then begin
    //         VLEOtherComp.ChangeCompany(Rec."Company Code");
    //         VLEOtherComp.SetCurrentKey("Document No.");
    //         VLEOtherComp.SetRange("Applies-to ID", Rec."Document No.");
    //         VLEOtherComp.SetRange(Open, true);
    //         IF Rec."Account Type" = Rec."Account Type"::Vendor then
    //             VLEOtherComp.SetRange("Vendor No.", Rec."Account No.");
    //         If VLEOtherComp.FindSet() then
    //             repeat
    //                 VLEOtherComp_2.ChangeCompany(Rec."Company Code");
    //                 VLEOtherComp_2 := VLEOtherComp;
    //                 VLEOtherComp_2."Applies-to ID" := '';
    //                 VLEOtherComp_2."Accepted Pmt. Disc. Tolerance" := false;
    //                 VLEOtherComp_2."Accepted Payment Tolerance" := 0;
    //                 VLEOtherComp_2."Amount to Apply" := 0;
    //                 // VLEOtherComp_2."On Hold" := false;
    //                 VLEOtherComp_2.Modify();
    //                 VLEOtherComp := VLEOtherComp_2;
    //             until VLEOtherComp.Next() = 0;
    //     end;
    // end;
    [EventSubscriber(ObjectType::Page, Page::"Payment Journal", OnDeleteRecordEvent, '', false, false)]
    local procedure OnDeleteRecordEvent(var Rec: Record "Gen. Journal Line"; var AllowDelete: Boolean)
    var
        GVLE: Record "Global Vendor Ledger Entry";
        GVLE2: Record "Global Vendor Ledger Entry";
        GELE: Record "Global Employee Ledger Entry";
        GELE2: Record "Global Employee Ledger Entry";
        GCLE: Record "Global Cust. Ledger Entry";
        GCLE2: Record "Global Cust. Ledger Entry";
        VLE: Record "Vendor Ledger Entry";
        VLE2: Record "Vendor Ledger Entry";
        ELE: Record "Employee Ledger Entry";
        ELE2: Record "Employee Ledger Entry";
        CLE: Record "Cust. Ledger Entry";
        CLE2: Record "Cust. Ledger Entry";
    begin
        If not AllowDelete then exit;
        IF Rec."Account Type" = Rec."Account Type"::Vendor then begin
            GVLE.SetCurrentKey("Document No.");
            // GVLE.SetRange("Company Name", rec."Company Code");
            GVLE.SetRange("Applies-to ID", Rec."Document No.");
            GVLE.SetRange("Bank Document No. Applied", Rec."Bank Document No."); //VJ 13FEB2025
            GVLE.SetRange(Open, true);
            GVLE.SetRange("Vendor No.", Rec."Account No.");
            If GVLE.FindSet()then repeat GVLE2:=GVLE;
                    GVLE2."Applies-to ID":='';
                    GVLE2."Accepted Pmt. Disc. Tolerance":=false;
                    GVLE2."Accepted Payment Tolerance":=0;
                    GVLE2."Amount to Apply":=0;
                    GVLE2."Bank Document No. Applied":=''; //NT_ 11-02-2025 
                    GVLE2.Modify();
                until GVLE.Next() = 0;
        end
        else IF Rec."Account Type" = Rec."Account Type"::Employee then begin
                GELE.SetCurrentKey("Document No.");
                // GELE.SetRange("Company Code", rec."Company Code");
                GELE.SetRange("Applies-to ID", Rec."Document No.");
                GELE.SetRange("Bank Document No. Applied", Rec."Bank Document No."); //VJ 13FEB2025
                GELE.SetRange(Open, true);
                GELE.SetRange("Employee No.", Rec."Account No.");
                If GELE.FindSet()then repeat GELE2:=GELE;
                        GELE2."Applies-to ID":='';
                        GELE2."Amount to Apply":=0;
                        GELE2."Bank Document No. Applied":=''; //NT_ 11-02-2025 
                        GELE2.Modify();
                    until GELE.Next() = 0;
            end
            else //TEC.VJ 06MAR2025>>
                IF Rec."Account Type" = Rec."Account Type"::Customer then begin
                    GCLE.SetCurrentKey("Document No.");
                    GCLE.SetRange("Applies-to ID", Rec."Document No.");
                    GCLE.SetRange("Bank Document No. Applied", Rec."Bank Document No.");
                    GCLE.SetRange(Open, true);
                    GCLE.SetRange("Customer No.", Rec."Account No.");
                    If GCLE.FindSet()then repeat GCLE2:=GCLE;
                            GCLE2."Applies-to ID":='';
                            GCLE2."Accepted Pmt. Disc. Tolerance":=false;
                            GCLE2."Accepted Payment Tolerance":=0;
                            GCLE2."Amount to Apply":=0;
                            GCLE2."Bank Document No. Applied":='';
                            GCLE2.Modify();
                        until GCLE.Next() = 0;
                END;
        //TEC.VJ 06MAR2025<<
        //NT_ 11-02-2025 >>
        if Rec."Account Type" = Rec."Account Type"::Vendor then begin
            VLE.Reset();
            VLE.SetRange("Applies-to ID", Rec."Document No.");
            VLE.SetRange("Bank Document No. Applied", Rec."Bank Document No."); //VJ 13FEB2025
            VLE.SetRange(Open, true);
            if VLE.FindFirst()then repeat VLE2:=VLE;
                    VLE2."Applies-to ID":='';
                    VLE2."Bank Document No. Applied":='';
                    VLE2.Modify();
                until VLE.Next() = 0;
        end
        else if Rec."Account Type" = Rec."Account Type"::Employee then begin
                ELE.Reset();
                ELE.SetRange("Applies-to ID", Rec."Document No.");
                ELE.SetRange("Bank Document No. Applied", Rec."Bank Document No."); //VJ 13FEB2025
                ELE.SetRange(Open, true);
                if ELE.FindFirst()then repeat ELE2:=ELE;
                        ELE2."Applies-to ID":='';
                        ELE2."Bank Document No. Applied":='';
                        ELE2.Modify();
                    until ELE.Next() = 0;
            end
            else //TEC.VJ 06MAR2025>>
 if Rec."Account Type" = Rec."Account Type"::Customer then begin
                    CLE.Reset();
                    CLE.SetRange("Applies-to ID", Rec."Document No.");
                    CLE.SetRange("Bank Document No. Applied", Rec."Bank Document No."); //VJ 13FEB2025
                    CLE.SetRange(Open, true);
                    if CLE.FindFirst()then repeat CLE2:=CLE;
                            CLE2."Applies-to ID":='';
                            CLE2."Bank Document No. Applied":='';
                            CLE2.Modify();
                        until CLE.Next() = 0;
                end;
    //TEC.VJ 06MAR2025<<
    //NT_ 11-02-2025 <<
    end;
    [EventSubscriber(ObjectType::Page, Page::"Payment Journal", OnBeforeSuggestVendorPaymentsAction, '', false, false)]
    local procedure OnBeforeSuggestVendorPaymentsAction(sender: Page "Payment Journal"; var GenJournalLine: Record "Gen. Journal Line"; var IsHanlded: Boolean)
    var
        SuggestVendorPayments: Report "Suggest Vendor Payments Dim";
    begin
    // Message('hi');
    // Clear(SuggestVendorPayments);
    // SuggestVendorPayments.SetGenJnlLine(GenJournalLine);
    // SuggestVendorPayments.RunModal();
    // IsHanlded := true;
    end;
    [EventSubscriber(ObjectType::Table, database::"Gen. Journal Line", OnBeforeRenameEvent, '', false, false)]
    local procedure OnBeforeRenameEvent(var Rec: Record "Gen. Journal Line"; RunTrigger: Boolean)
    var
        GVLE: Record "Global Vendor Ledger Entry";
        GVLE2: Record "Global Vendor Ledger Entry";
        GELE: Record "Global Employee Ledger Entry";
        GELE2: Record "Global Employee Ledger Entry";
        GCLE: Record "Global Cust. Ledger Entry";
        GCLE2: Record "Global Cust. Ledger Entry";
        VLE: Record "Vendor Ledger Entry";
        VLE2: Record "Vendor Ledger Entry";
        ELE: Record "Employee Ledger Entry";
        ELE2: Record "Employee Ledger Entry";
        CLE: Record "Cust. Ledger Entry";
        CLE2: Record "Cust. Ledger Entry";
    begin
        If not RunTrigger then exit;
        exit;
        IF Rec."Account Type" = Rec."Account Type"::Vendor then begin
            GVLE.SetCurrentKey("Document No.");
            // GVLE.SetRange("Company Name", rec."Company Code");
            GVLE.SetRange("Applies-to ID", Rec."Document No.");
            GVLE.SetRange("Bank Document No. Applied", Rec."Bank Document No."); //VJ 13FEB2025
            GVLE.SetRange(Open, true);
            GVLE.SetRange("Vendor No.", Rec."Account No.");
            If GVLE.FindSet()then repeat GVLE2:=GVLE;
                    GVLE2."Applies-to ID":='';
                    GVLE2."Accepted Pmt. Disc. Tolerance":=false;
                    GVLE2."Accepted Payment Tolerance":=0;
                    GVLE2."Amount to Apply":=0;
                    GVLE2."Bank Document No. Applied":=''; //NT_ 11-02-2025 
                    GVLE2.Modify();
                until GVLE.Next() = 0;
        end
        else IF Rec."Account Type" = Rec."Account Type"::Employee then begin
                GELE.SetCurrentKey("Document No.");
                // GELE.SetRange("Company Code", rec."Company Code");
                GELE.SetRange("Applies-to ID", Rec."Document No.");
                GELE.SetRange("Bank Document No. Applied", Rec."Bank Document No."); //VJ 13FEB2025
                GELE.SetRange(Open, true);
                GELE.SetRange("Employee No.", Rec."Account No.");
                If GELE.FindSet()then repeat GELE2:=GELE;
                        GELE2."Applies-to ID":='';
                        GELE2."Amount to Apply":=0;
                        GELE2."Bank Document No. Applied":=''; //NT_ 11-02-2025 
                        GELE2.Modify();
                    until GELE.Next() = 0;
            end //TEC.VJ 06MAR2025>>
            else IF Rec."Account Type" = Rec."Account Type"::Customer then begin
                    GCLE.SetCurrentKey("Document No.");
                    // GCLE.SetRange("Company Code", rec."Company Code");
                    GCLE.SetRange("Applies-to ID", Rec."Document No.");
                    GCLE.SetRange("Bank Document No. Applied", Rec."Bank Document No."); //VJ 13FEB2025
                    GCLE.SetRange(Open, true);
                    GCLE.SetRange("Customer No.", Rec."Account No.");
                    If GCLE.FindSet()then repeat GCLE2:=GCLE;
                            GCLE2."Applies-to ID":='';
                            GCLE2."Amount to Apply":=0;
                            GCLE2."Bank Document No. Applied":=''; //NT_ 11-02-2025 
                            GCLE2.Modify();
                        until GELE.Next() = 0;
                end;
        //NT_ 11-02-2025 >>
        if Rec."Account Type" = Rec."Account Type"::Vendor then begin
            VLE.Reset();
            VLE.SetRange("Applies-to ID", Rec."Document No.");
            VLE.SetRange("Bank Document No. Applied", Rec."Bank Document No."); //VJ 13FEB2025
            VLE.SetRange(Open, true);
            if VLE.FindFirst()then repeat VLE2:=VLE;
                    VLE2."Applies-to ID":='';
                    VLE2."Bank Document No. Applied":='';
                    VLE2.Modify();
                until VLE.Next() = 0;
        end
        else if Rec."Account Type" = Rec."Account Type"::Employee then begin
                ELE.Reset();
                ELE.SetRange("Applies-to ID", Rec."Document No.");
                ELE.SetRange("Bank Document No. Applied", Rec."Bank Document No."); //VJ 13FEB2025
                ELE.SetRange(Open, true);
                if ELE.FindFirst()then repeat ELE2:=ELE;
                        ELE2."Applies-to ID":='';
                        ELE2."Bank Document No. Applied":='';
                        ELE2.Modify();
                    until ELE.Next() = 0;
            end
            else //TEC.VJ 06MAR2025>>
                if Rec."Account Type" = Rec."Account Type"::Customer then begin
                    CLE.Reset();
                    CLE.SetRange("Applies-to ID", Rec."Document No.");
                    CLE.SetRange("Bank Document No. Applied", Rec."Bank Document No.");
                    CLE.SetRange(Open, true);
                    if CLE.FindFirst()then repeat CLE2:=CLE;
                            CLE2."Applies-to ID":='';
                            CLE2."Bank Document No. Applied":='';
                            CLE2.Modify();
                        until CLE.Next() = 0;
                end;
    //TEC.VJ 06MAR2025<<
    //NT_ 11-02-2025 <<
    end;
}
