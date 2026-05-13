tableextension 50104 "GLSetupExt " extends "General Ledger Setup"
{
    fields
    {
        field(50001; "Shortcut Dimension 9 Code"; Code[20])
        {
            AccessByPermission = TableData "Dimension Combination"=R;
            Caption = 'Shortcut Dimension 9 Code';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                UpdateDimValueGlobalDimNo(xRec."Shortcut Dimension 9 Code", "Shortcut Dimension 9 Code", 9);
            end;
        }
        field(50002; "Shortcut Dimension 10 Code"; Code[20])
        {
            AccessByPermission = TableData "Dimension Combination"=R;
            Caption = 'Shortcut Dimension 10 Code';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                UpdateDimValueGlobalDimNo(xRec."Shortcut Dimension 10 Code", "Shortcut Dimension 10 Code", 10);
            end;
        }
        field(50003; "Shortcut Dimension 11 Code"; Code[20])
        {
            AccessByPermission = TableData "Dimension Combination"=R;
            Caption = 'Shortcut Dimension 11 Code';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                UpdateDimValueGlobalDimNo(xRec."Shortcut Dimension 11 Code", "Shortcut Dimension 11 Code", 11);
            end;
        }
        field(50004; "Shortcut Dimension 12 Code"; Code[20])
        {
            AccessByPermission = TableData "Dimension Combination"=R;
            Caption = 'Shortcut Dimension 12 Code';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                UpdateDimValueGlobalDimNo(xRec."Shortcut Dimension 12 Code", "Shortcut Dimension 12 Code", 12);
            end;
        }
        field(50005; "Shortcut Dimension 13 Code"; Code[20])
        {
            AccessByPermission = TableData "Dimension Combination"=R;
            Caption = 'Shortcut Dimension 13 Code';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                UpdateDimValueGlobalDimNo(xRec."Shortcut Dimension 13 Code", "Shortcut Dimension 13 Code", 13);
            end;
        }
        field(50006; "Shortcut Dimension 14 Code"; Code[20])
        {
            AccessByPermission = TableData "Dimension Combination"=R;
            Caption = 'Shortcut Dimension 14 Code';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                UpdateDimValueGlobalDimNo(xRec."Shortcut Dimension 14 Code", "Shortcut Dimension 14 Code", 14);
            end;
        }
        field(50007; "Shortcut Dimension 15 Code"; Code[20])
        {
            AccessByPermission = TableData "Dimension Combination"=R;
            Caption = 'Shortcut Dimension 15 Code';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                UpdateDimValueGlobalDimNo(xRec."Shortcut Dimension 15 Code", "Shortcut Dimension 15 Code", 15);
            end;
        }
        field(50012; "Elimination Rule No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50013; "RIE Unappl. G/L Entries Appln"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Source Code";
            Caption = 'Unapplied G/L Entries Appln';
        }
        //#001 <<
        field(50014; "Allocation Rule No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        //#001 >>
        field(50015; "Payment Jnl Approver1 Limit"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Journal Approver1 Limit';
        }
        //VJ#47 12DEC2024 Start
        field(50016; "Bank Document Nos."; Code[20])
        {
            //AccessByPermission = TableData "Bank Account" = R;
            Caption = 'Bank Document Nos.';
            TableRelation = "No. Series";
        }
        //VJ#47 12DEC2024 End
        //#252 TEC.VJ>>
        field(50017; "Auto Post Cash Rcpt."; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50018; "Auto Post Payment Jnl."; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50019; "Auto Post Return Payment Jnl."; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50020; "Auto Post Bank Transfer"; Boolean) //TEC.VJ 22APR2025
        {
            DataClassification = ToBeClassified;
        }
    }
}
