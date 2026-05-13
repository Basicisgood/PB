report 50115 Elimination
{
    // UsageCategory = ReportsAndAnalysis;
    // ApplicationArea = All;
    // ProcessingOnly = true;
    // dataset
    // {
    //     dataitem("Elimination Rule Header"; "Elimination Rule Header")
    //     {
    //         DataItemTableView = where(Active = const(true));
    //         RequestFilterFields = Rule;
    //         dataitem("Elimination Rule Line"; "Elimination Rule Line")
    //         {
    //             DataItemLink = Rule = field(Rule);
    //             DataItemTableView = sorting(Rule, "Line No.");
    //             trigger OnAfterGetRecord()
    //             var
    //                 myInt: Integer;
    //                 l_rec_SourceDimSetEntry: Record "Dimension Set Entry";
    //                 DimSetEntryTEMP: Record "Dimension Set Entry" temporary;
    //                 Amt: Decimal;
    //             begin
    //                 if "Elimination Rule Line"."Elimination Method" = "Elimination Rule Line"."Elimination Method"::"Fixed Amount" then begin
    //                     if "Elimination Rule Line"."Account Specification" = "Elimination Rule Line"."Account Specification"::"User Specified" then
    //                         "Elimination Rule Line".TestField("Destination Account")
    //                     else
    //                         "Elimination Rule Line".TestField("Source Account");
    //                     g_LineNo += 10000;
    //                     g_GenJnlLine.Init();
    //                     // g_GenJnlLine."Journal Template Name" := 'GENERAL';
    //                     g_GenJnlLine."Journal Template Name" := "Elimination Rule Header"."Journal Template Name";
    //                     g_GenJnlLine."Journal Batch Name" := "Elimination Rule Header"."Journal Name";
    //                     g_GenJnlLine."Line No." := g_LineNo;
    //                     g_GenJnlLine."Document No." := g_DocNo;
    //                     g_GenJnlLine.Validate("Posting Date", g_PostingDate);
    //                     g_GenJnlLine.Validate("Account Type", g_GenJnlLine."Account Type"::"G/L Account");
    //                     if "Elimination Rule Line"."Account Specification" = "Elimination Rule Line"."Account Specification"::"User Specified" then
    //                         g_GenJnlLine.Validate("Account No.", "Elimination Rule Line"."Destination Account")
    //                     else
    //                         g_GenJnlLine.Validate("Account No.", "Elimination Rule Line"."Source Account");
    //                     if "Elimination Rule Line"."Fixed Amount" < 0 then
    //                         g_GenJnlLine.Validate("Credit Amount", "Elimination Rule Line"."Fixed Amount")
    //                     else
    //                         g_GenJnlLine.Validate("Debit Amount", "Elimination Rule Line"."Fixed Amount");
    //                     DimensionSetEntry.DeleteAll();
    //                     g_DimSetEntry.Reset();
    //                     if "Elimination Rule Line"."Account Specification" = "Elimination Rule Line"."Account Specification"::"User Specified" then
    //                         g_DimSetEntry.SetRange("Dimension Set ID", "Elimination Rule Line"."Destination Dimension Set ID")
    //                     else
    //                         g_DimSetEntry.SetRange("Dimension Set ID", "Elimination Rule Line"."Source Dimension Set ID");
    //                     if g_DimSetEntry.FindSet() then begin
    //                         repeat
    //                             if strpos(g_DimSetEntry."Dimension Code", 'COMPANY') = 0 then begin
    //                                 IF NOT DimensionValue.GEt(g_DimSetEntry."Dimension Code", g_DimSetEntry."Dimension Value Code") THEN BEGIN
    //                                     DimensionValue.INIT;
    //                                     DimensionValue."Dimension Code" := g_DimSetEntry."Dimension Code";
    //                                     DimensionValue.Code := g_DimSetEntry."Dimension Value Code";
    //                                     DimensionValue.Name := g_DimSetEntry."Dimension Value Code";
    //                                     DimensionValue.INSERT(TRUE);
    //                                 END;
    //                                 DimensionSetEntry.INIT;
    //                                 DimensionSetEntry."Dimension Code" := g_DimSetEntry."Dimension Code";
    //                                 DimensionSetEntry."Dimension Value Code" := g_DimSetEntry."Dimension Value Code";
    //                                 DimensionSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
    //                                 DimensionSetEntry.INSERT;
    //                             end;
    //                         until g_DimSetEntry.Next() = 0;
    //                         if g_CompanyMapping.Get(CompanyName) then begin
    //                             g_Dimension.Reset();
    //                             g_Dimension.SetFilter(Code, '%1', '*COMPANY*');
    //                             if g_Dimension.FindFirst() then begin
    //                                 if not DimensionValue.get(g_Dimension.Code, g_CompanyMapping."PB Company Code") then begin
    //                                     DimensionValue.INIT;
    //                                     DimensionValue."Dimension Code" := g_Dimension.Code;
    //                                     DimensionValue.Code := g_CompanyMapping."PB Company Code";
    //                                     DimensionValue.Name := g_CompanyMapping."PB Company Code";
    //                                     DimensionValue.INSERT(TRUE);
    //                                 end;
    //                                 DimensionSetEntry.INIT;
    //                                 DimensionSetEntry."Dimension Code" := g_Dimension.Code;
    //                                 DimensionSetEntry."Dimension Value Code" := g_CompanyMapping."PB Company Code";
    //                                 DimensionSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
    //                                 DimensionSetEntry.INSERT;
    //                             end;
    //                         end;
    //                         g_GenJnlLine.validate("Dimension Set ID", g_DimMgmt.GetDimensionSetID(DimensionSetEntry));
    //                     end;
    //                     g_GenJnlLine.Insert();
    //                 end
    //                 else begin
    //                     if "Elimination Rule Line"."Account Specification" = "Elimination Rule Line"."Account Specification"::"User Specified" then
    //                         "Elimination Rule Line".TestField("Destination Account")
    //                     else
    //                         "Elimination Rule Line".TestField("Source Account");
    //                     g_GLDimBuffer.DeleteAll();
    //                     g_GLEntry.reset;
    //                     if "Elimination Rule Line"."Account Specification" = "Elimination Rule Line"."Account Specification"::"User Specified" then
    //                         g_GLEntry.SetRange("G/L Account No.", "Elimination Rule Line"."Destination Account")
    //                     else
    //                         g_GLEntry.SetRange("G/L Account No.", "Elimination Rule Line"."Source Account");
    //                     //NT_ >> 10-02-2025
    //                     l_rec_SourceDimSetEntry.Reset();
    //                     l_rec_SourceDimSetEntry.SetRange("Dimension Set ID", "Source Dimension Set ID");
    //                     if ("Dimension Specification" = "Dimension Specification"::Source) then begin
    //                         if (not l_rec_SourceDimSetEntry.FindSet()) then begin
    //                             //NT_<< 10-02-2025
    //                             if g_GLEntry.FindSet() then
    //                                 repeat
    //                                     if g_GLDimBuffer.get(g_GLEntry."Global Dimension 1 Code", g_GLEntry."Global Dimension 2 Code",
    //                                     g_GLEntry."Shortcut Dimension 3 Code_PB", g_GLEntry."Shortcut Dimension 4 Code_PB",
    //                                     g_GLEntry."Shortcut Dimension 5 Code_PB", g_GLEntry."Shortcut Dimension 6 Code_PB",
    //                                     g_GLEntry."Shortcut Dimension 7 Code_PB",
    //                                     g_GLEntry."Shortcut Dimension 9 Code_PB", g_GLEntry."Shortcut Dimension 10 Code_PB",
    //                                     g_GLEntry."Shortcut Dimension 11 Code_PB", g_GLEntry."Shortcut Dimension 12 Code_PB",
    //                                     g_GLEntry."Shortcut Dimension 13 Code_PB", g_GLEntry."Shortcut Dimension 14 Code_PB",
    //                                     g_GLEntry."Shortcut Dimension 15 Code_PB", g_GLEntry."G/L Account No.") then begin
    //                                         g_GLDimBuffer.Amount += g_GLEntry.Amount;
    //                                         g_GLDimBuffer.Modify();
    //                                     end
    //                                     else begin
    //                                         g_GLDimBuffer.Init();
    //                                         g_GLDimBuffer."Dimension 1" := g_GLEntry."Global Dimension 1 Code";
    //                                         g_GLDimBuffer."Dimension 2" := g_GLEntry."Global Dimension 2 Code";
    //                                         g_GLDimBuffer."Dimension 3" := g_GLEntry."Shortcut Dimension 3 Code_PB";
    //                                         g_GLDimBuffer."Dimension 4" := g_GLEntry."Shortcut Dimension 4 Code_PB";
    //                                         g_GLDimBuffer."Dimension 5" := g_GLEntry."Shortcut Dimension 5 Code_PB";
    //                                         g_GLDimBuffer."Dimension 6" := g_GLEntry."Shortcut Dimension 6 Code_PB";
    //                                         g_GLDimBuffer."Dimension 7" := g_GLEntry."Shortcut Dimension 7 Code_PB";
    //                                         g_GLDimBuffer."Dimension 9" := g_GLEntry."Shortcut Dimension 9 Code_PB";
    //                                         g_GLDimBuffer."Dimension 10" := g_GLEntry."Shortcut Dimension 10 Code_PB";
    //                                         g_GLDimBuffer."Dimension 11" := g_GLEntry."Shortcut Dimension 11 Code_PB";
    //                                         g_GLDimBuffer."Dimension 12" := g_GLEntry."Shortcut Dimension 12 Code_PB";
    //                                         g_GLDimBuffer."Dimension 13" := g_GLEntry."Shortcut Dimension 13 Code_PB";
    //                                         g_GLDimBuffer."Dimension 14" := g_GLEntry."Shortcut Dimension 14 Code_PB";
    //                                         g_GLDimBuffer."Dimension 15" := g_GLEntry."Shortcut Dimension 15 Code_PB";
    //                                         g_GLDimBuffer."Account No." := g_GLEntry."G/L Account No.";
    //                                         g_GLDimBuffer.Amount := g_GLEntry.Amount;
    //                                         g_GLDimBuffer."Dimension Set ID" := g_GLEntry."Dimension Set ID";
    //                                         g_GLDimBuffer.Insert();
    //                                     end;
    //                                 until g_GLEntry.next = 0;
    //                             g_GLDimBuffer.Reset();
    //                             if g_GLDimBuffer.FindSet() then
    //                                 repeat
    //                                     g_LineNo += 10000;
    //                                     g_GenJnlLine.Init();
    //                                     // g_GenJnlLine."Journal Template Name" := 'GENERAL';
    //                                     g_GenJnlLine."Journal Template Name" := "Elimination Rule Header"."Journal Template Name";
    //                                     g_GenJnlLine."Journal Batch Name" := "Elimination Rule Header"."Journal Name";
    //                                     g_GenJnlLine."Line No." := g_LineNo;
    //                                     g_GenJnlLine."Document No." := g_DocNo;
    //                                     g_GenJnlLine.Validate("Posting Date", g_PostingDate);
    //                                     g_GenJnlLine.Validate("Account Type", g_GenJnlLine."Account Type"::"G/L Account");
    //                                     if "Elimination Rule Line"."Account Specification" = "Elimination Rule Line"."Account Specification"::"User Specified" then
    //                                         g_GenJnlLine.Validate("Account No.", "Elimination Rule Line"."Destination Account")
    //                                     else
    //                                         g_GenJnlLine.Validate("Account No.", "Elimination Rule Line"."Source Account");
    //                                     // if g_GLDimBuffer.Amount < 0 then
    //                                     if g_GLDimBuffer.Amount > 0 then
    //                                         g_GenJnlLine.Validate("Credit Amount", g_GLDimBuffer.Amount)
    //                                     else
    //                                         g_GenJnlLine.Validate("Debit Amount", g_GLDimBuffer.Amount * -1);
    //                                     // g_GenJnlLine.Validate("Debit Amount", g_GLDimBuffer.Amount);
    //                                     DimensionSetEntry.DeleteAll();
    //                                     g_DimSetEntry.Reset();
    //                                     g_DimSetEntry.SetRange("Dimension Set ID", g_GLDimBuffer."Dimension Set ID");
    //                                     if g_DimSetEntry.FindSet() then begin
    //                                         repeat
    //                                             if strpos(g_DimSetEntry."Dimension Code", 'COMPANY') = 0 then begin
    //                                                 IF NOT DimensionValue.GEt(g_DimSetEntry."Dimension Code", g_DimSetEntry."Dimension Value Code") THEN BEGIN
    //                                                     DimensionValue.INIT;
    //                                                     DimensionValue."Dimension Code" := g_DimSetEntry."Dimension Code";
    //                                                     DimensionValue.Code := g_DimSetEntry."Dimension Value Code";
    //                                                     DimensionValue.Name := g_DimSetEntry."Dimension Value Code";
    //                                                     DimensionValue.INSERT(TRUE);
    //                                                 END;
    //                                                 DimensionSetEntry.INIT;
    //                                                 DimensionSetEntry."Dimension Code" := g_DimSetEntry."Dimension Code";
    //                                                 DimensionSetEntry."Dimension Value Code" := g_DimSetEntry."Dimension Value Code";
    //                                                 DimensionSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
    //                                                 DimensionSetEntry.INSERT;
    //                                             end;
    //                                         until g_DimSetEntry.Next() = 0;
    //                                         if g_CompanyMapping.Get(CompanyName) then begin
    //                                             g_Dimension.Reset();
    //                                             g_Dimension.SetFilter(Code, '%1', '*COMPANY*');
    //                                             if g_Dimension.FindFirst() then begin
    //                                                 if not DimensionValue.get(g_Dimension.Code, g_CompanyMapping."PB Company Code") then begin
    //                                                     DimensionValue.INIT;
    //                                                     DimensionValue."Dimension Code" := g_Dimension.Code;
    //                                                     DimensionValue.Code := g_CompanyMapping."PB Company Code";
    //                                                     DimensionValue.Name := g_CompanyMapping."PB Company Code";
    //                                                     DimensionValue.INSERT(TRUE);
    //                                                 end;
    //                                                 DimensionSetEntry.INIT;
    //                                                 DimensionSetEntry."Dimension Code" := g_Dimension.Code;
    //                                                 DimensionSetEntry."Dimension Value Code" := g_CompanyMapping."PB Company Code";
    //                                                 DimensionSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
    //                                                 DimensionSetEntry.INSERT;
    //                                             end;
    //                                         end;
    //                                         //NT_ 10022025 >>
    //                                         // g_GenJnlLine.validate("Dimension Set ID", g_DimMgmt.GetDimensionSetID(DimensionSetEntry));
    //                                         g_GenJnlLine."Dimension Set ID" := g_DimMgmt.GetDimensionSetID(DimensionSetEntry);
    //                                         InsertDimensions(g_GenJnlLine, DimensionSetEntry);
    //                                         //NT_ 10022025 <<
    //                                     end;
    //                                     g_GenJnlLine.Insert();
    //                                 until g_GLDimBuffer.next = 0;
    //                             //NT_  10-02-2025 >>
    //                         end else begin
    //                             g_LineNo += 10000;
    //                             g_GenJnlLine.Init();
    //                             // g_GenJnlLine."Journal Template Name" := 'GENERAL';
    //                             g_GenJnlLine."Journal Template Name" := "Elimination Rule Header"."Journal Template Name";
    //                             g_GenJnlLine."Journal Batch Name" := "Elimination Rule Header"."Journal Name";
    //                             g_GenJnlLine."Line No." := g_LineNo;
    //                             g_GenJnlLine."Document No." := g_DocNo;
    //                             g_GenJnlLine.Validate("Posting Date", g_PostingDate);
    //                             g_GenJnlLine.Validate("Account Type", g_GenJnlLine."Account Type"::"G/L Account");
    //                             if "Elimination Rule Line"."Account Specification" = "Elimination Rule Line"."Account Specification"::"User Specified" then
    //                                 g_GenJnlLine.Validate("Account No.", "Elimination Rule Line"."Destination Account")
    //                             else
    //                                 g_GenJnlLine.Validate("Account No.", "Elimination Rule Line"."Source Account");
    //                             DimSetEntryTEMP.DeleteAll();
    //                             /* l_rec_SourceDimSetEntry.Reset();
    //                             l_rec_SourceDimSetEntry.SetRange("Dimension Set ID", "Source Dimension Set ID");
    //                             if l_rec_SourceDimSetEntry.FindFirst() then
    //                                 repeat
    //                                     IF NOT DimensionValue.GEt(l_rec_SourceDimSetEntry."Dimension Code", l_rec_SourceDimSetEntry."Dimension Value Code") THEN BEGIN
    //                                         DimensionValue.INIT;
    //                                         DimensionValue."Dimension Code" := l_rec_SourceDimSetEntry."Dimension Code";
    //                                         DimensionValue.Code := l_rec_SourceDimSetEntry."Dimension Value Code";
    //                                         DimensionValue.Name := l_rec_SourceDimSetEntry."Dimension Value Code";
    //                                         DimensionValue.INSERT(TRUE);
    //                                     END;
    //                                     DimSetEntryTEMP.Init();
    //                                     DimSetEntryTEMP."Dimension Code" := l_rec_SourceDimSetEntry."Dimension Code";
    //                                     DimSetEntryTEMP."Dimension Value Code" := l_rec_SourceDimSetEntry."Dimension Value Code";
    //                                     DimSetEntryTEMP."Dimension Value ID" := l_rec_SourceDimSetEntry."Dimension Value ID";
    //                                     DimSetEntryTEMP.Insert();
    //                                 until l_rec_SourceDimSetEntry.Next() = 0; */
    //                             g_DimMgmt.GetDimensionSet(DimSetEntryTEMP, "Source Dimension Set ID");
    //                             g_GenJnlLine."Dimension Set ID" := g_DimMgmt.GetDimensionSetID(DimSetEntryTEMP);
    //                             InsertDimensions(g_GenJnlLine, DimSetEntryTEMP);
    //                             Amt := GetSumByDim(g_GenJnlLine);
    //                             if g_GLDimBuffer.Amount > 0 then
    //                                 g_GenJnlLine.Validate("Credit Amount", Amt)
    //                             else
    //                                 g_GenJnlLine.Validate("Debit Amount", Amt * -1);
    //                             g_GenJnlLine.Insert();
    //                         end;
    //                     end else begin
    //                         g_LineNo += 10000;
    //                         g_GenJnlLine.Init();
    //                         // g_GenJnlLine."Journal Template Name" := 'GENERAL';
    //                         g_GenJnlLine."Journal Template Name" := "Elimination Rule Header"."Journal Template Name";
    //                         g_GenJnlLine."Journal Batch Name" := "Elimination Rule Header"."Journal Name";
    //                         g_GenJnlLine."Line No." := g_LineNo;
    //                         g_GenJnlLine."Document No." := g_DocNo;
    //                         g_GenJnlLine.Validate("Posting Date", g_PostingDate);
    //                         g_GenJnlLine.Validate("Account Type", g_GenJnlLine."Account Type"::"G/L Account");
    //                         if "Elimination Rule Line"."Account Specification" = "Elimination Rule Line"."Account Specification"::"User Specified" then
    //                             g_GenJnlLine.Validate("Account No.", "Elimination Rule Line"."Destination Account")
    //                         else
    //                             g_GenJnlLine.Validate("Account No.", "Elimination Rule Line"."Source Account");
    //                         DimSetEntryTEMP.DeleteAll();
    //                         /* l_rec_SourceDimSetEntry.Reset();
    //                         l_rec_SourceDimSetEntry.SetRange("Dimension Set ID", "Destination Dimension Set ID");
    //                         if l_rec_SourceDimSetEntry.FindFirst() then
    //                             repeat
    //                                 IF NOT DimensionValue.GEt(l_rec_SourceDimSetEntry."Dimension Code", l_rec_SourceDimSetEntry."Dimension Value Code") THEN BEGIN
    //                                     DimensionValue.INIT;
    //                                     DimensionValue."Dimension Code" := l_rec_SourceDimSetEntry."Dimension Code";
    //                                     DimensionValue.Code := l_rec_SourceDimSetEntry."Dimension Value Code";
    //                                     DimensionValue.Name := l_rec_SourceDimSetEntry."Dimension Value Code";
    //                                     DimensionValue.INSERT(TRUE);
    //                                 END;
    //                                 DimSetEntryTEMP.Init();
    //                                 DimSetEntryTEMP."Dimension Code" := l_rec_SourceDimSetEntry."Dimension Code";
    //                                 DimSetEntryTEMP."Dimension Value Code" := l_rec_SourceDimSetEntry."Dimension Value Code";
    //                                 DimSetEntryTEMP."Dimension Value ID" := l_rec_SourceDimSetEntry."Dimension Value ID";
    //                                 DimSetEntryTEMP.Insert();
    //                             until l_rec_SourceDimSetEntry.Next() = 0; */
    //                         g_DimMgmt.GetDimensionSet(DimSetEntryTEMP, "Destination Dimension Set ID");
    //                         g_GenJnlLine."Dimension Set ID" := g_DimMgmt.GetDimensionSetID(DimSetEntryTEMP);
    //                         InsertDimensions(g_GenJnlLine, DimSetEntryTEMP);
    //                         Amt := GetSumByDim(g_GenJnlLine);
    //                         if g_GLDimBuffer.Amount > 0 then
    //                             g_GenJnlLine.Validate("Credit Amount", Amt)
    //                         else
    //                             g_GenJnlLine.Validate("Debit Amount", Amt * -1);
    //                         g_GenJnlLine.Insert();
    //                     end;
    //                     //NT_  10-02-2025 <<
    //                 end;
    //             end;
    //             trigger OnPostDataItem()
    //             var
    //                 myInt: Integer;
    //             begin
    //                 if g_PropoSalOptions = g_PropoSalOptions::"Post Only" then begin
    //                     g_GenJnlLine.Reset();
    //                     // g_GenJnlLine.SetRange("Journal Template Name", 'GENERAL');
    //                     g_GenJnlLine.SetRange("Journal Template Name", "Elimination Rule Header"."Journal Template Name");
    //                     g_GenJnlLine.SetRange("Journal Batch Name", "Elimination Rule Header"."Journal Name");
    //                     if g_GenJnlLine.FindSet() then
    //                         g_GenJnlPostBatch.Run(g_GenJnlLine);
    //                 end;
    //                 g_GLDimBuffer.Reset();
    //                 if g_GLDimBuffer.FindSet() then
    //                     g_GLDimBuffer.DeleteAll();
    //             end;
    //         }
    //         trigger OnPreDataItem()
    //         var
    //             myInt: Integer;
    //         begin
    //             g_CompanyMapping.Get(CompanyName);
    //             if not g_CompanyMapping."Consolidation Company" then
    //                 Error('Elimination can be run only in consolidation company');
    //             if g_PostingDate = 0D then
    //                 g_PostingDate := today;
    //         end;
    //         trigger OnAfterGetRecord()
    //         var
    //             myInt: Integer;
    //         begin
    //             "Elimination Rule Header".TestField("Journal Name");
    //             g_LineNo := 0;
    //             g_GenJnlLine.reset;
    //             // g_GenJnlLine.SetRange("Journal Template Name", 'GENERAL');
    //             g_GenJnlLine.SetRange("Journal Template Name", "Elimination Rule Header"."Journal Template Name");
    //             g_GenJnlLine.SetRange("Journal Batch Name", "Elimination Rule Header"."Journal Name");
    //             if g_GenJnlLine.FindLast() then
    //                 g_LineNo := g_GenJnlLine."Line No.";
    //             //if g_OldBatchName <> "Elimination Rule Header"."Journal Name" then begin
    //             // g_GenJnlBatch.get('GENERAL', "Elimination Rule Header"."Journal Name");
    //             g_GenJnlBatch.get("Elimination Rule Header"."Journal Template Name", "Elimination Rule Header"."Journal Name");
    //             g_GenJnlBatch.TestField("No. Series");
    //             g_DocNo := g_NoSeries.GetNextNo(g_GenJnlBatch."No. Series");
    //             //    g_OldBatchName := "Elimination Rule Header"."Journal Name";
    //             //end;
    //         end;
    //     }
    // }
    // requestpage
    // {
    //     layout
    //     {
    //         area(Content)
    //         {
    //             group(GroupName)
    //             {
    //                 field(g_PostingDate; g_PostingDate)
    //                 {
    //                     Caption = 'G/L Posting Date';
    //                     ApplicationArea = All;
    //                 }
    //                 field(g_PropoSalOptions; g_PropoSalOptions)
    //                 {
    //                     Caption = 'Proposal Options';
    //                     ApplicationArea = All;
    //                 }
    //             }
    //         }
    //     }
    // }
    // local procedure InsertDimensions(var GJLine: Record "Gen. Journal Line"; var DimSetEntry: Record "Dimension Set Entry")
    // var
    //     GLSetup: Record "General Ledger Setup";
    // begin
    //     if GLSetup.get() then;
    //     DimSetEntry.Reset();
    //     if DimSetEntry.FindFirst() then
    //         repeat
    //             if GLSetup."Shortcut Dimension 1 Code" = DimSetEntry."Dimension Code" then
    //                 GJLine.validate("Shortcut Dimension 1 Code", DimSetEntry."Dimension Value Code");
    //             if GLSetup."Shortcut Dimension 2 Code" = DimSetEntry."Dimension Code" then
    //                 GJLine.validate("Shortcut Dimension 2 Code", DimSetEntry."Dimension Value Code");
    //             if GLSetup."Shortcut Dimension 3 Code" = DimSetEntry."Dimension Code" then
    //                 GJLine.validate("Shortcut Dimension 3 Code", DimSetEntry."Dimension Value Code");
    //             if GLSetup."Shortcut Dimension 4 Code" = DimSetEntry."Dimension Code" then
    //                 GJLine.validate("Shortcut Dimension 4 Code", DimSetEntry."Dimension Value Code");
    //             if GLSetup."Shortcut Dimension 5 Code" = DimSetEntry."Dimension Code" then
    //                 GJLine.validate("Shortcut Dimension 5 Code", DimSetEntry."Dimension Value Code");
    //             if GLSetup."Shortcut Dimension 6 Code" = DimSetEntry."Dimension Code" then
    //                 GJLine.validate("Shortcut Dimension 6 Code", DimSetEntry."Dimension Value Code");
    //             if GLSetup."Shortcut Dimension 7 Code" = DimSetEntry."Dimension Code" then
    //                 GJLine.validate("Shortcut Dimension 7 Code", DimSetEntry."Dimension Value Code");
    //             if GLSetup."Shortcut Dimension 8 Code" = DimSetEntry."Dimension Code" then
    //                 GJLine.validate("Shortcut Dimension 8 Code", DimSetEntry."Dimension Value Code");
    //             if GLSetup."Shortcut Dimension 9 Code" = DimSetEntry."Dimension Code" then
    //                 GJLine.validate("Shortcut Dimension 9 Code", DimSetEntry."Dimension Value Code");
    //             if GLSetup."Shortcut Dimension 10 Code" = DimSetEntry."Dimension Code" then
    //                 GJLine.validate("Shortcut Dimension 10 Code", DimSetEntry."Dimension Value Code");
    //             if GLSetup."Shortcut Dimension 11 Code" = DimSetEntry."Dimension Code" then
    //                 GJLine.validate("Shortcut Dimension 11 Code", DimSetEntry."Dimension Value Code");
    //             if GLSetup."Shortcut Dimension 12 Code" = DimSetEntry."Dimension Code" then
    //                 GJLine.validate("Shortcut Dimension 12 Code", DimSetEntry."Dimension Value Code");
    //             if GLSetup."Shortcut Dimension 13 Code" = DimSetEntry."Dimension Code" then
    //                 GJLine.validate("Shortcut Dimension 13 Code", DimSetEntry."Dimension Value Code");
    //             if GLSetup."Shortcut Dimension 14 Code" = DimSetEntry."Dimension Code" then
    //                 GJLine.validate("Shortcut Dimension 14 Code", DimSetEntry."Dimension Value Code");
    //             if GLSetup."Shortcut Dimension 15 Code" = DimSetEntry."Dimension Code" then
    //                 GJLine.validate("Shortcut Dimension 15 Code", DimSetEntry."Dimension Value Code");
    //         until DimSetEntry.Next() = 0;
    // end;
    // local procedure GetSumByDim(var GJLine: Record "Gen. Journal Line"): Decimal
    // var
    //     GLE: Record "G/L Entry";
    // begin
    //     GLE.Reset();
    //     GLE.SetRange("G/L Account No.", GJLine."Account No.");
    //     GLE.SetRange("Global Dimension 1 Code", GJLine."Shortcut Dimension 1 Code");
    //     GLE.SetRange("Global Dimension 2 Code", GJLine."Shortcut Dimension 2 Code");
    //     GLE.SetRange("Shortcut Dimension 3 Code_PB", GJLine."Shortcut Dimension 3 Code");
    //     GLE.SetRange("Shortcut Dimension 4 Code_PB", GJLine."Shortcut Dimension 4 Code");
    //     GLE.SetRange("Shortcut Dimension 5 Code_PB", GJLine."Shortcut Dimension 5 Code");
    //     GLE.SetRange("Shortcut Dimension 6 Code_PB", GJLine."Shortcut Dimension 6 Code");
    //     GLE.SetRange("Shortcut Dimension 7 Code_PB", GJLine."Shortcut Dimension 7 Code");
    //     GLE.SetRange("Shortcut Dimension 8 Code_PB", GJLine."Shortcut Dimension 8 Code");
    //     GLE.SetRange("Shortcut Dimension 9 Code_PB", GJLine."Shortcut Dimension 9 Code");
    //     GLE.SetRange("Shortcut Dimension 10 Code_PB", GJLine."Shortcut Dimension 10 Code");
    //     GLE.SetRange("Shortcut Dimension 11 Code_PB", GJLine."Shortcut Dimension 11 Code");
    //     GLE.SetRange("Shortcut Dimension 12 Code_PB", GJLine."Shortcut Dimension 12 Code");
    //     GLE.SetRange("Shortcut Dimension 13 Code_PB", GJLine."Shortcut Dimension 13 Code");
    //     GLE.SetRange("Shortcut Dimension 14 Code_PB", GJLine."Shortcut Dimension 14 Code");
    //     GLE.SetRange("Shortcut Dimension 15 Code_PB", GJLine."Shortcut Dimension 15 Code");
    //     GLE.CalcSums(Amount);
    //     exit(GLE.Amount);
    // end;
    // var
    //     g_PostingDate: Date;
    //     g_PropoSalOptions: Option "Proposal Only","Post Only";
    //     g_GenJnlLine: Record "Gen. Journal Line";
    //     g_LineNo: Integer;
    //     g_DocumentNo: Code[20];
    //     g_NoSeries: Codeunit "No. Series";
    //     g_EliminationRuleHdr: Record "Elimination Rule Header";
    //     g_OldBatchName: Code[20];
    //     g_GenJnlBatch: Record "Gen. Journal Batch";
    //     g_DocNo: Code[20];
    //     g_GLEntry: Record "G/L Entry";
    //     g_GLDimBuffer: Record "G/L Dimension Buffer";
    //     g_DimSetEntry: Record "Dimension Set Entry";
    //     g_DimMgmt: Codeunit DimensionManagement;
    //     DimensionSetEntry: Record "Dimension Set Entry" temporary;
    //     DimensionValue: Record "Dimension Value";
    //     g_CompanyMapping: Record "Company Name Mapping";
    //     g_Dimension: Record Dimension;
    //     g_GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
    ApplicationArea = All;
    Caption = 'Elimination';
    UsageCategory = Tasks;
    ProcessingOnly = true;

    dataset
    {
        dataitem(EliminationRuleHeader; "Elimination Rule Header")
        {
            DataItemTableView = where(Active=const(true));
            RequestFilterFields = Rule;

            dataitem("Elimination Rule Line"; "Elimination Rule Line")
            {
                DataItemLinkReference = EliminationRuleHeader;
                DataItemLink = Rule=field(Rule);

                trigger OnAfterGetRecord()
                var
                    ElimQuery: Query "Elimination Query";
                    AccountNo: Code[20];
                    DimensionSetEntry: Record "Dimension Set Entry" temporary;
                    DimensionValue: Record "Dimension Value";
                begin
                    EliminationRuleHeader.TestField("Journal Name");
                    EliminationRuleHeader.TestField("Journal Template Name");
                    if "Elimination Method" = "Elimination Method"::"Net Change" then begin
                        AccountNo:=GetGLAccNo();
                        SetQueryFilter(ElimQuery);
                        if ElimQuery.Open()then begin
                            while ElimQuery.Read()do begin
                                GenerateGJLine(AccountNo, g_cod_DocNo, ElimQuery);
                            end;
                            ElimQuery.Close();
                        end;
                    end;
                    //PY>>
                    if "Elimination Rule Line"."Elimination Method" = "Elimination Rule Line"."Elimination Method"::"Fixed Amount" then begin
                        if "Elimination Rule Line"."Account Specification" = "Elimination Rule Line"."Account Specification"::"User Specified" then "Elimination Rule Line".TestField("Destination Account")
                        else
                            "Elimination Rule Line".TestField("Source Account");
                        g_LineNo+=10000;
                        g_GenJnlLine.Init();
                        // g_GenJnlLine."Journal Template Name" := 'GENERAL';
                        g_GenJnlLine."Journal Template Name":=EliminationRuleHeader."Journal Template Name";
                        g_GenJnlLine."Journal Batch Name":=EliminationRuleHeader."Journal Name";
                        g_GenJnlLine."Line No.":=g_LineNo;
                        g_GenJnlLine."Document No.":=g_cod_DocNo;
                        g_GenJnlLine.Validate("Posting Date", g_PostingDate);
                        g_GenJnlLine.Validate("Account Type", g_GenJnlLine."Account Type"::"G/L Account");
                        if "Elimination Rule Line"."Account Specification" = "Elimination Rule Line"."Account Specification"::"User Specified" then g_GenJnlLine.Validate("Account No.", "Elimination Rule Line"."Destination Account")
                        else
                            g_GenJnlLine.Validate("Account No.", "Elimination Rule Line"."Source Account");
                        /* if "Elimination Rule Line"."Fixed Amount" < 0 then
                            g_GenJnlLine.Validate("Credit Amount", "Elimination Rule Line"."Fixed Amount")
                        else
                            g_GenJnlLine.Validate("Debit Amount", "Elimination Rule Line"."Fixed Amount"); */
                        g_GenJnlLine.Validate(Amount, "Elimination Rule Line"."Fixed Amount");
                        g_GenJnlLine.validate(Description, EliminationRuleHeader.Description);
                        DimensionSetEntry.DeleteAll();
                        g_DimSetEntry.Reset();
                        if "Elimination Rule Line"."Account Specification" = "Elimination Rule Line"."Account Specification"::"User Specified" then g_DimSetEntry.SetRange("Dimension Set ID", "Elimination Rule Line"."Destination Dimension Set ID")
                        else
                            g_DimSetEntry.SetRange("Dimension Set ID", "Elimination Rule Line"."Source Dimension Set ID");
                        if g_DimSetEntry.FindSet()then begin
                            repeat if strpos(g_DimSetEntry."Dimension Code", 'COMPANY') = 0 then begin
                                    IF NOT DimensionValue.GEt(g_DimSetEntry."Dimension Code", g_DimSetEntry."Dimension Value Code")THEN BEGIN
                                        DimensionValue.INIT;
                                        DimensionValue."Dimension Code":=g_DimSetEntry."Dimension Code";
                                        DimensionValue.Code:=g_DimSetEntry."Dimension Value Code";
                                        DimensionValue.Name:=g_DimSetEntry."Dimension Value Code";
                                        DimensionValue.INSERT(TRUE);
                                    END;
                                    DimensionSetEntry.INIT;
                                    DimensionSetEntry."Dimension Code":=g_DimSetEntry."Dimension Code";
                                    DimensionSetEntry."Dimension Value Code":=g_DimSetEntry."Dimension Value Code";
                                    DimensionSetEntry."Dimension Value ID":=DimensionValue."Dimension Value ID";
                                    DimensionSetEntry.INSERT;
                                end;
                            until g_DimSetEntry.Next() = 0;
                            if g_CompanyMapping.Get(CompanyName)then begin
                                g_Dimension.Reset();
                                g_Dimension.SetFilter(Code, '%1', '*COMPANY*');
                                if g_Dimension.FindFirst()then begin
                                    if not DimensionValue.get(g_Dimension.Code, g_CompanyMapping."PB Company Code")then begin
                                        DimensionValue.INIT;
                                        DimensionValue."Dimension Code":=g_Dimension.Code;
                                        DimensionValue.Code:=g_CompanyMapping."PB Company Code";
                                        DimensionValue.Name:=g_CompanyMapping."PB Company Code";
                                        DimensionValue.INSERT(TRUE);
                                    end;
                                    DimensionSetEntry.INIT;
                                    DimensionSetEntry."Dimension Code":=g_Dimension.Code;
                                    DimensionSetEntry."Dimension Value Code":=g_CompanyMapping."PB Company Code";
                                    DimensionSetEntry."Dimension Value ID":=DimensionValue."Dimension Value ID";
                                    DimensionSetEntry.INSERT;
                                end;
                            end;
                            // g_GenJnlLine.validate("Dimension Set ID", g_DimMgmt.GetDimensionSetID(DimensionSetEntry));
                            InsertDimensionGJLine(g_GenJnlLine, DimensionSetEntry);
                        end;
                        g_GenJnlLine.Insert();
                    end;
                //PY<<
                end;
            }
            trigger OnPreDataItem()
            var
                l_rec_CompanyMapping: Record "Company Name Mapping";
            begin
                l_rec_CompanyMapping.Get(CompanyName);
                if not l_rec_CompanyMapping."Consolidation Company" then Error('Elimination can be run only in consolidation company');
                if g_PostingDate = 0D then g_PostingDate:=today;
            end;
            trigger OnAfterGetRecord()
            begin
                GetNextDocNo();
                EliminationRuleHeader.TestField("Journal Name");
                g_LineNo:=0;
                g_GenJnlLine.reset;
                // g_GenJnlLine.SetRange("Journal Template Name", 'GENERAL');
                g_GenJnlLine.SetRange("Journal Template Name", EliminationRuleHeader."Journal Template Name");
                g_GenJnlLine.SetRange("Journal Batch Name", EliminationRuleHeader."Journal Name");
                if g_GenJnlLine.FindLast()then g_LineNo:=g_GenJnlLine."Line No.";
                //if g_OldBatchName <> "Elimination Rule Header"."Journal Name" then begin
                // g_GenJnlBatch.get('GENERAL', "Elimination Rule Header"."Journal Name");
                g_GenJnlBatch.get(EliminationRuleHeader."Journal Template Name", EliminationRuleHeader."Journal Name");
                g_GenJnlBatch.TestField("No. Series");
            //end;
            end;
            trigger OnPostDataItem()
            begin
                "Date Last Run":=Today;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Filters)
                {
                    field(g_PostingDate; g_PostingDate)
                    {
                        Caption = 'G/L Posting Date';
                        ApplicationArea = All;
                    }
                    field(g_PropoSalOptions; g_PropoSalOptions)
                    {
                        Caption = 'Proposal Options';
                        ApplicationArea = All;
                    }
                    field(g_dat_Start; g_dat_Start)
                    {
                        Caption = 'Start Date';
                        ApplicationArea = All;
                    }
                    field(g_dat_End; g_dat_End)
                    {
                        Caption = 'End Date';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
    trigger OnInitReport()
    begin
        Clear(g_cod_DocNo);
    end;
    var g_dat_End: Date;
    g_dat_Start: Date;
    g_PostingDate: Date;
    g_PropoSalOptions: Option "Proposal Only", "Post Only";
    g_GenJnlLine: Record "Gen. Journal Line";
    g_LineNo: Integer;
    g_NoSeries: Codeunit "No. Series";
    g_GenJnlBatch: Record "Gen. Journal Batch";
    g_DimSetEntry: Record "Dimension Set Entry";
    g_DimMgmt: Codeunit DimensionManagement;
    g_CompanyMapping: Record "Company Name Mapping";
    g_Dimension: Record Dimension;
    local procedure GetNextDocNo()
    var
        l_rec_GJL: Record "Gen. Journal Line";
        NoSeries: Codeunit "No. Series";
        l_rec_GenJnlBtch: Record "Gen. Journal Batch";
    begin
        l_rec_GJL.Reset();
        l_rec_GJL.SetRange("Journal Template Name", EliminationRuleHeader."Journal Template Name");
        l_rec_GJL.SetRange("Journal Batch Name", EliminationRuleHeader."Journal Name");
        if l_rec_GJL.FindLast()then g_cod_DocNo:=IncStr(l_rec_GJL."Document No.")
        else
        begin
            l_rec_GenJnlBtch.Get(EliminationRuleHeader."Journal Template Name", EliminationRuleHeader."Journal Name");
            g_cod_DocNo:=NoSeries.PeekNextNo(l_rec_GenJnlBtch."No. Series", g_PostingDate);
        end;
    end;
    local procedure GenerateGJLine(AccNo: code[20]; DocNo: Code[20]; ElimQuery: Query "Elimination Query")
    var
        GenJnLine: Record "Gen. Journal Line";
        LineNo: Integer;
    begin
        LineNo:=GetLastLineNo() + 10000;
        GenJnLine.Init();
        GenJnLine."Document No.":=DocNo;
        GenJnLine."Line No.":=LineNo;
        GenJnLine."Journal Template Name":=EliminationRuleHeader."Journal Template Name";
        GenJnLine."Journal Batch Name":=EliminationRuleHeader."Journal Name";
        GenJnLine.validate("Posting Date", g_PostingDate);
        GenJnLine.Validate("Account Type", GenJnLine."Account Type"::"G/L Account");
        GenJnLine.Validate("Account No.", AccNo);
        if ElimQuery.Amount > 0 then GenJnLine.Validate("Credit Amount", ElimQuery.Amount)
        else
            GenJnLine.Validate("Debit Amount", ElimQuery.Amount * -1);
        GenJnLine.Validate(Description, EliminationRuleHeader.Description);
        InsertDimension(GenJnLine, ElimQuery);
        GenJnLine.Insert();
    end;
    local procedure GetGLAccNo(): Code[20]begin
        if "Elimination Rule Line"."Account Specification" = "Elimination Rule Line"."Account Specification"::Source then begin
            "Elimination Rule Line".TestField("Source Account");
            exit("Elimination Rule Line"."Source Account");
        end;
        if "Elimination Rule Line"."Account Specification" = "Elimination Rule Line"."Account Specification"::"User Specified" then begin
            "Elimination Rule Line".TestField("Destination Account");
            exit("Elimination Rule Line"."Destination Account");
        end;
    end;
    local procedure GetLastLineNo(): Integer var
        GenJnLine: Record "Gen. Journal Line";
    begin
        GenJnLine.Reset();
        GenJnLine.SetRange("Journal Template Name", EliminationRuleHeader."Journal Template Name");
        GenJnLine.SetRange("Journal Batch Name", EliminationRuleHeader."Journal Name");
        if GenJnLine.FindLast()then exit(GenJnLine."Line No.");
    end;
    local procedure GetNoSeriesCode(): Code[20]var
        GenJnBatch: Record "Gen. Journal Batch";
    begin
        if GenJnBatch.Get(EliminationRuleHeader."Journal Template Name", EliminationRuleHeader."Journal Name")then exit(GenJnBatch."No. Series");
    end;
    local procedure InsertDimension(var GenJnLine: Record "Gen. Journal Line"; ElimQuery: Query "Elimination Query")
    var
        DimSetEntryTEMP: Record "Dimension Set Entry" temporary;
        DimMgmt: Codeunit DimensionManagement;
    begin
        if "Elimination Rule Line"."Dimension Specification" = "Elimination Rule Line"."Dimension Specification"::"User Specified" then begin
            DimMgmt.GetDimensionSet(DimSetEntryTEMP, "Elimination Rule Line"."Destination Dimension Set ID");
            GenJnLine."Dimension Set ID":=DimMgmt.GetDimensionSetID(DimSetEntryTEMP);
            InsertDimensionGJLine(GenJnLine, DimSetEntryTEMP);
        end;
        if "Elimination Rule Line"."Dimension Specification" = "Elimination Rule Line"."Dimension Specification"::Source then begin
            if "Elimination Rule Line"."Source Dimension Set ID" = 0 then begin
                GenJnLine.Validate("Shortcut Dimension 1 Code", ElimQuery.GlobalDimension1Code);
                GenJnLine.Validate("Shortcut Dimension 3 Code", ElimQuery.ShortcutDimension3Code_PB);
                GenJnLine.Validate("Shortcut Dimension 4 Code", ElimQuery.ShortcutDimension4Code_PB);
                GenJnLine.Validate("Shortcut Dimension 5 Code", ElimQuery.ShortcutDimension5Code_PB);
                GenJnLine.Validate("Shortcut Dimension 6 Code", ElimQuery.ShortcutDimension6Code_PB);
                GenJnLine.Validate("Shortcut Dimension 7 Code", ElimQuery.ShortcutDimension7Code_PB);
                GenJnLine.Validate("Shortcut Dimension 8 Code", ElimQuery.ShortcutDimension8Code_PB);
                GenJnLine.Validate("Shortcut Dimension 9 Code", ElimQuery.ShortcutDimension9Code_PB);
                GenJnLine.Validate("Shortcut Dimension 10 Code", ElimQuery.ShortcutDimension10Code_PB);
                GenJnLine.Validate("Shortcut Dimension 11 Code", ElimQuery.ShortcutDimension11Code_PB);
                GenJnLine.Validate("Shortcut Dimension 12 Code", ElimQuery.ShortcutDimension12Code_PB);
                GenJnLine.Validate("Shortcut Dimension 13 Code", ElimQuery.ShortcutDimension13Code_PB);
                GenJnLine.Validate("Shortcut Dimension 14 Code", ElimQuery.ShortcutDimension14Code_PB);
                GenJnLine.Validate("Shortcut Dimension 15 Code", ElimQuery.ShortcutDimension15Code_PB);
            end
            else
            begin
                DimMgmt.GetDimensionSet(DimSetEntryTEMP, "Elimination Rule Line"."Source Dimension Set ID");
                GenJnLine."Dimension Set ID":=DimMgmt.GetDimensionSetID(DimSetEntryTEMP);
                InsertDimensionGJLine(GenJnLine, DimSetEntryTEMP);
            end;
        end;
    end;
    local procedure InsertDimensionGJLine(var GJLine: Record "Gen. Journal Line"; var DimSetEntry: Record "Dimension Set Entry")
    var
        GLSetup: Record "General Ledger Setup";
    begin
        if GLSetup.get()then;
        DimSetEntry.Reset();
        if DimSetEntry.FindFirst()then repeat if GLSetup."Shortcut Dimension 1 Code" = DimSetEntry."Dimension Code" then GJLine.validate("Shortcut Dimension 1 Code", DimSetEntry."Dimension Value Code");
                if GLSetup."Shortcut Dimension 2 Code" = DimSetEntry."Dimension Code" then GJLine.validate("Shortcut Dimension 2 Code", DimSetEntry."Dimension Value Code");
                if GLSetup."Shortcut Dimension 3 Code" = DimSetEntry."Dimension Code" then GJLine.validate("Shortcut Dimension 3 Code", DimSetEntry."Dimension Value Code");
                if GLSetup."Shortcut Dimension 4 Code" = DimSetEntry."Dimension Code" then GJLine.validate("Shortcut Dimension 4 Code", DimSetEntry."Dimension Value Code");
                if GLSetup."Shortcut Dimension 5 Code" = DimSetEntry."Dimension Code" then GJLine.validate("Shortcut Dimension 5 Code", DimSetEntry."Dimension Value Code");
                if GLSetup."Shortcut Dimension 6 Code" = DimSetEntry."Dimension Code" then GJLine.validate("Shortcut Dimension 6 Code", DimSetEntry."Dimension Value Code");
                if GLSetup."Shortcut Dimension 7 Code" = DimSetEntry."Dimension Code" then GJLine.validate("Shortcut Dimension 7 Code", DimSetEntry."Dimension Value Code");
                if GLSetup."Shortcut Dimension 8 Code" = DimSetEntry."Dimension Code" then GJLine.validate("Shortcut Dimension 8 Code", DimSetEntry."Dimension Value Code");
                if GLSetup."Shortcut Dimension 9 Code" = DimSetEntry."Dimension Code" then GJLine.validate("Shortcut Dimension 9 Code", DimSetEntry."Dimension Value Code");
                if GLSetup."Shortcut Dimension 10 Code" = DimSetEntry."Dimension Code" then GJLine.validate("Shortcut Dimension 10 Code", DimSetEntry."Dimension Value Code");
                if GLSetup."Shortcut Dimension 11 Code" = DimSetEntry."Dimension Code" then GJLine.validate("Shortcut Dimension 11 Code", DimSetEntry."Dimension Value Code");
                if GLSetup."Shortcut Dimension 12 Code" = DimSetEntry."Dimension Code" then GJLine.validate("Shortcut Dimension 12 Code", DimSetEntry."Dimension Value Code");
                if GLSetup."Shortcut Dimension 13 Code" = DimSetEntry."Dimension Code" then GJLine.validate("Shortcut Dimension 13 Code", DimSetEntry."Dimension Value Code");
                if GLSetup."Shortcut Dimension 14 Code" = DimSetEntry."Dimension Code" then GJLine.validate("Shortcut Dimension 14 Code", DimSetEntry."Dimension Value Code");
                if GLSetup."Shortcut Dimension 15 Code" = DimSetEntry."Dimension Code" then GJLine.validate("Shortcut Dimension 15 Code", DimSetEntry."Dimension Value Code");
            until DimSetEntry.Next() = 0;
    end;
    local procedure SetQueryFilter(var ElimQuery: Query "Elimination Query")
    var
        DimSetEntry: Record "Dimension Set Entry";
        GLSetup: Record "General Ledger Setup";
    begin
        Clear(ElimQuery);
        GLSetup.get();
        DimSetEntry.Reset();
        if "Elimination Rule Line"."Source Dimension Set ID" <> 0 then begin
            DimSetEntry.SetRange("Dimension Set ID", "Elimination Rule Line"."Source Dimension Set ID");
            if DimSetEntry.FindFirst()then repeat if GLSetup."Shortcut Dimension 1 Code" = DimSetEntry."Dimension Code" then ElimQuery.SetRange(GlobalDimension1Code, DimSetEntry."Dimension Value Code");
                    if GLSetup."Shortcut Dimension 2 Code" = DimSetEntry."Dimension Code" then ElimQuery.SetRange(GlobalDimension2Code, DimSetEntry."Dimension Value Code");
                    if GLSetup."Shortcut Dimension 3 Code" = DimSetEntry."Dimension Code" then ElimQuery.SetRange(ShortcutDimension3Code_PB, DimSetEntry."Dimension Value Code");
                    if GLSetup."Shortcut Dimension 4 Code" = DimSetEntry."Dimension Code" then ElimQuery.SetRange(ShortcutDimension4Code_PB, DimSetEntry."Dimension Value Code");
                    if GLSetup."Shortcut Dimension 5 Code" = DimSetEntry."Dimension Code" then ElimQuery.SetRange(ShortcutDimension5Code_PB, DimSetEntry."Dimension Value Code");
                    if GLSetup."Shortcut Dimension 6 Code" = DimSetEntry."Dimension Code" then ElimQuery.SetRange(ShortcutDimension6Code_PB, DimSetEntry."Dimension Value Code");
                    if GLSetup."Shortcut Dimension 7 Code" = DimSetEntry."Dimension Code" then ElimQuery.SetRange(ShortcutDimension7Code_PB, DimSetEntry."Dimension Value Code");
                    if GLSetup."Shortcut Dimension 8 Code" = DimSetEntry."Dimension Code" then ElimQuery.SetRange(ShortcutDimension8Code_PB, DimSetEntry."Dimension Value Code");
                    if GLSetup."Shortcut Dimension 9 Code" = DimSetEntry."Dimension Code" then ElimQuery.SetRange(ShortcutDimension9Code_PB, DimSetEntry."Dimension Value Code");
                    if GLSetup."Shortcut Dimension 10 Code" = DimSetEntry."Dimension Code" then ElimQuery.SetRange(ShortcutDimension10Code_PB, DimSetEntry."Dimension Value Code");
                    if GLSetup."Shortcut Dimension 11 Code" = DimSetEntry."Dimension Code" then ElimQuery.SetRange(ShortcutDimension11Code_PB, DimSetEntry."Dimension Value Code");
                    if GLSetup."Shortcut Dimension 12 Code" = DimSetEntry."Dimension Code" then ElimQuery.SetRange(ShortcutDimension12Code_PB, DimSetEntry."Dimension Value Code");
                    if GLSetup."Shortcut Dimension 13 Code" = DimSetEntry."Dimension Code" then ElimQuery.SetRange(ShortcutDimension13Code_PB, DimSetEntry."Dimension Value Code");
                    if GLSetup."Shortcut Dimension 14 Code" = DimSetEntry."Dimension Code" then ElimQuery.SetRange(ShortcutDimension14Code_PB, DimSetEntry."Dimension Value Code");
                    if GLSetup."Shortcut Dimension 15 Code" = DimSetEntry."Dimension Code" then ElimQuery.SetRange(ShortcutDimension15Code_PB, DimSetEntry."Dimension Value Code");
                until DimSetEntry.Next() = 0;
        end;
        ElimQuery.SetRange(GLAccountNo, "Elimination Rule Line"."Source Account");
        ElimQuery.SetRange(PostingDate, g_dat_Start, g_dat_End);
    end;
    var g_cod_DocNo: Code[20];
}
