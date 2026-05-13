page 50134 "Crew Member Inbound List"
{
    ApplicationArea = All;
    Caption = 'Crew Member Inbound List';
    PageType = List;
    SourceTable = "PB Crew Member Inbound";
    UsageCategory = Lists;

    //Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = All;
                }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = All;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ApplicationArea = All;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                }
                field("Area"; Rec."Area")
                {
                    ApplicationArea = All;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ApplicationArea = All;
                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Termination Date"; Rec."Termination Date")
                {
                    ApplicationArea = All;
                }
                field("API Status"; Rec."API Status")
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Error Description"; Rec."Error Description")
                {
                    ToolTip = 'Specifies the value of the Error Description field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Cancelled by User"; Rec."Cancelled by User")
                {
                    ToolTip = 'Specifies the value of the Cancelled by User field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Cancelled Date time"; Rec."Cancelled Date time")
                {
                    ToolTip = 'Specifies the value of the Cancelled Date time field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Create Employee")
            {
                ApplicationArea = All;
                Visible = false;

                trigger OnAction()
                var
                    CreateEmployeeFromCrewMember: Codeunit "CreateEmployeeFromCrewMember";
                begin
                    CreateEmployeeFromCrewMember.Run();
                end;
            }
            action("Cancel Records")
            {
                ApplicationArea = All;
                Image = Cancel;
                Visible = false;

                trigger OnAction()
                var
                    CrewMemberRec: Record "PB Crew Member Inbound";
                    SelectionFilterManagement: Codeunit SelectionFilterManagement;
                    RecRef: RecordRef;
                    SelectedFilter: Boolean;
                    Text001: Label 'Do you want to Cancel all Selected records on this page?';
                    ConfirmManagement: Codeunit "Confirm Management";
                begin
                    CrewMemberRec.Reset();
                    CurrPage.SetSelectionFilter(CrewMemberRec);
                    if ConfirmManagement.GetResponseOrDefault(StrSubstNo(Text001), true)then begin
                        if CrewMemberRec.FindSet()then repeat if CrewMemberRec."API Status" = CrewMemberRec."API Status"::Processed then error('The line for Entry No.: %1 is processed you cannot cancel it', CrewMemberRec."Entry No.");
                                if CrewMemberRec."API Status" <> CrewMemberRec."API Status"::Cancel then begin
                                    CrewMemberRec."API Status":=CrewMemberRec."API Status"::Cancel;
                                    CrewMemberRec."Cancelled by User":=UserId;
                                    CrewMemberRec."Cancelled Date time":=CreateDateTime(Today, Time);
                                    CrewMemberRec.Modify()end;
                            until CrewMemberRec.Next() = 0;
                    end;
                end;
            }
        }
        area(Navigation)
        {
            action("Inbound Error Log")
            {
                ApplicationArea = All;
                Visible = false;
                RunObject = page "Inbound Error Log Entry";
                RunPageLink = "Inbound Table"=filter(50134);
                RunPageMode = View;
                RunPageView = sorting("Inbound Table", "Inbound Entry No.")where("Inbound Table"=filter(50134));
            }
            Action("Related Employee Card")
            {
                ApplicationArea = all;
                Image = Employee;
                Visible = false;

                // RunObject = page "Employee Card";
                // RunPageLink = "DNV Staging Entry No." = field("Entry No.");
                // RunPageView = sorting(Status, "Emplymt. Contract Code") where(Status = filter(EnumStatus::Processed));
                trigger OnAction()
                var
                    Employee: Record Employee;
                begin
                    employee.SetRange("DNV Staging Entry No.", rec."Entry No.");
                    if Employee.FindSet()then begin
                        if Rec."API Status" = Rec."API Status"::Processed then Page.Run(Page::"Employee Card", Employee);
                    end;
                end;
            }
        }
    }
}
