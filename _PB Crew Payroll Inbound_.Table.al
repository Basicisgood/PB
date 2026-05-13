table 50132 "PB Crew Payroll Inbound"
{
    Caption = 'Crew Payrol Inbound';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(2; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(5; "Crew Personnel Number"; Text[50])
        {
        }
        field(8; "Currency Code"; Text[5])
        {
        }
        field(9; "Accounting Area"; Text[50])
        {
        }
        field(10; "Created At"; Date)
        {
        }
        field(11; "Posting Date"; Date)
        {
        }
        field(12; "Created By"; Text[255])
        {
        }
        field(14; "Carry Forward Amount"; Decimal)
        {
        }
        field(16; "Payout This Month"; Decimal)
        {
        }
        field(18; "Payment From"; Date)
        {
        }
        field(20; "Payment To"; Date)
        {
        }
        field(22; "Sign On"; Date)
        {
        }
        field(24; "Sign Off"; Date)
        {
        }
        field(26; "Ship Short Sign"; Text[10])
        {
        }
        field(28; "Crew Rank"; Text[50])
        {
        }
        field(29; "Is Cadet"; boolean)
        {
        }
        field(30; "Wage Calculation Basis 30 Days"; Boolean)
        {
        }
        field(32; "Pending Balance Wage"; Decimal)
        {
        }
        field(34; "Pending Balance Leave Pay"; Decimal)
        {
        }
        field(36; "Pending Bal. Subsist. Allow."; Decimal)
        {
            Caption = 'Pending Balance Subsistence Allowance';
        }
        field(38; "Is Paid Out"; Boolean)
        {
        }
        field(39; "Status";Enum DNVEnumInvStatus)
        {
            Caption = 'Status';
            Editable = true;
        }
        field(40; "Error Description"; Text[250])
        {
            Caption = 'Error Description';
            Editable = false;
        }
        field(41; "Cancelled by User"; Code[50])
        {
            Editable = false;
        }
        field(42; "Cancelled Date time"; DateTime)
        {
            Editable = false;
        }
        field(50; "Records Status";Enum PayrollInboundStatus)
        {
        }
        field(55; "Transaction Number"; Integer)
        {
        }
        field(65; "Posted Document No Fin Company"; code[20])
        {
            caption = 'Posted Document No Fin Company';
        }
        field(70; "Posted Document No Shp Company"; code[20])
        {
            caption = 'Posted Document No Ship Company';
        }
        field(75; "Finance Company No"; text[500])
        {
            caption = 'Finance Company No';
        }
        field(80; "Ship Sign Company No"; text[50])
        {
            caption = 'Ship Sign Company No';
        }
        field(85; "Posted In Fin Company"; Boolean)
        {
            Editable = false;
        }
        field(90; "Posted In Ship Company"; Boolean)
        {
            Editable = false;
        }
        field(95; "Lines Created"; Boolean)
        {
            Editable = false;
        }
        field(100; "Linked Entry No."; Integer)
        {
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        CrewLine: record 50145;
    begin
        CrewLine.Reset();
        CrewLine.SetRange("Crew Payroll Entry No.", Rec."Entry No.");
        if CrewLine.FindSet()then CrewLine.DeleteAll();
    end;
}
