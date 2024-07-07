tableextension 57100 "ITOS Inter Company Setup" extends "IC Setup"
{
    fields
    {
        field(57100; "ITOS Sync Items to IC"; Boolean)
        {
            Caption = 'Sync Items to Inter-company';
            DataClassification = ToBeClassified;
        }
        field(57101; "ITOS Sync Customer to IC"; Boolean)
        {
            Caption = 'Sync Customer to Intern-Company';
            DataClassification = ToBeClassified;
        }
        field(57102; "ITOS Sync-Vendor to IC"; Boolean)
        {
            Caption = 'Sync-Vendor to Inter-Company';
            DataClassification = ToBeClassified;
        }
        field(57103; "ITOS Sync-Dimension to IC"; Boolean)
        {
            Caption = 'Sync-Dimension to Inter-Company';
            DataClassification = ToBeClassified;
        }
        field(57104; "ITOS Sync-COA to IC"; Boolean)
        {
            Caption = 'Sync-COA to Inter-Company';
            DataClassification = ToBeClassified;
        }

    }
}
