report 50105 "Calc. Deprc. Multicompany"
{
    // AdditionalSearchTerms = 'write down fixed asset';
    // ApplicationArea = All;
    Caption = 'Calculate Depreciation Batch Process';
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            RequestFilterFields = "No.", "FA Class Code", "FA Subclass Code", "Budgeted Asset";

            //DataItemTableView = where("No." = const('0209-CA03-0IT063'));
            trigger OnAfterGetRecord()
            begin
                if Inactive or Blocked then CurrReport.Skip();
                // OnBeforeCalculateDepreciation(
                //     "No.", TempGenJnlLine, TempFAJnlLine, DeprAmount, NumberOfDays, DeprBookCode, DeprUntilDate, EntryAmounts, DaysInPeriod);
                CalculateDepr.Calculate(DeprAmount, Custom1Amount, NumberOfDays, Custom1NumberOfDays, "No.", DeprBookCode, DeprUntilDate, EntryAmounts, 0D, DaysInPeriod);
                if GuiAllowed()then if(DeprAmount <> 0) or (Custom1Amount <> 0)then Window.Update(1, "No.")
                    else
                        Window.Update(2, "No.");
                Custom1Amount:=Round(Custom1Amount, GeneralLedgerSetup."Amount Rounding Precision");
                DeprAmount:=Round(DeprAmount, GeneralLedgerSetup."Amount Rounding Precision");
                // OnAfterCalculateDepreciation(
                //     "No.", TempGenJnlLine, TempFAJnlLine, DeprAmount, NumberOfDays, DeprBookCode, DeprUntilDate, EntryAmounts, DaysInPeriod);
                if Custom1Amount <> 0 then if not DeprBook."G/L Integration - Custom 1" or "Budgeted Asset" then begin
                        //TempFAJnlLine.ChangeCompany(dcl."Company Code");
                        TempFAJnlLine."FA No.":="No.";
                        TempFAJnlLine."FA Posting Type":=TempFAJnlLine."FA Posting Type"::"Custom 1";
                        TempFAJnlLine.Amount:=Custom1Amount;
                        TempFAJnlLine."No. of Depreciation Days":=Custom1NumberOfDays;
                        TempFAJnlLine."FA Error Entry No.":=Custom1ErrorNo;
                        TempFAJnlLine."Line No.":=TempFAJnlLine."Line No." + 1;
                        TempFAJnlLine.Insert();
                    end
                    else
                    begin
                        //TempGenJnlLine.ChangeCompany(dcl."Company Code");
                        TempGenJnlLine."Account No.":="No.";
                        TempGenJnlLine."FA Posting Type":=TempGenJnlLine."FA Posting Type"::"Custom 1";
                        TempGenJnlLine.Amount:=Custom1Amount;
                        TempGenJnlLine."No. of Depreciation Days":=Custom1NumberOfDays;
                        TempGenJnlLine."FA Error Entry No.":=Custom1ErrorNo;
                        TempGenJnlLine."Line No.":=TempGenJnlLine."Line No." + 1;
                        TempGenJnlLine.Insert();
                    end;
                if DeprAmount <> 0 then if not DeprBook."G/L Integration - Depreciation" or "Budgeted Asset" then begin
                        //TempFAJnlLine.ChangeCompany(dcl."Company Code");
                        TempFAJnlLine."FA No.":="No.";
                        TempFAJnlLine."FA Posting Type":=TempFAJnlLine."FA Posting Type"::Depreciation;
                        TempFAJnlLine.Amount:=DeprAmount;
                        TempFAJnlLine."No. of Depreciation Days":=NumberOfDays;
                        TempFAJnlLine."FA Error Entry No.":=ErrorNo;
                        TempFAJnlLine."Line No.":=TempFAJnlLine."Line No." + 1;
                        TempFAJnlLine.Insert();
                    end
                    else
                    begin
                        //TempGenJnlLine.ChangeCompany(dcl."Company Code");
                        TempGenJnlLine."Account No.":="No.";
                        TempGenJnlLine."FA Posting Type":=TempGenJnlLine."FA Posting Type"::Depreciation;
                        TempGenJnlLine.Amount:=DeprAmount;
                        TempGenJnlLine."No. of Depreciation Days":=NumberOfDays;
                        TempGenJnlLine."FA Error Entry No.":=ErrorNo;
                        TempGenJnlLine."Line No.":=TempGenJnlLine."Line No." + 1;
                        TempGenJnlLine.Insert();
                    end;
            end;
            trigger OnPostDataItem()
            var
                NeedCommit: Boolean;
                CompMapping: Record "Company Name Mapping";
                RecordHasBeenRead: Boolean;
                FAJnlBatch: Record "FA Journal Batch";
                NoSeriesMgt: Codeunit "No. Series";
                DocumentNoNew: Code[20];
            begin
                //TempFAJnlLine.ChangeCompany(dcl."Company Code");
                if TempFAJnlLine.Find('-')then begin
                    NeedCommit:=true;
                    // CompMapping.GET(CompanyName);
                    // CompMapping.TestField("FA Journal Template");
                    // CompMapping.TestField("FA Journal Batch");
                    // FAJnlBatch.GET(CompMapping."FA Journal Template", CompMapping."FA Journal Batch");
                    // IF (FAJnlBatch."No. Series" <> '') AND NOT FIND('=><') THEN
                    //     DocumentNoNew := NoSeriesMgt.GetNextNo(FAJnlBatch."No. Series", PostingDate, FALSE);
                    // FAJnlLine.LockTable();
                    // FAJnlLine.SetRange("Journal Template Name", CompMapping."FA Journal Template");
                    // FAJnlLine.SetRange("Journal Batch Name", CompMapping."FA Journal Batch");
                    // if FAJnlLine.FindLast() then
                    //     AutoDocumentNo := FAJnlLine."Document No."
                    // else begin
                    //     IF (FAJnlBatch."No. Series" <> '') AND NOT FIND('=><') THEN
                    //         AutoDocumentNo := NoSeriesMgt.GetNextNo(FAJnlBatch."No. Series", PostingDate, FALSE);
                    // end;
                    //FAJnlLine.ChangeCompany(dcl."Company Code");
                    FAJnlLine.LOCKTABLE;
                    //FAJnlSetup.ChangeCompany(dcl."Company Code");
                    FAJnlSetup.FAJnlName(DeprBook, FAJnlLine, FAJnlNextLineNo);
                    NoSeries:=FAJnlSetup.GetFANoSeries(FAJnlLine);
                    IF DocumentNo = '' THEN IF FAJnlLine.findlast()then AutoDocumentNo:=FAJnlLine."Document No."
                        else
                            AutoDocumentNo:=FAJnlSetup.GetFAJnlDocumentNo(FAJnlLine, DeprUntilDate, TRUE)
                    ELSE
                        AutoDocumentNo:=DocumentNo;
                end;
                if TempFAJnlLine.Find('-')then repeat //  FAJnlLine.ChangeCompany(dcl."Company Code");
                        FAJnlLine.Init();
                        FAJnlLine."Line No.":=0;
                        // FAJnlSetup.ChangeCompany(dcl."Company Code");
                        FAJnlSetup.SetFAJnlTrailCodes(FAJnlLine);
                        LineNo:=LineNo + 1;
                        if GuiAllowed()then Window.Update(3, LineNo);
                        FAJnlLine."Posting Date":=PostingDate;
                        FAJnlLine."FA Posting Date":=DeprUntilDate;
                        if FAJnlLine."Posting Date" = FAJnlLine."FA Posting Date" then FAJnlLine."Posting Date":=0D;
                        FAJnlLine."FA Posting Type":=TempFAJnlLine."FA Posting Type";
                        FAJnlLine.Validate("FA No.", TempFAJnlLine."FA No.");
                        FAJnlLine."Document No.":=AutoDocumentNo;
                        FAJnlLine."Posting No. Series":=NoSeries;
                        FAJnlLine.Description:=PostingDescription;
                        FAJnlLine.Validate("Depreciation Book Code", DeprBookCode);
                        FAJnlLine.Validate(Amount, TempFAJnlLine.Amount);
                        FAJnlLine."No. of Depreciation Days":=TempFAJnlLine."No. of Depreciation Days";
                        FAJnlLine."FA Error Entry No.":=TempFAJnlLine."FA Error Entry No.";
                        FAJnlNextLineNo:=FAJnlNextLineNo + 10000;
                        FAJnlLine."Line No.":=FAJnlNextLineNo;
                        // OnBeforeFAJnlLineInsert(TempFAJnlLine, FAJnlLine);
                        FAJnlLine.Insert(true);
                        FAJnlLineCreatedCount+=1;
                    until TempFAJnlLine.Next() = 0;
                //TempGenJnlLine.ChangeCompany(dcl."Company Code");
                if TempGenJnlLine.Find('-')then begin
                    NeedCommit:=true;
                    //GenJnlLine.ChangeCompany(dcl."Company Code");
                    GenJnlLine.LockTable();
                    //FAJnlSetup.ChangeCompany(dcl."Company Code");
                    FAJnlSetup.GenJnlName(DeprBook, GenJnlLine, GenJnlNextLineNo);
                    FAJnlSetup.get(DeprBook.Code, '');
                    FAJnlSetup.TestField("Gen. Jnl. Template Name");
                    FAJnlSetup.TestField("Gen. Jnl. Batch Name");
                    GenJnlLine.reset;
                    GenJnlLine.SetRange("Journal Template Name", FAJnlSetup."Gen. Jnl. Template Name");
                    GenJnlLine.SetRange("Journal Batch Name", FAJnlSetup."Gen. Jnl. Batch Name");
                    if GenJnlLine.FindSet()then GenJnlLine.DeleteAll();
                    NoSeries:=FAJnlSetup.GetGenNoSeries(GenJnlLine);
                    GenJnlBatch.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
                    GenJnlBatch.TestField("Posting No. Series");
                /*
                    if DocumentNo = '' then
                        if GenJnlLine.FindLast() then
                            AutoDocumentNo := GenJnlLine."Document No."
                        else
                            AutoDocumentNo := FAJnlSetup.GetGenJnlDocumentNo(GenJnlLine, DeprUntilDate, true)
                    else
                        AutoDocumentNo := DocumentNo;
                        */
                end;
                DocNo:=0;
                if TempGenJnlLine.Find('-')then repeat //GenJnlLine.ChangeCompany(dcl."Company Code");
                        GenJnlLine.Init();
                        // OnBeforeGenJnlLineCreate(TempGenJnlLine, GenJnlLine);
                        GenJnlLine."Line No.":=0;
                        //FAJnlSetup.ChangeCompany(dcl."Company Code");
                        FAJnlSetup.SetGenJnlTrailCodes(GenJnlLine);
                        LineNo:=LineNo + 1;
                        if GuiAllowed()then Window.Update(3, LineNo);
                        GenJnlLine."Posting Date":=PostingDate;
                        GenJnlLine."FA Posting Date":=DeprUntilDate;
                        if GenJnlLine."Posting Date" = GenJnlLine."FA Posting Date" then GenJnlLine."FA Posting Date":=0D;
                        GenJnlLine."FA Posting Type":=TempGenJnlLine."FA Posting Type";
                        GenJnlLine."Account Type":=GenJnlLine."Account Type"::"Fixed Asset";
                        GenJnlLine.Validate("Account No.", TempGenJnlLine."Account No.");
                        GenJnlLine.Description:=PostingDescription;
                        //GenJnlLine."Document No." := NoSeiresCU.GetNextNo(GenJnlBatch."No. Series");
                        DocNo+=1;
                        AutoDocumentNo:=Format(DocNo);
                        GenJnlLine."Document No.":=AutoDocumentNo;
                        GenJnlLine."Posting No. Series":=GenJnlBatch."Posting No. Series";
                        GenJnlLine.Validate("Depreciation Book Code", DeprBookCode);
                        GenJnlLine.Validate(Amount, TempGenJnlLine.Amount);
                        GenJnlLine."No. of Depreciation Days":=TempGenJnlLine."No. of Depreciation Days";
                        GenJnlLine."FA Error Entry No.":=TempGenJnlLine."FA Error Entry No.";
                        GenJnlNextLineNo:=GenJnlNextLineNo + 1000;
                        GenJnlLine."Line No.":=GenJnlNextLineNo;
                        // OnBeforeGenJnlLineInsert(TempGenJnlLine, GenJnlLine);
                        GenJnlLine.Insert(true);
                        GenJnlLineCreatedCount+=1;
                        if BalAccount then FAInsertGLAcc.GetBalAcc(GenJnlLine, GenJnlNextLineNo);
                    // OnAfterFAInsertGLAccGetBalAcc(GenJnlLine, GenJnlNextLineNo, BalAccount, TempGenJnlLine);
                    //Clear(GenJnlPostBatch);
                    //CompanyMapping.Get(CompanyName);
                    //if CompanyMapping."Autopost Depreciation" then
                    //    GenJnlPostBatch.Run(GenJnlLine);
                    until TempGenJnlLine.Next() = 0;
                // OnAfterPostDataItem();
                if NeedCommit and not SuppressCommit then Commit();
            end;
            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
            //"Fixed Asset".ChangeCompany(dcl."Company Code");
            end;
        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(DepreciationBook; DeprBookCode)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Depreciation Book';
                        TableRelation = "Depreciation Book";
                        ToolTip = 'Specifies the code for the depreciation book to be included in the report or batch job.';
                    }
                    field(FAPostingDate; DeprUntilDate)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'FA Posting Date';
                        Importance = Additional;
                        ToolTip = 'Specifies the fixed asset posting date to be used by the batch job. The batch job includes ledger entries up to this date. This date appears in the FA Posting Date field in the resulting journal lines. If the Use Same FA+G/L Posting Dates field has been activated in the depreciation book that is used in the batch job, then this date must be the same as the posting date entered in the Posting Date field.';

                        trigger OnValidate()
                        begin
                            DeprUntilDateModified:=true;
                        end;
                    }
                    field(UseForceNoOfDays; UseForceNoOfDays)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Use Force No. of Days';
                        Importance = Additional;
                        ToolTip = 'Specifies if you want the program to use the number of days, as specified in the field below, in the depreciation calculation.';

                        trigger OnValidate()
                        begin
                            if not UseForceNoOfDays then DaysInPeriod:=0;
                        end;
                    }
                    field(ForceNoOfDays; DaysInPeriod)
                    {
                        ApplicationArea = FixedAssets;
                        BlankZero = true;
                        Caption = 'Force No. of Days';
                        Importance = Additional;
                        MinValue = 0;
                        ToolTip = 'Specifies if you want the program to use the number of days, as specified in the field below, in the depreciation calculation.';

                        trigger OnValidate()
                        begin
                            if not UseForceNoOfDays and (DaysInPeriod <> 0)then Error(Text006);
                        end;
                    }
                    field(PostingDate; PostingDate)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Posting Date';
                        ToolTip = 'Specifies the posting date to be used by the batch job.';

                        trigger OnValidate()
                        begin
                            if not DeprUntilDateModified then DeprUntilDate:=PostingDate;
                        end;
                    }
                    field(DocumentNo; DocumentNo)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Document No.';
                        ToolTip = 'Specifies, if you leave the field empty, the next available number on the resulting journal line. If a number series is not set up, enter the document number that you want assigned to the resulting journal line.';
                    }
                    field(PostingDescription; PostingDescription)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Posting Description';
                        ToolTip = 'Specifies the posting date to be used by the batch job as a filter.';
                    }
                    field(InsertBalAccount; BalAccount)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Insert Bal. Account';
                        Importance = Additional;
                        ToolTip = 'Specifies if you want the batch job to automatically insert fixed asset entries with balancing accounts.';
                    }
                }
            }
        }
        actions
        {
        }
        trigger OnOpenPage()
        var
            ClientTypeManagement: Codeunit "Client Type Management";
        begin
            BalAccount:=true;
            if ClientTypeManagement.GetCurrentClientType() <> CLIENTTYPE::Background then begin
                PostingDate:=WorkDate();
                DeprUntilDate:=WorkDate();
            end;
            if DeprBookCode = '' then begin
                FASetup.Get();
                DeprBookCode:=FASetup."Default Depr. Book";
            end;
        end;
    }
    labels
    {
    }
    trigger OnInitReport()
    begin
        DCL.Reset();
        DCL.SetRange("Company Code", CompanyName);
        DCL.SetRange("Depreciation Calculated", false);
        DCL.SetRange("Depreciation Posted", false);
        //dcl.setr
        IF DCL.Findlast()then begin
            InitializeRequest(DCL.DeprBookCode, DCL."FA Posting Date", dcl."Use Force No Of Days", DCL."Force No. Of Days", DCL."Posting Date", dcl."Document No.", dcl."Posting Desc", dcl.BalAccount, dcl."Entry No.");
        //message(dcl."Company Code", dcl."FA Posting Date");
        end
        else
        begin
            CurrReport.Quit();
        //Message('bye');
        end;
    // OnBeforeOnInitReport(DeprBookCode);
    end;
    trigger OnPostReport()
    var
        PageGenJnlLine: Record "Gen. Journal Line";
        PageFAJnlLine: Record "FA Journal Line";
        ConfirmMgt: Codeunit "Confirm Management";
        IsHandled: Boolean;
    begin
        if ErrorMessageHandler.HasErrors()then if ErrorMessageHandler.ShowErrors()then Error('');
        if GuiAllowed()then Window.Close();
        if(FAJnlLineCreatedCount = 0) and (GenJnlLineCreatedCount = 0)then begin
        //Message(CompletionStatsMsg);
        //exit;
        end;
        if(FAJnlLineCreatedCount > 0) or (GenJnlLineCreatedCount > 0)then begin
            DCL.Get(DCLEntryNo);
            DCL."Depreciation Calculated":=true;
            DCL.FAJnlLineCreatedCount:=FAJnlLineCreatedCount;
            DCL.GenJnlLineCreatedCount:=GenJnlLineCreatedCount;
            DCL.Modify();
        End;
        if FAJnlLineCreatedCount > 0 then begin
            IsHandled:=false;
            // OnPostReportOnBeforeConfirmShowFAJournalLines(DeprBook, FAJnlLine, FAJnlLineCreatedCount, IsHandled);
            if not IsHandled then if ConfirmMgt.GetResponse(StrSubstNo(CompletionStatsFAJnlQst, FAJnlLineCreatedCount), true)then begin
                    PageFAJnlLine.SetRange("Journal Template Name", FAJnlLine."Journal Template Name");
                    PageFAJnlLine.SetRange("Journal Batch Name", FAJnlLine."Journal Batch Name");
                    PageFAJnlLine.FindFirst();
                    PAGE.Run(PAGE::"Fixed Asset Journal", PageFAJnlLine);
                end;
        end;
        if GenJnlLineCreatedCount > 0 then begin
            IsHandled:=false;
            // OnPostReportOnBeforeConfirmShowGenJournalLines(DeprBook, GenJnlLine, GenJnlLineCreatedCount, IsHandled);
            if not IsHandled then begin
                CompanyMapping.Get(CompanyName);
                if CompanyMapping."Autopost Depreciation" then begin
                    //GenJnlLine.RenumberDocumentNo();
                    GenJnlPostBatch.Run(GenJnlLine);
                end;
            /*
                if ConfirmMgt.GetResponse(StrSubstNo(CompletionStatsGenJnlQst, GenJnlLineCreatedCount), true) then begin
                    PageGenJnlLine.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
                    PageGenJnlLine.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
                    PageGenJnlLine.FindFirst();
                    PAGE.Run(PAGE::"Fixed Asset G/L Journal", PageGenJnlLine);
                end;
                */
            end;
        end;
    // OnAfterOnPostReport();
    end;
    trigger OnPreReport()
    begin
        ActivateErrorMessageHandling("Fixed Asset");
        //DeprBook.ChangeCompany(dcl."Company Code");
        DeprBook.Get(DeprBookCode);
        if DeprUntilDate = 0D then Error(Text000, FAJnlLine.FieldCaption("FA Posting Date"));
        if PostingDate = 0D then PostingDate:=DeprUntilDate;
        if UseForceNoOfDays and (DaysInPeriod = 0)then Error(Text001);
        if DeprBook."Use Same FA+G/L Posting Dates" and (DeprUntilDate <> PostingDate)then Error(Text002, FAJnlLine.FieldCaption("FA Posting Date"), FAJnlLine.FieldCaption("Posting Date"), DeprBook.FieldCaption("Use Same FA+G/L Posting Dates"), false, DeprBook.TableCaption(), DeprBook.FieldCaption(Code), DeprBook.Code);
        if GuiAllowed()then Window.Open(Text003 + Text004 + Text005);
    end;
    var GenJnlLine: Record "Gen. Journal Line";
    CompanyMapping: Record "Company Name Mapping";
    TempGenJnlLine: Record "Gen. Journal Line" temporary;
    FASetup: Record "FA Setup";
    NoSeiresCU: Codeunit "No. Series";
    GenJnlBatch: Record "Gen. Journal Batch";
    FAJnlLine: Record "FA Journal Line";
    TempFAJnlLine: Record "FA Journal Line" temporary;
    DeprBook: Record "Depreciation Book";
    FAJnlSetup: Record "FA Journal Setup";
    GeneralLedgerSetup: Record "General Ledger Setup";
    CalculateDepr: Codeunit "Calculate Depreciation";
    FAInsertGLAcc: Codeunit "FA Insert G/L Account";
    ErrorMessageMgt: Codeunit "Error Message Management";
    ErrorContextElement: Codeunit "Error Context Element";
    ErrorMessageHandler: Codeunit "Error Message Handler";
    GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
    Window: Dialog;
    DeprAmount: Decimal;
    Custom1Amount: Decimal;
    NumberOfDays: Integer;
    Custom1NumberOfDays: Integer;
    AutoDocumentNo: Code[20];
    DocNo: Integer;
    NoSeries: Code[20];
    ErrorNo: Integer;
    Custom1ErrorNo: Integer;
    FAJnlNextLineNo: Integer;
    GenJnlNextLineNo: Integer;
    EntryAmounts: array[4]of Decimal;
    LineNo: Integer;
    FAJnlLineCreatedCount: Integer;
    GenJnlLineCreatedCount: Integer;
    DeprUntilDateModified: Boolean;
    SuppressCommit: Boolean;
    DCL: Record "Depr. Calc. Log";
    Text000: Label 'You must specify %1.';
    Text001: Label 'Force No. of Days must be activated.';
    Text002: Label '%1 and %2 must be identical. %3 must be %4 in %5 %6 = %7.';
    Text003: Label 'Depreciating fixed asset      #1##########\';
    Text004: Label 'Not depreciating fixed asset  #2##########\';
    Text005: Label 'Inserting journal lines       #3##########';
    Text006: Label 'Use Force No. of Days must be activated.';
    CompletionStatsMsg: Label 'The depreciation has been calculated.\\No journal lines were created.';
    CompletionStatsFAJnlQst: Label 'The depreciation has been calculated.\\%1 fixed asset journal lines were created.\\Do you want to open the Fixed Asset Journal window?', Comment = 'The depreciation has been calculated.\\5 fixed asset journal lines were created.\\Do you want to open the Fixed Asset Journal window?';
    CompletionStatsGenJnlQst: Label 'The depreciation has been calculated.\\%1 fixed asset G/L journal lines were created.\\Do you want to open the Fixed Asset G/L Journal window?', Comment = 'The depreciation has been calculated.\\2 fixed asset G/L  journal lines were created.\\Do you want to open the Fixed Asset G/L Journal window?';
    protected var DeprBookCode: Code[10];
    DeprUntilDate: Date;
    UseForceNoOfDays: Boolean;
    DaysInPeriod: Integer;
    PostingDate: Date;
    DocumentNo: Code[20];
    PostingDescription: Text[100];
    BalAccount: Boolean;
    DCLEntryNo: Integer;
    procedure InitializeRequest(DeprBookCodeFrom: Code[10]; DeprUntilDateFrom: Date; UseForceNoOfDaysFrom: Boolean; DaysInPeriodFrom: Integer; PostingDateFrom: Date; DocumentNoFrom: Code[20]; PostingDescriptionFrom: Text[100]; BalAccountFrom: Boolean; LogEntryNo: Integer)
    begin
        DeprBookCode:=DeprBookCodeFrom;
        DeprUntilDate:=DeprUntilDateFrom;
        UseForceNoOfDays:=UseForceNoOfDaysFrom;
        DaysInPeriod:=DaysInPeriodFrom;
        PostingDate:=PostingDateFrom;
        DocumentNo:=DocumentNoFrom;
        PostingDescription:=PostingDescriptionFrom;
        BalAccount:=BalAccountFrom;
        DCLEntryNo:=LogEntryNo;
    end;
    local procedure ActivateErrorMessageHandling(var FixedAsset: Record "Fixed Asset")
    var
        IsHandled: Boolean;
    begin
        IsHandled:=false;
        // OnBeforeActivateErrorMessageHandling(FixedAsset, ErrorMessageMgt, ErrorMessageHandler, ErrorContextElement, IsHandled);
        // if IsHandled then
        //     exit;
        if GuiAllowed then ErrorMessageMgt.Activate(ErrorMessageHandler);
    end;
    procedure SetSuppressCommit(NewSuppressCommmit: Boolean)
    begin
        SuppressCommit:=NewSuppressCommmit;
    end;
}
