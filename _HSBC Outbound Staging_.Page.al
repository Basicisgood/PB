page 50157 "HSBC Outbound Staging"
{
    ApplicationArea = All;
    Caption = 'HSBC Outbound Staging';
    PageType = List;
    SourceTable = "HSBC Outbound Staging Table";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Bank Document No."; Rec."Bank Document No.")
                {
                    ToolTip = 'Specifies the value of the Bank Document No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Batch Type"; Rec."Batch Type")
                {
                    ToolTip = 'Specifies the value of the Batch Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Batch Id"; Rec."Batch Id")
                {
                    ToolTip = 'Specifies the value of the Batch Id field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Identification; Rec.Identification)
                {
                    ToolTip = 'Specifies the value of the Identification field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Payment Method"; Rec."Payment Method")
                {
                    ToolTip = 'Specifies the value of the Payment Method field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Service Level"; Rec."Service Level")
                {
                    ToolTip = 'Specifies the value of the Service Level field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor Name"; Rec."Debtor Name")
                {
                    ToolTip = 'Specifies the value of the Debtor  Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor Address"; Rec."Debtor Address")
                {
                    ToolTip = 'Specifies the value of the Debtor Address field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor Address 2"; Rec."Debtor Address 2")
                {
                    ToolTip = 'Specifies the value of the Debtor Address 2 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor Country"; Rec."Debtor Country")
                {
                    ToolTip = 'Specifies the value of the Debtor Country field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor Post Code"; Rec."Debtor Post Code")
                {
                    ToolTip = 'Specifies the value of the Debtor Post Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor Bank Account"; Rec."Debtor Bank Account")
                {
                    ToolTip = 'Specifies the value of the Debtor Bank Account field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor Currency Code"; Rec."Debtor Currency Code")
                {
                    ToolTip = 'Specifies the value of the Debtor Currency Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor SWIFT Code"; Rec."Debtor SWIFT Code")
                {
                    ToolTip = 'Specifies the value of the Debtor SWIFT Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor Bank Acc Name"; Rec."Debtor Bank Acc Name")
                {
                    ToolTip = 'Specifies the value of the Debtor Bank Acc Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor Bank Address"; Rec."Debtor Bank Address")
                {
                    ToolTip = 'Specifies the value of the Debtor Bank Address field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor Bank Post Code"; Rec."Debtor Bank Post Code")
                {
                    ToolTip = 'Specifies the value of the Debtor Bank Post Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor Bank Address 2"; Rec."Debtor Bank Address 2")
                {
                    ToolTip = 'Specifies the value of the Debtor Bank Address 2 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor Bank Country"; Rec."Debtor Bank Country")
                {
                    ToolTip = 'Specifies the value of the Debtor Bank Country field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor Bank Clearing Code"; Rec."Debtor Bank Clearing Code")
                {
                    ToolTip = 'Specifies the value of the Debtor Bank Clearing Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor ACH ID"; Rec."Debtor ACH ID")
                {
                    ToolTip = 'Specifies the value of the Debtor ACH ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor To Receipt"; Rec."Debtor To Receipt")
                {
                    ToolTip = 'Specifies the value of the Message To Receipt field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Recipient Bank Name"; Rec."Recipient Bank Name")
                {
                    ToolTip = 'Specifies the value of the Recipient Bank Name field.', Comment = '%';
                }
                field("Debtor ABA Routing Code"; Rec."Debtor ABA Routing Code")
                {
                    ToolTip = 'Specifies the value of the Debtor ABA Routing Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Currency; Rec.Currency)
                {
                    ToolTip = 'Specifies the value of the Currency field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Bank Account"; Rec."Creditor Bank Account")
                {
                    ToolTip = 'Specifies the value of the Creditor Bank Account field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor IFSC Code"; Rec."Creditor IFSC Code")
                {
                    ToolTip = 'Specifies the value of the Creditor IFSC Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Bank Acc Name"; Rec."Creditor Bank Acc Name")
                {
                    ToolTip = 'Specifies the value of the Creditor Bank Acc Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Swift Code"; Rec."Creditor Swift Code")
                {
                    ToolTip = 'Specifies the value of the Creditor Swift Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Bank Branch Code"; Rec."Creditor Bank Branch Code")
                {
                    ToolTip = 'Specifies the value of the Creditor Bank Branch Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Bank Clearing Code"; Rec."Creditor Bank Clearing Code")
                {
                    ToolTip = 'Specifies the value of the Creditor Bank Clearing Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Currency Code"; Rec."Creditor Currency Code")
                {
                    ToolTip = 'Specifies the value of the Creditor Currency Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Address"; Rec."Creditor Address")
                {
                    ToolTip = 'Specifies the value of the Creditor Address field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Post Code"; Rec."Creditor Post Code")
                {
                    ToolTip = 'Specifies the value of the Creditor Post Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Address 2"; Rec."Creditor Address 2")
                {
                    ToolTip = 'Specifies the value of the Creditor Address 2 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Country"; Rec."Creditor Country")
                {
                    ToolTip = 'Specifies the value of the Creditor Country field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Charge Bearer"; Rec."Charges Bearer")
                {
                    ToolTip = 'Specifies the value of the Charge Bearer field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ToolTip = 'Specifies the value of the Bal. Account No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Bank Integration Type"; Rec."Bank Integration Type")
                {
                    ToolTip = 'Specifies the value of the Bank Integration Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ToolTip = 'Specifies the value of the Country/Region Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor IBAN Account"; Rec."Creditor IBAN Account")
                {
                    ToolTip = 'Specifies the value of the Creditor IBAN Account field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("ABA/BSB No."; Rec."Creditor ABA/BSB No.")
                {
                    Caption = 'Creditor ABA BSB';
                    ToolTip = 'Specifies the value of the ABA/BSB No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Inter. Bank SWIFT"; Rec."Creditor Inter. Bank SWIFT")
                {
                    ToolTip = 'Specifies the value of the Creditor Intermediary Bank SWIFT field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Inter. Bank Country"; Rec."Creditor Inter. Bank Country")
                {
                    ToolTip = 'Specifies the value of the Creditor Intermediary Bank Country field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Inter. Bank Acc. No"; Rec."Creditor Inter. Bank Acc. No")
                {
                    ToolTip = 'Specifies the value of the Creditor Intermediary Bank Account No field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Email Address 1"; Rec."Creditor Email Address 1")
                {
                    ToolTip = 'Specifies the value of the Creditor Email Address 1 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Email Address 2"; Rec."Creditor Email Address 2")
                {
                    ToolTip = 'Specifies the value of the Creditor Email Address 2 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Email Address 3"; Rec."Creditor Email Address 3")
                {
                    ToolTip = 'Specifies the value of the Creditor Email Address 3 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Email Address 4"; Rec."Creditor Email Address 4")
                {
                    ToolTip = 'Specifies the value of the Creditor Email Address 4 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Email Address 5"; Rec."Creditor Email Address 5")
                {
                    ToolTip = 'Specifies the value of the Creditor Email Address 5 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Email Address 6"; Rec."Creditor Email Address 6")
                {
                    ToolTip = 'Specifies the value of the Creditor Email Address 6 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Create Date"; Rec."Create Date")
                {
                    ToolTip = 'Specifies the value of the Create Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Payment Method Bank XML"; Rec."Payment Method Bank XML")
                {
                    ToolTip = 'Specifies the value of the Payment Method Bank XML field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Applied Entries to XML"; Rec."Applied Entries to XML")
                {
                    ToolTip = 'Specifies the value of the Applied Entries to XML field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Payment Reference No."; Rec."Payment Reference No.")
                {
                    ToolTip = 'Specifies the value of the Payment Reference No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Purpose Code"; Rec."Purpose Code")
                {
                    ToolTip = 'Specifies the value of the Purpose Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Payment Purpose"; Rec."Payment Purpose")
                {
                    ToolTip = 'Specifies the value of the Payment Purpose field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("ACH Payment Set Code"; Rec."ACH Payment Set Code")
                {
                    ToolTip = 'Specifies the value of the ACH Payment Set Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Trans. Amt."; Rec."Trans. Amt.")
                {
                    ToolTip = 'Specifies the value of the Trans. Amt. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Trans. Currency"; Rec."Trans. Currency")
                {
                    ToolTip = 'Specifies the value of the Trans. Currency field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Exchange Rate"; Rec."Exchange Rate")
                {
                    ToolTip = 'Specifies the value of the Exchange Rate field.', Comment = '%';
                    ApplicationArea = All;
                }
                // field("Word Link"; Rec."Word Link") //NT_ 20250812
                // {
                //     ToolTip = 'Specifies the value of the Word Link field.', Comment = '%';
                //     ApplicationArea = All;
                // }
                field("Instruction to Bank"; Rec."Instruction to Bank")
                {
                    ToolTip = 'Specifies the value of the Instruction to Bank field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("FPS Type"; Rec."FPS Type")
                {
                    ToolTip = 'Specifies the value of the FPS Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("FPS No."; Rec."FPS No.")
                {
                    ToolTip = 'Specifies the value of the FPS No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("API Information"; Rec."API Information")
                {
                    ToolTip = 'Specifies the value of the API Information field.';
                    ApplicationArea = All;
                }
                field(TxSts; Rec.TxSts)
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
            action(FindEnties) //VJ20FEB2025+++
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                Image = Navigate;

                trigger OnAction()
                var
                    NavigatePage: Page Navigate;
                begin
                    NavigatePage.SetDoc(ConvertDateTimeToDate(Rec."Posting Date"), Rec."Bank Document No.");
                    NavigatePage.Run;
                end;
            }
            action(API)
            {
                ToolTip = 'Executes the API action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Codeunit.Run(Codeunit::"HSBC Outbound API");
                end;
            }
            // action(del)
            // {
            //     trigger OnAction()
            //     var
            //         logtable: Record "Bank API Log";
            //     begin
            //         logtable.Reset();
            //         logtable.DeleteAll();
            //     end;
            // }
            action(HSBCSetup)
            {
                Caption = 'HSBC Setup';
                Image = Setup;
                ApplicationArea = All;
                RunObject = page "HSBC Batch Setup";
                ToolTip = 'Executes the HSBC Setup action.';
            }
            action(ProcessFailedLines)
            {
                Caption = 'Process Failed Lines';
                ApplicationArea = all;
                Image = Process;
                ToolTip = 'Executes the Process Failed Lines action.';

                trigger OnAction()
                begin
                    MoveRejectLines();
                end;
            }
            action(MockXML)
            {
                Caption = 'Mock XML';
                ApplicationArea = all;
                ToolTip = 'Executes the Mock XML action.';

                trigger OnAction()
                var
                    Outbound: Record "HSBC Outbound Staging Table";
                begin
                    Outbound.Reset();
                    Outbound.SetRange("Bank Document No.", Rec."Bank Document No.");
                    if Outbound.FindSet()then GenXML(Outbound);
                end;
            }
            //NT_ 20250815 >>
            action(RejectBatch)
            {
                Caption = 'Create Reject Batch';
                ApplicationArea = all;

                trigger OnAction()
                var
                    CreateRejBatchLines: codeunit "Create Rejection Batch Lines";
                    GenJnlLine: Record "Gen. Journal Line";
                begin
                    GenJnlLine.Reset();
                    GenJnlLine.SetRange("Bank Document No.", Rec."Bank Document No.");
                    IF GenJnlLine.FindSet()then CreateRejBatchLines.Run(GenJnlLine);
                end;
            }
        //NT_ 20250815 <<
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
    local procedure CreateGenJnlBatch(FromGenJnlBatch: Record "Gen. Journal Batch")
    var
        myInt: Integer;
    begin
        ToGenJnlBatch.Reset();
        ToGenJnlBatch.SetRange("Journal Template Name", FromGenJnlBatch."Journal Template Name");
        ToGenJnlBatch.SetRange(Name, 'REJ_' + Format(Today, 0, '<Day,2><Month,2><Year>'));
        if not ToGenJnlBatch.FindFirst()then begin
            ToGenJnlBatch.Init();
            ToGenJnlBatch.TransferFields(FromGenJnlBatch);
            ToGenJnlBatch.Validate(Name, 'REJ_' + Format(Today, 0, '<Day,2><Month,2><Year>'));
            ToGenJnlBatch.Insert();
        end;
    end;
    local procedure MoveRejectLines()
    var
        HsbcOutbound: Record "HSBC Outbound Staging Table";
        HsbcOutbound2: Record "HSBC Outbound Staging Table";
        FromGenJnlBatch: Record "Gen. Journal Batch";
        FromGenJnlLine: Record "Gen. Journal Line";
        ToGenJnlLine: Record "Gen. Journal Line";
        BankAPISetup: Record "HSBC Batch Setup";
        LineNo: Integer;
    begin
        LineNo:=0;
        Clear(ToGenJnlBatch);
        BankAPISetup.Reset();
        BankAPISetup.SetRange("Bank Integration Type", BankAPISetup."Bank Integration Type"::HSBC);
        BankAPISetup.SetRange(Processed, false);
        if BankAPISetup.FindSet()then repeat HsbcOutbound.Reset();
                HsbcOutbound.SetCurrentKey("Bank Integration Type", "Batch Type", "Batch Id");
                HsbcOutbound.SetRange("Bank Integration Type", BankAPISetup."Bank Integration Type");
                HsbcOutbound.SetRange("Batch Type", BankAPISetup."Batch Type");
                HsbcOutbound.SetRange("Batch Id", BankAPISetup."Batch No.");
                HsbcOutbound.SetRange(Status, HsbcOutbound.Status::Fail);
                if HsbcOutbound.FindFirst()then begin
                    HsbcOutbound2.Reset();
                    HsbcOutbound2.CopyFilters(HsbcOutbound);
                    HsbcOutbound2.SetRange(Status);
                    if HsbcOutbound2.FindSet()then repeat FromGenJnlLine.Reset();
                            FromGenJnlLine.SetRange("Batch Type", HsbcOutbound2."Batch Type");
                            FromGenJnlLine.SetRange("Batch No.", HsbcOutbound2."Batch Id");
                            FromGenJnlLine.SetRange("Document No.", HsbcOutbound2."Document No.");
                            if FromGenJnlLine.FindFirst()then begin
                                LineNo+=10000;
                                FromGenJnlBatch.Get(FromGenJnlLine."Journal Template Name", FromGenJnlLine."Journal Template Name");
                                if LineNo = 10000 then CreateGenJnlBatch(FromGenJnlBatch);
                                ToGenJnlLine.Reset();
                                ToGenJnlLine.SetRange("Journal Template Name", ToGenJnlBatch."Journal Template Name");
                                ToGenJnlLine.SetRange("Journal Template Name", ToGenJnlBatch."Name");
                                if ToGenJnlLine.FindLast()then LineNo:=ToGenJnlLine."Line No." + 10000;
                                ToGenJnlLine.SetRange("Document No.", FromGenJnlLine."Document No.");
                                if not ToGenJnlLine.FindFirst()then begin
                                    ToGenJnlLine.get(FromGenJnlLine."Journal Template Name", FromGenJnlLine."Journal Batch Name", FromGenJnlLine."Line No.");
                                    ToGenJnlLine.Rename(FromGenJnlLine."Journal Template Name", ToGenJnlBatch.Name, FromGenJnlLine."Line No.");
                                    ToGenJnlLine.get(FromGenJnlLine."Journal Template Name", ToGenJnlBatch.Name, FromGenJnlLine."Line No.");
                                    ToGenJnlLine."Approver A Grp User":='';
                                    ToGenJnlLine."Approver B Grp User":='';
                                    ToGenJnlLine.Modify();
                                end;
                            end;
                        until HsbcOutbound2.Next() = 0;
                end;
            until BankAPISetup.Next() = 0;
    end;
    local procedure GenXML(var Outbound: Record "HSBC Outbound Staging Table")
    var
        HK_HighValueXML: XmlPort "HSBC High Value XML";
        HK_LowValueXML: XmlPort "HSBC Low Value XML";
        US_HighValueXML: XmlPort "HSBC US High Value XML";
        US_LowValueXML: XmlPort "HSBC US Low Value XML";
        l_TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
        InStream: InStream;
        l_txt_XML: Text;
    begin
        Clear(l_TempBlob);
        l_TempBlob.CreateOutStream(OutStream);
        l_TempBlob.CreateInStream(InStream);
        case OutBound."Batch Type" of OutBound."Batch Type"::"HK Upper Value": begin
            HK_HighValueXML.SetRecord(OutBound);
            HK_HighValueXML.SetTableView(OutBound);
            HK_HighValueXML.SetDestination(OutStream);
            HK_HighValueXML.Export();
        end;
        OutBound."Batch Type"::"HK Lower Value": begin
            HK_LowValueXML.SetRecord(OutBound);
            HK_LowValueXML.SetTableView(OutBound);
            HK_LowValueXML.SetDestination(OutStream);
            HK_LowValueXML.Export();
        end;
        OutBound."Batch Type"::"US Upper Value": begin
            US_HighValueXML.SetRecord(OutBound);
            US_HighValueXML.SetTableView(OutBound);
            US_HighValueXML.SetDestination(OutStream);
            US_HighValueXML.Export();
        end;
        OutBound."Batch Type"::"US Lower Value": begin
            US_LowValueXML.SetRecord(OutBound);
            US_LowValueXML.SetTableView(OutBound);
            US_LowValueXML.SetDestination(OutStream);
            US_LowValueXML.Export();
        end;
        end;
        InStream.Read(l_txt_XML);
        Message(l_txt_XML);
    end;
    procedure ConvertDateTimeToDate(MyDateTime: DateTime): Date var
        MyDate: Date;
    begin
        MyDate:=DT2Date(MyDateTime);
        exit(MyDate);
    end;
    var ToGenJnlBatch: Record "Gen. Journal Batch";
}
