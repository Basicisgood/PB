table 50177 "Payment Enquiry Status Setup"
{
    Caption = 'Payment Enquiry Status Setup';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Pending, Sent, Fail, Approved, Rejected, Booked, Settled, "Bank Process";
            Caption = 'Status';
        }
        field(2; Reprocess; Boolean)
        {
            Caption = 'Reprocess';
        }
    }
    keys
    {
        key(PK; Status)
        {
            Clustered = true;
        }
    }
}
