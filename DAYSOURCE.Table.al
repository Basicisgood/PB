table 50114 DAYSOURCE
{
    Caption = 'Rec';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; T1; Code[20])
        {
            Caption = 'T1';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                fn_GetCompanyName;
            end;
        }
        field(3; T3; Integer)
        {
            Caption = 'T3';
            DataClassification = CustomerContent;
        }
        field(4; "Days Type"; Text[30])
        {
            Caption = 'Days Type';
            DataClassification = CustomerContent;
        }
        field(5; "Contract Type"; Text[50])
        {
            Caption = 'Contract Type';
            DataClassification = CustomerContent;
        }
        field(6; Period; Code[10])
        {
            Caption = 'Period';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                YearPeriod: Integer;
                MonthPeriod: integer;
            begin
                IF STRLEN(Period) <> 7 then Error('Period must be 7 characters only');
                IF NOT Evaluate(YearPeriod, COPYSTR(Period, 1, 4))then ERROR('Invalid Year Entry for Peroid' + COPYSTR(Period, 1, 4));
                IF NOT Evaluate(MonthPeriod, COPYSTR(Period, 6, 2))then ERROR('Invalid Month Entry for Peroid' + COPYSTR(Period, 6, 2));
                if MonthPeriod > 12 then ERROR('Invalid Month Entry for Peroid' + COPYSTR(Period, 6, 2));
                if MonthPeriod = 12 then "Source Date":=DMY2DATE(31, MonthPeriod, YearPeriod)
                else
                    "Source Date":=DMY2DATE(1, MonthPeriod + 1, YearPeriod) - 1;
            end;
        }
        field(7; Days; Decimal)
        {
            Caption = 'Days';
            DataClassification = CustomerContent;
        }
        field(8; "TCI Code"; Code[20])
        {
            Caption = 'TCI Code';
            DataClassification = CustomerContent;
        }
        field(9; "Vessel Type"; Code[20])
        {
            Caption = 'Vessel Type';
            DataClassification = CustomerContent;
        }
        field(10; Vessel; Text[150])
        {
            Caption = 'Vessel';
            DataClassification = CustomerContent;
        }
        field(11; VoyNo; Code[10])
        {
            Caption = 'VoyNo';
            DataClassification = CustomerContent;
        }
        field(12; T2; Code[20])
        {
            Caption = 'T2';
            DataClassification = CustomerContent;
        }
        field(13; vslType; Text[20])
        {
            Caption = 'vslType';
            DataClassification = CustomerContent;
        }
        field(14; "Head Company"; Code[20])
        {
            Caption = 'Head Company';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                fn_GetCompanyName;
            end;
        }
        field(15; "Pool Points"; Decimal)
        {
            Caption = 'Pool Points';
            DataClassification = CustomerContent;
        }
        field(16; "Company Name"; Text[100])
        {
        }
        field(17; "IC Partner Code"; Code[20])
        {
        }
        field(18; "Source Date"; Date)
        {
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        fn_PopulateDataToDistribution()end;
    trigger OnModify()
    begin
        fn_PopulateDataToDistribution()end;
    procedure fn_PopulateDataToDistribution()
    var
        l_Rec_Rec: REcord DAYSOURCE;
        l_rpt_RecPatch: Report DaySourcePatch;
    begin
        fn_PopulateDataToDistributions;
        EXIT;
        l_Rec_Rec.RESET;
        l_Rec_Rec.SETRANGE("Entry No.", Rec."Entry No.");
        CLEAR(l_rpt_RecPatch);
        l_rpt_RecPatch.SetTableView(l_Rec_Rec);
        l_rpt_RecPatch.UseRequestPage:=false;
        l_rpt_RecPatch.RUNMODAL;
    end;
    procedure fn_GetCompanyName()
    var
        l_Rec_VMT: Record VMT;
        l_Rec_Company: Record Company;
        l_rec_ICPartner: Record "IC Partner";
        l_rec_CompanyMapping: Record "Company Name Mapping";
    begin
        IF "Head Company" <> '' THEN BEGIN
            l_Rec_VMT.RESET;
            l_Rec_VMT.SETRANGE("DBASE", '0' + COPYSTR("Head Company", 2, 10));
            IF l_Rec_VMT.FINDSET THEN begin
                l_rec_CompanyMapping.RESET;
                l_rec_CompanyMapping.SETRANGE("PB Company Code", l_REc_VMT."Head Company");
                IF l_rec_CompanyMapping.FINDSET THEN begin
                    //IF NOT l_Rec_Company.GET(l_rec_CompanyMapping."BC Company Name") then
                    //    ERROR('BC Company Name: ' + l_rec_CompanyMapping."BC Company Name" + ' not able to find corresponding Company');
                    "Company Name":=l_rec_CompanyMapping."BC Company Name";
                end
                ELSE
                begin
                //ERROR('DBASE: ' + l_Rec_VMT.DBASE + ' not able to find corresponding PB Company Mapping');
                end;
            end;
        END
        ELSE
        begin
            l_Rec_VMT.RESET;
            l_Rec_VMT.SETRANGE(VESSELCODE, T1);
            IF l_Rec_VMT.FINDSET THEN begin
                l_rec_CompanyMapping.RESET;
                l_rec_CompanyMapping.SETRANGE("PB Company Code", l_REc_VMT.DBASE);
                IF l_rec_CompanyMapping.FINDSET THEN begin
                    //IF NOT l_Rec_Company.GET(l_rec_CompanyMapping."BC Company Name") then
                    //    ERROR('BC Company Name: ' + l_rec_CompanyMapping."BC Company Name" + ' not able to find corresponding Company');
                    "Company Name":=l_rec_CompanyMapping."BC Company Name";
                end
                ELSE
                begin
                //ERROR('DBASE: ' + l_Rec_VMT.DBASE + ' not able to find corresponding PB Company Mapping');
                end;
            end;
        end;
        //    ERROR('VMT not found for Vesselcode: ' + T1);
        IF "Company Name" <> '' THEN begin
            l_rec_ICPartner.RESET;
            l_rec_ICPartner.SETRANGE("Inbox Details", "Company Name");
            IF l_rec_ICPartner.FindSet THEN begin
                "IC Partner Code":=l_rec_ICPartner.Code;
            end
            ELSE
            begin
                "IC Partner Code":="Company Name";
            end;
        END;
    end;
    procedure fn_PopulateDataToDistributions()
    var
        l_Rec_PoolDistribution: Record "Pool Distribution";
        l_Rec_ManagementFeeDistribution: Record "Management Fee Distribution";
        l_int_LastEntry: Integer;
    begin
        IF Rec."Days Type" = 'Revenue Days' THEN begin
            l_Rec_PoolDistribution.RESET;
            l_Rec_PoolDistribution.SETRANGE("Company Name", Rec."Company Name");
            l_Rec_PoolDistribution.SETRANGE("Days Type", Rec."Days Type");
            l_Rec_PoolDistribution.SETRANGE(Period, Rec.Period);
            l_Rec_PoolDistribution.SETRANGE("Source Date", Rec."Source Date");
            l_Rec_PoolDistribution.SetRange("Pool Points", Rec."Pool Points");
            IF NOT l_Rec_PoolDistribution.FINDSET THEN begin
                l_Rec_PoolDistribution.RESET;
                IF l_Rec_PoolDistribution.FindLast()then l_int_LastEntry:=l_Rec_PoolDistribution."Entry No.";
                l_int_LastEntry+=1;
                l_Rec_PoolDistribution.RESET;
                l_Rec_PoolDistribution.INIT;
                l_Rec_PoolDistribution."Entry No.":=l_int_LastEntry;
                l_Rec_PoolDistribution."Company Name":=Rec."Company Name";
                l_Rec_PoolDistribution."Days Type":=Rec."Days Type";
                l_Rec_PoolDistribution.Period:=Rec.Period;
                l_Rec_PoolDistribution."Source Date":=Rec."Source Date";
                l_Rec_PoolDistribution."Pool Points":=Rec."Pool Points";
                l_Rec_PoolDistribution.T1:=Rec.T1;
                l_Rec_PoolDistribution."IC Partner No.":=Rec."IC Partner Code";
                l_Rec_PoolDistribution.INSERT;
            end;
        end
        ELSE IF Rec."Days Type" = 'Operating Days' THEN begin
                l_Rec_ManagementFeeDistribution.RESET;
                l_Rec_ManagementFeeDistribution.SETRANGE("Company Name", Rec."Company Name");
                l_Rec_ManagementFeeDistribution.SETRANGE("Days Type", Rec."Days Type");
                l_Rec_ManagementFeeDistribution.SETRANGE(Period, Rec.Period);
                l_Rec_ManagementFeeDistribution.SETRANGE("Source Date", Rec."Source Date");
                IF NOT l_Rec_ManagementFeeDistribution.FINDSET THEN begin
                    l_Rec_ManagementFeeDistribution.RESET;
                    IF l_Rec_ManagementFeeDistribution.FindLast()then l_int_LastEntry:=l_Rec_ManagementFeeDistribution."Entry No.";
                    l_int_LastEntry+=1;
                    l_Rec_ManagementFeeDistribution.RESET;
                    l_Rec_ManagementFeeDistribution.INIT;
                    l_Rec_ManagementFeeDistribution."Entry No.":=l_int_LastEntry;
                    l_Rec_ManagementFeeDistribution."Company Name":=Rec."Company Name";
                    l_Rec_ManagementFeeDistribution."Days Type":=Rec."Days Type";
                    l_Rec_ManagementFeeDistribution.Period:=Rec.Period;
                    l_Rec_ManagementFeeDistribution."Source Date":=Rec."Source Date";
                    l_Rec_ManagementFeeDistribution.T1:=Rec.T1;
                    l_Rec_ManagementFeeDistribution."IC Partner No.":=Rec."IC Partner Code";
                    l_Rec_ManagementFeeDistribution.INSERT;
                end;
            end;
    end;
}
