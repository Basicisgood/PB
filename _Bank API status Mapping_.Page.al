page 50221 "Bank API status Mapping"
{
    ApplicationArea = All;
    Caption = 'Bank API status Mapping';
    PageType = List;
    SourceTable = "Bank API status Mapping";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Bank Code"; Rec."Bank Code")
                {
                    ToolTip = 'Specifies the value of the Bank Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("API Status (BC)"; Rec."API Status (BC)")
                {
                    ToolTip = 'Specifies the value of the API Status (BC) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Trigger API"; Rec."Trigger API")
                {
                    ApplicationArea = ALL;
                    ToolTip = 'Specifies the value of the Trigger API field.', Comment = '%';
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        if Rec.Count < 1 then begin
            Rec.Init();
            Rec."Bank Code":='ACCP';
            Rec.Description:='The payment is processed by bank';
            Rec."API Status (BC)":=Rec."API Status (BC)"::Approved;
            Rec.Insert();
            Rec.Init();
            Rec."Bank Code":='RJCT';
            Rec.Description:='The payment is rejected by bank';
            Rec."API Status (BC)":=Rec."API Status (BC)"::Rejected;
            Rec.Insert();
        end;
    end;
}
