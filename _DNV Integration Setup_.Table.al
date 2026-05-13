table 50140 "DNV Integration Setup"
{
    Caption = 'DNV Integration Setup';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(2; "Primary Key"; Code[10])
        {
        }
        field(5; "Token URL"; Text[100])
        {
        }
        field(10; "Account Create URL"; Text[100])
        {
        }
        field(11; "Account Update URL"; Text[100])
        {
        }
        field(14; "Contact Create URL"; Text[100])
        {
        }
        field(15; "Contact Update URL"; Text[100])
        {
        }
        field(16; "CurrExchRate Create URL"; Text[100])
        {
        }
        field(17; "Invoices Payment Update URL"; Text[100])
        {
        }
        field(35; "G/L Account Initials Sync"; Text[3])
        {
        }
        field(40; "User Id"; Code[50])
        {
        }
        field(45; Password; Text[50])
        {
        //ExtendedDatatype = Masked;
        }
        field(100; "Is Enable"; Boolean)
        {
        }
        field(50; "Access Token"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(51; "Default Gen. Jnl. Template"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(52; "Default Gen. Jnl. Batch"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name"=field("Default Gen. Jnl. Template"));
        }
        field(53; "Auto Post Invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Auto Post Invoice';
        }
        field(54; "Auto Post Recurring Journal"; Boolean)
        {
            Caption = 'Auto Post Recurring General';
            DataClassification = ToBeClassified;
        }
        field(56; "Recurring Gen. Jnl. Template"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template" where(Recurring=const(true));
        }
        field(57; "Recurring Gen. Jnl. Batch"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name"=field("Recurring Gen. Jnl. Template"));
        }
        field(58; "Auto Post General Journal"; Boolean)
        {
            Caption = 'Auto Post General General';
            DataClassification = ToBeClassified;
        }
        field(60; "Accrual Bal Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No." where("Direct Posting"=filter(true));
        }
        field(62; "Accrual No Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(65; "Main Financial Company"; text[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Company.Name;
        }
        field(70; "Budget Bal Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No." where("Direct Posting"=filter(true));
        }
        field(80; "Wages Bal Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No." where("Direct Posting"=filter(true));
        }
        field(82; "Payout Default Gen. Jnl. Templ"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
            Caption = 'Payout balance Default Gen. Jnl. Template';
        }
        field(83; "Payout Default Gen. Jnl. Batch"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name"=field("Payout Default Gen. Jnl. Templ"));
            Caption = 'Payout Balance Default Gen. Jnl. Batch';
        }
        field(90; "Leave Pay Bal Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No." where("Direct Posting"=filter(true));
        }
        field(91; "Commited Cost Bal. Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No." where("Direct Posting"=filter(true));
        }
        field(92; "Invoice Def. Gen. Jnl.Template"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(93; "Invoice Def. Gen. Jnl. Batch"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name"=field("Invoice Def. Gen. Jnl.Template"));
        }
        field(94; "Invoice Countrt Party Type"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension VAlue".Code where("Global Dimension No."=filter(9));
        }
        field(101; "Invoice Correction Suffix"; code[10])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
    procedure SetAccessToken(NewAccessToken: Text)
    var
        OutStream: OutStream;
    begin
        Clear("Access Token");
        "Access Token".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewAccessToken);
        Modify;
    end;
    procedure GetAccessToken()AccessToken: Text var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("Access Token");
        "Access Token".CreateInStream(InStream, TEXTENCODING::UTF8);
        if not TypeHelper.TryReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator(), AccessToken)then Message(ReadingDataSkippedMsg, FieldCaption("Access Token"));
    end;
    var myInt: Integer;
    ReadingDataSkippedMsg: Label 'Loading field %1 will be skipped because there was an error when reading the data.\To fix the current data, contact your administrator.\Alternatively, you can overwrite the current data by entering data in the field.', Comment = '%1=field caption';
}
