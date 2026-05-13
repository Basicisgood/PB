page 50170 "Incoming Fund Alert"
{
    ApplicationArea = All;
    Caption = 'Incoming Fund Alert';
    PageType = List;
    SourceTable = "Incoming Fund Alert";
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
                field(requestTime; Rec.requestTime)
                {
                    ToolTip = 'Specifies the value of the requestTime field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(notificationType; Rec.notificationType)
                {
                    ToolTip = 'Specifies the value of the notificationType field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(acctNo; Rec.acctNo)
                {
                    ToolTip = 'Specifies the value of the acctNo field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(acctName; Rec.acctName)
                {
                    ToolTip = 'Specifies the value of the acctName field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(acctRegion; Rec.acctRegion)
                {
                    ToolTip = 'Specifies the value of the acctRegion field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(payerAcctNo; Rec.payerAcctNo)
                {
                    ToolTip = 'Specifies the value of the payerAcctNo field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(payerName; Rec.payerName)
                {
                    ToolTip = 'Specifies the value of the payerName field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(txTime; Rec.txTime)
                {
                    ToolTip = 'Specifies the value of the txTime field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(crCur; Rec.crCur)
                {
                    ToolTip = 'Specifies the value of the crCur field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(crAmt; Rec.crAmt)
                {
                    ToolTip = 'Specifies the value of the crAmt field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(txType; Rec.txType)
                {
                    ToolTip = 'Specifies the value of the txType field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(particular; Rec.particular)
                {
                    ToolTip = 'Specifies the value of the particular field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(messageBase64; Rec.messageBase64)
                {
                    ToolTip = 'Specifies the value of the messageBase64 field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
