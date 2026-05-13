page 50183 "HSBC Notification"
{
    ApplicationArea = All;
    Caption = 'HSBC Notification';
    PageType = List;
    SourceTable = "HSBC Notification";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(platformAc; Rec.platformAc)
                {
                    ToolTip = 'Specifies the value of the platformAc field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(keyName; Rec.keyName)
                {
                    ToolTip = 'Specifies the value of the keyName field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(messageId; Rec.messageId)
                {
                    ToolTip = 'Specifies the value of the messageId field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
