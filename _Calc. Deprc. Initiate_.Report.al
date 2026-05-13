report 50106 "Calc. Deprc. Initiate"
{
    AdditionalSearchTerms = 'write down fixed asset';
    ApplicationArea = All;
    Caption = 'Calculate Depreciation MultiCompany';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Companyloop; Company)
        {
            RequestFilterFields = Name;

            trigger OnAfterGetRecord()
            begin
                GenerateDeprLog();
                CheckandTransferJQ();
            end;
            trigger OnPostDataItem()
            var
            begin
            End;
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
        // OnBeforeOnInitReport(DeprBookCode);
        DeprCalcLog.Reset();
        If DeprCalcLog.FindLast()then NewEntryNo+=DeprCalcLog."Entry No." + 1
        else
            NewEntryNo:=1;
    end;
    trigger OnPreReport()
    begin
        // ActivateErrorMessageHandling("Fixed Asset");
        DeprBook.Get(DeprBookCode);
        if DeprUntilDate = 0D then Error(Text000, FAJnlLine.FieldCaption("FA Posting Date"));
        if PostingDate = 0D then PostingDate:=DeprUntilDate;
        if UseForceNoOfDays and (DaysInPeriod = 0)then Error(Text001);
        if DeprBook."Use Same FA+G/L Posting Dates" and (DeprUntilDate <> PostingDate)then Error(Text002, FAJnlLine.FieldCaption("FA Posting Date"), FAJnlLine.FieldCaption("Posting Date"), DeprBook.FieldCaption("Use Same FA+G/L Posting Dates"), false, DeprBook.TableCaption(), DeprBook.FieldCaption(Code), DeprBook.Code);
    // if GuiAllowed() then
    //     Window.Open(Text003 + Text004 + Text005);
    end;
    var FASetup: Record "FA Setup";
    FAJnlLine: Record "FA Journal Line";
    DeprBook: Record "Depreciation Book";
    ErrorMessageMgt: Codeunit "Error Message Management";
    ErrorMessageHandler: Codeunit "Error Message Handler";
    DeprUntilDateModified: Boolean;
    SuppressCommit: Boolean;
    DeprCalcLog: Record "Depr. Calc. Log";
    NewEntryNo: Integer;
    JQE: Record "Job Queue Entry";
    Text000: Label 'You must specify %1.';
    Text001: Label 'Force No. of Days must be activated.';
    Text002: Label '%1 and %2 must be identical. %3 must be %4 in %5 %6 = %7.';
    Text006: Label 'Use Force No. of Days must be activated.';
    protected var DeprBookCode: Code[10];
    DeprUntilDate: Date;
    UseForceNoOfDays: Boolean;
    DaysInPeriod: Integer;
    PostingDate: Date;
    DocumentNo: Code[20];
    PostingDescription: Text[100];
    BalAccount: Boolean;
    procedure InitializeRequest(DeprBookCodeFrom: Code[10]; DeprUntilDateFrom: Date; UseForceNoOfDaysFrom: Boolean; DaysInPeriodFrom: Integer; PostingDateFrom: Date; DocumentNoFrom: Code[20]; PostingDescriptionFrom: Text[100]; BalAccountFrom: Boolean)
    begin
        DeprBookCode:=DeprBookCodeFrom;
        DeprUntilDate:=DeprUntilDateFrom;
        UseForceNoOfDays:=UseForceNoOfDaysFrom;
        DaysInPeriod:=DaysInPeriodFrom;
        PostingDate:=PostingDateFrom;
        DocumentNo:=DocumentNoFrom;
        PostingDescription:=PostingDescriptionFrom;
        BalAccount:=BalAccountFrom;
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
    local procedure GenerateDeprLog()
    begin
        DeprCalcLog.Init();
        DeprCalcLog."Entry No.":=0;
        DeprCalcLog."Company Code":=Companyloop.Name;
        DeprCalcLog.DateTime:=CurrentDateTime;
        DeprCalcLog.DeprBookCode:=DeprBookCode;
        DeprCalcLog."User ID":=UserId;
        DeprCalcLog."FA Posting Date":=DeprUntilDate;
        DeprCalcLog."Use Force No Of Days":=UseForceNoOfDays;
        DeprCalcLog."Force No. Of Days":=DaysInPeriod;
        DeprCalcLog."Posting Date":=PostingDate;
        DeprCalcLog."Posting Desc":=PostingDescription;
        DeprCalcLog."Document No.":=DocumentNo;
        DeprCalcLog.BalAccount:=BalAccount;
        DeprCalcLog.Insert();
    end;
    local procedure CheckandTransferJQ()
    var
        JQE_l: Record "Job Queue Entry";
        JobQueueENtry: Record "Job Queue Entry";
        CurrentLanguage: Integer;
        Dimensions: Dictionary of[Text, Text];
        JobQueueEntriesCategoryTxt: Label 'AL JobQueueEntries', Locked = true;
        RunJobQueueOnceTxt: Label 'Running job queue once.', Locked = true;
        SuccessDispatcher: Boolean;
        SuccessErrorHandler: Boolean;
        JobQueueLogEntry: Record "Job Queue Log Entry";
        JQpage: page 673;
    begin
    /*
        JQE_l.Reset();
        JQE_l.ChangeCompany(Companyloop.Name);
        JQE_l.SetRange("Object Type to Run", JQE."Object Type to Run"::Report);
        JQE_l.SetRange("Object ID to Run", 50105);
        IF JQE_l.FindSet() then
            JQE_l.DeleteAll();

        JQE.ChangeCompany(Companyloop.Name);
        JQE.Init();
        JQE.ID := CreateGuid();
        JQE."Object Type to Run" := JQE."Object Type to Run"::Report;
        JQE.Validate("Object ID to Run", 50105);
        JQE."Recurring Job" := true;
        JQE.Status := JQE.Status::Ready;
        JQE."No. of Minutes between Runs" := 2;
        JQE.Validate("Run on Mondays", true);
        JQE.Validate("Run on Tuesdays", true);
        JQE.Validate("Run on Wednesdays", true);
        JQE.Validate("Run on Thursdays", true);
        JQE.Validate("Run on fridays", true);
        JQE.Validate("Run on Saturdays", true);
        JQE.Validate("Run on Sundays", true);
        JQE."Earliest Start Date/Time" := CurrentDateTime;
        JQE.insert;

        
        JQE.CalcFields(XML);
        JobQueueENtry.ChangeCompany(Companyloop.Name);
        JobQueueEntry := jqe;
        JobQueueEntry.ID := CreateGuid();
        JobQueueEntry."User ID" := copystr(UserId(), 1, MaxStrLen(JobQueueEntry."User ID"));
        JobQueueEntry."Recurring Job" := false;
        JobQueueEntry.Status := JobQueueEntry.Status::"Ready";
        JobQueueEntry."Job Queue Category Code" := '';
        clear(JobQueueEntry."Expiration Date/Time");
        clear(JobQueueEntry."System Task ID");
        JobQueueEntry.Insert(true);
        Commit();
        CurrentLanguage := GlobalLanguage();
        GlobalLanguage(1033);
        Dimensions.Add('Category', JobQueueEntriesCategoryTxt);
        Dimensions.Add('Id', Format(JobQueueEntry.ID, 0, 4));
        Dimensions.Add('ObjectType', Format(JobQueueEntry."Object Type to Run"));
        Dimensions.Add('ObjectId', Format(JobQueueEntry."Object ID to Run"));
        Dimensions.Add('Status', Format(JobQueueEntry.Status));
        Dimensions.Add('IsRecurring', Format(JobQueueEntry."Recurring Job"));
        Dimensions.Add('EarliestStartDateTime', Format(JobQueueEntry."Earliest Start Date/Time"));
        Dimensions.Add('CompanyName', JobQueueEntry.CurrentCompany());
        Session.LogMessage('0000FMG', RunJobQueueOnceTxt, Verbosity::Normal, DataClassification::OrganizationIdentifiableInformation, TelemetryScope::All, Dimensions);
        GlobalLanguage(CurrentLanguage);
        // Run the job queue
        SuccessDispatcher := Codeunit.run(Codeunit::"Job Queue Dispatcher", JobQueueEntry);
        // If JQ fails, run the error handler
        if not SuccessDispatcher then begin
            SuccessErrorHandler := Codeunit.run(Codeunit::"Job Queue Error Handler", JobQueueEntry);
            // If the error handler fails, save the error (Non-AL errors will automatically surface to end-user)
            // If it is unable to save the error (No permission etc), it should also just be surfaced to the end-user.
            if not SuccessErrorHandler then begin
                JobQueueLogEntry.ChangeCompany(Companyloop.Name);
                JobQueueEntry.SetError(GetLastErrorText());
                JobQueueEntry.InsertLogEntry(JobQueueLogEntry);
                JobQueueEntry.FinalizeLogEntry(JobQueueLogEntry, GetLastErrorCallStack());
                Commit();
            end;
        end;
        */
    end;
    procedure SetSuppressCommit(NewSuppressCommmit: Boolean)
    begin
        SuppressCommit:=NewSuppressCommmit;
    end;
}
