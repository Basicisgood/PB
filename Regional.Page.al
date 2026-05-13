page 50175 Regional
{
    ApplicationArea = All;
    Caption = 'Regional';
    PageType = List;
    SourceTable = Regional;
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
                field(proxyId; Rec.proxyId)
                {
                    ToolTip = 'Specifies the value of the proxyId field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(txId; Rec.txId)
                {
                    ToolTip = 'Specifies the value of the txId field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(sendingID; Rec.sendingID)
                {
                    ToolTip = 'Specifies the value of the sendingID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(termID; Rec.termID)
                {
                    ToolTip = 'Specifies the value of the termID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(billRef; Rec.billRef)
                {
                    ToolTip = 'Specifies the value of the billRef field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(billRef2; Rec.billRef2)
                {
                    ToolTip = 'Specifies the value of the billRef2 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(billRef3; Rec.billRef3)
                {
                    ToolTip = 'Specifies the value of the billRef3 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(dupPmt; Rec.dupPmt)
                {
                    ToolTip = 'Specifies the value of the dupPmt field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(txAmt; Rec.txAmt)
                {
                    ToolTip = 'Specifies the value of the txAmt field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(oriTxDate; Rec.oriTxDate)
                {
                    ToolTip = 'Specifies the value of the oriTxDate field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(payPurpose; Rec.payPurpose)
                {
                    ToolTip = 'Specifies the value of the payPurpose field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(txTime; Rec.txTime)
                {
                    ToolTip = 'Specifies the value of the txTime field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
