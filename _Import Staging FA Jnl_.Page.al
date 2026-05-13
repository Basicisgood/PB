page 50109 "Import Staging FA Jnl"
{
    ApplicationArea = All;
    Caption = 'Import Staging FA Journal';
    PageType = List;
    SourceTable = "Import Staging";
    SourceTableView = where("Import Type"=const(FixedAsset));
    UsageCategory = Lists;
    // Editable = false;
    // DeleteAllowed = true;
    InsertAllowed = false;

    //ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Journal Template"; Rec."Journal Template")
                {
                    ToolTip = 'Specifies the value of the Journal Template field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Journal Batch"; Rec."Journal Batch")
                {
                    ToolTip = 'Specifies the value of the Journal Batch field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Batch Description"; Rec."Batch Description")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Company Code"; Rec."Company Code")
                {
                    ToolTip = 'Specifies the value of the Company Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ToolTip = 'Specifies the value of the Account Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("FA Posting Type"; Rec."FA Posting Type")
                {
                    ToolTip = 'Specifies the value of the FA Posting Type field.';
                    ApplicationArea = All;
                }
                field("Depreciation Book Code"; Rec."Depreciation Book Code")
                {
                    ToolTip = 'Specifies the value of the Depreciation Book Code field.';
                    ApplicationArea = All;
                }
                field("FA Posting Date"; Rec."FA Posting Date")
                {
                    ApplicationArea = All;
                }
                field("No. of Depreciation Days"; Rec."No. of Depreciation Days")
                {
                    ToolTip = 'Specifies the value of the No. of Depreciation Days field.';
                    ApplicationArea = All;
                }
                field("Salvage Value"; Rec."Salvage Value")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Amount LCY"; Rec."Amount LCY")
                {
                    ToolTip = 'Specifies the value of the Amount LCY field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("External Doc No."; Rec."External Doc No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Error Description"; Rec."Error Description")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1"; Rec."Global Dimension 1")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Global Dimension 2"; Rec."Global Dimension 2")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3"; Rec."Shortcut Dimension 3")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 4"; Rec."Shortcut Dimension 4")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 5"; Rec."Shortcut Dimension 5")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 5 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 6"; Rec."Shortcut Dimension 6")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 6 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 7"; Rec."Shortcut Dimension 7")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 7 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 8"; Rec."Shortcut Dimension 8")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 8 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 9"; Rec."Shortcut Dimension 9")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 9 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 10"; Rec."Shortcut Dimension 10")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 10 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 11"; Rec."Shortcut Dimension 11")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 10 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 12"; Rec."Shortcut Dimension 12")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 10 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Bal. Acc. Type"; Rec."Bal. Acc. Type")
                {
                    ToolTip = 'Specifies the value of the Bal. Account Type field.';
                    ApplicationArea = All;
                }
                field("Bal. Acc. No."; Rec."Bal. Acc. No.")
                {
                    ToolTip = 'Specifies the value of the Bal. Account No. field.';
                    ApplicationArea = All;
                }
                field("Import TimeStamp"; Rec."Import TimeStamp")
                {
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(test)
            {
                Caption = 'Import';
                Image = TestDatabase;
                // InFooterBar = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Import action.';

                trigger OnAction()
                var
                    ImportStagingFAGLfromExcel: Report "Import Staging FA from Excel";
                begin
                    ImportStagingFAGLfromExcel.Run();
                end;
            }
            action(Cancel)
            {
                Caption = 'Cancel';
                Image = Cancel;
                InFooterBar = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                ToolTip = 'Cancel the Line';

                trigger OnAction()
                var
                begin
                    rec.Status:=rec.Status::Cancel;
                    rec."Cancelled by User":=UserId;
                    rec."Cancelled Date time":=CurrentDateTime;
                    rec.Modify();
                end;
            }
            action(ProcessStagingData)
            {
                Caption = 'Process Staging Data';
                ApplicationArea = all;
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PostGLLinefromStaging: codeunit PostGLLinefromStaging;
                begin
                    PostGLLinefromStaging.FindOpenStagingEntries(Rec."Import Type");
                end;
            }
        }
    }
}
