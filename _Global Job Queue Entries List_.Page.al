page 50263 "Global Job Queue Entries List"
{
    ApplicationArea = All;
    Caption = 'Global Job Queue Entries List';
    PageType = List;
    SourceTable = "Job Queue Entry";
    Permissions = tabledata "Job Queue Entry"=m;
    SourceTableTemporary = true;
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Error Message"; Rec."Error Message")
                {
                    Caption = 'Company Code';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies a description of the job queue entry. You can edit and update the description on the job queue entry card. The description is also displayed in the Job Queue Entries window, but it cannot be updated there.';
                    ApplicationArea = All;
                }
                field("Parameter String"; Rec."Parameter String")
                {
                    ApplicationArea = All;
                }
                field("Starting Time"; Rec."Starting Time")
                {
                    ApplicationArea = All;
                }
                field("Ending Time"; Rec."Ending Time")
                {
                    ToolTip = 'Specifies the latest time of the day that the recurring job queue entry is to be run.';
                    ApplicationArea = All;
                }
                field("Object ID to Run"; Rec."Object ID to Run")
                {
                    ApplicationArea = All;
                }
                field("Object Type to Run"; Rec."Object Type to Run")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Earliest Start Date/Time"; Rec."Earliest Start Date/Time")
                {
                    ToolTip = 'Specifies the earliest date and time when the job queue entry should be run.  The format for the date and time must be month/day/year hour:minute, and then AM or PM. For example, 3/10/2021 12:00 AM.';
                    ApplicationArea = All;
                }
                field("Run on Mondays"; Rec."Run on Mondays")
                {
                    ApplicationArea = All;
                }
                field("Run on Tuesdays"; Rec."Run on Tuesdays")
                {
                    ApplicationArea = All;
                }
                field("Run on Wednesdays"; Rec."Run on Wednesdays")
                {
                    ApplicationArea = All;
                }
                field("Run on Thursdays"; Rec."Run on Thursdays")
                {
                    ApplicationArea = All;
                }
                field("Run on Fridays"; Rec."Run on Fridays")
                {
                    ApplicationArea = All;
                }
                field("Run on Saturdays"; Rec."Run on Saturdays")
                {
                    ApplicationArea = All;
                }
                field("Run on Sundays"; Rec."Run on Sundays")
                {
                    ApplicationArea = All;
                }
                field("No. of Minutes between Runs"; Rec."No. of Minutes between Runs")
                {
                    ApplicationArea = All;
                }
                field("No. of Attempts to Run"; Rec."No. of Attempts to Run")
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
            action(SetToReady)
            {
                Caption = 'Set to Ready';
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    UpdateData(1);
                end;
            }
            action(SetOnhold)
            {
                Caption = 'Set to OnHold';
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    UpdateData(2);
                end;
            }
            action(BatchRefreshHealthcheck)
            {
                Caption = 'Batch Refresh Health Check';
                ToolTip = 'For lines that have starting time and Object ID >= 50000 only';
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Report.Run(50124);
                end;
            }
            Action(Last7DaysLog)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    l_pag_GlobalJobQueueLogEntry: page GlobalJobQueueListEntryHist;
                begin
                    CLEAR(l_pag_GlobalJobQueueLogEntry);
                    l_pag_GlobalJobQueueLogEntry.fn_Passparameter(Rec.SystemID, Rec."Error Message", CALCDATE('<-7D>', TODAY));
                    l_pag_GlobalJobQueueLogEntry.Run();
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
        l_rec_Company: Record Company;
        l_rec_JobQueueEntries: Record "Job Queue Entry";
        l_pag_JobQueueEntries: Page "Job Queue Entries";
        l_txt_GUID: Text;
    begin
        l_rec_Company.RESET;
        IF l_rec_Company.FIND('-')THEN repeat l_rec_JobQueueEntries.RESET;
                l_rec_JobQueueEntries.ChangeCompany(l_rec_Company.Name);
                IF l_rec_JobQueueEntries.FINDSET THEN REPEAT Rec.RESET;
                        Rec.INIT;
                        REc:=l_rec_JobQueueEntries;
                        Rec."Error Message":=l_rec_Company.Name;
                        REC.ID:=CREATEGUID();
                        Rec.INSERT;
                    UNTIL l_rec_JobQueueEntries.NEXT = 0;
            until l_rec_Company.NEXT = 0;
    end;
    trigger OnModifyRecord(): Boolean begin
        UpdateData(0);
    end;
    procedure UpdateData(UpdateStatus: integer)
    var
        l_rec_JobQueueEntries: Record "Job Queue Entry";
    begin
        l_rec_JobQueueEntries.RESET;
        l_rec_JobQueueEntries.SETRANGE(SystemId, Rec.SystemId);
        l_rec_JobQueueEntries.ChangeCompany(Rec."Error Message");
        IF l_rec_JobQueueEntries.FINDSET THEN begin
            CASE UpdateStatus of 1: l_rec_JobQueueEntries.Status:=l_rec_JobQueueEntries.Status::Ready;
            2: l_rec_JobQueueEntries.Status:=l_rec_JobQueueEntries.Status::"On Hold";
            END;
            IF l_rec_JobQueueEntries."Earliest Start Date/Time" <> Rec."Earliest Start Date/Time" THEN l_rec_JobQueueEntries."Earliest Start Date/Time":=Rec."Earliest Start Date/Time";
            IF l_rec_JobQueueEntries.Status <> Rec.Status then l_rec_JobQueueEntries.Status:=Rec.Status;
            IF l_rec_JobQueueEntries."Starting Time" <> Rec."Starting Time" then l_rec_JobQueueEntries."Starting Time":=Rec."Starting Time";
            l_rec_JobQueueEntries."Run on Fridays":=Rec."Run on Fridays";
            l_rec_JobQueueEntries."Run on Mondays":=Rec."Run on Mondays";
            l_rec_JobQueueEntries."Run on Saturdays":=Rec."Run on Saturdays";
            l_rec_JobQueueEntries."Run on Sundays":=Rec."Run on Sundays";
            l_rec_JobQueueEntries."Run on Thursdays":=Rec."Run on Thursdays";
            l_rec_JobQueueEntries."Run on Tuesdays":=Rec."Run on Tuesdays";
            l_rec_JobQueueEntries."Run on Wednesdays":=Rec."Run on Wednesdays";
            l_rec_JobQueueEntries."No. of Attempts to Run":=Rec."No. of Attempts to Run";
            l_rec_JobQueueEntries."No. of Minutes between Runs":=Rec."No. of Minutes between Runs";
            l_rec_JobQueueEntries.MODIFY;
        end;
        CASE UpdateStatus of 1: Rec.Status:=Rec.Status::Ready;
        2: Rec.Status:=Rec.Status::"On Hold";
        END;
        Rec.MODIFY;
    end;
}
