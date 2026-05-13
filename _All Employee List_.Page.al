page 50254 "All Employee List"
{
    ApplicationArea = All;
    Caption = 'All Employee List';
    PageType = List;
    SourceTable = Employee;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the employee''s address.';
                    ApplicationArea = All;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ToolTip = 'Specifies additional address information.';
                    ApplicationArea = All;
                }
                field("Alt. Address Code"; Rec."Alt. Address Code")
                {
                    ToolTip = 'Specifies a code for an alternate address.';
                    ApplicationArea = All;
                }
                field("Alt. Address End Date"; Rec."Alt. Address End Date")
                {
                    ToolTip = 'Specifies the last day when the alternate address is valid.';
                    ApplicationArea = All;
                }
                field("Alt. Address Start Date"; Rec."Alt. Address Start Date")
                {
                    ToolTip = 'Specifies the starting date when the alternate address is valid.';
                    ApplicationArea = All;
                }
                field("Application Method"; Rec."Application Method")
                {
                    ToolTip = 'Specifies how to apply payments to entries for this employee.';
                    ApplicationArea = All;
                }
                field(Approver; Rec.Approver)
                {
                    ToolTip = 'Specifies the value of the Approver field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Area"; Rec."Area")
                {
                    ToolTip = 'Specifies the value of the Area field.';
                    ApplicationArea = All;
                }
                field(Balance; Rec.Balance)
                {
                    ToolTip = 'Specifies the value of the Balance field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Balance (LCY)"; Rec."Balance (LCY)")
                {
                    ToolTip = 'Specifies the value of the the employee''s balance.';
                    ApplicationArea = All;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ToolTip = 'Specifies the number used by the bank for the bank account.';
                    ApplicationArea = All;
                }
                field("Bank Branch No."; Rec."Bank Branch No.")
                {
                    ToolTip = 'Specifies a number of the bank branch.';
                    ApplicationArea = All;
                }
                field("Birth Date"; Rec."Birth Date")
                {
                    ToolTip = 'Specifies the employee''s date of birth.';
                    ApplicationArea = All;
                }
                field("Cause of Inactivity Code"; Rec."Cause of Inactivity Code")
                {
                    ToolTip = 'Specifies a code for the cause of inactivity by the employee.';
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the city of the address.';
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies if a comment has been entered for this entry.';
                    ApplicationArea = All;
                }
                field(Company; Rec.Company)
                {
                    ToolTip = 'Specifies the value of the Company field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Company E-Mail"; Rec."Company E-Mail")
                {
                    ToolTip = 'Specifies the employee''s email address at the company.';
                    ApplicationArea = All;
                }
                field("Concur Cash Adv. Account code"; Rec."Concur Cash Adv. Account code")
                {
                    ToolTip = 'Specifies the value of the Concur Cash Advanced Account code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Concur Corp Card ID"; Rec."Concur Corp Card ID")
                {
                    ToolTip = 'Specifies the value of the Concur Corp Card ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Concur ID"; Rec."Concur ID")
                {
                    ToolTip = 'Specifies the value of the Concur ID field.';
                    ApplicationArea = All;
                }
                field("Concur Personal Emp ID"; Rec."Concur Personal Emp ID")
                {
                    ToolTip = 'Specifies the value of the Concur Personal Employee ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Concur Vendor ID"; Rec."Concur Vendor ID")
                {
                    ToolTip = 'Specifies the value of the Concur Vendor ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Corp Card"; Rec."Corp Card")
                {
                    ToolTip = 'Specifies the value of the Corp Card field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Cost Center Code"; Rec."Cost Center Code")
                {
                    ToolTip = 'Specifies the value of the Cost Center Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Cost Object Code"; Rec."Cost Object Code")
                {
                    ToolTip = 'Specifies the value of the Cost Object Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ToolTip = 'Specifies the country/region of the address.';
                    ApplicationArea = All;
                }
                field(County; Rec.County)
                {
                    ToolTip = 'Specifies the county of the employee.';
                    ApplicationArea = All;
                }
                field("Credit Card"; Rec."Credit Card")
                {
                    ToolTip = 'Specifies the value of the Credit Card field.';
                    ApplicationArea = All;
                }
                field(Crew; Rec.Crew)
                {
                    ToolTip = 'Specifies the value of the Crew field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the currency code that is inserted by default when you create entries for the employee.';
                    ApplicationArea = All;
                }
                field("DNV Address"; Rec."DNV Address")
                {
                    ToolTip = 'Specifies the value of the DNV Address field.';
                    ApplicationArea = All;
                }
                field("DNV Address 2"; Rec."DNV Address 2")
                {
                    ToolTip = 'Specifies the value of the DNV Address 2 field.';
                    ApplicationArea = All;
                }
                field("DNV City"; Rec."DNV City")
                {
                    ToolTip = 'Specifies the value of the DNV City field.';
                    ApplicationArea = All;
                }
                field("DNV E-Mail"; Rec."DNV E-Mail")
                {
                    ToolTip = 'Specifies the value of the DNV E-Mail field.';
                    ApplicationArea = All;
                }
                field("DNV First Name"; Rec."DNV First Name")
                {
                    ToolTip = 'Specifies the value of the DNV First Name field.';
                    ApplicationArea = All;
                }
                field("DNV Last Name"; Rec."DNV Last Name")
                {
                    ToolTip = 'Specifies the value of the DNV Last Name field.';
                    ApplicationArea = All;
                }
                field("DNV Middle Name"; Rec."DNV Middle Name")
                {
                    ToolTip = 'Specifies the value of the DNV Middle Name field.';
                    ApplicationArea = All;
                }
                field("DNV Mobile Phone No."; Rec."DNV Mobile Phone No.")
                {
                    ToolTip = 'Specifies the value of the DNV Mobile Phone No. field.';
                    ApplicationArea = All;
                }
                field("DNV No"; Rec."DNV No")
                {
                    ToolTip = 'Specifies the value of the DNV No field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("DNV Phone No."; Rec."DNV Phone No.")
                {
                    ToolTip = 'Specifies the value of the DNV Phone No. field.';
                    ApplicationArea = All;
                }
                field("DNV PostCode"; Rec."DNV PostCode")
                {
                    ToolTip = 'Specifies the value of the DNV PostCode field.';
                    ApplicationArea = All;
                }
                field("DNV Staging Entry No."; Rec."DNV Staging Entry No.")
                {
                    ToolTip = 'Specifies the value of the DNV Staging Entry No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Department; Rec.Department)
                {
                    ToolTip = 'Specifies the value of the Department field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ToolTip = 'Specifies the employee''s private email address.';
                    ApplicationArea = All;
                }
                field("Emp. ID Cash Adv. Approver"; Rec."Emp. ID Cash Adv. Approver")
                {
                    ToolTip = 'Specifies the value of the Employee ID of the cash advance approver field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Emp. ID Exp. Rep. Approver"; Rec."Emp. ID Exp. Rep. Approver")
                {
                    ToolTip = 'Specifies the value of the Employee ID of the expense report approver field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Employee Group"; Rec."Employee Group")
                {
                    ToolTip = 'Specifies the value of the Employee Group field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Employee Posting Group"; Rec."Employee Posting Group")
                {
                    ToolTip = 'Specifies the employee''s type to link business transactions made for the employee with the appropriate account in the general ledger.';
                    ApplicationArea = All;
                }
                field("Employment Date"; Rec."Employment Date")
                {
                    ToolTip = 'Specifies the date when the employee began to work for the company.';
                    ApplicationArea = All;
                }
                field("Emplymt. Contract Code"; Rec."Emplymt. Contract Code")
                {
                    ToolTip = 'Specifies the employment contract code for the employee.';
                    ApplicationArea = All;
                }
                field("Expense Report Submitter"; Rec."Expense Report Submitter")
                {
                    ToolTip = 'Specifies the value of the Expense Report Submitter field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Extension; Rec.Extension)
                {
                    ToolTip = 'Specifies the employee''s telephone extension.';
                    ApplicationArea = All;
                }
                field("Fax No."; Rec."Fax No.")
                {
                    ToolTip = 'Specifies the value of the Fax No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("First Name"; Rec."First Name")
                {
                    ToolTip = 'Specifies the employee''s first name.';
                    ApplicationArea = All;
                }
                field(Gender; Rec.Gender)
                {
                    ToolTip = 'Specifies the gender with which the employee identifies.';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Grounds for Term. Code"; Rec."Grounds for Term. Code")
                {
                    ToolTip = 'Specifies a termination code for the employee who has been terminated.';
                    ApplicationArea = All;
                }
                field(IBAN; Rec.IBAN)
                {
                    ToolTip = 'Specifies the bank account''s international bank account number.';
                    ApplicationArea = All;
                }
                field(Image; Rec.Image)
                {
                    ToolTip = 'Specifies the picture of the employee.';
                    ApplicationArea = All;
                }
                field("Inactive Date"; Rec."Inactive Date")
                {
                    ToolTip = 'Specifies the date when the employee became inactive, due to disability or maternity leave, for example.';
                    ApplicationArea = All;
                }
                field(Initials; Rec.Initials)
                {
                    ToolTip = 'Specifies the employee''s initials.';
                    ApplicationArea = All;
                }
                field("Integrate to Concur"; Rec."Integrate to Concur")
                {
                    ToolTip = 'Specifies the value of the Integrate to Concur field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the employee''s job title.';
                    ApplicationArea = All;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ToolTip = 'Specifies when this record was last modified.';
                    ApplicationArea = All;
                }
                field("Last Modified Date Time"; Rec."Last Modified Date Time")
                {
                    ToolTip = 'Specifies the value of the Last Modified Date Time field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ToolTip = 'Specifies the employee''s last name.';
                    ApplicationArea = All;
                }
                field("Locale Code"; Rec."Locale Code")
                {
                    ToolTip = 'Specifies the value of the Locale Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Login ID"; Rec."Login ID")
                {
                    ToolTip = 'Specifies the value of the Login ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Manager No."; Rec."Manager No.")
                {
                    ToolTip = 'Specifies the value of the Manager No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ToolTip = 'Specifies the employee''s middle name.';
                    ApplicationArea = All;
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ToolTip = 'Specifies the employee''s private telephone number.';
                    ApplicationArea = All;
                }
                field(Nationality2; Rec.Nationality2)
                {
                    ToolTip = 'Specifies the value of the Nationality2 field.';
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    ApplicationArea = All;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ToolTip = 'Specifies the value of the No. Series field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Pager; Rec.Pager)
                {
                    ToolTip = 'Specifies the employee''s pager number.';
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ToolTip = 'Specifies the employee''s telephone number.';
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ToolTip = 'Specifies the postal code.';
                    ApplicationArea = All;
                }
                field("Privacy Blocked"; Rec."Privacy Blocked")
                {
                    ToolTip = 'Specifies whether to limit access to data for the data subject during daily operations. This is useful, for example, when protecting data from changes while it is under privacy review.';
                    ApplicationArea = All;
                }
                field(Region; Rec.Region)
                {
                    ToolTip = 'Specifies the value of the Region field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Relocate to Company"; Rec."Relocate to Company")
                {
                    ToolTip = 'Specifies the value of the Relocate to Company field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Resource No."; Rec."Resource No.")
                {
                    ToolTip = 'Specifies a resource number for the employee.';
                    ApplicationArea = All;
                }
                field("SWIFT Code"; Rec."SWIFT Code")
                {
                    ToolTip = 'Specifies the SWIFT code (international bank identifier code) of the bank where the employee has the account.';
                    ApplicationArea = All;
                }
                field("Salespers./Purch. Code"; Rec."Salespers./Purch. Code")
                {
                    ToolTip = 'Specifies a salesperson or purchaser code for the employee.';
                    ApplicationArea = All;
                }
                field("Search Name"; Rec."Search Name")
                {
                    ToolTip = 'Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.';
                    ApplicationArea = All;
                }
                field("Social Security No."; Rec."Social Security No.")
                {
                    ToolTip = 'Specifies the social security number of the employee.';
                    ApplicationArea = All;
                }
                field("Statistics Group Code"; Rec."Statistics Group Code")
                {
                    ToolTip = 'Specifies a statistics group code to assign to the employee for statistical purposes.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the employment status of the employee.';
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Termination Date"; Rec."Termination Date")
                {
                    ToolTip = 'Specifies the date when the employee was terminated, due to retirement or dismissal, for example.';
                    ApplicationArea = All;
                }
                field(Title; Rec.Title)
                {
                    ToolTip = 'Specifies the value of the Title field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Total Absence (Base)"; Rec."Total Absence (Base)")
                {
                    ToolTip = 'Specifies the value of the Total Absence (Base) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Union Code"; Rec."Union Code")
                {
                    ToolTip = 'Specifies the employee''s labor union membership code.';
                    ApplicationArea = All;
                }
                field("Union Membership No."; Rec."Union Membership No.")
                {
                    ToolTip = 'Specifies the employee''s labor union membership number.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
