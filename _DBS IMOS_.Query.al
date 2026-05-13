query 50107 "DBS IMOS"
{
    Caption = 'DBS IMOS';
    QueryType = Normal;
    DataAccessIntent = ReadOnly;

    elements
    {
        dataitem(IMOS_Voyage_Lookup_Table;
            "IMOS Voyage Lookup Table")
        {
            column(FD2;
                FD2)
            {
            }
            column(FD3;
                FD3)
            {
            }
            column(FD4;
                FD4)
            {
            }
            column(TC_Type;
                "TC Type")
            {
            }
            column(NewContractType_full;
                NewContractType_full)
            {
            }
            filter(FD1Name;
                FD1Name)
            {
            }
            filter(Period_Date;
                "Period Date")
            {
            }
        }
    }
}
