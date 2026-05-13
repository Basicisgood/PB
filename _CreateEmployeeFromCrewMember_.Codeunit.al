codeunit 51002 "CreateEmployeeFromCrewMember"
{
    trigger OnRun()
    var
    begin
        CreateEmployeeFromCrewMemberAPI();
    end;
    procedure CreateEmployeeFromCrewMemberAPI()
    var
        CrewMemberRec: Record "PB Crew Member Inbound";
        Employee: Record Employee;
    begin
        CrewMemberRec.Reset();
        CrewMemberRec.SetFilter("API Status", '%1|%2', CrewMemberRec."API Status"::Pending, CrewMemberRec."API Status"::Error);
        if CrewMemberRec.FindSet()then begin
            repeat Employee.Reset();
                if Employee.Get(CrewMemberRec."No.")then begin
                    CrewMemberRec."API Status":=CrewMemberRec."API Status"::Cancel;
                    CrewMemberRec."Error Description":='Employee already exists with this No. ' + CrewMemberRec."No.";
                    CrewMemberRec.Modify();
                end
                else
                begin
                    Employee.Reset();
                    Employee.Init();
                    Employee."No.":=CopyStr(CrewMemberRec."No.", 1, 20);
                    Employee.validate("First Name", CopyStr(CrewMemberRec."First Name", 1, 30));
                    Employee.validate("Middle Name", CopyStr(CrewMemberRec."Middle Name", 1, 30));
                    Employee.validate("Last Name", CopyStr(CrewMemberRec."last Name", 1, 30));
                    Employee.Nationality2:=CrewMemberRec.Nationality;
                    Employee.Insert(true);
                    CrewMemberRec."API Status":=CrewMemberRec."API Status"::Processed;
                    CrewMemberRec."Error Description":='';
                    CrewMemberRec.Modify(true);
                end;
            until CrewMemberRec.Next() = 0;
        end;
    end;
    procedure GetError(var CrewMember3: Record "PB Crew Member Inbound")
    var
    begin
        if(CrewMember3."Entry No." <> 0) and (CrewMember3."No." <> '') and (CrewMember3."First Name" <> '')then begin
            InsertEmployeeRec(CrewMember3);
            CrewMember3."API Status":=CrewMember3."API Status"::Processed;
            CrewMember3.Modify();
        end
        else
        begin
        end;
    end;
    procedure InsertEmployeeRec(var CrewMember4: Record "PB Crew Member Inbound")
    var
        EmployeeRec1: Record Employee;
        EmployeeRec2: Record Employee;
    begin
        EmployeeRec1.Reset();
        EmployeeRec1.SetRange("No.", CrewMember4."No.");
        if not EmployeeRec1.FindFirst()then begin
            EmployeeRec2.Init();
            EmployeeRec2."No.":=CopyStr(CrewMember4."No.", 1, 20);
            if EmployeeRec2.Insert()then ModifyCrewMemberRecord(CrewMember4, EmployeeRec2);
        end
        else
        begin
            ModifyCrewMemberRecord(CrewMember4, EmployeeRec1);
        end;
    end;
    procedure ModifyCrewMemberRecord(var PBCrewMemberInb: Record "PB Crew Member Inbound"; EmployeeRec2: Record Employee)
    var
        EmployeeBankAccRec: Record "Employee Bank Account";
    begin
        EmployeeRec2."First Name":=CopyStr(PBCrewMemberInb."First Name", 1, 30);
        EmployeeRec2."Middle Name":=CopyStr(PBCrewMemberInb."Middle Name", 1, 30);
        EmployeeRec2."Last Name":=CopyStr(PBCrewMemberInb."Last Name", 1, 30);
        EmployeeRec2."Search Name":=EmployeeRec2.FullName();
        EmployeeRec2.Address:=CopyStr(PBCrewMemberInb.Address, 1, 100);
        EmployeeRec2."Address 2":=CopyStr(PBCrewMemberInb."Address 2", 1, 50);
        EmployeeRec2."City":=CopyStr(PBCrewMemberInb."City", 1, 30);
        EmployeeRec2."Post Code":=CopyStr(PBCrewMemberInb."Post Code", 1, 20);
        EmployeeRec2."E-Mail":=CopyStr(PBCrewMemberInb."E-Mail", 1, 80);
        EmployeeRec2."Phone No.":=CopyStr(PBCrewMemberInb."Phone No.", 1, 30);
        EmployeeRec2."Mobile Phone No.":=CopyStr(PBCrewMemberInb."Mobile Phone No.", 1, 30);
        EmployeeRec2."Area":=PBCrewMemberInb."Area";
        EmployeeRec2."Country/Region Code":=PBCrewMemberInb."Country/Region Code";
        EmployeeRec2.Nationality2:=PBCrewMemberInb.Nationality;
        //EmployeeRec2.Status := PBCrewMemberInb.Status;
        case PBCrewMemberInb.Status of PBCrewMemberInb.Status::Active: EmployeeRec2.Status:=EmployeeRec2.Status::Active;
        PBCrewMemberInb.Status::InActive: EmployeeRec2.Status:=EmployeeRec2.Status::Inactive;
        PBCrewMemberInb.Status::Terminated: EmployeeRec2.Status:=EmployeeRec2.Status::Terminated;
        end;
        EmployeeRec2."Termination Date":=PBCrewMemberInb."Termination Date";
        EmployeeRec2."DNV No":=PBCrewMemberInb."No.";
        EmployeeRec2."DNV First Name":=PBCrewMemberInb."First Name";
        EmployeeRec2."DNV Middle Name":=PBCrewMemberInb."Middle Name";
        EmployeeRec2."DNV Last Name":=PBCrewMemberInb."Last Name";
        EmployeeRec2."DNV Address":=PBCrewMemberInb.Address;
        EmployeeRec2."DNV Address 2":=PBCrewMemberInb."Address 2";
        EmployeeRec2."DNV City":=PBCrewMemberInb.City;
        EmployeeRec2."DNV PostCode":=PBCrewMemberInb."Post Code";
        EmployeeRec2."DNV E-Mail":=PBCrewMemberInb."E-Mail";
        EmployeeRec2."DNV Phone No.":=PBCrewMemberInb."Phone No.";
        EmployeeRec2."DNV Mobile Phone No.":=PBCrewMemberInb."Mobile Phone No.";
        EmployeeRec2."DNV Staging Entry No.":=PBCrewMemberInb."Entry No.";
        EmployeeRec2.Crew:=true; //VJ 20Nov2024
        CreateDefaultDimension(EmployeeRec2);
        if EmployeeRec2.Modify()then begin
            ////////////////
            //TEC.VJ 21112024>>
            // EmployeeRec2."Bank Code" := CrewMemberBankRec."Bank Code";
            // EmployeeRec2."Bank Name" := CrewMemberBankRec."Bank Name";
            // EmployeeRec2."Account Currency Code" := CrewMemberBankRec."Account Currency Code";
            // EmployeeRec2."Account Currency Name" := CrewMemberBankRec."Account Currency Name";
            // EmployeeRec2."Bank Account No." := CrewMemberBankRec."Bank Account No.";
            // EmployeeRec2.Beneficiary := CrewMemberBankRec.Beneficiary;
            // EmployeeRec2.BIC := CrewMemberBankRec.BIC;
            //EmployeeRec2."Is Main Account" := CrewMemberBankRec."Is Main Account";
            //EmployeeRec2.GUID := CrewMemberBankRec.GUID;
            //TEC.VJ 21112024<<
            EmployeeRec2.Modify();
        end;
    end;
    procedure ClearLogEntry(TableNo: Integer; EntryNo_p: Integer)
    begin
        ItemErrorLogEntry.Reset();
        ItemErrorLogEntry.SetRange("Inbound Table", TableNo);
        IF EntryNo_p <> 0 then ItemErrorLogEntry.SetRange("Inbound Entry No.", EntryNo_p);
        if ItemErrorLogEntry.FindFirst()then ItemErrorLogEntry.DeleteAll();
    end;
    procedure CreateDefaultDimension(p_employee: Record Employee);
    var
        GLSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
        DefaultDim: Record "Default Dimension";
    begin
        GLSetup.get();
        DimValue.Reset();
        DimValue.SetRange("Dimension Code", GLSetup."Shortcut Dimension 6 Code");
        DimValue.SetRange(Code, p_employee."DNV No");
        if not DimValue.FindFirst()then begin
            DimValue.Init();
            DimValue.Validate("Dimension Code", GLSetup."Shortcut Dimension 6 Code");
            DimValue.Validate(Code, p_employee."DNV No");
            DimValue.Validate("Dimension Value Type", DimValue."Dimension Value Type"::Standard);
            DimValue.Validate(Name, p_employee."Last Name" + ' ' + p_employee."First Name");
            if DimValue.Insert(true)then;
        end;
        DefaultDim.Reset();
        DefaultDim.SetRange("Table ID", Database::Employee);
        DefaultDim.SetRange("No.", p_employee."No.");
        DefaultDim.SetRange("Dimension Code", GLSetup."Shortcut Dimension 6 Code");
        if not DefaultDim.FindFirst()then begin
            DefaultDim.Init();
            DefaultDim.VALIDATE("Table ID", Database::Employee);
            DefaultDim.Validate("No.", p_employee."No.");
            DefaultDim.VALIDATE("Dimension Code", GLSetup."Shortcut Dimension 6 Code");
            DefaultDim.VALIDATE("Dimension Value Code", p_employee."DNV No");
            DefaultDim.Validate("Value Posting", DefaultDim."Value Posting"::"Same Code");
            if DefaultDim.Insert(true)then;
        end;
    end;
    var ItemErrorLogEntry: Record "Inbound Error Log Entry";
    IsError: Boolean;
}
