pageextension 50116 "CashReceiptJournal_Ext" extends "Cash Receipt Journal"
{
    layout
    {
        addafter(Amount)
        {
            field("Over Receipt"; Rec."Over Receipt")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Over Receipt field.', Comment = '%';
            }
        }
        addafter(ShortcutDimCode8)
        {
            field("Shortcut Dimension 9 Code"; Rec."Shortcut Dimension 9 Code")
            {
                ApplicationArea = Dimensions;
                ToolTip = 'Specifies the code for Shortcut Dimension 9, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
            //Visible = false;
            }
            field("Shortcut Dimension 10 Code"; Rec."Shortcut Dimension 10 Code")
            {
                ApplicationArea = Dimensions;
                ToolTip = 'Specifies the code for Shortcut Dimension 10, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
            //Visible = false;
            }
            field("Shortcut Dimension 11 Code"; Rec."Shortcut Dimension 11 Code")
            {
                ApplicationArea = Dimensions;
                ToolTip = 'Specifies the code for Shortcut Dimension 11, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                Visible = false;
            }
            field("Shortcut Dimension 12 Code"; Rec."Shortcut Dimension 12 Code")
            {
                ApplicationArea = Dimensions;
                ToolTip = 'Specifies the code for Shortcut Dimension 12, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                Visible = false;
            }
            field("Shortcut Dimension 13 Code"; Rec."Shortcut Dimension 13 Code")
            {
                ApplicationArea = Dimensions;
                ToolTip = 'Specifies the code for Shortcut Dimension 13, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                Visible = false;
            }
            field("Shortcut Dimension 14 Code"; Rec."Shortcut Dimension 14 Code")
            {
                ApplicationArea = Dimensions;
                ToolTip = 'Specifies the code for Shortcut Dimension 14, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                Visible = false;
            }
            field("Shortcut Dimension 15 Code"; Rec."Shortcut Dimension 15 Code")
            {
                ApplicationArea = Dimensions;
                ToolTip = 'Specifies the code for Shortcut Dimension 15, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                Visible = false;
            }
        }
    }
    actions
    {
        modify("Apply Entries")
        {
            Visible = false;
        }
        addafter("Apply Entries")
        {
            action(GlobalApplyEntries)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Global Apply Entries';
                Ellipsis = true;
                Image = ApplyEntries;
                RunObject = Codeunit "Global Gen. Jnl.-Apply";
                ShortCutKey = 'Shift+F11';
                ToolTip = 'Apply the payment amount on a journal line to a sales or purchase document that was already posted for a customer or vendor. This updates the amount on the posted document, and the document can either be partially paid, or closed as paid or refunded.';
            }
        }
    }
    var GenJnlManagement: Codeunit GenJnlManagement;
    JournalModifyError: Label 'Journal can not be modified when Review Status is %1';
    LastGenJnlBatch: Code[10];
    ApprovalMgmt: Codeunit "Approvals Mgmt.";
    GenJnlBatchApprovalStatus: Text[20];
    EnabledGenJnlBatchWorkflowsExist: Boolean;
    WorkflowManagement: Codeunit "Workflow Management";
    WorkflowEventHandling: Codeunit "Workflow Event Handling";
}
