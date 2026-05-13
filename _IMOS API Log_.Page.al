page 50136 "IMOS API Log"
{
    ApplicationArea = All;
    Caption = 'IMOS Outbound Log';
    PageType = List;
    SourceTable = "IMOS API Log";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Company Code"; Rec."Company Code")
                {
                    ApplicationArea = All;
                }
                field("Table No."; Rec."Table No.")
                {
                    ApplicationArea = All;
                }
                field("Primary key"; Rec."Primary key")
                {
                    ApplicationArea = All;
                }
                field("Primary key 2"; Rec."Primary key 2") //IMOS Integration
                {
                    ToolTip = 'Specifies the value of the Primary key 2 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Primary key 3"; Rec."Primary key 3")
                {
                    ToolTip = 'Specifies the value of the Primary key 3 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Primary key 4"; Rec."Primary key 4")
                {
                    ToolTip = 'Specifies the value of the Primary key 4 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("IMOS Transaction No"; Rec."IMOS Transaction No")
                {
                    ApplicationArea = all;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                }
                field("Sent Date Time"; Rec."Sent Date Time")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Payment Amount"; Rec."Payment Amount")
                {
                    ApplicationArea = All;
                }
                field("Payment Amount LCY"; Rec."Payment Amount LCY")
                {
                    ApplicationArea = all;
                }
                field("Currency Factor"; Rec."Currency Factor")
                {
                    ApplicationArea = all;
                }
                field("Over Receipt Amount"; Rec."Over Receipt Amount")
                {
                    ApplicationArea = All;
                }
                field("Bank ID"; Rec."Bank ID")
                {
                    ApplicationArea = All;
                }
                field("Bank Charge Amount"; Rec."Bank Charge Amount")
                {
                    ApplicationArea = All;
                }
                field("Invoice List"; Rec."Invoice List")
                {
                    ApplicationArea = all;
                }
                field(Response; Rec.Response)
                {
                    ApplicationArea = all;
                }
                field("XML Data"; Rec."XML Data")
                {
                    ApplicationArea = all;
                }
                field("Bank Document No."; Rec."Bank Document No.")
                {
                    ApplicationArea = all;
                }
                field("Document No Suffix"; Rec."Document No Suffix")
                {
                    ApplicationArea = all;
                }
                field("Currency Exch Start Date"; Rec."Currency Exch Start Date")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}
