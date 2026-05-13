page 50181 RegionalAPI
{
    APIGroup = 'BOC';
    APIPublisher = 'PB';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'regional';
    DelayedInsert = true;
    EntityName = 'regional';
    EntitySetName = 'regionals';
    PageType = API;
    SourceTable = Regional;

    //https://api.businesscentral.dynamics.com/v2.0/ba92f9e8-c19e-47b4-88f8-ce3df6492b8f/SandBox_DEV/api/PB/BOS/v2.0/companies(1324cb6a-b638-ef11-8e51-6045bde99b08)/regionals
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
                field(proxyId; Rec.proxyId)
                {
                    Caption = 'proxyId';
                }
                field(txId; Rec.txId)
                {
                    Caption = 'txId';
                }
                field(sendingID; Rec.sendingID)
                {
                    Caption = 'sendingID';
                }
                field(termID; Rec.termID)
                {
                    Caption = 'termID';
                }
                field(billRef; Rec.billRef)
                {
                    Caption = 'billRef';
                }
                field(billRef2; Rec.billRef2)
                {
                    Caption = 'billRef2';
                }
                field(billRef3; Rec.billRef3)
                {
                    Caption = 'billRef3';
                }
                field(dupPmt; Rec.dupPmt)
                {
                    Caption = 'dupPmt';
                }
                field(txAmt; Rec.txAmt)
                {
                    Caption = 'txAmt';
                }
                field(oriTxDate; Rec.oriTxDate)
                {
                    Caption = 'oriTxDate';
                }
                field(payPurpose; Rec.payPurpose)
                {
                    Caption = 'payPurpose';
                }
                field(txTime; Rec.txTime)
                {
                    Caption = 'txTime';
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
