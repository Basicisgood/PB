report 50159 DaySourcePatch
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(DAYSOURCE; DAYSOURCE)
        {
            trigger OnPreDataItem()
            var
                l_Rec_PoolDistribution: Record "Pool Distribution";
                l_Rec_ManagementFeeDistribution: Record "Management Fee Distribution";
            begin
                IF g_bol_ClearList THEN begin
                    g_bol_ClearList:=FALSE;
                    l_Rec_PoolDistribution.RESET;
                    IF l_Rec_PoolDistribution.FIND('-')then l_Rec_PoolDistribution.DELETEALL;
                    l_Rec_ManagementFeeDistribution.RESET;
                    IF l_Rec_ManagementFeeDistribution.FIND('-')then l_Rec_ManagementFeeDistribution.DELETEALL;
                end;
                SETFILTER("Days Type", '=%1|%2', 'Revenue Days', 'Operating Days');
            end;
            trigger OnAfterGetRecord()
            begin
                IF g_bol_ClearList THEN begin
                    "Company Name":='';
                    "IC Partner Code":='';
                end;
                DAYSOURCE.VALIDATE(Period);
                DAYSOURCE.VALIDATE(T1);
                DAYSOURCE.VALIDATE("Head Company", Daysource."Head Company");
                DAYSOURCE.fn_GetCompanyName();
                DAYSOURCE.MODIFY;
                fn_PopulateDataToDistributions();
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
                    field(g_bol_ClearList; g_bol_ClearList)
                    {
                        Caption = 'Clear List';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
    procedure fn_PopulateDataToDistributions()
    var
        l_Rec_PoolDistribution: Record "Pool Distribution";
        l_Rec_ManagementFeeDistribution: Record "Management Fee Distribution";
        l_int_LastEntry: Integer;
    begin
        IF DAYSOURCE."Company Name" = '' then EXIT;
        IF DAYSOURCE."Days Type" = 'Revenue Days' THEN begin
            l_Rec_PoolDistribution.RESET;
            l_Rec_PoolDistribution.SETRANGE("Company Name", DAYSOURCE."Company Name");
            l_Rec_PoolDistribution.SETRANGE("Days Type", DAYSOURCE."Days Type");
            l_Rec_PoolDistribution.SETRANGE(Period, DAYSOURCE.Period);
            l_Rec_PoolDistribution.SETRANGE("Source Date", DAYSOURCE."Source Date");
            l_Rec_PoolDistribution.SetRange("Pool Points", DAYSOURCE."Pool Points");
            IF NOT l_Rec_PoolDistribution.FINDSET THEN begin
                l_Rec_PoolDistribution.RESET;
                IF l_Rec_PoolDistribution.FindLast()then l_int_LastEntry:=l_Rec_PoolDistribution."Entry No.";
                l_int_LastEntry+=1;
                l_Rec_PoolDistribution.RESET;
                l_Rec_PoolDistribution.INIT;
                l_Rec_PoolDistribution."Entry No.":=l_int_LastEntry;
                l_Rec_PoolDistribution."Company Name":=DAYSOURCE."Company Name";
                l_Rec_PoolDistribution."Days Type":=DAYSOURCE."Days Type";
                l_Rec_PoolDistribution.Period:=DAYSOURCE.Period;
                l_Rec_PoolDistribution."Source Date":=DAYSOURCE."Source Date";
                l_Rec_PoolDistribution."Pool Points":=DAYSOURCE."Pool Points";
                l_Rec_PoolDistribution.T1:=DAYSOURCE.T1;
                l_Rec_PoolDistribution."IC Partner No.":=DAYSOURCE."IC Partner Code";
                l_Rec_PoolDistribution.INSERT;
            end;
        end
        ELSE iF(DAYSOURCE."Days Type" = 'Operating Days')then begin
                l_Rec_ManagementFeeDistribution.RESET;
                l_Rec_ManagementFeeDistribution.SETRANGE("Company Name", DAYSOURCE."Company Name");
                l_Rec_ManagementFeeDistribution.SETRANGE("Days Type", DAYSOURCE."Days Type");
                l_Rec_ManagementFeeDistribution.SETRANGE(Period, DAYSOURCE.Period);
                l_Rec_ManagementFeeDistribution.SETRANGE("Source Date", DAYSOURCE."Source Date");
                IF NOT l_Rec_ManagementFeeDistribution.FINDSET THEN begin
                    l_Rec_ManagementFeeDistribution.RESET;
                    IF l_Rec_ManagementFeeDistribution.FindLast()then l_int_LastEntry:=l_Rec_ManagementFeeDistribution."Entry No.";
                    l_int_LastEntry+=1;
                    l_Rec_ManagementFeeDistribution.RESET;
                    l_Rec_ManagementFeeDistribution.INIT;
                    l_Rec_ManagementFeeDistribution."Entry No.":=l_int_LastEntry;
                    l_Rec_ManagementFeeDistribution."Company Name":=DAYSOURCE."Company Name";
                    l_Rec_ManagementFeeDistribution."Days Type":=DAYSOURCE."Days Type";
                    l_Rec_ManagementFeeDistribution.Period:=DAYSOURCE.Period;
                    l_Rec_ManagementFeeDistribution."Source Date":=DAYSOURCE."Source Date";
                    l_Rec_ManagementFeeDistribution.T1:=DAYSOURCE.T1;
                    l_Rec_ManagementFeeDistribution."IC Partner No.":=DAYSOURCE."IC Partner Code";
                    l_Rec_ManagementFeeDistribution.INSERT;
                end;
            end;
    end;
    var myInt: Integer;
    g_bol_ClearList: boolean;
}
