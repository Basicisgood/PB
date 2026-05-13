page 50105 "COA Template"
{
    ApplicationArea = All;
    Caption = 'COA Template';
    PageType = List;
    SourceTable = "COA Template";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(EditCOATemplate)
            {
                ApplicationArea = All;
                Caption = 'COA Templae G/L Accounts';
                PromotedIsBig = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    lrec_COATemplateGLAcc: Record "COA Template G/L Accounts";
                    lPage_COATemplateGLAcc: page "COA Template G/L Accounts";
                begin
                    clear(lPage_COATemplateGLAcc);
                    lPage_COATemplateGLAcc.SetTemplate(rec.Code);
                    lPage_COATemplateGLAcc.RunModal();
                end;
            }
            action(CopyTemplateAllCompany)
            {
                ApplicationArea = All;
                Caption = 'Copy Template All Company';
                PromotedIsBig = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    lrec_COATemplateGLAcc: Record "COA Template G/L Accounts";
                    lPage_COATemplateGLAcc: page "COA Template G/L Accounts";
                    CompMapping: Record "Company Name Mapping";
                    COA: Record "G/L Account";
                    DefaultDimension: record "Default Dimension";
                    DefaultDimension2: record "Default Dimension";
                begin
                    CompMapping.Reset();
                    CompMapping.SetRange("BC Company Name", CompanyName);
                    CompMapping.SetRange("Master Data Company", false);
                    if CompMapping.FindSet()then Error('This function can be executed in master company only');
                    if not Confirm(Text001)then exit;
                    lrec_COATemplateGLAcc.Reset();
                    lrec_COATemplateGLAcc.SetRange("Template Code", rec.Code);
                    lrec_COATemplateGLAcc.SetRange("Sync Pending", true);
                    lrec_COATemplateGLAcc.FindSet();
                    CompMapping.Reset();
                    CompMapping.SetRange("COA Template Code", rec.Code);
                    CompMapping.FindSet();
                    repeat repeat COA.Reset();
                            COA.ChangeCompany(CompMapping."BC Company Name");
                            COA.Init();
                            COA.TransferFields(lrec_COATemplateGLAcc, false);
                            COA."No.":=lrec_COATemplateGLAcc."No.";
                            coa."Consol. Translation Method":=lrec_COATemplateGLAcc."Consol. Translation Method";
                            if not COA.Insert()then COA.Modify();
                            //default dimensions
                            DefaultDimension.Reset();
                            DefaultDimension.SetRange("Table ID", 15);
                            DefaultDimension.SetRange("No.", lrec_COATemplateGLAcc."No.");
                            if DefaultDimension.FindSet()then repeat DefaultDimension2.Reset();
                                    DefaultDimension2.ChangeCompany(CompMapping."BC Company Name");
                                    DefaultDimension2.Init();
                                    DefaultDimension2."Table ID":=DefaultDimension."Table ID";
                                    DefaultDimension2."No.":=DefaultDimension."No.";
                                    DefaultDimension2."Dimension Code":=DefaultDimension."Dimension Code";
                                    DefaultDimension2."Dimension Value Code":=DefaultDimension."Dimension Value Code";
                                    DefaultDimension2."Value Posting":=DefaultDimension."Value Posting";
                                    if not DefaultDimension2.Insert()then DefaultDimension2.Modify();
                                until DefaultDimension.Next() = 0;
                        until CompMapping.Next() = 0;
                        lrec_COATemplateGLAcc."Sync Pending":=false;
                        lrec_COATemplateGLAcc.Modify();
                    until lrec_COATemplateGLAcc.Next() = 0;
                end;
            }
            action(ResteSyncData)
            {
                ApplicationArea = All;
                Caption = 'Reset Sync Data';
                PromotedIsBig = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    lrec_COATemplateGLAcc: Record "COA Template G/L Accounts";
                begin
                    lrec_COATemplateGLAcc.Reset();
                    lrec_COATemplateGLAcc.SetRange("Template Code", Rec.Code);
                    if lrec_COATemplateGLAcc.FindSet()then repeat lrec_COATemplateGLAcc."Sync Pending":=true;
                            lrec_COATemplateGLAcc.Modify();
                        until lrec_COATemplateGLAcc.Next() = 0;
                end;
            }
        }
    }
    var Text001: Label 'Do you want to copy this template to all the applicable company(s)';
}
