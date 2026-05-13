page 50256 "IMOS Voyage Lookup Table"
{
    ApplicationArea = All;
    Caption = 'IMOS Voyage Lookup Table';
    PageType = List;
    SourceTable = "IMOS Voyage Lookup Table";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Vessel; Rec.Vessel)
                {
                    ToolTip = 'Specifies the value of the Vessel field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(FD1Name; Rec.FD1Name)
                {
                    ToolTip = 'Specifies the value of the FD1Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(FD2; Rec.FD2)
                {
                    ToolTip = 'Specifies the value of the FD2 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(FD4; Rec.FD4)
                {
                    ToolTip = 'Specifies the value of the FD4 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(FD3; Rec.FD3)
                {
                    ToolTip = 'Specifies the value of the FD3 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Opr Type"; Rec."Opr Type")
                {
                    ToolTip = 'Specifies the value of the Opr Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Voyage Start/GMT"; Rec."Voyage Start/GMT")
                {
                    ToolTip = 'Specifies the value of the Voyage Start/GMT field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Voyage End/GMT"; Rec."Voyage End/GMT")
                {
                    ToolTip = 'Specifies the value of the Voyage End/GMT field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Full On Hire Days"; Rec."Full On Hire Days")
                {
                    ToolTip = 'Specifies the value of the Full On Hire Days field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(LOB; Rec.LOB)
                {
                    ToolTip = 'Specifies the value of the LOB field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Voyage Trade Area"; Rec."Voyage Trade Area")
                {
                    ToolTip = 'Specifies the value of the Voyage Trade Area field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Voyage Status"; Rec."Voyage Status")
                {
                    ToolTip = 'Specifies the value of the Voyage Status field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("TC In Contract Type"; Rec."TC In Contract Type")
                {
                    ToolTip = 'Specifies the value of the TC In Contract Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Contract Type"; Rec."Contract Type")
                {
                    ToolTip = 'Specifies the value of the Contract Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Index/Non Index"; Rec."Index/Non Index")
                {
                    ToolTip = 'Specifies the value of the Index/Non Index field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Period; Rec.Period)
                {
                    ToolTip = 'Specifies the value of the Period field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Opr_LOB; Rec.Opr_LOB)
                {
                    ToolTip = 'Specifies the value of the Opr_LOB field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Opr_Trade_Area; Rec.Opr_Trade_Area)
                {
                    ToolTip = 'Specifies the value of the Opr_Trade_Area field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(LastVoy; Rec.LastVoy)
                {
                    ToolTip = 'Specifies the value of the LastVoy field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(COA; Rec.COA)
                {
                    ToolTip = 'Specifies the value of the COA field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Core Operating"; Rec."Core Operating")
                {
                    ToolTip = 'Specifies the value of the Core Operating field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(ANAL_T3_KEY; Rec.ANAL_T3_KEY)
                {
                    ToolTip = 'Specifies the value of the ANAL_T3_KEY field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(T2Key; Rec.T2Key)
                {
                    ToolTip = 'Specifies the value of the T2Key field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(T3Key; Rec.T3Key)
                {
                    ToolTip = 'Specifies the value of the T3Key field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(T4Key; Rec.T4Key)
                {
                    ToolTip = 'Specifies the value of the T4Key field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(NewContractType; Rec.NewContractType)
                {
                    ToolTip = 'Specifies the value of the NewContractType field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(NewContractType1; Rec.NewContractType1)
                {
                    ToolTip = 'Specifies the value of the NewContractType1 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("TC Type"; Rec."TC Type")
                {
                    ToolTip = 'Specifies the value of the TC Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(NewContractType_full; Rec.NewContractType_full)
                {
                    ToolTip = 'Specifies the value of the NewContractType_full field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(NewContractType_RA; Rec.NewContractType_RA)
                {
                    ToolTip = 'Specifies the value of the NewContractType_RA field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(OP2_3; Rec.OP2_3)
                {
                    ToolTip = 'Specifies the value of the OP2_3 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(OP2_3A; Rec.OP2_3A)
                {
                    ToolTip = 'Specifies the value of the OP2_3A field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
