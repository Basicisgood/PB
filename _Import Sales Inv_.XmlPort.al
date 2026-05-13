xmlport 50101 "Import Sales Inv"
{
    Caption = 'Import Sales Inv XMLPort';
    Direction = Import;
    Format = VariableText;
    Permissions = TableData "Sales Invoice Header"=rimd,
        TableData "Sales invoice Line"=rimd;
    TextEncoding = UTF8;
    FormatEvaluate = Legacy;
    UseRequestPage = false;

    // ApplicationArea = True;
    // FileName = 'abc1.csv';
    schema
    {
    textelement(RootNodeName)
    {
    tableelement(SalesInvLineTemp;
    "Sales Invoice Line")
    {
    UseTemporary = true;

    fieldelement(DocNo;
    SalesInvLineTemp."Document No.")
    {
    FieldValidate = No;
    }
    fieldelement(SelltoCust;
    SalesInvLineTemp."Sell-to Customer No.")
    {
    FieldValidate = No;
    }
    fieldelement(Line;
    SalesInvLineTemp."Line No.")
    {
    FieldValidate = No;
    }
    fieldelement(Desc;
    SalesInvLineTemp.Description)
    {
    FieldValidate = No;
    }
    // trigger OnAfterGetRecord()
    // var
    //     SalesInvHdr_l: Record "Sales Invoice Header";
    //     SalesInvLine_l: Record "Sales Invoice Line";
    // begin
    //     If NOT SalesInvHdr_l.get(SalesInvLineTemp."Document No.") then begin
    //         SalesInvHdr_l.Init();
    //         SalesInvHdr_l."No." := SalesInvLineTemp."Document No.";
    //         SalesInvHdr_l."Sell-to Customer No." := SalesInvLineTemp."Sell-to Customer No.";
    //         SalesInvHdr_l.Insert();
    //     end;
    //     SalesInvLine_l.Init();
    //     SalesInvLine_l."Document No." := SalesInvLineTemp."Document No.";
    //     SalesInvLine_l."Line No." := SalesInvLineTemp."Line No.";
    //     SalesInvLine_l.Description := SalesInvLineTemp.Description;
    //     SalesInvLine_l.Insert();
    // end;
    trigger OnBeforeInsertRecord()
    var
        SalesInvHdr_l: Record "Sales Invoice Header";
        SalesInvLine_l: Record "Sales Invoice Line";
    begin
        If NOT SalesInvHdr_l.get(SalesInvLineTemp."Document No.")then begin
            SalesInvHdr_l.Init();
            SalesInvHdr_l."No.":=SalesInvLineTemp."Document No.";
            SalesInvHdr_l."Sell-to Customer No.":=SalesInvLineTemp."Sell-to Customer No.";
            SalesInvHdr_l.Insert();
        end;
        SalesInvLine_l.Init();
        SalesInvLine_l."Document No.":=SalesInvLineTemp."Document No.";
        SalesInvLine_l."Line No.":=SalesInvLineTemp."Line No.";
        SalesInvLine_l.Description:=SalesInvLineTemp.Description;
        SalesInvLine_l.Insert();
    end;
    }
    }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
}
