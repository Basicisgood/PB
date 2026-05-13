page 50152 "Crew Payroll Inbound API"
{
    //  ApplicationArea = All;
    Caption = 'Crew Payroll Inbound API';
    PageType = API;
    SourceTable = "PB Crew Payroll Inbound";
    UsageCategory = Lists;
    //Editable = false;
    APIPublisher = 'PB';
    APIGroup = 'app1';
    APIVersion = 'v2.0', 'v1.0';
    EntityName = 'CrewPayrollInbound';
    EntitySetName = 'CrewPayrollInbound';
    ODataKeyFields = SystemId;
    DelayedInsert = true;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(id; Rec.SystemId)
                {
                    ApplicationArea = All;
                }
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field(CrewPersonnelNumber; Rec."Crew Personnel Number")
                {
                    ApplicationArea = All;
                }
                field(AccountingArea; Rec."Accounting Area")
                {
                    ApplicationArea = all;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field(CreatedAt; Rec."Created At")
                {
                    ApplicationArea = All;
                }
                field(CreatedBy; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                field(CarryForwardAmount; Rec."Carry Forward Amount")
                {
                    ApplicationArea = All;
                }
                field(PayoutThisMonth; Rec."Payout This Month")
                {
                    ApplicationArea = All;
                }
                field(PaymentFrom; Rec."Payment From")
                {
                    ApplicationArea = All;
                }
                field(PaymentTo; Rec."Payment To")
                {
                    ApplicationArea = All;
                }
                field(SignOn; Rec."Sign On")
                {
                    ApplicationArea = All;
                }
                field(SignOff; Rec."Sign Off")
                {
                    ApplicationArea = All;
                }
                field(ShipShortSign; Rec."Ship Short Sign")
                {
                    ApplicationArea = All;
                }
                field(CrewRank; Rec."Crew Rank")
                {
                    ApplicationArea = All;
                }
                field(WageCalculationBasis30Days; Rec."Wage Calculation Basis 30 Days")
                {
                    ApplicationArea = All;
                }
                field(PendingBalanceWage; Rec."Pending Balance Wage")
                {
                    ApplicationArea = All;
                }
                field(PendingBalanceLeavePay; Rec."Pending Balance Leave Pay")
                {
                    ApplicationArea = All;
                }
                field(PendingBalSubsistAllow; Rec."Pending Bal. Subsist. Allow.")
                {
                    ApplicationArea = All;
                }
                field(IsPaidOut; Rec."Is Paid Out")
                {
                    ApplicationArea = All;
                }
                field(recordStatus; Rec."Records Status")
                {
                    ApplicationArea = All;
                }
                field(transactionNumber; Rec."Transaction Number")
                {
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                    ApplicationArea = all;
                }
                field(errorDescription; Rec."Error Description")
                {
                    Caption = 'Error Description';
                    ApplicationArea = all;
                }
                field(cancelledByUser; Rec."Cancelled by User")
                {
                    Caption = 'Cancelled by User';
                    ApplicationArea = all;
                }
                field(cancelledDateTime; Rec."Cancelled Date time")
                {
                    Caption = 'Cancelled Date time';
                    ApplicationArea = all;
                }
            }
            part(crewPayrolldimInb; "Crew Payroll Dim Inb API")
            {
                Caption = 'Purchase Invoice Lines';
                EntityName = 'crewPayrolldimInb';
                EntitySetName = 'crewPayrolldimInb';
                SubPageLink = CrewPayrollId=Field(SystemId);
            }
        }
    }
}
