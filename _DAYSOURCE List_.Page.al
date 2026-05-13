page 50121 "DAYSOURCE List"
{
    ApplicationArea = All;
    Caption = 'DAYSOURCE List';
    PageType = List;
    SourceTable = DAYSOURCE;
    UsageCategory = Lists;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(T1; Rec.T1)
                {
                    ToolTip = 'Specifies the value of the T1 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(T2; Rec.T2)
                {
                    ToolTip = 'Specifies the value of the T2 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(T3; Rec.T3)
                {
                    ToolTip = 'Specifies the value of the T3 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Days Type"; Rec."Days Type")
                {
                    ToolTip = 'Specifies the value of the Days Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Contract Type"; Rec."Contract Type")
                {
                    ToolTip = 'Specifies the value of the Contract Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Period; Rec.Period)
                {
                    ToolTip = 'Specifies the value of the Period field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Vessel; Rec.Vessel)
                {
                    ToolTip = 'Specifies the value of the Vessel field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(VoyNo; Rec.VoyNo)
                {
                    ToolTip = 'Specifies the value of the VoyNo field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(vslType; Rec.vslType)
                {
                    ToolTip = 'Specifies the value of the vslType field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Vessel Type"; Rec."Vessel Type")
                {
                    ToolTip = 'Specifies the value of the Vessel Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Days; Rec.Days)
                {
                    ToolTip = 'Specifies the value of the Days field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Head Company"; Rec."Head Company")
                {
                    ToolTip = 'Specifies the value of the Head Company field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Pool Points"; Rec."Pool Points")
                {
                    ToolTip = 'Specifies the value of the Pool Points field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("TCI Code"; Rec."TCI Code")
                {
                    ToolTip = 'Specifies the value of the TCI Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = All;
                }
                field("IC Partner Code"; Rec."IC Partner Code")
                {
                    ApplicationArea = All;
                }
                field("Source Date"; Rec."Source Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Import Excel")
            {
                Caption = 'Import Excel';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Import action.';

                trigger OnAction()
                var
                    ImportDaySourcefromExcel_l: Report "Import DaySource from Excel";
                begin
                    ImportDaySourcefromExcel_l.Run();
                end;
            }
            action("Data Process")
            {
                Caption = 'Patch to Pool & Management Table';
                ApplicationArea = All;

                trigger OnAction()
                var
                    l_rpt_DataPatch: Report DaySourcePatch;
                    l_Rec_DaySource: REcord DAYSOURCE;
                begin
                    l_Rec_DaySource.RESET;
                    l_Rec_DaySource.SETRANGE("Entry No.", Rec."Entry No.");
                    IF l_Rec_DaySource.FINDSET THEN;
                    CLEAR(l_rpt_DataPatch);
                    //l_rpt_DataPatch.SetTableView(l_Rec_DaySource);
                    l_rpt_DataPatch.RUN;
                end;
            }
            action("Pool Distribution")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    l_pag_PoolDistribution: Page "Pool Distribution List";
                begin
                    l_pag_PoolDistribution.RUN;
                end;
            }
            action("Management Distribution")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    l_pag_ManagementDistribution: Page "Management Fee Dist. List";
                begin
                    l_pag_ManagementDistribution.RUN;
                end;
            }
        }
    }
}
