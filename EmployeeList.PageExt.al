pageextension 50144 EmployeeList extends "Employee List"
{ //PS005
    layout
    {
        addafter("Job Title")
        {
            field(Crew; Rec.Crew)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action("Sync Employees")
            {
                ApplicationArea = all;
                PromotedCategory = Process;
                Promoted = true;
                Ellipsis = true;
                Image = UpdateDescription;
                ToolTip = 'Sync Employees';

                //Visible = ISMasterCompany;
                trigger OnAction()
                var
                    EmployeeRec: Record Employee;
                    MasterSyncDetails: Record "Master Sync Details";
                    EmpBankAccounts: Record "Employee Bank Account";
                    EmpBankAccounts2: Record "Employee Bank Account";
                    CommonFunc: Codeunit "Common Functions";
                    OutboundLog: Record "Concur Outbound Log";
                    Log: Record "Concur Outbound Log";
                    DefaultDim: Record "Default Dimension";
                    DimeensionValue: Record "Dimension Value";
                    GLSetup: Record "General Ledger Setup";
                    CompanyMapping: Record "Company Name Mapping";
                    APISetup: Record "Concur API Setup";
                    EmpRec: Record Employee;
                    DefaultDimComp: Record "Default Dimension";
                    RecEmployee: Record Employee;
                //MasterSyncDetails: Record "Master Sync Details";
                //EmpBankAccounts: Record "Employee Bank Account";
                //EmpBankAccounts2: Record "Employee Bank Account";
                begin
                    EmployeeRec.Reset();
                    //Employee.Copy(rec);
                    CurrPage.SetSelectionFilter(EmployeeRec);
                    if EmployeeRec.FindSet()then //Recemployee.Reset();
                        //Employee.Copy(rec);
                        //CurrPage.SetSelectionFilter(Recemployee);
                        //if Recemployee.FindSet() then
                        repeat Rec.CreateOutboundLog(EmployeeRec);
                        /*
                        APISetup.get;
                        APISetup.TestField("Default Company");

                        glsetup.get;
                        if (RecEmployee."Integrate to Concur" = true) and (RecEmployee.crew = true) then
                            Error('Crew can not be send to Concur.');

                        //CompanyMapping.get(APISetup."Default Company");
                        //CompanyMapping.TestField("Sync Employees", true);

                        EmpRec.changecompany(APISetup."Default Company");
                        EmpRec.init;
                        EmpRec.TransferFields(RecEmployee, false);
                        EmpRec."No." := RecEmployee."No.";
                        EmpRec.Company := APISetup."Default Company";
                        if not emprec.insert then EmpRec.Modify();

                        DefaultDimComp.ChangeCompany(APISetup."Default Company");
                        DimeensionValue.ChangeCompany(APISetup."Default Company");
                        DefaultDim.reset;
                        DefaultDim.SetRange("Table ID", 5200);
                        DefaultDim.SetRange("No.", RecEmployee."No.");
                        DefaultDim.SetFilter("Dimension Code", '<>%1&<>%2', GLSetup."Shortcut Dimension 8 Code", GLSetup."Shortcut Dimension 6 Code");
                        if DefaultDim.FindSet() then
                            repeat
                                if not DimeensionValue.get(DefaultDim."Dimension Code", DefaultDim."Dimension Value Code") then begin
                                    DimeensionValue.Init();
                                    DimeensionValue."Dimension Code" := DefaultDim."Dimension Code";
                                    DimeensionValue.Code := DefaultDim."Dimension Value Code";
                                    DimeensionValue.Name := DefaultDim."Dimension Value Code";

                                    DimeensionValue.Insert(true);
                                end;

                                //if not DefaultDimComp.get(DefaultDim."Table ID", DefaultDim."No.", DefaultDim."Dimension Code") then begin
                                DefaultDimComp.init;
                                DefaultDimComp.TransferFields(DefaultDim, false);
                                DefaultDimComp."Table ID" := DefaultDim."Table ID";
                                DefaultDimComp."No." := DefaultDim."No.";
                                DefaultDimComp."Dimension Code" := DefaultDim."Dimension Code";
                                if not DefaultDimComp.insert then DefaultDimComp.Modify();
                            //end;
                            until DefaultDim.next = 0;

                        if not DefaultDimComp.get(5200, RecEmployee."No.", GLSetup."Shortcut Dimension 8 Code") then begin
                            if not DimeensionValue.get(GLSetup."Shortcut Dimension 8 Code", APISetup."Default Company") then begin
                                DimeensionValue.Init();
                                DimeensionValue."Dimension Code" := GLSetup."Shortcut Dimension 8 Code";
                                DimeensionValue.Code := APISetup."Default Company";
                                DimeensionValue.Name := APISetup."Default Company";
                                DimeensionValue.Insert(true);
                            end;
                            DefaultDimComp.Init();
                            DefaultDimComp.Validate("Table ID", 5200);
                            DefaultDimComp."No." := RecEmployee."No.";
                            DefaultDimComp."Dimension Code" := GLSetup."Shortcut Dimension 8 Code";
                            DefaultDimcomp."Dimension Value Code" := APISetup."Default Company";

                            DefaultDimComp.Insert(true);
                        end;

                        empBankAccounts.Reset();
                        empBankAccounts.SetRange("Employee No.", recEmployee."No.");
                        if empBankAccounts.FindSet() then
                            repeat
                                empBankAccounts2.Reset();
                                empBankAccounts2.ChangeCompany(APISetup."Default Company");
                                empBankAccounts2.Init();
                                empBankAccounts2.TransferFields(empBankAccounts, false);
                                empBankAccounts2."EMployee No." := empBankAccounts."Employee No.";
                                empBankAccounts2.Code := empBankAccounts.Code;
                                if not empbankAccounts2.Insert() then empBankAccounts2.Modify();
                            until empBankAccounts.Next() = 0;

                        MasterSyncDetails.init();
                        MasterSyncDetails."Entry No." := 0;
                        MasterSyncDetails.Code := recEmployee."No.";
                        MasterSyncDetails."Company Name" := APISetup."Default Company";
                        MasterSyncDetails."Sync DateTime" := CurrentDateTime;
                        MasterSyncDetails."User ID" := UserId;
                        MasterSyncDetails.Insert();

                        if CopyStr(recemployee."No.", StrLen(recemployee."No.") - 1) = 'CC' then begin
                            RecEmployee.TestField(Company);

                            if RecEmployee."Relocate to Company" <> '' then begin
                                EmpRec.changecompany(RecEmployee.Company);
                                if EmpRec.get(RecEmployee."No.") then begin
                                    EmpRec.Status := EmpRec.Status::Inactive;
                                    EmpRec."Inactive Date" := today;
                                    EmpRec.Modify();
                                end;

                                EmpRec.changecompany(RecEmployee."Relocate to Company");
                                EmpRec.init;
                                EmpRec.TransferFields(RecEmployee, false);
                                EmpRec."No." := RecEmployee."No.";
                                EmpRec.Company := RecEmployee."Relocate to Company";
                                EmpRec."Relocate to Company" := '';
                                if not emprec.insert then EmpRec.Modify();

                                DefaultDimComp.ChangeCompany(RecEmployee."Relocate to Company");
                                DimeensionValue.ChangeCompany(RecEmployee."Relocate to Company");
                                DefaultDim.reset;
                                DefaultDim.SetRange("Table ID", 5200);
                                DefaultDim.SetRange("No.", RecEmployee."No.");
                                DefaultDim.SetFilter("Dimension Code", '<>%1&<>%2', GLSetup."Shortcut Dimension 8 Code", GLSetup."Shortcut Dimension 6 Code");
                                if DefaultDim.FindSet() then
                                    repeat
                                        if not DimeensionValue.get(DefaultDim."Dimension Code", DefaultDim."Dimension Value Code") then begin
                                            DimeensionValue.Init();
                                            DimeensionValue."Dimension Code" := DefaultDim."Dimension Code";
                                            DimeensionValue.Code := DefaultDim."Dimension Value Code";
                                            DimeensionValue.Name := DefaultDim."Dimension Value Code";
                                            DimeensionValue.Insert(true);
                                        end;

                                        //if not DefaultDimComp.get(DefaultDim."Table ID", DefaultDim."No.", DefaultDim."Dimension Code") then begin
                                        DefaultDimComp.init;
                                        DefaultDimComp.TransferFields(DefaultDim, false);
                                        DefaultDimComp."Table ID" := DefaultDim."Table ID";
                                        DefaultDimComp."No." := DefaultDim."No.";
                                        DefaultDimComp."Dimension Code" := DefaultDim."Dimension Code";
                                        if not DefaultDimComp.insert then DefaultDimComp.Modify();
                                    //end;
                                    until DefaultDim.next = 0;

                                if not DefaultDimComp.get(5200, RecEmployee."No.", GLSetup."Shortcut Dimension 8 Code") then begin
                                    if not DimeensionValue.get(GLSetup."Shortcut Dimension 8 Code", RecEmployee."Relocate to Company") then begin
                                        DimeensionValue.Init();
                                        DimeensionValue."Dimension Code" := GLSetup."Shortcut Dimension 8 Code";
                                        DimeensionValue.Code := RecEmployee."Relocate to Company";
                                        DimeensionValue.Name := RecEmployee."Relocate to Company";
                                        DimeensionValue.Insert(true);
                                    end;
                                    DefaultDimComp.Init();
                                    DefaultDimComp.Validate("Table ID", 5200);
                                    DefaultDimComp."No." := RecEmployee."No.";
                                    DefaultDimComp."Dimension Code" := GLSetup."Shortcut Dimension 8 Code";
                                    DefaultDimcomp."Dimension Value Code" := RecEmployee."Relocate to Company";
                                    DefaultDimComp.Insert(true);
                                end;

                                empBankAccounts.Reset();
                                empBankAccounts.SetRange("Employee No.", recEmployee."No.");
                                if empBankAccounts.FindSet() then
                                    repeat
                                        empBankAccounts2.Reset();
                                        empBankAccounts2.ChangeCompany(recEmployee."Relocate to Company");
                                        empBankAccounts2.Init();
                                        empBankAccounts2.TransferFields(empBankAccounts, false);
                                        empBankAccounts2."EMployee No." := empBankAccounts."Employee No.";
                                        empBankAccounts2.Code := empBankAccounts.Code;
                                        if not empbankAccounts2.Insert() then empBankAccounts2.Modify();
                                    until empBankAccounts.Next() = 0;

                                MasterSyncDetails.init();
                                MasterSyncDetails."Entry No." := 0;
                                MasterSyncDetails.Code := recEmployee."No.";
                                MasterSyncDetails."Company Name" := recEmployee."Relocate to Company";
                                MasterSyncDetails."Sync DateTime" := CurrentDateTime;
                                MasterSyncDetails."User ID" := UserId;
                                MasterSyncDetails.Insert();

                                RecEmployee.Company := RecEmployee."Relocate to Company";
                                RecEmployee."Relocate to Company" := '';
                                RecEmployee.Modify();
                            end
                            else begin
                                EmpRec.changecompany(RecEmployee.company);
                                EmpRec.init;
                                EmpRec.TransferFields(RecEmployee, false);
                                emprec."No." := RecEmployee."No.";
                                if not emprec.insert then EmpRec.Modify();

                                DefaultDimComp.ChangeCompany(recemployee.company);
                                DimeensionValue.ChangeCompany(RecEmployee.Company);
                                DefaultDim.reset;
                                DefaultDim.SetRange("Table ID", 5200);
                                DefaultDim.SetRange("No.", RecEmployee."No.");
                                DefaultDim.SetFilter("Dimension Code", '<>%1&<>%2', GLSetup."Shortcut Dimension 8 Code", GLSetup."Shortcut Dimension 6 Code");
                                if DefaultDim.FindSet() then
                                    repeat
                                        if not DimeensionValue.get(DefaultDim."Dimension Code", DefaultDim."Dimension Value Code") then begin
                                            DimeensionValue.Init();
                                            DimeensionValue."Dimension Code" := DefaultDim."Dimension Code";
                                            DimeensionValue.Code := DefaultDim."Dimension Value Code";
                                            DimeensionValue.Name := DefaultDim."Dimension Value Code";
                                            DimeensionValue.Insert(true);
                                        end;

                                        //if not DefaultDimComp.get(DefaultDim."Table ID", DefaultDim."No.", DefaultDim."Dimension Code") then begin
                                        DefaultDimComp.init;
                                        DefaultDimComp.TransferFields(DefaultDim, false);
                                        DefaultDimComp."Table ID" := DefaultDim."Table ID";
                                        DefaultDimComp."No." := DefaultDim."No.";
                                        DefaultDimComp."Dimension Code" := DefaultDim."Dimension Code";
                                        if not DefaultDimComp.insert then DefaultDimComp.Modify();
                                    //end;
                                    until DefaultDim.next = 0;

                                if not DefaultDimComp.get(5200, RecEmployee."No.", GLSetup."Shortcut Dimension 8 Code") then begin
                                    if not DimeensionValue.get(GLSetup."Shortcut Dimension 8 Code", RecEmployee.company) then begin
                                        DimeensionValue.Init();
                                        DimeensionValue."Dimension Code" := GLSetup."Shortcut Dimension 8 Code";
                                        DimeensionValue.Code := RecEmployee.company;
                                        DimeensionValue.Name := RecEmployee.company;
                                        DimeensionValue.Insert(true);
                                    end;
                                    DefaultDimComp.Init();
                                    DefaultDimComp.Validate("Table ID", 5200);
                                    DefaultDimComp."No." := RecEmployee."No.";
                                    DefaultDimComp."Dimension Code" := GLSetup."Shortcut Dimension 8 Code";
                                    DefaultDimcomp."Dimension Value Code" := RecEmployee.company;
                                    DefaultDimComp.Insert(true);
                                end;

                                empBankAccounts.Reset();
                                empBankAccounts.SetRange("Employee No.", recEmployee."No.");
                                if empBankAccounts.FindSet() then
                                    repeat
                                        empBankAccounts2.Reset();
                                        empBankAccounts2.ChangeCompany(recEmployee.company);
                                        empBankAccounts2.Init();
                                        empBankAccounts2.TransferFields(empBankAccounts, false);
                                        empBankAccounts2."EMployee No." := empBankAccounts."Employee No.";
                                        empBankAccounts2.Code := empBankAccounts.Code;
                                        if not empbankAccounts2.Insert() then empBankAccounts2.Modify();
                                    until empBankAccounts.Next() = 0;

                                MasterSyncDetails.init();
                                MasterSyncDetails."Entry No." := 0;
                                MasterSyncDetails.Code := recEmployee."No.";
                                MasterSyncDetails."Company Name" := recEmployee.company;
                                MasterSyncDetails."Sync DateTime" := CurrentDateTime;
                                MasterSyncDetails."User ID" := UserId;
                                MasterSyncDetails.Insert();
                            end;
                        end
                        else begin
                            if RecEmployee."Integrate to Concur" then begin
                                APISetup.TestField("Company ID");
                                recemployee.TestField("Country/Region Code");
                                recemployee.TestField("First Name");
                                recemployee.TestField("Last Name");
                                recemployee.TestField("Company E-Mail");
                                recemployee.TestField("Currency Code");
                                recemployee.TestField("Emp. ID Cash Adv. Approver");
                                recemployee.TestField("Emp. ID Exp. Rep. Approver");
                                RecEmployee.TestField(Company);
                                GLSetup.TestField("Shortcut Dimension 5 Code");
                                if not DefaultDim.Get(5200, recemployee."No.", GLSetup."Shortcut Dimension 5 Code") then
                                    Error('Department Dimension not found for Employee %1.', recemployee."No.");

                                if RecEmployee."Relocate to Company" <> '' then begin
                                    EmpRec.changecompany(RecEmployee.Company);
                                    if EmpRec.get(RecEmployee."No.") then begin
                                        EmpRec.Status := EmpRec.Status::Inactive;
                                        EmpRec."Inactive Date" := today;
                                        EmpRec.Modify();
                                    end;

                                    EmpRec.changecompany(RecEmployee."Relocate to Company");
                                    EmpRec.init;
                                    EmpRec.TransferFields(RecEmployee, false);
                                    emprec."No." := RecEmployee."No.";
                                    EmpRec.Company := RecEmployee."Relocate to Company";
                                    EmpRec."Relocate to Company" := '';
                                    if not emprec.insert then EmpRec.Modify();

                                    DefaultDimComp.ChangeCompany(RecEmployee."Relocate to Company");
                                    DimeensionValue.ChangeCompany(RecEmployee."Relocate to Company");
                                    DefaultDim.reset;
                                    DefaultDim.SetRange("Table ID", 5200);
                                    DefaultDim.SetRange("No.", RecEmployee."No.");
                                    DefaultDim.SetFilter("Dimension Code", '<>%1&<>%2', GLSetup."Shortcut Dimension 8 Code", GLSetup."Shortcut Dimension 6 Code");
                                    if DefaultDim.FindSet() then
                                        repeat
                                            if not DimeensionValue.get(DefaultDim."Dimension Code", DefaultDim."Dimension Value Code") then begin
                                                DimeensionValue.Init();
                                                DimeensionValue."Dimension Code" := DefaultDim."Dimension Code";
                                                DimeensionValue.Code := DefaultDim."Dimension Value Code";
                                                DimeensionValue.Name := DefaultDim."Dimension Value Code";
                                                DimeensionValue.Insert(true);
                                            end;

                                            //if not DefaultDimComp.get(DefaultDim."Table ID", DefaultDim."No.", DefaultDim."Dimension Code") then begin
                                            DefaultDimComp.init;
                                            DefaultDimComp.TransferFields(DefaultDim, false);
                                            DefaultDimComp."Table ID" := DefaultDim."Table ID";
                                            DefaultDimComp."No." := DefaultDim."No.";
                                            DefaultDimComp."Dimension Code" := DefaultDim."Dimension Code";
                                            if not DefaultDimComp.insert then DefaultDimComp.Modify();
                                        //end;
                                        until DefaultDim.next = 0;

                                    if not DefaultDimComp.get(5200, RecEmployee."No.", GLSetup."Shortcut Dimension 8 Code") then begin
                                        if not DimeensionValue.get(GLSetup."Shortcut Dimension 8 Code", RecEmployee."Relocate to Company") then begin
                                            DimeensionValue.Init();
                                            DimeensionValue."Dimension Code" := GLSetup."Shortcut Dimension 8 Code";
                                            DimeensionValue.Code := RecEmployee."Relocate to Company";
                                            DimeensionValue.Name := RecEmployee."Relocate to Company";
                                            DimeensionValue.Insert(true);
                                        end;
                                        DefaultDimComp.Init();
                                        DefaultDimComp.Validate("Table ID", 5200);
                                        DefaultDimComp."No." := RecEmployee."No.";
                                        DefaultDimComp."Dimension Code" := GLSetup."Shortcut Dimension 8 Code";
                                        DefaultDimcomp."Dimension Value Code" := RecEmployee."Relocate to Company";
                                        DefaultDimComp.Insert(true);
                                    end;

                                    empBankAccounts.Reset();
                                    empBankAccounts.SetRange("Employee No.", recEmployee."No.");
                                    if empBankAccounts.FindSet() then
                                        repeat
                                            empBankAccounts2.Reset();
                                            empBankAccounts2.ChangeCompany(recEmployee."Relocate to Company");
                                            empBankAccounts2.Init();
                                            empBankAccounts2.TransferFields(empBankAccounts, false);
                                            empBankAccounts2."EMployee No." := empBankAccounts."Employee No.";
                                            empBankAccounts2.Code := empBankAccounts.Code;
                                            if not empbankAccounts2.Insert() then empBankAccounts2.Modify();
                                        until empBankAccounts.Next() = 0;

                                    MasterSyncDetails.init();
                                    MasterSyncDetails."Entry No." := 0;
                                    MasterSyncDetails.Code := recEmployee."No.";
                                    MasterSyncDetails."Company Name" := recEmployee."Relocate to Company";
                                    MasterSyncDetails."Sync DateTime" := CurrentDateTime;
                                    MasterSyncDetails."User ID" := UserId;
                                    MasterSyncDetails.Insert();

                                    RecEmployee.Company := RecEmployee."Relocate to Company";
                                    RecEmployee."Relocate to Company" := '';
                                    RecEmployee.Modify();
                                end
                                else begin
                                    EmpRec.changecompany(RecEmployee.company);
                                    EmpRec.init;
                                    EmpRec.TransferFields(RecEmployee, false);
                                    emprec."No." := RecEmployee."No.";
                                    if not emprec.insert then EmpRec.Modify();

                                    DefaultDimComp.ChangeCompany(recemployee.company);
                                    DimeensionValue.ChangeCompany(RecEmployee.Company);
                                    DefaultDim.reset;
                                    DefaultDim.SetRange("Table ID", 5200);
                                    DefaultDim.SetRange("No.", RecEmployee."No.");
                                    DefaultDim.SetFilter("Dimension Code", '<>%1&<>%2', GLSetup."Shortcut Dimension 8 Code", GLSetup."Shortcut Dimension 6 Code");
                                    if DefaultDim.FindSet() then
                                        repeat
                                            if not DimeensionValue.get(DefaultDim."Dimension Code", DefaultDim."Dimension Value Code") then begin
                                                DimeensionValue.Init();
                                                DimeensionValue."Dimension Code" := DefaultDim."Dimension Code";
                                                DimeensionValue.Code := DefaultDim."Dimension Value Code";
                                                DimeensionValue.Name := DefaultDim."Dimension Value Code";
                                                DimeensionValue.Insert(true);
                                            end;

                                            //if not DefaultDimComp.get(DefaultDim."Table ID", DefaultDim."No.", DefaultDim."Dimension Code") then begin
                                            DefaultDimComp.init;
                                            DefaultDimComp.TransferFields(DefaultDim, false);
                                            DefaultDimComp."Table ID" := DefaultDim."Table ID";
                                            DefaultDimComp."No." := DefaultDim."No.";
                                            DefaultDimComp."Dimension Code" := DefaultDim."Dimension Code";
                                            if not DefaultDimComp.insert then DefaultDimComp.Modify();
                                        //end;
                                        until DefaultDim.next = 0;

                                    if not DefaultDimComp.get(5200, RecEmployee."No.", GLSetup."Shortcut Dimension 8 Code") then begin
                                        if not DimeensionValue.get(GLSetup."Shortcut Dimension 8 Code", RecEmployee.company) then begin
                                            DimeensionValue.Init();
                                            DimeensionValue."Dimension Code" := GLSetup."Shortcut Dimension 8 Code";
                                            DimeensionValue.Code := RecEmployee.company;
                                            DimeensionValue.Name := RecEmployee.company;
                                            DimeensionValue.Insert(true);
                                        end;
                                        DefaultDimComp.Init();
                                        DefaultDimComp.Validate("Table ID", 5200);
                                        DefaultDimComp."No." := RecEmployee."No.";
                                        DefaultDimComp."Dimension Code" := GLSetup."Shortcut Dimension 8 Code";
                                        DefaultDimcomp."Dimension Value Code" := RecEmployee.company;
                                        DefaultDimComp.Insert(true);
                                    end;

                                    empBankAccounts.Reset();
                                    empBankAccounts.SetRange("Employee No.", recEmployee."No.");
                                    if empBankAccounts.FindSet() then
                                        repeat
                                            empBankAccounts2.Reset();
                                            empBankAccounts2.ChangeCompany(recEmployee.company);
                                            empBankAccounts2.Init();
                                            empBankAccounts2.TransferFields(empBankAccounts, false);
                                            empBankAccounts2."EMployee No." := empBankAccounts."Employee No.";
                                            empBankAccounts2.Code := empBankAccounts.Code;
                                            if not empbankAccounts2.Insert() then empBankAccounts2.Modify();
                                        until empBankAccounts.Next() = 0;

                                    MasterSyncDetails.init();
                                    MasterSyncDetails."Entry No." := 0;
                                    MasterSyncDetails.Code := recEmployee."No.";
                                    MasterSyncDetails."Company Name" := recEmployee.company;
                                    MasterSyncDetails."Sync DateTime" := CurrentDateTime;
                                    MasterSyncDetails."User ID" := UserId;
                                    MasterSyncDetails.Insert();
                                end;

                                Log.reset;
                                Log.SetCurrentKey("Table No.", "Primary key", Status);
                                Log.SetRange("Table No.", 5200);
                                Log.SetRange("Primary key", Recemployee."No.");
                                IF Not Log.FindFirst() then begin
                                    OutboundLog.Init();
                                    OutboundLog."Table No." := 5200;
                                    OutboundLog."Table Name" := rec.TableName;
                                    OutboundLog."Primary key" := recemployee."No.";
                                    if RecEmployee."Concur ID" = '' then
                                        OutboundLog."Entry Type" := 0
                                    else
                                        OutboundLog."Entry Type" := 1;
                                    OutboundLog.Status := OutboundLog.Status::Pending;
                                    OutboundLog."Company Name" := Recemployee.Company;
                                    OutboundLog.Insert(true);
                                end
                                else begin
                                    if RecEmployee."Concur ID" <> '' then begin
                                        OutboundLog.Init();
                                        OutboundLog."Table No." := 5200;
                                        OutboundLog."Table Name" := rec.TableName;
                                        OutboundLog."Primary key" := recemployee."No.";
                                        OutboundLog."Entry Type" := 1;
                                        OutboundLog.Status := OutboundLog.Status::Pending;
                                        if RecEmployee."Relocate to Company" <> '' then
                                            OutboundLog."Company Name" := recemployee."Relocate to Company"
                                        else
                                            OutboundLog."Company Name" := RecEmployee.Company;
                                        OutboundLog.Insert(true);
                                    end;
                                end;
                            end
                            else begin
                                if RecEmployee.crew then begin
                                    CompanyMapping.reset;
                                    CompanyMapping.SetRange("Master Data Company", false);
                                    Companymapping.setrange("Sync Employees", true);
                                    CompanyMapping.SetFilter("BC Company Name", '<>%1', APISetup."Default Company");
                                    if CompanyMapping.findset then
                                        repeat
                                            EmpRec.changecompany(CompanyMapping."BC Company Name");
                                            EmpRec.init;
                                            EmpRec.TransferFields(RecEmployee, false);
                                            emprec."No." := RecEmployee."No.";
                                            EmpRec.Company := CompanyMapping."BC Company Name";
                                            if not emprec.insert then EmpRec.Modify();

                                            DefaultDimComp.ChangeCompany(CompanyMapping."BC Company Name");
                                            DimeensionValue.ChangeCompany(CompanyMapping."BC Company Name");
                                            DefaultDim.reset;
                                            DefaultDim.SetRange("Table ID", 5200);
                                            DefaultDim.SetRange("No.", RecEmployee."No.");
                                            DefaultDim.SetFilter("Dimension Code", '<>%1&<>%2', GLSetup."Shortcut Dimension 8 Code", GLSetup."Shortcut Dimension 6 Code");
                                            if DefaultDim.FindSet() then
                                                repeat
                                                    if not DimeensionValue.get(DefaultDim."Dimension Code", DefaultDim."Dimension Value Code") then begin
                                                        DimeensionValue.Init();
                                                        DimeensionValue."Dimension Code" := DefaultDim."Dimension Code";
                                                        DimeensionValue.Code := DefaultDim."Dimension Value Code";
                                                        DimeensionValue.Name := DefaultDim."Dimension Value Code";
                                                        DimeensionValue.Insert(true);
                                                    end;
                                                    //if not DefaultDimComp.get(DefaultDim."Table ID", DefaultDim."No.", DefaultDim."Dimension Code") then begin
                                                    //DefaultDimComp.Reset();                                                        
                                                    DefaultDimComp.init;
                                                    DefaultDimComp.TransferFields(DefaultDim, false);
                                                    DefaultDimComp."Table ID" := DefaultDim."Table ID";
                                                    DefaultDimComp."No." := DefaultDim."No.";
                                                    DefaultDimComp."Dimension Code" := DefaultDim."Dimension Code";
                                                    //DefaultDimComp."Dimension Value Code" := DefaultDim."Dimension Value Code";
                                                    //DefaultDimComp."Value Posting" := DefaultDim."Value Posting";
                                                    if not DefaultDimComp.insert then DefaultDimComp.Modify();
                                                //end;
                                                until DefaultDim.next = 0;

                                            if not DefaultDimComp.get(5200, RecEmployee."No.", GLSetup."Shortcut Dimension 8 Code") then begin
                                                if not DimeensionValue.get(GLSetup."Shortcut Dimension 8 Code", CompanyMapping."BC Company Name") then begin
                                                    DimeensionValue.Init();
                                                    DimeensionValue."Dimension Code" := GLSetup."Shortcut Dimension 8 Code";
                                                    DimeensionValue.Code := CompanyMapping."BC Company Name";
                                                    DimeensionValue.Name := CompanyMapping."BC Company Name";
                                                    DimeensionValue.Insert(true);
                                                end;
                                                DefaultDimComp.Init();
                                                DefaultDimComp.Validate("Table ID", 5200);
                                                DefaultDimComp."No." := RecEmployee."No.";
                                                DefaultDimComp."Dimension Code" := GLSetup."Shortcut Dimension 8 Code";
                                                DefaultDimcomp."Dimension Value Code" := CompanyMapping."BC Company Name";
                                                DefaultDimComp.Insert(true);
                                            end;

                                            empBankAccounts.Reset();
                                            empBankAccounts.SetRange("Employee No.", recEmployee."No.");
                                            if empBankAccounts.FindSet() then
                                                repeat
                                                    empBankAccounts2.Reset();
                                                    empBankAccounts2.ChangeCompany(CompanyMapping."BC Company Name");
                                                    empBankAccounts2.Init();
                                                    empBankAccounts2.TransferFields(empBankAccounts, false);
                                                    empBankAccounts2."EMployee No." := empBankAccounts."Employee No.";
                                                    empBankAccounts2.Code := empBankAccounts.Code;
                                                    if not empbankAccounts2.Insert() then empBankAccounts2.Modify();
                                                until empBankAccounts.Next() = 0;

                                            MasterSyncDetails.init();
                                            MasterSyncDetails."Entry No." := 0;
                                            MasterSyncDetails.Code := recEmployee."No.";
                                            MasterSyncDetails."Company Name" := CompanyMapping."BC Company Name";
                                            MasterSyncDetails."Sync DateTime" := CurrentDateTime;
                                            MasterSyncDetails."User ID" := UserId;
                                            MasterSyncDetails.Insert();
                                        until CompanyMapping.next = 0;
                                end
                                else begin
                                    if (RecEmployee.Company <> '') and (RecEmployee.Company <> APISetup."Default Company") then begin
                                        EmpRec.changecompany(RecEmployee.company);
                                        EmpRec.init;
                                        EmpRec.TransferFields(RecEmployee, false);
                                        emprec."No." := RecEmployee."No.";
                                        if not emprec.insert then EmpRec.Modify();

                                        DefaultDimComp.ChangeCompany(recemployee.company);
                                        DimeensionValue.ChangeCompany(RecEmployee.Company);
                                        DefaultDim.reset;
                                        DefaultDim.SetRange("Table ID", 5200);
                                        DefaultDim.SetRange("No.", RecEmployee."No.");
                                        DefaultDim.SetFilter("Dimension Code", '<>%1&<>%2', GLSetup."Shortcut Dimension 8 Code", GLSetup."Shortcut Dimension 6 Code");
                                        if DefaultDim.FindSet() then
                                            repeat
                                                if not DimeensionValue.get(DefaultDim."Dimension Code", DefaultDim."Dimension Value Code") then begin
                                                    DimeensionValue.Init();
                                                    DimeensionValue."Dimension Code" := DefaultDim."Dimension Code";
                                                    DimeensionValue.Code := DefaultDim."Dimension Value Code";
                                                    DimeensionValue.Name := DefaultDim."Dimension Value Code";
                                                    DimeensionValue.Insert(true);
                                                end;

                                                //if not DefaultDimComp.get(DefaultDim."Table ID", DefaultDim."No.", DefaultDim."Dimension Code") then begin
                                                DefaultDimComp.init;
                                                DefaultDimComp.TransferFields(DefaultDim, false);
                                                DefaultDimComp."Table ID" := DefaultDim."Table ID";
                                                DefaultDimComp."No." := DefaultDim."No.";
                                                DefaultDimComp."Dimension Code" := DefaultDim."Dimension Code";
                                                if not DefaultDimComp.insert then DefaultDimComp.Modify();
                                            //end;
                                            until DefaultDim.next = 0;

                                        if not DefaultDimComp.get(5200, RecEmployee."No.", GLSetup."Shortcut Dimension 8 Code") then begin
                                            if not DimeensionValue.get(GLSetup."Shortcut Dimension 8 Code", RecEmployee.company) then begin
                                                DimeensionValue.Init();
                                                DimeensionValue."Dimension Code" := GLSetup."Shortcut Dimension 8 Code";
                                                DimeensionValue.Code := RecEmployee.company;
                                                DimeensionValue.Name := RecEmployee.company;
                                                DimeensionValue.Insert(true);
                                            end;
                                            DefaultDimComp.Init();
                                            DefaultDimComp.Validate("Table ID", 5200);
                                            DefaultDimComp."No." := RecEmployee."No.";
                                            DefaultDimComp."Dimension Code" := GLSetup."Shortcut Dimension 8 Code";
                                            DefaultDimcomp."Dimension Value Code" := RecEmployee.company;
                                            DefaultDimComp.Insert(true);
                                        end;

                                        empBankAccounts.Reset();
                                        empBankAccounts.SetRange("Employee No.", recEmployee."No.");
                                        if empBankAccounts.FindSet() then
                                            repeat
                                                empBankAccounts2.Reset();
                                                empBankAccounts2.ChangeCompany(recEmployee.company);
                                                empBankAccounts2.Init();
                                                empBankAccounts2.TransferFields(empBankAccounts, false);
                                                empBankAccounts2."EMployee No." := empBankAccounts."Employee No.";
                                                empBankAccounts2.Code := empBankAccounts.Code;
                                                if not empbankAccounts2.Insert() then empBankAccounts2.Modify();
                                            until empBankAccounts.Next() = 0;

                                        MasterSyncDetails.init();
                                        MasterSyncDetails."Entry No." := 0;
                                        MasterSyncDetails.Code := recEmployee."No.";
                                        MasterSyncDetails."Company Name" := recEmployee.company;
                                        MasterSyncDetails."Sync DateTime" := CurrentDateTime;
                                        MasterSyncDetails."User ID" := UserId;
                                        MasterSyncDetails.Insert();
                                    end;
                                end;
                            end;
                        end;
                        */
                        /*
                        empBankAccounts.Reset();
                        empBankAccounts.SetRange("Employee No.", Employee."No.");
                        if empBankAccounts.FindSet() then
                            repeat
                                empBankAccounts2.Reset();
                                empBankAccounts2.ChangeCompany(Employee.Company);
                                empBankAccounts2.Init();
                                empBankAccounts2.TransferFields(empBankAccounts, false);
                                empBankAccounts2."EMployee No." := empBankAccounts."Employee No.";
                                empBankAccounts2.Code := empBankAccounts.Code;
                                if not empbankAccounts2.Insert() then empBankAccounts2.Modify();
                            until empBankAccounts.Next() = 0;

                        MasterSyncDetails.init();
                        MasterSyncDetails."Entry No." := 0;
                        MasterSyncDetails.Code := Employee."No.";
                        MasterSyncDetails."Company Name" := Employee.Company;
                        MasterSyncDetails."Sync DateTime" := CurrentDateTime;
                        MasterSyncDetails."User ID" := UserId;
                        MasterSyncDetails.Insert();
                        */
                        until employeerec.Next() = 0;
                    Message('Done.');
                end;
            }
            action(SyncEmployeesLog)
            {
                ApplicationArea = all;
                Caption = 'Sync Employees Log';
                PromotedCategory = Process;
                Promoted = true;
                Ellipsis = true;
                Image = UpdateDescription;
                ToolTip = 'Sync Employees Log';
                RunObject = page "Master Sync Details";
                RunPageLink = Code=field("No.");

                trigger OnAction()
                var
                begin
                end;
            }
            action(BankAccounts)
            {
                ApplicationArea = all;
                Caption = 'Bank Accounts';
                PromotedCategory = Process;
                Promoted = true;
                Ellipsis = true;
                Image = BankAccount;
                ToolTip = 'Bank Accounts';
                RunObject = page "Employee Bank Account List";
                RunPageLink = "Employee No."=field("No.");

                trigger OnAction()
                var
                begin
                end;
            }
            action("Get Concur ID")
            {
                ApplicationArea = all;
                //Caption = 'Sync Employees Log';
                PromotedCategory = Process;
                Promoted = true;
                Ellipsis = true;
                Image = UpdateDescription;
                ToolTip = 'Get Concur ID';

                //RunObject = page "Master Sync Details";
                //RunPageLink = Code = field("No.");
                trigger OnAction()
                var
                    GetIdentity: Codeunit "Concur Get Identity";
                    EmployeeRec: Record Employee;
                begin
                    employeeRec.reset;
                    EmployeeRec.SetRange("Concur ID", '');
                    EmployeeRec.SetRange("Integrate to Concur", true);
                    if EmployeeRec.FindSet()then repeat //Clear(GetIdentity);
                            GetIdentity.GetConcurID(true, EmployeeRec);
                        until EmployeeRec.Next() = 0;
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
    begin
        ISMasterCompany:=CuCommonFunction.IsMasterCompany;
    end;
    var ISMasterCompany: Boolean;
    CuCommonFunction: codeunit 50100;
}
