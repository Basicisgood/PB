page 50143 Consolidation
{
    PageType = Document;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Consolidate;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            field("No."; Rec."No.")
            {
                ApplicationArea = All;
            }
            group(Criteria)
            {
                group("Main Account")
                {
                    field("From Account"; Rec."From Account")
                    {
                        Caption = 'From';
                        ApplicationArea = All;
                    }
                    field("To Account"; Rec."To Account")
                    {
                        Caption = 'To';
                        ApplicationArea = All;
                    }
                }
                group("Consolidation Period")
                {
                    field("From Period"; Rec."From Period")
                    {
                        Caption = 'From';
                        ApplicationArea = All;
                    }
                    field("To Period"; Rec."To Period")
                    {
                        Caption = 'To';
                        ApplicationArea = All;
                    }
                }
                field("Include Actual Amounts"; Rec."Include Actual Amounts")
                {
                    ApplicationArea = All;
                }
                field("Rebuild Bal. during Con. Proc."; Rec."Rebuild Bal. during Con. Proc.")
                {
                    ApplicationArea = All;
                }
            }
            group(General)
            {
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                group(Elimination)
                {
                    field("Proposal Options"; Rec."Proposal Options")
                    {
                        ApplicationArea = All;
                    }
                    field("G/L Posting Date"; Rec."G/L Posting Date")
                    {
                        ApplicationArea = All;
                    }
                    field("Release Date"; Rec."Release Date")
                    {
                        ApplicationArea = All;
                    }
                    field("Reason Code"; Rec."Reason Code")
                    {
                        ApplicationArea = All;
                    }
                    field("Reason Comment"; Rec."Reason Comment")
                    {
                        ApplicationArea = All;
                    }
                }
                group("Currency Translation")
                {
                    field("Exchange Rate Type"; Rec."Exchange Rate Type")
                    {
                        ApplicationArea = All;
                    }
                    field("Exchange Rate Date"; Rec."Exchange Rate Date")
                    {
                        ApplicationArea = All;
                    }
                    field("Exchange Rate"; Rec."Exchange Rate")
                    {
                        ApplicationArea = All;
                    }
                }
            }
            part(LegalEntities; "Legal Entities")
            {
                ApplicationArea = all;
                //Editable = IsSalesLinesEditable;
                //Enabled = IsSalesLinesEditable;
                SubPageLink = "Consolidate No."=field("No.");
                UpdatePropagation = Both;
            }
            part(ConsolidateElimination; "Consolidate Elimination")
            {
                ApplicationArea = all;
                Caption = 'Elimination';
                //Editable = IsSalesLinesEditable;
                //Enabled = IsSalesLinesEditable;
                SubPageLink = "Consolidate No."=field("No.");
                UpdatePropagation = Both;
            }
            part(CurrencyTranslation; "Currency Translation")
            {
                ApplicationArea = all;
                //Editable = IsSalesLinesEditable;
                //Enabled = IsSalesLinesEditable;
                SubPageLink = "Consolidate No."=field("No.");
                UpdatePropagation = Both;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Dimensions)
            {
                AccessByPermission = TableData Dimension=R;
                ApplicationArea = all;
                Image = Dimensions;

                trigger OnAction()
                begin
                    Rec.ShowDimensions();
                end;
            }
        }
    }
    var myInt: Integer;
}
