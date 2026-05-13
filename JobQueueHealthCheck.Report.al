report 50124 JobQueueHealthCheck
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Company; Company)
        {
            RequestFilterFields = "Name";

            dataitem("Job Queue Entry"; "Job Queue Entry")
            {
                RequestFilterFields = "Object ID to Run";

                trigger OnPreDataItem()
                begin
                    "Job Queue Entry".ChangeCompany(Company.Name);
                end;
                trigger OnAfterGetRecord()
                var
                    l_bol_HasChange: Boolean;
                begin
                    l_bol_HasChange:=false;
                    IF "Job Queue Entry"."Starting Time" <> 0T THEN begin
                        IF "Job Queue Entry"."Object ID to Run" >= 50000 then begin
                            "Job Queue Entry"."Earliest Start Date/Time":=CREATEDATETIME(TODAY, "Job Queue Entry"."Starting Time");
                            l_bol_HasChange:=true;
                            IF "Job Queue Entry".Status <> "Job Queue Entry".Status::Ready Then begin
                                "Job Queue Entry".Status:="Job Queue Entry".Status::Ready;
                            end;
                        end;
                    END;
                    IF "Job Queue Entry".Status = "Job Queue Entry".Status::Error THEN begin
                        "Job Queue Entry".Status:="Job Queue Entry".Status::Ready;
                        l_bol_HasChange:=true;
                    end;
                    IF l_bol_HasChange then begin
                        "Job Queue Entry".MODIFY;
                    end;
                end;
            }
        }
    }
    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';

        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
                action(LayoutName)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    var myInt: Integer;
}
