page 50197 "Apply G/L Entries PB"
{
    Caption = 'Apply General Ledger Entries';
    DataCaptionFields = "G/L Account No.";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    Permissions = tabledata "G/L Entry"=m;
    SourceTable = "G/L Entry";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field(TempApplyingGLEntryPostingDateField; TempGLEntry."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posting Date';
                    Editable = false;
                    ToolTip = 'Specifies the entry''s Posting Date.';
                }
                field(TempApplyingGLEntryDocumentTypeField; TempGLEntry."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Document Type';
                    Editable = false;
                    ToolTip = 'Specifies the original document type which will be applied.';
                }
                field(TempApplyingGLEntryDocumentNoField; TempGLEntry."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Document No.';
                    Editable = false;
                    ToolTip = 'Specifies the entry''s Document No.';
                }
                field(TempApplyingGLEntryGLAccountNoField; TempGLEntry."G/L Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'G/L Account No.';
                    Editable = false;
                    ToolTip = 'Specifies the number of the account that the entry has been posted to.';
                }
                field(TempApplyingGLEntryDescriptionField; TempGLEntry.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Description';
                    Editable = false;
                    ToolTip = 'Specifies the description of the entry.';
                }
                field(TempApplyingGLEntryAmountField; TempGLEntry.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Amount';
                    Editable = false;
                    ToolTip = 'Specifies the amount to apply.';
                }
                field(TempApplyingGLEntryOriginalAmountField; TempGLEntry."Original Amount PB")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Original Amount';
                    Editable = false;
                }
                field(TempApplyingGLEntryOriginalCurrField; TempGLEntry."Original Currency PB")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Original Currency';
                    Editable = false;
                }
                field(ApplyingRemainingAmountField; ApplyingRemainingAmount)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Remaining Amount';
                    Editable = false;
                    ToolTip = 'Specifies the remaining amount of general ledger entries';
                }
            }
            repeater(Lines)
            {
                ShowCaption = false;

                field("Applies-to ID"; Rec."Applies-to ID PB")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the ID to apply to the general ledger entry.';

                    trigger OnValidate()
                    begin
                        AppliestoIDOnAfterValidate();
                    end;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the date when the posting of the apply general ledger entries will be recorded.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the original document type which will be applied.';
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the entry''s Document No.';
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the account that the entry has been posted to.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the description of the entry to be applied.';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                }
                field("Original Currency"; Rec."Original Currency PB")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Original Amount"; Rec."Original Amount PB")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the amount of the entry.';
                }
                field("Remaining Amount (LCY) PB"; Rec."Remaining Amount (LCY) PB")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Amount to Apply LCY"; Rec."Amount to Apply (LCY) PB")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        AmounttoApplyLCYOnAfterValidate();
                    end;
                }
                field("Amount to Apply"; Rec."Amount to Apply PB")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the amount to apply.';

                    trigger OnValidate()
                    begin
                        AmounttoApplyOnAfterValidate();
                    end;
                }
                field("Applying Entry"; Rec."Applying Entry PB")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies that the general ledger entry is an applying entry.';
                    Visible = false;
                }
                field("Applied Amount"; Rec."Applied Amount PB")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the applied amount for the general ledger entry.';
                }
                field(RemainingAmountField; Remaining)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Remaining Amount';
                    ToolTip = 'Specifies the remaining amount of general ledger entries';
                    Visible = false;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the code for the Gen. Bus. Posting Group that applies to the entry.';
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the code for the Gen. Prod. Posting Group that applies to the entry.';
                    Visible = false;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies a VAT business posting group code.';
                    Visible = false;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies a VAT product posting group code for the VAT Statement.';
                    Visible = false;
                }
            }
            group(Amounts)
            {
                ShowCaption = false;

                fixed(AmountFields)
                {
                    ShowCaption = false;

                    group(AmmountToApply)
                    {
                        Caption = 'Amount to Apply';

                        field(ApplyingAmountField; ApplyingAmount)
                        {
                            ApplicationArea = Basic, Suite;
                            AutoFormatType = 1;
                            Caption = 'Amount to Apply';
                            Editable = false;
                            ShowCaption = false;
                            ToolTip = 'Specifies the apply amount for the general ledger entry.';
                        }
                    }
                    group(AvailableAmount)
                    {
                        Caption = 'Available Amount';

                        field(AvailableAmountField; AvailableAmount)
                        {
                            ApplicationArea = Basic, Suite;
                            AutoFormatType = 1;
                            Caption = 'Available Amount';
                            Editable = false;
                            ToolTip = 'Specifies the amount of the journal entry that you have selected as the applying entry.';
                        }
                    }
                    group(Balance)
                    {
                        Caption = 'Balance';

                        field(AvailableAmountPlusApplyingAmountField; AvailableAmount + ApplyingAmount)
                        {
                            ApplicationArea = Basic, Suite;
                            AutoFormatType = 1;
                            Caption = 'Balance';
                            Editable = false;
                            ToolTip = 'Specifies the description of the entry to be applied.';
                        }
                    }
                }
            }
        }
    }
    actions
    {
        area(navigation)
        {
            group(Entry)
            {
                Caption = 'Entry';

                action("Applied E&ntries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Applied E&ntries';
                    Image = Approve;
                    RunObject = Page "Applied GL Entries PB";
                    RunPageOnRec = true;
                    ToolTip = 'Specifies the apllied entries.';
                }
                action(Dimensions)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View the dimension sets that are set up for the entry.';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions();
                    end;
                }
                action("Detailed &Ledger Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Detailed &Ledger Entries';
                    Image = View;
                    RunObject = Page "Detailed G/L Entries PB";
                    RunPageLink = "G/L Entry No."=Field("Entry No.");
                    RunPageView = sorting("G/L Entry No.", "Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'Specifies the detailed ledger entries of the entry.';
                }
            }
            group(Application)
            {
                Caption = 'Application';

                action("Set Applying Entry")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Set Applying Entry';
                    Image = Line;
                    ShortCutKey = 'Shift+F11';
                    ToolTip = 'Sets applying entry';

                    trigger OnAction()
                    var
                        TEntryNo: Integer;
                    begin
                        if GenJnlLineApply then exit;
                        TEntryNo:=Rec."Entry No.";
                        if TempGLEntry."Entry No." <> 0 then RemoveApplyingGLEntry();
                        SetApplyingGLEntry(TEntryNo);
                    end;
                }
                action("Remove Applying Entry")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Remove Applying Entry';
                    Image = CancelLine;
                    ShortCutKey = 'Ctrl+F11';
                    ToolTip = 'Removes applying entry';

                    trigger OnAction()
                    begin
                        if GenJnlLineApply then exit;
                        RemoveApplyingGLEntry();
                    end;
                }
                action("Set Applies-to ID")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Set Applies-to ID';
                    Image = SelectLineToApply;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';
                    ToolTip = 'Sets applies to id';

                    trigger OnAction()
                    begin
                        // Message('%1..1', ApplGLEntryNo);
                        SetAppliesToID();
                    end;
                }
                action("Post Application")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post Application';
                    Ellipsis = true;
                    Image = PostApplication;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F9';
                    ToolTip = 'This batch job posts G/L entries application.';

                    trigger OnAction()
                    var
                        CompareOneGLEntry: Record "G/L Entry";
                        CompareTwoGLEntry: Record "G/L Entry";
                    begin
                        if CalcType <> CalcType::GenJnlLine then begin
                            if TempGLEntry."Entry No." <> 0 then begin
                                CompareTwoGLEntry.Get(TempGLEntry."Entry No.");
                                CompareTwoGLEntry.CalcFields("Applied Amount PB");
                                CompareTwoGLEntry.CalcFields("Applied Amount (LCY) PB"); //Sgarg-Added
                                Commit();
                                GLEntryPostApplicationCZA.PostApplyGLEntry(TempGLEntry);
                                //GLEntryPostApplicationCZA.PostApplyGLEntryOld(TempGLEntry);
                                CurrPage.Update(false);
                                CompareOneGLEntry.Get(TempGLEntry."Entry No.");
                                CompareOneGLEntry.CalcFields("Applied Amount PB");
                                if CompareTwoGLEntry."Applied Amount PB" <> CompareOneGLEntry."Applied Amount PB" then RemoveApplyingGLEntry();
                            //Tec-Sgarg- Added >>
                            //Commit();
                            // PostAndDeleteExchangeBatch();
                            //Tec-Sgarg- Added <<
                            end
                            else
                                Error(AppEntryNeedErr);
                        end
                        else
                            Error(AppFromWindowErr);
                    end;
                }
                action("Show Only Selected Entries to Be Applied")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show Only Selected Entries to Be Applied';
                    Image = ShowSelected;
                    ToolTip = 'View the selected ledger entries that will be applied to the specified record. ';

                    trigger OnAction()
                    begin
                        ShowAppliedEntries:=not ShowAppliedEntries;
                        if ShowAppliedEntries then Rec.SetRange("Applies-to ID PB", GLApplID)
                        else
                            Rec.SetRange("Applies-to ID PB");
                    end;
                }
            }
        }
        area(processing)
        {
            action(Navigate)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Find Entries';
                Image = Navigate;
                Ellipsis = true;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ShortCutKey = 'Ctrl+Alt+Q';
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';

                trigger OnAction()
                begin
                    PageNavigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                    PageNavigate.Run();
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Applied Amount PB");
        // Remaining := Rec.Amount - Rec."RIE Applied Amount";  //Sgarg - Commented
        Remaining:=Rec."Original Amount PB" - Rec."Applied Amount PB"; //Sgarg - Added
    end;
    trigger OnClosePage()
    var
        ApplyGLEntry: Record "G/L Entry";
    begin
        ShowAppliedEntries:=false;
        if not PostingDone then begin
            ApplyGLEntry:=TempGLEntry;
            if ApplyGLEntry.FindFirst()then GLEntryPostApplicationCZA.SetApplyingGLEntry(ApplyGLEntry, false, '');
        end;
    end;
    trigger OnOpenPage()
    var
        GLAccount: Record "G/L Account";
    begin
        GLAccount.Get(Rec.GetFilter("G/L Account No."));
        PostingDone:=false;
        if CalcType = CalcType::GenJnlLine then begin
            case ApplnType of ApplnType::"Applies-to Doc. No.": GLApplID:=GenJournalLine."Applies-to Doc. No.";
            ApplnType::"Applies-to ID": GLApplID:=GenJournalLine."Applies-to ID";
            end;
            CalcApplnAmount();
        end
        else
            FindApplyingGLEntry();
    end;
    var TempGLEntry: Record "G/L Entry" temporary;
    GLEntry: Record "G/L Entry";
    GenJournalLine: Record "Gen. Journal Line";
    GLEntryPostApplicationCZA: Codeunit "G/L Entry -Post App PB";
    PageNavigate: Page Navigate;
    ShowAppliedEntries: Boolean;
    ApplyingRemainingAmount: Decimal;
    ApplyingAmount: Decimal;
    AvailableAmount: Decimal;
    GLApplID: Code[50];
    Remaining: Decimal;
    ApplEntryNo: Integer;
    ApplGLEntryNo: Integer; //Sgarg
    PostingDone: Boolean;
    GenJnlLineApply: Boolean;
    ApplnType: Option " ", "Applies-to Doc. No.", "Applies-to ID";
    CalcType: Option Direct, GenJnlLine;
    AppEntryNeedErr: Label 'You must select an applying entry before posting the application.';
    AppFromWindowErr: Label 'You must post the application from the window where you entered the applying entry.';
    local procedure FindApplyingGLEntry()
    begin
        GLApplID:=CopyStr(UserId(), 1, MaxStrLen(GLApplID));
        if GLApplID = '' then GLApplID:='***';
        if ApplEntryNo <> 0 then begin
            SetApplyingGLEntry(ApplEntryNo);
            ApplEntryNo:=0;
        end
        else
        begin
            GLEntry.SetCurrentKey("G/L Account No.", "Posting Date");
            GLEntry.SetRange("G/L Account No.", Rec."G/L Account No.");
            GLEntry.SetRange("Applies-to ID PB", GLApplID);
            GLEntry.SetRange("Closed PB", false);
            GLEntry.SetRange("Applying Entry PB", true);
            if GLEntry.FindFirst()then SetApplyingGLEntry(GLEntry."Entry No.");
        end;
        CalcApplnAmount();
    end;
    local procedure SetApplyingGLEntry(EntryNo: Integer)
    begin
        Rec.Get(EntryNo);
        GLEntryPostApplicationCZA.SetApplyingGLEntry(Rec, true, GLApplID);
        //TEC-SGarg- Code commented >>
        /*  comment later as per dorothy requirement
        if Rec.Amount > 0 then
            Rec.SetFilter(Amount, '<0')
        else
            Rec.SetFilter(Amount, '>0');
        */
        //TEC-SGarg- Code commented <<
        //TEC-SGarg- Code Added >>
        // if rec."Original Amount PB" > 0 then
        //     Rec.SetFilter(rec."Original Amount PB", '<0')
        // else
        //     Rec.SetFilter(rec."Original Amount PB", '>0');
        //TEC-SGarg- Code Added >>
        Rec."Applying Entry PB":=true;
        Rec.Modify();
        TempGLEntry:=Rec;
        Rec.SetCurrentKey("Entry No.");
        Rec.SetFilter("Entry No.", '<> %1', Rec."Entry No.");
        // AvailableAmount := Rec."Original Amount PB" - Rec."Applied Amount PB"; //Sgarg- Added
        // ApplyingRemainingAmount := Rec."Original Amount PB" - Rec."Applied Amount PB"; //Sgarg- Added
        //   AvailableAmount := Rec.Amount - Rec."RIE Applied Amount"; //Sgarg - Commented
        //   ApplyingRemainingAmount := Rec.Amount - Rec."RIE Applied Amount"; //Sgarg - Commented
        AvailableAmount:=Rec."Amount" - rec."Applied Amount (LCY) PB"; //Sgarg- Added
        ApplyingRemainingAmount:=Rec."Amount" - rec."Applied Amount (LCY) PB"; //Sgarg- Added
        CalcApplnAmount();
        Rec.SetCurrentKey("G/L Account No.");
    end;
    local procedure RemoveApplyingGLEntry()
    begin
        if Rec.Get(TempGLEntry."Entry No.")then begin
            GLEntryPostApplicationCZA.SetApplyingGLEntry(Rec, false, '');
            Rec.SetRange(Amount);
            Rec."Applying Entry PB":=false;
            Rec.Modify();
            Clear(TempGLEntry);
            Rec.SetCurrentKey("Entry No.");
            Rec.SetRange("Entry No.");
            AvailableAmount:=0;
            ApplyingRemainingAmount:=0;
            CalcApplnAmount();
        end;
    end;
    local procedure SetAppliesToID()
    begin
        GLEntry.Reset();
        GLEntry.Copy(Rec);
        CurrPage.SetSelectionFilter(GLEntry);
        if GLEntry.FindSet(true)then repeat SetApplyingGLEntry(GLEntry, false, GLApplID);
            until GLEntry.Next() = 0;
        //TEC-Sgarg - Added>>
        //TEC-Sgarg - Added<<
        Rec:=GLEntry;
        CalcApplnAmount();
        CurrPage.Update(false);
    end;
    local procedure SetApplyingGLEntry(var GLEntry2: Record "G/L Entry"; IsApplyingEntry: Boolean; AppliesToID: Code[50])
    var
        IsHandled: Boolean;
    begin
        OnBeforeSetApplyingGLEntry(GLEntry2, IsApplyingEntry, AppliesToID, GLEntryPostApplicationCZA, IsHandled);
        if IsHandled then exit;
        //Message('%1..Entry No', ApplGLEntryNo);
        // ApplEntryNo
        GLEntryPostApplicationCZA.SetApplyingGLEntry(GLEntry2, false, GLApplID); //Sgarg - comment Standard code
    // GLEntryPostApplicationCZA.SetApplyingGLEntryNew(GLEntry2, false, GLApplID, ApplGLEntryNo);  //Sgarg - add new code calling new fxn
    end;
    local procedure CalcApplnAmount()
    begin
        ApplyingAmount:=0;
        GLEntry.Reset();
        GLEntry.Copy(Rec);
        GLEntry.SetRange("Applies-to ID PB", GLApplID);
        if GLEntry.FindSet()then repeat //   ApplyingAmount := ApplyingAmount + GLEntry."Amount to Apply PB";
                ApplyingAmount:=ApplyingAmount + GLEntry."Amount to Apply (LCY) PB";
            until GLEntry.Next() = 0;
    end;
    procedure CheckAppliesToID(var GLEntry2: Record "G/L Entry")
    begin
        if GLEntry2."Applies-to ID PB" <> '' then begin
            GLApplID:=CopyStr(UserId, 1, MaxStrLen(GLApplID));
            if GLApplID = '' then GLApplID:='***';
            GLEntry2.TestField("Applies-to ID PB", GLApplID);
        end;
    end;
    local procedure AppliestoIDOnAfterValidate()
    begin
        //  if (Rec."Applies-to ID PB" = GLApplID) and (Rec."Amount to Apply PB" = 0) then
        //      SetAppliesToID();
        if(Rec."Applies-to ID PB" = GLApplID) and (Rec."Amount to Apply (LCY) PB" = 0)then SetAppliesToID();
        if Rec."Applies-to ID PB" = '' then begin
            Rec."Applies-to ID PB":='';
            Rec."Amount to Apply PB":=0;
            rec."Amount to Apply (LCY) PB":=0; //Add later
            Rec.Modify();
        end;
    end;
    local procedure AmounttoApplyOnAfterValidate()
    begin
        if Rec."Amount to Apply PB" <> 0 then Rec."Applies-to ID PB":=GLApplID
        else
            Rec."Applies-to ID PB":='';
        Rec.Modify();
        CalcApplnAmount();
    end;
    local procedure AmounttoApplyLCYOnAfterValidate()
    begin
        if Rec."Amount to Apply (LCY) PB" <> 0 then Rec."Applies-to ID PB":=GLApplID
        else
            Rec."Applies-to ID PB":='';
        Rec.Modify();
        CalcApplnAmount();
    end;
    procedure SetAplEntry(ApplEntryNo1: Integer)
    begin
        ApplEntryNo:=ApplEntryNo1;
    end;
    //TEC-Sgarg>>
    procedure SetAplEntryNew(ApplEntryNo1: Integer)
    begin
        ApplGLEntryNo:=ApplEntryNo1;
    end;
    //TEC-Sgarg<<
    procedure SetGenJnlLine(NewGenJournalLine: Record "Gen. Journal Line"; ApplnTypeSelect: Integer)
    begin
        GenJournalLine:=NewGenJournalLine;
        GenJnlLineApply:=true;
        if GenJournalLine."Bal. Account Type" = GenJournalLine."Bal. Account Type"::"G/L Account" then ApplyingAmount:=-GenJournalLine.Amount;
        if GenJournalLine."Account Type" = GenJournalLine."Account Type"::"G/L Account" then ApplyingAmount:=GenJournalLine.Amount;
        CalcType:=CalcType::GenJnlLine;
        case ApplnTypeSelect of GenJournalLine.FieldNo("Applies-to Doc. No."): ApplnType:=ApplnType::"Applies-to Doc. No.";
        GenJournalLine.FieldNo("Applies-to ID"): ApplnType:=ApplnType::"Applies-to ID";
        end;
        TempGLEntry."Entry No.":=1;
        TempGLEntry."Posting Date":=GenJournalLine."Posting Date";
        TempGLEntry."Document Type":=GenJournalLine."Document Type";
        TempGLEntry."Document No.":=GenJournalLine."Document No.";
        TempGLEntry."G/L Account No.":=GenJournalLine."Account No.";
        TempGLEntry.Description:=GenJournalLine.Description;
        TempGLEntry.Amount:=GenJournalLine.Amount;
        TempGLEntry."Original Amount PB":=GenJournalLine.Amount; //TEC-Sgarg - Added
        TempGLEntry."Original Currency PB":=GenJournalLine."Currency Code"; //TEC-Sgarg -Aded
        ApplyingRemainingAmount:=GenJournalLine.Amount;
        CalcApplnAmount();
    end;
    procedure PostAndDeleteExchangeBatch()
    var
        GJL: Record "Gen. Journal Line";
        GPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        GJB: Record "Gen. Journal Batch";
    //Sgarg - Added
    begin
        GJL.Reset();
        GJL.SetRange("Journal Template Name", 'GENERAL');
        GJL.SetRange("Journal Batch Name", 'EXCHANGE');
        GJL.SetFilter("Account No.", '<>%1', '');
        IF GJL.FindSet()then GPostBatch.Run(GJL);
        IF GJB.get('GENERAL', 'EXCHANGE')then GJB.Delete();
    end;
    [IntegrationEvent(true, false)]
    local procedure OnBeforeSetApplyingGLEntry(var GLEntry: Record "G/L Entry"; IsApplyingEntry: Boolean; AppliesToID: Code[50]; var GLEntryPostApplicationCZA: Codeunit "G/L Entry -Post App PB"; var IsHandled: Boolean);
    begin
    end;
}
