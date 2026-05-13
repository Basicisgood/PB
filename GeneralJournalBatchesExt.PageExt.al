pageextension 50103 GeneralJournalBatchesExt extends "General Journal Batches"
{
    layout
    {
        addafter("Posting No. Series")
        {
            field("Payment Method Code"; Rec."Payment Method Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Payment Method Code field.', Comment = '%';
            }
            field("Bypass API"; Rec."Bypass API")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bypass API field.', Comment = '%';
            }
            field("Bank Transfer"; Rec."Bank Transfer")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bank Transfer field.', Comment = '%';
            }
            field(SendApprovalUser; Rec."Reviewer User")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Send Approval User field.';
            }
            field("Prepare User"; Rec."Prepare User")
            {
                ApplicationArea = All;
            }
            field("Approver A Grp User"; Rec."Approver A Grp User")
            {
                ApplicationArea = All;
            }
            field("Approver B Grp User"; Rec."Approver B Grp User")
            {
                ApplicationArea = All;
            }
            field("Review Status"; Rec."Review Status")
            {
                ApplicationArea = All;
            }
            field("Review Comments"; Rec."Review Comments")
            {
                ApplicationArea = ALL;
            }
            //TEC.VJ 17DEC2024>>
            field("No. of Pending"; Rec."No. of Pending")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the No. of Pending field.', Comment = '%';
            }
            field("No. of Approved"; Rec."No. of Approved")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the No. of Approved field.', Comment = '%';
            }
            field("No. of Rejected"; Rec."No. of Rejected")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the No. of Rejected field.', Comment = '%';
            }
            field("Total No."; Rec."Total No.")
            { //#188
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total No. field.', Comment = '%';
            }
            field("No Deletion After Post"; Rec."No Deletion After Post")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the No Deletion After Post field.', Comment = '%';
            //#280 VJ20032025
            }
            //TEC.VJ 17DEC2024<<
            //PS008 Start
            field("Value Date"; Rec."Value Date")
            {
                ApplicationArea = all;
            }
            //PS008 End
            //VT27122024 >>
            field("Export ifile"; Rec."Export ifile")
            {
                ApplicationArea = All;
            }
        //VT27122024 <<
        }
        addafter("No. Series")
        {
            field(Reviewed; Rec.Reviewed)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reviewed field.', Comment = '%';
            }
        }
    }
    actions
    {
        addafter("P&ost")
        {
            action("Refresh fields")
            {
                ApplicationArea = all;
                Caption = 'Refresh Status Counts';
                Image = Refresh;

                trigger OnAction()
                var
                    GenJnlBatch: Record "Gen. Journal Batch";
                    CommonFunc: Codeunit "Common Functions";
                begin
                    GenJnlBatch.Reset();
                    if GenJnlBatch.FindSet()then repeat CommonFunc.UpdateGenjnlBatchFieldsForHSBC_Citi(GenJnlBatch."Journal Template Name", GenJnlBatch.Name);
                        until GenJnlBatch.Next() = 0;
                end;
            }
        }
        addafter(EditJournal)
        {
            action("CreatenAssignbatch")
            {
                ApplicationArea = all;
                Caption = 'Create and assign No series';
                Image = Notes;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    GenJnlBatch: Record "Gen. Journal Batch";
                    CommonFunc: Codeunit "Common Functions";
                begin
                    Message('hi');
                end;
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean begin
        if StrLen(Rec.Name) > 7 then Error('Name Should be <=7 chars');
    end;
}
