page 50230 "Company Mapping Multiple"
{
    Caption = 'Company Mapping';
    PageType = List;
    SourceTable = "Company Name Mapping";
    PromotedActionCategories = 'New,Process,Report,Confirm';
    // UsageCategory = Lists;
    SourceTableTemporary = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            field("Company Code"; RefCompCode)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Filter Criteria"; FilterText)
            {
                ApplicationArea = All;

                trigger OnValidate()
                begin
                    IF FilterText <> '' then rec.setfilter("BC Company Name", FilterText)
                    else
                        rec.SetRange("BC Company Name");
                    CurrPage.Update(false);
                end;
            }
            repeater(General)
            {
                field("BC Company Name"; Rec."BC Company Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("PB Company Code"; Rec."PB Company Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Select; Rec.Select)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Selected")
            {
                Caption = 'Select';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    Map: Record "Company Name Mapping";
                begin
                    CurrPage.SetSelectionFilter(rec);
                    //rec.SetRecFilter();
                    IF rec.FindSet()then rec.ModifyAll(Select, true);
                end;
            }
            action("Confirm")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    IF Confirm('Are you sure , selected ones are parent companies', false)then begin
                        G_String:=ProcessParentCompanyString();
                        RecCompMap.GET(RefCompCode);
                        RecCompMap."Central payment company":=G_string + '|' + RefCompCode;
                        RecCompMap.Modify();
                        CurrPage.Close();
                    END;
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        CompMap.GET(RefCompCode);
        RecCompMap.reset;
        RecCompMap.setfilter("BC Company Name", '<>%1', RefCompCode);
        IF RecCompMap.FindFirst()then repeat rec.Init();
                rec.TransferFields(RecCompMap);
                IF StrPos(CompMap."Central payment company", RecCompMap."BC Company Name") <> 0 then rec.Select:=true
                else
                    rec.Select:=false;
                rec.Insert();
            until RecCompMap.Next() = 0;
        Rec.FindFirst();
    end;
    procedure ProcessParentCompanyString(): Text var
        L_String: text;
    begin
        L_String:='';
        rec.reset;
        rec.SetCurrentKey(Select);
        rec.SetRange(Select, true);
        IF rec.FindFirst()then repeat IF L_String = '' then L_String:=rec."BC Company Name"
                else
                    L_String+='|' + rec."BC Company Name";
            until Rec.Next() = 0;
        rec.SetRange(Select);
        exit(L_String);
    end;
    procedure SetCompanyCode(P_CompCode: text[30])
    begin
        RefCompCode:=P_CompCode;
    end;
    var StyleText: Boolean;
    RecCompMap: Record "Company Name Mapping";
    G_String: text;
    RefCompCode: Text[30];
    CompMap: Record "Company Name Mapping";
    FilterText: text;
}
