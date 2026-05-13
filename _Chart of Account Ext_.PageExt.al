pageextension 50128 "Chart of Account Ext" extends "Chart of Accounts (G/L)"
{
    actions
    {
        addafter("Indent Chart of Accounts")
        {
            action(updateCOA)
            {
                ApplicationArea = all;
                Caption = 'Update COA in Template/Companies';
                PromotedCategory = Process;
                Promoted = true;
                Ellipsis = true;
                Image = UpdateDescription;
                ToolTip = 'Update COA';

                trigger OnAction()
                var
                    COATemp: record "COA Template G/L Accounts";
                    COA: record "G/L Account";
                    CompList: record Company;
                    CompMapping: record "Company Name Mapping";
                    COA2: Record "G/L Account";
                begin
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
                                            coa.Modify();
                                        end;
                                    until CompList.Next() = 0;
                            until coa2.Next() = 0;
                    end;
                end;
            }
        }
    }
    procedure GetSelectionFilter(): Text var
        GLList: Record "G/L Account";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(GLList);
        exit(SelectionFilterManagement.GetSelectionFilterForGLAccount(GLList));
    end;
    var myInt: Integer;
}
