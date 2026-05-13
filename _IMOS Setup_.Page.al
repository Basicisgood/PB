page 50129 "IMOS Setup"
{
    ApplicationArea = All;
    Caption = 'IMOS Setup';
    PageType = Card;
    SourceTable = "IMOS Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Is Enable"; Rec."Is Enable")
                {
                    Caption = 'Énable';
                    ToolTip = 'Specifies the value of the Is Enable field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Token URL"; Rec."Token URL")
                {
                    ToolTip = 'Specifies the value of the Token URL field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("API Token"; Rec."API Token")
                {
                    ToolTip = 'Specifies the value of the API Token field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Company Dimension Type"; Rec."Vendor Type Dimension")
                {
                    ToolTip = 'Specifies the value of the Company Dimension Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("FD4 Default VAlue"; Rec."FD4 Default VAlue")
                {
                    ApplicationArea = all;
                }
                field("FD9 Default Value"; Rec."FD9 Default Value")
                {
                    ApplicationArea = all;
                }
                field("Bank Charge GL Code"; Rec."Bank Charge GL Code")
                {
                    ApplicationArea = all;
                }
                field("Default Cash Receipt Batch"; Rec."Default Cash Receipt Batch")
                {
                    ApplicationArea = all;
                }
                field("Default Payment Reversal Batch"; Rec."Default Payment Reversal Batch")
                {
                    ApplicationArea = all;
                }
                field("Payment Reversal Batch"; Rec."Payment Reversal Batch")
                {
                    ApplicationArea = all;
                }
                field("Push IMOS Transaction"; Rec."Push IMOS Transaction")
                {
                    ApplicationArea = all;
                }
                field("Exch Gain/Loss Account"; Rec."Exch Gain/Loss Account")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action("IMOS API Log")
            {
                Caption = 'IMOS API Log';
                ApplicationArea = All;
                Image = Navigate;
                RunObject = page "IMOS API LOG";
            }
            action("Check Company Dimension Mapping Insert")
            {
                ApplicationArea = All;
                Image = Post;

                trigger OnAction()
                var
                    APISync: codeunit "API IMOS SYNC";
                begin
                    APISync.GetAndUpdateAPILOGForComDimMapping(0);
                end;
            }
            action("Check Company Dimension Mapping Update")
            {
                ApplicationArea = All;
                Image = Post;

                trigger OnAction()
                var
                    APISync: codeunit "API IMOS SYNC";
                begin
                    APISync.GetAndUpdateAPILOGForComDimMapping(1);
                end;
            }
            action("Check Currency Exch. Rate Insert")
            {
                ApplicationArea = All;
                Image = Post;

                trigger OnAction()
                var
                    APISync: codeunit "API IMOS SYNC";
                begin
                    APISync.GetAndUpdateAPILOGForCurrExchRate(0);
                end;
            }
            action("Check Invoices Payment Update")
            {
                ApplicationArea = All;
                Image = Post;

                trigger OnAction()
                var
                    APISync: codeunit "API IMOS SYNC";
                begin
                    Clear(APISync);
                    APISync.GetAndUpdateAPILOGForVendLedg(1);
                end;
            }
            action("Check Customer Payment Update")
            {
                ApplicationArea = All;
                Image = Post;

                trigger OnAction()
                var
                    APISync: codeunit "API IMOS SYNC";
                begin
                    Clear(APISync);
                //APISync.GetAndUpdateAPILOGForCustLedger(1);
                end;
            }
            action("Check Customer Bank Account Update")
            {
                ApplicationArea = All;
                Image = Post;

                trigger OnAction()
                var
                    APISync: codeunit "API IMOS SYNC";
                begin
                    Clear(APISync);
                    APISync.GetAndUpdateAPILOGForCustBankAcc(1);
                end;
            }
            action("Check Vendor Bank Account Update")
            {
                ApplicationArea = All;
                Image = Post;

                trigger OnAction()
                var
                    APISync: codeunit "API IMOS SYNC";
                begin
                    Clear(APISync);
                    APISync.GetAndUpdateAPILOGForVendorBankAcc(1);
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
    begin
        if not rec.Get()then rec.Insert();
    end;
}
