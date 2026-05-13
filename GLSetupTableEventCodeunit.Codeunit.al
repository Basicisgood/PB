codeunit 50103 GLSetupTableEventCodeunit
{
    [EventSubscriber(ObjectType::Table, Database::"General Ledger Setup", OnAfterValidateEvent, "Allow Posting From", false, false)]
    local procedure AllowedPostingFromOnAfterValidateEvent(var Rec: Record "General Ledger Setup"; var xRec: Record "General Ledger Setup")
    var
        CompanyLoop: Record Company;
        GLSetup: Record "General Ledger Setup";
        CurrCompany: Text;
    begin
        if NOT(xRec."Allow Posting From" = Rec."Allow Posting From")then begin
            CurrCompany:=CompanyName;
            CompanyLoop.Reset();
            CompanyLoop.SetFilter(Name, '<>%1', CurrCompany);
            If CompanyLoop.FindSet()then repeat Clear(GLSetup);
                    GLSetup.ChangeCompany(CompanyLoop.Name);
                    GLSetup.Get();
                    GLSetup."Allow Posting From":=Rec."Allow Posting From";
                    GLSetup.Modify();
                until CompanyLoop.Next() = 0;
        end;
    end;
    [EventSubscriber(ObjectType::Table, Database::"General Ledger Setup", OnAfterValidateEvent, "Allow Posting To", false, false)]
    local procedure AllowedPostingToOnAfterValidateEvent(var Rec: Record "General Ledger Setup"; var xRec: Record "General Ledger Setup")
    var
        CompanyLoop: Record Company;
        GLSetup: Record "General Ledger Setup";
        CurrCompany: Text;
    begin
        if NOT(xRec."Allow Posting To" = Rec."Allow Posting To")then begin
            CurrCompany:=CompanyName;
            CompanyLoop.Reset();
            CompanyLoop.SetFilter(Name, '<>%1', CurrCompany);
            If CompanyLoop.FindSet()then repeat Clear(GLSetup);
                    GLSetup.ChangeCompany(CompanyLoop.Name);
                    GLSetup.Get();
                    GLSetup."Allow Posting To":=Rec."Allow Posting To";
                    GLSetup.Modify();
                until CompanyLoop.Next() = 0;
        end;
    end;
}
