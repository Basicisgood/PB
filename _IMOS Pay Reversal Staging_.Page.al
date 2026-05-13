page 50237 "IMOS Pay Reversal Staging"
{
    ApplicationArea = All;
    Caption = 'IMOS Pay Reversal Staging';
    PageType = List;
    SourceTable = "IMOS Payment Reversal Staging";
    UsageCategory = Lists;
    InsertAllowed = false;
    //ModifyAllowed = false;
    DeleteAllowed = true;
    Editable = true;

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
                field("BC Company Code"; Rec."BC Company Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Payment Transaction No."; Rec."Payment Transaction No.")
                {
                    ToolTip = 'Specifies the value of the Payment Transaction No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Posted Document No"; Rec."Posted Document No")
                {
                    ToolTip = 'Specifies the value of the Posted Document No field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Vendor External Reference"; Rec."Vendor External Reference")
                {
                    ToolTip = 'Specifies the value of the Vendor External Reference field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ToolTip = 'Specifies the value of the Vendor Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Vendor No"; Rec."Vendor No")
                {
                    ToolTip = 'Specifies the value of the Vendor No field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Payment Transaction Type"; Rec."Payment Transaction Type")
                {
                    ToolTip = 'Specifies the value of the Payment Transaction Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("External Reference Id"; Rec."External Reference Id")
                {
                    ToolTip = 'Specifies the value of the External Reference Id field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Error Description"; Rec."Error Description")
                {
                    ApplicationArea = all;
                }
                field("Act Date"; Rec."Act Date")
                {
                    ToolTip = 'Specifies the value of the Act Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Approval; Rec.Approval)
                {
                    ToolTip = 'Specifies the value of the Approval field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Bank Amount"; Rec."Bank Amount")
                {
                    ToolTip = 'Specifies the value of the Bank Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Bank Charge"; Rec."Bank Charge")
                {
                    ToolTip = 'Specifies the value of the Bank Charge field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    ToolTip = 'Specifies the value of the Bank Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Bank Currency"; Rec."Bank Currency")
                {
                    ToolTip = 'Specifies the value of the Bank Currency field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Bank Exch Rate"; Rec."Bank Exch Rate")
                {
                    ToolTip = 'Specifies the value of the Bank Exch Rate field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ToolTip = 'Specifies the value of the Bank Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Bank Short Name"; Rec."Bank Short Name")
                {
                    ToolTip = 'Specifies the value of the Bank Short Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Base Currency Amount"; Rec."Base Currency Amount")
                {
                    ToolTip = 'Specifies the value of the Base Currency Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Cancelled Datentime"; Rec."Cancelled Datentime")
                {
                    ToolTip = 'Specifies the value of the Cancelled Datentime field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Cancelled by user"; Rec."Cancelled by user")
                {
                    ToolTip = 'Specifies the value of the Cancelled by user field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Currency; Rec.Currency)
                {
                    ToolTip = 'Specifies the value of the Currency field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Currency Amount"; Rec."Currency Amount")
                {
                    ToolTip = 'Specifies the value of the Currency Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Entry Date"; Rec."Entry Date")
                {
                    ToolTip = 'Specifies the value of the Entry Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Exchage Rate Date"; Rec."Exchage Rate Date")
                {
                    ToolTip = 'Specifies the value of the Exchage Rate Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Exchange Rate"; Rec."Exchange Rate")
                {
                    ToolTip = 'Specifies the value of the Exchange Rate field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Intercompany Code"; Rec."Intercompany Code")
                {
                    ToolTip = 'Specifies the value of the Intercompany Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Last User ID"; Rec."Last User ID")
                {
                    ToolTip = 'Specifies the value of the Last User ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Memo; Rec.Memo)
                {
                    ToolTip = 'Specifies the value of the Memo field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Other Charges"; Rec."Other Charges")
                {
                    ToolTip = 'Specifies the value of the Other Charges field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Other Charges Code"; Rec."Other Charges Code")
                {
                    ToolTip = 'Specifies the value of the Other Charges Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                    ToolTip = 'Specifies the value of the Payment Mode field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Payment Mode No"; Rec."Payment Mode No")
                {
                    ToolTip = 'Specifies the value of the Payment Mode No field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Vendor Coross Reference"; Rec."Vendor Coross Reference")
                {
                    ToolTip = 'Specifies the value of the Vendor Coross Reference field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Vendor Counry"; Rec."Vendor Counry")
                {
                    ToolTip = 'Specifies the value of the Vendor Counry field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Vendor Country Code"; Rec."Vendor Country Code")
                {
                    ToolTip = 'Specifies the value of the Vendor Country Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Vendor Reference Code"; Rec."Vendor Reference Code")
                {
                    ToolTip = 'Specifies the value of the Vendor Reference Code field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
            part(invoiceLines;50261)
            {
                SubPageLink = "Reverse Entry No."=field("Entry No.");
                ApplicationArea = All;
            }
            part(postingDetails;50258)
            {
                SubPageLink = "Entry No."=field("Entry No.");
                ApplicationArea = All;
            }
        }
    }
}
