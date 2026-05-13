page 50107 "Import Staging GL Line"
{
    ApplicationArea = All;
    Caption = 'Import Staging General Journal';
    PageType = List;
    SourceTable = "Import Staging";
    SourceTableView = where("Import Type"=const(GenJournal));
    UsageCategory = Lists;
    // Editable = false;
    DeleteAllowed = true;

    //InsertAllowed = false;
    // ModifyAllowed = false;
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
                field("Document Type"; Rec."Document Type")
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
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("External Doc No."; Rec."External Doc No.")
                {
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
                field(Description; Rec.Description)
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
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field.', Comment = '%';
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
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Error Description"; Rec."Error Description")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Error Description field.';
                }
                field("Cancelled by User"; Rec."Cancelled by User")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cancelled by User field.';
                }
                field("Cancelled Date time"; Rec."Cancelled Date time")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cancelled Date time field.';
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
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 field.';
                }
                field("Shortcut Dimension 4"; Rec."Shortcut Dimension 4")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 field.';
                }
                field("Shortcut Dimension 5"; Rec."Shortcut Dimension 5")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 5 field.';
                }
                field("Shortcut Dimension 6"; Rec."Shortcut Dimension 6")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 6 field.';
                }
                field("Shortcut Dimension 7"; Rec."Shortcut Dimension 7")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 7 field.';
                }
                field("Shortcut Dimension 8"; Rec."Shortcut Dimension 8")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 8 field.';
                }
                field("Shortcut Dimension 9"; Rec."Shortcut Dimension 9")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 9 field.';
                }
                field("Shortcut Dimension 10"; Rec."Shortcut Dimension 10")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 10 field.';
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
            action(Import)
            {
                Caption = 'Import';
                Image = Import;
                InFooterBar = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Import action.';

                trigger OnAction()
                var
                    ImportStagingGLfromExcel: Report "Import Staging GL from Excel";
                begin
                    // StagingTable.DeleteAll();
                    ImportStagingGLfromExcel.Run();
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
