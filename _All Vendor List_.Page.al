page 50252 "All Vendor List"
{
    ApplicationArea = All;
    Caption = 'All Vendor List';
    PageType = List;
    SourceTable = Vendor;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the vendor''s address.';
                    ApplicationArea = All;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ToolTip = 'Specifies additional address information.';
                    ApplicationArea = All;
                }
                field("Address 4"; Rec."Address 4")
                {
                    ToolTip = 'Specifies the value of the Address 4 field.';
                    ApplicationArea = All;
                }
                field("Allow Multiple Posting Groups"; Rec."Allow Multiple Posting Groups")
                {
                    ToolTip = 'Specifies if multiple posting groups can be used for posting business transactions for this customer.';
                    ApplicationArea = All;
                }
                field("Amt. Rcd. Not Invoiced"; Rec."Amt. Rcd. Not Invoiced")
                {
                    ToolTip = 'Specifies the value of the Amt. Rcd. Not Invoiced field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Amt. Rcd. Not Invoiced (LCY)"; Rec."Amt. Rcd. Not Invoiced (LCY)")
                {
                    ToolTip = 'Specifies the total invoice amount (in LCY) for the items you have received but not yet been invoiced for.';
                    ApplicationArea = All;
                }
                field("Application Method"; Rec."Application Method")
                {
                    ToolTip = 'Specifies how to apply payments to entries for this vendor.';
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
                    ToolTip = 'Specifies the total value of your completed purchases from the vendor in the current fiscal year. It is calculated from amounts including VAT on all completed purchase invoices and credit memos.';
                    ApplicationArea = All;
                }
                field("Balance Due"; Rec."Balance Due")
                {
                    ToolTip = 'Specifies the value of the Balance Due field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Balance Due (LCY)"; Rec."Balance Due (LCY)")
                {
                    ToolTip = 'Specifies the total value of your unpaid purchases from the vendor in the current fiscal year. It is calculated from amounts including VAT on all open purchase invoices and credit memos.';
                    ApplicationArea = All;
                }
                field("Base Calendar Code"; Rec."Base Calendar Code")
                {
                    ToolTip = 'Specifies a customizable calendar for delivery planning that holds the vendor''s working days and holidays.';
                    ApplicationArea = All;
                }
                field("Block Payment Tolerance"; Rec."Block Payment Tolerance")
                {
                    ToolTip = 'Specifies if the vendor allows payment tolerance.';
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies which transactions with the vendor that cannot be processed, for example a vendor that is declared insolvent.';
                    ApplicationArea = All;
                }
                field("Budgeted Amount"; Rec."Budgeted Amount")
                {
                    ToolTip = 'Specifies the value of the Budgeted Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Buy-from No. Of Archived Doc."; Rec."Buy-from No. Of Archived Doc.")
                {
                    ToolTip = 'Specifies the value of the Buy-from No. Of Archived Doc. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Cash Flow Payment Terms Code"; Rec."Cash Flow Payment Terms Code")
                {
                    ToolTip = 'Specifies a payment term that will be used for calculating cash flow.';
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the vendor''s city.';
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies the value of the Comment field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Company Size Code"; Rec."Company Size Code")
                {
                    ToolTip = 'Specifies the size of the vendor''s company.';
                    ApplicationArea = All;
                }
                field(Contact; Rec.Contact)
                {
                    ToolTip = 'Specifies the name of the person you regularly contact when you do business with this vendor.';
                    ApplicationArea = All;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ToolTip = 'Specifies the country/region of the address.';
                    ApplicationArea = All;
                }
                field(County; Rec.County)
                {
                    ToolTip = 'Specifies the state, province or county as a part of the address.';
                    ApplicationArea = All;
                }
                field("Coupled to Dataverse"; Rec."Coupled to Dataverse")
                {
                    ToolTip = 'Specifies that the vendor is coupled to an account in Dataverse.';
                    ApplicationArea = All;
                }
                field("Cr. Memo Amounts"; Rec."Cr. Memo Amounts")
                {
                    ToolTip = 'Specifies the value of the Cr. Memo Amounts field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Cr. Memo Amounts (LCY)"; Rec."Cr. Memo Amounts (LCY)")
                {
                    ToolTip = 'Specifies the value of the Cr. Memo Amounts (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ToolTip = 'Specifies the value of the Credit Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Credit Amount (LCY)"; Rec."Credit Amount (LCY)")
                {
                    ToolTip = 'Specifies the value of the Credit Amount (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creditor No."; Rec."Creditor No.")
                {
                    ToolTip = 'Specifies the number of the vendor.';
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the currency code that is inserted by default when you create purchase documents or journal lines for the vendor.';
                    ApplicationArea = All;
                }
                field("Currency Id"; Rec."Currency Id")
                {
                    ToolTip = 'Specifies the value of the Currency Id field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("DNV Vendor"; Rec."DNV Vendor")
                {
                    ToolTip = 'Specifies the value of the DNV Vendor field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("DNV Vendor No."; Rec."DNV Vendor No.")
                {
                    ToolTip = 'Specifies the value of the DNV Vendor No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ToolTip = 'Specifies the value of the Debit Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Debit Amount (LCY)"; Rec."Debit Amount (LCY)")
                {
                    ToolTip = 'Specifies the value of the Debit Amount (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Disable Search by Name"; Rec."Disable Search by Name")
                {
                    ToolTip = 'Specifies that you can change the vendor name on open purchase documents. The change applies only to the documents.';
                    ApplicationArea = All;
                }
                field("Document Sending Profile"; Rec."Document Sending Profile")
                {
                    ToolTip = 'Specifies the preferred method of sending documents to this vendor, so that you do not have to select a sending option every time that you post and send a document to the vendor. Documents to this vendor will be sent using the specified sending profile and will override the default document sending profile.';
                    ApplicationArea = All;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ToolTip = 'Specifies the vendor''s email address.';
                    ApplicationArea = All;
                }
                field("EORI Number"; Rec."EORI Number")
                {
                    ToolTip = 'Specifies the Economic Operators Registration and Identification number that is used when you exchange information with the customs authorities due to trade into or out of the European Union.';
                    ApplicationArea = All;
                }
                field("Exclude from Pmt. Practices"; Rec."Exclude from Pmt. Practices")
                {
                    ToolTip = 'Specifies that the vendor must be excluded from Payment Practices calculations.';
                    ApplicationArea = All;
                }
                field("Fax No."; Rec."Fax No.")
                {
                    ToolTip = 'Specifies the vendor''s fax number.';
                    ApplicationArea = All;
                }
                field("Fin. Charge Memo Amounts (LCY)"; Rec."Fin. Charge Memo Amounts (LCY)")
                {
                    ToolTip = 'Specifies the value of the Fin. Charge Memo Amounts (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Fin. Charge Terms Code"; Rec."Fin. Charge Terms Code")
                {
                    ToolTip = 'Specifies the code for the involved finance charges in case of late payment.';
                    ApplicationArea = All;
                }
                field("Finance Charge Memo Amounts"; Rec."Finance Charge Memo Amounts")
                {
                    ToolTip = 'Specifies the value of the Finance Charge Memo Amounts field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Format Region"; Rec."Format Region")
                {
                    ToolTip = 'Specifies the region format to be used on printouts for this vendor.';
                    ApplicationArea = All;
                }
                field(GLN; Rec.GLN)
                {
                    ToolTip = 'Specifies the vendor in connection with electronic document receiving.';
                    ApplicationArea = All;
                }
                field("GNA Vendor"; Rec."GNA Vendor")
                {
                    ToolTip = 'Specifies the value of the GNA Vendor field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ToolTip = 'Specifies the vendor''s trade type to link transactions made for this vendor with the appropriate general ledger account according to the general posting setup.';
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
                field("Home Page"; Rec."Home Page")
                {
                    ToolTip = 'Specifies the vendor''s web site.';
                    ApplicationArea = All;
                }
                field("IC Partner Code"; Rec."IC Partner Code")
                {
                    ToolTip = 'Specifies the vendor''s IC partner code, if the vendor is one of your intercompany partners.';
                    ApplicationArea = All;
                }
                field("IMOS Vendor"; Rec."IMOS Vendor")
                {
                    ToolTip = 'Specifies the value of the IMOS Vendor field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Image; Rec.Image)
                {
                    ToolTip = 'Specifies the picture of the vendor, for example, a logo.';
                    ApplicationArea = All;
                }
                field("InActive Date"; Rec."InActive Date")
                {
                    ToolTip = 'Specifies the value of the InActive Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Intrastat Partner Type"; Rec."Intrastat Partner Type")
                {
                    ToolTip = 'Specifies for Intrastat reporting if the vendor is a person or a company.';
                    ApplicationArea = All;
                }
                field("Inv. Amounts (LCY)"; Rec."Inv. Amounts (LCY)")
                {
                    ToolTip = 'Specifies the value of the Inv. Amounts (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Inv. Discounts (LCY)"; Rec."Inv. Discounts (LCY)")
                {
                    ToolTip = 'Specifies the value of the Inv. Discounts (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Invoice Amounts"; Rec."Invoice Amounts")
                {
                    ToolTip = 'Specifies the value of the Invoice Amounts field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Invoice Disc. Code"; Rec."Invoice Disc. Code")
                {
                    ToolTip = 'Specifies the vendor''s invoice discount code. When you set up a new vendor card, the number you have entered in the No. field is automatically inserted.';
                    ApplicationArea = All;
                }
                field("Is Agent"; Rec."Is Agent")
                {
                    ToolTip = 'Specifies the value of the Is Agent field.';
                    ApplicationArea = All;
                }
                field("Is Delivery Address"; Rec."Is Delivery Address")
                {
                    ToolTip = 'Specifies the value of the Is Delivery Address field.';
                    ApplicationArea = All;
                }
                field("Is Dockyard"; Rec."Is Dockyard")
                {
                    ToolTip = 'Specifies the value of the Is Dockyard field.';
                    ApplicationArea = All;
                    Caption = 'Is Shipyard';
                }
                field("Is Invoice Address"; Rec."Is Invoice Address")
                {
                    ToolTip = 'Specifies the value of the Is Invoice Address field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Is Manufacturer"; Rec."Is Manufacturer")
                {
                    ToolTip = 'Specifies the value of the Is Manufacturer field.';
                    ApplicationArea = All;
                }
                field("Is Service"; Rec."Is Service")
                {
                    ToolTip = 'Specifies the value of the Is Service field.';
                    ApplicationArea = All;
                }
                field("Is Supplier"; Rec."Is Supplier")
                {
                    ToolTip = 'Specifies the value of the Is Supplier field.';
                    ApplicationArea = All;
                }
                field("Language Code"; Rec."Language Code")
                {
                    ToolTip = 'Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.';
                    ApplicationArea = All;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ToolTip = 'Specifies when the vendor card was last modified.';
                    ApplicationArea = All;
                }
                field("Last Modified Date Time"; Rec."Last Modified Date Time")
                {
                    ToolTip = 'Specifies the value of the Last Modified Date Time field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Lead Time Calculation"; Rec."Lead Time Calculation")
                {
                    ToolTip = 'Specifies a date formula for the amount of time it takes to replenish the item.';
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the warehouse location where items from the vendor must be received by default.';
                    ApplicationArea = All;
                }
                field("Max Bank Ref ID"; Rec."Max Bank Ref ID")
                {
                    ToolTip = 'Specifies the value of the Max Bank Ref ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ToolTip = 'Specifies the vendor''s mobile telephone number.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the vendor''s name. You can enter a maximum of 30 characters, both numbers and letters.';
                    ApplicationArea = All;
                }
                field("Name 2"; Rec."Name 2")
                {
                    ToolTip = 'Specifies an additional part of the name.';
                    ApplicationArea = All;
                }
                field("Name of Shareholder"; Rec."Name of Shareholder")
                {
                    ToolTip = 'Specifies the value of the Name of Shareholder field.';
                    ApplicationArea = All;
                }
                field("Net Change"; Rec."Net Change")
                {
                    ToolTip = 'Specifies the value of the Net Change field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Net Change (LCY)"; Rec."Net Change (LCY)")
                {
                    ToolTip = 'Specifies the value of the Net Change (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the vendor. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.';
                    ApplicationArea = All;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ToolTip = 'Specifies the value of the No. Series field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("No. of Blanket Orders"; Rec."No. of Blanket Orders")
                {
                    ToolTip = 'Specifies the number of purchase blanket orders that exist for the vendor.';
                    ApplicationArea = All;
                }
                field("No. of Credit Memos"; Rec."No. of Credit Memos")
                {
                    ToolTip = 'Specifies the number of unposted purchase credit memos that exist for the vendor.';
                    ApplicationArea = All;
                }
                field("No. of Incoming Documents"; Rec."No. of Incoming Documents")
                {
                    ToolTip = 'Specifies incoming documents, such as vendor invoices in PDF or as image files, that you can manually or automatically convert to document records, such as purchase invoices. The external files that represent incoming documents can be attached at any process stage, including to posted documents and to the resulting vendor, customer, and general ledger entries.';
                    ApplicationArea = All;
                }
                field("No. of Invoices"; Rec."No. of Invoices")
                {
                    ToolTip = 'Specifies the number of unposted purchase invoices that exist for the vendor.';
                    ApplicationArea = All;
                }
                field("No. of Order Addresses"; Rec."No. of Order Addresses")
                {
                    ToolTip = 'Specifies the value of the No. of Order Addresses field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("No. of Orders"; Rec."No. of Orders")
                {
                    ToolTip = 'Specifies the number of purchase orders that exist for the vendor.';
                    ApplicationArea = All;
                }
                field("No. of Pstd. Credit Memos"; Rec."No. of Pstd. Credit Memos")
                {
                    ToolTip = 'Specifies the number of posted purchase credit memos that exist for the vendor.';
                    ApplicationArea = All;
                }
                field("No. of Pstd. Invoices"; Rec."No. of Pstd. Invoices")
                {
                    ToolTip = 'Specifies the number of posted purchase invoices that exist for the vendor.';
                    ApplicationArea = All;
                }
                field("No. of Pstd. Receipts"; Rec."No. of Pstd. Receipts")
                {
                    ToolTip = 'Specifies the number of posted purchase receipts that exist for the vendor.';
                    ApplicationArea = All;
                }
                field("No. of Pstd. Return Shipments"; Rec."No. of Pstd. Return Shipments")
                {
                    ToolTip = 'Specifies the number of posted return shipments that exist for the vendor.';
                    ApplicationArea = All;
                }
                field("No. of Quotes"; Rec."No. of Quotes")
                {
                    ToolTip = 'Specifies the number of purchase quotes that exist for the vendor.';
                    ApplicationArea = All;
                }
                field("No. of Return Orders"; Rec."No. of Return Orders")
                {
                    ToolTip = 'Specifies the number of purchase return orders that exist for the vendor.';
                    ApplicationArea = All;
                }
                field("Other Amounts"; Rec."Other Amounts")
                {
                    ToolTip = 'Specifies the value of the Other Amounts field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Other Amounts (LCY)"; Rec."Other Amounts (LCY)")
                {
                    ToolTip = 'Specifies the value of the Other Amounts (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Our Account No."; Rec."Our Account No.")
                {
                    ToolTip = 'Specifies your account number with the vendor, if you have one.';
                    ApplicationArea = All;
                }
                field("Outstanding Invoices"; Rec."Outstanding Invoices")
                {
                    ToolTip = 'Specifies the value of the Outstanding Invoices field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Outstanding Invoices (LCY)"; Rec."Outstanding Invoices (LCY)")
                {
                    ToolTip = 'Specifies the sum of the vendor''s outstanding purchase invoices in LCY.';
                    ApplicationArea = All;
                }
                field("Outstanding Orders"; Rec."Outstanding Orders")
                {
                    ToolTip = 'Specifies the value of the Outstanding Orders field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Outstanding Orders (LCY)"; Rec."Outstanding Orders (LCY)")
                {
                    ToolTip = 'Specifies the sum of outstanding orders (in LCY) to this vendor.';
                    ApplicationArea = All;
                }
                field("Over-Receipt Code"; Rec."Over-Receipt Code")
                {
                    ToolTip = 'Specifies the policy that will be used for the vendor if more items than ordered are received.';
                    ApplicationArea = All;
                }
                field("Parent Company"; Rec."Parent Company")
                {
                    ToolTip = 'Specifies the value of the Parent Company field.';
                    ApplicationArea = All;
                }
                field("Parent Company CP Type"; Rec."Parent Company CP Type")
                {
                    ToolTip = 'Specifies the value of the Parent Company Counter Party Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Parent Company Type"; Rec."Parent Company Type")
                {
                    ToolTip = 'Specifies the value of the Parent Company Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Partner Type"; Rec."Partner Type")
                {
                    ToolTip = 'Specifies if the vendor is a person or a company.';
                    ApplicationArea = All;
                }
                field("Pay-to No. Of Archived Doc."; Rec."Pay-to No. Of Archived Doc.")
                {
                    ToolTip = 'Specifies the value of the Pay-to No. Of Archived Doc. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Pay-to No. of Blanket Orders"; Rec."Pay-to No. of Blanket Orders")
                {
                    ToolTip = 'Specifies the number of blanket orders.';
                    ApplicationArea = All;
                }
                field("Pay-to No. of Credit Memos"; Rec."Pay-to No. of Credit Memos")
                {
                    ToolTip = 'Specifies the amount that relates to credit memos.';
                    ApplicationArea = All;
                }
                field("Pay-to No. of Invoices"; Rec."Pay-to No. of Invoices")
                {
                    ToolTip = 'Specifies the amount that relates to invoices.';
                    ApplicationArea = All;
                }
                field("Pay-to No. of Orders"; Rec."Pay-to No. of Orders")
                {
                    ToolTip = 'Specifies the number of posted orders that exist for the vendor.';
                    ApplicationArea = All;
                }
                field("Pay-to No. of Pstd. Cr. Memos"; Rec."Pay-to No. of Pstd. Cr. Memos")
                {
                    ToolTip = 'Specifies the amount that relates to credit memos.';
                    ApplicationArea = All;
                }
                field("Pay-to No. of Pstd. Invoices"; Rec."Pay-to No. of Pstd. Invoices")
                {
                    ToolTip = 'Specifies the amount that relates to posted invoices.';
                    ApplicationArea = All;
                }
                field("Pay-to No. of Pstd. Receipts"; Rec."Pay-to No. of Pstd. Receipts")
                {
                    ToolTip = 'Specifies the number of posted receipts that exist for the vendor.';
                    ApplicationArea = All;
                }
                field("Pay-to No. of Pstd. Return S."; Rec."Pay-to No. of Pstd. Return S.")
                {
                    ToolTip = 'Specifies the number of posted return shipments that exist for the vendor.';
                    ApplicationArea = All;
                }
                field("Pay-to No. of Quotes"; Rec."Pay-to No. of Quotes")
                {
                    ToolTip = 'Specifies the number of quotes that exist for the vendor.';
                    ApplicationArea = All;
                }
                field("Pay-to No. of Return Orders"; Rec."Pay-to No. of Return Orders")
                {
                    ToolTip = 'Specifies how many return orders have been registered for the customer when the customer acts as the pay-to customer.';
                    ApplicationArea = All;
                }
                field("Pay-to Vendor No."; Rec."Pay-to Vendor No.")
                {
                    ToolTip = 'Specifies the number of a different vendor whom you pay for products delivered by the vendor on the vendor card.';
                    ApplicationArea = All;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ToolTip = 'Specifies how to make payment, such as with bank transfer, cash, or check.';
                    ApplicationArea = All;
                }
                field("Payment Method Id"; Rec."Payment Method Id")
                {
                    ToolTip = 'Specifies the value of the Payment Method Id field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ToolTip = 'Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.';
                    ApplicationArea = All;
                }
                field("Payment Terms Id"; Rec."Payment Terms Id")
                {
                    ToolTip = 'Specifies the value of the Payment Terms Id field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Payments; Rec.Payments)
                {
                    ToolTip = 'Specifies the value of the Payments field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Payments (LCY)"; Rec."Payments (LCY)")
                {
                    ToolTip = 'Specifies the sum of payments paid to the vendor.';
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ToolTip = 'Specifies the vendor''s telephone number.';
                    ApplicationArea = All;
                }
                field("Pmt. Disc. Tolerance (LCY)"; Rec."Pmt. Disc. Tolerance (LCY)")
                {
                    ToolTip = 'Specifies the value of the Pmt. Disc. Tolerance (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Pmt. Discounts (LCY)"; Rec."Pmt. Discounts (LCY)")
                {
                    ToolTip = 'Specifies the value of the Pmt. Discounts (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Pmt. Tolerance (LCY)"; Rec."Pmt. Tolerance (LCY)")
                {
                    ToolTip = 'Specifies the value of the Pmt. Tolerance (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ToolTip = 'Specifies the postal code.';
                    ApplicationArea = All;
                }
                field("Preferred Bank Account Code"; Rec."Preferred Bank Account Code")
                {
                    ToolTip = 'Specifies the vendor bank account that will be used by default on payment journal lines for export to a payment bank file.';
                    ApplicationArea = All;
                }
                field("Prepayment %"; Rec."Prepayment %")
                {
                    ToolTip = 'Specifies a prepayment percentage that applies to all orders for this vendor, regardless of the items or services on the order lines.';
                    ApplicationArea = All;
                }
                field("Price Calculation Method"; Rec."Price Calculation Method")
                {
                    ToolTip = 'Specifies the default price calculation method.';
                    ApplicationArea = All;
                }
                field("Prices Including VAT"; Rec."Prices Including VAT")
                {
                    ToolTip = 'Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.';
                    ApplicationArea = All;
                }
                field("Primary Contact No."; Rec."Primary Contact No.")
                {
                    ToolTip = 'Specifies the primary contact number for the vendor.';
                    ApplicationArea = All;
                }
                field(Priority; Rec.Priority)
                {
                    ToolTip = 'Specifies the importance of the vendor when suggesting payments using the Suggest Vendor Payments function.';
                    ApplicationArea = All;
                }
                field("Privacy Blocked"; Rec."Privacy Blocked")
                {
                    ToolTip = 'Specifies whether to limit access to data for the data subject during daily operations. This is useful, for example, when protecting data from changes while it is under privacy review.';
                    ApplicationArea = All;
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                    ToolTip = 'Specifies which purchaser is assigned to the vendor.';
                    ApplicationArea = All;
                }
                field("Purchases (LCY)"; Rec."Purchases (LCY)")
                {
                    ToolTip = 'Specifies the value of the Purchases (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Reference Code"; Rec."Reference Code")
                {
                    ToolTip = 'Specifies the value of the Reference Code field.';
                    ApplicationArea = All;
                }
                field(Refunds; Rec.Refunds)
                {
                    ToolTip = 'Specifies the value of the Refunds field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Refunds (LCY)"; Rec."Refunds (LCY)")
                {
                    ToolTip = 'Specifies the sum of refunds paid to the vendor.';
                    ApplicationArea = All;
                }
                field("Registration Number"; Rec."Registration Number")
                {
                    ToolTip = 'Specifies the registration number of the vendor. You can enter a maximum of 20 characters, both numbers and letters.';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Reminder Amounts"; Rec."Reminder Amounts")
                {
                    ToolTip = 'Specifies the value of the Reminder Amounts field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Reminder Amounts (LCY)"; Rec."Reminder Amounts (LCY)")
                {
                    ToolTip = 'Specifies the value of the Reminder Amounts (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ToolTip = 'Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.';
                    ApplicationArea = All;
                }
                field("Search Name"; Rec."Search Name")
                {
                    ToolTip = 'Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.';
                    ApplicationArea = All;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ToolTip = 'Specifies the delivery conditions of the related shipment, such as free on board (FOB).';
                    ApplicationArea = All;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ToolTip = 'Specifies the value of the Shipping Agent Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Short Name"; Rec."Short Name")
                {
                    ToolTip = 'Specifies the value of the Short Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Statistics Group"; Rec."Statistics Group")
                {
                    ToolTip = 'Specifies the value of the Statistics Group field.', Comment = '%';
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
                field("Tax Area Code"; Rec."Tax Area Code")
                {
                    ToolTip = 'Specifies a tax area code for the company.';
                    ApplicationArea = All;
                }
                field("Tax Liable"; Rec."Tax Liable")
                {
                    ToolTip = 'Specifies if the customer is liable for sales tax.';
                    ApplicationArea = All;
                }
                field("Telex Answer Back"; Rec."Telex Answer Back")
                {
                    ToolTip = 'Specifies the value of the Telex Answer Back field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Telex No."; Rec."Telex No.")
                {
                    ToolTip = 'Specifies the value of the Telex No. field.';
                    ApplicationArea = All;
                }
                field("Territory Code"; Rec."Territory Code")
                {
                    ToolTip = 'Specifies the value of the Territory Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Transmission Format"; Rec."Transmission Format")
                {
                    ToolTip = 'Specifies the value of the Transmission Format field.';
                    ApplicationArea = All;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ToolTip = 'Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                    ApplicationArea = All;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ToolTip = 'Specifies the vendor''s VAT registration number.';
                    ApplicationArea = All;
                }
                field("Validate EU Vat Reg. No."; Rec."Validate EU Vat Reg. No.")
                {
                    ToolTip = 'Specifies the value of the Validate EU VAT Reg. No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Vendor Posting Group"; Rec."Vendor Posting Group")
                {
                    ToolTip = 'Specifies the vendor''s market type to link business transactions made for the vendor with the appropriate account in the general ledger.';
                    ApplicationArea = All;
                }
                field("e-Commerce ID"; Rec."e-Commerce ID")
                {
                    ToolTip = 'Specifies the value of the e-Commerce ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Äddress 3"; Rec."Äddress 3")
                {
                    ToolTip = 'Specifies the value of the Address 3 field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
