page 50110 "Import Staging IC GLLine"
{
    ApplicationArea = All;
    Caption = 'Import Staging Intercompany General Journal';
    PageType = List;
    SourceTable = "Import Staging";
    SourceTableView = where("Import Type"=const(ICJournal));
    UsageCategory = Lists;

    // Editable = false;
    // DeleteAllowed = true;
    //InsertAllowed = false;
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
                    applicationarea = all;
                }
                field("Journal Template"; Rec."Journal Template")
                {
                    ToolTip = 'Specifies the value of the Journal Template field.', Comment = '%';
                    applicationarea = all;
                }
                field("Journal Batch"; Rec."Journal Batch")
                {
                    ToolTip = 'Specifies the value of the Journal Batch field.', Comment = '%';
                    applicationarea = all;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                    applicationarea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                    applicationarea = all;
                }
                field("Company Code"; Rec."Company Code")
                {
                    ToolTip = 'Specifies the value of the Company Code field.', Comment = '%';
                    applicationarea = all;
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.', Comment = '%';
                    applicationarea = all;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ToolTip = 'Specifies the value of the Account Type field.', Comment = '%';
                    applicationarea = all;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                    applicationarea = all;
                }
                field("Amount LCY"; Rec."Amount LCY")
                {
                    ToolTip = 'Specifies the value of the Amount LCY field.', Comment = '%';
                    applicationarea = all;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field.', Comment = '%';
                    applicationarea = all;
                }
                field("PB IC Account Type"; Rec."PB IC Account Type")
                {
                    ApplicationArea = All;
                }
                field("PB IC Account No."; Rec."PB IC Account No.")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    applicationarea = all;
                }
                field("Error Description"; Rec."Error Description")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1"; Rec."Global Dimension 1")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 field.', Comment = '%';
                    applicationarea = all;
                }
                field("Global Dimension 2"; Rec."Global Dimension 2")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 field.', Comment = '%';
                    applicationarea = all;
                }
                field("Shortcut Dimension 3"; Rec."Shortcut Dimension 3")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 field.', Comment = '%';
                    applicationarea = all;
                }
                field("Shortcut Dimension 4"; Rec."Shortcut Dimension 4")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 field.', Comment = '%';
                    applicationarea = all;
                }
                field("Shortcut Dimension 5"; Rec."Shortcut Dimension 5")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 5 field.', Comment = '%';
                    applicationarea = all;
                }
                field("Shortcut Dimension 6"; Rec."Shortcut Dimension 6")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 6 field.', Comment = '%';
                    applicationarea = all;
                }
                field("Shortcut Dimension 7"; Rec."Shortcut Dimension 7")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 7 field.', Comment = '%';
                    applicationarea = all;
                }
                field("Shortcut Dimension 8"; Rec."Shortcut Dimension 8")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 8 field.', Comment = '%';
                    applicationarea = all;
                }
                field("Shortcut Dimension 9"; Rec."Shortcut Dimension 9")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 9 field.', Comment = '%';
                    applicationarea = all;
                }
                field("Shortcut Dimension 10"; Rec."Shortcut Dimension 10")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 10 field.', Comment = '%';
                    applicationarea = all;
                }
                field("Shortcut Dimension 11"; Rec."Shortcut Dimension 11")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 10 field.', Comment = '%';
                    applicationarea = all;
                }
                field("Shortcut Dimension 12"; Rec."Shortcut Dimension 12")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 10 field.', Comment = '%';
                    applicationarea = all;
                }
                field("IC Global Dimension 1"; Rec."IC Global Dimension 1")
                {
                    ApplicationArea = All;
                }
                field("IC Global Dimension 2"; Rec."IC Global Dimension 2")
                {
                    ApplicationArea = All;
                }
                field("IC Shortcut Dimension 3"; Rec."IC Shortcut Dimension 3")
                {
                    ApplicationArea = All;
                }
                field("IC Shortcut Dimension 4"; Rec."IC Shortcut Dimension 4")
                {
                    ApplicationArea = All;
                }
                field("IC Shortcut Dimension 5"; Rec."IC Shortcut Dimension 5")
                {
                    ApplicationArea = All;
                }
                field("IC Shortcut Dimension 6"; Rec."IC Shortcut Dimension 6")
                {
                    ApplicationArea = All;
                }
                field("IC Shortcut Dimension 7"; Rec."IC Shortcut Dimension 7")
                {
                    ApplicationArea = All;
                }
                field("IC Shortcut Dimension 8"; Rec."IC Shortcut Dimension 8")
                {
                    ApplicationArea = All;
                }
                field("IC Shortcut Dimension 9"; Rec."IC Shortcut Dimension 9")
                {
                    ApplicationArea = All;
                }
                field("IC Shortcut Dimension 10"; Rec."IC Shortcut Dimension 10")
                {
                    ApplicationArea = All;
                }
                field("IC Shortcut Dimension 11"; Rec."IC Shortcut Dimension 11")
                {
                    ApplicationArea = All;
                }
                field("IC Shortcut Dimension 12"; Rec."IC Shortcut Dimension 12")
                {
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
                    ImportStagingICGLfromExcel: Report "Import Staging ICGL from Excel";
                begin
                    // StagingTable.DeleteAll();
                    ImportStagingICGLfromExcel.Run();
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
