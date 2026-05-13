page 50264 GlobalJobQueueListEntryHist
{
    ApplicationArea = All;
    Caption = 'GlobalJobQueueListEntryHist';
    PageType = List;
    SourceTable = "Job Queue Log Entry";
    SourceTableTemporary = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the status of the running of the job queue entry in a log.';
                    ApplicationArea = All;
                }
                field("Start Date/Time"; Rec."Start Date/Time")
                {
                    ToolTip = 'Specifies the date and time when the job was started.';
                    ApplicationArea = All;
                }
                field("End Date/Time"; Rec."End Date/Time")
                {
                    ToolTip = 'Specifies the date and time when the job ended.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies a description of the job queue entry in the log.';
                    ApplicationArea = All;
                }
                field("Error Message"; Rec."Error Message")
                {
                    ToolTip = 'Specifies an error that occurred in the job queue.';
                    ApplicationArea = All;
                }
                field("Object ID to Run"; Rec."Object ID to Run")
                {
                    ToolTip = 'Specifies the ID of the object that is to be run for the job.';
                    ApplicationArea = All;
                }
                field("Parameter String"; Rec."Parameter String")
                {
                    ToolTip = 'Specifies the parameter string of the corresponding job.';
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        myInt: Integer;
        l_Rec_JobQueueLogEntry: Record "Job Queue Log Entry";
        l_Rec_JobQueueEntry: Record "Job Queue Entry";
    begin
        ;
        l_Rec_JobQueueLogEntry.RESET;
        l_Rec_JobQueueLogEntry.ChangeCompany(g_txt_CompName);
        l_Rec_JobQueueLogEntry.SETRANGE(SystemID, g_txt_SystemID);
        l_Rec_JobQueueLogEntry.SETFILTER("Start Date/Time", '>=%1', CreateDateTime(g_dat_StartDate, 0T));
        IF l_Rec_JobQueueLogEntry.FINDSET THEN repeat Rec.REset;
                REc.init;
                REc:=l_Rec_JobQueueLogEntry;
                Rec.INSERT;
            UNTIL l_Rec_JobQueueLogEntry.NEXT = 0;
    end;
    procedure fn_Passparameter(SystemID: Text; CompName: Text; StartDate: Date)
    begin
        g_txt_SystemID:=SystemID;
        g_txt_CompName:=CompName;
        g_dat_StartDate:=StartDate;
    end;
    var g_txt_SystemID: Text;
    g_txt_CompName: text;
    g_dat_StartDate: Date;
}
