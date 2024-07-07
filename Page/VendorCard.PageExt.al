pageextension 57108 ITOS_Vendor_Card extends "Vendor Card"
{
    actions
    {
        addlast(processing)
        {
            action(ITOSSyncSetup)
            {
                Caption = 'IC Sync Setup';
                ApplicationArea = All;
                RunObject = page "ITOS Inter-Company Sync Setup";
                RunPageLink = "ITOS Primary Key 1" = field("No."), "ITOS Table No." = const(Database::Vendor);
            }
        }

        addlast("F&unctions")
        {
            action("ITOSSendToIC")
            {
                ApplicationArea = Intercompany;
                Caption = 'Send IC Vendor';
                Image = IntercompanyOrder;

                trigger OnAction()
                var
                    ICSyncMgt: Codeunit "ITOS IC Sync Mgt.";
                begin
                    if not ICSyncMgt.SendVendorToIC(Rec) then
                        Message(GetLastErrorText());
                end;
            }
        }

    }
}
