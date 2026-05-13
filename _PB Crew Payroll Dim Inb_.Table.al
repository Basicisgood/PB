table 50145 "PB Crew Payroll Dim Inb"
{
    Caption = 'Crew Payrol Dimension Inbound';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(2; "Crew Payroll Entry No."; Integer)
        {
        }
        field(3; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(5; CrewPayrollId; Guid)
        {
            TableRelation = "PB Crew Payroll Inbound".SystemId;
        }
        field(40; "Wage Dimension Code"; Text[10])
        {
        }
        field(42; "Wage Dimension Value"; Text[50])
        {
        }
        field(44; "Total Amount"; Decimal)
        {
        }
        field(100; "GL Code"; Code[20])
        {
            Editable = false;
        }
        field(110; "IC Code"; Text[50])
        {
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Crew Payroll Entry No.", "Line No")
        {
            Clustered = true;
        }
    }
}
