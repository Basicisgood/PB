page 50112 glaccounts
{
    APIGroup = 'app1';
    APIPublisher = 'pb';
    APIVersion = 'v2.0', 'v1.0';
    ApplicationArea = All;
    Caption = 'Chart Of Accounts API';
    DelayedInsert = true;
    EntityName = 'glaccount';
    EntitySetName = 'glaccounts';
    PageType = API;
    SourceTable = "G/L Account";
    ODataKeyFields = "No.";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(globalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    Caption = 'Global Dimension 1 Code';
                }
                field(globalDimension2Code; Rec."Global Dimension 2 Code")
                {
                    Caption = 'Global Dimension 2 Code';
                }
            }
        }
    }
}
