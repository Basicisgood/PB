pageextension 50145 EmployeeLedgerEntries extends "Employee Ledger Entries"
{ //PS006
    layout
    {
        modify("Shortcut Dimension 3 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 4 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 5 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 6 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 7 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 8 Code")
        {
            Visible = false;
        }
        addafter("Bal. Account No.")
        {
            field("Shortcut Dimension 3 Code_PB"; Rec."Shortcut Dimension 3 Code_PB")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code_pb field.';
            }
            field("Shortcut Dimension 4 Code_PB"; Rec."Shortcut Dimension 4 Code_PB")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code_pb field.';
            }
            field("Shortcut Dimension 5 Code_PB"; Rec."Shortcut Dimension 5 Code_PB")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Shortcut Dimension 5 Code_pb field.';
            }
            field("Shortcut Dimension 6 Code_PB"; Rec."Shortcut Dimension 6 Code_PB")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Shortcut Dimension 6 Code_pb field.';
            }
            field("Shortcut Dimension 7 Code_PB"; Rec."Shortcut Dimension 7 Code_PB")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Shortcut Dimension 7 Code_pb field.';
            }
            field("Shortcut Dimension 8 Code_PB"; Rec."Shortcut Dimension 8 Code_PB")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Shortcut Dimension 8 Code_pb field.';
            }
            field("Shortcut Dimension 9 Code_PB"; Rec."Shortcut Dimension 9 Code_PB")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Shortcut Dimension 9 Code_pb field.';
            }
            field("Shortcut Dimension 10 Code_PB"; Rec."Shortcut Dimension 10 Code_PB")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Shortcut Dimension 10 Code_pb field.';
            }
            field("Shortcut Dimension 11 Code_PB"; Rec."Shortcut Dimension 11 Code_PB")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Shortcut Dimension 11 Code_pb field.';
            }
            field("Shortcut Dimension 12 Code_PB"; Rec."Shortcut Dimension 12 Code_PB")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Shortcut Dimension 12 Code_pb field.';
            }
            field("Shortcut Dimension 13 Code_PB"; Rec."Shortcut Dimension 13 Code_PB")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Shortcut Dimension 13 Code_pb field.';
            }
            field("Shortcut Dimension 14 Code_PB"; Rec."Shortcut Dimension 14 Code_PB")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Shortcut Dimension 14 Code_pb field.';
            }
            field("Shortcut Dimension 15 Code_PB"; Rec."Shortcut Dimension 15 Code_PB")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Shortcut Dimension 15 Code_pb field.';
            }
            field("Exported to Concur"; Rec."Exported to Concur")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Exported to Concur field.', Comment = '%';
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the External Document No. field.';
            }
            field("Record Type"; Rec."Record Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Record Type field.', Comment = '%';
            }
            //VJ#68
            field("Receipt image ID"; Rec."Receipt image ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Receipt image ID field.', Comment = '%';
            }
            //VJ#68
            //VT20-12-24 >>
            field("Concur ID"; Rec."Concur ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Concur ID field.', Comment = '%';
            }
            field("Entry Id"; Rec."Entry Id")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Entry Id field.', Comment = '%';
            }
            field("Report ID"; Rec."Report ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Report ID field.', Comment = '%';
            }
            field(ConfirmationResult; Rec.ConfirmationResult)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the ConfirmationResult field.', Comment = '%';
            }
            field(PaymentConfirmationResult; Rec.PaymentConfirmationResult)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PaymentConfirmationResult field.', Comment = '%';
            }
            //VT20-12-24 <<
            field("Employee Bank Account"; Rec."Employee Bank Account") //NT_ 13-02-2025
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Employee Bank Account field.';
            }
            field("Payment Confirmed in Concur"; Rec."Payment Confirmed in Concur")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Payment Confirmed in Concur field.', Comment = '%';
            }
        }
        addafter("Document No.")
        {
            field("Bank Document No."; Rec."Bank Document No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Bank Document No. field.';
            }
            field("Bank Document No. Applied"; Rec."Bank Document No. Applied")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Bank Document No Applied field.';
            }
        }
    }
    actions
    {
        addafter("F&unctions")
        {
            action(ConfirmationAPI)
            {
                ApplicationArea = all;
                Image = Confirm;
                Visible = false; //#329 TEC.VJ
                ToolTip = 'Executes the ConfirmationAPI action.';

                trigger OnAction()
                var
                    Concur: Codeunit "Concur Send Confirmation";
                begin
                    //Confur.GeneratePostingConfirmation2(Rec)
                    Concur.GetPostingConfirmation(Rec);
                end;
            }
            action(PaymentConfirmationAPI)
            {
                ApplicationArea = all;
                Image = Confirm;
                ToolTip = 'Executes the PaymentConfirmationAPI action.';

                trigger OnAction()
                var
                    Concur: Codeunit "Concur Send Payment Confir.";
                    ConcurApiSet: Record "Concur API Setup";
                begin
                    ConcurApiSet.Get();
                    //Confur.GeneratePostingPaymentConfirmation2(rec);
                    //Rec.TestField("Exported to Concur", false);//VJ22APR2025 //#372 VJ 18June2025 commented
                    Rec.TestField("Payment Confirmed in Concur", false); //#372 VJ 18June2025 added new check for payment confirmation Exported to Concur is used for confirmation only
                    //IF (Rec."Global Dimension 2 Code" <> 'CONCL') AND (Rec."Global Dimension 2 Code" <> 'CONCR') THEN
                    IF(Rec."Global Dimension 2 Code" <> ConcurApiSet."Default Concur Dimension") AND (Rec."Global Dimension 2 Code" <> ConcurApiSet."CL Default Concur Dim.")then //VJ 08052025 changed to pick from setup #329
 Error('%1 must be %2 or %3.', Rec.FieldCaption("Global Dimension 2 Code"), ConcurApiSet."Default Concur Dimension", ConcurApiSet."CL Default Concur Dim.");
                    //VJ 13062025 Ronald
                    if Rec."Shortcut Dimension 9 Code_PB" = 'CARD' then Error('Card entries can not send to Concur');
                    //VJ 13062025 Ronald
                    Concur.GetPostingPaymentConfirmation(Rec, false);
                end;
            }
            action(PaymentConfirmationRequestPreview)
            {
                ApplicationArea = all;
                Image = Confirm;
                ToolTip = 'Executes the PaymentConfirmationAPI to see json request';

                trigger OnAction()
                var
                    Concur: Codeunit "Concur Send Payment Confir.";
                    ConcurApiSet: Record "Concur API Setup";
                    PreviewRequest: Boolean;
                begin
                    //VJ 06082025 #390 Added button to see request preview
                    ConcurApiSet.Get();
                    //Confur.GeneratePostingPaymentConfirmation2(rec);
                    //Rec.TestField("Exported to Concur", false);//VJ22APR2025 //#372 VJ 18June2025 commented
                    Rec.TestField("Payment Confirmed in Concur", false); //#372 VJ 18June2025 added new check for payment confirmation Exported to Concur is used for confirmation only
                    //IF (Rec."Global Dimension 2 Code" <> 'CONCL') AND (Rec."Global Dimension 2 Code" <> 'CONCR') THEN
                    IF(Rec."Global Dimension 2 Code" <> ConcurApiSet."Default Concur Dimension") AND (Rec."Global Dimension 2 Code" <> ConcurApiSet."CL Default Concur Dim.")then //VJ 08052025 changed to pick from setup #329
 Error('%1 must be %2 or %3.', Rec.FieldCaption("Global Dimension 2 Code"), ConcurApiSet."Default Concur Dimension", ConcurApiSet."CL Default Concur Dim.");
                    //VJ 13062025 Ronald
                    if Rec."Shortcut Dimension 9 Code_PB" = 'CARD' then Error('Card entries can not send to Concur');
                    //VJ 13062025 Ronald
                    PreviewRequest:=true; //VJ 06082025 #390 Added button to see request preview
                    Concur.GetPostingPaymentConfirmation(Rec, PreviewRequest); //VJ 06082025 #390 Added button to see request preview
                end;
            }
            action(ConcurPostConfirmationAPI)
            {
                ApplicationArea = all;
                Image = Confirm;
                Caption = 'Post Cash Advance Confirmation';
                ToolTip = 'Executes the ConcurPostConfirmationAPI action.';

                trigger OnAction()
                var
                    Concur: Codeunit "Concur Post CA Confr.For Emp";
                begin
                    Concur.GetPostingConfirmation(Rec); //TEC.VJ 14MAY2025
                end;
            }
            action(OpenImage)
            {
                ApplicationArea = all;
                Image = Confirm;
                Caption = 'Open Image';
                ToolTip = 'Executes the Open Image action.';

                trigger OnAction()
                var
                    l_cdu_ConcurImageAPI: Codeunit "Concur Image API";
                begin
                    Clear(l_cdu_ConcurImageAPI);
                    l_cdu_ConcurImageAPI.GetExpenseImageUrl(Rec."Receipt image ID");
                end;
            }
        }
    }
    var myInt: Integer;
}
