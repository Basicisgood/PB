codeunit 50108 GenJnlPostBatchCodeunitEvents
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnProcessLinesOnAfterPostGenJnlLines', '', false, false)]
    local procedure OnProcessLinesOnAfterPostGenJnlLines(var GenJournalLine: Record "Gen. Journal Line"; GLRegister: Record "G/L Register"; PreviewMode: Boolean; var GLRegNo: Integer)
    var
        GenJnlLine_l: Record "Gen. Journal Line";
        GenJnlLineOtherCompany: Record "Gen. Journal Line";
        GenJnlLineOtherCompany_2: Record "Gen. Journal Line";
        LastLine: Integer;
    begin
        GenJnlLine_l.Reset();
        GenJnlLine_l.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenJnlLine_l.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenJnlLine_l.SetFilter("Company Code", '<>%1', CompanyName);
        If GenJnlLine_l.FindSet()then repeat if NOT(GenJnlLine_l."Company Code" = '')then begin
                    GenJnlLineOtherCompany.ChangeCompany(GenJnlLine_l."Company Code");
                    GenJnlLineOtherCompany_2.ChangeCompany(GenJnlLine_l."Company Code");
                    GenJnlLineOtherCompany_2.Reset();
                    GenJnlLineOtherCompany_2.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
                    GenJnlLineOtherCompany_2.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
                    If GenJnlLineOtherCompany_2.FindLast()then LastLine:=GenJnlLineOtherCompany_2."Line No." + 10000
                    Else
                        LastLine:=10000;
                    GenJnlLineOtherCompany.ChangeCompany(GenJnlLine_l."Company Code");
                    GenJnlLineOtherCompany.Init();
                    GenJnlLineOtherCompany:=GenJournalLine;
                    GenJnlLineOtherCompany."Line No.":=LastLine;
                    GenJnlLineOtherCompany."Company Code":='';
                    GenJnlLineOtherCompany."Applies-to ID":=GenJournalLine."Document No.";
                    GenJnlLineOtherCompany.Insert();
                end;
            until GenJnlLine_l.Next() = 0;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnBeforeProcessLines', '', false, false)]
    local procedure OnBeforeProcessLines(var GenJournalLine: Record "Gen. Journal Line")
    var
        GenJnlLine_l: Record "Gen. Journal Line";
        GenJnlBatch_l: Record "Gen. Journal Batch";
        GenJnlBatchExistInOtherCompError: Label 'Company %1 must have %2 General Journal Templte and %3 General Journal Batch. Please define it first.';
    begin
        GenJnlLine_l.Reset();
        GenJnlLine_l.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenJnlLine_l.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenJnlLine_l.SetFilter("Company Code", '<>%1', CompanyName);
        If GenJnlLine_l.FindSet()then repeat if NOT(GenJnlLine_l."Company Code" = '')then begin
                    GenJnlBatch_l.ChangeCompany(GenJnlLine_l."Company Code");
                    if NOT GenJnlBatch_l.Get(GenJnlLine_l."Journal Template Name", GenJnlLine_l."Journal Batch Name")then Error(GenJnlBatchExistInOtherCompError, GenJnlLine_l."Company Code", GenJnlLine_l."Journal Template Name", GenJnlLine_l."Journal Batch Name");
                end;
            Until GenJnlLine_l.Next() = 0;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", OnBeforeGenJnlPostBatchRun, '', false, false)]
    local procedure "Gen. Jnl.-Post_OnBeforeGenJnlPostBatchRun"(var GenJnlLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    var
        GenJnltemplate: record "Gen. Journal Template";
    begin
        exit;
        if(GenJnlLine."IC Account No." <> '') and (GenJnlLine."Account Type" = GenJnlLine."Account Type"::"G/L Account") and (GenJnlLine."Account No." <> '')then begin
            GenJnlLine."PB IC Account":=GenJnlLine."IC Account No.";
            GenJnlLine."IC Account No.":='';
            GenJnlLine.Modify();
        end;
        if(GenJnlLine."PB IC Account" <> '') and (GenJnlLine."Account Type" = GenJnlLine."Account Type"::"IC Partner")then begin
            GenJnlLine."IC Account No.":=GenJnlLine."PB IC Account";
            GenJnlLine.Modify();
        end;
        exit;
        if(GenJnlLine."Journal Template Name" <> '')then if GenJnltemplate.Get(GenJnlLine."Journal Template Name")then begin
                if GenJnltemplate.Type = GenJnltemplate.Type::Intercompany then GenJnltemplate.Type:=GenJnltemplate.Type::"PB-InterCompany";
                GenJnltemplate.Modify();
            end;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", OnBeforeProcessBalanceOfLines, '', false, false)]
    local procedure "Gen. Jnl.-Post Batch_OnBeforeProcessBalanceOfLines"(var GenJournalLine: Record "Gen. Journal Line"; var GenJournalBatch: Record "Gen. Journal Batch"; var GenJournalTemplate: Record "Gen. Journal Template"; var IsKeySet: Boolean)
    begin
        exit;
        if GenJournalLine."PB IC Account" <> '' then begin
            GenJournalLine."IC Account No.":=GenJournalLine."PB IC Account";
            GenJournalLine.Modify();
        end;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", OnCheckLineOnBeforeRunCheck, '', false, false)]
    local procedure "Gen. Jnl.-Post Batch_OnCheckLineOnBeforeRunCheck"(var GenJournalLine: Record "Gen. Journal Line")
    var
        GenJnltemplate: record "Gen. Journal Template";
    begin
        exit;
        if(GenJournalLine."Journal Template Name" <> '')then if GenJnltemplate.Get(GenJournalLine."Journal Template Name")then begin
                if GenJnltemplate.Type = GenJnltemplate.Type::"PB-InterCompany" then GenJnltemplate.Type:=GenJnltemplate.Type::Intercompany;
                GenJnltemplate.Modify();
            end;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnUpdateAndDeleteLinesOnBeforeInBatchName', '', false, false)]
    local procedure OnUpdateAndDeleteLinesOnBeforeInBatchName(var GenJnlBatch: Record "Gen. Journal Batch"; var GenJnlLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    var
        GenJnlBatch_l: Record "Gen. Journal Batch";
        GenJnlLine2: Record "Gen. Journal Line";
    begin
        GenJnlLine2.Reset();
        GenJnlLine2.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
        GenJnlLine2.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
        if not GenJnlLine2.FindSet()then begin
            GenJnlBatch_l:=GenJnlBatch;
            // IF NOT (GenJnlBatch_l."Review Status" = GenJnlBatch_l."Review Status"::" ") then begin
            GenJnlBatch_l."Review Status":=GenJnlBatch_l."Review Status"::" ";
            GenJnlBatch_l."Reviewer User":='';
            GenJnlBatch_l."Review Comments":='';
            GenJnlBatch_l."Approver A Grp User":='';
            GenJnlBatch_l."Approver B Grp User":='';
            GenJnlBatch_l."Prepare User":='';
            GenJnlBatch_l.Modify();
            // end;
            GenJnlBatch:=GenJnlBatch_l;
        end;
    end;
// [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", 'OnCodeOnAfterGenJnlPostBatchRun', '', false, false)]
// local procedure OnCodeOnAfterGenJnlPostBatchRun(var GenJnlLine: Record "Gen. Journal Line")
// var
//     GenJnlBatch_l: Record "Gen. Journal Batch";
// begin
//     if not GenJnlLine.Find('=><') then begin
//         GenJnlBatch_l.Reset();
//         IF GenJnlBatch_l.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name") then begin
//             GenJnlBatch_l."Review Status" := GenJnlBatch_l."Review Status"::" ";
//             GenJnlBatch_l."Reviewer User" := '';
//             GenJnlBatch_l."Review Comments" := '';
//             GenJnlBatch_l.Modify();
//         end;
//     End;
// end;
}
