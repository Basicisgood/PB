page 50244 "PB Central Payment History"
{
    ApplicationArea = All;
    Caption = 'Central Payment/Receipt History List';
    PageType = List;
    SourceTable = "PB Central Payment History";
    UsageCategory = Administration;
    Editable = true;
    DeleteAllowed = false;
    ModifyAllowed = true;
    InsertAllowed = false;

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
                    Editable = isEditAllowed;
                }
                field("Parent Entry No."; Rec."Parent Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    Editable = isEditAllowed;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                    Editable = isEditAllowed;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                    Editable = isEditAllowed;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    Editable = isEditAllowed;
                }
                field("Source Company"; Rec."Source Company")
                {
                    ToolTip = 'Specifies the value of the Source Company field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = isEditAllowed;
                }
                field("Source Document No"; Rec."Source Document No")
                {
                    ToolTip = 'Specifies the value of the Source Document No field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = isEditAllowed;
                }
                field("Source Gl Entry Document No"; Rec."Source Gl Entry Document No")
                {
                    ApplicationArea = all;
                    Editable = isEditAllowed;
                }
                field("Creation DatenTime"; Rec."Creation DatenTime")
                {
                    ToolTip = 'Specifies the value of the Creation DatenTime field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = isEditAllowed;
                }
                field("Target Company"; Rec."Target Company")
                {
                    ToolTip = 'Specifies the value of the Target Company field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = isEditAllowed;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = isEditAllowed;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = isEditAllowed;
                }
                field("Document Amount"; Rec."Document Amount")
                {
                    ApplicationArea = all;
                    Editable = isEditAllowed;
                }
                field("Over Receipt Amount"; Rec."Over Receipt Amount")
                {
                    ApplicationArea = all;
                    Editable = isEditAllowed;
                }
                field("Document Over Receipt Amount"; Rec."Document Over Receipt Amount")
                {
                    ApplicationArea = all;
                    Editable = isEditAllowed;
                }
                field("Bank Charges"; Rec."Bank Charges")
                {
                    ApplicationArea = all;
                    Editable = isEditAllowed;
                }
                field("Document Bank Charges Amount"; Rec."Document Bank Charges Amount")
                {
                    ApplicationArea = all;
                    Editable = isEditAllowed;
                }
                field("Exchange Rate"; Rec."Exchange Rate")
                {
                    ApplicationArea = all;
                    Editable = isEditAllowed;
                }
                field("Applied Document No."; Rec."Applied Document No.")
                {
                    ToolTip = 'Specifies the value of the Applied Document No. field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = isEditAllowed;
                }
                field("Bank Document No."; Rec."Bank Document No.")
                {
                    ApplicationArea = all;
                    Editable = isEditAllowed;
                }
                field("Invoice External No."; Rec."Invoice External No.")
                {
                    ApplicationArea = all;
                    Editable = isEditAllowed;
                }
                field("Source Processed Document No."; Rec."Source Processed Document No.")
                {
                    ToolTip = 'Specifies the value of the Processed Document No. field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = isEditAllowed;
                }
                field("Target Processed Document No."; Rec."Target Processed Document No.")
                {
                    ApplicationArea = all;
                    Editable = isEditAllowed;
                }
                field("Bank ID"; Rec."Bank ID")
                {
                    ApplicationArea = all;
                    Editable = isEditAllowed;
                }
                field("IMOS Transaction No"; Rec."IMOS Transaction No")
                {
                    ApplicationArea = all;
                    Editable = isEditAllowed;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = isEditAllowed;
                }
                field("Error Description"; Rec."Error Description")
                {
                    ToolTip = 'Specifies the value of the Error Description field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = isEditAllowed;
                }
                field("Processed DatenTime"; Rec."Processed DatenTime")
                {
                    ToolTip = 'Specifies the value of the Processed DatenTime field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = isEditAllowed;
                }
                field("Gen Jnl Line GUIID"; Rec."Gen Jnl Line GUIID")
                {
                    ApplicationArea = all;
                    Editable = isEditAllowed;
                }
                field("Posted in Source Company"; Rec."Posted in Source Company")
                {
                    ApplicationArea = all;
                    Editable = isEditAllowed;
                }
                field("Posted in Target Company"; Rec."Posted in Target Company")
                {
                    ApplicationArea = all;
                    Editable = isEditAllowed;
                }
                field("Source Entry Closed"; Rec."Source Entry Closed")
                {
                    ApplicationArea = all;
                    Editable = isEditAllowed;
                }
            }
        }
    }
    var isEditAllowed: Boolean;
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        isEditAllowed:=false;
        if UserSetup.Get(UserId)then begin
            isEditAllowed:=UserSetup."Allow Inbound Edit/Delete";
        end;
    end;
}
