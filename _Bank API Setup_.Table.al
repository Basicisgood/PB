table 50125 "Bank API Setup"
{
    Caption = 'Bank API Setup';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "PGP Base API Url"; Text[1024])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Encrypt EndPoint"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Decrypt EndPoint"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "HSBC HK Base API Url"; Text[1024])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "HSBC HK Public Key"; Blob)
        {
            DataClassification = ToBeClassified;
            Caption = 'Public Key';
        }
        field(7; "HSBC HK Private Key"; Blob)
        {
            DataClassification = ToBeClassified;
            Caption = 'Private Key';
        }
        field(8; "HSBC HK Private Key Password"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "x-hsbc-profile-id"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "x-hsbc-client-id"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "x-hsbc-client-secret"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "x-payload-type"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "HSBC Bulk Payment Endpoint"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "HSBC Statement Endpoint"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "HSBC Last Statement DateTime"; DateTime)
        {
        }
        field(16; "HSBC Account Number"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "HSBC Account Country"; code[2])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "HSBC Institution Code"; Code[4])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "HSBC Account Type"; code[2])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "BOC API Base URL"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(21; "BOC Pre E2EE Endpoint"; text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "BOC platformAc"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(23; "BOC keyName"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "BOC Private Key"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "BOC Public Key"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "BOC Private Key Password"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Citi API Base URL"; text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Citi Token Endpoint"; text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Citi Statement Token Endpoint"; text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Citi Payment Endpoint"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Citi Statment Init Endpoint"; text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Citi Statment Retriv. Endpoint"; text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Citi Client Id"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(34; "Citi Client Secret"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Citi Encryption Cert"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(36; "Citi Signing Cert"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(37; "Citi Client SSL Cert"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(38; "Citi Client SSL Password"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(39; "Citi Client Encryption Cert"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Citi Client Encrypt Password"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(41; "Citi Client Sign Cert"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(42; "Citi Client Sign Password"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        //TEC.VJ 10042024
        field(43; "HKLV No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
        }
        field(44; "HKUV No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
        }
        field(45; "USLV No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
        }
        field(46; "USUV No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
        }
        field(53; "WL395"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
        }
        field(54; "DO391"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
        }
        field(55; "CB392"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
        }
        field(56; "BT393"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
        }
        field(57; "FP403"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
        }
        field(58; "CITI949"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
        }
        field(59; "CITI391"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
        }
        field(60; "CITI392"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
        }
        field(61; "CITI393"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
        }
        field(62; "CITI403"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
        }
        field(47; "CaschRcpt Template Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(48; "CaschRcpt Batch Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name"=field("CaschRcpt Template Name"));
        }
        field(49; "General Jnl. Template Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(50; "General Jnl. Batch Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name"=field("General Jnl. Template Name"));
        }
        field(51; "Payment Jnl. Template Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(52; "Payment Jnl. Batch Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name"=field("Payment Jnl. Template Name"));
        }
        //#252 TEC.VJ 07MAR2025>> Moved to GL setup
        // field(63; "Auto Post"; Boolean)
        // {
        //     DataClassification = ToBeClassified;
        // }
        //#252 TEC.VJ 07MAR2025>>
        field(64; "Citi WL ID + Branch Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(65; "Citi Payment Status Endpoint"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(66; "HSBC Payment Status Endpoint"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(67; "Bank Charge Account No."; code[20]) //#112 TEC.VJ
        {
            TableRelation = "G/L Account" where(Blocked=const(false));
            DataClassification = ToBeClassified;
        }
        //#112 VJ Start
        field(68; "Bank Charge Template Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(69; "Bank Charge Batch Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name"=field("Bank Charge Template Name"));
        }
        field(70; "Dummy GL Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "IC G/L Account";
        }
        //#112 VJ End
        //#189 TEC.VJ 25012025>>
        field(71; "TRP Payment Jnl. Template Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(72; "TRP Payment Jnl. Batch Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name"=field("TRP Payment Jnl. Template Name"));
        }
        //#189 TEC.VJ 25012025<<
        //#191 TEC.VJ 29012025>>
        field(73; "Split Inbound Date Wise"; Boolean)
        {
            Caption = 'Split Batch Date Wise';
            DataClassification = ToBeClassified;
        }
        field(74; "Batch Name No. Series"; Code[10])
        {
            TableRelation = "No. Series".Code;
            DataClassification = ToBeClassified;
        }
        //#191 TEC.VJ 29012025<<
        //#288 TEC.VJ 25032025>>
        field(75; "Return Template Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(76; "Return Batch Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name"=field("Return Template Name"));
        }
        field(77; "Bank Transfer Template Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(78; "Bank Transfer Batch Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name"=field("Bank Transfer Template Name"));
        }
        //#288 TEC.VJ 25032025<<
        //#293 TEC.VJ>>
        field(79; "API Bank Dummy Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "IC G/L Account" where(Blocked=const(false));
        }
        //#293 TEC.VJ<<
        //#310 TEC.VJ 16APR2025>>
        field(80; "Rejection Payment Jnl. NoS."; Code[20])
        {
            Caption = 'Rejection Payment Jnl. No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(81; "Rejection IC Jnl. NoS."; Code[20])
        {
            Caption = 'Rejection IC Jnl. No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        //#310 TEC.VJ 16APR2025<<
        field(82; "Company Code Filter list"; Text[2048])
        {
        }
        field(83; "Bank API List Date Formula"; DateFormula)
        {
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}
