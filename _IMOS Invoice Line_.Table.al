table 50176 "IMOS Invoice Line"
{
    Caption = 'IMOS Invoice Line';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Invoice Entry No."; Integer)
        {
            Caption = 'Invoice Entry No.';
        }
        field(2; "Line No"; Integer)
        {
            Caption = 'Line No';
        }
        field(3; transNo; Text[100])
        {
            Caption = 'transNo';
        }
        field(4; transType; Integer)
        {
            Caption = 'transType';
        }
        field(5; seqNo; Text[10])
        {
            Caption = 'seqNo';
        }
        field(6; oprSeqNo; Integer)
        {
            Caption = 'oprSeqNo';
        }
        field(7; oprBillCode; Text[100])
        {
            Caption = 'oprBillCode';
        }
        field(8; billSubSeq; Integer)
        {
            Caption = 'billSubSeq';
        }
        field(9; billSubCode; Text[20])
        {
            Caption = 'billSubCode';
        }
        field(10; billSubSource; Text[20])
        {
            Caption = 'billSubSource';
        }
        field(11; companyCode; Text[10])
        {
            Caption = 'companyCode';
        }
        field(12; companyExternalRef; Text[20])
        {
            Caption = 'companyExternalRef';
        }
        field(13; companyContact; Text[30])
        {
            Caption = 'companyContact';
        }
        field(14; companyContactPhone; Text[30])
        {
            Caption = 'companyContactPhone';
        }
        field(15; lobCode; Text[10])
        {
            Caption = 'lobCode';
        }
        field(16; deptCode; Text[10])
        {
            Caption = 'deptCode';
        }
        field(17; vesselCode; Text[20])
        {
            Caption = 'vesselCode';
        }
        field(18; vesselName; Text[50])
        {
            Caption = 'vesselName';
        }
        field(19; vesselExternalRef; Text[20])
        {
            Caption = 'vesselExternalRef';
        }
        field(20; vesselCrossRef; Text[20])
        {
            Caption = 'vesselCrossRef';
        }
        field(21; vesselImoNo; Text[20])
        {
            Caption = 'vesselImoNo';
        }
        field(22; vesselType; Text[20])
        {
            Caption = 'vesselType';
        }
        field(23; vesselGRT; Decimal)
        {
            Caption = 'vesselGRT';
        }
        field(24; vendorNo; Integer)
        {
            Caption = 'vendorNo';
        }
        field(25; vendorName; Text[150])
        {
            Caption = 'vendorName';
        }
        field(26; vendorShortName; Text[50])
        {
            Caption = 'vendorShortName';
        }
        field(27; vendorExternalRef; Text[30])
        {
            Caption = 'vendorExternalRef';
        }
        field(28; vendorCrossRef; Text[30])
        {
            Caption = 'vendorCrossRef';
        }
        field(29; vendorReferenceCode; Text[20])
        {
            Caption = 'vendorReferenceCode';
        }
        field(30; vendorIsInternal; Boolean)
        {
            Caption = 'vendorIsInternal';
        }
        field(31; vendorType; Text[10])
        {
            Caption = 'vendorType';
        }
        field(32; intercompanyCode; Text[20])
        {
            Caption = 'intercompanyCode';
        }
        field(33; voyageNo; Integer)
        {
            Caption = 'voyageNo';
        }
        field(34; fixtureNo; Text[10])
        {
            Caption = 'fixtureNo';
        }
        field(35; portName; Text[60])
        {
            Caption = 'portName';
        }
        field(36; portNo; Integer)
        {
            Caption = 'portNo';
        }
        field(37; portUNCode; Text[10])
        {
            Caption = 'portUNCode';
        }
        field(38; portCountryCode; Text[10])
        {
            Caption = 'portCountryCode';
        }
        field(39; ledgerCode; Text[10])
        {
            Caption = 'ledgerCode';
        }
        field(40; ledgerCategory; Text[20])
        {
            Caption = 'ledgerCategory';
        }
        field(41; aparCode; Text[20])
        {
            Caption = 'aparCode';
        }
        field(42; actDate; Date)
        {
            Caption = 'actDate';
        }
        field(43; memo; Text[500])
        {
            Caption = 'memo';
        }
        field(44; currencyAmount; Decimal)
        {
            Caption = 'currencyAmount';
        }
        field(45; currency; Text[10])
        {
            Caption = 'currency';
        }
        field(46; exchangeRate; Decimal)
        {
            Caption = 'exchangeRate';
        }
        field(47; exchangeRateDate; Text[30])
        {
            Caption = 'exchangeRateDate';
        }
        field(48; baseCurrencyAmount; Decimal)
        {
            Caption = 'baseCurrencyAmount';
        }
        field(49; taxCode; Text[10])
        {
            Caption = 'taxCode';
        }
        field(50; companyBrokerage; Text[10])
        {
            Caption = 'companyBrokerage';
        }
        field(51; counterpartyBrokerage; Text[20])
        {
            Caption = 'counterpartyBrokerage';
        }
        field(52; lastUserId; Text[20])
        {
            Caption = 'lastUserId';
        }
        field(53; lastModifiedDate; Text[50])
        {
            Caption = 'lastModifiedDate';
        }
        field(54; description; Text[250])
        {
            Caption = 'description';
        }
        field(55; taxRate; Decimal)
        {
            Caption = 'taxRate';
        }
        field(56; tradeRoute; Text[10])
        {
            Caption = 'tradeRoute';
        }
        field(57; tradeRouteCode; Text[10])
        {
            Caption = 'tradeRouteCode';
        }
        field(58; tradeRouteExtRef; Text[20])
        {
            Caption = 'tradeRouteExtRef';
        }
        field(59; oprType; Text[10])
        {
            Caption = 'oprType';
        }
        field(60; opsCoordinator; Text[20])
        {
            Caption = 'opsCoordinator';
        }
        field(61; voyRef; Text[20])
        {
            Caption = 'voyRef';
        }
        field(62; voyageCompanyCode; Text[20])
        {
            Caption = 'voyageCompanyCode';
        }
        field(63; voyageTCICode; Text[20])
        {
            Caption = 'voyageTCICode';
        }
        field(64; voyageTCOCode; Text[20])
        {
            Caption = 'voyageTCOCode';
        }
        field(65; voyageCommenceDateTime; Text[30])
        {
            Caption = 'voyageCommenceDateTime';
        }
        field(66; voyageCompletionDateTime; Text[30])
        {
            Caption = 'voyageCompletionDateTime';
        }
        field(67; rate; Decimal)
        {
            Caption = 'rate';
        }
        field(68; percentage; Decimal)
        {
            Caption = 'percentage';
        }
        field(69; quantity; Decimal)
        {
            Caption = 'quantity';
        }
        field(70; BLDate; Text[30])
        {
            Caption = 'BLDate';
        }
        field(71; BLCode; Text[20])
        {
            Caption = 'BLCode';
        }
        field(72; cpUnit; Text[10])
        {
            Caption = 'cpUnit';
        }
        field(73; consignee; Text[20])
        {
            Caption = 'consignee';
        }
        field(74; commercialId; Text[10])
        {
            Caption = 'commercialId';
        }
        field(75; consigneeNo; Integer)
        {
            Caption = 'consigneeNo';
        }
        field(76; agent; Text[10])
        {
            Caption = 'agent';
        }
        field(77; refBLNo; Text[10])
        {
            Caption = 'refBLNo';
        }
        field(78; combineIndicator; Text[10])
        {
            Caption = 'combineIndicator';
        }
        field(79; transhipIndicator; Text[10])
        {
            Caption = 'transhipIndicator';
        }
        field(80; transhipSeq; Integer)
        {
            Caption = 'transhipSeq';
        }
        field(81; transhipDate; Date)
        {
            Caption = 'transhipDate';
        }
        field(82; transhipPort; Text[10])
        {
            Caption = 'transhipPort';
        }
        field(83; transhipToVessel; Text[10])
        {
            Caption = 'transhipToVessel';
        }
        field(84; transhipToVoyNo; Integer)
        {
            Caption = 'transhipToVoyNo';
        }
        field(85; transhipGross; Decimal)
        {
            Caption = 'transhipGross';
        }
        field(86; transhipGrossUnit; Text[10])
        {
            Caption = 'transhipGrossUnit';
        }
        field(87; cargoFullName; Text[100])
        {
            Caption = 'cargoFullName';
        }
        field(88; cargoGroupCode; Text[10])
        {
            Caption = 'cargoGroupCode';
        }
        field(89; blQty; Decimal)
        {
            Caption = 'blQty';
            DecimalPlaces = 0: 5;
        }
        field(90; cargoId; Integer)
        {
            Caption = 'cargoId';
        }
        field(91; importedCargo; Text[10])
        {
            Caption = 'importedCargo';
        }
        field(92; coaNo; Text[10])
        {
            Caption = 'coaNo';
        }
        field(93; cargoRefContract; Text[20])
        {
            Caption = 'cargoRefContract';
        }
        field(94; cargoExposureVesselNumber; Text[20])
        {
            Caption = 'cargoExposureVesselNumber';
        }
        field(95; portCallSeq; Integer)
        {
            Caption = 'portCallSeq';
        }
        field(96; voyageRef; Text[10])
        {
            Caption = 'voyageRef';
        }
        field(97; bunkerType; Text[10])
        {
            Caption = 'bunkerType';
        }
        field(98; tciVesselNumber; Text[10])
        {
            Caption = 'tciVesselNumber';
        }
        field(99; tciReference; Text[10])
        {
            Caption = 'tciReference';
        }
        field(100; cargoVesselNumber; Text[10])
        {
            Caption = 'cargoVesselNumber';
        }
        field(101; cargoReference; Text[10])
        {
            Caption = 'cargoReference';
        }
        field(102; vesselFlag; Text[10])
        {
            Caption = 'vesselFlag';
        }
    }
    keys
    {
        key(PK; "Invoice Entry No.", "Line No")
        {
            Clustered = true;
        }
    }
}
