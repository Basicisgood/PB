query 50101 ManagementFeeDistributionQuery
{
    QueryType = API;
    APIPublisher = 'PublisherName';
    APIGroup = 'GroupName';
    EntityName = 'ManagementFeeDistribution';
    EntitySetName = 'EntitySetName';

    elements
    {
        dataitem(DAYSOURCE;
            DAYSOURCE)
        {
            column(T1;
                T1)
            {
            }
            column(Days_Type;
                "Days Type")
            {
            }
            column(Period;
                Period)
            {
            }
            column(Source_Date;
                "Source Date")
            {
            }
            column(Company_Name;
                "Company Name")
            {
            }
            column(IC_Partner_Code;
                "IC Partner Code")
            {
            }
            column(Days;
                Days)
            {
                Method = Sum;
            }
            filter(Days_Type_FILTER;
                "Days Type")
            {
            }
            filter(Period_FILTER;
                "Period")
            {
            }
            filter(Source_Date_FILTER;
                "Source Date")
            {
            }
            filter(Company_Name_FILTER;
                "Company Name")
            {
            }
            filter(IC_Partner_Code_FILTER;
                "IC Partner Code")
            {
            }
        }
    }
    var myInt: Integer;
    trigger OnBeforeOpen()
    begin
    end;
}
