page 50213 "Master Sync Details"
{
    ApplicationArea = All;
    Caption = 'Master Sync Details';
    PageType = List;
    SourceTable = "Master Sync Details";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field("Company Name"; Rec."Company Name")
                {
                    ToolTip = 'Specifies the value of the Company Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Sync DateTime"; Rec."Sync DateTime")
                {
                    ToolTip = 'Specifies the value of the Sync DateTime field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the value of the User Id field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
