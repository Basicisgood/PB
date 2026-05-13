enum 50123 "Bank Paym Enquiry API Status"
{
    Extensible = true;
    Caption = 'Bank Payment Enquiry API Status';

    // Pending,Sent,Fail,Approved,Rejected,Booked,Settled,"Bank Process";
    value(1; Fail)
    {
    }
    value(2; Sent)
    {
    }
    value(3; Pending)
    {
    }
    value(4; Approved)
    {
    }
    value(5; Rejected)
    {
    }
    value(6; Settled) //#219
    {
    }
    value(7; Booked)
    {
    }
    value(8; "Bank Process")
    {
    }
}
