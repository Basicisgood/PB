page 50271 "Marcura Setup"
{
    ApplicationArea = All;
    Caption = 'Marcura Setup';
    PageType = Card;
    SourceTable = "Marcura Setup";
    InsertAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Token URL"; Rec."Token URL")
                {
                    ToolTip = 'Specifies the value of the Token URL field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Payment API URL"; Rec."Payment API URL")
                {
                    ToolTip = 'Specifies the value of the Payment API URL field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("User Id"; Rec."User Id")
                {
                    ApplicationArea = All;
                }
                field(Password; Rec.Password)
                {
                    ApplicationArea = All;
                    ExtendedDatatype = Masked;
                }
                field("Payment Template Name"; Rec."Payment Template Name")
                {
                    ApplicationArea = all;
                }
                field("Payment Batch Name"; Rec."Payment Batch Name")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Access Token"; AccessToken)
                {
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Access Token field.';
                    MultiLine = true;

                    trigger OnValidate()
                    begin
                        Rec.SetAccessToken(AccessToken);
                    end;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ProcessLine)
            {
                ApplicationArea = All;
                Caption = 'Generate Token';
                Image = Interaction;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CUMarcuraIntegration: Codeunit "Marcura Integration";
                begin
                    clear(CUMarcuraIntegration);
                    CUMarcuraIntegration.Run();
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        if not Rec.get then rec.Insert();
        AccessToken:=rec.GetAccessToken();
    end;
    var AccessToken: text;
}
