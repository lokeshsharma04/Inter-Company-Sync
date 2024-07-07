pageextension 57104 "ITOS Customer Card" extends "Customer Card"
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
                RunPageLink = "ITOS Primary Key 1" = field("No."), "ITOS Table No." = const(Database::Customer);
            }
        }


        addlast("F&unctions")
        {
            action("ITOSSendToIC")
            {
                ApplicationArea = Intercompany;
                Caption = 'Send IC Customer';
                Image = IntercompanyOrder;

                trigger OnAction()
                var
                    ICSyncMgt: Codeunit "ITOS IC Sync Mgt.";
                begin
                    if not ICSyncMgt.SendCutomerToIC(Rec) then
                        Message(GetLastErrorText());
                end;
            }
        }
    }
}
