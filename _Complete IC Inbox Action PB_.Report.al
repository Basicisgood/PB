report 50162 "Complete IC Inbox Action PB"
{
    Caption = 'Complete IC Inbox Action PB';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Permissions = tabledata "Handled IC Inbox Trans."=rm;

    dataset
    {
        dataitem("IC Inbox Transaction"; "IC Inbox Transaction")
        {
            DataItemTableView = sorting("Transaction No.", "IC Partner Code", "Transaction Source", "Document Type")where("IC Source Type"=const(Journal));
            RequestFilterFields = "IC Partner Code", "Transaction Source", "Line Action", "Transaction No.";

            dataitem("IC Inbox Jnl. Line"; "IC Inbox Jnl. Line")
            {
                DataItemLink = "Transaction No."=field("Transaction No."), "IC Partner Code"=field("IC Partner Code"), "Transaction Source"=field("Transaction Source");
                DataItemTableView = sorting("Transaction No.", "IC Partner Code", "Transaction Source", "Line No.");

                trigger OnAfterGetRecord()
                var
                    InboxJnlLine2: Record "IC Inbox Jnl. Line";
                    HandledInboxJnlLine: Record "Handled IC Inbox Jnl. Line";
                    inbtrans: page "IC Inbox Transactions";
                begin
                    InboxJnlLine2:="IC Inbox Jnl. Line";
                    case "IC Inbox Transaction"."Line Action" of "IC Inbox Transaction"."Line Action"::Accept: ICIOMgt.CreateJournalLines("IC Inbox Transaction", "IC Inbox Jnl. Line", TempGenJnlLine, GenJnlTemplate);
                    "IC Inbox Transaction"."Line Action"::"Return to IC Partner": if not Forward then begin
                            ICIOMgt.ForwardToOutBox("IC Inbox Transaction");
                            Forward:=true;
                        end;
                    "IC Inbox Transaction"."Line Action"::Cancel: begin
                        HandledInboxJnlLine.TransferFields(InboxJnlLine2);
                        HandledInboxJnlLine.Insert();
                    end;
                    end;
                    ICIOMgt.MoveICJnlDimToHandled(DATABASE::"IC Inbox Jnl. Line", DATABASE::"Handled IC Inbox Jnl. Line", "IC Inbox Transaction"."Transaction No.", "IC Inbox Transaction"."IC Partner Code", true, InboxJnlLine2."Line No.");
                    InboxJnlLine2.Delete(true);
                end;
                trigger OnPostDataItem()
                var
                    GenJnlLine: Record "Gen. Journal Line";
                    GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
                    HandledInboxTransaction: Record "Handled IC Inbox Trans.";
                    CU12: Codeunit 12;
                begin
                //TempGenJnlLine."Document No." := IncStr(TempGenJnlLine."Document No.");
                end;
                //Sgarg- Added >>
                trigger OnPreDataItem()
                var
                    GenJnlLine: Record "Gen. Journal Line";
                    NoSeries: Codeunit "No. Series";
                begin
                    if not ICSetup.Get()then exit;
                    TempGenJnlLine."Journal Template Name":=ICSetup."Default IC Gen. Jnl. Template";
                    TempGenJnlLine."Journal Batch Name":=ICSetup."Default IC Gen. Jnl. Batch";
                    TempGenJnlLine."Document No.":='';
                    GenJnlLine.SetRange("Journal Template Name", TempGenJnlLine."Journal Template Name");
                    GenJnlLine.SetRange("Journal Batch Name", TempGenJnlLine."Journal Batch Name");
                    GenJnlLine.LockTable();
                    if GenJnlLine.FindLast()then begin
                        TempGenJnlLine."Document No.":=IncStr(GenJnlLine."Document No.");
                        TempGenJnlLine."Line No.":=GenJnlLine."Line No.";
                    end
                    else if GenJnlBatch.Get(TempGenJnlLine."Journal Template Name", TempGenJnlLine."Journal Batch Name")then if GenJnlBatch."No. Series" = '' then TempGenJnlLine."Document No.":=''
                            else
                                TempGenJnlLine."Document No.":=NoSeries.PeekNextNo(GenJnlBatch."No. Series", TempGenJnlLine."Posting Date");
                end;
            //Sgarg- Added <<
            }
            trigger OnAfterGetRecord()
            var
                InboxTransaction2: Record "IC Inbox Transaction";
                HandledInboxTransaction2: Record "Handled IC Inbox Trans.";
                ICCommentLine: Record "IC Comment Line";
                ICPartner: Record "IC Partner";
                ICsetup: Record "IC Setup";
            begin
                ICsetup.GET;
                if "Line Action" = "Line Action"::"No Action" then CurrReport.Skip();
                InboxTransaction2:="IC Inbox Transaction";
                if("IC Source Type" = "IC Source Type"::Journal) and (InboxTransaction2."Line Action" <> InboxTransaction2."Line Action"::Cancel) and (InboxTransaction2."Line Action" <> InboxTransaction2."Line Action"::"Return to IC Partner")then begin
                    TempGenJnlLine."Journal Template Name":=ICSetup."Default IC Gen. Jnl. Template";
                    TempGenJnlLine."Journal Batch Name":=ICSetup."Default IC Gen. Jnl. Batch";
                    TempGenJnlLine.TestField("Journal Template Name");
                    TempGenJnlLine.TestField("Journal Batch Name");
                end;
                if(InboxTransaction2."Line Action" <> InboxTransaction2."Line Action"::Cancel) and ICPartner.Get(InboxTransaction2."IC Partner Code")then ICPartner.TestField(Blocked, false);
                HandledInboxTransaction2.TransferFields(InboxTransaction2);
                case InboxTransaction2."Line Action" of InboxTransaction2."Line Action"::Accept: HandledInboxTransaction2.Status:=HandledInboxTransaction2.Status::Accepted;
                InboxTransaction2."Line Action"::"Return to IC Partner": HandledInboxTransaction2.Status:=HandledInboxTransaction2.Status::"Returned to IC Partner";
                InboxTransaction2."Line Action"::Cancel: HandledInboxTransaction2.Status:=HandledInboxTransaction2.Status::Cancelled;
                end;
                if not HandledInboxTransaction2.Insert()then Error(Text001, InboxTransaction2.FieldCaption("Transaction No."), InboxTransaction2."Transaction No.", InboxTransaction2."IC Partner Code", HandledInboxTransaction2.TableCaption());
                InboxTransaction2.Delete();
                ICIOMgt.HandleICComments(ICCommentLine."Table Name"::"IC Inbox Transaction", ICCommentLine."Table Name"::"Handled IC Inbox Transaction", "Transaction No.", "IC Partner Code", "Transaction Source");
                Forward:=false;
            end;
            trigger OnPostDataItem()
            var
                HandledIC: Record "Handled IC Inbox Trans.";
                HandledIC2: Record "Handled IC Inbox Trans.";
                GJL: Record "Gen. Journal Line";
                ICsetup: Record "IC Setup";
                GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
                CU50190: Codeunit 50190;
            begin
                Commit();
                ICsetup.get;
                HandledIC.Reset();
                HandledIC.SetRange("IC Source Type", HandledIC."IC Source Type"::Journal);
                HandledIC.SetRange(Status, HandledIC.Status::Accepted);
                IF HandledIC.FindFirst()then repeat GJL.reset;
                        GJL.SetRange("Journal Template Name", ICsetup."Default IC Gen. Jnl. Template");
                        GJL.SetRange("Journal Batch Name", ICsetup."Default IC Gen. Jnl. Batch");
                        GJL.SetRange("IC Partner Transaction No.", HandledIC."Transaction No.");
                        IF GJL.FindSet()then begin
                            ClearLastError();
                            clear(CU50190);
                            //IF NOT GuiAllowed then
                            //IF NOT GenJnlPostBatch.RUN(GJL) then begin
                            IF NOT CU50190.Run(GJL)then begin
                                HandledIC2.GET(HandledIC."Transaction No.", HandledIC."IC Partner Code", HandledIC."Transaction Source", HandledIC."Document Type");
                                HandledIC2."Error Msg":=GetLastErrorText();
                                HandledIC2.Modify();
                            end;
                        end;
                        commit;
                    until HandledIC.Next() = 0;
            end;
        }
    }
    var GenJnlTemplate: Record "Gen. Journal Template";
    GenJnlBatch: Record "Gen. Journal Batch";
    GLSetup: Record "General Ledger Setup";
    ICIOMgt: Codeunit ICInboxOutboxMgt;
    DimMgt: Codeunit DimensionManagement;
    GLSetupFound: Boolean;
    Forward: Boolean;
    Text001: Label '%1 %2 from IC Partner %3 already exists in the %4 window. You have to delete %1 %2 in the %4 window before you complete the line action.';
    DocPostingDateEditable: Boolean;
    PostingDateEditable: Boolean;
    ICSetup: Record "IC Setup";
    TempGenJnlLine: Record "Gen. Journal Line" temporary;
    ReplacePostingDate: Boolean;
    ReplaceDocPostingDate: Boolean;
    DocPostingDate: Date;
    PostingError: Boolean;
    CU12: Codeunit 12;
}
