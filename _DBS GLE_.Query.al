query 50106 "DBS GLE"
{
    Caption = 'DBS GLE';
    QueryType = Normal;
    DataAccessIntent = ReadOnly;

    elements
    {
        dataitem(GLEntry;
            "G/L Entry")
        {
            column(Amount;
                Amount)
            {
                Method = Sum;
            }
            filter(G_L_Account_No_;
                "G/L Account No.")
            {
            }
            filter(Global_Dimension_1_Code;
                "Global Dimension 1 Code")
            {
            }
            filter(Shortcut_Dimension_10_Code_PB;
                "Shortcut Dimension 10 Code_PB")
            {
            }
            filter(Shortcut_Dimension_3_Code;
                "Shortcut Dimension 3 Code")
            {
            }
            filter(Shortcut_Dimension_4_Code;
                "Shortcut Dimension 4 Code")
            {
            }
            filter(Posting_Date;
                "Posting Date")
            {
            }
        }
    }
}
