page 50270 "Port Payable Staging List"
{
    ApplicationArea = All;
    Caption = 'Port Payable Staging List';
    PageType = List;
    SourceTable = "Port Payable Staging";
    UsageCategory = Tasks;
    InsertAllowed = false;
    //Editable = false;
    ModifyAllowed = false;
    DeleteAllowed = true;

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
                field("Line No"; Rec."Line No")
                {
                    ToolTip = 'Specifies the value of the Line No field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ToolTip = 'Specifies the value of the Account Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("BC Bank Code"; Rec."BC Bank Code")
                {
                    ToolTip = 'Specifies the value of the BC Bank Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Amount (Lcy)"; Rec."Amount (Lcy)")
                {
                    ToolTip = 'Specifies the value of the Amount (Lcy) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Currency Factor"; Rec."Currency Factor")
                {
                    ToolTip = 'Specifies the value of the Currency Factor field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
                {
                    ToolTip = 'Specifies the value of the Applies-to Doc. Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
                {
                    ToolTip = 'Specifies the value of the Applies-to Doc. No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Company Code"; Rec."Company Code")
                {
                    ToolTip = 'Specifies the value of the Company Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Bank Document No."; Rec."Bank Document No.")
                {
                    ToolTip = 'Specifies the value of the Bank Document No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ToolTip = 'Specifies the value of the External Document No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("IMOS Bank ID"; Rec."IMOS Bank ID")
                {
                    ToolTip = 'Specifies the value of the IMOS Bank ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("IMOS Transaction No"; Rec."IMOS Transaction No")
                {
                    ToolTip = 'Specifies the value of the IMOS Transaction No field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(FD1_Subsegment; Rec.FD1_Subsegment)
                {
                    ToolTip = 'Specifies the value of the FD1_Subsegment field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(FD2_VesselName; Rec.FD2_VesselName)
                {
                    ToolTip = 'Specifies the value of the FD2_VesselName field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(FD3_VoyageNumber; Rec.FD3_VoyageNumber)
                {
                    ToolTip = 'Specifies the value of the FD3_VoyageNumber field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(FD4_CharterIn; Rec.FD4_CharterIn)
                {
                    ToolTip = 'Specifies the value of the FD4_CharterIn field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(FD5_Department; Rec.FD5_Department)
                {
                    ToolTip = 'Specifies the value of the FD5_Department field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(FD6_Employee; Rec.FD6_Employee)
                {
                    ToolTip = 'Specifies the value of the FD6_Employee field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(FD7_Location; Rec.FD7_Location)
                {
                    ToolTip = 'Specifies the value of the FD7_Location field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(FD8_Company; Rec.FD8_Company)
                {
                    ToolTip = 'Specifies the value of the FD8_Company field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(FD9_CounterParty; Rec.FD9_CounterParty)
                {
                    ToolTip = 'Specifies the value of the FD9_CounterParty field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(FD10_JType; Rec.FD10_JType)
                {
                    ToolTip = 'Specifies the value of the FD10_JType field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("DNV Ship Manager ID"; Rec."DNV Ship Manager ID")
                {
                    ToolTip = 'Specifies the value of the DNV Ship Manager ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Posted Document No."; Rec."Posted Document No.")
                {
                    ApplicationArea = All;
                }
                field("CP Entry No"; Rec."CP Entry No")
                {
                    ApplicationArea = All;
                }
                field("File Name"; Rec."File Name")
                {
                    ToolTip = 'Specifies the value of the File Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Imported By"; Rec."Imported By")
                {
                    ToolTip = 'Specifies the value of the Imported By field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Import Date n Time"; Rec."Import Date n Time")
                {
                    ToolTip = 'Specifies the value of the Import Date n Time field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Import)
            {
                ApplicationArea = All;
                Caption = 'Import';
                Image = Excel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ImportPortPayable: Report "Import Port Payable rom Excel";
                begin
                    ImportPortPayable.RunModal();
                end;
            }
            action(ProcessLine)
            {
                ApplicationArea = All;
                Caption = 'Process';
                Image = PostDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                begin
                    Message('Post');
                end;
            }
        }
    }
}
