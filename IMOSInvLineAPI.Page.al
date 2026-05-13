page 50169 IMOSInvLineAPI
{
    ApplicationArea = All;
    Caption = 'imosInvLineAPI';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "IMOS Invoice Line";
    Editable = true;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(lineNo; Rec."Line No")
                {
                    Caption = 'Line No';
                    ApplicationArea = All;
                }
                field(actDate; Rec.actDate)
                {
                    Caption = 'actDate';
                    ApplicationArea = All;
                }
                field(baseCurrencyAmount; Rec.baseCurrencyAmount)
                {
                    Caption = 'baseCurrencyAmount';
                    ApplicationArea = All;
                }
                field(companyCode; Rec.companyCode)
                {
                    Caption = 'companyCode';
                    ApplicationArea = All;
                }
                field(currency; Rec.currency)
                {
                    Caption = 'currency';
                    ApplicationArea = All;
                }
                field(currencyAmount; Rec.currencyAmount)
                {
                    Caption = 'currencyAmount';
                    ApplicationArea = All;
                }
                field(deptCode; Rec.deptCode)
                {
                    Caption = 'deptCode';
                    ApplicationArea = All;
                }
                field(exchangeRate; Rec.exchangeRate)
                {
                    Caption = 'exchangeRate';
                    ApplicationArea = All;
                }
                field(intercompanyCode; Rec.intercompanyCode)
                {
                    Caption = 'intercompanyCode';
                    ApplicationArea = All;
                }
                field(ledgerCategory; Rec.ledgerCategory)
                {
                    Caption = 'ledgerCategory';
                    ApplicationArea = All;
                }
                field(ledgerCode; Rec.ledgerCode)
                {
                    Caption = 'ledgerCode';
                    ApplicationArea = All;
                }
                field(vesselType; Rec.vesselType)
                {
                    Caption = 'vesselType';
                    ApplicationArea = All;
                }
                field(tciVesselNumber; Rec.tciVesselNumber)
                {
                    Caption = 'tciVesselNumber';
                    ApplicationArea = All;
                }
                field(transNo; Rec.transNo)
                {
                    Caption = 'transNo';
                    ApplicationArea = All;
                }
                field(vendorExternalRef; Rec.vendorExternalRef)
                {
                    Caption = 'vendorExternalRef';
                    ApplicationArea = All;
                }
                field(vesselCode; Rec.vesselCode)
                {
                    Caption = 'vesselCode';
                    ApplicationArea = All;
                }
                field(vesselCrossRef; Rec.vesselCrossRef)
                {
                    Caption = 'vesselCrossRef';
                    ApplicationArea = All;
                }
                field(vesselExternalRef; Rec.vesselExternalRef)
                {
                    Caption = 'vesselExternalRef';
                    ApplicationArea = All;
                }
                field(vesselImoNo; Rec.vesselImoNo)
                {
                    Caption = 'vesselImoNo';
                    ApplicationArea = All;
                }
                field(vesselName; Rec.vesselName)
                {
                    Caption = 'vesselName';
                    ApplicationArea = All;
                }
                field(voyageNo; Rec.voyageNo)
                {
                    Caption = 'voyageNo';
                    ApplicationArea = All;
                }
                field(voyageTCICode; Rec.voyageTCICode)
                {
                    Caption = 'voyageTCICode';
                    ApplicationArea = All;
                }
                field(voyageTCOCode; Rec.voyageTCOCode)
                {
                    Caption = 'voyageTCOCode';
                    ApplicationArea = All;
                }
            }
        }
    }
}
