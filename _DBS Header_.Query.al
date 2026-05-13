query 50103 "DBS Header"
{
    Caption = 'DBS Header';
    QueryType = Normal;
    DataAccessIntent = ReadOnly;

    elements
    {
        dataitem(IMOSVoyageLookupTable;
            "IMOS Voyage Lookup Table")
        {
            column(FD1Name;
                FD1Name)
            {
            }
            column(Count)
            {
                Method = Count;
            }
            filter(Period_Date;
                "Period Date")
            {
            }
        }
    }
    trigger OnBeforeOpen()
    begin
    end;
}
