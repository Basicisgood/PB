page 50233 "IMOS Bank Mapping List"
{
    ApplicationArea = All;
    Caption = 'IMOS Bank Mapping List';
    PageType = List;
    SourceTable = "IMOS Bank Mapping";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("IMOS Bank ID"; Rec."IMOS Bank ID")
                {
                    ToolTip = 'Specifies the value of the IMOS Bank ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("BC Bank Code"; Rec."BC Bank Code")
                {
                    ToolTip = 'Specifies the value of the BC Bank Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Dummy GL Code"; Rec."Dummy GL Code")
                {
                    ToolTip = 'Specifies the value of the Dummy GL Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("IC GL Code"; Rec."IC GL Code")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}
