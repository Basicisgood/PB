pageextension 50129 "Purchase Journal Ext." extends "Purchase Journal"
{
    layout
    {
        addafter("Bal. Account No.")
        {
            field("Invoice Link"; Rec."Invoice Link")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Invoice Link field.', Comment = '%';
            }
            field("Ship Manager Id"; Rec."Ship Manager Id")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Ship Manager Id field.', Comment = '%';
            }
        }
        addafter(ShortcutDimCode8)
        {
            field("Shortcut Dimension 9 Code"; Rec."Shortcut Dimension 9 Code")
            {
                ApplicationArea = all;
            }
            field("Shortcut Dimension 10 Code"; Rec."Shortcut Dimension 10 Code")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("Apply Entries")
        {
            action("Apply Entries 2")
            {
                ApplicationArea = all;
                Caption = 'Global Apply Entries';
                PromotedCategory = Process;
                Promoted = true;
                Ellipsis = true;
                Image = ApplyEntries;
                RunObject = Codeunit "Global Gen. Jnl.-Apply";
                ShortCutKey = 'Shift+F11';
                ToolTip = 'Apply the payment amount on a journal line to a sales or purchase document that was already posted for a customer or vendor. This updates the amount on the posted document, and the document can either be partially paid, or closed as paid or refunded.';
            }
        }
    }
}
