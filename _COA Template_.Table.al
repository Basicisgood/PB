table 50103 "COA Template"
{
    Caption = 'COA Template';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    begin
        grec_COATemplateGLAccounts.Reset();
        grec_COATemplateGLAccounts.SetRange("Template Code", rec.Code);
        if grec_COATemplateGLAccounts.FindSet()then grec_COATemplateGLAccounts.DeleteAll();
    end;
    var grec_COATemplateGLAccounts: Record "COA Template G/L Accounts";
    procedure CopyTemplateApplicableCompany()
    var
        lrec_COATemplateCompany: Record "Company COA Template";
        l_Window: Dialog;
        l_Text001: Label '#1#################################\\ Copying company';
    begin
        lrec_COATemplateCompany.Reset();
        lrec_COATemplateCompany.SetRange("COA Template Code", Rec.Code);
        if lrec_COATemplateCompany.FindSet()then begin
            l_Window.Open(l_Text001);
            repeat l_Window.Update(1, lrec_COATemplateCompany."Company Name");
                lrec_COATemplateCompany.CopyGLAccount(true);
            until lrec_COATemplateCompany.Next() = 0;
            l_Window.Close();
        end;
    end;
}
