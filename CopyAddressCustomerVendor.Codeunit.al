codeunit 50125 CopyAddressCustomerVendor
{
    trigger OnRun()
    begin
    end;
    procedure CopyAddressFromVendor(var Customer_p: Record Customer)
    var
        VendorCard: page "Vendor List";
        Vendor_l: Record Vendor;
        Cust: Record Customer;
    begin
        Vendor_l.Reset();
        VendorCard.LookupMode:=true;
        VendorCard.SetTableView(Vendor_l);
        if VendorCard.RunModal() = ACTION::LookupOK then begin
            VendorCard.GetRecord(Vendor_l);
            // If Not Vendor_l.IsEmpty then
            //     Vendor_l.FindFirst();
            // Cust.Reset();
            // if Cust.get(Customer_p."No.") then begin
            Customer_p.Validate(Name, vendor_l.Name);
            Customer_p.Validate(Blocked, vendor_l.Blocked);
            Customer_p.Validate("Balance (LCY)", vendor_l."Balance (LCY)");
            Customer_p.Validate("Balance Due", vendor_l."Balance Due");
            Customer_p.Validate("Reference Code", vendor_l."Reference Code");
            Customer_p.Validate("Parent Company Type", vendor_l."Parent Company Type");
            Customer_p.Validate("Parent Company", vendor_l."Parent Company");
            Customer_p.Validate("Short Name", vendor_l."Short Name");
            //Customer_p.Validate("IMOS Company No.", vendor_l."IMOS Company No.");
            Customer_p.Validate("Name of Shareholder", vendor_l."Name of Shareholder");
            Customer_p.Address:=Vendor_l.Address;
            Customer_p."Address 2":=Vendor_l."Address 2";
            Customer_p.City:=Vendor_l.City;
            Customer_p."Country/Region Code":=Vendor_l."Country/Region Code";
            Customer_p.County:=Vendor_l.County;
            Customer_p."Post Code":=Vendor_l."Post Code";
            Customer_p.Validate("Phone No.", vendor_l."Phone No.");
            Customer_p.Validate("Mobile Phone No.", vendor_l."Mobile Phone No.");
            Customer_p.Validate("E-Mail", vendor_l."E-Mail");
            // Rec.Validate("Home Page", vendor_l."Home Page");
            Customer_p.Validate("Our Account No.", vendor_l."Our Account No.");
            Customer_p.Validate("Primary Contact No.", vendor_l."Primary Contact No.");
            Customer_p.Validate(Contact, vendor_l.Contact);
            Customer_p.Modify();
            Customer_p.Modify();
        // end;
        end;
    end;
    procedure CopyAddressFromCustomer(var Vendor_p: Record Vendor)
    var
        CustomerCard: page "Customer List";
        Customer_l: Record Customer;
        Vend: Record Vendor;
    begin
        Customer_l.Reset();
        CustomerCard.LookupMode:=true;
        CustomerCard.SetTableView(Customer_l);
        if CustomerCard.RunModal() = ACTION::LookupOK then begin
            CustomerCard.GetRecord(Customer_l);
            /* If Not vendor_l.IsEmpty then
                vendor_l.FindFirst(); */
            // Vend.Reset();
            // if Vend.get(Vendor_p."No.") then begin
            /* Vend.Address := vendor_l.Address;
            Vend."Address 2" := vendor_l."Address 2";
            Vend.City := vendor_l.City;
            Vend."Country/Region Code" := vendor_l."Country/Region Code";
            Vend.County := vendor_l.County;
            Vend."Post Code" := vendor_l."Post Code";
            Vend.Modify(); */
            // end;
            Vendor_p.Validate(Name, Customer_l.Name);
            Vendor_p.Validate(Blocked, Customer_l.Blocked);
            Vendor_p.Validate("Balance (LCY)", Customer_l."Balance (LCY)");
            Vendor_p.Validate("Balance Due", Customer_l."Balance Due");
            Vendor_p.Validate("Reference Code", Customer_l."Reference Code");
            Vendor_p.Validate("Parent Company Type", Customer_l."Parent Company Type");
            Vendor_p.Validate("Parent Company", Customer_l."Parent Company");
            Vendor_p.Validate("Short Name", Customer_l."Short Name");
            // Vendor_p.Validate("IMOS Company No.", Customer_l."IMOS Company No.");
            Vendor_p.Validate("Name of Shareholder", Customer_l."Name of Shareholder");
            Vendor_p.Address:=Customer_l.Address;
            Vendor_p."Address 2":=Customer_l."Address 2";
            Vendor_p.City:=Customer_l.City;
            Vendor_p."Post Code":=Customer_l."Post Code";
            Vendor_p."Country/Region Code":=Customer_l."Country/Region Code";
            Vendor_p.County:=Customer_l.County;
            Vendor_p.Validate("Phone No.", Customer_l."Phone No.");
            Vendor_p.Validate("Mobile Phone No.", Customer_l."Mobile Phone No.");
            Vendor_p.Validate("E-Mail", Customer_l."E-Mail");
            // Rec.Validate("Home Page", Customer_l."Home Page");
            Vendor_p.Validate("Our Account No.", Customer_l."Our Account No.");
            Vendor_p.Validate("Primary Contact No.", Customer_l."Primary Contact No.");
            Vendor_p.Validate(Contact, Customer_l.Contact);
            Vendor_p.Modify();
        end;
    end;
}
