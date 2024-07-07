pageextension 57100 "ITOS Intercompany Setup" extends "Intercompany Setup"
{

    layout
    {
        addlast(General)
        {
            group("Inter-Company Sync Group")
            {
                field("ITOS Sync Items to Inter-company"; Rec."ITOS Sync Items to IC")
                {
                    ApplicationArea = all;

                }
                field("ITOS Sync Customer to Intern-Company"; Rec."ITOS Sync Customer to IC")
                {
                    ApplicationArea = all;
                }
                field("ITOS Sync-Vendor to Inter-Company"; Rec."ITOS Sync-Vendor to IC")
                {
                    ApplicationArea = all;
                }
                field("ITOS Sync-Dimension to Inter-Company"; Rec."ITOS Sync-Dimension to IC")
                {
                    ApplicationArea = all;
                }
                field("ITOS Sync-COA to Inter-Company"; Rec."ITOS Sync-COA to IC")
                {
                    ApplicationArea = all;
                }





            }
        }

    }
}

