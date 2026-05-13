page 50108 "COA Template G/L Accounts"
{
    PageType = List;
    //ApplicationArea = All;
    //UsageCategory = Lists;
    SourceTable = "COA Template G/L Accounts";
    Caption = 'COA Template G/L Accounts';
    InsertAllowed = false;
    DeleteAllowed = true;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            field(g_TemplateCode; g_TemplateCode)
            {
                Editable = false;
                Caption = 'Template Code';
                Visible = true;
                ApplicationArea = All;
            }
            repeater(GroupName)
            {
                ShowCaption = true;

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                }
                field("Sync Pending"; Rec."Sync Pending")
                {
                    ApplicationArea = all;
                }
            }
        }
        area(Factboxes)
        {
        }
    }
    actions
    {
        area(Processing)
        {
            action(EditCOATemplate)
            {
                ApplicationArea = All;
                Caption = 'Copy G/L Accounts';
                PromotedIsBig = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    lrec_COATemplateGLAcc: Record "COA Template G/L Accounts";
                    lrec_GLAccount: Record "G/L Account";
                    lPage_GLAccList: Page "G/L Account List";
                begin
                    Clear(lPage_GLAccList);
                    lPage_GLAccList.LookupMode:=true;
                    if lPage_GLAccList.RunModal() = ACTION::LookupOK then begin
                        lPage_GLAccList.SetSelectionFilter(lrec_GLAccount);
                        if lrec_GLAccount.findset then repeat lrec_COATemplateGLAcc.Init();
                                lrec_COATemplateGLAcc.TransferFields(lrec_GLAccount);
                                lrec_COATemplateGLAcc."Template Code":=g_TemplateCode;
                                lrec_COATemplateGLAcc."Sync Pending":=true;
                                if not lrec_COATemplateGLAcc.Insert()then begin
                                    lrec_COATemplateGLAcc.Modify();
                                end;
                            until lrec_GLAccount.Next() = 0;
                    end;
                end;
            }
        }
    }
    var T83: Record "Item Journal Line";
    g_TemplateCode: code[20];
    trigger OnOpenPage()
    begin
        rec.FilterGroup(2);
        rec.SetRange("Template Code", g_TemplateCode);
        rec.FilterGroup(0);
    end;
    procedure SetTemplate(p_Code: Code[20])
    begin
        g_TemplateCode:=p_Code;
    end;
}
