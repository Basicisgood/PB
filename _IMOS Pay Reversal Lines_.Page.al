page 50261 "IMOS Pay Reversal Lines"
{
    ApplicationArea = All;
    Caption = 'IMOS Pay Reversal Lines';
    PageType = ListPart;
    SourceTable = "IMOS Payment Reversal Line";
    UsageCategory = None;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Payment Transaction No"; Rec."Payment Transaction No")
                {
                    ToolTip = 'Specifies the value of the Payment Transaction No field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Company Code"; Rec."Company Code")
                {
                    ToolTip = 'Specifies the value of the Company Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Transaction No"; Rec."Transaction No")
                {
                    ToolTip = 'Specifies the value of the Transaction No field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Transaction type"; Rec."Transaction type")
                {
                    ToolTip = 'Specifies the value of the Transaction type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Act Date"; Rec."Act Date")
                {
                    ToolTip = 'Specifies the value of the Act Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Aparcode; Rec.Aparcode)
                {
                    ToolTip = 'Specifies the value of the Aparcode field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    ToolTip = 'Specifies the value of the Bank Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Base Currency Amount"; Rec."Base Currency Amount")
                {
                    ToolTip = 'Specifies the value of the Base Currency Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("COA No."; Rec."COA No.")
                {
                    ToolTip = 'Specifies the value of the COA No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Company External reference No"; Rec."Company External reference No")
                {
                    ToolTip = 'Specifies the value of the Company External reference No field.', Comment = '%';
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
                field("Due Date"; Rec."Due Date")
                {
                    ToolTip = 'Specifies the value of the Due Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Entry Datetime"; Rec."Entry Datetime")
                {
                    ToolTip = 'Specifies the value of the Entry Datetime field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Exchange Rate"; Rec."Exchange Rate")
                {
                    ToolTip = 'Specifies the value of the Exchange Rate field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Invoice Date"; Rec."Invoice Date")
                {
                    ToolTip = 'Specifies the value of the Invoice Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Invoice No"; Rec."Invoice No")
                {
                    ToolTip = 'Specifies the value of the Invoice No field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Last User ID"; Rec."Last User ID")
                {
                    ToolTip = 'Specifies the value of the Last User ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Line No"; Rec."Line No")
                {
                    ToolTip = 'Specifies the value of the Line No field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Lob; Rec.Lob)
                {
                    ToolTip = 'Specifies the value of the Lob field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Memo; Rec.Memo)
                {
                    ToolTip = 'Specifies the value of the Memo field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Opr Type"; Rec."Opr Type")
                {
                    ToolTip = 'Specifies the value of the Opr Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Port Country code"; Rec."Port Country code")
                {
                    ToolTip = 'Specifies the value of the Port Country code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Port Name"; Rec."Port Name")
                {
                    ToolTip = 'Specifies the value of the Port Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Port No"; Rec."Port No")
                {
                    ToolTip = 'Specifies the value of the Port No field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Port UN Code"; Rec."Port UN Code")
                {
                    ToolTip = 'Specifies the value of the Port UN Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Posted Document No."; Rec."Posted Document No.")
                {
                    ToolTip = 'Specifies the value of the Posted Document No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Reverse Entry No."; Rec."Reverse Entry No.")
                {
                    ToolTip = 'Specifies the value of the Reverse Entry No. field.', Comment = '%';
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
                field("Trasaction Sequence"; Rec."Trasaction Sequence")
                {
                    ToolTip = 'Specifies the value of the Trasaction Sequence field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Vendor External Reference No"; Rec."Vendor External Reference No")
                {
                    ToolTip = 'Specifies the value of the Vendor External Reference No field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Vessel Code"; Rec."Vessel Code")
                {
                    ToolTip = 'Specifies the value of the Vessel Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Vessel Cross Reference No"; Rec."Vessel Cross Reference No")
                {
                    ToolTip = 'Specifies the value of the Vessel Cross Reference No field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Vessel External Reference No"; Rec."Vessel External Reference No")
                {
                    ToolTip = 'Specifies the value of the Vessel External Reference No field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Vessel Name"; Rec."Vessel Name")
                {
                    ToolTip = 'Specifies the value of the Vessel Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Voyage No"; Rec."Voyage No")
                {
                    ToolTip = 'Specifies the value of the Voyage No field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Voyege Reference"; Rec."Voyege Reference")
                {
                    ToolTip = 'Specifies the value of the Voyege Reference field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
