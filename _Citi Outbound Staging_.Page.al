page 50159 "Citi Outbound Staging"
{
    ApplicationArea = All;
    Caption = 'Citi Outbound Staging';
    PageType = List;
    SourceTable = "Citi Outbound Staging Table";
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
                field("Create Date Time"; Rec."Create Date Time")
                {
                    ToolTip = 'Specifies the value of the Create Date Time field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Identification; Rec.Identification)
                {
                    ToolTip = 'Specifies the value of the Identification field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(PaymentID; Rec.PaymentID)
                {
                    ToolTip = 'Specifies the value of the PaymentID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
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
                field("Applied Entries to XML"; Rec."Applied Entries to XML")
                {
                    ToolTip = 'Specifies the value of the Applied Entries to XML field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor Name"; Rec."Debtor Name")
                {
                    ToolTip = 'Specifies the value of the Debtor Name field.', Comment = '%';
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
                field("Debtor Post Code"; Rec."Debtor Post Code")
                {
                    ToolTip = 'Specifies the value of the Debtor Post Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor Country"; Rec."Debtor Country")
                {
                    ToolTip = 'Specifies the value of the Debtor Country field.', Comment = '%';
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
                field("Debitor Bank Clearing Code"; Rec."Debitor Bank Clearing Code")
                {
                    ToolTip = 'Specifies the value of the Debitor Bank Clearing Code field.', Comment = '%';
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
                    ToolTip = 'Specifies the value of the Debtor Bank Address field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor Bank Country"; Rec."Debtor Bank Country")
                {
                    ToolTip = 'Specifies the value of the Debtor Bank Country field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor To Receipt"; Rec."Debtor To Receipt")
                {
                    ToolTip = 'Specifies the value of the Message To Receipt field.', Comment = '%';
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
                field("Debitor Branch Code"; Rec."Debitor Branch Code")
                {
                    ToolTip = 'Specifies the value of the Debitor Branch Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debitor ACH ID"; Rec."Debitor ACH ID")
                {
                    ToolTip = 'Specifies the value of the Debitor ACH ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor ABA Routing Code"; Rec."Debtor ABA Routing Code")
                {
                    ToolTip = 'Specifies the value of the Debtor ABA Routing Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Bank Account"; Rec."Creditor Bank Account")
                {
                    ToolTip = 'Specifies the value of the Creditor Bank Account field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Currency Code"; Rec."Creditor Currency Code")
                {
                    ToolTip = 'Specifies the value of the Creditor Currency Code field.', Comment = '%';
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
                field("Creditor Bank Acc Name"; Rec."Creditor Bank Acc Name")
                {
                    ToolTip = 'Specifies the value of the Creditor Bank Acc Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor IFSC Code"; Rec."Creditor IFSC Code")
                {
                    ToolTip = 'Specifies the value of the Creditor IFSC Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Swift Code"; Rec."Creditor Swift Code")
                {
                    ToolTip = 'Specifies the value of the Creditor Swift Code field.', Comment = '%';
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
                field("Creditor Address 3"; Rec."Creditor Address 3")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Creditor Address 3 field.';
                }
                field("Creditor Country"; Rec."Creditor Country")
                {
                    ToolTip = 'Specifies the value of the Creditor Country field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Branch Code"; Rec."Creditor Branch Code")
                {
                    ToolTip = 'Specifies the value of the Creditor Bank Branch Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor ACH ID"; Rec."Creditor ACH ID")
                {
                    ToolTip = 'Specifies the value of the Creditor ACH ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Inter. Bank Acc. No"; Rec."Creditor Inter. Bank Acc. No")
                {
                    ToolTip = 'Specifies the value of the Creditor Intermediary Bank Account No field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Inter. Bank Country"; Rec."Creditor Inter. Bank Country")
                {
                    ToolTip = 'Specifies the value of the Creditor Intermediary Bank Country field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Inter. Bank SWIFT"; Rec."Creditor Inter. Bank SWIFT")
                {
                    ToolTip = 'Specifies the value of the Creditor Intermediary Bank SWIFT field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("ABA/BSB No."; Rec."Creditor ABA/BSB No.")
                {
                    Caption = 'Creditor ABA BSB';
                    ToolTip = 'Specifies the value of the ABA/BSB No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor IBAN Account"; Rec."Creditor IBAN Account")
                {
                    ToolTip = 'Specifies the value of the Creditor IBAN Account field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Charge Bearer"; Rec."Charges Bearer")
                {
                    ToolTip = 'Specifies the value of the Charges Bearer field.';
                    ApplicationArea = All;
                }
                field("Payment Method Bank XML"; Rec."Payment Method Bank XML")
                {
                    ToolTip = 'Specifies the value of the Payment Method Bank XML field.', Comment = '%';
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
                field("Exchange Rate"; Rec."Exchange Rate")
                {
                    ToolTip = 'Specifies the value of the Exchange Rate field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Trans. Currency"; Rec."Trans. Currency")
                {
                    ToolTip = 'Specifies the value of the Trans. Currency field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Trans. Amt."; Rec."Trans. Amt.")
                {
                    ToolTip = 'Specifies the value of the Trans. Amt. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Word Link"; Rec."Word Link")
                {
                    ToolTip = 'Specifies the value of the Word Link field.', Comment = '%';
                    ApplicationArea = All;
                }
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
                field(Processed; Rec.Processed)
                {
                    ToolTip = 'Specifies the value of the Processed field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
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
                    NavigatePage.SetDoc(Rec."Posting Date", Rec."Bank Document No.");
                    NavigatePage.Run;
                end;
            }
            /* action(API)
            {
                ToolTip = 'Executes the API action.';
                ApplicationArea = All;
                Visible = false;
                trigger OnAction()
                var
                    CitiSetup: Record 50125;
                begin
                    Error('Not Allowed');
                    CitiSetup.Get();
                    CitiSetup."Citi API Base URL" := '';
                    CitiSetup."Citi Client Id" := '';
                    CitiSetup."Citi Payment Endpoint" := '';
                    CitiSetup."Citi Payment Status Endpoint" := '';
                    CitiSetup."Citi Statement Token Endpoint" := '';
                    CitiSetup."Citi Statment Init Endpoint" := '';
                    CitiSetup.Modify();
                    Codeunit.Run(Codeunit::"Citi Outbound API");
                end;
            } */
            action(SetUnprocessed)
            {
                Caption = 'Set unprocessed';
                Visible = ButtonVisible;
                ApplicationArea = All;

                trigger OnAction()
                var
                    Outbound: Record "Citi Outbound Staging Table";
                begin
                    if Outbound.Get(Rec."Bank Document No.")then begin
                        Outbound.Processed:=false;
                        Outbound.Modify();
                    end;
                end;
            }
            /* action(FxRate)
            {
                ToolTip = 'Executes the FxRate action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Codeunit.Run(Codeunit::"Worldlink Spot Rate Job");
                end;
            } */
            action(ProcessFailedLines)
            {
                Caption = 'Process Failed Lines';
                ApplicationArea = all;
                Image = Process;
                ToolTip = 'Executes the Process Failed Lines action.';
                Visible = ButtonVisible;

                trigger OnAction()
                begin
                    MoveRejectLines();
                end;
            }
            action(MockXML)
            {
                Caption = 'Mock XML';
                ApplicationArea = all;
                Visible = ButtonVisible;
                ToolTip = 'Executes the Mock XML action.';

                trigger OnAction()
                begin
                    GenXML();
                end;
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
    local procedure GenXML()
    var
        Citi403: XmlPort "Citi 403 XML";
        Citi949: XmlPort "Citi 949 XML";
        Citi393: XmlPort "Citi 393 XML";
        Citi392: XmlPort "Citi 392 XML";
        Citi391: XmlPort "Citi 391 XML";
        OutStream: OutStream;
        InStream: InStream;
        l_TempBlob: Codeunit "Temp Blob";
        l_txt_XML: Text;
        l_rec_Outbound: Record "Citi Outbound Staging Table";
    begin
        Clear(l_TempBlob);
        l_TempBlob.CreateOutStream(OutStream);
        l_TempBlob.CreateInStream(InStream);
        l_rec_Outbound.SetRange("Bank Document No.", Rec."Bank Document No.");
        l_rec_Outbound.FindFirst();
        case l_rec_Outbound."Batch Type" of l_rec_Outbound."Batch Type"::CITI403: begin
            Citi403.SetRecord(l_rec_Outbound);
            Citi403.SetTableView(l_rec_Outbound);
            Citi403.SetDestination(OutStream);
            Citi403.Export();
        end;
        l_rec_Outbound."Batch Type"::CITI949: begin
            Citi949.SetRecord(l_rec_Outbound);
            Citi949.SetTableView(l_rec_Outbound);
            Citi949.SetDestination(OutStream);
            Citi949.Export();
        end;
        l_rec_Outbound."Batch Type"::CITI393: begin
            Citi393.SetRecord(l_rec_Outbound);
            Citi393.SetTableView(l_rec_Outbound);
            Citi393.SetDestination(OutStream);
            Citi393.Export();
        end;
        l_rec_Outbound."Batch Type"::CITI391: begin
            Citi391.SetRecord(l_rec_Outbound);
            Citi391.SetTableView(l_rec_Outbound);
            Citi391.SetDestination(OutStream);
            Citi391.Export();
        end;
        l_rec_Outbound."Batch Type"::CITI392: begin
            Citi392.SetRecord(l_rec_Outbound);
            Citi392.SetTableView(l_rec_Outbound);
            Citi392.SetDestination(OutStream);
            Citi392.Export();
        end;
        end;
        InStream.Read(l_txt_XML);
        Message(l_txt_XML);
    end;
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
        CitiOutbound: Record "Citi Outbound Staging Table";
        FromGenJnlBatch: Record "Gen. Journal Batch";
        FromGenJnlLine: Record "Gen. Journal Line";
        ToGenJnlLine: Record "Gen. Journal Line";
        LineNo: Integer;
    begin
        LineNo:=0;
        Clear(ToGenJnlBatch);
        CitiOutbound.Reset();
        CitiOutbound.SetCurrentKey("Bank Integration Type", "Batch Type", "Batch Id");
        CitiOutbound.SetRange("Bank Integration Type", CitiOutbound."Bank Integration Type"::Citi);
        CitiOutbound.SetRange(Status, CitiOutbound.Status::Fail);
        if CitiOutbound.FindSet()then repeat FromGenJnlLine.Reset();
                FromGenJnlLine.SetRange("Batch Type", CitiOutbound."Batch Type");
                FromGenJnlLine.SetRange("Batch No.", CitiOutbound."Batch Id");
                FromGenJnlLine.SetRange("Document No.", CitiOutbound."Document No.");
                if FromGenJnlLine.FindFirst()then begin
                    repeat LineNo+=10000;
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
                    until FromGenJnlLine.Next() = 0 end;
            until CitiOutbound.Next() = 0;
    end;
    var ToGenJnlBatch: Record "Gen. Journal Batch";
    ButtonVisible: Boolean;
    trigger OnOpenPage()
    var
        tmp: Text;
    begin
        ButtonVisible:=false;
        tmp:=UserId;
        tmp:=tmp.ToUpper();
        if tmp.Contains('TECTURA')then ButtonVisible:=true;
    end;
}
