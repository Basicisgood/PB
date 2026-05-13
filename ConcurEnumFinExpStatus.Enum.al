enum 50120 ConcurEnumFinExpStatus
{ //PS006
    Extensible = true;

    value(0; Pending)
    {
    Caption = 'Pending';
    }
    value(1; Processed)
    {
    Caption = 'Processed';
    }
    value(2; Error)
    {
    Caption = 'Error';
    }
    value(3; Cancel)
    {
    Caption = 'Cancel';
    }
    value(4; "Finanace Company Processed")
    {
    Caption = 'Finanace Company Processed';
    }
    value(5; "Ship Shop Company Processed")
    {
    Caption = 'Ship Shop Company Processed';
    }
    //VT 23-12-2024 >>
    value(6; Paid)
    {
    Caption = 'Paid';
    }
//VT 23-12-2024 <<
}
