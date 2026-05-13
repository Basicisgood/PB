page 50268 "CitiOutboundStaging_WS"
{
    Caption = 'CitiOutboundStaging_WS';
    PageType = List;
    SourceTable = "Citi Outbound Staging Table";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("API Information"; Rec."API Information")
                {
                    ToolTip = 'Specifies the value of the API Information field.';
                    ApplicationArea = All;
                }
                field("API Status"; Rec."API Status")
                {
                    ToolTip = 'Specifies the value of the API Status field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ToolTip = 'Specifies the value of the Account Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Applied Entries to XML"; Rec."Applied Entries to XML")
                {
                    ToolTip = 'Specifies the value of the Applied Entries to XML field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ToolTip = 'Specifies the value of the Bal. Account No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ToolTip = 'Specifies the value of the Bal. Account Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Bank Document No."; Rec."Bank Document No.")
                {
                    ToolTip = 'Specifies the value of the Bank Document No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Bank Integration Type"; Rec."Bank Integration Type")
                {
                    ToolTip = 'Specifies the value of the Bank Integration Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Batch Id"; Rec."Batch Id")
                {
                    ToolTip = 'Specifies the value of the Batch Id field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Batch Type"; Rec."Batch Type")
                {
                    ToolTip = 'Specifies the value of the Batch Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Charges Bearer"; Rec."Charges Bearer")
                {
                    ToolTip = 'Specifies the value of the Charges Bearer field.';
                    ApplicationArea = All;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ToolTip = 'Specifies the value of the Country/Region Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Create Date"; Rec."Create Date")
                {
                    ToolTip = 'Specifies the value of the Create Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Create Date Time"; Rec."Create Date Time")
                {
                    ToolTip = 'Specifies the value of the Create Date Time field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor ABA/BSB No."; Rec."Creditor ABA/BSB No.")
                {
                    ToolTip = 'Specifies the value of the ABA/BSB No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Address"; Rec."Creditor Address")
                {
                    ToolTip = 'Specifies the value of the Creditor Address field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Address 2"; Rec."Creditor Address 2")
                {
                    ToolTip = 'Specifies the value of the Creditor Address 2 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Address 3"; Rec."Creditor Address 3")
                {
                    ToolTip = 'Specifies the value of the Creditor Address 3 field.';
                    ApplicationArea = All;
                }
                field("Creditor Bank Acc Name"; Rec."Creditor Bank Acc Name")
                {
                    ToolTip = 'Specifies the value of the Creditor Bank Acc Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Bank Account"; Rec."Creditor Bank Account")
                {
                    ToolTip = 'Specifies the value of the Creditor Bank Account field.', Comment = '%';
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
                field("Creditor Branch Code"; Rec."Creditor Branch Code")
                {
                    ToolTip = 'Specifies the value of the Creditor Bank Branch Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Country"; Rec."Creditor Country")
                {
                    ToolTip = 'Specifies the value of the Creditor Country field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Currency Code"; Rec."Creditor Currency Code")
                {
                    ToolTip = 'Specifies the value of the Creditor Currency Code field.', Comment = '%';
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
                field("Creditor IBAN Account"; Rec."Creditor IBAN Account")
                {
                    ToolTip = 'Specifies the value of the Creditor IBAN Account field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor IFSC Code"; Rec."Creditor IFSC Code")
                {
                    ToolTip = 'Specifies the value of the Creditor IFSC Code field.', Comment = '%';
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
                field("Creditor Post Code"; Rec."Creditor Post Code")
                {
                    ToolTip = 'Specifies the value of the Creditor Post Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor Swift Code"; Rec."Creditor Swift Code")
                {
                    ToolTip = 'Specifies the value of the Creditor Swift Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Currency; Rec.Currency)
                {
                    ToolTip = 'Specifies the value of the Currency field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debitor ACH ID"; Rec."Debitor ACH ID")
                {
                    ToolTip = 'Specifies the value of the Debitor ACH ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debitor Bank Clearing Code"; Rec."Debitor Bank Clearing Code")
                {
                    ToolTip = 'Specifies the value of the Debitor Bank Clearing Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debitor Branch Code"; Rec."Debitor Branch Code")
                {
                    ToolTip = 'Specifies the value of the Debitor Branch Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor ABA Routing Code"; Rec."Debtor ABA Routing Code")
                {
                    ToolTip = 'Specifies the value of the Debtor ABA Routing Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor ACH ID"; Rec."Debtor ACH ID")
                {
                    ToolTip = 'Specifies the value of the Debtor ACH ID field.', Comment = '%';
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
                field("Debtor Bank Acc Name"; Rec."Debtor Bank Acc Name")
                {
                    ToolTip = 'Specifies the value of the Debtor Bank Acc Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor Bank Account"; Rec."Debtor Bank Account")
                {
                    ToolTip = 'Specifies the value of the Debtor Bank Account field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor Bank Address"; Rec."Debtor Bank Address")
                {
                    ToolTip = 'Specifies the value of the Debtor Bank Address field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor Bank Address 2"; Rec."Debtor Bank Address 2")
                {
                    ToolTip = 'Specifies the value of the Debtor Bank Address field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor Bank Clearing Code"; Rec."Debtor Bank Clearing Code")
                {
                    ToolTip = 'Specifies the value of the Debtor Bank Clearing Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor Bank Country"; Rec."Debtor Bank Country")
                {
                    ToolTip = 'Specifies the value of the Debtor Bank Country field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor Bank Post Code"; Rec."Debtor Bank Post Code")
                {
                    ToolTip = 'Specifies the value of the Debtor Bank Post Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor Country"; Rec."Debtor Country")
                {
                    ToolTip = 'Specifies the value of the Debtor Country field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor Currency Code"; Rec."Debtor Currency Code")
                {
                    ToolTip = 'Specifies the value of the Debtor Currency Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor Name"; Rec."Debtor Name")
                {
                    ToolTip = 'Specifies the value of the Debtor Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor Post Code"; Rec."Debtor Post Code")
                {
                    ToolTip = 'Specifies the value of the Debtor Post Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor SWIFT Code"; Rec."Debtor SWIFT Code")
                {
                    ToolTip = 'Specifies the value of the Debtor SWIFT Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debtor To Receipt"; Rec."Debtor To Receipt")
                {
                    ToolTip = 'Specifies the value of the Message To Receipt field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Exchange Rate"; Rec."Exchange Rate")
                {
                    ToolTip = 'Specifies the value of the Exchange Rate field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("FPS No."; Rec."FPS No.")
                {
                    ToolTip = 'Specifies the value of the FPS No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("FPS Type"; Rec."FPS Type")
                {
                    ToolTip = 'Specifies the value of the FPS Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Identification; Rec.Identification)
                {
                    ToolTip = 'Specifies the value of the Identification field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Instruction to Bank"; Rec."Instruction to Bank")
                {
                    ToolTip = 'Specifies the value of the Instruction to Bank field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ToolTip = 'Specifies the value of the Journal Batch Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ToolTip = 'Specifies the value of the Journal Template Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Payment Method"; Rec."Payment Method")
                {
                    ToolTip = 'Specifies the value of the Payment Method field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Payment Method Bank XML"; Rec."Payment Method Bank XML")
                {
                    ToolTip = 'Specifies the value of the Payment Method Bank XML field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Payment Purpose"; Rec."Payment Purpose")
                {
                    ToolTip = 'Specifies the value of the Payment Purpose field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Payment Reference No."; Rec."Payment Reference No.")
                {
                    ToolTip = 'Specifies the value of the Payment Reference No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(PaymentID; Rec.PaymentID)
                {
                    ToolTip = 'Specifies the value of the PaymentID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Processed; Rec.Processed)
                {
                    ToolTip = 'Specifies the value of the Processed field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Purpose Code"; Rec."Purpose Code")
                {
                    ToolTip = 'Specifies the value of the Purpose Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Service Level"; Rec."Service Level")
                {
                    ToolTip = 'Specifies the value of the Service Level field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ToolTip = 'Specifies the value of the Source Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
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
                field("Trigger API"; Rec."Trigger API")
                {
                    ToolTip = 'Specifies the value of the Trigger API field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Word Link"; Rec."Word Link")
                {
                    ToolTip = 'Specifies the value of the Word Link field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
