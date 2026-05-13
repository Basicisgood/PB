table 50174 "Global Employee Ledger Entry"
{
    Caption = 'Global Employee Ledger Entry';
    DrillDownPageID = 50248;
    LookupPageID = 50248;
    DataClassification = CustomerContent;
    DataPerCompany = false;
    Permissions = tabledata "Employee Ledger Entry"=rim;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(3; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee;
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(5; "Document Type";Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(11; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(13; Amount; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("GB Det. Employee Ledger Entry".Amount where("Ledger Entry Amount"=const(true), "Employee Ledger Entry No."=field("Entry No."), "Posting Date"=field("Date Filter"), "Company Code"=field("Company Code")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Remaining Amount"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("GB Det. Employee Ledger Entry".Amount where("Employee Ledger Entry No."=field("Entry No."), "Posting Date"=field("Date Filter"), "Company Code"=field("Company Code")));
            Caption = 'Remaining Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Original Amt. (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("GB Det. Employee Ledger Entry"."Amount (LCY)" where("Employee Ledger Entry No."=field("Entry No."), "Entry Type"=filter("Initial Entry"), "Posting Date"=field("Date Filter"), "Company Code"=field("Company Code")));
            Caption = 'Original Amt. (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Remaining Amt. (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("GB Det. Employee Ledger Entry"."Amount (LCY)" where("Employee Ledger Entry No."=field("Entry No."), "Posting Date"=field("Date Filter"), "Company Code"=field("Company Code")));
            Caption = 'Remaining Amt. (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("GB Det. Employee Ledger Entry"."Amount (LCY)" where("Ledger Entry Amount"=const(true), "Employee Ledger Entry No."=field("Entry No."), "Posting Date"=field("Date Filter"), "Company Code"=field("Company Code")));
            Caption = 'Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "Employee Posting Group"; Code[20])
        {
            Caption = 'Employee Posting Group';
            TableRelation = "Employee Posting Group";
        }
        field(23; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(1));
        }
        field(24; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(2));
        }
        field(25; "Salespers./Purch. Code"; Code[20])
        {
            Caption = 'Salespers./Purch. Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(27; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
        }
        field(28; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(34; "Applies-to Doc. Type";Enum "Gen. Journal Document Type")
        {
            Caption = 'Applies-to Doc. Type';
        }
        field(35; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';
        }
        field(36; Open; Boolean)
        {
            Caption = 'Open';
        }
        field(43; Positive; Boolean)
        {
            Caption = 'Positive';
        }
        field(44; "Closed by Entry No."; Integer)
        {
            Caption = 'Closed by Entry No.';
            TableRelation = "Employee Ledger Entry";
        }
        field(45; "Closed at Date"; Date)
        {
            Caption = 'Closed at Date';
        }
        field(46; "Closed by Amount"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Closed by Amount';
        }
        field(47; "Applies-to ID"; Code[50])
        {
            Caption = 'Applies-to ID';

            trigger OnValidate()
            begin
                TestField(Open, true);
            end;
        }
        field(48; "Journal Templ. Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            DataClassification = SystemMetadata;
        }
        field(49; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(50; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(51; "Bal. Account Type";Enum "Gen. Journal Account Type")
        {
            Caption = 'Bal. Account Type';
        }
        field(52; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = if("Bal. Account Type"=const("G/L Account"))"G/L Account"
            else if("Bal. Account Type"=const(Customer))Customer
            else if("Bal. Account Type"=const(Vendor))Vendor
            else if("Bal. Account Type"=const("Bank Account"))"Bank Account"
            else if("Bal. Account Type"=const("Fixed Asset"))"Fixed Asset";
        }
        field(53; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
        }
        field(54; "Closed by Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Closed by Amount (LCY)';
        }
        field(58; "Debit Amount"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = sum("GB Det. Employee Ledger Entry"."Debit Amount" where("Ledger Entry Amount"=const(true), "Employee Ledger Entry No."=field("Entry No."), "Posting Date"=field("Date Filter"), "Company Code"=field("Company Code")));
            Caption = 'Debit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(59; "Credit Amount"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = sum("GB Det. Employee Ledger Entry"."Credit Amount" where("Ledger Entry Amount"=const(true), "Employee Ledger Entry No."=field("Entry No."), "Posting Date"=field("Date Filter"), "Company Code"=field("Company Code")));
            Caption = 'Credit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "Debit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = sum("GB Det. Employee Ledger Entry"."Debit Amount (LCY)" where("Ledger Entry Amount"=const(true), "Employee Ledger Entry No."=field("Entry No."), "Posting Date"=field("Date Filter"), "Company Code"=field("Company Code")));
            Caption = 'Debit Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "Credit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = sum("GB Det. Employee Ledger Entry"."Credit Amount (LCY)" where("Ledger Entry Amount"=const(true), "Employee Ledger Entry No."=field("Entry No."), "Posting Date"=field("Date Filter"), "Company Code"=field("Company Code")));
            Caption = 'Credit Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(64; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(65; "Closed by Currency Code"; Code[10])
        {
            Caption = 'Closed by Currency Code';
            TableRelation = Currency;
        }
        field(66; "Closed by Currency Amount"; Decimal)
        {
            AccessByPermission = TableData Currency=R;
            AutoFormatExpression = "Closed by Currency Code";
            AutoFormatType = 1;
            Caption = 'Closed by Currency Amount';
        }
        field(73; "Adjusted Currency Factor"; Decimal)
        {
            Caption = 'Adjusted Currency Factor';
            DecimalPlaces = 0: 15;
        }
        field(74; "Original Currency Factor"; Decimal)
        {
            Caption = 'Original Currency Factor';
            DecimalPlaces = 0: 15;
        }
        field(75; "Original Amount"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("GB Det. Employee Ledger Entry".Amount where("Employee Ledger Entry No."=field("Entry No."), "Entry Type"=filter("Initial Entry"), "Posting Date"=field("Date Filter"), "Company Code"=field("Company Code")));
            Caption = 'Original Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(76; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(84; "Amount to Apply"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount to Apply';

            trigger OnValidate()
            var
                L_ELE: Record "Employee Ledger Entry";
            begin
                TestField(Open, true);
                CalcFields("Remaining Amount");
                if AreOppositeSign("Amount to Apply", "Remaining Amount")then FieldError("Amount to Apply", MustHaveSameSignErr);
                if Abs("Amount to Apply") > Abs("Remaining Amount")then FieldError("Amount to Apply", MustNotBeLargerErr);
                //TEC-Sgarg>>21jan25
                IF "Company Code" = CompanyName then begin
                    IF L_ELE.GET("Entry No.")then begin
                        L_ELE."Amount to Apply":=rec."Amount to Apply";
                        L_ELE.Modify();
                    end end //TEC-Sgarg<< 21jan25
            end;
        }
        field(86; "Applying Entry"; Boolean)
        {
            Caption = 'Applying Entry';
        }
        field(87; Reversed; Boolean)
        {
            Caption = 'Reversed';
            DataClassification = CustomerContent;
        }
        field(88; "Reversed by Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Reversed by Entry No.';
            DataClassification = CustomerContent;
            TableRelation = "Employee Ledger Entry";
        }
        field(89; "Reversed Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Reversed Entry No.';
            DataClassification = CustomerContent;
            TableRelation = "Employee Ledger Entry";
        }
        field(170; "Creditor No."; Code[20])
        {
            Caption = 'Creditor No.';
        }
        field(171; "Payment Reference"; Code[50])
        {
            Caption = 'Payment Reference';

            trigger OnValidate()
            begin
                if "Payment Reference" <> '' then TestField("Creditor No.");
            end;
        }
        field(172; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";

            trigger OnValidate()
            begin
                TestField(Open, true);
            end;
        }
        field(289; "Message to Recipient"; Text[140])
        {
            Caption = 'Message to Recipient';

            trigger OnValidate()
            begin
                TestField(Open, true);
            end;
        }
        field(290; "Exported to Payment File"; Boolean)
        {
            Caption = 'Exported to Payment File';
            Editable = false;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                Rec.ShowDimensions();
            end;
        }
        field(500; "Company Code"; Text[50])
        {
            Caption = 'Company Code';
        }
        field(50100; "Record Type"; Text[10])
        {
            DataClassification = ToBeClassified;
        //Editable = false;
        }
        field(50101; "Exported to Concur"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50102; "PB Concur Invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
        //Editable = false;
        }
        field(50105; "Shortcut Dimension 3 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(3));
        }
        field(50106; "Shortcut Dimension 4 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(4));
        }
        field(50107; "Shortcut Dimension 5 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(5));
        }
        field(50108; "Shortcut Dimension 6 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(6));
        }
        field(50109; "Shortcut Dimension 7 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(7));
        }
        field(50110; "Shortcut Dimension 8 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(8));
        }
        field(50111; "Shortcut Dimension 9 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,9';
            Caption = 'Shortcut Dimension 9 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(9));
        }
        field(50112; "Shortcut Dimension 10 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,10';
            Caption = 'Shortcut Dimension 10 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(10));
        }
        field(50113; "Shortcut Dimension 11 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,11';
            Caption = 'Shortcut Dimension 11 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(11));
        }
        field(50114; "Shortcut Dimension 12 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,12';
            Caption = 'Shortcut Dimension 12 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(12));
        }
        field(50115; "Shortcut Dimension 13 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,13';
            Caption = 'Shortcut Dimension 13 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(13));
        }
        field(50116; "Shortcut Dimension 14 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,14';
            Caption = 'Shortcut Dimension 14 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(14));
        }
        field(50117; "Shortcut Dimension 15 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,15';
            Caption = 'Shortcut Dimension 15 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(15));
        }
        //VJ#68
        field(50121; "Receipt image ID"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        //VJ#68
        //PS008 Start
        field(50122; "External Document No."; code[35])
        {
            DataClassification = ToBeClassified;
        }
        //PS008 End
        //VT20-12-2024 >>
        field(50123; "Concur ID"; text[100])
        {
            Caption = 'Concur ID';
            DataClassification = ToBeClassified;
        }
        field(50124; "Entry Id"; Text[100])
        {
            Caption = 'Entry Id';
        }
        //VT20-12-2024 <<
        field(50125; "ConfirmationResult"; Text[2048])
        {
            Caption = 'ConfirmationResult';
        }
        field(50126; "PaymentConfirmationResult"; Text[2048])
        {
            Caption = 'PaymentConfirmationResult';
        }
        field(50127; "errorMessage"; Text[2048])
        {
            Caption = 'errorMessage';
        }
        field(50128; "Report ID"; text[100])
        {
            Caption = 'Report ID';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50129; "Bank Document No. Applied"; code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50130; "Bank Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50236; "Employee Bank Account"; Code[20]) //NT_ 13-02-2025
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
    keys
    {
        key(Key1; "Entry No.", "Company Code")
        {
            Clustered = true;
        }
        key(Key2; "Employee No.", "Applies-to ID", Open, Positive)
        {
        }
    }
    fieldgroups
    {
    }
    var MustHaveSameSignErr: Label 'must have the same sign as remaining amount';
    MustNotBeLargerErr: Label 'must not be larger than remaining amount';
    procedure ShowDimensions()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption(), "Entry No."));
    end;
    procedure RecalculateAmounts(FromCurrencyCode: Code[10]; ToCurrencyCode: Code[10]; PostingDate: Date)
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        if ToCurrencyCode = FromCurrencyCode then exit;
        "Remaining Amount":=CurrExchRate.ExchangeAmount("Remaining Amount", FromCurrencyCode, ToCurrencyCode, PostingDate);
        "Amount to Apply":=CurrExchRate.ExchangeAmount("Amount to Apply", FromCurrencyCode, ToCurrencyCode, PostingDate);
    end;
    local procedure AreOppositeSign(Amount1: Decimal; Amount2: Decimal): Boolean var
        Math: Codeunit "Math";
    begin
        if(Amount1 = 0) or (Amount2 = 0)then exit(false);
        exit(Math.Sign(Amount1) <> Math.Sign(Amount2));
    end;
}
