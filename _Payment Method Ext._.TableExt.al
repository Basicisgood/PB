tableextension 50135 "Payment Method Ext." extends "Payment Method"
{
    fields
    {
        field(50100; "Batch Type";Enum "Batch Type")
        {
            Caption = 'Batch Type';
            DataClassification = ToBeClassified;
        }
        field(50101; "Payment Method Bank XML"; Code[3])
        {
            Caption = 'Payment Method Bank XML';
            DataClassification = ToBeClassified;
        }
        field(50102; "Trans. Currency"; Code[20])
        {
            Caption = 'Trans. Currency';
            TableRelation = Currency;
            DataClassification = ToBeClassified;
        }
        field(50103; "Lavel Service Code";Enum "Level Service Code")
        {
            DataClassification = ToBeClassified;
        }
        field(50104; "FPS/FPP"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50105; "Purpose Code"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        //PS008 Start
        field(50106; "Export ifile"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50107; "Control Field"; code[2])
        {
            DataClassification = ToBeClassified;
        }
        //PS008 End
        field(50108; "Inst to Debotr"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Inst to Debotr';
        }
        field(50109; "Payment Type"; Option)
        {
            Caption = 'Payment Type';
            DataClassification = ToBeClassified;
            OptionMembers = " ", "Priority Payment", "Inter-account transfer", ACH, "Cross Border Fund Transfer", "Domestic Fund Transfer", "ACH Credit/GIRO/Instant Payment", "WorldLink Cross Border Fund Transfer", "Book Transfer";
        }
        field(50110; "Transaction Type"; Option)
        {
            Caption = 'Transaction Type';
            DataClassification = ToBeClassified;
            OptionMembers = " ", "Telegraphic Transfer", "BOC Remittance Plus", Citi;
        }
    }
}
