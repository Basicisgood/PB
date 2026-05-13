page 50164 "Crew Payroll Dim Inb API"
{
    // ApplicationArea = All;
    Caption = 'Crew Payroll Dimension Inbound API';
    PageType = API;
    SourceTable = "PB Crew Payroll Dim Inb";
    UsageCategory = Lists;
    //Editable = false;
    APIPublisher = 'PB';
    APIGroup = 'app1';
    APIVersion = 'v2.0', 'v1.0';
    EntityName = 'crewPayrolldimInb';
    EntitySetName = 'crewPayrolldimInb';
    ODataKeyFields = SystemId;
    DelayedInsert = true;

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
                field(crewPayrollEntryNo; Rec."Crew Payroll Entry No.")
                {
                    ApplicationArea = All;
                }
                field(CrewPayrollId; Rec.CrewPayrollId)
                {
                    ApplicationArea = All;
                }
                field(LineNo; Rec."Line No")
                {
                    ApplicationArea = All;
                }
                field(WageDimensionCode; Rec."Wage Dimension Code")
                {
                    ApplicationArea = All;
                }
                field(WageDimensionValue; Rec."Wage Dimension Value")
                {
                    ApplicationArea = All;
                }
                field(TotalAmount; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean var
        CrewPayrollInbound: Record "PB Crew Payroll Inbound";
        CrewPayrollDimInb: Record "PB Crew Payroll Dim Inb";
    begin
        CrewPayrollInbound.GetBySystemId(Rec.CrewPayrollId);
        Rec."Crew Payroll Entry No.":=CrewPayrollInbound."Entry No.";
        CrewPayrollDimInb.SetRange("Crew Payroll Entry No.", Rec."Crew Payroll Entry No.");
        if CrewPayrollDimInb.FindLast()then Rec."Line No":=CrewPayrollDimInb."Line No" + 10000
        else
            Rec."Line No":=10000;
    end;
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        CrewInvDimInbound: Record "PB Crew Payroll Inbound";
    begin
        CrewInvDimInbound.GetBySystemId(Rec.CrewPayrollId);
        Rec."Crew Payroll Entry No.":=CrewInvDimInbound."Entry No.";
    end;
}
