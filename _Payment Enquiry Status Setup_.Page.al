page 50234 "Payment Enquiry Status Setup"
{
    ApplicationArea = All;
    Caption = 'Payment Enquiry Status Setup';
    PageType = List;
    SourceTable = "Payment Enquiry Status Setup";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Reprocess; Rec.Reprocess)
                {
                    ToolTip = 'Specifies the value of the Reprocess field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
