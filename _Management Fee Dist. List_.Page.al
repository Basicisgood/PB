page 50215 "Management Fee Dist. List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Management Fee Distribution";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(T1; Rec.T1)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = All;
                }
                field("IC Partner No."; Rec."IC Partner No.")
                {
                    ApplicationArea = All;
                }
                field(Period; Rec.Period)
                {
                    ApplicationArea = All;
                }
                field("Source Date"; Rec."Source Date")
                {
                    ApplicationArea = All;
                }
                field("Calc. Days"; Rec."Calc. Days")
                {
                    ApplicationArea = All;
                }
            /*                field(g_txt_T1; g_txt_T1) { Caption = 'T1'; }
                                field(g_txt_CompanyName; g_txt_CompanyName) { Caption = 'Company Name'; }
                                field(g_txt_ICPartnerCode; g_txt_ICPartnerCode) { Caption = 'IC Partner Code'; }
                                field(g_txt_Period; g_txt_Period) { Caption = 'Period'; }
                                field(g_dat_SourceDate; g_dat_SourceDate) { Caption = 'Source Date'; }
                                field(g_dec_PoolPoints; g_dec_PoolPoints) { Caption = 'Pool Point'; }
                                field(g_dec_Days; g_dec_Days) { Caption = 'Days'; }*/
            }
        }
    }
/*
        trigger OnOpenPage()
        var
            l_qry_DaySource: Query PoolDistributionQuery;
        begin
            l_qry_DaySource.OPEN;
            IF l_qry_DaySource.Read() THEN BEGIN
                repeat
                    g_int_NoOfRecord += 1;
                    g_Rec_PoolDistribution.RESET;
                    g_Rec_PoolDistribution.INIT;
                    g_Rec_PoolDistribution."Entry No." := g_int_NoOfRecord;
                    g_Rec_PoolDistribution.T1 := l_qry_DaySource.T1;
                    g_Rec_PoolDistribution."Company Name" := l_qry_DaySource.Company_Name;
                    g_Rec_PoolDistribution."IC Partner No." := l_qry_DaySource.IC_Partner_Code;
                    g_Rec_PoolDistribution.Period := l_qry_DaySource.Period;
                    g_Rec_PoolDistribution."Source Date" := l_qry_DaySource.Source_Date;
                    g_Rec_PoolDistribution."Pool Points" := l_qry_DaySource.Pool_Points;
                    g_Rec_PoolDistribution."Calc. Days" := l_qry_DaySource.Days;
                    g_Rec_PoolDistribution.INSERT;
                Until l_qry_DaySource.Read() = false;
            END;

            Rec.SETRANGE(Number, 1, g_int_NoOfRecord);

        end;

        trigger OnAfterGetRecord()
        begin
            g_txt_T1 := '';
            g_txt_CompanyName := '';
            g_txt_ICPartnerCode := '';
            g_txt_Period := '';
            g_dat_SourceDate := 0D;
            g_dec_Days := 0;
            g_dec_PoolPoints := 0;
            g_dec_PointXDay := 0;
            IF Rec.Number = 1 THEN begin
                g_Rec_PoolDistribution.RESET;
                IF g_Rec_PoolDistribution.FIND('-') THEN begin
                    g_txt_T1 := g_Rec_PoolDistribution.T1;
                    g_txt_CompanyName := g_Rec_PoolDistribution."Company Name";
                    g_txt_ICPartnerCode := g_Rec_PoolDistribution."IC Partner No.";
                    g_txt_Period := g_Rec_PoolDistribution.Period;
                    g_dat_SourceDate := g_Rec_PoolDistribution."Source Date";
                    g_dec_Days := g_Rec_PoolDistribution."Calc. Days";
                    g_dec_PoolPoints := g_Rec_PoolDistribution."Pool Points";
                    g_dec_PointXDay := 0;
                end;
            end ELSE begin
                IF g_Rec_PoolDistribution.Next <> 0 THEN begin
                    g_txt_T1 := g_Rec_PoolDistribution.T1;
                    g_txt_CompanyName := g_Rec_PoolDistribution."Company Name";
                    g_txt_ICPartnerCode := g_Rec_PoolDistribution."IC Partner No.";
                    g_txt_Period := g_Rec_PoolDistribution.Period;
                    g_dat_SourceDate := g_Rec_PoolDistribution."Source Date";
                    g_dec_Days := g_Rec_PoolDistribution."Calc. Days";
                    g_dec_PoolPoints := g_Rec_PoolDistribution."Pool Points";
                    g_dec_PointXDay := 0;
                end;
            end;
        end;

        var
            g_int_NoOfRecord: integer;
            g_Rec_PoolDistribution: Record "Pool Distribution" temporary;
            g_txt_T1: Text;
            g_txt_CompanyName: Text;
            g_txt_ICPartnerCode: Text;
            g_dec_PoolPoints: Decimal;
            g_txt_Period: Text;
            g_dat_SourceDate: Date;
            g_dec_Days: Decimal;
            g_dec_PointXDay: Decimal;
            g_txt_DayType: Text;
    */
}
