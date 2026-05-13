page 50200 "DNV Integration Setup"
{
    ApplicationArea = All;
    Caption = 'DNV Integration Setup';
    PageType = Card;
    SourceTable = "DNV Integration Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group("Outbound Setup")
            {
                group(General)
                {
                    Caption = 'General';

                    field("Is Enable"; Rec."Is Enable")
                    {
                        ApplicationArea = All;
                        Caption = 'Enable DNV Integration';
                    }
                    field("Token URL"; Rec."Token URL")
                    {
                        ApplicationArea = All;
                    }
                    field("Account Create URL"; Rec."Account Create URL")
                    {
                        ApplicationArea = All;
                    }
                    field("Account Update URL"; Rec."Account Update URL")
                    {
                        ApplicationArea = All;
                    }
                    field("Contact Create URL"; Rec."Contact Create URL")
                    {
                        ApplicationArea = All;
                    }
                    field("Contact Update URL"; Rec."Contact Update URL")
                    {
                        ApplicationArea = All;
                    }
                    field("CurrExchRate Create URL"; Rec."CurrExchRate Create URL")
                    {
                        ToolTip = 'Specifies the value of the CurrExchRate Create URL field.', Comment = '%';
                        ApplicationArea = all;
                    }
                    field("Invoices Payment Update URL"; Rec."Invoices Payment Update URL")
                    {
                        ToolTip = 'Specifies the value of the Invoices Payment Update URL field.', Comment = '%';
                        ApplicationArea = all;
                    }
                    field("User Id"; Rec."User Id")
                    {
                        ApplicationArea = All;
                    }
                    field(Password; Rec.Password)
                    {
                        ApplicationArea = All;
                    }
                    field("G/L Account Initials Sync"; Rec."G/L Account Initials Sync")
                    {
                        ApplicationArea = All;
                    }
                    field("Access Token"; AccessToken)
                    {
                        //           Visible = false;
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
            group("Inbound Setup")
            {
                group("Invoice")
                {
                    field("Auto Post Receive-Invoice"; Rec."Auto Post Invoice")
                    {
                        ToolTip = 'Specifies the value of the Auto Post Purchase Invoice field.', Comment = '%';
                        ApplicationArea = All;
                    }
                    field("Invoice Correction Suffix"; Rec."Invoice Correction Suffix")
                    {
                        ApplicationArea = all;
                    }
                    //     field("Main Financial Company"; Rec."Main Financial Company")
                    //   {
                    //      ApplicationArea = all;
                    //  }
                    field("Invoice Def. Gen. Jnl.Template"; Rec."Invoice Def. Gen. Jnl.Template")
                    {
                        ApplicationArea = all;
                    }
                    field("Invoice Def. Gen. Jnl. Batch"; Rec."Invoice Def. Gen. Jnl. Batch")
                    {
                        ApplicationArea = all;
                    }
                    field("Invoice Countrt Party Type"; Rec."Invoice Countrt Party Type")
                    {
                        ApplicationArea = all;
                    }
                }
                Group("Commited Cost")
                {
                    field("Auto Post Recurring General"; Rec."Auto Post Recurring Journal")
                    {
                        ToolTip = 'Specifies the value of the Auto Post Recurring General field.', Comment = '%';
                        ApplicationArea = all;
                    }
                    field("Commited Cost Bal. Account No."; Rec."Commited Cost Bal. Account No.")
                    {
                        ToolTip = 'Specifies the value of the Bal. Account No. field.', Comment = '%';
                        ApplicationArea = All;
                    }
                    field("Recurring Gen. Jnl. Template"; Rec."Recurring Gen. Jnl. Template")
                    {
                        ToolTip = 'Specifies the value of the Recurring Gen. Jnl. Template field.', Comment = '%';
                        ApplicationArea = all;
                        LookupPageId = "General Journal Template List";
                    }
                    field("Recurring Gen. Jnl. Batch"; Rec."Recurring Gen. Jnl. Batch")
                    {
                        ToolTip = 'Specifies the value of the Recurring Gen. Jnl. Batch field.', Comment = '%';
                        ApplicationArea = all;
                        LookupPageId = "General Journal Batches";
                    }
                    field("Accrual No Series"; Rec."Accrual No Series")
                    {
                        ApplicationArea = all;
                    }
                }
                Group("Crew Payroll")
                {
                    field("Auto Post General Journal"; Rec."Auto Post General Journal")
                    {
                        ToolTip = 'Specifies the value of the Auto Post General Journal field.', Comment = '%';
                        ApplicationArea = all;
                    }
                    field("Default Gen. Jnl. Template"; Rec."Default Gen. Jnl. Template")
                    {
                        ToolTip = 'Specifies the value of the Default Gen. Jnl. Template field.', Comment = '%';
                        ApplicationArea = all;
                    }
                    field("Default Gen. Jnl. Batch"; Rec."Default Gen. Jnl. Batch")
                    {
                        ToolTip = 'Specifies the value of the Default Gen. Jnl. Batch field.', Comment = '%';
                        ApplicationArea = all;
                    }
                    field("Wages Bal Account No."; Rec."Wages Bal Account No.")
                    {
                        ToolTip = 'Specifies the value of the Cash Account field.', Comment = '%';
                        ApplicationArea = all;
                    }
                    field("Payout Default Gen. Jnl. Templ"; Rec."Payout Default Gen. Jnl. Templ")
                    {
                        ApplicationArea = all;
                    }
                    field("Payout Default Gen. Jnl. Batch"; Rec."Payout Default Gen. Jnl. Batch")
                    {
                        ApplicationArea = all;
                    }
                    field("Leave Pay Bal Account No."; Rec."Leave Pay Bal Account No.")
                    {
                        ApplicationArea = all;
                    }
                }
                Group("Crew Member")
                {
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Get Token")
            {
                ApplicationArea = All;
                Image = Post;

                trigger OnAction()
                begin
                    Clear(CU_APIRequest);
                    CU_APIRequest.GenerateRefreshToken();
                    CurrPage.Update(false);
                end;
            }
            action("Check GL Account Insert")
            {
                ApplicationArea = All;
                Image = Post;

                trigger OnAction()
                begin
                    Clear(CU_APIGLInsert);
                    //   CU_APIGLInsert.PrepareBody();
                    CU_APIGLInsert.GLAccountInsert(0);
                //CurrPage.Update(false);
                end;
            }
            action("Check GL Account Update")
            {
                ApplicationArea = All;
                Image = Post;

                trigger OnAction()
                begin
                    Clear(CU_APIGLInsert);
                    CU_APIGLInsert.GLAccountInsert(1);
                end;
            }
            action("Check Contact Insert")
            {
                ApplicationArea = All;
                Image = Post;

                trigger OnAction()
                begin
                    Clear(CU_APIContactInsert);
                    CU_APIContactInsert.ContactInsert(0);
                end;
            }
            action("Check Contact Update")
            {
                ApplicationArea = All;
                Image = Post;

                trigger OnAction()
                begin
                    Clear(CU_APIContactInsert);
                    CU_APIContactInsert.ContactInsert(1);
                end;
            }
            action("Check CurrExchRate Insert")
            {
                ApplicationArea = All;
                Image = Post;

                trigger OnAction()
                begin
                    Clear(CU_APICurrExchRateInsert);
                    CU_APICurrExchRateInsert.CurrExchRateInsert(0);
                end;
            }
        }
        area(Navigation)
        {
            action("DVN Outbound Log")
            {
                Caption = 'DNV Outbound Log';
                ApplicationArea = All;
                Image = Navigate;
                RunObject = page "DNV Outbound Log";

                trigger OnAction()
                begin
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        AccessToken:=rec.GetAccessToken();
    end;
    var AccessToken: text;
    CU_APIRequest: Codeunit "API Token Request";
    CU_APIGLInsert: Codeunit "API Account Insert/Update Req";
    CU_APIContactInsert: Codeunit "API Contact Insert/Update";
    CU_APICurrExchRateInsert: Codeunit "API CurrExchRate Insert";
    CU_APIInvoiePaymentupdate: Codeunit "API Invoice Payment Update";
}
