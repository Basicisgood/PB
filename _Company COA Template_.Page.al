page 50106 "Company COA Template"
{
    //ApplicationArea = All;
    Caption = 'Company COA Template';
    PageType = List;
    SourceTable = "Company COA Template";
    ApplicationArea = All;

    //UsageCategory = Administration;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Company Name"; Rec."Company Name")
                {
                    ToolTip = 'Specifies the value of the Company Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("COA Template Code"; Rec."COA Template Code")
                {
                    ToolTip = 'Specifies the value of the COA Template Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                Field(Synchronized; Rec.Synchronized)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(CopyCOATemplate)
            {
                ApplicationArea = All;
                Caption = 'Synchronize Template';
                ToolTip = 'Copy Template and accounts to company';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    rec.TestField("Company Name");
                    rec.TestField(Synchronized, false);
                    IF not Confirm(StrSubstNo(Text001, rec."Company Name"))then exit;
                    rec.CopyGLAccount(false);
                end;
            }
        }
    }
    var Text001: Label 'Copy Chart of accounts to Company %1';
}
