page 50102 "Allocation Rule Source"
{
    ApplicationArea = All;
    Caption = 'Allocation Rule Source';
    PageType = List;
    SourceTable = "Allocation Source";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Field Setting"; Rec."Field Setting")
                {
                    ToolTip = 'Specifies the value of the Field Setting field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Source Criteria"; Rec."Source Criteria")
                {
                    ToolTip = 'Specifies the value of the Source Criteria field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("No markup"; Rec."No markup")
                {
                    ApplicationArea = All;
                }
                field("Last Source Amount get"; Rec."Last Source Amount get")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Last Get From Date"; Rec."Last Get From Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Last Get To Date"; Rec."Last Get To Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            part("Allocation Source Company"; "Allocation Source Company")
            {
                SubPageLink = rule=field(rule), "Line No."=field("Line No.");
                ApplicationArea = All;
            }
        }
    }
}
