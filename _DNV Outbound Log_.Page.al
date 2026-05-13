page 50113 "DNV Outbound Log"
{
    ApplicationArea = All;
    Caption = 'DNV Outbound Log';
    PageType = List;
    SourceTable = "DNV Outbound Log";
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
                field("Company Name"; Rec."Company Name")
                {
                    ToolTip = 'Specifies the value of the Company Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Primary key"; Rec."Primary key")
                {
                    ToolTip = 'Specifies the value of the Primary key field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Primary key 2"; Rec."Primary key 2")
                {
                    ToolTip = 'Specifies the value of the Primary key 2 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Table No."; Rec."Table No.")
                {
                    ToolTip = 'Specifies the value of the Table No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ToolTip = 'Specifies the value of the Entry Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Error Reason"; Rec."Error Reason")
                {
                    ToolTip = 'Specifies the value of the Error Reason field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Sent Date Time"; Rec."Sent Date Time")
                {
                    ToolTip = 'Specifies the value of the Sent Date Time field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
