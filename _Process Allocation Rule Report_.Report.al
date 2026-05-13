report 50158 "Process Allocation Rule Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Allocation Rule"; "Allocation Rule")
        {
            RequestFilterFields = Rule;

            trigger OnPreDataItem()
            var
                l_pag_ICJournal: Page "IC General Journal";
                l_pag_GenJnl: Page "General Journal";
                l_Rec_GenJnl: Record "Gen. Journal Line";
                l_cdu_JnlMgt: Codeunit GenJnlManagement;
                l_Rec_GenBatch: Record "Gen. Journal Batch";
                l_Cdu_Post: Codeunit 50190;
            begin
                SETRANGE(Active, TRUE);
                SETFILTER("Effective Date", '<=%1|%2', g_dat_RunDate, 0D);
                SETFILTER("Expiration Date", '>=%1|%2', g_dat_RunDate, 0D);
                SETFILTER("Date Last Run", '<=%1', g_dat_RunDate);
            end;
            trigger OnAfterGetRecord()
            var
                l_bol_Generatedata: Boolean;
                l_pag_OpenICJournal: Page "IC General Journal";
                l_pag_OpenJournal: Page "General Journal";
                l_Rec_GenJnl: Record "Gen. Journal Line";
                l_cdu_GenPost: Codeunit "Gen. Jnl.-Post Line";
                l_cdu_JnlMgt: Codeunit GenJnlManagement;
                l_Rec_GenBatch: Record "Gen. Journal Batch";
                l_Cdu_Post: Codeunit 50190;
            begin
                g_dat_EndDate:=g_dat_RunDate;
                case "Date Interval Code" OF //"Date Interval Code"::FY:
                //    g_dat_StartDate := CalcDate('<-1Y+1D>', g_dat_EndDate);
                //"Date Interval Code"::HY:
                //    g_dat_StartDate := CalcDate('<D1-5M>', g_dat_EndDate);
                "Date Interval Code"::YTD: g_dat_StartDate:=DMY2DATE(1, 1, DATE2DMY(g_dat_EndDate, 3));
                "Date Interval Code"::QTD: g_dat_StartDate:=CalcDate('<-2M>', CALCDATE('<CM+1D-1M>', g_dat_EndDate));
                "Date Interval Code"::MTD: g_dat_StartDate:=CALCDATE('<CM+1D-1M>', g_dat_EndDate);
                "Date Interval Code"::"As at Date": g_dat_StartDate:=0D;
                "Date Interval Code"::Min: begin
                    g_dat_StartDate:=CALCDATE('<CM+1D-1M>', g_dat_EndDate);
                    g_dat_MinFromDate:=CALCDATE('<-1M>', CALCDATE('<CM+1D-1M>', g_dat_EndDate));
                    g_dat_MinToDate:=CALCDATE('<CM>', g_dat_MinFromDate);
                end;
                END;
                case "Date Interval Code" of "Date Interval Code"::Min: begin
                    g_dat_StartDate:=0D;
                    g_dat_MinFromDate:=0D;
                end;
                end;
                CheckSetup(Rule); //Check Setup  
                case "Date Interval Code" of "Date Interval Code"::Min: begin
                    g_dat_StartDate:=CALCDATE('<CM+1D-1M>', g_dat_EndDate);
                    g_dat_MinFromDate:=CALCDATE('<-1M>', CALCDATE('<CM+1D-1M>', g_dat_EndDate));
                    g_dat_MinToDate:=CALCDATE('<CM>', g_dat_MinFromDate);
                end;
                end;
                IF g_dat_EndDate <= g_dat_RunDate then begin
                    CASE "Data Source" of "Data Source"::Ledger: GenerateRule_GLBased(g_dat_StartDate, g_dat_EndDate, Rule);
                    "Data Source"::"Fixed Value": GenerateRule_FixedValue(g_dat_EndDate, Rule);
                    END;
                    case "Date Interval Code" of "Date Interval Code"::Min: begin
                        g_dat_StartDate:=0D;
                        g_dat_MinFromDate:=0D;
                    end;
                    end;
                    CreateJournal_List(Rule);
                    IF "Allocation method" = "Allocation method"::Point then g_dat_RunDate:=CALCDATE('<CM>', g_dat_RunDate);
                    "Date Last Run":=g_dat_RunDate;
                    "Execute Run System Date":=TODAY;
                    MODIFY;
                    IF g_bol_Post = FALSE THEN begin
                        l_Rec_GenBatch.RESET;
                        l_Rec_GenBatch.SETRANGE("Journal Template Name", "Allocation Rule"."Journal Template Name");
                        l_Rec_GenBatch.SETRANGE(Name, "Allocation Rule"."Journal Batch Name");
                        IF l_Rec_GenBatch.FINDSET THEN l_cdu_JnlMgt.TemplateselectionFromBatch(l_Rec_GenBatch);
                    //TEC#001<<
                    end
                    ELSE
                    begin
                        l_Rec_GenJnl.RESET;
                        l_Rec_GenJnl.SETRANGE("Journal Batch Name", "Allocation Rule"."Journal Batch Name");
                        l_Rec_GenJnl.SetRange("Journal Template Name", "Allocation Rule"."Journal Template Name");
                        IF l_Rec_GenJnl.FINDSET THEN;
                        //TEC#001<<
                        IF l_Rec_GenJnl.Count > 0 THEN begin
                            l_Cdu_Post.Run(l_Rec_GenJnl);
                        //l_cdu_GenPost.RunWithCheck(l_Rec_GenJnl);
                        end
                        ELSE IF GuiAllowed THEN begin
                                MESSAGE('No record generated for posting');
                            end;
                    end;
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(g_dat_RunDate; g_dat_RunDate)
                    {
                        Caption = 'Run Date';
                        ApplicationArea = All;
                    }
                    field(g_dat_PostingDate; g_dat_PostingDate)
                    {
                        Caption = 'Posting Date';
                        ApplicationArea = All;
                    }
                    field(g_bol_Post; g_bol_Post)
                    {
                        Caption = 'Post';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
    procedure CreateJournal_List(RuleNo: Code[20])
    var
        l_rec_AllocationDestination: Record "Allocation Destination";
        l_Rec_AllocationDimension: Record "Allocation Default Dimension";
        l_cdu_NoSeries: Codeunit "No. Series";
        l_Rec_GLSEtup: Record "General Ledger Setup";
        l_Rec_GenJnlBatch: Record "Gen. Journal Batch";
        l_Rec_ICPartner: REcord "IC Partner";
        l_cod_DocNum: Code[20];
        l_cod_AccountNo: Code[20];
        l_dec_TransAmt: Decimal;
        l_cod_Dimensions: Array[15]OF Code[20];
        l_Cod_DestinationToAccount: Code[20];
        Template: Code[20];
        Batch: Code[20];
        l_dec_Value: Decimal;
        l_dec_ValueDivider: Decimal;
        l_Dec_RemainAmt: Decimal;
        l_dec_DestAmt: Decimal;
        l_int_Counter: integer;
        l_int_TotalCount: integer;
        l_Dec_MinAmt1: decimal;
        l_Dec_MinAmt2: decimal;
    begin
        Template:="Allocation Rule"."Journal Template Name";
        Batch:="Allocation Rule"."Journal Batch Name";
        IF g_dec_Denominator = 0 then begin
            CreateAllocationLog(Template, batch, RuleNo, 0, '', '', '', 0, l_cod_Dimensions, '', FALSE);
            EXIT;
        end;
        l_Rec_GenJnlBatch.ReSET;
        l_Rec_GenJnlBatch.SETRANGE("Journal Template Name", Template);
        l_Rec_GenJnlBatch.SETRANGE(Name, Batch);
        IF l_Rec_GenJnlBatch.FINDSET THEN;
        //l_cod_DocNum := l_Cdu_NoSeries.GetNextNo("Allocation Rule"."No. Series");
        g_Rec_GenJnlLineTemp.RESET;
        IF g_Rec_GenJnlLineTemp.FIND('-')THEN REPEAT IF l_Rec_GenJnlBatch."No. Series" <> '' THEN l_cod_DocNum:=l_Cdu_NoSeries.GetNextNo(l_Rec_GenJnlBatch."No. Series", g_dat_PostingDate)
                else
                    l_cod_DocNum:=l_Cdu_NoSeries.GetNextNo("Allocation Rule"."No. Series", g_dat_PostingDate);
                l_Dec_RemainAmt:=-g_Rec_GenJnlLineTemp.Amount;
                l_dec_DestAmt:=0;
                //Do Offset Entry
                l_cod_Dimensions[1]:=g_Rec_GenJnlLineTemp."Shortcut Dimension 1 Code";
                l_cod_Dimensions[2]:=g_Rec_GenJnlLineTemp."Shortcut Dimension 2 Code";
                l_cod_Dimensions[3]:=g_Rec_GenJnlLineTemp."Shortcut Dimension 3 Code";
                l_cod_Dimensions[4]:=g_Rec_GenJnlLineTemp."Shortcut Dimension 4 Code";
                l_cod_Dimensions[5]:=g_Rec_GenJnlLineTemp."Shortcut Dimension 5 Code";
                l_cod_Dimensions[6]:=g_Rec_GenJnlLineTemp."Shortcut Dimension 6 Code";
                l_cod_Dimensions[7]:=g_Rec_GenJnlLineTemp."Shortcut Dimension 7 Code";
                l_cod_Dimensions[8]:=g_Rec_GenJnlLineTemp."Shortcut Dimension 8 Code";
                l_cod_Dimensions[9]:=g_Rec_GenJnlLineTemp."Shortcut Dimension 9 Code";
                l_cod_Dimensions[10]:=g_Rec_GenJnlLineTemp."Shortcut Dimension 10 Code";
                l_cod_Dimensions[11]:=g_Rec_GenJnlLineTemp."Shortcut Dimension 11 Code";
                l_cod_Dimensions[12]:=g_Rec_GenJnlLineTemp."Shortcut Dimension 12 Code";
                l_cod_Dimensions[13]:=g_Rec_GenJnlLineTemp."Shortcut Dimension 13 Code";
                l_cod_Dimensions[14]:=g_Rec_GenJnlLineTemp."Shortcut Dimension 14 Code";
                l_cod_Dimensions[15]:=g_Rec_GenJnlLineTemp."Shortcut Dimension 15 Code";
                l_dec_TransAmt:=-g_Rec_GenJnlLineTemp.Amount;
                l_cod_AccountNo:=g_Rec_GenJnlLineTemp."Account No.";
                l_Cod_DestinationToAccount:=l_cod_AccountNo;
                CreateJournal(Template, Batch, RUleNo, g_int_LogHdrLineNo, l_cod_DocNum, FALSE, l_cod_AccountNo, g_Rec_GenJnlLineTemp."Currency Code", l_dec_TransAmt, l_cod_Dimensions, '', TRUE, "Allocation Rule".Description);
                l_int_Counter:=1;
                l_rec_AllocationDestination.RESET;
                l_rec_AllocationDestination.SETRANGE(Rule, RuleNo);
                IF l_rec_AllocationDestination.FINDSET THEN begin
                    l_int_TotalCount:=l_rec_AllocationDestination.Count;
                    repeat IF l_Rec_GLSEtup.FIND('-')THEN;
                        //Convert Dimension
                        //Rajan start
                        //OverwriteDimensions(l_cod_Dimensions, False);
                        OverwriteDimensions(l_cod_Dimensions, true);
                        GenICDimensions(l_cod_ICDimensions, l_rec_AllocationDestination.Company, l_rec_AllocationDestination."To Account"); // for IC Dimensions
                        //Rajan End
                        IF l_rec_AllocationDestination."To Account" <> '' THEN l_Cod_DestinationToAccount:=l_rec_AllocationDestination."To Account";
                        CASE "Allocation Rule"."Allocation method" of "Allocation Rule"."Allocation method"::Percentage: l_dec_Value:=l_rec_AllocationDestination."Fixed Percentage";
                        "Allocation Rule"."Allocation method"::Weight: l_dec_Value:=l_rec_AllocationDestination."Fixed Weight";
                        "Allocation Rule"."Allocation method"::Ratio: l_Dec_Value:=GetDestinationRatio(l_rec_AllocationDestination.Rule, l_rec_AllocationDestination.Company, l_rec_AllocationDestination."To Account", false);
                        "Allocation Rule"."Allocation method"::Point: l_dec_Value:=GetDestinationPoints(l_rec_AllocationDestination.Rule, l_rec_AllocationDestination.Company, l_rec_AllocationDestination."To Account", false);
                        "Allocation Rule"."Allocation method"::OperatingDaysXRatio: l_Dec_Value:=GetDestinationOperatingDaysXPoints(l_rec_AllocationDestination.Rule, l_rec_AllocationDestination.Company, l_rec_AllocationDestination."To Account");
                        END;
                        IF "Allocation Rule"."Date Interval Code" = "Allocation Rule"."Date Interval Code"::Min THEN begin
                            l_Dec_MinAmt1:=l_Dec_Value;
                            l_Dec_MinAmt2:=GetDestinationRatio(l_rec_AllocationDestination.Rule, l_rec_AllocationDestination.Company, l_rec_AllocationDestination."To Account", true);
                            l_dec_Value:=(l_Dec_MinAmt1 + l_Dec_MinAmt2) / 2;
                        end;
                        IF l_rec_AllocationDestination."Same as Source" THEN l_Cod_DestinationToAccount:=g_Rec_GenJnlLineTemp."Account No.";
                        l_dec_ValueDivider:=g_dec_Denominator;
                        IF l_dec_ValueDivider <> 0 THEN begin
                            l_rec_AllocationDestination."Last Destination Amount get":=l_dec_Value;
                            l_rec_AllocationDestination."Last Destination Factor Amt":=l_dec_ValueDivider;
                            IF "Allocation Rule"."Allocation method" = "Allocation Rule"."Allocation method"::Ratio THEN l_rec_AllocationDestination."Last Destination Ratio":=l_dec_Value / l_dec_ValueDivider;
                            IF "Allocation Rule"."Allocation method" = "Allocation Rule"."Allocation method"::Point THEN l_rec_AllocationDestination."Last Destination PointXDays":=l_dec_Value;
                            IF "Allocation Rule"."Date Interval Code" = "Allocation Rule"."Date Interval Code"::Min THEN begin
                                l_rec_AllocationDestination."Last Min Curr. Period Amt":=l_Dec_MinAmt1;
                                l_rec_AllocationDestination."Last Min Prev. Period Amt":=l_Dec_MinAmt2;
                            end;
                            l_rec_AllocationDestination.MODIFY;
                            l_dec_TransAmt:=ROUND(g_Rec_GenJnlLineTemp.Amount * l_dec_Value / l_dec_ValueDivider, l_Rec_GLSEtup."Amount Rounding Precision");
                            l_dec_DestAmt+=l_dec_TransAmt;
                            IF l_int_Counter = l_int_TotalCount THEN begin
                                l_dec_TransAmt+=-(-g_Rec_GenJnlLineTemp.Amount + l_dec_DestAmt);
                            end;
                            l_int_Counter+=1;
                            IF "Allocation Rule"."Intercompany Rule" = FALSE THEN begin
                                CreateJournal(Template, Batch, RUleNo, g_int_LogHdrLineNo, l_cod_DocNum, FALSE, l_Cod_DestinationToAccount, g_Rec_GenJnlLineTemp."Currency Code", l_dec_TransAmt, l_cod_Dimensions, l_Cod_DestinationToAccount, FALSE, "Allocation Rule".Description);
                            end
                            ELSE
                            begin
                                IF l_rec_AllocationDestination."Current Company" THEN begin
                                    CreateJournal(Template, Batch, RUleNo, g_int_LogHdrLineNo, l_cod_DocNum, FALSE, l_Cod_DestinationToAccount, g_Rec_GenJnlLineTemp."Currency Code", l_dec_TransAmt, l_cod_Dimensions, l_Cod_DestinationToAccount, FALSE, "Allocation Rule".Description); //Current Company
                                end
                                ELSE
                                begin
                                    l_Rec_ICPartner.RESET;
                                    l_Rec_ICPartner.SETRANGE("Code", l_rec_AllocationDestination.Company);
                                    IF l_Rec_ICPartner.FINDSET THEN begin
                                        IF(l_Rec_ICPartner."Inbox Details" = CompanyName) OR (l_Rec_ICPartner."Inbox Details" = '')THEN begin
                                            CreateJournal(Template, Batch, RUleNo, g_int_LogHdrLineNo, l_cod_DocNum, FALSE, l_Cod_DestinationToAccount, g_Rec_GenJnlLineTemp."Currency Code", l_dec_TransAmt, l_cod_Dimensions, l_Cod_DestinationToAccount, FALSE, "Allocation Rule".Description); //Current Company
                                        end
                                        ELSE
                                        begin
                                            l_cod_AccountNo:=l_Rec_ICPartner.Code;
                                            CreateJournal(Template, Batch, RUleNo, g_int_LogHdrLineNo, l_cod_DocNum, TRUE, l_cod_AccountNo, g_Rec_GenJnlLineTemp."Currency Code", l_dec_TransAmt, l_cod_Dimensions, l_Cod_DestinationToAccount, FALSE, "Allocation Rule".Description);
                                        End;
                                    end;
                                end;
                            end;
                        end;
                    UNTIL l_REc_AllocationDestination.NEXT = 0;
                end;
            UNTIL g_Rec_GenJnlLineTemp.NEXT = 0;
    end;
    procedure CreateJournal(Template: Code[20]; Batch: Code[20]; RuleNo: Code[20]; RuleLineNo: Integer; DocNum: Code[20]; ISICType: Boolean; AccountNo: Code[20]; CurCode: Code[20]; Amt: Decimal; Dimensions: Array[15]OF Code[20]; ToAccount: Code[20]; IsOffset: Boolean; OverWriteDesc: Text)
    var
        l_Rec_GenJnl: Record "Gen. Journal Line";
        l_int_LineNo: Integer;
        l_Rec_GLS: Record "General Ledger Setup";
    BEGIN
        g_int_LogHdrLineNo:=CreateAllocationLog(Template, Batch, RuleNo, RuleLineNo, AccountNo, DocNum, CurCode, Amt, Dimensions, ToAccount, IsOffset);
        IF Amt = 0 then EXIT;
        l_Rec_GenJnl.RESET;
        l_Rec_GenJnl.SETRANGE("Journal Template Name", Template);
        l_Rec_GenJnl.SETRANGE("Journal Batch Name", Batch);
        IF l_Rec_GenJnl.FINDLAST then l_int_LineNo:=l_Rec_GenJnl."Line No.";
        l_int_LineNo+=10000;
        l_Rec_GenJnl.RESET;
        l_Rec_GenJnl.INIT;
        l_Rec_GenJnl."Journal Template Name":=Template;
        l_Rec_GenJnl."Journal Batch Name":=Batch;
        l_Rec_GenJnl."Document No.":=DocNum;
        l_Rec_GenJnl."Line No.":=l_int_LineNo;
        l_Rec_GenJnl.INSERT;
        IF ISICType = false then l_Rec_GenJnl."Account Type":=l_Rec_GenJnl."Account Type"::"G/L Account"
        ELSE
            l_Rec_GenJnl."Account Type":=l_Rec_GenJnl."Account Type"::"IC Partner";
        l_Rec_GenJnl.VALIDATE("Account No.", AccountNo);
        l_Rec_GenJnl.VALIDATE("Posting Date", g_dat_PostingDate);
        //l_Rec_GenJnl.VALIDATE("Currency Code", CurCode);
        IF l_Rec_GLS.GET THEN;
        IF l_Rec_GLS."LCY Code" <> '' THEN l_Rec_GenJnl.VALIDATE("Currency Code", l_Rec_GLS."LCY Code"); //#003
        l_Rec_GenJnl.VALIDATE(Amount, Amt);
        IF IsOffset THEN l_Rec_GenJnl."IC Account No.":=AccountNo
        else
            l_Rec_GenJnl."IC Account No.":='';
        //l_Rec_GenJnl."IC Account No." := ToAccount;
        l_Rec_GenJnl.VALIDATE("PB IC Account", ToAccount);
        l_Rec_GenJnl."Alloc. Rule":=RuleNo;
        l_Rec_GenJnl."Rule Line No.":=g_int_LogHdrLineNo;
        IF OverWriteDesc <> '' THEN l_Rec_GenJnl.Description:=OverWriteDesc;
        l_Rec_GenJnl."PB IC Journal Batch Name":=Batch;
        l_Rec_GenJnl."PB IC Journal Template Name":=Template;
        IF DImensions[1] <> '' THEN l_Rec_GenJnl.VALIDATE("Shortcut Dimension 1 Code", Dimensions[1]);
        IF DImensions[2] <> '' THEN l_Rec_GenJnl.VALIDATE("Shortcut Dimension 2 Code", Dimensions[2]);
        IF DImensions[3] <> '' THEN l_Rec_GenJnl.VALIDATE("Shortcut Dimension 3 Code", Dimensions[3]);
        IF DImensions[4] <> '' THEN l_Rec_GenJnl.VALIDATE("Shortcut Dimension 4 Code", Dimensions[4]);
        IF DImensions[5] <> '' THEN l_Rec_GenJnl.VALIDATE("Shortcut Dimension 5 Code", Dimensions[5]);
        IF DImensions[6] <> '' THEN l_Rec_GenJnl.VALIDATE("Shortcut Dimension 6 Code", Dimensions[6]);
        IF DImensions[7] <> '' THEN l_Rec_GenJnl.VALIDATE("Shortcut Dimension 7 Code", Dimensions[7]);
        IF DImensions[8] <> '' THEN l_Rec_GenJnl.VALIDATE("Shortcut Dimension 8 Code", Dimensions[8]);
        IF DImensions[9] <> '' THEN l_Rec_GenJnl.VALIDATE("Shortcut Dimension 9 Code", Dimensions[9]);
        IF DImensions[10] <> '' THEN l_Rec_GenJnl.VALIDATE("Shortcut Dimension 10 Code", Dimensions[10]);
        IF DImensions[11] <> '' THEN l_Rec_GenJnl.VALIDATE("Shortcut Dimension 11 Code", Dimensions[11]);
        IF DImensions[12] <> '' THEN l_Rec_GenJnl.VALIDATE("Shortcut Dimension 12 Code", Dimensions[12]);
        IF DImensions[13] <> '' THEN l_Rec_GenJnl.VALIDATE("Shortcut Dimension 13 Code", Dimensions[13]);
        IF DImensions[14] <> '' THEN l_Rec_GenJnl.VALIDATE("Shortcut Dimension 14 Code", Dimensions[14]);
        IF DImensions[15] <> '' THEN l_Rec_GenJnl.VALIDATE("Shortcut Dimension 15 Code", Dimensions[15]);
        //TEC#003>>
        if l_Rec_GenJnl."Account Type" = l_Rec_GenJnl."Account Type"::"IC Partner" then begin
            l_Rec_GenJnl.VALIDATE("IC Dimension 1", l_cod_ICDimensions[1]);
            l_Rec_GenJnl.VALIDATE("IC Dimension 2", l_cod_ICDimensions[2]);
            l_Rec_GenJnl.VALIDATE("IC Dimension 3", l_cod_ICDimensions[3]);
            l_Rec_GenJnl.VALIDATE("IC Dimension 4", l_cod_ICDimensions[4]);
            l_Rec_GenJnl.VALIDATE("IC Dimension 5", l_cod_ICDimensions[5]);
            l_Rec_GenJnl.VALIDATE("IC Dimension 6", l_cod_ICDimensions[6]);
            l_Rec_GenJnl.VALIDATE("IC Dimension 7", l_cod_ICDimensions[7]);
            l_Rec_GenJnl.VALIDATE("IC Dimension 8", l_cod_ICDimensions[8]);
            l_Rec_GenJnl.VALIDATE("IC Dimension 9", l_cod_ICDimensions[9]);
            l_Rec_GenJnl.VALIDATE("IC Dimension 10", l_cod_ICDimensions[10]);
            l_Rec_GenJnl.VALIDATE("IC Dimension 11", l_cod_ICDimensions[11]);
            l_Rec_GenJnl.VALIDATE("IC Dimension 12", l_cod_ICDimensions[12]);
        //l_Rec_GenJnl.VALIDATE("IC Dimension 13", l_cod_ICDimensions[13]);
        //l_Rec_GenJnl.VALIDATE("IC Dimension 14", l_cod_ICDimensions[14]);
        //l_Rec_GenJnl.VALIDATE("IC Dimension 15", l_cod_ICDimensions[15]);
        end; //TEC#003<<
        //IF DImensions[11] <> '' THEN l_Rec_GenJnl.VALIDATE("IC Dimension 11", Dimensions[11]);
        //IF DImensions[12] <> '' THEN l_Rec_GenJnl.VALIDATE("IC Dimension 12", Dimensions[12]);
        //IF DImensions[13] <> '' THEN l_Rec_GenJnl.VALIDATE("IC Dimension 13", Dimensions[13]);
        //IF DImensions[14] <> '' THEN l_Rec_GenJnl.VALIDATE("IC Dimension 14", Dimensions[14]);
        //IF DImensions[15] <> '' THEN l_Rec_GenJnl.VALIDATE("IC Dimension 15", Dimensions[15]);
        /*
        IF DImensions[3] <> '' THEN l_Rec_GenJnl.VALIDATE("Shortcut Dimension 3 Code", Dimensions[3]);
        IF DImensions[4] <> '' THEN l_Rec_GenJnl.VALIDATE("Shortcut Dimension 4 Code", Dimensions[4]);
        IF DImensions[5] <> '' THEN l_Rec_GenJnl.VALIDATE("Shortcut Dimension 5 Code", Dimensions[5]);
        IF DImensions[6] <> '' THEN l_Rec_GenJnl.VALIDATE("Shortcut Dimension 6 Code", Dimensions[6]);
        IF DImensions[7] <> '' THEN l_Rec_GenJnl.VALIDATE("Shortcut Dimension 7 Code", Dimensions[7]);
        IF DImensions[8] <> '' THEN l_Rec_GenJnl.VALIDATE("Shortcut Dimension 8 Code", Dimensions[8]);
        
        IF DImensions[9] <> '' THEN l_Rec_GenJnl.VALIDATE("Shortcut Dimension 9 Code", Dimensions[9]);
        IF DImensions[10] <> '' THEN l_Rec_GenJnl.VALIDATE("Shortcut Dimension 10 Code", Dimensions[10]);
        IF DImensions[11] <> '' THEN l_Rec_GenJnl.VALIDATE("Shortcut Dimension 11 Code", Dimensions[11]);
        IF DImensions[12] <> '' THEN l_Rec_GenJnl.VALIDATE("Shortcut Dimension 12 Code", Dimensions[12]);
        IF DImensions[13] <> '' THEN l_Rec_GenJnl.VALIDATE("Shortcut Dimension 13 Code", Dimensions[13]);
        IF DImensions[14] <> '' THEN l_Rec_GenJnl.VALIDATE("Shortcut Dimension 14 Code", Dimensions[14]);
        IF DImensions[15] <> '' THEN l_Rec_GenJnl.VALIDATE("Shortcut Dimension 15 Code", Dimensions[15]);
        */
        l_Rec_GenJnl.Modify;
    end;
    //Gather Data from Fixed Value
    procedure GenerateRule_FixedValue(PostingDate: Date; RuleNo: Code[20])
    var
        l_Rec_AllocationRuleSource: Record "Allocation Source";
        l_Rec_GLSetup: Record "General Ledger Setup";
        l_Rec_SourceDim: array[20]of Code[20];
    begin
        IF l_Rec_GLSetup.FIND('-')THEN;
        IF "Allocation Rule"."Offset Dimension From" = "Allocation Rule"."Offset Dimension From"::"User Specified" THEN OverwriteDimensions(l_Rec_SourceDim, TRUE);
        g_Rec_GenJnlLineTemp.RESET;
        g_Rec_GenJnlLineTemp.INIT;
        g_Rec_GenJnlLineTemp."Line No.":=10000;
        g_Rec_GenJnlLineTemp."Posting Date":=g_dat_PostingDate;
        g_Rec_GenJnlLineTemp."Account No.":="Allocation Rule"."Offset Account No.";
        g_Rec_GenJnlLineTemp.Amount:="Allocation Rule"."Fixed Amount";
        g_Rec_GenJnlLineTemp."Shortcut Dimension 1 Code":=l_Rec_SourceDim[1];
        g_Rec_GenJnlLineTemp."Shortcut Dimension 2 Code":=l_Rec_SourceDim[2];
        g_Rec_GenJnlLineTemp."Shortcut Dimension 3 Code":=l_Rec_SourceDim[3];
        g_Rec_GenJnlLineTemp."Shortcut Dimension 4 Code":=l_Rec_SourceDim[4];
        g_Rec_GenJnlLineTemp."Shortcut Dimension 5 Code":=l_Rec_SourceDim[5];
        g_Rec_GenJnlLineTemp."Shortcut Dimension 6 Code":=l_Rec_SourceDim[6];
        g_Rec_GenJnlLineTemp."Shortcut Dimension 7 Code":=l_Rec_SourceDim[7];
        g_Rec_GenJnlLineTemp."Shortcut Dimension 8 Code":=l_Rec_SourceDim[8];
        g_Rec_GenJnlLineTemp."Shortcut Dimension 9 Code":=l_Rec_SourceDim[9];
        g_Rec_GenJnlLineTemp."Shortcut Dimension 10 Code":=l_Rec_SourceDim[10];
        g_Rec_GenJnlLineTemp."Shortcut Dimension 11 Code":=l_Rec_SourceDim[11];
        g_Rec_GenJnlLineTemp."Shortcut Dimension 12 Code":=l_Rec_SourceDim[12];
        g_Rec_GenJnlLineTemp."Shortcut Dimension 13 Code":=l_Rec_SourceDim[13];
        g_Rec_GenJnlLineTemp."Shortcut Dimension 14 Code":=l_Rec_SourceDim[14];
        g_Rec_GenJnlLineTemp."Shortcut Dimension 15 Code":=l_Rec_SourceDim[15];
        g_Rec_GenJnlLineTemp.INSERT;
    end;
    //Gather Data from G/L Entry
    procedure GenerateRule_GLBased(FromDate: Date; ToDate: Date; RuleNo: Code[20])
    var
        l_Rec_AllocationRuleSource: Record "Allocation Source";
        l_Rec_GLSetup: Record "General Ledger Setup";
        l_Rec_SourceDimCode: array[20]of Code[20];
        l_Rec_SourceDimValue: array[20]of Text;
        l_Dec_MarkupRatio: Decimal;
        l_Dec_Amount: Decimal;
    begin
        //Loop for all Dimension Combination
        IF l_Rec_GLSetup.FIND('-')THEN;
        l_Rec_AllocationRuleSource.RESET;
        l_Rec_AllocationRuleSource.SETRANGE(Rule, RuleNo);
        l_Rec_AllocationRuleSource.SETRANGE("Field Setting", l_Rec_AllocationRuleSource."Field Setting"::"Financial Dimension");
        IF l_Rec_AllocationRuleSource.FINDSET THEN REPEAT IF l_Rec_GLSetup."Shortcut Dimension 1 Code" = l_Rec_AllocationRuleSource.Name THEN begin
                    l_Rec_SourceDimCode[1]:=l_Rec_AllocationRuleSource.Name;
                    l_Rec_SourceDimValue[1]:=l_Rec_AllocationRuleSource."Source Criteria";
                end;
                IF l_Rec_GLSetup."Shortcut Dimension 2 Code" = l_Rec_AllocationRuleSource.Name THEN begin
                    l_Rec_SourceDimCode[2]:=l_Rec_AllocationRuleSource.Name;
                    l_Rec_SourceDimValue[2]:=l_Rec_AllocationRuleSource."Source Criteria";
                end;
                IF l_Rec_GLSetup."Shortcut Dimension 3 Code" = l_Rec_AllocationRuleSource.Name THEN begin
                    l_Rec_SourceDimCode[3]:=l_Rec_AllocationRuleSource.Name;
                    l_Rec_SourceDimValue[3]:=l_Rec_AllocationRuleSource."Source Criteria";
                end;
                IF l_Rec_GLSetup."Shortcut Dimension 4 Code" = l_Rec_AllocationRuleSource.Name THEN begin
                    l_Rec_SourceDimCode[4]:=l_Rec_AllocationRuleSource.Name;
                    l_Rec_SourceDimValue[4]:=l_Rec_AllocationRuleSource."Source Criteria";
                end;
                IF l_Rec_GLSetup."Shortcut Dimension 5 Code" = l_Rec_AllocationRuleSource.Name THEN begin
                    l_Rec_SourceDimCode[5]:=l_Rec_AllocationRuleSource.Name;
                    l_Rec_SourceDimValue[5]:=l_Rec_AllocationRuleSource."Source Criteria";
                end;
                IF l_Rec_GLSetup."Shortcut Dimension 6 Code" = l_Rec_AllocationRuleSource.Name THEN begin
                    l_Rec_SourceDimCode[6]:=l_Rec_AllocationRuleSource.Name;
                    l_Rec_SourceDimValue[6]:=l_Rec_AllocationRuleSource."Source Criteria";
                end;
                IF l_Rec_GLSetup."Shortcut Dimension 7 Code" = l_Rec_AllocationRuleSource.Name THEN begin
                    l_Rec_SourceDimCode[7]:=l_Rec_AllocationRuleSource.Name;
                    l_Rec_SourceDimValue[7]:=l_Rec_AllocationRuleSource."Source Criteria";
                end;
                IF l_Rec_GLSetup."Shortcut Dimension 8 Code" = l_Rec_AllocationRuleSource.Name THEN begin
                    l_Rec_SourceDimCode[8]:=l_Rec_AllocationRuleSource.Name;
                    l_Rec_SourceDimValue[8]:=l_Rec_AllocationRuleSource."Source Criteria";
                end;
                IF l_Rec_GLSetup."Shortcut Dimension 9 Code" = l_Rec_AllocationRuleSource.Name THEN begin
                    l_Rec_SourceDimCode[9]:=l_Rec_AllocationRuleSource.Name;
                    l_Rec_SourceDimValue[9]:=l_Rec_AllocationRuleSource."Source Criteria";
                end;
                IF l_Rec_GLSetup."Shortcut Dimension 10 Code" = l_Rec_AllocationRuleSource.Name THEN begin
                    l_Rec_SourceDimCode[10]:=l_Rec_AllocationRuleSource.Name;
                    l_Rec_SourceDimValue[10]:=l_Rec_AllocationRuleSource."Source Criteria";
                end;
                IF l_Rec_GLSetup."Shortcut Dimension 11 Code" = l_Rec_AllocationRuleSource.Name THEN begin
                    l_Rec_SourceDimCode[11]:=l_Rec_AllocationRuleSource.Name;
                    l_Rec_SourceDimValue[11]:=l_Rec_AllocationRuleSource."Source Criteria";
                end;
                IF l_Rec_GLSetup."Shortcut Dimension 12 Code" = l_Rec_AllocationRuleSource.Name THEN begin
                    l_Rec_SourceDimCode[12]:=l_Rec_AllocationRuleSource.Name;
                    l_Rec_SourceDimValue[12]:=l_Rec_AllocationRuleSource."Source Criteria";
                end;
                IF l_Rec_GLSetup."Shortcut Dimension 13 Code" = l_Rec_AllocationRuleSource.Name THEN begin
                    l_Rec_SourceDimCode[13]:=l_Rec_AllocationRuleSource.Name;
                    l_Rec_SourceDimValue[13]:=l_Rec_AllocationRuleSource."Source Criteria";
                end;
                IF l_Rec_GLSetup."Shortcut Dimension 14 Code" = l_Rec_AllocationRuleSource.Name THEN begin
                    l_Rec_SourceDimCode[14]:=l_Rec_AllocationRuleSource.Name;
                    l_Rec_SourceDimValue[14]:=l_Rec_AllocationRuleSource."Source Criteria";
                end;
                IF l_Rec_GLSetup."Shortcut Dimension 15 Code" = l_Rec_AllocationRuleSource.Name THEN begin
                    l_Rec_SourceDimCode[15]:=l_Rec_AllocationRuleSource.Name;
                    l_Rec_SourceDimValue[15]:=l_Rec_AllocationRuleSource."Source Criteria";
                end;
            UNTIL l_Rec_AllocationRuleSource.NEXT = 0;
        //Loop for All Account List
        l_Rec_AllocationRuleSource.RESET;
        l_Rec_AllocationRuleSource.SETRANGE(Rule, RuleNo);
        l_Rec_AllocationRuleSource.SETRANGE("Field Setting", l_Rec_AllocationRuleSource."Field Setting"::"Main Account");
        IF l_Rec_AllocationRuleSource.FINDSET THEN REPEAT l_Dec_MarkupRatio:="Allocation Rule"."Math Ratio";
                IF l_Rec_AllocationRuleSource."No Markup" then l_Dec_MarkupRatio:=1;
                IF "Allocation Rule".MathCalculation = "Allocation Rule".MathCalculation::None then l_Dec_MarkupRatio:=1;
                l_Dec_Amount:=GetGLData_Companies(RuleNo, l_Rec_AllocationRuleSource."Line No.", l_Dec_MarkupRatio, FromDate, ToDate, l_Rec_AllocationRuleSource."Source Criteria", l_Rec_SourceDimCode, l_Rec_SourceDimValue);
                l_Rec_AllocationRuleSource."Last Source Amount get":=l_Dec_Amount;
                l_Rec_AllocationRuleSource."Last Get From Date":=FroMDate;
                l_Rec_AllocationRuleSource."Last Get To Date":=ToDate;
                l_Rec_AllocationRuleSource.MODIFY;
            UNTIL l_Rec_AllocationRuleSource.NEXT = 0;
    end;
    procedure GetGLData_Companies(RuleNo: Code[20]; LineNo: Integer; MarkupRatio: Decimal; FromDate: Date; ToDate: Date; GLAccountNoFilter: Text; SourceDimCodeFilter: array[20]OF Code[20]; SourceDimValueFilter: array[20]OF Text): Decimal var
        l_Rec_AllocationRuleSourceCompany: Record "Allocation Source Company";
        l_Rec_ICPartner: Record "IC Partner";
        l_cud_ItemPost: Codeunit "Item Jnl.-Post";
        l_Dec_Amount: decimal;
        l_Dec_SubAmount: Decimal;
    begin
        l_Rec_AllocationRuleSourceCompany.RESET;
        l_Rec_AllocationRuleSourceCompany.SETRANGE(Rule, RuleNo);
        l_Rec_AllocationRuleSourceCompany.SETRANGE("Line No.", LineNo);
        IF l_Rec_AllocationRuleSourceCompany.FINDSET THEN begin
            repeat IF l_Rec_ICPartner.GET(l_Rec_AllocationRuleSourceCompany."Company Name")THEN;
                l_Dec_SubAmount:=GetGLData(l_Rec_ICPartner."Inbox Details", RuleNo, LineNo, MarkupRatio, FromDate, ToDate, GLAccountNoFilter, SourceDimCodeFilter, SourceDimValueFilter);
                l_Rec_AllocationRuleSourceCompany."Last Source Amount get":=l_Dec_SubAmount;
                l_Rec_AllocationRuleSourceCompany."Last Get From Date":=FroMDate;
                l_Rec_AllocationRuleSourceCompany."Last Get To Date":=ToDate;
                l_Rec_AllocationRuleSourceCompany.MODIFY;
                l_Dec_Amount+=l_Dec_SubAmount;
            UNTIL l_Rec_AllocationRuleSourceCompany.NEXT = 0;
        end
        ELSE
        begin
            l_Dec_Amount:=GetGLData('', RuleNo, LineNo, MarkupRatio, FromDate, ToDate, GLAccountNoFilter, SourceDimCodeFilter, SourceDimValueFilter);
        end;
        EXIT(l_Dec_Amount);
    end;
    procedure GetGLData(p_txt_CompanyName: Text; RuleNo: Code[20]; LineNo: Integer; MarkupRatio: Decimal; FromDate: Date; ToDate: Date; GLAccountNoFilter: Text; SourceDimCodeFilter: array[20]OF Code[20]; SourceDimValueFilter: array[20]OF Text): Decimal var
        l_Rec_GLEntry: Record "G/L Entry";
        l_Rec_AllocationDestination: Record "Allocation Destination";
        l_dec_Amount: Decimal;
    begin
        l_Rec_GLEntry.RESET;
        IF p_txt_CompanyName <> CompanyName THEN begin
            l_Rec_GLEntry.ChangeCompany(p_txt_CompanyName);
        end;
        l_Rec_GLEntry.SETRANGE("Posting Date", FromDate, ToDate);
        l_Rec_GLEntry.SETFILTER("G/L Account No.", GLAccountNoFilter);
        l_Rec_GLEntry.SETFILTER(Amount, '<>%1', 0);
        IF SourceDimCodeFilter[1] <> '' then l_Rec_GLEntry.SETFILTER("Global Dimension 1 Code", SourceDimValueFilter[1]);
        IF SourceDimCodeFilter[2] <> '' then l_Rec_GLEntry.SETFILTER("Global Dimension 2 Code", SourceDimValueFilter[2]);
        IF SourceDimCodeFilter[3] <> '' then l_Rec_GLEntry.SETFILTER("Shortcut Dimension 3 Code_PB", SourceDimValueFilter[3]);
        IF SourceDimCodeFilter[4] <> '' then l_Rec_GLEntry.SETFILTER("Shortcut Dimension 4 Code_PB", SourceDimValueFilter[4]);
        IF SourceDimCodeFilter[5] <> '' then l_Rec_GLEntry.SETFILTER("Shortcut Dimension 5 Code_PB", SourceDimValueFilter[5]);
        IF SourceDimCodeFilter[6] <> '' then l_Rec_GLEntry.SETFILTER("Shortcut Dimension 6 Code_PB", SourceDimValueFilter[6]);
        IF SourceDimCodeFilter[7] <> '' then l_Rec_GLEntry.SETFILTER("Shortcut Dimension 7 Code_PB", SourceDimValueFilter[7]);
        IF SourceDimCodeFilter[8] <> '' then l_Rec_GLEntry.SETFILTER("Shortcut Dimension 8 Code_PB", SourceDimValueFilter[8]);
        IF SourceDimCodeFilter[9] <> '' then l_Rec_GLEntry.SETFILTER("Shortcut Dimension 9 Code_PB", SourceDimValueFilter[9]);
        IF SourceDimCodeFilter[10] <> '' then l_Rec_GLEntry.SETFILTER("Shortcut Dimension 10 Code_PB", SourceDimValueFilter[10]);
        IF SourceDimCodeFilter[11] <> '' then l_Rec_GLEntry.SETFILTER("Shortcut Dimension 11 Code_PB", SourceDimValueFilter[11]);
        IF SourceDimCodeFilter[12] <> '' then l_Rec_GLEntry.SETFILTER("Shortcut Dimension 12 Code_PB", SourceDimValueFilter[12]);
        IF SourceDimCodeFilter[13] <> '' then l_Rec_GLEntry.SETFILTER("Shortcut Dimension 13 Code_PB", SourceDimValueFilter[13]);
        IF SourceDimCodeFilter[14] <> '' then l_Rec_GLEntry.SETFILTER("Shortcut Dimension 14 Code_PB", SourceDimValueFilter[14]);
        IF SourceDimCodeFilter[15] <> '' then l_Rec_GLEntry.SETFILTER("Shortcut Dimension 15 Code_PB", SourceDimValueFilter[15]);
        IF l_Rec_GLEntry.FINDSET THEN REPEAT l_dec_Amount+=l_Rec_GLEntry.Amount * MarkupRatio;
                //l_dec_Amount += l_Rec_GLEntry.Amount * MarkupRatio;
                GatherGLDataByDimension(l_Rec_GLEntry, MarkupRatio, RuleNo);
            //Gather to g_Rec_GenJnlLineTemp                
            UNTIL l_Rec_GLEntry.NEXT = 0;
        EXIT(l_dec_Amount);
    end;
    procedure GatherGLDataByDimension(var l_Rec_GLEntry: Record "G/L Entry"; MarkupRatio: Decimal; RuleNo: Code[20])
    var
        l_int_LineNo: integer;
        l_cod_AccountNo: Code[20];
        l_Rec_SourceDim: Array[20]of Code[50];
        l_Rec_AllocationDimension: REcord "Allocation Default Dimension";
        l_Rec_GLSEtup: REcord "General Ledger Setup";
    begin
        l_cod_AccountNo:=l_Rec_GLEntry."G/L Account No.";
        //IF l_rec_AllocationRule.GET(p_rec_AllocationDestination.Rule) THEN;
        //need to change dimension Based on Offset Dimensions
        l_Rec_SourceDim[1]:=l_Rec_GLEntry."Global Dimension 1 Code";
        l_Rec_SourceDim[2]:=l_Rec_GLEntry."Global Dimension 2 Code";
        l_Rec_SourceDim[3]:=l_Rec_GLEntry."Shortcut Dimension 3 Code_PB";
        l_Rec_SourceDim[4]:=l_Rec_GLEntry."Shortcut Dimension 4 Code_PB";
        l_Rec_SourceDim[5]:=l_Rec_GLEntry."Shortcut Dimension 5 Code_PB";
        l_Rec_SourceDim[6]:=l_Rec_GLEntry."Shortcut Dimension 6 Code_PB";
        l_Rec_SourceDim[7]:=l_Rec_GLEntry."Shortcut Dimension 7 Code_PB";
        l_Rec_SourceDim[8]:=l_Rec_GLEntry."Shortcut Dimension 8 Code_PB";
        l_Rec_SourceDim[9]:=l_Rec_GLEntry."Shortcut Dimension 9 Code_PB";
        l_Rec_SourceDim[10]:=l_Rec_GLEntry."Shortcut Dimension 10 Code_PB";
        l_Rec_SourceDim[11]:=l_Rec_GLEntry."Shortcut Dimension 11 Code_PB";
        l_Rec_SourceDim[12]:=l_Rec_GLEntry."Shortcut Dimension 12 Code_PB";
        l_Rec_SourceDim[13]:=l_Rec_GLEntry."Shortcut Dimension 13 Code_PB";
        l_Rec_SourceDim[14]:=l_Rec_GLEntry."Shortcut Dimension 14 Code_PB";
        l_Rec_SourceDim[15]:=l_Rec_GLEntry."Shortcut Dimension 15 Code_PB";
        //Convert Account No.
        IF "Allocation Rule"."Offset Account From" = "Allocation Rule"."Offset Account From"::"User Specified" THEN begin
            l_cod_AccountNo:="Allocation Rule"."Offset Account No.";
        end;
        //Convert DImension
        IF "Allocation Rule"."Offset Dimension From" = "Allocation Rule"."Offset Dimension From"::"User Specified" THEN begin
            OverwriteDimensions(l_Rec_SourceDim, TRUE);
        end;
        l_Rec_GLSEtup.GET;
        //IF l_Rec_GLEntry."Original Currency PB" = '' then
        //    l_Rec_GLEntry."Original Currency PB" := l_Rec_GLSEtup."LCY Code";
        g_Rec_GenJnlLineTemp.RESET;
        g_Rec_GenJnlLineTemp.SETRANGE("Account No.", l_cod_AccountNo);
        g_Rec_GenJnlLineTemp.SETRANGE("Shortcut Dimension 1 Code", l_Rec_SourceDim[1]);
        g_Rec_GenJnlLineTemp.SETRANGE("Shortcut Dimension 2 Code", l_Rec_SourceDim[2]);
        g_Rec_GenJnlLineTemp.SETRANGE("Shortcut Dimension 3 Code", l_Rec_SourceDim[3]);
        g_Rec_GenJnlLineTemp.SETRANGE("Shortcut Dimension 4 Code", l_Rec_SourceDim[4]);
        g_Rec_GenJnlLineTemp.SETRANGE("Shortcut Dimension 5 Code", l_Rec_SourceDim[5]);
        g_Rec_GenJnlLineTemp.SETRANGE("Shortcut Dimension 6 Code", l_Rec_SourceDim[6]);
        g_Rec_GenJnlLineTemp.SETRANGE("Shortcut Dimension 7 Code", l_Rec_SourceDim[7]);
        g_Rec_GenJnlLineTemp.SETRANGE("Shortcut Dimension 8 Code", l_Rec_SourceDim[8]);
        g_Rec_GenJnlLineTemp.SETRANGE("Shortcut Dimension 9 Code", l_Rec_SourceDim[9]);
        g_Rec_GenJnlLineTemp.SETRANGE("Shortcut Dimension 10 Code", l_Rec_SourceDim[10]);
        g_Rec_GenJnlLineTemp.SETRANGE("Shortcut Dimension 11 Code", l_Rec_SourceDim[11]);
        g_Rec_GenJnlLineTemp.SETRANGE("Shortcut Dimension 12 Code", l_Rec_SourceDim[12]);
        g_Rec_GenJnlLineTemp.SETRANGE("Shortcut Dimension 13 Code", l_Rec_SourceDim[13]);
        g_Rec_GenJnlLineTemp.SETRANGE("Shortcut Dimension 14 Code", l_Rec_SourceDim[14]);
        g_Rec_GenJnlLineTemp.SETRANGE("Shortcut Dimension 15 Code", l_Rec_SourceDim[15]);
        //g_Rec_GenJnlLineTemp.SetRange("Posting Date", l_Rec_GLEntry."Posting Date");
        //g_Rec_GenJnlLineTemp.SETRANGE("Currency Code", l_Rec_GLEntry."Original Currency PB");
        IF g_Rec_GenJnlLineTemp.FINDSET THEN begin
            //g_Rec_GenJnlLineTemp.Amount += l_Rec_GLEntry.Amount * MarkupRatio;
            g_Rec_GenJnlLineTemp.Amount+=l_Rec_GLEntry.Amount * MarkupRatio;
            /*
            IF l_Rec_GLEntry."Original Currency PB" = '' then
                g_Rec_GenJnlLineTemp.Amount += l_Rec_GLEntry.Amount * MarkupRatio
            ELSE begin
                g_Rec_GenJnlLineTemp."Amount" += l_Rec_GLEntry."Original Amount PB" * MarkupRatio;
            end;
            */
            g_Rec_GenJnlLineTemp.MODIFY;
        end
        ELSE
        begin
            g_Rec_GenJnlLineTemp.RESET;
            IF g_Rec_GenJnlLineTemp.FindLast()then l_int_LineNo:=g_Rec_GenJnlLineTemp."Line No.";
            l_int_LineNo+=1;
            g_Rec_GenJnlLineTemp.RESET;
            g_Rec_GenJnlLineTemp.INIT;
            g_Rec_GenJnlLineTemp."Line No.":=l_int_LineNo;
            g_Rec_GenJnlLineTemp."Posting Date":=l_Rec_GLEntry."Posting Date";
            //g_Rec_GenJnlLineTemp."Currency Code" := l_Rec_GLEntry."Original Currency PB";
            g_Rec_GenJnlLineTemp."Account No.":=l_cod_AccountNo;
            g_Rec_GenJnlLineTemp."Shortcut Dimension 1 Code":=l_Rec_SourceDim[1];
            g_Rec_GenJnlLineTemp."Shortcut Dimension 2 Code":=l_Rec_SourceDim[2];
            g_Rec_GenJnlLineTemp."Shortcut Dimension 3 Code":=l_Rec_SourceDim[3];
            g_Rec_GenJnlLineTemp."Shortcut Dimension 4 Code":=l_Rec_SourceDim[4];
            g_Rec_GenJnlLineTemp."Shortcut Dimension 5 Code":=l_Rec_SourceDim[5];
            g_Rec_GenJnlLineTemp."Shortcut Dimension 6 Code":=l_Rec_SourceDim[6];
            g_Rec_GenJnlLineTemp."Shortcut Dimension 7 Code":=l_Rec_SourceDim[7];
            g_Rec_GenJnlLineTemp."Shortcut Dimension 8 Code":=l_Rec_SourceDim[8];
            g_Rec_GenJnlLineTemp."Shortcut Dimension 9 Code":=l_Rec_SourceDim[9];
            g_Rec_GenJnlLineTemp."Shortcut Dimension 10 Code":=l_Rec_SourceDim[10];
            g_Rec_GenJnlLineTemp."Shortcut Dimension 11 Code":=l_Rec_SourceDim[11];
            g_Rec_GenJnlLineTemp."Shortcut Dimension 12 Code":=l_Rec_SourceDim[12];
            g_Rec_GenJnlLineTemp."Shortcut Dimension 13 Code":=l_Rec_SourceDim[13];
            g_Rec_GenJnlLineTemp."Shortcut Dimension 14 Code":=l_Rec_SourceDim[14];
            g_Rec_GenJnlLineTemp."Shortcut Dimension 15 Code":=l_Rec_SourceDim[15];
            //g_Rec_GenJnlLineTemp.Amount := l_Rec_GLEntry.Amount * MarkupRatio;            
            g_Rec_GenJnlLineTemp.Amount:=l_Rec_GLEntry.Amount * MarkupRatio;
            /*
            IF l_Rec_GLEntry."Original Currency PB" = '' then
                g_Rec_GenJnlLineTemp.Amount := l_Rec_GLEntry.Amount * MarkupRatio
            ELSE
                g_Rec_GenJnlLineTemp."Amount" := l_Rec_GLEntry."Original Amount PB" * MarkupRatio;
            */
            g_Rec_GenJnlLineTemp.INSERT;
        end;
    end;
    procedure OverwriteDimensions(var l_Rec_SourceDim: array[20]OF Code[50]; IsOffset: Boolean)
    var
        l_Rec_AllocationDimension: Record "Allocation Default Dimension";
        l_Rec_GLSetup: Record "General Ledger Setup";
    begin
        clear(l_Rec_SourceDim); //TEC#002
        l_Rec_GLSEtup.Get(); //Rajan 06Feb2025
        l_Rec_AllocationDimension.RESET;
        l_Rec_AllocationDimension.SETRANGE(Rule, "Allocation Rule".Rule);
        IF IsOffset then begin
            l_Rec_AllocationDimension.SETRANGE(Type, l_Rec_AllocationDimension.Type::Offset);
        end
        ELSE
            l_Rec_AllocationDimension.SETRANGE(Type, l_Rec_AllocationDimension.Type::Destination);
        IF l_Rec_AllocationDimension.FINDSET THEN repeat IF l_Rec_GLSEtup."Shortcut Dimension 1 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[1]:=l_Rec_AllocationDimension."Dimension Value Code";
                IF l_Rec_GLSEtup."Shortcut Dimension 2 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[2]:=l_Rec_AllocationDimension."Dimension Value Code";
                IF l_Rec_GLSEtup."Shortcut Dimension 3 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[3]:=l_Rec_AllocationDimension."Dimension Value Code";
                IF l_Rec_GLSEtup."Shortcut Dimension 4 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[4]:=l_Rec_AllocationDimension."Dimension Value Code";
                IF l_Rec_GLSEtup."Shortcut Dimension 5 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[5]:=l_Rec_AllocationDimension."Dimension Value Code";
                IF l_Rec_GLSEtup."Shortcut Dimension 6 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[6]:=l_Rec_AllocationDimension."Dimension Value Code";
                IF l_Rec_GLSEtup."Shortcut Dimension 7 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[7]:=l_Rec_AllocationDimension."Dimension Value Code";
                IF l_Rec_GLSEtup."Shortcut Dimension 8 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[8]:=l_Rec_AllocationDimension."Dimension Value Code";
                IF l_Rec_GLSEtup."Shortcut Dimension 9 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[9]:=l_Rec_AllocationDimension."Dimension Value Code";
                IF l_Rec_GLSEtup."Shortcut Dimension 10 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[10]:=l_Rec_AllocationDimension."Dimension Value Code";
                IF l_Rec_GLSEtup."Shortcut Dimension 11 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[11]:=l_Rec_AllocationDimension."Dimension Value Code";
                IF l_Rec_GLSEtup."Shortcut Dimension 12 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[12]:=l_Rec_AllocationDimension."Dimension Value Code";
                IF l_Rec_GLSEtup."Shortcut Dimension 13 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[13]:=l_Rec_AllocationDimension."Dimension Value Code";
                IF l_Rec_GLSEtup."Shortcut Dimension 14 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[14]:=l_Rec_AllocationDimension."Dimension Value Code";
                IF l_Rec_GLSEtup."Shortcut Dimension 15 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[15]:=l_Rec_AllocationDimension."Dimension Value Code";
            UNTIl l_Rec_AllocationDimension.NEXT = 0;
    end;
    procedure GenICDimensions(var l_Rec_SourceDim: array[20]OF Code[50]; mCompID: Code[50]; mAccountCode: Code[20])
    var
        l_Rec_AllocationDimension: Record "Allocation Default Dimension";
        l_Rec_GLSetup: Record "General Ledger Setup";
    begin
        clear(l_Rec_SourceDim);
        l_Rec_GLSEtup.Get();
        l_Rec_AllocationDimension.RESET;
        l_Rec_AllocationDimension.SETRANGE(Rule, "Allocation Rule".Rule);
        l_Rec_AllocationDimension.SETRANGE(Type, l_Rec_AllocationDimension.Type::Destination);
        l_Rec_AllocationDimension.SetRange(Company, mCompID);
        l_Rec_AllocationDimension.SetRange("To Account", mAccountCode);
        IF l_Rec_AllocationDimension.FINDSET THEN repeat IF l_Rec_GLSEtup."Shortcut Dimension 1 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[1]:=l_Rec_AllocationDimension."Dimension Value Code";
                IF l_Rec_GLSEtup."Shortcut Dimension 2 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[2]:=l_Rec_AllocationDimension."Dimension Value Code";
                IF l_Rec_GLSEtup."Shortcut Dimension 3 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[3]:=l_Rec_AllocationDimension."Dimension Value Code";
                IF l_Rec_GLSEtup."Shortcut Dimension 4 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[4]:=l_Rec_AllocationDimension."Dimension Value Code";
                IF l_Rec_GLSEtup."Shortcut Dimension 5 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[5]:=l_Rec_AllocationDimension."Dimension Value Code";
                IF l_Rec_GLSEtup."Shortcut Dimension 6 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[6]:=l_Rec_AllocationDimension."Dimension Value Code";
                IF l_Rec_GLSEtup."Shortcut Dimension 7 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[7]:=l_Rec_AllocationDimension."Dimension Value Code";
                IF l_Rec_GLSEtup."Shortcut Dimension 8 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[8]:=l_Rec_AllocationDimension."Dimension Value Code";
                IF l_Rec_GLSEtup."Shortcut Dimension 9 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[9]:=l_Rec_AllocationDimension."Dimension Value Code";
                IF l_Rec_GLSEtup."Shortcut Dimension 10 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[10]:=l_Rec_AllocationDimension."Dimension Value Code";
                IF l_Rec_GLSEtup."Shortcut Dimension 11 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[11]:=l_Rec_AllocationDimension."Dimension Value Code";
                IF l_Rec_GLSEtup."Shortcut Dimension 12 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[12]:=l_Rec_AllocationDimension."Dimension Value Code";
                IF l_Rec_GLSEtup."Shortcut Dimension 13 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[13]:=l_Rec_AllocationDimension."Dimension Value Code";
                IF l_Rec_GLSEtup."Shortcut Dimension 14 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[14]:=l_Rec_AllocationDimension."Dimension Value Code";
                IF l_Rec_GLSEtup."Shortcut Dimension 15 Code" = l_Rec_AllocationDimension."Dimension Code" then l_Rec_SourceDim[15]:=l_Rec_AllocationDimension."Dimension Value Code";
            UNTIl l_Rec_AllocationDimension.NEXT = 0;
    end;
    procedure CheckSetup(RuleNo: Code[20])
    var
        l_Rec_AllocationDestination: Record "Allocation Destination";
        l_Dec_PartAmt: Decimal;
    begin
        "Allocation Rule".TestField("No. Series");
        "Allocation Rule".TestField("Journal Batch Name");
        IF g_dat_RunDate = 0D then ERROR('Parameter: Run Date must have a Value');
        IF g_dat_PostingDate = 0D then ERROR('Parameter: Posting Date must have a Value');
        CheckGLBatch(RuleNo); //Clear and recreate IC Journal Batch 
        l_Rec_AllocationDestination.RESET;
        l_Rec_AllocationDestination.SETRANGE(Rule, RuleNo);
        IF l_Rec_AllocationDestination.FINDSET THEN repeat CASE "Allocation Rule"."Allocation method" of "Allocation Rule"."Allocation method"::Percentage: g_dec_Denominator+=l_Rec_AllocationDestination."Fixed Percentage";
                "Allocation Rule"."Allocation method"::Weight: g_dec_Denominator+=l_Rec_AllocationDestination."Fixed Weight";
                "Allocation Rule"."Allocation method"::Ratio: begin
                    l_Dec_PartAmt:=0;
                    l_Dec_PartAmt+=GetDestinationRatio(l_Rec_AllocationDestination.Rule, l_Rec_AllocationDestination.Company, l_Rec_AllocationDestination."To Account", false);
                    IF "Allocation Rule"."Date Interval Code" = "Allocation Rule"."Date Interval Code"::Min tHEN begin
                        l_Dec_PartAmt+=GetDestinationRatio(l_Rec_AllocationDestination.Rule, l_Rec_AllocationDestination.Company, l_Rec_AllocationDestination."To Account", true);
                        l_Dec_PartAmt:=l_Dec_PartAmt / 2;
                    END;
                    g_dec_Denominator+=l_Dec_PartAmt;
                end;
                "Allocation Rule"."Allocation method"::Point: begin
                    g_dec_Denominator+=GetDestinationPoints(l_Rec_AllocationDestination.Rule, l_Rec_AllocationDestination.Company, l_Rec_AllocationDestination."To Account", false);
                end;
                "Allocation Rule"."Allocation method"::OperatingDaysXRatio: begin
                    g_dec_Denominator+=GetDestinationOperatingDaysXPoints(l_Rec_AllocationDestination.Rule, l_Rec_AllocationDestination.Company, l_Rec_AllocationDestination."To Account");
                end;
                END;
            until l_Rec_AllocationDestination.NEXT = 0;
        IF g_dec_Denominator = 0 THEN g_dec_Denominator:=1;
    end;
    procedure GetDestinationOperatingDaysXPoints(RuleNo: Code[20]; ICPartner: Code[20]; ToAccount: Code[20]): Decimal var
        l_dec_Ratio: Decimal;
        l_dec_Points: decimal;
    begin
        l_dec_Ratio:=GetDestinationRatio(RuleNo, ICPartner, ToAccount, false);
        l_dec_Points:=GetDestinationPoints(RuleNo, ICPartner, ToAccount, true);
        EXIT(l_dec_Ratio * l_Dec_Points);
    end;
    procedure GetDestinationPoints(RuleNo: Code[20]; ICPartner: Code[20]; ToAccount: Code[20]; IgnoreMultiply: Boolean): Decimal var
        l_Rec_PoolDistribution: Record "Pool Distribution";
        l_Rec_ManagementDistribution: Record "Management Fee Distribution";
        l_Dec_TotalPoint: Decimal;
        l_int_NoOfDays: Decimal;
        l_Rec_VMT: Record VMT;
        l_Rec_CompanyMapping: Record "Company Name Mapping";
    begin
        IF "Allocation Rule"."Point Calculation Day Type" = "Allocation Rule"."Point Calculation Day Type"::"Revenue Days" THEN begin
            l_Rec_PoolDistribution.RESET;
            IF ICPartner <> '' THEN l_Rec_PoolDistribution.SETRANGE("IC Partner No.", ICPartner)
            ELSE
                l_Rec_PoolDistribution.SETRANGE("Company Name", COMPANYNAME);
            l_Rec_PoolDistribution.SETRANGE("Source Date", g_dat_EndDate);
            IF l_Rec_PoolDistribution.FINDSET THEN repeat l_Rec_PoolDistribution.CalcFields("Calc. Days");
                    l_Dec_TotalPoint+=l_Rec_PoolDistribution."Calc. Days" * l_Rec_PoolDistribution."Pool Points";
                    l_int_NoOfDays+=l_Rec_PoolDistribution."Calc. Days";
                UNTIL l_Rec_PoolDistribution.NEXT = 0;
        end
        ELSE
        begin
            l_Rec_ManagementDistribution.RESET;
            IF ICPartner <> '' THEN l_Rec_ManagementDistribution.SETRANGE("IC Partner No.", ICPartner)
            ELSE
                l_Rec_ManagementDistribution.SETRANGE("Company Name", COMPANYNAME);
            l_Rec_ManagementDistribution.SETRANGE("Source Date", g_dat_EndDate);
            IF l_Rec_ManagementDistribution.FINDSET THEN repeat l_Rec_VMT.RESET;
                    l_Rec_VMT.SETRANGE(DBASE, l_Rec_ManagementDistribution."Company Name");
                    IF l_Rec_VMT.FINDSET THEN;
                    l_Rec_ManagementDistribution.CalcFields("Calc. Days");
                    IF IgnoreMultiply THEN begin
                        l_Dec_TotalPoint+=l_Rec_ManagementDistribution."Calc. Days";
                        l_int_NoOfDays+=l_Rec_ManagementDistribution."Calc. Days";
                    end
                    ELSE
                    begin
                        l_Dec_TotalPoint+=l_Rec_ManagementDistribution."Calc. Days" * l_Rec_VMT."MFEE FACTOR";
                        l_int_NoOfDays+=l_Rec_ManagementDistribution."Calc. Days" * l_Rec_VMT."MFEE FACTOR";
                    end;
                UNTIL l_Rec_ManagementDistribution.NEXT = 0;
        end;
        EXIT(l_Dec_TotalPoint);
    end;
    procedure GetDestinationRatio(RuleNo: Code[20]; ICPartner: Code[20]; ToAccount: Code[20]; CalculatePreviousMin: Boolean): Decimal var
        l_Rec_AllocationDestRatio: Record "Allocation Dest. Ratio G/L";
        l_Rec_DestDimCode: array[20]OF Code[20];
        l_rec_DestDimValue: array[20]of Code[20];
        l_Rec_GLSetup: Record "General Ledger Setup";
        l_Dec_Amount: Decimal;
        l_Dec_AmtPart: Decimal;
        l_Dec_Subtraction: integer;
    begin
        IF l_Rec_GLSetup.FIND('-')THEN;
        l_Rec_AllocationDestRatio.RESET;
        l_Rec_AllocationDestRatio.SETRANGE(Rule, RuleNo);
        l_Rec_AllocationDestRatio.SETRANGE("To Account", ToAccount);
        l_Rec_AllocationDestRatio.SETRANGE("Field Setting", l_Rec_AllocationDestRatio."Field Setting"::"Financial Dimension");
        IF l_Rec_AllocationDestRatio.FINDSET THEN REPEAT IF l_Rec_GLSetup."Shortcut Dimension 1 Code" = l_Rec_AllocationDestRatio.Name THEN begin
                    l_Rec_DestDimCode[1]:=l_Rec_AllocationDestRatio.Name;
                    l_Rec_DestDimValue[1]:=l_Rec_AllocationDestRatio."Source Criteria";
                end;
                IF l_Rec_GLSetup."Shortcut Dimension 2 Code" = l_Rec_AllocationDestRatio.Name THEN begin
                    l_Rec_DestDimCode[2]:=l_Rec_AllocationDestRatio.Name;
                    l_Rec_DestDimValue[2]:=l_Rec_AllocationDestRatio."Source Criteria";
                end;
                IF l_Rec_GLSetup."Shortcut Dimension 3 Code" = l_Rec_AllocationDestRatio.Name THEN begin
                    l_Rec_DestDimCode[3]:=l_Rec_AllocationDestRatio.Name;
                    l_Rec_DestDimValue[3]:=l_Rec_AllocationDestRatio."Source Criteria";
                end;
                IF l_Rec_GLSetup."Shortcut Dimension 4 Code" = l_Rec_AllocationDestRatio.Name THEN begin
                    l_Rec_DestDimCode[4]:=l_Rec_AllocationDestRatio.Name;
                    l_Rec_DestDimValue[4]:=l_Rec_AllocationDestRatio."Source Criteria";
                end;
                IF l_Rec_GLSetup."Shortcut Dimension 5 Code" = l_Rec_AllocationDestRatio.Name THEN begin
                    l_Rec_DestDimCode[5]:=l_Rec_AllocationDestRatio.Name;
                    l_Rec_DestDimValue[5]:=l_Rec_AllocationDestRatio."Source Criteria";
                end;
                IF l_Rec_GLSetup."Shortcut Dimension 6 Code" = l_Rec_AllocationDestRatio.Name THEN begin
                    l_Rec_DestDimCode[6]:=l_Rec_AllocationDestRatio.Name;
                    l_Rec_DestDimValue[6]:=l_Rec_AllocationDestRatio."Source Criteria";
                end;
                IF l_Rec_GLSetup."Shortcut Dimension 7 Code" = l_Rec_AllocationDestRatio.Name THEN begin
                    l_Rec_DestDimCode[7]:=l_Rec_AllocationDestRatio.Name;
                    l_Rec_DestDimValue[7]:=l_Rec_AllocationDestRatio."Source Criteria";
                end;
                IF l_Rec_GLSetup."Shortcut Dimension 8 Code" = l_Rec_AllocationDestRatio.Name THEN begin
                    l_Rec_DestDimCode[8]:=l_Rec_AllocationDestRatio.Name;
                    l_Rec_DestDimValue[8]:=l_Rec_AllocationDestRatio."Source Criteria";
                end;
                IF l_Rec_GLSetup."Shortcut Dimension 9 Code" = l_Rec_AllocationDestRatio.Name THEN begin
                    l_Rec_DestDimCode[9]:=l_Rec_AllocationDestRatio.Name;
                    l_Rec_DestDimValue[9]:=l_Rec_AllocationDestRatio."Source Criteria";
                end;
                IF l_Rec_GLSetup."Shortcut Dimension 10 Code" = l_Rec_AllocationDestRatio.Name THEN begin
                    l_Rec_DestDimCode[10]:=l_Rec_AllocationDestRatio.Name;
                    l_Rec_DestDimValue[10]:=l_Rec_AllocationDestRatio."Source Criteria";
                end;
                IF l_Rec_GLSetup."Shortcut Dimension 11 Code" = l_Rec_AllocationDestRatio.Name THEN begin
                    l_Rec_DestDimCode[11]:=l_Rec_AllocationDestRatio.Name;
                    l_Rec_DestDimValue[11]:=l_Rec_AllocationDestRatio."Source Criteria";
                end;
                IF l_Rec_GLSetup."Shortcut Dimension 12 Code" = l_Rec_AllocationDestRatio.Name THEN begin
                    l_Rec_DestDimCode[12]:=l_Rec_AllocationDestRatio.Name;
                    l_Rec_DestDimValue[12]:=l_Rec_AllocationDestRatio."Source Criteria";
                end;
                IF l_Rec_GLSetup."Shortcut Dimension 13 Code" = l_Rec_AllocationDestRatio.Name THEN begin
                    l_Rec_DestDimCode[13]:=l_Rec_AllocationDestRatio.Name;
                    l_Rec_DestDimValue[13]:=l_Rec_AllocationDestRatio."Source Criteria";
                end;
                IF l_Rec_GLSetup."Shortcut Dimension 14 Code" = l_Rec_AllocationDestRatio.Name THEN begin
                    l_Rec_DestDimCode[14]:=l_Rec_AllocationDestRatio.Name;
                    l_Rec_DestDimValue[14]:=l_Rec_AllocationDestRatio."Source Criteria";
                end;
                IF l_Rec_GLSetup."Shortcut Dimension 15 Code" = l_Rec_AllocationDestRatio.Name THEN begin
                    l_Rec_DestDimCode[15]:=l_Rec_AllocationDestRatio.Name;
                    l_Rec_DestDimValue[15]:=l_Rec_AllocationDestRatio."Source Criteria";
                end;
            UNTIL l_Rec_AllocationDestRatio.NEXT = 0;
        l_Rec_AllocationDestRatio.RESET;
        l_Rec_AllocationDestRatio.SETRANGE(Rule, RuleNo);
        l_Rec_AllocationDestRatio.SETRANGE("To Account", ToAccount);
        IF ICPartner <> '' then l_Rec_AllocationDestRatio.SETRANGE(Company, ICPartner);
        l_Rec_AllocationDestRatio.SETRANGE("Field Setting", l_Rec_AllocationDestRatio."Field Setting"::"Main Account");
        IF l_Rec_AllocationDestRatio.FINDSET THEN REPEAT //Inlcude Subtraction Logic
                IF l_Rec_AllocationDestRatio.Subtraction then l_Dec_Subtraction:=-1
                ELSE
                    l_Dec_Subtraction:=1;
                //Calculate for PRevious Month (Min) calculation
                //l_Dec_Amount += GetGLSumData_OtherCompany(l_Rec_AllocationDestRatio.Company, g_dat_StartDate, g_dat_EndDate, l_Rec_AllocationDestRatio."Source Criteria", l_rec_DestDimValue);
                IF CalculatePreviousMin then begin
                    l_Dec_Amount+=l_Dec_Subtraction * GetGLSumData_OtherCompany(l_Rec_AllocationDestRatio.Company, g_dat_MinFromDate, g_dat_MinToDate, l_Rec_AllocationDestRatio."Source Criteria", l_rec_DestDimValue);
                end
                else
                begin
                    l_Dec_Amount+=l_Dec_Subtraction * GetGLSumData_OtherCompany(l_Rec_AllocationDestRatio.Company, g_dat_StartDate, g_dat_EndDate, l_Rec_AllocationDestRatio."Source Criteria", l_rec_DestDimValue);
                end;
            UNTIL l_Rec_AllocationDestRatio.NEXT = 0;
        EXIT(l_Dec_Amount);
    end;
    procedure GetGLSumData_OtherCompany(ICPartnerNo: Code[20]; FromDate: Date; ToDate: Date; GLAccountFilter: Text; DimensionFilter: Array[20]OF Code[20]): Decimal var
        l_Rec_GLEntry: Record "G/L Entry";
        l_rec_ICPartner: Record "IC Partner";
        l_Rec_Company: Record "Company";
        l_dec_Amount: Decimal;
    begin
        IF l_rec_ICPartner.GET(ICPartnerNo)THEN;
        IF NOT l_Rec_Company.FINDSET THEN begin
            ERROR('Invalid Company for IC Partner No:' + ICPartnerNo);
        end;
        l_Rec_GLEntry.RESET;
        l_Rec_GLEntry.ChangeCompany(l_rec_ICPartner."Inbox Details");
        l_Rec_GLEntry.SETRANGE("Posting Date", FromDate, ToDate);
        l_Rec_GLEntry.SETFILTER("G/L Account No.", GLAccountFilter);
        IF DimensionFilter[1] <> '' then l_Rec_GLEntry.SETFILTER("Global Dimension 1 Code", DimensionFilter[1]);
        IF DimensionFilter[2] <> '' then l_Rec_GLEntry.SETFILTER("Global Dimension 1 Code", DimensionFilter[2]);
        IF DimensionFilter[3] <> '' then l_Rec_GLEntry.SETFILTER("Global Dimension 1 Code", DimensionFilter[3]);
        IF DimensionFilter[4] <> '' then l_Rec_GLEntry.SETFILTER("Global Dimension 1 Code", DimensionFilter[4]);
        IF DimensionFilter[5] <> '' then l_Rec_GLEntry.SETFILTER("Global Dimension 1 Code", DimensionFilter[5]);
        IF DimensionFilter[6] <> '' then l_Rec_GLEntry.SETFILTER("Global Dimension 1 Code", DimensionFilter[6]);
        IF DimensionFilter[7] <> '' then l_Rec_GLEntry.SETFILTER("Global Dimension 1 Code", DimensionFilter[7]);
        IF DimensionFilter[8] <> '' then l_Rec_GLEntry.SETFILTER("Global Dimension 1 Code", DimensionFilter[8]);
        IF DimensionFilter[9] <> '' then l_Rec_GLEntry.SETFILTER("Global Dimension 1 Code", DimensionFilter[9]);
        IF DimensionFilter[10] <> '' then l_Rec_GLEntry.SETFILTER("Global Dimension 1 Code", DimensionFilter[10]);
        IF DimensionFilter[11] <> '' then l_Rec_GLEntry.SETFILTER("Global Dimension 1 Code", DimensionFilter[11]);
        IF DimensionFilter[12] <> '' then l_Rec_GLEntry.SETFILTER("Global Dimension 1 Code", DimensionFilter[12]);
        IF DimensionFilter[13] <> '' then l_Rec_GLEntry.SETFILTER("Global Dimension 1 Code", DimensionFilter[13]);
        IF DimensionFilter[14] <> '' then l_Rec_GLEntry.SETFILTER("Global Dimension 1 Code", DimensionFilter[14]);
        IF DimensionFilter[15] <> '' then l_Rec_GLEntry.SETFILTER("Global Dimension 1 Code", DimensionFilter[15]);
        IF l_Rec_GLEntry.FINDSET THEN repeat l_dec_Amount+=l_Rec_GLEntry.Amount;
            //l_dec_Amount += l_Rec_GLEntry.Amount;
            UNTIl l_Rec_GLEntry.NEXT = 0;
        EXIT(l_dec_Amount);
    end;
    procedure CheckGLBatch(RuleNo: Code[20])
    var
        l_Rec_JournalBatch: REcord "Gen. Journal Batch";
        l_Rec_GEnJnl: Record "GEn. Journal LIne";
        l_cod_TemplateName: Code[20];
    begin
        IF "Allocation Rule".GET(RUleNo)THEN;
        //TEC#001>>
        /* IF "Allocation Rule"."Intercompany Rule" THEN begin
            l_cod_TemplateName := 'INTERCOMP';
        end ELSE begin
            l_cod_TemplateName := 'GENERAL';
        end; */
        l_cod_TemplateName:="Allocation Rule"."Journal Template Name";
        //TEC#001<<
        //l_cod_TemplateName := "Allocation Rule"."Journal Template Name";        //Added Journal Template Filter
        "Allocation Rule".TestField("Journal Batch Name");
        l_Rec_JournalBatch.RESET;
        l_Rec_JournalBatch.SETRANGE("Journal Template Name", l_cod_TemplateName);
        l_Rec_JournalBatch.SETRANGE(Name, "Allocation Rule"."Journal Batch Name");
        IF NOT l_Rec_JournalBatch.FINDSET THEN begin
            l_Rec_JournalBatch.RESET;
            l_Rec_JournalBatch.INIT;
            l_Rec_JournalBatch.VALIDATE("Journal Template Name", l_cod_TemplateName);
            l_Rec_JournalBatch.VALIDATE(Name, "Allocation Rule"."Journal Batch Name");
            l_Rec_JournalBatch.INSERT;
        end;
        l_Rec_GEnJnl.RESET;
        l_Rec_GEnJnl.SETRANGE("Journal Template Name", l_cod_TemplateName);
        l_Rec_GEnJnl.SETRANGE("Journal Batch Name", "Allocation Rule"."Journal Batch Name");
        IF l_Rec_GEnJnl.FINDSET THEN begin
            l_Rec_GEnJnl.DELETEALL;
        end;
    end;
    procedure CreateAllocationLog(Template: Code[20]; Batch: Code[20]; RuleNo: Code[20]; RuleLineNo: Integer; AccountNo: Code[20]; DocNum: Code[20]; CurCode: Code[20]; Amt: Decimal; Dimensions: Array[15]OF Code[20]; ToAccount: Code[20]; IsOffSet: Boolean): Integer var
        l_Rec_AllocationLogHdr: Record "Allocation Entry Log";
        l_Rec_AllocationLogLine: REcord "Allocation Entry Log Detail";
        l_int_DetailLineNo: integer;
        l_Rec_ICPartner: Record "IC Partner";
    begin
        IF g_bol_LogHdrGenerated = FALSE THEN BEGIN
            l_Rec_AllocationLogHdr.RESET;
            l_Rec_AllocationLogHdr.SETRANGE("Rule No.", RuleNo);
            IF l_Rec_AllocationLogHdr.FINDLAST then g_int_LogHdrLineNo:=l_Rec_AllocationLogHdr."Line No.";
            g_int_LogHdrLineNo+=1;
            l_Rec_AllocationLogHdr.RESET;
            l_Rec_AllocationLogHdr.INIT;
            l_Rec_AllocationLogHdr."Journal Template Name":=Template;
            l_Rec_AllocationLogHdr."Journal Batch Name":=Batch;
            l_Rec_AllocationLogHdr."Rule No.":=RuleNo;
            l_Rec_AllocationLogHdr."Line No.":=g_int_LogHdrLineNo;
            l_Rec_AllocationLogHdr."Data From Date":=g_dat_StartDate;
            l_Rec_AllocationLogHdr."Data To Date":=g_dat_EndDate;
            l_Rec_AllocationLogHdr."Posting Date":=g_dat_PostingDate;
            l_Rec_AllocationLogHdr."Document No.":=DocNum;
            l_Rec_AllocationLogHdr."Run Date":=g_dat_RunDate;
            l_Rec_AllocationLogHdr."Execute Run System Date":=TODAY;
            l_Rec_AllocationLogHdr."Exeucted by":=USERID;
            l_Rec_AllocationLogHdr.INSERT;
            g_bol_LogHdrGenerated:=TRUE;
        END;
        l_Rec_AllocationLogLine.RESET;
        l_Rec_AllocationLogLine.SETRANGE("Rule No.", RuleNo);
        l_Rec_AllocationLogLine.SETRANGE("Line No.", g_int_LogHdrLineNo);
        IF l_Rec_AllocationLogLine.FindLast()then l_int_DetailLineNo:=l_Rec_AllocationLogLine."Entry No.";
        l_int_DetailLineNo+=1;
        l_Rec_AllocationLogLine.RESET;
        l_Rec_AllocationLogLine.INIT;
        l_Rec_AllocationLogLine."Rule No.":=RuleNo;
        l_Rec_AllocationLogLine."Line No.":=g_int_LogHdrLineNo;
        l_Rec_AllocationLogLine."Entry No.":=l_int_DetailLineNo;
        l_Rec_AllocationLogLine."Journal Batch Name":=Batch;
        l_Rec_AllocationLogLine."Journal Template Name":=Template;
        l_Rec_AllocationLogLine."Document No.":=DocNUm;
        l_Rec_AllocationLogLine."Currency Code":=CurCode;
        l_Rec_AllocationLogLine."Sum Amount":=Amt;
        l_Rec_AllocationLogLine."Run Date":=g_dat_RunDate;
        l_Rec_AllocationLogLine."Data From Date":=g_dat_StartDate;
        l_Rec_AllocationLogLine."Data To Date":=g_dat_EndDate;
        l_Rec_AllocationLogLine."Posting Date":=g_dat_PostingDate;
        l_Rec_AllocationLogLine."Account NO.":=AccountNo;
        l_Rec_AllocationLogLine."Source Company":=COMPANYNAME;
        l_Rec_AllocationLogLine."Target Company":=CompanyName;
        IF l_Rec_ICPartner.GET(AccountNo)THEN l_Rec_AllocationLogLine."Target Company":=l_Rec_ICPartner."Inbox Details";
        l_Rec_AllocationLogLine."Destination Offset Account No.":=ToAccount;
        l_Rec_AllocationLogLine."Shortcut Dimension 1 Code":=DImensions[1];
        l_Rec_AllocationLogLine."Shortcut Dimension 2 Code":=DImensions[2];
        l_Rec_AllocationLogLine."Shortcut Dimension 3 Code":=DImensions[3];
        l_Rec_AllocationLogLine."Shortcut Dimension 4 Code":=DImensions[4];
        l_Rec_AllocationLogLine."Shortcut Dimension 5 Code":=DImensions[5];
        l_Rec_AllocationLogLine."Shortcut Dimension 6 Code":=DImensions[6];
        l_Rec_AllocationLogLine."Shortcut Dimension 7 Code":=DImensions[7];
        l_Rec_AllocationLogLine."Shortcut Dimension 8 Code":=DImensions[8];
        l_Rec_AllocationLogLine."Shortcut Dimension 9 Code":=DImensions[9];
        l_Rec_AllocationLogLine."Shortcut Dimension 10 Code":=DImensions[10];
        l_Rec_AllocationLogLine."Shortcut Dimension 11 Code":=DImensions[11];
        l_Rec_AllocationLogLine."Shortcut Dimension 12 Code":=DImensions[12];
        l_Rec_AllocationLogLine."Shortcut Dimension 13 Code":=DImensions[13];
        l_Rec_AllocationLogLine."Shortcut Dimension 14 Code":=DImensions[14];
        l_Rec_AllocationLogLine."Shortcut Dimension 15 Code":=DImensions[15];
        l_Rec_AllocationLogLine.INSERT;
        EXIT(g_int_LogHdrLineNo);
    end;
    procedure GetDestinationTotalAmount(RuleNo: Code[20]; FactorAmt: Decimal): Decimal var
        l_rec_DestRule: Record "Allocation Destination";
        l_rec_AllocRule: Record "Allocation Rule";
    begin
        l_rec_AllocRule.GET(RuleNo);
        IF l_rec_AllocRule."Date Interval Code" = l_rec_AllocRule."Date Interval Code"::Min THEN begin
        end
        else
            EXIT(FactorAmt);
    end;
    trigger OnPreReport()
    begin
        IF NOT Confirm('Are you sure you want to Process the journal', false)then Exit;
        g_int_GeneratingPhase:=1;
        g_dia_Windows.Open(g_lbl_ProgressText, g_int_GeneratingPhase, g_int_MaxPhase);
    end;
    trigger OnPostReport()
    begin
        g_dia_Windows.Close();
    end;
    var g_dia_Windows: Dialog;
    g_int_GeneratingPhase: integer;
    g_int_MaxPhase: Integer;
    g_lbl_ProgressText: Label 'Processing: #1';
    g_bol_LogHdrGenerated: BOolean;
    g_dec_Denominator: Decimal;
    g_int_LogHdrLineNo: Integer;
    g_bol_Post: Boolean;
    g_dat_RunDate: Date;
    g_dat_PostingDate: Date;
    g_dat_StartDate: Date;
    g_dat_EndDate: Date;
    g_Rec_GenJnlLineTemp: Record "Gen. Journal Line" temporary;
    g_bol_HasMin: Boolean;
    g_dat_MinFromDate: Date;
    g_dat_MinToDate: Date;
    l_cod_ICDimensions: Array[15]OF Code[20];
}
