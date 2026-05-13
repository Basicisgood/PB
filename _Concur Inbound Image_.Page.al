page 50220 "Concur Inbound Image"
{
    ApplicationArea = All;
    Caption = 'Concur Inbound Image';
    PageType = List;
    SourceTable = "Concur Inbound Image";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry no"; Rec."Entry no")
                {
                    ToolTip = 'Specifies the value of the Entry no field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Image ID"; Rec."Image ID")
                {
                    ToolTip = 'Specifies the value of the Image ID field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Image URL "; Rec."Image URL ")
                {
                    ToolTip = 'Specifies the value of the Image URL field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Status "; Rec."Status ")
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Description (Error message)"; Rec."Description (Error message)")
                {
                    ToolTip = 'Specifies the value of the Description (Error message) field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Creation date/time "; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the Creation date/time field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Processed date/time "; Rec."Processed date/time ")
                {
                    ToolTip = 'Specifies the value of the Processed date/time field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Process status "; Rec."Process status ")
                {
                    ToolTip = 'Specifies the value of the Process status field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Process error message "; Rec."Process error message ")
                {
                    ToolTip = 'Specifies the value of the Process error message field.', Comment = '%';
                    ApplicationArea = all;
                }
            }
        }
    }
}
