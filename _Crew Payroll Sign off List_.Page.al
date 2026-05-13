page 50257 "Crew Payroll Sign off List"
{
    ApplicationArea = All;
    Caption = 'Crew Payroll Sign Off List';
    PageType = List;
    SourceTable = "PB Crew Payroll Inbound";
    SourceTableView = where("Sign Off"=filter(<>0D));
    UsageCategory = Lists;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;

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
                field("Crew Personnel Number"; Rec."Crew Personnel Number")
                {
                    ApplicationArea = All;
                }
                field("Accounting Area"; Rec."Accounting Area")
                {
                    ApplicationArea = all;
                }
                field("Finance Company No"; Rec."Finance Company No")
                {
                    ApplicationArea = all;
                }
                field("Ship Sign Company No"; Rec."Ship Sign Company No")
                {
                    ApplicationArea = all;
                }
                field("Posted Document No Fin Company"; Rec."Posted Document No Fin Company")
                {
                    ApplicationArea = all;
                }
                field("Posted Document No Shp Company"; Rec."Posted Document No Shp Company")
                {
                    ApplicationArea = all;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Created At"; Rec."Created At")
                {
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                field("Carry Forward Amount"; Rec."Carry Forward Amount")
                {
                    ApplicationArea = All;
                }
                field("Payout This Month"; Rec."Payout This Month")
                {
                    ApplicationArea = All;
                }
                field("Payment From"; Rec."Payment From")
                {
                    ApplicationArea = All;
                }
                field("Payment To"; Rec."Payment To")
                {
                    ApplicationArea = All;
                }
                field("Sign On"; Rec."Sign On")
                {
                    ApplicationArea = All;
                }
                field("Sign Off"; Rec."Sign Off")
                {
                    ApplicationArea = All;
                }
                field("Ship Short Sign"; Rec."Ship Short Sign")
                {
                    ApplicationArea = All;
                }
                field("Crew Rank"; Rec."Crew Rank")
                {
                    ApplicationArea = All;
                }
                field("Is Cadet"; Rec."Is Cadet")
                {
                    ApplicationArea = All;
                }
                field("Wage Calculation Basis 30 Days"; Rec."Wage Calculation Basis 30 Days")
                {
                    ApplicationArea = All;
                }
                field("Pending Balance Wage"; Rec."Pending Balance Wage")
                {
                    ApplicationArea = All;
                }
                field("Pending Balance Leave Pay"; Rec."Pending Balance Leave Pay")
                {
                    ApplicationArea = All;
                }
                field("Pending Bal. Subsist. Allow."; Rec."Pending Bal. Subsist. Allow.")
                {
                    ApplicationArea = All;
                }
                field("Is Paid Out"; Rec."Is Paid Out")
                {
                    ApplicationArea = All;
                }
                field("Transaction Number"; Rec."Transaction Number")
                {
                    ApplicationArea = All;
                }
                field("Records Status"; Rec."Records Status")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
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
            part(dimensions; "Crew Payroll Dim Inb List")
            {
                Caption = 'Crew Payroll Dimension Subpage';
                // EntityName = 'CommittedCostInbdim';
                // EntitySetName = 'CommittedCostInbdim';
                SubPageLink = CrewPayrollId=Field(SystemId);
                ApplicationArea = All;
            }
        }
        area(FactBoxes)
        {
            part(GLEntriesPart; "G/L Entries Part")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Related G/L Entries';
                ShowFilter = false;
                SubPageLink = "DNV Staging Entry No."=field("Entry No.");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Create Gen. Jnl")
            {
                ApplicationArea = All;
                Caption = 'Create General Jounral';
                Image = Create;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
                    CreateGenJournlFromCrewPayroll: Codeunit 50149;
                begin
                    CreateGenJournlFromCrewPayroll.Run();
                end;
            }
            action("Cancel Records")
            {
                ApplicationArea = All;
                Image = Cancel;
                Caption = 'Cancel Records';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
                    PBCrewPayrollInb: Record "PB Crew Payroll Inbound";
                    SelectionFilterManagement: Codeunit SelectionFilterManagement;
                    RecRef: RecordRef;
                    SelectedFilter: Boolean;
                    Text001: Label 'Do you want to Cancel all Selected records in the Crew Payroll Inbound List?';
                    ConfirmManagement: Codeunit "Confirm Management";
                begin
                    PBCrewPayrollInb.Reset();
                    CurrPage.SetSelectionFilter(PBCrewPayrollInb);
                    if ConfirmManagement.GetResponseOrDefault(StrSubstNo(Text001), true)then begin
                        if PBCrewPayrollInb.FindSet()then repeat if(PBCrewPayrollInb.Status = PBCrewPayrollInb.status::Processed) or (PBCrewPayrollInb.Status = PBCrewPayrollInb.status::"Finanace Company Processed") OR (PBCrewPayrollInb.Status = PBCrewPayrollInb.status::"Ship Shop Company Processed")then error('The Line is Processed and moved to the General Journal window For Entry No.: %1', PBCrewPayrollInb."Entry No.");
                                PBCrewPayrollInb.status:=PBCrewPayrollInb.status::Cancel;
                                PBCrewPayrollInb."Cancelled by User":=UserId;
                                PBCrewPayrollInb."Cancelled Date time":=CreateDateTime(Today, Time);
                                PBCrewPayrollInb."Posted Document No Fin Company":='CANCELLED';
                                PBCrewPayrollInb."Posted Document No Shp Company":='CANCELLED';
                                PBCrewPayrollInb.Modify()until PBCrewPayrollInb.Next() = 0;
                    end;
                end;
            }
            action("Delete Cancel Records")
            {
                ApplicationArea = All;
                Image = Cancel;
                Caption = 'Delete all Cancel Records';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
                    PBCrewPayrollInb: Record "PB Crew Payroll Inbound";
                    SelectionFilterManagement: Codeunit SelectionFilterManagement;
                    RecRef: RecordRef;
                    SelectedFilter: Boolean;
                    Text001: Label 'Do you want to Cancel all Selected records in the Crew Payroll Inbound List?';
                    ConfirmManagement: Codeunit "Confirm Management";
                begin
                    PBCrewPayrollInb.Reset();
                    PBCrewPayrollInb.SetRange(Status, PBCrewPayrollInb.Status::Cancel);
                    if PBCrewPayrollInb.FindSet()then PBCrewPayrollInb.DeleteAll();
                end;
            }
            action("Reset Records")
            {
                ApplicationArea = All;
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
                    PBCrewPayrollInb: Record "PB Crew Payroll Inbound";
                    SelectionFilterManagement: Codeunit SelectionFilterManagement;
                    RecRef: RecordRef;
                    SelectedFilter: Boolean;
                    Text001: Label 'Do you want to reset all Selected records in the Purchase Invoice Inbound List?';
                    ConfirmManagement: Codeunit "Confirm Management";
                begin
                    PBCrewPayrollInb.Reset();
                    CurrPage.SetSelectionFilter(PBCrewPayrollInb);
                    if ConfirmManagement.GetResponseOrDefault(StrSubstNo(Text001), true)then begin
                        if PBCrewPayrollInb.FindSet()then repeat //            if (PBCrewPayrollInb.Status = PBCrewPayrollInb.Status::Processed) or (PBCrewPayrollInb.Status = PBCrewPayrollInb.Status::"Finanace Company Processed")
                                //          or (PBCrewPayrollInb.Status = PBCrewPayrollInb.Status::"Ship Shop Company Processed")
                                //        then begin
                                PBCrewPayrollInb.Status:=PBCrewPayrollInb.Status::Pending;
                                PBCrewPayrollInb."Cancelled by User":='';
                                PBCrewPayrollInb."Cancelled Date time":=0DT;
                                PBCrewPayrollInb."Posted Document No Fin Company":='';
                                PBCrewPayrollInb."Posted Document No Shp Company":='';
                                PBCrewPayrollInb."Finance Company No":='';
                                PBCrewPayrollInb."Ship Sign Company No":='';
                                PBCrewPayrollInb."Error Description":='';
                                PBCrewPayrollInb.Modify();
                            //      end;
                            until PBCrewPayrollInb.Next() = 0;
                    end;
                end;
            }
        }
        area(Navigation)
        {
            action("Inbound Error Log")
            {
                ApplicationArea = all;
                Image = ErrorLog;
                RunObject = page "Inbound Error Log Entry";
                RunPageLink = "Inbound Table"=filter(50132);
                RunPageMode = View;
                RunPageView = sorting("Inbound Table", "Inbound Entry No.")where("Inbound Table"=filter(50130));
            }
            action("Related General Journal")
            {
                ApplicationArea = all;
                Image = Journal;
                RunObject = page "General Journal";
            }
        }
    }
}
