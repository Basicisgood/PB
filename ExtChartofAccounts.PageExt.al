pageextension 50132 ExtChartofAccounts extends "Chart of Accounts"
{
    layout
    {
        addafter("Account Subcategory Descript.")
        {
            field("Account Group"; Rec."Account Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Account Group field.', Comment = '%';
            }
            field(RMT1; Rec.RMT1)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the RMT1 field.', Comment = '%';
            }
            field(RMT2; Rec.RMT2)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the RMT2 field.', Comment = '%';
            }
            field(RMT3; Rec.RMT3)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the RMT3 field.', Comment = '%';
            }
            field(RMT4; Rec.RMT4)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the RMT4 field.', Comment = '%';
            }
            field(RMT5; Rec.RMT5)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the RMT5 field.', Comment = '%';
            }
        }
    }
    actions
    {
        addafter(IndentChartOfAccounts)
        {
            action(updateCOA)
            {
                ApplicationArea = all;
                Caption = 'Update COA in Template/Companies';
                PromotedCategory = Process;
                Promoted = true;
                Ellipsis = true;
                //Visible = false;
                Image = UpdateDescription;
                ToolTip = 'Update COA';

                trigger OnAction()
                var
                    COATemp: record "COA Template G/L Accounts";
                    COA: record "G/L Account";
                    CompList: record Company;
                    CompMapping: record "Company Name Mapping";
                    COA2: Record "G/L Account";
                    DefDImension: record "Default Dimension";
                    DefDimension2: record "Default Dimension";
                    DNVsetup: record "DNV Integration Setup";
                begin
                    DNVsetup.get;
                    CompMapping.Reset();
                    CompMapping.SetRange("BC Company Name", CompanyName);
                    CompMapping.SetRange("Master Data Company", true);
                    if not CompMapping.FindSet()then Error('This function can be executed in master company only');
                    if Confirm('Are you sure you want to update all the templates and Chart of accounts?')then begin
                        COA2.Reset();
                        CurrPage.SetSelectionFilter(COA2);
                        if COA2.FindSet()then repeat COATemp.Reset();
                                COATemp.SetRange("No.", COA2."No.");
                                if COATemp.FindSet()then repeat COATemp.TransferFields(COA2, false);
                                        COATemp.Modify();
                                    until COATemp.Next() = 0;
                                CompList.Reset();
                                CompList.SetFilter(Name, '<>%1', CompanyName);
                                if CompList.FindSet()then repeat COA.Reset();
                                        COA.ChangeCompany(CompList.Name);
                                        COA.SetRange("No.", COA2."No.");
                                        if coa.FindSet()then begin
                                            COA.TransferFields(COA2, false);
                                            COA."Consol. Translation Method":=COA."Consol. Translation Method"::"Average Rate (Manual)";
                                            coa.Modify();
                                            DefDImension.Reset();
                                            DefDimension.SetRange("Table ID", 15);
                                            DefDimension.SetRange("No.", COA2."No.");
                                            if DefDImension.FindSet()then repeat DefDimension2.Reset();
                                                    DefDimension2.ChangeCompany(CompList.Name);
                                                    DefDimension2.Init();
                                                    DefDimension2.TransferFields(DefDImension, false);
                                                    if not DefDimension2.Insert()then DefDImension2.Modify();
                                                until DefDImension.Next() = 0;
                                        end;
                                    until CompList.Next() = 0;
                                COA2.CreateOutboundLog(0); //TEC.VJ 11082024
                                COA2.CreateOutboundLog(1); //TEC.VJ 11082024
                            until coa2.Next() = 0;
                        COA2.Reset();
                    end;
                end;
            }
            // //TEC-Sgarg - Added >>
            action("Adjust Ex Rate")
            {
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;
                Ellipsis = true;
                Caption = 'Update COA Fields (Translation Method/Exchange Rate)';
                //Visible = false;
                Image = UpdateDescription;
                ToolTip = 'Update COA';

                trigger OnAction()
                var
                    comp: Record Company;
                    COA: record "G/L Account";
                    COA2: record "G/L Account";
                begin
                    COA.Reset();
                    coa.FindSet();
                    repeat comp.Reset();
                        comp.FindSet();
                        repeat COA2.Reset();
                            COA2.ChangeCompany(comp.Name);
                            COA2.SetRange("No.", COA."No.");
                            if COA2.FindSet()then begin
                                COA2."Consol. Translation Method":=COA."Consol. Translation Method";
                                COA2."Exchange Rate Adjustment":=COA."Exchange Rate Adjustment";
                                COA2.Modify();
                            end;
                        until comp.Next() = 0;
                    until coa.Next() = 0;
                end;
            }
        // //TEC-Sgarg - Added <<
        }
    }
}
