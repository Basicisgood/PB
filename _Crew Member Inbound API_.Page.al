page 50154 "Crew Member Inbound API"
{
    //  ApplicationArea = All;
    Caption = 'Crew Member Inbound API';
    PageType = API;
    SourceTable = "PB Crew Member Inbound";
    UsageCategory = Lists;
    // Editable = false;
    APIPublisher = 'PB';
    APIGroup = 'app1';
    APIVersion = 'v2.0', 'v1.0';
    EntityName = 'CrewMemberInbound';
    EntitySetName = 'CrewMemberInbound';
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(LastName; Rec."Last Name")
                {
                    ApplicationArea = All;
                }
                field(FirstName; Rec."First Name")
                {
                    ApplicationArea = All;
                }
                field(MiddleName; Rec."Middle Name")
                {
                    ApplicationArea = All;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                }
                field(Address2; Rec."Address 2")
                {
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                }
                field(PostCode; Rec."Post Code")
                {
                    ApplicationArea = All;
                }
                field("Area"; Rec."Area")
                {
                    ApplicationArea = All;
                }
                field(CountryRegionCode; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field(EMail; Rec."E-Mail")
                {
                    ApplicationArea = All;
                }
                field(PhoneNo; Rec."Phone No.")
                {
                    ApplicationArea = All;
                }
                field(MobilePhoneNo; Rec."Mobile Phone No.")
                {
                    ApplicationArea = All;
                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(TerminationDate; Rec."Termination Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
