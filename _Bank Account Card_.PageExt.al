pageextension 50127 "Bank Account Card" extends "Bank Account Card"
{
    layout
    {
        modify("Currency Code")
        {
            Visible = false;
        }
        addafter(Name)
        {
            field("Account Holder Name"; Rec."Account Holder Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Account Holder Name field.', Comment = '%';
            }
            field("Bank Beneficiary Name"; Rec."Bank Beneficiary Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bank Beneficiary Name field.', Comment = '%';
            }
        }
        addlast(General)
        {
            field("Bank Integration Type"; Rec."Bank Integration Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bank Integration Type field.', Comment = '%';
            }
            field("Bank Statement from API"; Rec."Bank Statement from API")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bank Statement from API field.';
            }
            field("No Corresponding Bank for Pmt"; Rec."No Corresponding Bank for Pmt")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the "No Corresponding Bank For Payment field.', Comment = '%';
            }
            field("Institution Code"; Rec."HSBC Institution Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Institution Code field.';
            }
            field("HSBC Account Type"; Rec."HSBC Account Type")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the HSBC Account Type field.';
            }
        }
        // modify("Currency Code")
        // {
        //     Visible = false;
        // }
        addfirst(Posting)
        {
            field("Currency Code Custom"; Rec."Currency Code Custom")
            {
                ApplicationArea = All;
                Caption = 'Currency Code';
                ToolTip = 'Specifies the value of the Bank Integration Type field.', Comment = '%';
            }
        }
        addlast(Transfer)
        {
            field("ABA Routing Code"; Rec."ABA Routing Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the ABA Routing Code field.', Comment = '%';
            }
        }
        addafter(Transfer)
        {
            //#162 TEC.VJ 160012025>> 
            group(Correspondent)
            {
                Caption = 'Correspondent Bank';

                field("Correspondent Bank Name"; Rec."Correspondent Bank Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Correspondent Bank Name field.', Comment = '%';
                }
                field("Correspondent Swift Code"; Rec."Correspondent Swift Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Correspondent Swift Code field.', Comment = '%';
                }
                field("Correspondent Bank Account No."; Rec."Correspondent Bank Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Correspondent Bank Account No. field.', Comment = '%';
                }
            }
        //#162 TEC.VJ 160012025<<
        }
    }
    actions
    {
        addafter("Ledger E&ntries")
        {
            action(HSBC53)
            {
                Caption = 'Import HSBC Statement 53';
                ApplicationArea = all;
                Image = Allocations;

                trigger OnAction()
                var
                    l_rep_HSBC53: Report "HSBC CAMT53 Manual";
                begin
                    Clear(l_rep_HSBC53);
                    l_rep_HSBC53.SetBankAccountNo(Rec."Bank Account No.");
                    l_rep_HSBC53.Run;
                end;
            }
            action(Citi53)
            {
                Caption = 'Import Citi Statement 53';
                ApplicationArea = all;
                Image = Allocations;

                trigger OnAction()
                var
                    l_rep_CITI53: Report "Citi CAMT 53 Maunal";
                begin
                    Clear(l_rep_CITI53);
                    l_rep_CITI53.SetBankAccountNo(Rec."Bank Account No.");
                    l_rep_CITI53.Run;
                end;
            }
        }
        addlast(Category_Category5)
        {
            actionref(HSBC53_Promoted; HSBC53)
            {
            }
            actionref(Citi53_Promoted; Citi53)
            {
            }
        }
    }
}
