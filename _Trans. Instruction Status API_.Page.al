page 50180 "Trans. Instruction Status API"
{
    APIGroup = 'BOC';
    APIPublisher = 'PB';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'transInstructionStatusAPI';
    DelayedInsert = true;
    EntityName = 'transactionInstructionStatus';
    EntitySetName = 'transactionInstructionStatus';
    PageType = API;
    SourceTable = "Transaction Instruction Status";

    //https://api.businesscentral.dynamics.com/v2.0/ba92f9e8-c19e-47b4-88f8-ce3df6492b8f/SandBox_DEV/api/PB/BOS/v2.0/companies(1324cb6a-b638-ef11-8e51-6045bde99b08)/transactionInstructionStatus
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
                field(txType; Rec.txType)
                {
                    Caption = 'txType';
                }
                field(cur; Rec.cur)
                {
                    Caption = 'cur';
                }
                field(amt; Rec.amt)
                {
                    Caption = 'amt';
                }
                field(payerAcctNo; Rec.payerAcctNo)
                {
                    Caption = 'payerAcctNo';
                }
                field(payerAcctName; Rec.payerAcctName)
                {
                    Caption = 'payerAcctNo';
                }
                field(effectiveDate; Rec.effectiveDate)
                {
                    Caption = 'effectiveDate';
                }
                field(txStatus; Rec.txStatus)
                {
                    Caption = 'txStatus';
                }
                field(iGTBRef; Rec.iGTBRef)
                {
                    Caption = 'iGTBRef';
                }
                field(custRef; Rec.custRef)
                {
                    Caption = 'custRef';
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
