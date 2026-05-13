table 50166 "Citi Inbound Staging"
{
    Caption = 'Citi Inbound Staging';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "Entry Reference"; Code[35])
        {
        }
        field(3; CreateDate; DateTime)
        {
        }
        field(4; FromDate; DateTime)
        {
        }
        field(5; ToDate; DateTime)
        {
        }
        field(6; "Bank Account"; Text[34])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Currency; Code[3])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "SWIFT Code"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(9; EntryCurrency; Code[3])
        {
            DataClassification = ToBeClassified;
        }
        field(10; EntryAmount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; EntryCrDrInd; Text[4])
        {
            DataClassification = ToBeClassified;
        }
        field(12; EntryBookingDate; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(13; EntryRevInd; Text[5])
        {
            DataClassification = ToBeClassified;
        }
        field(14; EntryStatus; Text[4])
        {
            DataClassification = ToBeClassified;
        }
        field(15; EntryBookedDate; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(16; EntryValueDate; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(17; EntryAccountServRef; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(18; EntryTransCode; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(19; EntryIssuer; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(20; EntryMessageId; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(21; EntryPmtInfid; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Entry Transaction Number"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(23; TxReference; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(24; TxMessageId; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(25; TxAccountServicerRef; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(26; TxPmtInfid; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(27; TxInstructionID; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(28; TxEndtoEndId; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(29; TxInstdAmt; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(30; TxTransactionAmt; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(31; TxTransCode; Code[4])
        {
            DataClassification = ToBeClassified;
        }
        field(32; TxIssuer; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(33; TxChargeAmt; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(34; TxChargeCrDbtInd; Text[2])
        {
            DataClassification = ToBeClassified;
        }
        field(35; TxName; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(36; "Creditor Account Number"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(37; TxAccountServicerReference; text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(38; "Transaction Identification"; text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(39; "Related Parties Name "; text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Clearinging System Member Id"; text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(41; "Additional Entry Information"; text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(42; "Processed"; Boolean)
        {
            DataClassification = ToBeClassified;
        //Editable = false;
        }
        field(43; "Error Message"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(44; TxAmt; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(45; TxCurrency; code[3])
        {
            DataClassification = ToBeClassified;
        }
        field(46; XChangeRate; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2: 7;
        }
        field(47; "Creditor Name"; Text[70])
        {
            DataClassification = ToBeClassified;
        }
        field(48; "Creditor Agent Name"; Text[70])
        {
            DataClassification = ToBeClassified;
        }
        field(49; "Remittance Information"; text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(50; Source; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "52", "53";
        }
        field(51; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Pending, Error, Success, Duplicate, Cancelled, Created, Posted;
        }
        field(52; "MSC DESC"; Text[120])
        {
            DataClassification = ToBeClassified;
        }
        //#190 TEC.VJ 29012025>>
        field(53; "Journal Template Name"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(54; "Journal Batch Name"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        //#190 TEC.VJ 29012025<<
        field(55; "Opening Available"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(56; "Opening Booked"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(57; "Closing Booked"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(58; "Closing Available"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59; "Statement Id"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(60; "Bank Account No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(61; "Executed Scenario"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
