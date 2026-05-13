page 50176 "Incoming Fund Alert API"
{
    APIGroup = 'BOC';
    APIPublisher = 'PB';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'incomingFundAlertAPI';
    DelayedInsert = true;
    EntityName = 'incomingFundAlert';
    EntitySetName = 'incomingFundAlerts';
    PageType = API;
    SourceTable = "Incoming Fund Alert";

    //https://api.businesscentral.dynamics.com/v2.0/ba92f9e8-c19e-47b4-88f8-ce3df6492b8f/SandBox_DEV/api/PB/BOS/v2.0/companies(1324cb6a-b638-ef11-8e51-6045bde99b08)/incomingFundAlerts
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(platformAc; Rec.platformAc)
                {
                    Caption = 'platformAc';
                }
                field(keyName; Rec.keyName)
                {
                    Caption = 'keyName';
                }
                field(messageId; Rec.messageId)
                {
                    Caption = 'messageId';
                }
                field(requestTime; Rec.requestTime)
                {
                    Caption = 'requestTime';
                }
                field(notificationType; Rec.notificationType)
                {
                    Caption = 'notificationType';
                }
                field(acctNo; Rec.acctNo)
                {
                    Caption = 'acctNo';
                }
                field(acctName; Rec.acctName)
                {
                    Caption = 'acctName';
                }
                field(acctRegion; Rec.acctRegion)
                {
                    Caption = 'acctRegion';
                }
                field(payerAcctNo; Rec.payerAcctNo)
                {
                    Caption = 'payerAcctNo';
                }
                field(payerName; Rec.payerName)
                {
                    Caption = 'payerName';
                }
                field(txTime; Rec.txTime)
                {
                    Caption = 'txTime';
                }
                field(crCur; Rec.crCur)
                {
                    Caption = 'crCur';
                }
                field(crAmt; Rec.crAmt)
                {
                    Caption = 'crAmt';
                }
                field(txType; Rec.txType)
                {
                    Caption = 'txType';
                }
                field(particular; Rec.particular)
                {
                    Caption = 'particular';
                }
                field(messageBase64; Rec.messageBase64)
                {
                    Caption = 'messageBase64';
                }
                field(systemCreatedAt; Rec.SystemCreatedAt)
                {
                    Caption = 'SystemCreatedAt';
                }
                field(systemCreatedBy; Rec.SystemCreatedBy)
                {
                    Caption = 'SystemCreatedBy';
                }
                field(systemModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'SystemModifiedAt';
                }
                field(systemModifiedBy; Rec.SystemModifiedBy)
                {
                    Caption = 'SystemModifiedBy';
                }
            }
        }
    }
}
