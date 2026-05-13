page 50231 "Concur Inbound AttendeeStaging"
{
    ApplicationArea = All;
    Caption = 'Concur Inbound Attendee Staging';
    PageType = List;
    SourceTable = "Concur inbound Attende Staging";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry no."; Rec."Entry no.")
                {
                    ToolTip = 'Specifies the value of the Entry no. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Transaction Amount"; Rec."Transaction Amount")
                {
                    ToolTip = 'Specifies the value of the Transaction Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    ToolTip = 'Specifies the value of the Approved Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(AssociatedAttendeeCount; Rec.AssociatedAttendeeCount)
                {
                    ToolTip = 'Specifies the value of the AssociatedAttendeeCount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(AttendeeID; Rec.AttendeeID)
                {
                    ToolTip = 'Specifies the value of the AttendeeID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Custom1; Rec.Custom1)
                {
                    ToolTip = 'Specifies the value of the Custom1 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Custom2; Rec.Custom2)
                {
                    ToolTip = 'Specifies the value of the Custom2 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Custom3; Rec.Custom3)
                {
                    ToolTip = 'Specifies the value of the Custom3 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Custom4; Rec.Custom4)
                {
                    ToolTip = 'Specifies the value of the Custom4 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Custom5; Rec.Custom5)
                {
                    ToolTip = 'Specifies the value of the Custom5 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(EntryID; Rec.EntryID)
                {
                    ToolTip = 'Specifies the value of the EntryID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the value of the ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(URI; Rec.URI)
                {
                    ToolTip = 'Specifies the value of the URI field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Description (Error message)"; Rec."Description (Error message)")
                {
                    ToolTip = 'Specifies the value of the Description (Error message) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creation date/time"; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the Creation date/time field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Processed date/time"; Rec."Processed date/time")
                {
                    ToolTip = 'Specifies the value of the Processed date/time field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Process status"; Rec."Process status")
                {
                    ToolTip = 'Specifies the value of the Process status field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Process error message"; Rec."Process error message")
                {
                    ToolTip = 'Specifies the value of the Process error message field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(AttendeeTypeCode; Rec.AttendeeTypeCode)
                {
                    ToolTip = 'Specifies the value of the AttendeeTypeCode field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(FirstName; Rec.FirstName)
                {
                    ToolTip = 'Specifies the value of the FirstName field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(LastName; Rec.LastName)
                {
                    ToolTip = 'Specifies the value of the LastName field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(MiddleInitial; Rec.MiddleInitial)
                {
                    ToolTip = 'Specifies the value of the MiddleInitial field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Suffix; Rec.Suffix)
                {
                    ToolTip = 'Specifies the value of the Suffix field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Company; Rec.Company)
                {
                    ToolTip = 'Specifies the value of the Company field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Title; Rec.Title)
                {
                    ToolTip = 'Specifies the value of the Title field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(ExternalId; Rec.ExternalId)
                {
                    ToolTip = 'Specifies the value of the ExternalId field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(HasExceptionsPrevYear; Rec.HasExceptionsPrevYear)
                {
                    ToolTip = 'Specifies the value of the HasExceptionsPrevYear field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(HasExceptionsYtd; Rec.HasExceptionsYtd)
                {
                    ToolTip = 'Specifies the value of the HasExceptionsYtd field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(TotalAmountPrevYear; Rec.TotalAmountPrevYear)
                {
                    ToolTip = 'Specifies the value of the TotalAmountPrevYear field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(TotalAmountYtd; Rec.TotalAmountYtd)
                {
                    ToolTip = 'Specifies the value of the TotalAmountYtd field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(VersionNumber; Rec.VersionNumber)
                {
                    ToolTip = 'Specifies the value of the VersionNumber field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(OwnerName; Rec.OwnerName)
                {
                    ToolTip = 'Specifies the value of the OwnerName field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(OwnerUserId; Rec.OwnerUserId)
                {
                    ToolTip = 'Specifies the value of the OwnerUserId field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(CurrencyCode; Rec.CurrencyCode)
                {
                    ToolTip = 'Specifies the value of the CurrencyCode field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
