page 57102 "ITOS Inter-Company Sync Setup"
{
    ApplicationArea = All;
    Caption = 'Inter-Company Sync Setup';
    PageType = List;
    SourceTable = "ITOS IC Sync Setup";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Table No."; Rec."ITOS Table No.")
                {
                    ToolTip = 'Specifies the value of the Table No. field.';
                    Editable = false;
                    Visible = false;
                }
                field("Primary Key 1"; Rec."ITOS Primary Key 1")
                {
                    ToolTip = 'Specifies the value of the Primary Key 1 field.';
                    Editable = false;
                }
                field("Primary Key 2"; Rec."ITOS Primary Key 2")
                {
                    ToolTip = 'Specifies the value of the Primary Key 2 field.';
                    Editable = false;
                    Visible = false;
                }
                field("Primary Key 3"; Rec."ITOS Primary Key 3")
                {
                    ToolTip = 'Specifies the value of the Primary Key 3 field.';
                    Editable = false;
                    Visible = false;
                }

                field("Company Name"; Rec."ITOS Company Name")
                {
                    ToolTip = 'Specifies the value of the Company NITOS field.';

                }
                field("ITOS Status"; Rec."ITOS Status")
                {
                    ApplicationArea = All;
                }
                field("Created On"; Rec."ITOS Created On")
                {
                    ToolTip = 'Specifies the value of the Created On field.';
                    Editable = false;

                }
                field("Last Updated On"; Rec."ITOS Last Updated On")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Last Updated On  field.';
                }


            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        myInt: Integer;
    begin
        if Rec."ITOS Table No." = 0 then
            if Rec.GetFilter("ITOS Table No.") <> '' then
                Evaluate(rec."ITOS Table No.", rec.GetFilter("ITOS Table No."));
        if rec."ITOS Primary Key 1" = '' then
            if Rec.GetFilter("ITOS Primary Key 1") <> '' then
                rec."ITOS Primary Key 1" := rec.GetFilter("ITOS Primary Key 1");
        if rec."ITOS Primary Key 2" = '' then
            if Rec.GetFilter("ITOS Primary Key 2") <> '' then
                rec."ITOS Primary Key 2" := rec.GetFilter("ITOS Primary Key 2");
        if rec."ITOS Primary Key 3" = '' then
            if Rec.GetFilter("ITOS Primary Key 3") <> '' then
                rec."ITOS Primary Key 3" := rec.GetFilter("ITOS Primary Key 3");

    end;
}
