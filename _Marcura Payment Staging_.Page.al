page 50276 "Marcura Payment Staging"
{
    ApplicationArea = All;
    Caption = 'Marcura Payment Staging';
    PageType = List;
    SourceTable = "Marcura Payment Staging";
    UsageCategory = Lists;
    Editable = true;
    //DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field(DAID; Rec.DAID)
                {
                    ToolTip = 'Specifies the value of the DAID field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Interface Unique Reference No"; Rec."Interface Unique Reference No")
                {
                    ToolTip = 'Specifies the value of the Interface Unique Reference No field.', Comment = '%';
                }
                field("BC Company Code"; Rec."BC Company Code")
                {
                    Caption = 'Source Company';
                }
                field("BC  Bank Code"; Rec."BC  Bank Code")
                {
                }
                field("Target Company Code"; Rec."Target Company Code")
                {
                }
                field("Account Type"; Rec."Account Type")
                {
                }
                field("Customer/Vendor No"; Rec."Customer/Vendor No")
                {
                }
                field("Vendor Type"; Rec."Vendor Type")
                {
                }
                field("IMOS Reference No."; Rec."IMOS Reference No.")
                {
                    ToolTip = 'Specifies the value of the IMOS Reference No. field.', Comment = '%';
                }
                field("IMOS Transaction ID"; Rec."IMOS Transaction ID")
                {
                    ToolTip = 'Specifies the value of the IMOS Transaction ID field.', Comment = '%';
                }
                field("Vendor Bank Country Code"; Rec."Vendor Bank Country Code")
                {
                    ToolTip = 'Specifies the value of the Vendor Bank Country Code field.', Comment = '%';
                }
                field("BC Document No"; Rec."BC Document No")
                {
                }
                field("Payment Amount"; Rec."Payment Amount")
                {
                    ToolTip = 'Specifies the value of the Payment Amount field.', Comment = '%';
                }
                field("Payment Currency"; Rec."Payment Currency")
                {
                    ToolTip = 'Specifies the value of the Payment Currency field.', Comment = '%';
                }
                field("Counter Party Reference No."; Rec."Counter Party Reference No.")
                {
                    ToolTip = 'Specifies the value of the Counter Party Reference No. field.', Comment = '%';
                }
                field("Debit Account Familiar Name"; Rec."Debit Account Familiar Name")
                {
                    ToolTip = 'Specifies the value of the Debit Account Familiar Name field.', Comment = '%';
                }
                field("Debit Account IBAN"; Rec."Debit Account IBAN")
                {
                    ToolTip = 'Specifies the value of the Debit Account IBAN field.', Comment = '%';
                }
                field("Debit Account Name"; Rec."Debit Account Name")
                {
                    ToolTip = 'Specifies the value of the Debit Account Name field.', Comment = '%';
                }
                field("Debit Account No."; Rec."Debit Account No.")
                {
                    ToolTip = 'Specifies the value of the Debit Account No. field.', Comment = '%';
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ToolTip = 'Specifies the value of the Debit Amount field.', Comment = '%';
                }
                field("Debit Currency"; Rec."Debit Currency")
                {
                    ToolTip = 'Specifies the value of the Debit Currency field.', Comment = '%';
                }
                field("Payment Execution Date"; Rec."Payment Execution Date")
                {
                    ToolTip = 'Specifies the value of the Payment Execution Date field.', Comment = '%';
                }
                field("Payment Type Description"; Rec."Payment Type Description")
                {
                    ToolTip = 'Specifies the value of the Payment Type Description field.', Comment = '%';
                }
                field("Payment Type ID"; Rec."Payment Type ID")
                {
                    ToolTip = 'Specifies the value of the Payment Type ID field.', Comment = '%';
                }
                field("Reference No."; Rec."Reference No.")
                {
                    ToolTip = 'Specifies the value of the Reference No. field.', Comment = '%';
                }
                field("Transaction Id"; Rec."Transaction Id")
                {
                    ToolTip = 'Specifies the value of the Transaction Id field.', Comment = '%';
                }
                field("Value Date"; Rec."Value Date")
                {
                    ToolTip = 'Specifies the value of the Value Date field.', Comment = '%';
                }
                field("Bank Reference"; Rec."Bank Reference")
                {
                    ToolTip = 'Specifies the value of the Bank Reference field.', Comment = '%';
                }
                field("Bank Statement Date"; Rec."Bank Statement Date")
                {
                    ToolTip = 'Specifies the value of the Bank Statement Date field.', Comment = '%';
                }
                field("Bank Exchange Rate"; Rec."Bank Exchange Rate")
                {
                    ToolTip = 'Specifies the value of the Bank Exchange Rate field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                }
                field("Error Description"; Rec."Error Description")
                {
                }
                field("Cancelled By"; Rec."Cancelled By")
                {
                }
                field("Cancelled Datetime"; Rec."Cancelled Datetime")
                {
                }
                field("Posted Document No"; Rec."Posted Document No")
                {
                    caption = 'Payment Journal Document No.';
                    ToolTip = 'Specifies the value of the Payment Journal Document No. field.', Comment = '%';
                }
                field("Central Payment Entry No."; Rec."Central Payment Entry No.")
                {
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ProcessLine)
            {
                ApplicationArea = All;
                Caption = 'Cancel Line';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                begin
                    if(Rec.Status = rec.Status::Error) or (Rec.Status = rec.Status::Pending)then begin
                        Rec.Status:=Rec.Status::Cancel;
                        rec."Error Description":='';
                        Rec."Cancelled By":=UserId();
                        Rec."Cancelled Datetime":=CurrentDateTime();
                        Rec.Modify(true);
                    end
                    else
                        Error('Only lines with status Error or Pending can be cancelled.');
                end;
            }
        }
    }
}
