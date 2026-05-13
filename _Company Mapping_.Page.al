page 50182 "Company Mapping"
{
    ApplicationArea = All;
    Caption = 'Company Mapping';
    PageType = List;
    SourceTable = "Company Name Mapping";
    UsageCategory = Lists;
    PromotedActionCategories = 'New,Process,Report,Central Company';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("BC Company Name"; Rec."BC Company Name")
                {
                    ToolTip = 'Specifies the value of the BC Company Name field.', Comment = '%';
                    Style = Strong;
                    StyleExpr = StyleText;
                    ApplicationArea = All;
                }
                field("PB Company Code"; Rec."PB Company Code")
                {
                    ToolTip = 'Specifies the value of the PB Company Code field.', Comment = '%';
                    Style = Strong;
                    StyleExpr = StyleText;
                    ApplicationArea = All;
                }
                field("IMOS Company code"; Rec."IMOS Company code")
                {
                    ApplicationArea = all;
                }
                field("Concur Company Code"; Rec."Concur Company Code")
                {
                    ApplicationArea = all;
                }
                field("DNV Company"; Rec."DNV Company")
                {
                    ToolTip = 'Specifies the value of the Company Type field.', Comment = '%';
                    Style = Strong;
                    StyleExpr = StyleText;
                    ApplicationArea = All;
                }
                field("IMOS Company"; Rec."IMOS Company")
                {
                    ToolTip = 'Specifies the value of the Company Type field.', Comment = '%';
                    Style = Strong;
                    StyleExpr = StyleText;
                    ApplicationArea = All;
                }
                field("GNA Company"; Rec."GNA Company")
                {
                    ToolTip = 'Specifies the value of the Company Type field.', Comment = '%';
                    Style = Strong;
                    StyleExpr = StyleText;
                    ApplicationArea = All;
                }
                field("Test Company"; Rec."Test Company")
                {
                    ToolTip = 'Specifies the value of the Test Company field.', Comment = '%';
                    Style = Strong;
                    StyleExpr = StyleText;
                    ApplicationArea = All;
                }
                field("Master Data Company"; Rec."Master Data Company")
                {
                    ToolTip = 'Specifies the value of the Master data Company field.', Comment = '%';
                    Style = Strong;
                    StyleExpr = StyleText;
                    ApplicationArea = All;
                }
                field("Consolidation Company"; Rec."Consolidation Company")
                {
                    ApplicationArea = all;
                    Style = Strong;
                    StyleExpr = StyleText;
                }
                field("Ship COmpany"; Rec."Ship COmpany")
                {
                    ApplicationArea = all;
                    Style = Strong;
                    StyleExpr = StyleText;
                }
                //PS015 Start
                field("Budget Company"; Rec."Budget Company")
                {
                    ApplicationArea = all;
                    Style = Strong;
                    StyleExpr = StyleText;
                }
                //PS015 End
                field("COA Template Code"; Rec."COA Template Code")
                {
                    ApplicationArea = all;
                    StyleExpr = StyleText;
                }
                field("Parent Company"; Rec."Central payment company")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleText;
                }
                field("Current ACcount No."; Rec."Current ACcount No.")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleText;
                }
                //PS006 Start
                field("Sync Employees"; Rec."Sync Employees")
                {
                    ApplicationArea = all;
                }
                //PS006 End
                field("Autopost Depreciation"; Rec."Autopost Depreciation")
                {
                    ApplicationArea = All;
                }
                //PS011 Start
                field(DBase; Rec.DBase)
                {
                    ApplicationArea = all;
                }
                //PS011 End
                field("Marcura Debit Bank Account No"; Rec."Marcura Debit Bank Account No")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            // action("Temporary clear")
            // {
            //     ApplicationArea = All;
            //     Promoted = true;
            //     PromotedIsBig = true;
            //     PromotedCategory = Category4;
            //     trigger OnAction()
            //     var
            //         CU: Codeunit 50190;
            //     begin
            //         CU.ClearApplietoId();
            //     end;
            // }
            action("Select Payment Company")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    P_MappingSelect: Page "Company Mapping Multiple";
                begin
                    clear(P_MappingSelect);
                    P_MappingSelect.SetCompanyCode(rec."BC Company Name");
                    P_MappingSelect.runmodal;
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        if Rec."Master Data Company" = true then StyleText:=true
        else
            StyleText:=false;
    end;
    var StyleText: Boolean;
}
