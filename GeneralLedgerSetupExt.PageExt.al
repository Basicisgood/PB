pageextension 50104 GeneralLedgerSetupExt extends "General Ledger Setup"
{
    layout
    {
        addafter("Shortcut Dimension 8 Code")
        {
            field("Shortcut Dimension 9 Code"; Rec."Shortcut Dimension 9 Code")
            {
                ApplicationArea = Dimensions;
                Importance = Additional;
                ToolTip = 'Specifies the code for Shortcut Dimension 9, whose dimension values you can then enter directly on journals and sales or purchase lines.';
            }
            field("Shortcut Dimension 10 Code"; Rec."Shortcut Dimension 10 Code")
            {
                ApplicationArea = Dimensions;
                Importance = Additional;
                ToolTip = 'Specifies the code for Shortcut Dimension 10, whose dimension values you can then enter directly on journals and sales or purchase lines.';
            }
            field("Shortcut Dimension 11 Code"; Rec."Shortcut Dimension 11 Code")
            {
                ApplicationArea = Dimensions;
                Importance = Additional;
                ToolTip = 'Specifies the code for Shortcut Dimension 11, whose dimension values you can then enter directly on journals and sales or purchase lines.';
            }
            field("Shortcut Dimension 12 Code"; Rec."Shortcut Dimension 12 Code")
            {
                ApplicationArea = Dimensions;
                Importance = Additional;
                ToolTip = 'Specifies the code for Shortcut Dimension 12, whose dimension values you can then enter directly on journals and sales or purchase lines.';
            }
            field("Shortcut Dimension 13 Code"; Rec."Shortcut Dimension 13 Code")
            {
                ApplicationArea = Dimensions;
                Importance = Additional;
                ToolTip = 'Specifies the code for Shortcut Dimension 13, whose dimension values you can then enter directly on journals and sales or purchase lines.';
            }
            field("Shortcut Dimension 14 Code"; Rec."Shortcut Dimension 14 Code")
            {
                ApplicationArea = Dimensions;
                Importance = Additional;
                ToolTip = 'Specifies the code for Shortcut Dimension 14, whose dimension values you can then enter directly on journals and sales or purchase lines.';
            }
            field("Shortcut Dimension 15 Code"; Rec."Shortcut Dimension 15 Code")
            {
                ApplicationArea = Dimensions;
                Importance = Additional;
                ToolTip = 'Specifies the code for Shortcut Dimension 15, whose dimension values you can then enter directly on journals and sales or purchase lines.';
            }
        }
        addafter("Bank Account Nos.")
        {
            field("Bank Document Nos."; Rec."Bank Document Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bank Document Nos. field.', Comment = '%';
            }
            field("Elimination Rule No."; Rec."Elimination Rule No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Elimination Rule No. field.', Comment = '%';
            }
            field("Allocation Rule No. Series"; Rec."Allocation Rule No. Series")
            {
                ApplicationArea = All;
            }
            field("Payment Jnl Approver1 Limit"; Rec."Payment Jnl Approver1 Limit")
            {
                ApplicationArea = All;
            }
        }
        addafter(Application)
        {
            group("Source Code")
            {
                field("RIE Unappl. G/L Entries Appln"; Rec."RIE Unappl. G/L Entries Appln")
                {
                    ApplicationArea = all;
                }
            }
        }
        addafter("Background Posting")
        {
            //#252 TEC.VJ>>
            group(AutoPostJnls)
            {
                Caption = 'Bank API Setup';

                field("Auto Post Payment Jnl."; Rec."Auto Post Payment Jnl.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Auto Post Payment Jnl. field.', Comment = '%';
                }
                field("Auto Post Cash Rcpt."; Rec."Auto Post Cash Rcpt.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Auto Post Cash Rcpt. field.', Comment = '%';
                }
                field("Auto Post Return Payment Jnl."; Rec."Auto Post Return Payment Jnl.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Auto Post Return Payment Jnl. field.', Comment = '%';
                }
                field("Auto Post Bank Transfer"; Rec."Auto Post Bank Transfer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Auto Post Bank Transfer field.', Comment = '%';
                }
            }
        //#252 TEC.VJ<<
        }
    }
}
