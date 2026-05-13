table 50106 "COA Template G/L Accounts"
{
    DataClassification = ToBeClassified;
    Caption = 'COA Template G/L Accounts';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(3; "Search Name"; Code[100])
        {
            Caption = 'Search Name';
        }
        field(4; "Account Type";Enum "G/L Account Type")
        {
            Caption = 'Account Type';
        }
        field(6; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(1), Blocked=const(false));
        }
        field(7; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(2), Blocked=const(false));
        }
        field(8; "Account Category";Enum "G/L Account Category")
        {
            BlankZero = true;
            Caption = 'Account Category';
        }
        field(9; "Income/Balance"; Option)
        {
            Caption = 'Income/Balance';
            OptionCaption = 'Income Statement,Balance Sheet';
            OptionMembers = "Income Statement", "Balance Sheet";
        }
        field(10; "Debit/Credit"; Option)
        {
            Caption = 'Debit/Credit';
            OptionCaption = 'Both,Debit,Credit';
            OptionMembers = Both, Debit, Credit;
        }
        field(11; "No. 2"; Code[20])
        {
            Caption = 'No. 2';
        }
        field(13; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(14; "Direct Posting"; Boolean)
        {
            Caption = 'Direct Posting';
            InitValue = true;
        }
        field(16; "Reconciliation Account"; Boolean)
        {
            AccessByPermission = TableData "Bank Account"=R;
            Caption = 'Reconciliation Account';
        }
        field(17; "New Page"; Boolean)
        {
            Caption = 'New Page';
        }
        field(18; "No. of Blank Lines"; Integer)
        {
            Caption = 'No. of Blank Lines';
            MinValue = 0;
        }
        field(19; Indentation; Integer)
        {
            Caption = 'Indentation';
            MinValue = 0;
        }
        field(20; "Source Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
            DataClassification = SystemMetadata;
        }
        field(21; "Source Currency Posting";Enum "G/L Source Currency Posting")
        {
            Caption = 'Source Currency Posting';
        }
        field(22; "Source Currency Revaluation"; Boolean)
        {
            Caption = 'Source Currency Revaluation';
        }
        field(23; "Unrealized Revaluation"; Boolean)
        {
            Caption = 'Unrealized Revaluation';
        }
        field(25; "Last Modified Date Time"; DateTime)
        {
            Caption = 'Last Modified Date Time';
            Editable = false;
        }
        field(26; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(34; Totaling; Text[250])
        {
            Caption = 'Totaling';
        }
        field(39; "Consol. Translation Method"; Option)
        {
            AccessByPermission = TableData "Business Unit"=R;
            Caption = 'Consol. Translation Method';
            OptionCaption = 'Average Rate (Manual),Closing Rate,Historical Rate,Composite Rate,Equity Rate';
            OptionMembers = "Average Rate (Manual)", "Closing Rate", "Historical Rate", "Composite Rate", "Equity Rate";
        }
        field(40; "Consol. Debit Acc."; Code[20])
        {
            AccessByPermission = TableData "Business Unit"=R;
            Caption = 'Consol. Debit Acc.';
        }
        field(41; "Consol. Credit Acc."; Code[20])
        {
            AccessByPermission = TableData "Business Unit"=R;
            Caption = 'Consol. Credit Acc.';
        }
        field(43; "Gen. Posting Type";Enum "General Posting Type")
        {
            Caption = 'Gen. Posting Type';
        }
        field(44; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(45; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(46; Picture; BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(49; "Automatic Ext. Texts"; Boolean)
        {
            Caption = 'Automatic Ext. Texts';
        }
        field(54; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(55; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(56; "Tax Group Code"; Code[20])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(57; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(58; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(63; "Exchange Rate Adjustment";Enum "Exch. Rate Adjustment Type")
        {
            AccessByPermission = TableData Currency=R;
            Caption = 'Exchange Rate Adjustment';
        }
        field(66; "Default IC Partner G/L Acc. No"; Code[20])
        {
            Caption = 'Default IC Partner G/L Acc. No';
            TableRelation = "IC G/L Account"."No.";
        }
        field(70; "Omit Default Descr. in Jnl."; Boolean)
        {
            Caption = 'Omit Default Descr. in Jnl.';
        }
        field(80; "Account Subcategory Entry No."; Integer)
        {
            Caption = 'Account Subcategory Entry No.';
            TableRelation = "G/L Account Category";
        }
        field(83; "Exclude From Consolidation"; Boolean)
        {
            Caption = 'Exclude from Consolidation';
            DataClassification = CustomerContent;
        }
        field(84; "Template Code"; Code[20])
        {
            Caption = 'Code';
            TableRelation = "COA Template";
        }
        field(1100; "Cost Type No."; Code[20])
        {
            Caption = 'Cost Type No.';
            Editable = false;
            TableRelation = "Cost Type";
            ValidateTableRelation = false;
        }
        field(1700; "Default Deferral Template Code"; Code[10])
        {
            Caption = 'Default Deferral Template Code';
            TableRelation = "Deferral Template"."Deferral Code";
        }
        field(8000; Id; Guid)
        {
            Caption = 'Id';
            ObsoleteState = Removed;
            ObsoleteReason = 'This functionality will be replaced by the systemID field';
            ObsoleteTag = '22.0';
        }
        field(9000; "API Account Type";Enum "G/L Account Type")
        {
            Caption = 'API Account Type';
            Editable = false;
        }
        field(9010; "Sync Pending"; Boolean)
        {
            Editable = false;
        }
    }
    keys
    {
        key(Key1; "Template Code", "No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    // Add changes to field groups here
    }
    var myInt: Integer;
    trigger OnInsert()
    begin
        "Sync Pending":=true;
    end;
    trigger OnModify()
    begin
    end;
    trigger OnDelete()
    begin
    end;
    trigger OnRename()
    begin
    end;
    var COA: Record "G/L Account";
}
