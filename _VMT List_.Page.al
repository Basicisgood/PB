page 50120 "VMT List"
{
    ApplicationArea = All;
    Caption = 'VMT List';
    PageType = List;
    SourceTable = VMT;
    UsageCategory = Lists;

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
                field(DBASE; Rec.DBASE)
                {
                    ToolTip = 'Specifies the value of the DBASE field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(DBASENAME; Rec.DBASENAME)
                {
                    ToolTip = 'Specifies the value of the DBASENAME field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(DBASEGROUP; Rec.DBASEGROUP)
                {
                    ApplicationArea = all;
                }
                field(COSTCTR; Rec.COSTCTR)
                {
                    ToolTip = 'Specifies the value of the COSTCTR field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SEGMENT; Rec.SEGMENT)
                {
                    ToolTip = 'Specifies the value of the SEGMENT field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Use FD1 Mapping"; Rec."Use FD1 Mapping")
                {
                    ToolTip = 'Specifies whether to use FD1 Mapping.', Comment = '%';
                    ApplicationArea = All;
                }
                field("DNV Finance Comapny"; Rec."DNV Finance Comapny")
                {
                    ToolTip = 'Specifies the value of the DNV Finance Comapny field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(VESSELCODE; Rec.VESSELCODE)
                {
                    ToolTip = 'Specifies the value of the VESSELCODE field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(VESSEL; Rec.VESSEL)
                {
                    ToolTip = 'Specifies the value of the VESSEL field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SHIPSIGN; Rec.SHIPSIGN)
                {
                    ToolTip = 'Specifies the value of the SHIPSIGN field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("MFEE FACTOR"; Rec."MFEE FACTOR")
                {
                    ToolTip = 'Specifies the value of the MFEE FACTOR field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("MARKUP FACTOR"; Rec."MARKUP FACTOR")
                {
                    ToolTip = 'Specifies the value of the MARKUP FACTOR field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(TAXRATE; Rec.TAXRATE)
                {
                    ToolTip = 'Specifies the value of the TAXRATE field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(TINTYPE; Rec.TINTYPE)
                {
                    ToolTip = 'Specifies the value of the TINTYPE field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("TAX JURISDICTION"; Rec."TAX JURISDICTION")
                {
                    ToolTip = 'Specifies the value of the TAX JURISDICTION field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("INCORP PLACE"; Rec."INCORP PLACE")
                {
                    ToolTip = 'Specifies the value of the INCORP PLACE field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("DATE OF INCORPORATION"; Rec."DATE OF INCORPORATION")
                {
                    ToolTip = 'Specifies the value of the DATE OF INCORPORATION field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("DISSOLVED DATE"; Rec."DISSOLVED DATE")
                {
                    ToolTip = 'Specifies the value of the DISSOLVED DATE field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Head Company"; Rec."Head Company")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}
