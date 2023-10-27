module lesson5::FT_TOKEN {
    struct FT_TOKEN { }

    fun init(witness: FT_TOKEN, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency(
            
        );
    }

    // mint 10_000 each time, only owner of token can mint
    public fun mint() {

    }

    // anyone can burn
    public entry fun burn_token() {

    }

    // transfer token from to
    public entry fun transfer_token() {

        // emit event
    }

    // use coin:: framework to split token for transfer
    public entry fun split_token() {

    }

    // UPDATE METADATA
    public entry fun update_name() {}
    public entry fun update_description() {}
    public entry fun update_symbol() {}
    public entry fun update_icon_url() {}

    // EVENT
    struct UpdateEvent {
        success: bool,
        data: String
    }

    // GETTER
    public entry fun get_token_name() {}
    public entry fun get_token_description() {}
    public entry fun get_token_symbol() {}
    public entry fun get_token_icon_url() {}
}
