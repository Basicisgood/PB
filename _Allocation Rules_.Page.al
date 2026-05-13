page 50100 "Allocation Rules"
{
    ApplicationArea = All;
    Caption = 'Allocation Rules';
    PageType = List;
    CardPageId = "Allocation Rule Card";
    SourceTable = "Allocation Rule";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Rule; Rec.Rule)
                {
                    ToolTip = 'Specifies the value of the Rule field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Active; Rec.Active)
                {
                    ToolTip = 'Specifies the value of the Active field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Date Last Run"; Rec."Date Last Run")
                {
                    ToolTip = 'Specifies the value of the Date Last Run field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ToolTip = 'Specifies the value of the Effective Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ToolTip = 'Specifies the value of the Expiration Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Execute Run System Date"; Rec."Execute Run System Date")
                {
                    ApplicationArea = All;
                }
                field("Intercompany Rule"; Rec."Intercompany Rule")
                {
                    ToolTip = 'Specifies the value of the Intercompany Rule field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
