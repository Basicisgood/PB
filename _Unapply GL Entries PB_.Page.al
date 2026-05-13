page 50198 "Unapply GL Entries PB"
{
    Caption = 'Unapply General Ledger Entries';
    DataCaptionExpression = Caption();
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    SourceTable = "Detailed G/L Entry PB";
    SourceTableTemporary = true;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field(DocuNo; DocNo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Document No.';
                    ToolTip = 'Specifies the document''s number.';
                }
                field(PostDate; PostingDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the entry''s Posting Date.';
                }
            }
            repeater(Lines)
            {
                Editable = false;
                ShowCaption = false;

                field("G/L Entry No."; Rec."G/L Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of G/L entry.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date when the posting of the unapply general ledger entries will be recorded.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the entry''s Document No.';
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the account that the entry has been posted to.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the amount of G/L entries.';
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Applied G/L Entry No."; Rec."Applied G/L Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of applied G/L entry.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the ID of the user associated with the entry.';

                    trigger OnDrillDown()
                    var
                        UserManagement: Codeunit "User Management";
                    begin
                        UserManagement.DisplayUserInformation(Rec."User ID");
                    end;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the entry number that is assigned to the entry.';
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(Unapply)
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Unapply';
                Image = UnApply;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Unselect one or more ledger entries that you want to unapply this record.';

                trigger OnAction()
                var
                    GLEntryPostApplicationCZA: Codeunit "G/L Entry -Post App PB";
                begin
                    if DetailedGLEntryCZA."Entry No." = 0 then Error(NothingToUnapplyErr);
                    GLEntryPostApplicationCZA.PostUnApplyGLEntry(DetailedGLEntryCZA, DocNo, PostingDate);
                    //>>
                    // Commit;
                    // PostAndDeleteExchangeBatch();
                    //<<
                    CurrPage.Close();
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        InsertEntries();
    end;
    procedure PostAndDeleteExchangeBatch()
    var
        GJL: Record "Gen. Journal Line";
        GPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        GJB: Record "Gen. Journal Batch";
    //Sgarg - Added
    begin
        GJL.Reset();
        GJL.SetRange("Journal Template Name", 'GENERAL');
        GJL.SetRange("Journal Batch Name", 'EXCHANGE');
        IF GJL.FindSet()then GPostBatch.Run(GJL);
        IF GJB.get('GENERAL', 'EXCHANGE')then GJB.Delete();
    end;
    var GLAccount: Record "G/L Account";
    DetailedGLEntryCZA: Record "Detailed G/L Entry PB";
    DocNo: Code[20];
    PostingDate: Date;
    NothingToUnapplyErr: Label 'There is nothing to unapply.';
    procedure SetDtldGLEntry(EntryNo: Integer)
    begin
        DetailedGLEntryCZA.Get(EntryNo);
        PostingDate:=DetailedGLEntryCZA."Posting Date";
        DocNo:=DetailedGLEntryCZA."Document No.";
    end;
    procedure InsertEntries()
    var
        SelectedDetailedGLEntryCZA: Record "Detailed G/L Entry PB";
    begin
        SelectedDetailedGLEntryCZA.SetCurrentKey("Entry No.");
        SelectedDetailedGLEntryCZA.SetRange("Transaction No.", DetailedGLEntryCZA."Transaction No.");
        SelectedDetailedGLEntryCZA.SetRange("G/L Account No.", DetailedGLEntryCZA."G/L Account No.");
        Rec.DeleteAll();
        if SelectedDetailedGLEntryCZA.FindSet()then repeat Rec:=SelectedDetailedGLEntryCZA;
                Rec.Insert();
            until SelectedDetailedGLEntryCZA.Next() = 0;
        GLAccount.Get(DetailedGLEntryCZA."G/L Account No.");
    end;
    procedure Caption(): Text var
        CaptionTok: Label '%1 %2 %3 %4', Locked = true;
    begin
        exit(StrSubstNo(CaptionTok, GLAccount."No.", GLAccount.Name, DetailedGLEntryCZA.FieldCaption("G/L Entry No."), DetailedGLEntryCZA."G/L Entry No."));
    end;
}
