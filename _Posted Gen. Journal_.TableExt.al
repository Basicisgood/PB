tableextension 50145 "Posted Gen. Journal" extends "Posted Gen. Journal Line"
{
    fields
    {
        //#332 TEC.VJ 08MAY2025>>
        field(50100; "Alloc. Rule"; Code[20])
        {
            Caption = 'Allocation Rule';
            DataClassification = ToBeClassified;
            TableRelation = "Allocation Rule";
        }
        field(50102; "Company Code"; Text[30])
        {
            Caption = 'Company Code';
            DataClassification = ToBeClassified;
            TableRelation = Company;
        }
        field(50103; "Prepared by"; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50104; "Certified Correct by"; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50105; "Approved by"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50106; "Approver A Grp User"; Code[50])
        {
            Caption = 'Approver A Group User';
            DataClassification = CustomerContent;
            TableRelation = "User Setup"."User ID" where("User Type"=filter("Approver A group"|"Approver B group"));
            ValidateTableRelation = false;
        }
        field(50107; "Approver B Grp User"; Code[50])
        {
            Caption = 'Approver B Group User';
            DataClassification = CustomerContent;
            TableRelation = "User Setup"."User ID" where("User Type"=filter("Approver A group"));
            ValidateTableRelation = false;
        }
        field(50110; "Invoice Link"; Text[1024])
        {
            DataClassification = CustomerContent;
            Caption = 'Invoice Link';
            ExtendedDatatype = URL;
        }
        field(50115; "No Corresponding Bank for Pmt"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'No Corresponding Bank For Payment';
        }
        field(50116; "Bank Charge Debit Pymnt. Amt."; code[1])
        {
            DataClassification = ToBeClassified;
            Caption = 'Bank charges Debited from Payment Amount (BOC Only)';
        }
        field(50117; "Correspon. Bank Charges Method"; code[1])
        {
            DataClassification = ToBeClassified;
            Caption = 'Correspondent Bank Charges Method (BOC Only)';
        }
        field(50118; "RMB Remittance Trans. Type";Enum "RMB Remittance Trans. Type")
        {
            DataClassification = ToBeClassified;
            Caption = 'RMB Remittance Transaction Type (BOC Only)';
        }
        field(50119; "Suggest Vendor Line"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Suggest Vendor Line';
        }
        field(50120; "Payment Purpose"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Purpose';
        }
        field(50122; "Report ID"; text[100])
        {
            Caption = 'Report ID';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50123; "Concur ID"; text[100])
        {
            Caption = 'Concur ID';
            DataClassification = ToBeClassified;
        }
        field(50124; "Entry Id"; Text[100])
        {
            Caption = 'Entry Id';
        }
        field(50125; "Receipt image ID"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50126; "Applied Entries to XML"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(50127; "Tax Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50128; "Purpose Code Preflix"; Text[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50129; "Applied Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50130; "Amount Mismatch"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50131; "Additional Entry Information"; text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(50132; "Creditor Name"; Text[70])
        {
            DataClassification = ToBeClassified;
        }
        field(50150; "Invoice Currency Code"; Code[20])
        { //used in split fxnality
        }
        field(50155; "Is Ship Run"; Boolean)
        { //Created to update posted doc no in Concur master -  SGarg
        }
        field(50156; "Fin Company Code"; Text[50])
        {
        //Created to update posted doc no in Concur master -  SGarg
        }
        field(50157; "Ship Company Code"; Text[50])
        {
        //Created to update posted doc no in Concur master -  SGarg
        }
        field(50158; "Txf Account No."; Code[20])
        {
            Caption = 'Txf Account No.';
            TableRelation = if("Account Type"=const("G/L Account"))"G/L Account" where("Account Type"=const(Posting), Blocked=const(false))
            else if("Account Type"=const(Customer))Customer
            else if("Account Type"=const(Vendor))Vendor
            else if("Account Type"=const("Bank Account"))"Bank Account"
            else if("Account Type"=const("Fixed Asset"))"Fixed Asset"
            else if("Account Type"=const("IC Partner"))"IC Partner"
            else if("Account Type"=const("Allocation Account"))"Allocation Account"
            else if("Account Type"=const(Employee))Employee;
        }
        field(50160; "Original Document No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50161; "API Bank Account Indicator"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50162; "Cash Advance"; Boolean)
        {
        }
        field(50163; "Auto Post"; Boolean)
        {
        }
        //#332 TEC.VJ 08MAY2025<<
        field(50165; "Inbound Entry No."; integer) //TEC.VG#05NOV2025
        {
            DataClassification = ToBeClassified;
        }
        field(50201; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(3), Blocked=const(false));
        }
        field(50202; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(4), Blocked=const(false));
        }
        field(50203; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(5), Blocked=const(false));
        }
        field(50204; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(6), Blocked=const(false));
        }
        field(50205; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(7), Blocked=const(false));
        }
        field(50206; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(8), Blocked=const(false));
        }
        field(50207; "Shortcut Dimension 9 Code"; Code[20])
        {
            CaptionClass = '1,2,9';
            Caption = 'Shortcut Dimension 9 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(9), Blocked=const(false));
        }
        field(50208; "Shortcut Dimension 10 Code"; Code[20])
        {
            CaptionClass = '1,2,10';
            Caption = 'Shortcut Dimension 10 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(10), Blocked=const(false));
        }
        field(50209; "Shortcut Dimension 11 Code"; Code[20])
        {
            CaptionClass = '1,2,11';
            Caption = 'Shortcut Dimension 11 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(11), Blocked=const(false));
        }
        field(50210; "Shortcut Dimension 12 Code"; Code[20])
        {
            CaptionClass = '1,2,12';
            Caption = 'Shortcut Dimension 12 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(12), Blocked=const(false));
        }
        field(50211; "Shortcut Dimension 13 Code"; Code[20])
        {
            CaptionClass = '1,2,13';
            Caption = 'Shortcut Dimension 13 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(13), Blocked=const(false));
        }
        field(50212; "Shortcut Dimension 14 Code"; Code[20])
        {
            CaptionClass = '1,2,14';
            Caption = 'Shortcut Dimension 14 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(14), Blocked=const(false));
        }
        field(50213; "Shortcut Dimension 15 Code"; Code[20])
        {
            CaptionClass = '1,2,15';
            Caption = 'Shortcut Dimension 15 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(15), Blocked=const(false));
        }
        field(50214; "Rule Line No."; Integer)
        {
        }
        field(50215; "IC Dimension 5"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50216; "IC Dimension 6"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'IC Dimension 6';
        }
        field(50217; "IC Dimension 1"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50218; "IC Dimension 2"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50219; "IC Dimension 3"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50220; "IC Dimension 4"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50221; "IC Dimension 7"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50222; "IC Dimension 8"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50223; "IC Dimension 9"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50224; "IC Dimension 10"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50225; "IC Dimension 11"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50226; "IC Dimension 12"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50227; "PB DNV invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50228; "PB IC Account Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "G/L Account", "Bank Account";
        }
        field(50229; "World Link"; Text[1024])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = URL;
        }
        field(50230; "Trans. Amt."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50231; "Trans. Currency"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
        field(50232; "IFSC Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50233; "Purpose Code"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50234; "Exchange Rate"; Decimal)
        {
            Caption = 'Exchange Rate (Worldlink)';
            DecimalPlaces = 1: 6;
            MinValue = 0;
            DataClassification = ToBeClassified;
        }
        field(50236; "Employee Bank Account"; Code[20])
        {
            Caption = 'Employee Bank Account';
            TableRelation = if("Account Type"=const(Employee))"Employee Bank Account"."Code" where("Employee No."=field("Account No."), "Is Inactive"=filter(false));
        }
        field(50237; "Payment Set Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Set Code";
        }
        field(50238; "FPS Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Email,FPS ID,Telephon No.';
            OptionMembers = " ", Email, "FPS ID", "Telephon No.";
        }
        field(50239; "FPS No."; text[70])
        {
            DataClassification = ToBeClassified;
        }
        field(50240; "PB Concur invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50300; "Original Invoice No"; text[50])
        {
            caption = 'Original Invoice No';
        }
        field(50398; "Central Payment Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50399; "DNV Crew Payroll Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50400; "IMOS invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50401; "IMOS Transaction No"; Text[50])
        {
            DataClassification = ToBeClassified;
        //Editable = false;
        }
        field(50402; "Remittance Company No"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50403; "Remittance Account No"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50404; "Remittance Full Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50405; "IMOS Bank ID"; Text[30])
        {
            DataClassification = ToBeClassified;
            //Editable = false;
            TableRelation = "IMOS Bank Mapping";
        }
        field(50406; "Bank Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50407; "Bank Transaction Code"; Text[90])
        {
            DataClassification = ToBeClassified;
        }
        field(50408; "CP External Document No"; Text[35])
        {
            DataClassification = ToBeClassified;
        }
        field(50409; "Manual Application Needed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52000; "Lavel Service Code";Enum "Level Service Code")
        {
            DataClassification = ToBeClassified;
        }
        field(52001; "Order Importance"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = HIGH, NORM;
        }
        field(52002; "Charges Bearer"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "SHA", "OUR", "BEN";
            OptionCaption = 'SHA,OUR,BEN';
        }
        field(52003; "Bank Account Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Bank Name';
        }
        field(52004; "Vendor Bank Account Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(52005; "Comment to bank"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(52006; "Instruction to Bank"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(52007; "Remittance Email 1"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(52008; "Remittance Email 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(52009; "Remittance Email 3"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(52010; "Remittance Email 4"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(52011; "Remittance Email 5"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(52012; "Remittance Email 6"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(52013; "Intermediary Bank Account No"; Text[35])
        {
        }
        field(52014; "Intermediary Bank SWIFT / BIC"; Text[35])
        {
        }
        field(52015; "Intermediary Bank Country"; Text[2])
        {
        }
        //dont use field no 55000
        field(60000; HSBC; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60001; "WorkFlow Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Workflow;
        }
        field(60002; "WorkFlow User Group"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Workflow User Group";
        }
        field(60003; "Booking Method"; text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(60004; "Ship Manager Id"; text[250])
        {
            DataClassification = ToBeClassified;
        }
        Field(60005; "DNV Staging Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(60006; "Over Receipt"; Decimal)
        {
            Caption = 'Over Receipt Amount';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60007; "Batch Type";enum "Batch Type")
        {
            DataClassification = ToBeClassified;
        }
        field(60008; "Batch No."; Text[35])
        {
            DataClassification = ToBeClassified;
        }
        field(60009; "Bypass API"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60010; "Payment Method Bank XML"; Code[3])
        {
            Caption = 'Payment Method Bank XML';
            DataClassification = ToBeClassified;
        }
        field(60011; "Bank Charges"; Decimal)
        {
            Caption = 'Bank Charges';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60012; "CP Over Receipt"; Boolean)
        {
            Caption = 'CP Over Receipt';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70000; "Is Vat Line"; Boolean)
        {
        //Added by Sgarg for temporary use , to flow Original amount in VAt GL Entry
        }
        field(70001; "Skip Detail GLE"; Boolean)
        {
        }
        field(70002; "PB IC Account"; code[20])
        {
            TableRelation = if("PB IC Account Type"=const("G/L Account"))"IC G/L Account" where("Account Type"=const(Posting), Blocked=const(false))
            else if("PB IC Account Type"=const("Bank Account"))"IC Bank Account" where("IC Partner Code"=field("Account No."));
        }
        field(70003; "PB IC Journal Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name"=field("PB IC Journal Template Name"));
        }
        field(70004; "PB IC Journal Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
    }
}
