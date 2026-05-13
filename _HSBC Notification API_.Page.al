page 50184 "HSBC Notification API"
{
    APIGroup = 'HSBC';
    APIPublisher = 'PB';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'hsbcNotificationAPI';
    DelayedInsert = true;
    EntityName = 'hsbcNotification';
    EntitySetName = 'hsbcNotifications';
    PageType = API;
    SourceTable = "HSBC Notification";

    //https://api.businesscentral.dynamics.com/v2.0/ba92f9e8-c19e-47b4-88f8-ce3df6492b8f/SandBox_DEV/api/PB/HSBC/v2.0/companies(1324cb6a-b638-ef11-8e51-6045bde99b08)/hsbcNotifications
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
                field(entryNo; Rec.entryNo)
                {
                    Caption = 'entryNo';
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
