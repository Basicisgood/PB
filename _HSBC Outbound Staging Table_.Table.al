table 50137 "HSBC Outbound Staging Table"
{
    Caption = 'HSBC Outbound Staging Table';
    DataClassification = ToBeClassified;
    LookupPageId = "HSBC Outbound Staging";
    DrillDownPageId = "HSBC Outbound Staging";

    fields
    {
        field(1; "Bank Document No."; Code[35])
        {
            Caption = 'Bank Document No.';
        }
        field(2; "Batch Id"; Text[35])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Batch Type";Enum "Batch Type")
        {
            //OptionMembers = "HK Lower Value","HK Upper Value","US Lower Value","US Upper Value";
            DataClassification = ToBeClassified;
        }
        field(4; Identification; Code[35])
        {
            Caption = 'Identification';
        }
        field(5; "Payment Method"; Code[35])
        {
            Caption = 'Payment Method';
        }
        field(6; "Service Level";Enum "Level Service Code")
        {
            Caption = 'Service Level';
        }
        field(7; "Posting Date"; DateTime)
        {
            Caption = 'Posting Date';
        }
        field(8; "Debtor Name"; Text[140])
        {
            Caption = 'Debtor Name';
        }
        field(9; "Debtor Address"; Text[35])
        {
            Caption = 'Debtor Address';
        }
        field(10; "Debtor Address 2"; Text[35])
        {
            Caption = 'Debtor Address 2';
        }
        field(11; "Debtor Country"; Text[2])
        {
            Caption = 'Debtor Country';
        }
        field(12; "Debtor Post Code"; Text[16])
        {
            Caption = 'Debtor Post Code';
        }
        field(13; "Debtor Bank Account"; Text[34])
        {
            Caption = 'Debtor Bank Account';
        }
        field(14; "Debtor Currency Code"; Code[3])
        {
            Caption = 'Debtor Currency Code';
        }
        field(15; "Debtor SWIFT Code"; Text[100])
        {
            Caption = 'Debtor SWIFT Code';
        }
        field(16; "Debtor Bank Acc Name"; Text[140])
        {
            Caption = 'Debtor Bank Acc Name';
        }
        field(17; "Debtor Bank Address"; Text[70])
        {
            Caption = 'Debtor Bank Address';
        }
        field(18; "Debtor Bank Post Code"; Text[16])
        {
            Caption = 'Debtor Bank Post Code';
        }
        field(19; "Debtor Bank Address 2"; Text[70])
        {
            Caption = 'Debtor Bank Address 2';
        }
        field(20; "Debtor Bank Country"; Code[2])
        {
            Caption = 'Debtor Bank Country';
        }
        field(21; "Debtor Bank Clearing Code"; Text[3])
        {
            DataClassification = ToBeClassified;
            Caption = 'Debtor Bank Clearing Code';
        }
        field(22; "Debtor ACH ID"; Text[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Debtor ACH ID';
        }
        field(23; "Debtor To Receipt"; Text[140])
        {
            Caption = 'Message To Receipt';
        }
        field(24; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(25; Currency; Code[3])
        {
            Caption = 'Currency';
        }
        field(26; "Creditor Bank Account"; Text[34])
        {
            DataClassification = ToBeClassified;
            Caption = 'Creditor Bank Account';
        }
        field(27; "Creditor Bank Acc Name"; text[35]) //#215 TEC.VJ Change Field length to 35 from 100
        {
            DataClassification = ToBeClassified;
            Caption = 'Creditor Bank Acc Name';
        }
        field(28; "Creditor Swift Code"; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Creditor Swift Code';
        }
        field(29; "Creditor Bank Branch Code"; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Creditor Bank Branch Code';
        }
        field(30; "Creditor Bank Clearing Code"; Text[50]) //[3]//#77 TEC.VJ
        {
            DataClassification = ToBeClassified;
            Caption = 'Creditor Bank Clearing Code';
        }
        field(31; "Creditor Currency Code"; Text[3])
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Creditor Address"; Text[35])
        {
            DataClassification = ToBeClassified;
            Caption = 'Creditor Address';
        }
        field(33; "Creditor Post Code"; Text[16])
        {
            DataClassification = ToBeClassified;
            Caption = 'Creditor Post Code';
        }
        field(34; "Creditor Address 2"; text[35])
        {
            DataClassification = ToBeClassified;
            Caption = 'Creditor Address 2';
        }
        field(35; "Creditor Country"; Text[16])
        {
            DataClassification = ToBeClassified;
            Caption = 'Creditor Country';
        }
        field(36; "Charges Bearer"; Option)
        {
            DataClassification = ToBeClassified;
            //OptionMembers = DEBT,CRED,SHAR;
            OptionMembers = "SHAR", "DEBT", "CRED"; //VJ #138
            OptionCaption = 'SHAR,DEBT,CRED';
        }
        field(37; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Pending, Sent, Fail, Approved, Rejected, Booked, Settled, "Bank Process";
            Caption = 'Status';
        }
        field(38; "Bank Integration Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ", HSBC, BOC, Citi, "Non API";
        }
        field(39; "Country/Region Code"; Code[20]) //TEC#001
        {
            TableRelation = "Country/Region";
            DataClassification = ToBeClassified;
        }
        field(40; "Bal. Account No."; Code[20]) //TEC#001
        {
            TableRelation = "Bank Account";
            DataClassification = ToBeClassified;
        }
        field(41; "Creditor IBAN Account"; text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(42; "Creditor Inter. Bank SWIFT"; Text[30])
        {
            Caption = 'Creditor Intermediary Bank SWIFT';
            DataClassification = ToBeClassified;
        }
        field(43; "Creditor Inter. Bank Country"; text[3])
        {
            DataClassification = ToBeClassified;
            Caption = 'Creditor Intermediary Bank Country';
        }
        field(44; "Creditor Inter. Bank Acc. No"; text[34])
        {
            DataClassification = ToBeClassified;
            Caption = 'Creditor Intermediary Bank Account No';
        }
        field(45; "Creditor Email Address 1"; Text[80])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(46; "Creditor Email Address 2"; Text[80])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(47; "Creditor Email Address 3"; Text[80])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(48; "Creditor Email Address 4"; Text[80])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(49; "Creditor Email Address 5"; Text[80])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(50; "Creditor Email Address 6"; Text[80])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(51; "Payment Method Bank XML"; Text[3])
        {
            DataClassification = ToBeClassified;
        }
        field(52; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(53; "Create Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(54; "Payment Reference No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(101; "Purpose Code"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(102; "Trans. Amt."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(103; "Trans. Currency"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(104; "Exchange Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 1: 6;
            MinValue = 0;
        }
        field(105; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            Editable = false;
            TableRelation = "Source Code";
        }
        field(106; "Creditor ABA/BSB No."; Text[100])
        {
            Caption = 'ABA/BSB No.';
            DataClassification = ToBeClassified;
        }
        field(107; "Debtor ABA Routing Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(108; "ACH Payment Set Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Set Code";
        }
        field(109; "Creditor IFSC Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Set Code";
        }
        field(110; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Gen. Journal Template";
        }
        field(111; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name"=field("Journal Template Name"));
        }
        field(112; "Account Type";Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
        }
        field(113; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = if("Account Type"=const("G/L Account"))"G/L Account" where("Account Type"=const(Posting), Blocked=const(false))
            else if("Account Type"=const(Customer))Customer
            else if("Account Type"=const(Vendor))Vendor
            else if("Account Type"=const("Bank Account"))"Bank Account"
            else if("Account Type"=const("Fixed Asset"))"Fixed Asset"
            else if("Account Type"=const("IC Partner"))"IC Partner"
            else if("Account Type"=const("Allocation Account"))"Allocation Account"
            else if("Account Type"=const(Employee))Employee;
        }
        field(114; "Bal. Account Type";Enum "Gen. Journal Account Type")
        {
            Caption = 'Bal. Account Type';
        }
        field(115; "Word Link"; Text[1024])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = URL;
        }
        field(116; "Instruction to Bank"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(121; "FPS Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Email,FPS ID,Telephon No.';
            OptionMembers = " ", Email, "FPS ID", "Telephon No.";
        }
        field(122; "FPS No."; text[70])
        {
            DataClassification = ToBeClassified;
        }
        field(128; "Remittance Email 6"; Text[80])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(131; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(132; "API Status";Enum "Bank Paym Enquiry API Status")
        {
            DataClassification = ToBeClassified;
        }
        field(133; "API Information"; Text[140])
        {
            DataClassification = ToBeClassified;
        }
        field(134; "Applied Entries to XML"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(135; "Payment Purpose"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Purpose';
        //#145
        }
        //#203 06022024 VJ>>
        field(136; "Creditor Address 3"; Text[35])
        {
            DataClassification = ToBeClassified;
            Caption = 'Creditor Address 3';
        }
        //#203 06022024 VJ<<
        //#219 TEC.VJ>>
        field(138; "Trigger API"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //#219 TEC.VJ<<
        //NT_ 20250729 >>
        field(139; TxSts; Text[15])
        {
            DataClassification = ToBeClassified;
        }
        //NT_ 20250729 <<
        field(140; "Recipient Bank Name"; Text[100]) //TEC.VJ06102025
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Bank Document No.")
        {
            Clustered = true;
        }
        key(PK2; "Batch Type", "Posting Date", "Batch Id")
        {
        }
        key(PK3; "Bank Integration Type", "Batch Type", "Batch Id")
        {
        }
    }
}
