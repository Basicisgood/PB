table 50170 "Concur inbound financial Expen"
{
    Caption = 'Concur inbound financial Expense';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Entry no."; Integer)
        {
            Caption = 'Entry no.';
        }
        // field(2; "Batch ID"; Code[13])
        // {
        //     Caption = 'Batch ID';
        // }
        field(2; "Concur ID"; text[100])
        {
            Caption = 'Concur ID';
        }
        field(3; "Batch Date"; Date)
        {
            Caption = 'Batch Date';
        }
        field(4; "Sequence Number"; Text[50])
        {
            Caption = 'Sequence Number';
        }
        field(5; "EMP ID"; Code[20])
        {
            Caption = 'FD6_Employee';
        }
        field(6; "Last Name"; Text[35])
        {
            Caption = 'Last Name';
        }
        field(7; "First Name"; Text[35])
        {
            Caption = 'First Name';
        }
        field(8; "Group ID"; Text[100])
        {
            Caption = 'Group ID';
        }
        field(9; "Employee Org Unit 1 Region"; Text[100])
        {
            Caption = 'Employee Org Unit 1 Region';
        }
        field(10; "Employee Org Unit 3"; Text[100])
        {
            Caption = 'Employee Org Unit 3';
        }
        field(11; "Employee Org Unit 4-FD5"; Text[100])
        {
            Caption = 'Employee Org Unit 4-FD5';
        }
        field(12; "New FD5"; Text[100])
        {
            Caption = 'New FD5';
        }
        field(13; "Report ID"; Text[100])
        {
            Caption = 'Report ID';
        }
        field(14; "Report Key"; Text[100])
        {
            Caption = 'Ext. Document no.';
        }
        field(15; Ledger; Text[100])
        {
            Caption = 'Ledger';
        }
        field(16; "reimb. Currency Alpha ISE"; Text[100])
        {
            Caption = 'Reimbursement Currency Alpha ISE';
        }
        field(17; "Home Country"; Text[100])
        {
            Caption = 'Home Country';
        }
        field(18; "Report Submit Date"; Text[100])
        {
            Caption = 'Report Submit Date';
        }
        field(19; "Report User Defined Date"; Text[100])
        {
            Caption = 'Report User Defined Date';
        }
        field(20; "Report Payment Processing Date"; Text[100])
        {
            Caption = 'Journal Date';
        }
        field(21; "Report Name"; Text[100])
        {
            Caption = 'Report Name';
        }
        field(22; "Report image required"; Text[100])
        {
            Caption = 'Report image required';
        }
        field(23; "Report has VAT entry"; Text[100])
        {
            Caption = 'Report has VAT entry';
        }
        field(24; "Report has TA entry"; Text[100])
        {
            Caption = 'Report has TA entry';
        }
        field(25; "Report Total Post Amount"; Text[100])
        {
            Caption = 'Report Total Post Amount';
        }
        field(26; "Report Total Approved Amount"; Text[100])
        {
            Caption = 'Report Total Approved Amount';
        }
        field(27; "Report Policy Name"; Text[100])
        {
            Caption = 'Report Policy Name';
        }
        field(28; "Report Org Unit 3   Division"; Text[100])
        {
            Caption = 'Report Org Unit 3   Division';
        }
        field(29; "Report Org Unit 4   Company"; Text[100])
        {
            Caption = 'Report Org Unit 4   Company';
        }
        field(30; "Report Custom 12   "; Text[100])
        {
            Caption = 'FD5_Department';
        }
        field(31; "Custom 13-Corp Card acc Code"; Text[100])
        {
            Caption = 'Custom 13-Corp Card accounts Code';
        }
        field(32; "Custom 14-Employee Acc code"; Text[100])
        {
            Caption = 'Custom 14-Employee Account code';
        }
        field(33; "Report Custom 17  "; Text[100])
        {
            Caption = 'Report Custom 17  ';
        }
        field(34; "Entry Id"; Text[100])
        {
            Caption = 'Entry Id';
        }
        field(35; "Entry Transaction Type"; Text[100])
        {
            Caption = 'Entry Transaction Type';
        }
        field(36; "Expense Type Name"; Text[100])
        {
            Caption = 'Expense Type Name';
        }
        field(37; "Entry Transaction Date"; Text[100])
        {
            Caption = 'Entry Transaction Date';
        }
        field(38; "Spend Currency Alpha ISO"; Text[100])
        {
            Caption = 'Transaction Currency';
        }
        field(39; "Currency Exchange Rate"; Text[100])
        {
            Caption = 'Currency Exchange Rate';
        }
        field(40; "Exchange Rate Direction"; Text[100])
        {
            Caption = 'Exchange Rate Direction';
        }
        field(41; "Is Personal"; Text[100])
        {
            Caption = 'Is Personal';
        }
        field(42; "Entry Description"; Text[100])
        {
            Caption = 'Journal Desscription';
        }
        field(43; "Vendor Description"; Text[100])
        {
            Caption = 'Vendor Description';
        }
        field(44; "Receipt Received"; Text[100])
        {
            Caption = 'Receipt Received';
        }
        field(45; "Receipt Type"; Text[100])
        {
            Caption = 'Receipt Type';
        }
        field(46; "Total Employee Attendee"; Text[100])
        {
            Caption = 'Total Employee Attendee';
        }
        field(47; "Attendee count spouse"; Text[100])
        {
            Caption = 'Attendee count spouse';
        }
        field(48; "Attendee count business"; Text[100])
        {
            Caption = 'Attendee count business';
        }
        field(49; "Report Entry Custom1 Proj Code"; Text[100])
        {
            Caption = 'Report Entry Custom 1 Project Code';
        }
        field(50; "Report Entry Custom2(DOC code)"; Text[100])
        {
            Caption = 'Report Entry Custom 2 (DOC code)';
        }
        field(51; "Report Entry Custom3 CT trvl"; Text[100])
        {
            Caption = 'Report Entry Custom 3 Client Travelling';
        }
        field(52; "Custom 35-Tax Reclaim Country"; Text[100])
        {
            Caption = 'Custom 35-Tax Reclaim Country';
        }
        field(53; "Custom 39-Tax Reclaim Amount"; Text[100])
        {
            Caption = 'Custom 39-Tax Reclaim Amount';
        }
        field(54; "Custom 40-Net of Tax Amount"; Text[100])
        {
            Caption = 'Custom 40-Net of Tax Amount';
        }
        field(55; "Foreign Entry Trans. Amount"; Text[100])
        {
            Caption = 'Foreign Entry Transaction Amount';
        }
        field(56; "Entry Posted Amount (Incl GST)"; Text[100])
        {
            Caption = 'Entry Posted Amount (Incl GST)';
        }
        field(57; "Entry Approved Amount"; Text[100])
        {
            Caption = 'Approved Amount(incl Tax.)';
        }
        field(58; "Entry Payment Code "; Text[100])
        {
            Caption = 'Entry Payment Code ';
        }
        field(59; "Entry Payment Code Name"; Text[100])
        {
            Caption = 'Entry Payment Code Name';
        }
        field(60; "Entry Country"; Text[100])
        {
            Caption = 'Entry Country';
        }
        field(61; "Entry Country Sub"; Text[100])
        {
            Caption = 'Entry Country Sub';
        }
        field(62; "Domestic Foreign"; Text[100])
        {
            Caption = 'Domestic Foreign';
        }
        field(63; PayerPayType; Text[100])
        {
            Caption = 'PayerPayType';
        }
        field(64; PayeePayType; Text[100])
        {
            Caption = 'PayeePayType';
        }
        field(65; PayeePayCode; Text[100])
        {
            Caption = 'PayeePayCode';
        }
        field(66; DRCR; Text[100])
        {
            Caption = 'DRCR';
        }
        field(67; JournalAmt; Text[100])
        {
            Caption = 'JournalAmt';
        }
        field(68; "Journal Key"; Text[100])
        {
            Caption = 'Account Code';
        }
        field(69; "Allocation Alloc Key"; Text[100])
        {
            Caption = 'Allocation Alloc Key';
        }
        field(70; "Allocation Percentage"; Text[100])
        {
            Caption = 'Allocation Percentage';
        }
        field(71; "Future Use-RES for Bank Acc"; Text[100])
        {
            Caption = 'Future Use-RES for Bank Account';
        }
        field(72; "Future Use-RES for Rtn Number"; Text[100])
        {
            Caption = 'Future Use-RES for Routing Number';
        }
        field(73; "Tax authority name"; Text[100])
        {
            Caption = 'Tax authority name';
        }
        field(74; "Tax label"; Text[100])
        {
            Caption = 'Tax label';
        }
        field(75; "Tax transaction amount"; Text[100])
        {
            Caption = 'Tax transaction amount';
        }
        field(76; "Tax posted amount"; Text[100])
        {
            Caption = 'Tax posted amount';
        }
        field(77; "Tax source"; Text[100])
        {
            Caption = 'Tax source';
        }
        field(78; "Tax reclaim transaction amount"; Text[100])
        {
            Caption = 'Tax reclaim transaction amount';
        }
        field(79; "Tax reclaim posted amount"; Text[100])
        {
            Caption = 'Tax reclaim posted amount';
        }
        field(80; "Reclaim Domestic Flag"; Text[100])
        {
            Caption = 'Reclaim Domestic Flag';
        }
        field(81; "Report Entry Tax Adj. Amount"; Text[100])
        {
            Caption = 'Report Entry Tax Adjusted Amount';
        }
        field(82; "Report Entry Tax Reclm Adj.Amt"; Text[100])
        {
            Caption = 'Report Entry Tax Reclaim Adjusted Amount ';
        }
        field(83; "Report Entry Tax Rec T_Adj.Amt"; Text[100])
        {
            Caption = 'Report Entry Tax Reclaim Transaction Adjusted Amount';
        }
        field(84; "Net Tax Amount"; Text[100])
        {
            Caption = 'Amount(excl Tax)';
        }
        field(85; "Report Entry Tot Reclm Adj.Amt"; Text[100])
        {
            Caption = 'Report Entry Total Reclaim Adjusted Amount';
        }
        field(86; "Net adjusted Reclaim Amount"; Text[100])
        {
            Caption = 'Net adjusted Reclaim Amount';
        }
        field(87; "Payment Type"; Text[100])
        {
            Caption = 'Payment Type';
        }
        field(88; "Global Dim 1 Code (FD1_Subseg)"; Code[20])
        {
            Caption = 'Global Dimension 1 Code (FD1_Subsegment)';
        }
        field(89; "Global Dim 2 Code (FD10_JType)"; Code[20])
        {
            Caption = 'Global Dimension 2 Code (FD10_JType)';
        }
        field(90; "Shortcut Dim 5 Code FD5_Dept "; Code[20])
        {
            Caption = 'Shortcut Dimension 5 Code FD5_Department ';
        }
        field(91; "Shortcut Dim 6 Code FD6_Emp"; Code[20])
        {
            Caption = 'Shortcut Dimension 6 Code FD6_Employee';
        }
        field(92; "Shortcut Dim 8 Code FD8_Comp"; Code[20])
        {
            Caption = 'Shortcut Dimension 8 Code FD8_Company';
        }
        field(93; "Status "; Text[100])
        {
            Caption = 'Status ';
        }
        field(94; "Description (Error message)"; Text[100])
        {
            Caption = 'Description (Error message)';
        }
        field(95; "Creation date/time "; Date)
        {
            Caption = 'Creation date/time ';
        }
        field(96; "Processed date/time "; Date)
        {
            Caption = 'Processed date/time ';
        }
        field(97; "Process status "; Text[100])
        {
            Caption = 'Process status ';
        }
        field(98; "Process error message "; Text[100])
        {
            Caption = 'Process error message ';
        }
        //////////////////////////////////////////
        field(99; "Journal Type"; Text[100])
        {
            Caption = 'Journal Type';
        }
        field(100; "Report Currency"; Text[100])
        {
            Caption = 'Report Currency';
        }
        field(101; "Shipsign"; Text[100])
        {
            Caption = 'Shipsign';
        }
        field(102; "Entry Custom 2(DOC Code)"; Text[100])
        {
            Caption = 'DOC Code';
        }
        field(103; "Employee name"; Text[100])
        {
            Caption = 'Employee name';
        }
        field(104; "Journal Tax Amount"; Text[100])
        {
            Caption = 'Journal Tax Amount';
        }
        field(105; "Journal Net Amount"; Text[100])
        {
            Caption = 'Journal Net Amount (ecl Tax)';
        }
        field(106; "Entry Date"; Text[100])
        {
            Caption = 'Entry Date';
        }
        field(107; "Report Org Unit 3"; Text[100])
        {
            Caption = 'FD8_Company';
        }
        field(108; "Legacy Entry Id"; Text[100])
        {
            Caption = 'Legacy Entry Id';
        }
        field(109; "Tax id"; Text[100])
        {
            Caption = 'Tax id';
        }
        //PS006 Start
        field(110; "Expense Status";Enum ConcurEnumFinExpStatus)
        {
            Caption = 'Expense Status';
        // Editable = false;
        }
        field(111; "Finance Company No"; text[50])
        {
            caption = 'Finance Company No';
        }
        field(112; "Ship Sign Company No"; text[50])
        {
            caption = 'Ship Sign Company No';
        }
        field(113; "Posted Document No Fin Company"; code[20])
        {
            caption = 'Posted Document No Fin Company';
        }
        field(114; "Posted Document No Shp Company"; code[20])
        {
            caption = 'Posted Document No Ship Company';
        }
        field(115; "Error Description"; Text[1000])
        {
            Caption = 'Error Description';
        //Editable = false;
        }
        field(116; "Cancelled by User"; Code[50])
        {
        //Editable = false;
        }
        field(117; "Cancelled Date time"; DateTime)
        {
        //Editable = false;
        }
        //PS006 End
        field(118; "API Log Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(119; "Cash Led entry description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(120; "Cash Led journal entry descri"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        //VJ#68
        field(121; "Receipt image ID"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        //VJ#68
        //VT24122024 >>
        field(122; "Payment Journal Document No."; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        //VT24122024 <<
        //PS009 Start
        field(123; UUID; text[250])
        {
            DataClassification = ToBeClassified;
        }
        //PS009 End
        //VJ 27/01/2025
        field(124; "Cashledger Employee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        //VJ 27/01/2025
        field(125; "Calculated Tax Amount"; Decimal)
        {
        }
    }
    keys
    {
        key(PK; "Entry no.")
        {
            Clustered = true;
        }
        key(Key2; "Report ID")
        {
        } //PS006
        key(key3; "Report ID", "Report Key")
        {
        } //VT
    }
}
