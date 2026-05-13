page 50156 APIExchRate
{
    //  ApplicationArea = All;
    Caption = 'apiExchRate';
    DelayedInsert = true;
    PageType = API;
    SourceTable = "Exch Rate Details";
    APIPublisher = 'PB';
    APIGroup = 'Exchrate';
    APIVersion = 'v2.0', 'v1.0';
    EntityName = 'BoombergExchrate';
    EntitySetName = 'BoombergExchrate';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(currencyCode; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                }
                field("date"; Rec."Date")
                {
                    Caption = 'Date';
                }
                field(exchangeRate; Rec."Exchange Rate")
                {
                    Caption = 'Exchange Rate';
                }
                field("LastPrice"; Rec."Last Price")
                {
                    Caption = 'Last Price';
                }
            }
        }
    }
}
