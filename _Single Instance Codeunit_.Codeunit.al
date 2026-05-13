codeunit 50114 "Single Instance Codeunit"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;
    //#338 TEC.VJ 21MAY2025>>
    /*
    procedure Preview(GenJournalLine_p: Record "Gen. Journal Line"): Boolean
    var
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
        SingleInst: codeunit "Single Instance Codeunit";
    begin
        ShowLedgEntries();
        GenJnlPost.Preview(GenJournalLine_p);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Preview", OnBeforeShowAllEntries, '', false, false)]
    local procedure "Gen. Jnl.-Post Preview_OnBeforeShowAllEntries"(var TempDocumentEntry: Record "Document Entry" temporary; var IsHandled: Boolean; var PostingPreviewEventHandler: Codeunit "Posting Preview Event Handler")
    begin
        if ShowEntries then
            IsHandled := true;
        ShowEntries := false;
    end;

    procedure ShowLedgEntries()
    begin
        ShowEntries := true;
    end;
    */
    //#338 TEC.VJ 21MAY2025<<
    procedure getdataApproverUserID(): Code[20]begin
        exit(ApproverUserID);
    end;
    procedure getdataWorkflowUserGroupCode(): Code[20]begin
        exit(WorkflowUserGroupCode);
    end;
    procedure getdataApproverLimitType(): Integer begin
        exit(ApproverLimitType.AsInteger());
    end;
    procedure getdataApproverType(): Integer begin
        exit(ApproverType.AsInteger());
    end;
    procedure getdataDelegateAfter(): Option begin
        exit(DelegateAfter);
    end;
    procedure SetData(var ApproverUserID1: Code[20]; WorkflowUserGroupCode1: Code[20]; ApproverLimitType1: Enum "Workflow Approver Limit Type"; ApproverType1: Enum "Workflow Approver Type"; DelegateAfter1: Option Never, "1 day", "2 days", "5 days")
    begin
        ApproverUserID:=ApproverUserID1;
        WorkflowUserGroupCode:=WorkflowUserGroupCode1;
        ApproverLimitType:=ApproverLimitType1;
        ApproverType:=ApproverType1;
        DelegateAfter:=DelegateAfter1;
    end;
    procedure clearvariable()
    begin
        WStepArgTemp.Reset();
        if WStepArgTemp.IsTemporary then WStepArgTemp.DeleteAll();
        Clear(ApproverUserID);
        Clear(WorkflowUserGroupCode);
        Clear(ApproverLimitType);
        Clear(ApproverType);
        Clear(DelegateAfter);
    end;
    var myInt: Integer;
    WStepArgTemp: Record "Workflow Step Argument" temporary;
    ApproverUserID: Code[20];
    WorkflowUserGroupCode: Code[20];
    ApproverLimitType: Enum "Workflow Approver Limit Type";
    ApproverType: Enum "Workflow Approver Type";
    DelegateAfter: Option Never, "1 day", "2 days", "5 days";
    ShowEntries: Boolean;
}
