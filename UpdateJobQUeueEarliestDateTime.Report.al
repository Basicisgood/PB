report 50125 UpdateJobQUeueEarliestDateTime
{
    Caption = 'UpdateJobQUeueEarliestDateTime';
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(l_dt_EarliestDateTime; l_dt_EarliestDateTime)
                    {
                        ApplicationArea = all;
                    }
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    procedure passinParamter(CompName: Text; SysID: Text)
    var
    begin
        l_txt_CompanyName:=CompName;
        l_txt_SystemID:=SysID;
    end;
    trigger OnPostReport()
    var
        l_Rec_JobQueue: Record "Job Queue Entry";
    begin
        l_Rec_JobQueue.RESET;
        l_Rec_JobQueue.ChangeCompany(l_txt_CompanyName);
        l_Rec_JobQueue.SETRANGE(SystemId, l_txt_SystemID);
        IF l_Rec_JobQueue.FINDSET THEN begin
            l_Rec_JobQueue."Earliest Start Date/Time":=l_dt_EarliestDateTime;
            l_Rec_JobQueue.MODIFY;
            l_bol_SuccessfulRun:=TRUE;
        end;
    end;
    procedure GetEarliestDateTime(): DateTime begin
        exit(l_dt_EarliestDateTime);
    end;
    procedure GetSuccessful(): Boolean begin
        EXIT(l_bol_SuccessfulRun);
    end;
    var l_dt_EarliestDateTime: Datetime;
    l_bol_SuccessfulRun: Boolean;
    l_txt_CompanyName: Text;
    l_txt_SystemID: Text;
}
