page 50167 "HSBC Inbound Staging"
{
    ApplicationArea = All;
    Caption = 'HSBC Inbound Staging';
    PageType = List;
    SourceTable = "HSBC Inbound Staging";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(MsgId; Rec.MsgId)
                {
                    ToolTip = 'Specifies the value of the MsgId field.';
                    ApplicationArea = All;
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
                    Style = Strong;
                }
                field(Source; Rec.Source)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Source field.';
                }
                field(EntryCrDrInd; Rec.EntryCrDrInd)
                {
                    ToolTip = 'Specifies the value of the EntryCrDrInd field.', Comment = '%';
                    ApplicationArea = All;
                    Style = Strong;
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
                    Style = Strong;
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
                    ToolTip = 'Specifies the value of the TxAccountServicerReference field.';
                    ApplicationArea = All;
                }
                field("Transaction Identification"; Rec."Transaction Identification")
                {
                    ToolTip = 'Specifies the value of the Transaction Identification field.';
                    ApplicationArea = All;
                }
                field("Related Parties Name "; Rec."Related Parties Name ")
                {
                    ToolTip = 'Specifies the value of the Related Parties Name  field.';
                    ApplicationArea = All;
                }
                field("Clearinging System Member Id"; Rec."Clearinging System Member Id")
                {
                    ToolTip = 'Specifies the value of the Clearinging System Member Id field.';
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
                    Style = Strong;
                }
                field("Executed Scenario"; Rec."Executed Scenario")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Executed Scenario field.', Comment = '%';
                }
                field(XChangeRate; Rec.XChangeRate)
                {
                    ToolTip = 'Specifies the value of the XChangeRate field.';
                    ApplicationArea = All;
                }
                field("Creditor Name"; Rec."Creditor Name")
                {
                    ToolTip = 'Specifies the value of the Creditor Name field.';
                    ApplicationArea = All;
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
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ToolTip = 'Specifies the value of the Journal Template Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ToolTip = 'Specifies the value of the Journal Batch Name field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
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
                    Codeunit.Run(Codeunit::"HSBC Inbound CAMT53")end;
            }
            action(ImportStmtIntra)
            {
                Caption = 'Import Bank Statement Intra';
                ToolTip = 'Executes the Import Bank Statement Intra action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Codeunit.Run(Codeunit::"HSBC Inbound CAMT52");
                end;
            }
            action(del)
            {
                ToolTip = 'Executes the del action.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    inbound: Record "HSBC Inbound Staging";
                begin
                    inbound.Reset();
                    inbound.DeleteAll();
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
                    HSBCInboundCod: Codeunit "HSBC Inbound Codeunit V2";
                begin
                    if not Confirm('Do you want to cancel all entires showing on the page?', false)then HSBCInboundCod.UpdateCancelStatus(Rec);
                    CurrPage.Update(false);
                end;
            }
            group(ProcessStaging)
            {
                Caption = 'Process Staging';

                action(Scenario1)
                {
                    ApplicationArea = all;
                    Image = UpdateDescription;
                    ToolTip = 'Executes the Scenario1 action.';

                    trigger OnAction()
                    var
                        HSBCInboudCodeunit: Codeunit "HSBC Inbound Codeunit v2";
                    begin
                        HSBCInboudCodeunit.ProcessAllInboundLines(1);
                        Clear(HSBCInboudCodeunit);
                    end;
                }
                action(Scenario2)
                {
                    ApplicationArea = all;
                    Image = UpdateDescription;
                    ToolTip = 'Executes the Scenario2 action.';

                    trigger OnAction()
                    var
                        HSBCInboudCodeunit: Codeunit "HSBC Inbound Codeunit v2";
                    begin
                        HSBCInboudCodeunit.ProcessAllInboundLines(2);
                        Clear(HSBCInboudCodeunit);
                    end;
                }
                action(Scenario3)
                {
                    ApplicationArea = all;
                    Image = UpdateDescription;
                    ToolTip = 'Executes the Scenario3 action.';

                    trigger OnAction()
                    var
                        HSBCInboudCodeunit: Codeunit "HSBC Inbound Codeunit v2";
                    begin
                        HSBCInboudCodeunit.ProcessAllInboundLines(3);
                        Clear(HSBCInboudCodeunit);
                    end;
                }
                action(Scenario4)
                {
                    ApplicationArea = all;
                    Image = UpdateDescription;
                    ToolTip = 'Executes the Scenario3 action.';

                    trigger OnAction()
                    var
                        HSBCInboudCodeunit: Codeunit "HSBC Inbound Codeunit v2";
                    begin
                        HSBCInboudCodeunit.ProcessAllInboundLines(4);
                        Clear(HSBCInboudCodeunit);
                    end;
                }
                action(CheckDuplicate)
                {
                    ApplicationArea = all;
                    Image = UpdateDescription;
                    ToolTip = 'Executes the duplicate checking action.';

                    trigger OnAction()
                    var
                        HSBCInboudCodeunit: Codeunit "HSBC Inbound Codeunit V2";
                    begin
                        HSBCInboudCodeunit.UpdateDuplicateStatus();
                        Clear(HSBCInboudCodeunit);
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
                        HSBCInboudCodeunit: Codeunit "HSBC Inbound Codeunit v2";
                        Options: Text[1000];
                        Selected: Integer;
                        Text000: Label 'Scenario 1(Post Payment),Scenario 2(Create Cash Journal),Scenario 3(Return Journal),Scenario 4(Create Payment Journal),All Scenario(2,3,1,4)';
                        Text002: Label 'Choose one of the following options:';
                    begin
                        Options:=Text000;
                        Selected:=Dialog.StrMenu(Options, 5, Text002);
                        if Selected = 0 then exit;
                        //Error('%1', Selected);
                        HSBCInboudCodeunit.ProcessAllInboundLines(Selected);
                        Clear(HSBCInboudCodeunit);
                    end;
                }
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
                        HSBCInboudCodeunit: Codeunit "HSBC Inbound Codeunit V2";
                    begin
                        HSBCInboudCodeunit.Run();
                        Clear(HSBCInboudCodeunit);
                    end;
                }
            }
            Group(Entries)
            {
                action("General Ledger Entries")
                {
                    ApplicationArea = all;
                    Image = GeneralLedger;
                    Caption = 'General Ledger Entries';
                    ToolTip = 'Executes the General Ledger Entries action.';

                    trigger OnAction()
                    var
                        GLEntry: Record "G/L Entry";
                        GeneralLedgEn: Page "General Ledger Entries";
                    begin
                        GLEntry.Reset();
                        GLEntry.SetRange("External Document No.", Rec.TxEndtoEndId);
                        if GLEntry.FindFirst()then begin
                            GeneralLedgEn.SetTableView(GLEntry);
                            GeneralLedgEn.Run();
                        end;
                    end;
                }
                action("Vendor Ledger Entries")
                {
                    ApplicationArea = all;
                    Image = VendorLedger;
                    Caption = 'Vendor Ledger Entries';
                    ToolTip = 'Executes the Vendor Ledger Entries action.';

                    trigger OnAction()
                    var
                        VendorLedgr: Record "Vendor Ledger Entry";
                        VendorLedgEn: Page "Vendor Ledger Entries";
                    begin
                        VendorLedgr.Reset();
                        VendorLedgr.SetRange("External Document No.", Rec.TxEndtoEndId);
                        if VendorLedgr.FindFirst()then begin
                            VendorLedgEn.SetTableView(VendorLedgr);
                            VendorLedgEn.Run();
                        end;
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
    trigger OnAfterGetRecord()
    begin
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
