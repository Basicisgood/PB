table 50105 "Import Staging"
{
    Caption = 'Import Staging';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        // AutoIncrement = true;
        }
        field(5; "Company Code"; Text[30])
        {
            Caption = 'Company Code';
            DataClassification = CustomerContent;
            TableRelation = Company.Name;
        }
        field(7; "Document Type";Enum "Gen. Journal Document Type")
        {
        }
        field(8; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(9; "External Doc No."; Code[35])
        { //Sgarg- Added
        }
        field(10; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(11; "Document Date"; Date)
        { //Sgarg- Added
        }
        field(12; "Account Type";Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(13; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
            TableRelation = if("Account Type"=const("G/L Account"))"G/L Account" where("Account Type"=const(Posting), Blocked=const(false))
            else if("Account Type"=const(Customer))Customer
            else if("Account Type"=const(Vendor))Vendor
            else if("Account Type"=const("Bank Account"))"Bank Account"
            else if("Account Type"=const("Fixed Asset"))"Fixed Asset"
            else if("Account Type"=const("IC Partner"))"IC Partner"
            else if("Account Type"=const("Allocation Account"))"Allocation Account"
            else if("Account Type"=const(Employee))Employee;
        }
        field(14; Description; Text[100])
        {
        }
        field(15; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = CustomerContent;
            TableRelation = Currency;
        }
        field(20; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(21; "Amount LCY"; Decimal)
        {
            Caption = 'Amount LCY';
            DataClassification = CustomerContent;
        }
        field(25; "Global Dimension 1"; Code[20])
        {
            Caption = 'Global Dimension 1';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value";
        }
        field(26; "Global Dimension 2"; Code[20])
        {
            Caption = 'Global Dimension 2';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value";
        }
        field(27; "Bal. Acc. Type";Enum "Gen. Journal Account Type")
        {
            Caption = 'Bal. Account Type';
            DataClassification = CustomerContent;
        }
        field(28; "Bal. Acc. No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            DataClassification = CustomerContent;
            TableRelation = if("Bal. Acc. Type"=const("G/L Account"))"G/L Account" where("Account Type"=const(Posting), Blocked=const(false))
            else if("Bal. Acc. Type"=const(Customer))Customer
            else if("Bal. Acc. Type"=const(Vendor))Vendor
            else if("Bal. Acc. Type"=const("Bank Account"))"Bank Account"
            else if("Bal. Acc. Type"=const("Fixed Asset"))"Fixed Asset"
            else if("Bal. Acc. Type"=const("IC Partner"))"IC Partner"
            else if("Bal. Acc. Type"=const("Allocation Account"))"Allocation Account"
            else if("Bal. Acc. Type"=const(Employee))Employee;
        }
        field(40; "Import Type";Enum "GL Import Type")
        {
            Caption = 'Import Type';
            DataClassification = CustomerContent;
        }
        field(41; "Salvage Value"; Decimal)
        {
        }
        field(42; "Depreciation Book Code"; Code[10])
        {
            Caption = 'Depreciation Book Code';
            DataClassification = CustomerContent;
        }
        field(43; "FA Posting Type";Enum "Gen. Journal Line FA Posting Type")
        {
            Caption = 'FA Posting Type';
        }
        field(44; "FA Posting Date"; Date)
        {
        }
        field(45; "No. of Depreciation Days"; Integer)
        {
            BlankZero = true;
            Caption = 'No. of Depreciation Days';
        }
        field(46; "Depr. until FA Posting Date"; Boolean)
        {
            Caption = 'Depr. until FA Posting Date';
        }
        field(47; "Depr. Acquisition Cost"; Boolean)
        {
            Caption = 'Depr. Acquisition Cost';
        }
        field(48; "Maintenance Code"; Code[10])
        {
            Caption = 'Maintenance Code';
            TableRelation = Maintenance;

            trigger OnValidate()
            begin
                if "Maintenance Code" <> '' then TestField("FA Posting Type", "FA Posting Type"::Maintenance);
            end;
        }
        field(49; "Insurance No."; Code[20])
        {
            Caption = 'Insurance No.';
            TableRelation = Insurance;

            trigger OnValidate()
            begin
                if "Insurance No." <> '' then TestField("FA Posting Type", "FA Posting Type"::"Acquisition Cost");
            end;
        }
        field(50; "Budgeted FA No."; Code[20])
        {
            Caption = 'Budgeted FA No.';
            TableRelation = "Fixed Asset";

            trigger OnValidate()
            var
                FA: Record "Fixed Asset";
            begin
                if "Budgeted FA No." <> '' then begin
                    FA.Get("Budgeted FA No.");
                    FA.TestField("Budgeted Asset", true);
                end;
            end;
        }
        field(51; "Duplicate in Depreciation Book"; Code[10])
        {
            Caption = 'Duplicate in Depreciation Book';
            TableRelation = "Depreciation Book";

            trigger OnValidate()
            begin
                "Use Duplication List":=false;
            end;
        }
        field(52; "Use Duplication List"; Boolean)
        {
            Caption = 'Use Duplication List';

            trigger OnValidate()
            begin
                "Duplicate in Depreciation Book":='';
            end;
        }
        field(53; "FA Reclassification Entry"; Boolean)
        {
            Caption = 'FA Reclassification Entry';
        }
        field(54; "FA Error Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'FA Error Entry No.';
            TableRelation = "FA Ledger Entry";
        }
        field(60; "PB IC Account Type";Enum "IC Journal Account Type")
        {
            Caption = 'PB IC Account Type';
        }
        field(61; "PB IC Account No."; Code[20])
        {
            Caption = 'PB IC Account No.';
        }
        field(80; "Created By"; Code[50])
        {
            Editable = false;
        }
        field(100; "Status";Enum EnumStatus)
        {
            Caption = 'Status';
        // Editable = false;
        }
        field(101; "Error Description"; Text[250])
        {
            Caption = 'Error Description';
            Editable = false;
        }
        field(102; "Cancelled by User"; Code[50])
        {
            Editable = false;
        }
        field(103; "Cancelled Date time"; DateTime)
        {
            Editable = false;
        }
        field(110; "Journal Template"; Code[10])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(115; "Journal Batch"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name"=field("Journal Template"));
        }
        field(116; "Batch Description"; Text[50])
        {
        }
        field(120; "Import TimeStamp"; DateTime)
        {
            Editable = false;
        }
        field(201; "Shortcut Dimension 3"; Code[20])
        {
            Caption = 'Shortcut Dimension 3';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value";
        }
        field(202; "Shortcut Dimension 4"; Code[20])
        {
            Caption = 'Shortcut Dimension 4';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value";
        }
        field(203; "Shortcut Dimension 5"; Code[20])
        {
            Caption = 'Shortcut Dimension 5';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value";
        }
        field(204; "Shortcut Dimension 6"; Code[20])
        {
            Caption = 'Shortcut Dimension 6';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value";
        }
        field(205; "Shortcut Dimension 7"; Code[20])
        {
            Caption = 'Shortcut Dimension 7';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value";
        }
        field(206; "Shortcut Dimension 8"; Code[20])
        {
            Caption = 'Shortcut Dimension 8';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value";
        }
        field(207; "Shortcut Dimension 9"; Code[20])
        {
            Caption = 'Shortcut Dimension 9';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value";
        }
        field(208; "Shortcut Dimension 10"; Code[20])
        {
            Caption = 'Shortcut Dimension 10';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value";
        }
        field(209; "Shortcut Dimension 11"; Code[20])
        {
            Caption = 'Shortcut Dimension 11';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value";
        }
        field(210; "Shortcut Dimension 12"; Code[20])
        {
            Caption = 'Shortcut Dimension 12';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value";
        }
        field(231; "IC Global Dimension 1"; Code[20])
        {
            TableRelation = "Dimension Value";
        }
        field(232; "IC Global Dimension 2"; Code[20])
        {
            TableRelation = "Dimension Value";
        }
        field(233; "IC Shortcut Dimension 3"; Code[20])
        {
            TableRelation = "Dimension Value";
        }
        field(234; "IC Shortcut Dimension 4"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value";
        }
        field(235; "IC Shortcut Dimension 5"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value";
        }
        field(236; "IC Shortcut Dimension 6"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value";
        }
        field(237; "IC Shortcut Dimension 7"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value";
        }
        field(238; "IC Shortcut Dimension 8"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value";
        }
        field(239; "IC Shortcut Dimension 9"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value";
        }
        field(240; "IC Shortcut Dimension 10"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value";
        }
        field(241; "IC Shortcut Dimension 11"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value";
        }
        field(242; "IC Shortcut Dimension 12"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value";
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Import Type", "Company Code", Status, "Journal Template", "Journal Batch", "Document No.")
        {
        }
    }
}
