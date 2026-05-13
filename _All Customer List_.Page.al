page 50253 "All Customer List"
{
    ApplicationArea = all;
    Caption = 'All Customer List';
    PageType = List;
    SourceTable = Customer;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the customer''s address. This address will appear on all sales documents for the customer.';
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
                field("Allow Line Disc."; Rec."Allow Line Disc.")
                {
                    ToolTip = 'Specifies if a sales line discount is calculated when a special sales price is offered according to setup in the Sales Prices window.';
                    ApplicationArea = All;
                }
                field("Allow Multiple Posting Groups"; Rec."Allow Multiple Posting Groups")
                {
                    ToolTip = 'Specifies if multiple posting groups can be used for posting business transactions for this customer.';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Application Method"; Rec."Application Method")
                {
                    ToolTip = 'Specifies how to apply payments to entries for this customer.';
                    ApplicationArea = All;
                }
                field(Balance; Rec.Balance)
                {
                    ToolTip = 'Specifies the value of the Balance field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Balance (LCY)"; Rec."Balance (LCY)")
                {
                    ToolTip = 'Specifies the payment amount that the customer owes for completed sales. This value is also known as the customer''s balance.';
                    ApplicationArea = All;
                }
                field("Balance Due"; Rec."Balance Due")
                {
                    ToolTip = 'Specifies the value of the Balance Due field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Balance Due (LCY)"; Rec."Balance Due (LCY)")
                {
                    ToolTip = 'Specifies the balance due for this customer in local currency.';
                    ApplicationArea = All;
                }
                field("Base Calendar Code"; Rec."Base Calendar Code")
                {
                    ToolTip = 'Specifies a customizable calendar for shipment planning that holds the customer''s working days and holidays.';
                    ApplicationArea = All;
                }
                field("Bill-To No. of Blanket Orders"; Rec."Bill-To No. of Blanket Orders")
                {
                    ToolTip = 'Specifies how many blanket orders have been registered for the customer when the customer acts as the bill-to customer.';
                    ApplicationArea = All;
                }
                field("Bill-To No. of Credit Memos"; Rec."Bill-To No. of Credit Memos")
                {
                    ToolTip = 'Specifies how many credit memos have been registered for the customer when the customer acts as the bill-to customer.';
                    ApplicationArea = All;
                }
                field("Bill-To No. of Invoices"; Rec."Bill-To No. of Invoices")
                {
                    ToolTip = 'Specifies how many invoices have been registered for the customer when the customer acts as the bill-to customer.';
                    ApplicationArea = All;
                }
                field("Bill-To No. of Orders"; Rec."Bill-To No. of Orders")
                {
                    ToolTip = 'Specifies how many sales orders have been registered for the customer when the customer acts as the bill-to customer.';
                    ApplicationArea = All;
                }
                field("Bill-To No. of Pstd. Cr. Memos"; Rec."Bill-To No. of Pstd. Cr. Memos")
                {
                    ToolTip = 'Specifies how many posted credit memos have been registered for the customer when the customer acts as the bill-to customer.';
                    ApplicationArea = All;
                }
                field("Bill-To No. of Pstd. Invoices"; Rec."Bill-To No. of Pstd. Invoices")
                {
                    ToolTip = 'Specifies how many posted invoices have been registered for the customer when the customer acts as the bill-to customer.';
                    ApplicationArea = All;
                }
                field("Bill-To No. of Pstd. Return R."; Rec."Bill-To No. of Pstd. Return R.")
                {
                    ToolTip = 'Specifies how many posted return receipts have been registered for the customer when the customer acts as the bill-to customer.';
                    ApplicationArea = All;
                }
                field("Bill-To No. of Pstd. Shipments"; Rec."Bill-To No. of Pstd. Shipments")
                {
                    ToolTip = 'Specifies how many posted shipments have been registered for the customer when the customer acts as the bill-to customer.';
                    ApplicationArea = All;
                }
                field("Bill-To No. of Quotes"; Rec."Bill-To No. of Quotes")
                {
                    ToolTip = 'Specifies how many quotes have been registered for the customer when the customer acts as the bill-to customer.';
                    ApplicationArea = All;
                }
                field("Bill-To No. of Return Orders"; Rec."Bill-To No. of Return Orders")
                {
                    ToolTip = 'Specifies how many return orders have been registered for the customer when the customer acts as the bill-to customer.';
                    ApplicationArea = All;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ToolTip = 'Specifies a different customer who will be invoiced for products that you sell to the customer in the Name field on the customer card.';
                    ApplicationArea = All;
                }
                field("Bill-to No. Of Archived Doc."; Rec."Bill-to No. Of Archived Doc.")
                {
                    ToolTip = 'Specifies the value of the Bill-to No. Of Sales Archived Doc. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Block Payment Tolerance"; Rec."Block Payment Tolerance")
                {
                    ToolTip = 'Specifies that the customer is not allowed a payment tolerance.';
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies which transactions with the customer that cannot be processed, for example, because the customer is insolvent.';
                    ApplicationArea = All;
                }
                field("Budgeted Amount"; Rec."Budgeted Amount")
                {
                    ToolTip = 'Specifies the value of the Budgeted Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Cash Flow Payment Terms Code"; Rec."Cash Flow Payment Terms Code")
                {
                    ToolTip = 'Specifies a payment term that will be used to calculate cash flow for the customer.';
                    ApplicationArea = All;
                }
                field("Chain Name"; Rec."Chain Name")
                {
                    ToolTip = 'Specifies the value of the Chain Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the customer''s city.';
                    ApplicationArea = All;
                }
                field("Collection Method"; Rec."Collection Method")
                {
                    ToolTip = 'Specifies the value of the Collection Method field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Combine Shipments"; Rec."Combine Shipments")
                {
                    ToolTip = 'Specifies if several orders delivered to the customer can appear on the same sales invoice.';
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies the value of the Comment field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Contact; Rec.Contact)
                {
                    ToolTip = 'Specifies the contact person at the customer''s company.';
                    ApplicationArea = All;
                }
                field("Contact Graph Id"; Rec."Contact Graph Id")
                {
                    ToolTip = 'Specifies the value of the Contact Graph Id field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Contact ID"; Rec."Contact ID")
                {
                    ToolTip = 'Specifies the value of the Contact ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Contact Type"; Rec."Contact Type")
                {
                    ToolTip = 'Specifies the value of the Contact Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Contract Gain/Loss Amount"; Rec."Contract Gain/Loss Amount")
                {
                    ToolTip = 'Specifies the value of the Contract Gain/Loss Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Copy Sell-to Addr. to Qte From"; Rec."Copy Sell-to Addr. to Qte From")
                {
                    ToolTip = 'Specifies which customer address is inserted on sales quotes that you create for the customer.';
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
                    ToolTip = 'Specifies that the customer is coupled to an account in Dataverse.';
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
                field("Credit Limit (LCY)"; Rec."Credit Limit (LCY)")
                {
                    ToolTip = 'Specifies the maximum amount you allow the customer to exceed the payment balance before warnings are issued.';
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the default currency for the customer.';
                    ApplicationArea = All;
                }
                field("Currency Id"; Rec."Currency Id")
                {
                    ToolTip = 'Specifies the value of the Currency Id field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Customer Disc. Group"; Rec."Customer Disc. Group")
                {
                    ToolTip = 'Specifies the customer discount group code, which you can use as a criterion to set up special discounts in the Sales Line Discounts window.';
                    ApplicationArea = All;
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    ToolTip = 'Specifies the customer''s market type to link business transactions to.';
                    ApplicationArea = All;
                }
                field("Customer Price Group"; Rec."Customer Price Group")
                {
                    ToolTip = 'Specifies the customer price group code, which you can use to set up special sales prices in the Sales Prices window.';
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
                    ToolTip = 'Specifies that you can change the customer name on open sales documents. The change applies only to the documents.';
                    ApplicationArea = All;
                }
                field("Document Sending Profile"; Rec."Document Sending Profile")
                {
                    ToolTip = 'Specifies the preferred method of sending documents to this customer, so that you do not have to select a sending option every time that you post and send a document to the customer. Sales documents to this customer will be sent using the specified sending profile and will override the default document sending profile.';
                    ApplicationArea = All;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ToolTip = 'Specifies the customer''s email address.';
                    ApplicationArea = All;
                }
                field("EORI Number"; Rec."EORI Number")
                {
                    ToolTip = 'Specifies the Economic Operators Registration and Identification number that is used when you exchange information with the customs authorities due to trade into or out of the European Union.';
                    ApplicationArea = All;
                }
                field("Exclude from Pmt. Practices"; Rec."Exclude from Pmt. Practices")
                {
                    ToolTip = 'Specifies that the customer must be excluded from Payment Practices calculations.';
                    ApplicationArea = All;
                }
                field("Fax No."; Rec."Fax No.")
                {
                    ToolTip = 'Specifies the customer''s fax number.';
                    ApplicationArea = All;
                }
                field("Fin. Charge Memo Amounts (LCY)"; Rec."Fin. Charge Memo Amounts (LCY)")
                {
                    ToolTip = 'Specifies the value of the Fin. Charge Memo Amounts (LCY) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Fin. Charge Terms Code"; Rec."Fin. Charge Terms Code")
                {
                    ToolTip = 'Specifies finance charges are calculated for the customer.';
                    ApplicationArea = All;
                }
                field("Finance Charge Memo Amounts"; Rec."Finance Charge Memo Amounts")
                {
                    ToolTip = 'Specifies the value of the Finance Charge Memo Amounts field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Format Region"; Rec."Format Region")
                {
                    ToolTip = 'Specifies the Format Region to be used on printouts for this customer.';
                    ApplicationArea = All;
                }
                field(GLN; Rec.GLN)
                {
                    ToolTip = 'Specifies the customer in connection with electronic document sending.';
                    ApplicationArea = All;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ToolTip = 'Specifies the customer''s trade type to link transactions made for this customer with the appropriate general ledger account according to the general posting setup.';
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
                    ToolTip = 'Specifies the customer''s home page address.';
                    ApplicationArea = All;
                }
                field("IC Partner Code"; Rec."IC Partner Code")
                {
                    ToolTip = 'Specifies the customer''s intercompany partner code.';
                    ApplicationArea = All;
                }
                field(Image; Rec.Image)
                {
                    ToolTip = 'Specifies the picture of the customer, for example, a logo.';
                    ApplicationArea = All;
                }
                field("Intrastat Partner Type"; Rec."Intrastat Partner Type")
                {
                    ToolTip = 'Specifies for Intrastat reporting if the customer is a person or a company.';
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
                // field("Invoice Copies"; Rec."Invoice Copies") 
                // {
                //     ToolTip = 'Specifies the value of the Invoice Copies field.', Comment = '%';
                //     ApplicationArea = All;
                //     ObsoleteReason = 'This field is not used consequently and hence does not work as expected. It should be retired.';
                // }
                field("Invoice Disc. Code"; Rec."Invoice Disc. Code")
                {
                    ToolTip = 'Specifies a code for the invoice discount terms that you have defined for the customer.';
                    ApplicationArea = All;
                }
                field("Language Code"; Rec."Language Code")
                {
                    ToolTip = 'Specifies the language to be used on printouts for this customer.';
                    ApplicationArea = All;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ToolTip = 'Specifies when the customer card was last modified.';
                    ApplicationArea = All;
                }
                field("Last Modified Date Time"; Rec."Last Modified Date Time")
                {
                    ToolTip = 'Specifies the value of the Last Modified Date Time field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Last Statement No."; Rec."Last Statement No.")
                {
                    ToolTip = 'Specifies the number of the last statement that was printed for this customer.';
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies from which location sales to this customer will be processed by default.';
                    ApplicationArea = All;
                }
                field("Max Bank Ref ID"; Rec."Max Bank Ref ID")
                {
                    ToolTip = 'Specifies the value of the Max Bank Ref ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ToolTip = 'Specifies the customer''s mobile telephone number.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the name of the customer.';
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
                    ToolTip = 'Specifies the number of the customer. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.';
                    ApplicationArea = All;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ToolTip = 'Specifies the value of the No. Series field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("No. of Blanket Orders"; Rec."No. of Blanket Orders")
                {
                    ToolTip = 'Specifies the number of sales blanket orders that have been registered for the customer.';
                    ApplicationArea = All;
                }
                field("No. of Credit Memos"; Rec."No. of Credit Memos")
                {
                    ToolTip = 'Specifies the number of unposted sales credit memos that have been registered for the customer.';
                    ApplicationArea = All;
                }
                field("No. of Invoices"; Rec."No. of Invoices")
                {
                    ToolTip = 'Specifies the number of unposted sales invoices that have been registered for the customer.';
                    ApplicationArea = All;
                }
                field("No. of Orders"; Rec."No. of Orders")
                {
                    ToolTip = 'Specifies the number of sales orders that have been registered for the customer.';
                    ApplicationArea = All;
                }
                field("No. of Pstd. Credit Memos"; Rec."No. of Pstd. Credit Memos")
                {
                    ToolTip = 'Specifies the number of posted sales credit memos that have been registered for the customer.';
                    ApplicationArea = All;
                }
                field("No. of Pstd. Invoices"; Rec."No. of Pstd. Invoices")
                {
                    ToolTip = 'Specifies the number of posted sales invoices that have been registered for the customer.';
                    ApplicationArea = All;
                }
                field("No. of Pstd. Return Receipts"; Rec."No. of Pstd. Return Receipts")
                {
                    ToolTip = 'Specifies the number of posted sales return receipts that have been registered for the customer.';
                    ApplicationArea = All;
                }
                field("No. of Pstd. Shipments"; Rec."No. of Pstd. Shipments")
                {
                    ToolTip = 'Specifies the number of posted sales shipments that have been registered for the customer.';
                    ApplicationArea = All;
                }
                field("No. of Quotes"; Rec."No. of Quotes")
                {
                    ToolTip = 'Specifies the number of sales quotes that have been registered for the customer.';
                    ApplicationArea = All;
                }
                field("No. of Return Orders"; Rec."No. of Return Orders")
                {
                    ToolTip = 'Specifies the number of sales return orders that have been registered for the customer.';
                    ApplicationArea = All;
                }
                field("No. of Ship-to Addresses"; Rec."No. of Ship-to Addresses")
                {
                    ToolTip = 'Specifies the value of the No. of Ship-to Addresses field.', Comment = '%';
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
                    ToolTip = 'Specifies the value of the Our Account No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Outstanding Invoices"; Rec."Outstanding Invoices")
                {
                    ToolTip = 'Specifies the value of the Outstanding Invoices field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Outstanding Invoices (LCY)"; Rec."Outstanding Invoices (LCY)")
                {
                    ToolTip = 'Specifies your expected sales income from the customer in LCY based on unpaid sales invoices.';
                    ApplicationArea = All;
                }
                field("Outstanding Orders"; Rec."Outstanding Orders")
                {
                    ToolTip = 'Specifies the value of the Outstanding Orders field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Outstanding Orders (LCY)"; Rec."Outstanding Orders (LCY)")
                {
                    ToolTip = 'Specifies your expected sales income from the customer in LCY based on ongoing sales orders.';
                    ApplicationArea = All;
                }
                field("Outstanding Serv. Orders (LCY)"; Rec."Outstanding Serv. Orders (LCY)")
                {
                    ToolTip = 'Specifies your expected service income from the customer in LCY based on ongoing service orders.';
                    ApplicationArea = All;
                }
                field("Outstanding Serv.Invoices(LCY)"; Rec."Outstanding Serv.Invoices(LCY)")
                {
                    ToolTip = 'Specifies your expected service income from the customer in LCY based on unpaid service invoices.';
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
                    ToolTip = 'Specifies for direct debit collections if the customer that the payment is collected from is a person or a company.';
                    ApplicationArea = All;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ToolTip = 'Specifies how the customer usually submits payment, such as bank transfer or check.';
                    ApplicationArea = All;
                }
                field("Payment Method Id"; Rec."Payment Method Id")
                {
                    ToolTip = 'Specifies the value of the Payment Method Id field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ToolTip = 'Specifies a code that indicates the payment terms that you require of the customer.';
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
                    ToolTip = 'Specifies the sum of payments received from the customer.';
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ToolTip = 'Specifies the customer''s telephone number.';
                    ApplicationArea = All;
                }
                field("Place of Export"; Rec."Place of Export")
                {
                    ToolTip = 'Specifies the value of the Place of Export field.', Comment = '%';
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
                    ToolTip = 'Specifies the customer''s bank account that will be used by default when you process refunds to the customer and direct debit collections.';
                    ApplicationArea = All;
                }
                field("Prepayment %"; Rec."Prepayment %")
                {
                    ToolTip = 'Specifies a prepayment percentage that applies to all orders for this customer, regardless of the items or services on the order lines.';
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
                    ToolTip = 'Specifies the contact number for the customer.';
                    ApplicationArea = All;
                }
                field("Print Statements"; Rec."Print Statements")
                {
                    ToolTip = 'Specifies whether to include this customer when you print the Statement report.';
                    ApplicationArea = All;
                }
                field(Priority; Rec.Priority)
                {
                    ToolTip = 'Specifies a number that corresponds to the priority you give the customer. The higher the number, the higher the priority.';
                    ApplicationArea = All;
                }
                field("Privacy Blocked"; Rec."Privacy Blocked")
                {
                    ToolTip = 'Specifies whether to limit access to data for the data subject during daily operations. This is useful, for example, when protecting data from changes while it is under privacy review.';
                    ApplicationArea = All;
                }
                field("Profit (LCY)"; Rec."Profit (LCY)")
                {
                    ToolTip = 'Specifies the value of the Profit (LCY) field.', Comment = '%';
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
                    ToolTip = 'Specifies the sum of refunds received from the customer.';
                    ApplicationArea = All;
                }
                field("Registration Number"; Rec."Registration Number")
                {
                    ToolTip = 'Specifies the registration number of the customer. You can enter a maximum of 20 characters, both numbers and letters.';
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
                field("Reminder Terms Code"; Rec."Reminder Terms Code")
                {
                    ToolTip = 'Specifies how reminders about late payments are handled for this customer.';
                    ApplicationArea = All;
                }
                field(Reserve; Rec.Reserve)
                {
                    ToolTip = 'Specifies whether items will never, automatically (Always), or optionally be reserved for this customer.';
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ToolTip = 'Specifies the code for the responsibility center that will administer this customer by default.';
                    ApplicationArea = All;
                }
                field("Sales (LCY)"; Rec."Sales (LCY)")
                {
                    ToolTip = 'Specifies the total net amount of sales to the customer in LCY.';
                    ApplicationArea = All;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ToolTip = 'Specifies a code for the salesperson who normally handles this customer''s account.';
                    ApplicationArea = All;
                }
                field("Search Name"; Rec."Search Name")
                {
                    ToolTip = 'Specifies an alternate name that you can use to search for a customer.';
                    ApplicationArea = All;
                }
                field("Sell-to No. Of Archived Doc."; Rec."Sell-to No. Of Archived Doc.")
                {
                    ToolTip = 'Specifies the value of the Sell-to No. Of Sales Archived Doc. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Serv Shipped Not Invoiced(LCY)"; Rec."Serv Shipped Not Invoiced(LCY)")
                {
                    ToolTip = 'Specifies your expected service income from the customer in LCY based on service orders that are shipped but not invoiced.';
                    ApplicationArea = All;
                }
                field("Service Zone Code"; Rec."Service Zone Code")
                {
                    ToolTip = 'Specifies the code for the service zone that is assigned to the customer.';
                    ApplicationArea = All;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ToolTip = 'Specifies the code for another shipment address than the customer''s own address, which is entered by default.';
                    ApplicationArea = All;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ToolTip = 'Specifies which shipment method to use when you ship items to the customer.';
                    ApplicationArea = All;
                }
                field("Shipment Method Id"; Rec."Shipment Method Id")
                {
                    ToolTip = 'Specifies the value of the Shipment Method Id field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Shipped Not Invoiced"; Rec."Shipped Not Invoiced")
                {
                    ToolTip = 'Specifies the value of the Shipped Not Invoiced field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Shipped Not Invoiced (LCY)"; Rec."Shipped Not Invoiced (LCY)")
                {
                    ToolTip = 'Specifies your expected sales income from the customer in LCY based on ongoing sales orders where items have been shipped.';
                    ApplicationArea = All;
                }
                field("Shipping Advice"; Rec."Shipping Advice")
                {
                    ToolTip = 'Specifies if the customer accepts partial shipment of orders.';
                    ApplicationArea = All;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ToolTip = 'Specifies which shipping company is used when you ship items to the customer.';
                    ApplicationArea = All;
                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {
                    ToolTip = 'Specifies the code for the shipping agent service to use for this customer.';
                    ApplicationArea = All;
                }
                field("Shipping Time"; Rec."Shipping Time")
                {
                    ToolTip = 'Specifies how long it takes from when the items are shipped from the warehouse to when they are delivered.';
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
                    ToolTip = 'Specifies the tax area that is used to calculate and post sales tax.';
                    ApplicationArea = All;
                }
                field("Tax Area ID"; Rec."Tax Area ID")
                {
                    ToolTip = 'Specifies the value of the Tax Area ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Tax Liable"; Rec."Tax Liable")
                {
                    ToolTip = 'Specifies if the customer or vendor is liable for sales tax.';
                    ApplicationArea = All;
                }
                field("Telex Answer Back"; Rec."Telex Answer Back")
                {
                    ToolTip = 'Specifies the value of the Telex Answer Back field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Telex No."; Rec."Telex No.")
                {
                    ToolTip = 'Specifies the value of the Telex No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Territory Code"; Rec."Territory Code")
                {
                    ToolTip = 'Specifies the value of the Territory Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Use GLN in Electronic Document"; Rec."Use GLN in Electronic Document")
                {
                    ToolTip = 'Specifies whether the GLN is used in electronic documents as a party identification number.';
                    ApplicationArea = All;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ToolTip = 'Specifies the customer''s VAT specification to link transactions made for this customer to.';
                    ApplicationArea = All;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ToolTip = 'Specifies the customer''s VAT registration number for customers in EU countries/regions.';
                    ApplicationArea = All;
                }
                field("Validate EU Vat Reg. No."; Rec."Validate EU Vat Reg. No.")
                {
                    ToolTip = 'Specifies the value of the Validate EU VAT Reg. No. field.', Comment = '%';
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
