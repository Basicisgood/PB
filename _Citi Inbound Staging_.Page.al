page 50130 "Citi Inbound Staging"
{
    ApplicationArea = All;
    Caption = 'Citi Inbound Staging';
    PageType = List;
    SourceTable = "Citi Inbound Staging";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Statement Id"; Rec."Statement Id")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Statement Id field.';
                }
                field("Entry Reference"; Rec."Entry Reference")
                {
                    ToolTip = 'Specifies the value of the Entry Reference field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(TxEndtoEndId; Rec.TxEndtoEndId)
                {
                    ToolTip = 'Specifies the value of the TxEndtoEndId field.', Comment = '%';
                    ApplicationArea = All;
                    style = Strong;
                }
                field(TxTransCode; Rec.TxTransCode)
                {
                    ToolTip = 'Specifies the value of the TxTransCode field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(EntryStatus; Rec.EntryStatus)
                {
                    ToolTip = 'Specifies the value of the EntryStatus field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(EntryCrDrInd; Rec.EntryCrDrInd)
                {
                    ToolTip = 'Specifies the value of the EntryCrDrInd field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Additional Entry Information"; Rec."Additional Entry Information")
                {
                    ToolTip = 'Specifies the value of the Additional Entry Information field.';
                    ApplicationArea = All;
                }
                field(EntryBookedDate; Rec.EntryBookedDate)
                {
                    ToolTip = 'Specifies the value of the EntryBookedDate field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(CreateDate; Rec.CreateDate)
                {
                    ToolTip = 'Specifies the value of the CreateDate field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(FromDate; Rec.FromDate)
                {
                    ToolTip = 'Specifies the value of the FromDate field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(ToDate; Rec.ToDate)
                {
                    ToolTip = 'Specifies the value of the ToDate field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Bank Account"; Rec."Bank Account")
                {
                    ToolTip = 'Specifies the value of the Bank Account field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Currency; Rec.Currency)
                {
                    ToolTip = 'Specifies the value of the Currency field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("SWIFT Code"; Rec."SWIFT Code")
                {
                    ToolTip = 'Specifies the value of the SWIFT Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(EntryCurrency; Rec.EntryCurrency)
                {
                    ToolTip = 'Specifies the value of the EntryCurrency field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(EntryAmount; Rec.EntryAmount)
                {
                    ToolTip = 'Specifies the value of the EntryAmount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(EntryBookingDate; Rec.EntryBookingDate)
                {
                    ToolTip = 'Specifies the value of the EntryBookingDate field.', Comment = '%';
                    ApplicationArea = All;
                    Style = strong;
                }
                field(EntryRevInd; Rec.EntryRevInd)
                {
                    ToolTip = 'Specifies the value of the EntryRevInd field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(EntryValueDate; Rec.EntryValueDate)
                {
                    ToolTip = 'Specifies the value of the EntryValueDate field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(EntryAccountServRef; Rec.EntryAccountServRef)
                {
                    ToolTip = 'Specifies the value of the EntryAccountServRef field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(EntryTransCode; Rec.EntryTransCode)
                {
                    ToolTip = 'Specifies the value of the EntryTransCode field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(EntryIssuer; Rec.EntryIssuer)
                {
                    ToolTip = 'Specifies the value of the EntryIssuer field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(EntryMessageId; Rec.EntryMessageId)
                {
                    ToolTip = 'Specifies the value of the EntryMessageId field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(EntryPmtInfid; Rec.EntryPmtInfid)
                {
                    ToolTip = 'Specifies the value of the EntryPmtInfid field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Entry Transaction Number"; Rec."Entry Transaction Number")
                {
                    ToolTip = 'Specifies the value of the Entry Transaction Number field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(TxReference; Rec.TxReference)
                {
                    ToolTip = 'Specifies the value of the TxReference field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(TxMessageId; Rec.TxMessageId)
                {
                    ToolTip = 'Specifies the value of the TxMessageId field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(TxAccountServicerRef; Rec.TxAccountServicerRef)
                {
                    ToolTip = 'Specifies the value of the TxAccountServicerRef field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(TxPmtInfid; Rec.TxPmtInfid)
                {
                    ToolTip = 'Specifies the value of the TxPmtInfid field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(TxInstructionID; Rec.TxInstructionID)
                {
                    ToolTip = 'Specifies the value of the TxInstructionID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(TxInstdAmt; Rec.TxInstdAmt)
                {
                    ToolTip = 'Specifies the value of the TxInstdAmt field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(TxTransactionAmt; Rec.TxTransactionAmt)
                {
                    ToolTip = 'Specifies the value of the TxTransactionAmt field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(TxIssuer; Rec.TxIssuer)
                {
                    ToolTip = 'Specifies the value of the TxIssuer field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(TxChargeAmt; Rec.TxChargeAmt)
                {
                    ToolTip = 'Specifies the value of the TxChargeAmt field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(TxChargeCrDbtInd; Rec.TxChargeCrDbtInd)
                {
                    ToolTip = 'Specifies the value of the TxChargeCrDbtInd field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(TxName; Rec.TxName)
                {
                    ToolTip = 'Specifies the value of the TxName field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Account Number"; Rec."Creditor Account Number")
                {
                    ToolTip = 'Specifies the value of the Creditor Account Number field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(TxAccountServicerReference; Rec.TxAccountServicerReference)
                {
                    ToolTip = 'Specifies the value of the TxAccountServicerReference field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Transaction Identification"; Rec."Transaction Identification")
                {
                    ToolTip = 'Specifies the value of the Transaction Identification field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Related Parties Name "; Rec."Related Parties Name ")
                {
                    ToolTip = 'Specifies the value of the Related Parties Name  field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Clearinging System Member Id"; Rec."Clearinging System Member Id")
                {
                    ToolTip = 'Specifies the value of the Clearinging System Member Id field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Error Message"; Rec."Error Message")
                {
                    ToolTip = 'Specifies the value of the Error Message field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Processed; Rec.Processed)
                {
                    ToolTip = 'Specifies the value of the Processed field.', Comment = '%';
                    ApplicationArea = All;
                    Style = Strong;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    ApplicationArea = All;
                    Style = strong;
                }
                field("Executed Scenario"; Rec."Executed Scenario")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Executed Scenario field.', Comment = '%';
                }
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Journal Template Name field.', Comment = '%';
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Journal Batch Name field.', Comment = '%';
                }
                field(TxAmt; Rec.TxAmt)
                {
                    ToolTip = 'Specifies the value of the TxAmt field.';
                    ApplicationArea = All;
                }
                field(TxCurrency; Rec.TxCurrency)
                {
                    ToolTip = 'Specifies the value of the TxCurrency field.';
                    ApplicationArea = All;
                }
                field(XChargeRate; Rec.XChangeRate)
                {
                    ToolTip = 'Specifies the value of the XChargeRate field.';
                    ApplicationArea = All;
                }
                field("Creditor Name"; Rec."Creditor Name")
                {
                    ToolTip = 'Specifies the value of the Creditor Name field.';
                    ApplicationArea = All;
                }
                field("Creditor Agent Name"; Rec."Creditor Agent Name")
                {
                    ToolTip = 'Specifies the value of the Creditor Agent Name field.';
                    ApplicationArea = All;
                }
                field("Remittance Information"; Rec."Remittance Information")
                {
                    ToolTip = 'Specifies the value of the Remittance Information field.';
                    ApplicationArea = All;
                }
                field(Source; Rec.Source)
                {
                    ToolTip = 'Specifies the value of the Source field.';
                    ApplicationArea = All;
                }
                field("MSC DESC"; Rec."MSC DESC")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the MSC DESC field.';
                }
                field("Opening Available"; Rec."Opening Available")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Opening Available field.';
                }
                field("Opening Booked"; Rec."Opening Booked")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Opening Booked field.';
                }
                field("Closing Booked"; Rec."Closing Booked")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Closing Booked field.';
                }
                field("Closing Available"; Rec."Closing Available")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Closing Available field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(FindEnties) //VJ20FEB2025+++
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                Image = Navigate;
                ToolTip = 'Executes the FindEnties action.';

                trigger OnAction()
                var
                    NavigatePage: Page Navigate;
                begin
                    NavigatePage.SetDoc(Rec.EntryValueDate, Rec.TxEndtoEndId);
                    NavigatePage.Run;
                end;
            }
            action(ImportStmt)
            {
                Caption = 'Import Bank Statement';
                ToolTip = 'Executes the Import Bank Statement action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Codeunit.Run(Codeunit::"Citi Import Statement API");
                end;
            }
            group(ProcessStaging)
            {
                Caption = 'Process Staging';
                Visible = false; //21jul2025 vj

                action(Scenario1)
                {
                    ApplicationArea = all;
                    Image = UpdateDescription;
                    ToolTip = 'Executes the Scenario1 action.';

                    trigger OnAction()
                    var
                        CitiInboudCodeunit: Codeunit "Citi Inbound Codeunit v2";
                    begin
                        CitiInboudCodeunit.ProcessAllInboundLines(1);
                        Clear(CitiInboudCodeunit);
                    end;
                }
                action(Scenario2)
                {
                    ApplicationArea = all;
                    Image = UpdateDescription;
                    ToolTip = 'Executes the Scenario2 action.';

                    trigger OnAction()
                    var
                        CitiInboudCodeunit: Codeunit "Citi Inbound Codeunit v2";
                    begin
                        CitiInboudCodeunit.ProcessAllInboundLines(2);
                        Clear(CitiInboudCodeunit);
                    end;
                }
                action(Scenario3)
                {
                    ApplicationArea = all;
                    Image = UpdateDescription;
                    ToolTip = 'Executes the Scenario3 action.';

                    trigger OnAction()
                    var
                        CitiInboudCodeunit: Codeunit "Citi Inbound Codeunit v2";
                    begin
                        CitiInboudCodeunit.ProcessAllInboundLines(3);
                        Clear(CitiInboudCodeunit);
                    end;
                }
                action(Scenario4)
                {
                    ApplicationArea = all;
                    Image = UpdateDescription;
                    ToolTip = 'Executes the Scenario3 action.';

                    trigger OnAction()
                    var
                        CitiInboudCodeunit: Codeunit "Citi Inbound Codeunit v2";
                    begin
                        CitiInboudCodeunit.ProcessAllInboundLines(4);
                        Clear(CitiInboudCodeunit);
                    end;
                }
                action(CheckDuplicate)
                {
                    ApplicationArea = all;
                    Image = UpdateDescription;
                    ToolTip = 'Executes the duplicate checking';

                    trigger OnAction()
                    var
                        CitiInboudCodeunit: Codeunit "Citi Inbound Codeunit V2";
                    begin
                        CitiInboudCodeunit.UpdateDuplicateStatus();
                        Clear(CitiInboudCodeunit);
                    end;
                }
            }
            group("ProcessStagingNew")
            {
                Caption = 'Process Staging New';

                action("Process Staging")
                {
                    ApplicationArea = all;
                    Image = UpdateDescription;
                    ToolTip = 'Executes the Scenarioes action.';

                    trigger OnAction()
                    var
                        CitiInboudCodeunit: Codeunit "Citi Inbound Codeunit v2";
                        Options: Text[200];
                        Selected: Integer;
                        Text000: Label 'Scenario 1(Post Payment),Scenario 2(Create Cash Journal),Scenario 3(Return Journal),Scenario 4(Create Payment Journal),All Scenario(3-2-1-4)';
                        Text002: Label 'Choose one of the following options:';
                    begin
                        Options:=Text000;
                        Selected:=Dialog.StrMenu(Options, 5, Text002);
                        if Selected = 0 then exit;
                        CitiInboudCodeunit.ProcessAllInboundLines(Selected);
                        Clear(CitiInboudCodeunit);
                    end;
                }
            }
            action(ProcessCurrentRecord)
            {
                ApplicationArea = all;
                Image = UpdateDescription;
                ToolTip = 'Executes current record and stop on error';
                Caption = 'Process Current Record';

                trigger OnAction()
                var
                    CitiInboudCodeunit: Codeunit "Citi Inbound Codeunit v2";
                    Options: Text[200];
                    Selected: Integer;
                    Text000: Label 'Scenario 1(Post Payment),Scenario 2(Create Cash Journal),Scenario 3(Return Journal),Scenario 4(Create Payment Journal),All Scenario(3-2-1-4)';
                    Text002: Label 'Choose one of the following options:';
                begin
                    Options:=Text000;
                    Selected:=Dialog.StrMenu(Options, 5, Text002);
                    if Selected = 0 then exit;
                    CitiInboudCodeunit.SetEntryNoFromCitiInboundStaging(rec."Entry No.");
                    CitiInboudCodeunit.ProcessAllInboundLines(Selected);
                    Clear(CitiInboudCodeunit);
                end;
            }
            action(Cancel)
            {
                ToolTip = 'Executes the Cancel action.';
                Caption = 'Cancel Entries';
                Image = CancelAllLines;
                ApplicationArea = All;

                //VJ17Jan2025 crated action
                trigger OnAction()
                var
                    CitiInboundCod: Codeunit "Citi Inbound Codeunit V2";
                begin
                    if not Confirm('Do you want to cancel all entires showing on the page?', false)then CitiInboundCod.UpdateCancelStatus(Rec);
                    CurrPage.Update(false);
                end;
            }
            group(ProcessAll)
            {
                action("Process All")
                {
                    Caption = 'Process All';
                    Image = Process;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Process All action.';
                    Visible = FALSE;

                    trigger OnAction()
                    var
                        CitiInboudCodeunit: Codeunit "Citi Inbound Codeunit V2";
                    begin
                        CitiInboudCodeunit.Run();
                        Clear(CitiInboudCodeunit);
                    end;
                }
                action(ResetProcess)
                {
                    ApplicationArea = All;
                    Caption = 'Reset Process Status"';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Restore;
                    ToolTip = 'Executes the Reset Process Status" action.';

                    trigger OnAction()
                    var
                        UserSetup: Record "User Setup";
                    begin
                        UserSetup.Reset();
                        UserSetup.Get(UserId);
                        if not UserSetup."Approval Administrator" then Error('Not Authorized');
                        rec.Processed:=false;
                        rec.Modify();
                    end;
                }
            }
        }
    }
    //TEC.VJ 03ARP2025>>
    TRIGGER OnDeleteRecord(): Boolean begin
        CheckDeleteOrModifyPermission();
    end;
    trigger OnModifyRecord(): Boolean begin
        CheckDeleteOrModifyPermission();
    end;
    local procedure CheckDeleteOrModifyPermission()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId)then begin
            if not UserSetup."Allow Inbound Edit/Delete" then Error('You do not have permission to delete or modify.');
        end
        else
            Error('You do not have permission to delete or modify.');
    end;
//TEC.VJ 03ARP2025<<
}
