codeunit 50202 "Process Vessel n TC Export"
{
    trigger OnRun()
    var
        VesselExport: record "Vessel Export Inbound";
        DImValue: record "Dimension Value";
        Companies: record Company;
        CompMapping: record "Company Name Mapping";
    begin
        VesselExport.Reset();
        VesselExport.SetRange(Synch, false);
        VesselExport.SetFilter("Vessel Code", '<>%1', '');
        VesselExport.SetFilter("Vessel Name", '<>%1', '');
        if VesselExport.FindSet()then repeat DImValue.Reset();
                if not DImValue.get('FD2', VesselExport."Vessel Code")then begin
                    DImValue.Reset();
                    DImValue.Init();
                    DImValue.validate("Dimension Code", 'FD2');
                    DImValue.Validate(Code, VesselExport."Vessel Code");
                    DImValue.Validate(Name, VesselExport."Vessel Name");
                    DImValue.Insert(true);
                    DImValue."Global Dimension No.":=10;
                    DImValue.Modify();
                end;
                DImValue.Reset();
                CompMapping.Reset();
                CompMapping.SetRange("IMOS Company", true);
                if CompMapping.FindSet()then repeat DImValue.Reset();
                        DImValue.ChangeCompany(CompMapping."BC Company Name");
                        if not DImValue.get('FD2', VesselExport."Vessel Code")then begin
                            DImValue.Reset();
                            DImValue.ChangeCompany(CompMapping."BC Company Name");
                            DImValue.Init();
                            DImValue.validate("Dimension Code", 'FD2');
                            DImValue.Validate(Code, VesselExport."Vessel Code");
                            DImValue.Validate(Name, VesselExport."Vessel Name");
                            DImValue.Insert(true);
                            DImValue."Global Dimension No.":=10;
                            DImValue.Modify();
                        end;
                    until CompMapping.Next() = 0;
                VesselExport.Synch:=true;
                VesselExport.Modify();
            until VesselExport.Next() = 0;
    end;
}
