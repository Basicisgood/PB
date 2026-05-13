table 50104 "Company COA Template"
{
    Caption = 'Company COA Template';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Company Name"; Text[50])
        {
            Caption = 'Company Name';
            TableRelation = Company;
        }
        field(2; "COA Template Code"; Code[20])
        {
            Caption = 'COA Template Code';
            TableRelation = "COA Template";
        }
        field(3; Synchronized; Boolean)
        {
            Caption = 'Synchronized';
        }
    }
    keys
    {
        key(PK; "Company Name", "COA Template Code")
        {
            Clustered = true;
        }
    }
    procedure CopyGLAccount(p_SuppressMessage: Boolean)
    var
        lrec_GLAccount: Record "G/L Account";
        lrec_COATemplateAccounts: Record "COA Template G/L Accounts";
    begin
        lrec_GLAccount.ChangeCompany(rec."Company Name");
        lrec_COATemplateAccounts.Reset();
        lrec_COATemplateAccounts.SetRange("Template Code", rec."COA Template Code");
        if lrec_COATemplateAccounts.findset then repeat lrec_GLAccount.TransferFields(lrec_COATemplateAccounts);
                if not lrec_COATemplateAccounts.Insert()then lrec_COATemplateAccounts.Modify();
            until lrec_COATemplateAccounts.Next() = 0;
        rec.Synchronized:=true;
        rec.Modify();
        if not p_SuppressMessage then Message(Text001);
    end;
    var Text001: Label 'Accounts Synchronized';
}
