page 50218 ConcurExpenseAttendeeAPI
{
    ApplicationArea = All;
    Caption = 'Concur Expense Attendee API Log';
    PageType = List;
    SourceTable = "Expense Attendee API Log";
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
                field(attendeeId; Rec.attendeeId)
                {
                    ToolTip = 'Specifies the value of the attendeeId field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(customData; Rec.customData)
                {
                    ToolTip = 'Specifies the value of the customData field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(isAmountUserEdited; Rec.isAmountUserEdited)
                {
                    ToolTip = 'Specifies the value of the isAmountUserEdited field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(isTraveling; Rec.isTraveling)
                {
                    ToolTip = 'Specifies the value of the isTraveling field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(associatedAttendeeCount; Rec.associatedAttendeeCount)
                {
                    ToolTip = 'Specifies the value of the associatedAttendeeCount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(versionNumber; Rec.versionNumber)
                {
                    ToolTip = 'Specifies the value of the versionNumber field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("transactionAmount value"; Rec."transactionAmount value")
                {
                    ToolTip = 'Specifies the value of the value field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("transactionAmount currencyCode"; Rec."transactionAmount currencyCode")
                {
                    ToolTip = 'Specifies the value of the currencyCode field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("approvedAmount value"; Rec."approvedAmount value")
                {
                    ToolTip = 'Specifies the value of the value field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("approvedAmount currencyCode"; Rec."approvedAmount currencyCode")
                {
                    ToolTip = 'Specifies the value of the currencyCode field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
