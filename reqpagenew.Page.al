page 50114 reqpagenew
{
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Workflow Step Argument";

    layout
    {
        area(Content)
        {
            group(Control10)
            {
                ShowCaption = false;

                //  Visible = WStepArg."Response Option Group" = 'GROUP 5';
                field("Show Confirmation Message"; Rec."Show Confirmation Message")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies that a confirmation message is shown to users after they request an approval.';
                }
                field("Due Date Formula"; Rec."Due Date Formula")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies in how many days the approval request must be resolved from the date when it was sent.';
                }
                field("Delegate After"; Rec."Delegate After")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies if and when an approval request will automatically be delegated to the relevant substitute. You can select to automatically delegate one, two, or five days after the date when the approval was requested.';
                }
                field("Approver Type"; Rec."Approver Type")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies who is notified first about approval requests.';

                    trigger OnValidate()
                    begin
                        SetVisibilityOptions();
                        CurrPage.Update(true)end;
                }
                group(Control4)
                {
                    ShowCaption = false;
                    Visible = ShowApprovalLimitType;

                    field("Approver Limit Type"; Rec."Approver Limit Type")
                    {
                        ApplicationArea = Suite;
                        ToolTip = 'Specifies how approvers'' approval limits affect when approval request entries are created for them. A qualified approver is an approver whose approval limit is above the value on the approval request.';

                        trigger OnValidate()
                        begin
                            CurrPage.Update(true)end;
                    }
                }
                group(Control18)
                {
                    ShowCaption = false;
                    Visible = NOT ShowApprovalLimitType;

                    field("Workflow User Group Code"; Rec."Workflow User Group Code")
                    {
                        ApplicationArea = Suite;
                        ShowMandatory = true;
                        ToolTip = 'Specifies the workflow user group that is used in connection with this workflow step argument.';

                        trigger OnValidate()
                        begin
                            CurrPage.Update(true)end;
                    }
                }
                group(Control34)
                {
                    ShowCaption = false;
                    Visible = ShowApproverUserId;

                    field(ApproverId; Rec."Approver User ID")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Approver ID';
                        ShowMandatory = true;
                        ToolTip = 'Specifies the approver.';

                        trigger OnValidate()
                        begin
                            CurrPage.Update(true)end;
                    }
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
            }
        }
    }
    var myInt: Integer;
    User: Record User;
    UserValue: Code[50];
    WorkflowUSerGroup: Code[20];
    NoArguments: Text;
    NoArgumentsTxt: Label 'You cannot set options for this workflow response.';
    ShowApprovalLimitType: Boolean;
    ShowApproverUserId: Boolean;
    ApprovalUserSetupLabel: Text;
    OpenPageTxt: Label 'Open %1', Comment = '%1 is the page that will be opened when clicking the control';
    TableFieldCaption: Text;
    ApplyAllValues: Boolean;
    ShowResponseUserID: Boolean;
    WStepArg: Record "Workflow Step Argument";
    trigger OnOpenPage()
    var
        ApprovalUserSetup: Page "Approval User Setup";
    begin
        //  WStepArg.CalcFields("Response Option Group");
        NoArguments:=NoArgumentsTxt;
        ApprovalUserSetupLabel:=StrSubstNo(OpenPageTxt, ApprovalUserSetup.Caption);
        WStepArg.HideExternalUsers();
    end;
    trigger OnQueryClosePage(CloseAction: Action): Boolean begin
    //GetRecValue()
    end;
    local procedure GetEventTable()
    var
        WorkflowStep: Record "Workflow Step";
        WorkflowStepEvent: Record "Workflow Step";
        WorkflowEvent: Record "Workflow Event";
    begin
        WorkflowStep.SetRange(Argument, Rec.ID);
        if WorkflowStep.FindFirst()then if WorkflowStep.HasParentEvent(WorkflowStepEvent)then begin
                WorkflowEvent.Get(WorkflowStepEvent."Function Name");
                Rec."Table No.":=WorkflowEvent."Table ID";
            end;
    end;
    local procedure SetVisibilityOptions()
    begin
        //    WStepArg.CalcFields("Response Option Group");
        ShowApprovalLimitType:=Rec."Approver Type" <> Rec."Approver Type"::"Workflow User Group";
        ShowApproverUserId:=ShowApprovalLimitType and (Rec."Approver Limit Type" = WStepArg."Approver Limit Type"::"Specific Approver");
        ShowResponseUserID:=Rec."Response Type" = Rec."Response Type"::"User ID";
    //OnAfterSetVisibilityOptions(Rec, ShowApprovalLimitType, ShowApproverUserId, ShowResponseUserID);
    end;
    local procedure LookupFieldCaption(TableNoFilter: Text; FieldNoFilter: Text): Text var
        "Field": Record Field;
        FieldSelection: Codeunit "Field Selection";
    begin
        Field.FilterGroup(2);
        Field.SetFilter(Type, StrSubstNo('%1|%2|%3|%4|%5|%6|%7|%8|%9|%10|%11|%12', Field.Type::Boolean, Field.Type::Text, Field.Type::Code, Field.Type::Decimal, Field.Type::Integer, Field.Type::BigInteger, Field.Type::Date, Field.Type::Time, Field.Type::DateTime, Field.Type::DateFormula, Field.Type::Option, Field.Type::Duration));
        Field.SetRange(Class, Field.Class::Normal);
        Field.SetFilter(TableNo, TableNoFilter);
        Field.SetFilter("No.", FieldNoFilter);
        if FieldSelection.Open(Field)then begin
            Rec."Table No.":=Field.TableNo;
            exit(Field."Field Caption");
        end;
        exit('');
    end;
    local procedure LookupFieldCaptionForApplyNewValues(): Text var
        WorkflowStepApply: Record "Workflow Step";
        WorkflowStepRevert: Record "Workflow Step";
        WorkflowStepArgument: Record "Workflow Step Argument";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        FilterForField: Text;
        FilterForTable: Text;
        Separator: Text[1];
        AddSeparator: Boolean;
    begin
        WorkflowStepApply.SetRange(Argument, Rec.ID);
        if WorkflowStepApply.FindFirst()then begin
            WorkflowStepRevert.SetRange("Workflow Code", WorkflowStepApply."Workflow Code");
            WorkflowStepRevert.SetRange("Function Name", WorkflowResponseHandling.RevertValueForFieldCode());
            if WorkflowStepRevert.FindSet()then repeat WorkflowStepArgument.Get(WorkflowStepRevert.Argument);
                    if WorkflowStepArgument."Field No." <> 0 then begin
                        if AddSeparator then Separator:='|';
                        AddSeparator:=true;
                        FilterForTable+=Separator + Format(WorkflowStepArgument."Table No.");
                        FilterForField+=Separator + Format(WorkflowStepArgument."Field No.");
                    end;
                until WorkflowStepRevert.Next() = 0;
            exit(LookupFieldCaption(FilterForTable, FilterForField));
        end;
        exit('');
    end;
    local procedure ValidateFieldCaption()
    var
        "Field": Record "Field";
    begin
        if TableFieldCaption <> '' then begin
            Field.SetRange(TableNo, Rec."Table No.");
            Field.SetRange("Field Caption", TableFieldCaption);
            Field.FindFirst();
            Rec."Field No.":=Field."No." end
        else
            Rec."Field No.":=0;
        CurrPage.Update(true);
    end;
    procedure SetRecValue(var WorkflowStepArgument: Record "Workflow Step Argument")
    begin
        Clear(WStepArg);
        WStepArg.Reset();
        WStepArg.Get(WorkflowStepArgument.ID);
    // WStepArg.CalcFields("Response Option Group");
    end;
    procedure GetRecValue()WFSA: Record "Workflow Step Argument";
    begin
        //Clear(WStepArg);
        //  WStepArg.Reset();
        //  WStepArg.Get(WorkflowStepArgument.ID);
        // WStepArg.CalcFields("Response Option Group");
        exit(WStepArg);
    end;
}
