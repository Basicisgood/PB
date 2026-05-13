page 50174 "Transaction Instruction Status"
{
    ApplicationArea = All;
    Caption = 'Transaction Instruction Status';
    PageType = List;
    SourceTable = "Transaction Instruction Status";
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
                field(txType; Rec.txType)
                {
                    ToolTip = 'Specifies the value of the txType field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(cur; Rec.cur)
                {
                    ToolTip = 'Specifies the value of the cur field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(amt; Rec.amt)
                {
                    ToolTip = 'Specifies the value of the amt field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(payerAcctNo; Rec.payerAcctNo)
                {
                    ToolTip = 'Specifies the value of the payerAcctNo field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(payerAcctName; Rec.payerAcctName)
                {
                    ToolTip = 'Specifies the value of the payerAcctNo field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(effectiveDate; Rec.effectiveDate)
                {
                    ToolTip = 'Specifies the value of the effectiveDate field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(txStatus; Rec.txStatus)
                {
                    ToolTip = 'Specifies the value of the txStatus field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(iGTBRef; Rec.iGTBRef)
                {
                    ToolTip = 'Specifies the value of the iGTBRef field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(custRef; Rec.custRef)
                {
                    ToolTip = 'Specifies the value of the custRef field.', Comment = '%';
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
