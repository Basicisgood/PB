page 50126 "Replicate Masters"
{
    ApplicationArea = All;
    Caption = 'Replicate Masters';
    PageType = List;
    SourceTable = "Replicate Masters";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("No. 2"; Rec."No. 2")
                {
                    ApplicationArea = All;
                }
                field("No. 3"; Rec."No. 3")
                {
                    ApplicationArea = All;
                }
                field(Company; Rec.Company)
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field(Replicate; Rec.Replicate)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
