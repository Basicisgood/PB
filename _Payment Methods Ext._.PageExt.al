pageextension 50135 "Payment Methods Ext." extends "Payment Methods"
{
    layout
    {
        addafter("Bal. Account No.")
        {
            field("Batch Type"; Rec."Batch Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Batch Type field.', Comment = '%';
            }
            field("Payment Method Bank XML"; Rec."Payment Method Bank XML")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Payment Method Bank XML field.', Comment = '%';
            }
            field("Trans. Currency"; Rec."Trans. Currency")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Trans. Currency field.', Comment = '%';
            }
            field("Lavel Service Code"; Rec."Lavel Service Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Lavel Service Code field.', Comment = '%';
            }
            field("FPS/FPP"; Rec."FPS/FPP")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the FPS/FPP field.', Comment = '%';
            }
            field("Purpose Code"; Rec."Purpose Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Purpose Code field.', Comment = '%';
            }
            //PS008 Start
            field("Control Field"; Rec."Control Field")
            {
                ApplicationArea = all;
            }
            field("Export ifile"; Rec."Export ifile")
            {
                ApplicationArea = all;
            }
            //PS008 End
            field("Inst to Debotr"; Rec."Inst to Debotr") //#80
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Inst to Debotr field.', Comment = '%';
            }
            field("Payment Type"; Rec."Payment Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Payment Type field.', Comment = '%';
            }
            field("Transaction Type"; Rec."Transaction Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transaction Type field.', Comment = '%';
            }
        }
    }
}
