table 50157 "Concur API Setup"
{
    Caption = 'Pacific Basin Setup';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Primary Key"; Text[1])
        {
            Caption = 'Primary Key';
        }
        field(2; "Token URL"; Text[2048])
        {
            Caption = 'Token URL';
        }
        field(3; "User ID"; Text[250])
        {
            Caption = 'User ID';
        }
        field(5; Password; Text[50])
        {
            ExtendedDatatype = Masked;
        }
        field(6; "Is Enable"; Boolean)
        {
        }
        field(7; "Access Token"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Financial Transaction URL"; text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Expense Attendee URL"; text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Concur Inbound Image URL"; text[1000])
        {
            DataClassification = ToBeClassified;
        }
        //PS004 Start
        field(11; "Enable Outbound Integration"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "API Token"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Exchange Rate URL"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        //PS004 End
        //PS005 Start
        field(14; "Employee URL"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Company ID"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(38; "Default Company"; text[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Company;
        }
        //PS005 End
        //PS006 Start
        field(16; "Payment URL"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Default Concur Dimension"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(2), Blocked=const(false));
        }
        field(18; "Concur Template Name"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(19; "Concur Batch Name"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name"=field("Concur Template Name"));
        }
        field(20; "Concur Gen. Journal No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        //PS006 End
        //PS007 Start
        field(22; "Concur Accr. Template Name"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(23; "Concur Accr. Batch Name"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name"=field("Concur Accr. Template Name"));
        }
        field(24; "Concur Accr. Gen. Journal No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(25; "Default Concur Accr. Dimension"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(2), Blocked=const(false));
        }
        field(26; "Company Code Prefix"; text[5])
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Concur Cash Ledger FD6"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(6), Blocked=const(false));
        }
        //PS007 End
        //VJ Start
        field(31; "Financial Transaction Ack URL"; text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Financial Trans Confirm URL"; text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Finan Trans. Payment Conf. URL"; text[1000])
        {
            Caption = 'Financial Transaction Payment Confirmation URL';
            DataClassification = ToBeClassified;
        }
        field(33; "Accrual Debit GL Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No." where("Direct Posting"=filter(true));
        }
        field(34; "Accrual Credit GL Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No." where("Direct Posting"=filter(true));
        }
        //VJ End
        //PS009 Start
        field(36; "Get Identity URL"; text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(37; "Get Attendee Info URL"; text[1000])
        {
            DataClassification = ToBeClassified;
        }
        //PS009 End
        //PS014 Start
        field(39; "Client ID"; text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Client Secret"; text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(41; "Refresh Token"; text[250])
        {
            DataClassification = ToBeClassified;
        }
        //PS014 End
        //PS007 Start
        field(42; "Accrual Report Name Filter 1"; text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Accrual Report Name Test Filter';
        }
        field(43; "Accrual Report Name Filter 2"; text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Accrual Report Name Inspection Filter';
        }
        field(44; "Accrual Report Name Filter 3"; text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Accrual Report Name Vessel Filter';
        }
        field(45; "Accrual FD5 Filter 1"; text[250])
        {
            DataClassification = ToBeClassified;
        }
        //PS007 End
        //PS006 Start
        field(46; "Expense Type Name Filter 1"; text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(47; "Expense Type Name Filter 2"; text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(48; "Expense Type Name Filter 3"; text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(49; "DOC Cash FD9"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(9), Blocked=const(false));
        }
        field(50; "DOC Non Cash FD9"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(9), Blocked=const(false));
        }
        //PS006 End
        //#256 TEC.VJ 10MAR2025>>
        field(51; "Get Cash Advance URL"; text[1000])
        {
            Caption = 'Get Concur Cash Advance URL';
            DataClassification = ToBeClassified;
        }
        field(52; "Post Cash Advance Ack. URL"; text[1000])
        {
            Caption = 'Post Cash Advance acknowledgement URL';
            DataClassification = ToBeClassified;
        }
        field(53; "Post Cash Advance Confir. URL"; text[1000])
        {
            Caption = 'Post Cash Advance Confirmation URL';
            DataClassification = ToBeClassified;
        }
        //#256 TEC.VJ 10MAR2025<<
        field(55; "Cash Advance Template Name"; Code[10])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(56; "Cash Advance Batch Name"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name"=field("Cash Advance Template Name"));
        }
        field(57; "Cash Advance No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(58; "Cash Advance FD10"; Code[20])
        {
            // TableRelation = "Dimension Value".Code where("Global Dimension No." = const(10),//#266 TEC.VJ 
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(2), //#266 TEC.VJ 
 Blocked=const(false));
        }
        field(59; "Is Enable Cash Advance"; Boolean)
        {
        }
        field(60; "CL Default Concur Dim."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(2), Blocked=const(false));
        }
        field(61; "CL Concur Template Name"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(62; "CL Concur Batch Name"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name"=field("CL Concur Template Name"));
        }
        field(63; "CL Concur Gen. Journal No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(64; "Cash Advance Return G/L Acc"; Code[20])
        {
            TableRelation = "G/L Account"."No." where("Direct Posting"=filter(true));
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
    var ReadingDataSkippedMsg: Label 'Loading field %1 will be skipped because there was an error when reading the data.\To fix the current data, contact your administrator.\Alternatively, you can overwrite the current data by entering data in the field.', Comment = '%1=field caption';
}
