module lesson5::FT_TOKEN {
    use std::option;
    use std::string::{Self, String};
    use std::ascii::{Self};
    use sui::url;
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin, TreasuryCap, CoinMetadata};
    use sui::transfer;
    use sui::event;

    struct FT_TOKEN has drop { }

    fun init(witness: FT_TOKEN, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency<FT_TOKEN>(
            witness,
            18,
            b"Symbol",
            b"Name",
            b"Description",
             option::some(url::new_unsafe_from_bytes(b"https://youtube.com")),
            ctx
        );
        transfer::public_transfer(metadata, tx_context::sender(ctx));
        transfer::public_share_object(treasury_cap);
    }

    // mint 10_000 each time, only owner of token can mint
    public fun mint(_: &CoinMetadata<FT_TOKEN>, treasury_cap: &mut TreasuryCap<FT_TOKEN>, recipient: address, ctx: &mut TxContext) {
        coin::mint_and_transfer(treasury_cap, 10_000, recipient, ctx);
    }

    // anyone can burn
    public entry fun burn_token(cap: &mut coin::TreasuryCap<FT_TOKEN>, c: coin::Coin<FT_TOKEN>) {
        coin::burn(cap,c);
    }

    // transfer token from to
    public entry fun transfer_token(coin: &mut Coin<FT_TOKEN>, amount: u64, to: address, ctx: &mut TxContext) {
        let object_split = split_token(coin, amount, ctx);
        transfer::public_transfer(object_split, to);
        // emit event
        event::emit(TransferEvent {
            from: tx_context::sender(ctx),
            to,
            amount,
        })
    
    }

    // use coin:: framework to split token for transfer
    public fun split_token(token: &mut Coin<FT_TOKEN>, split_amount: u64, ctx: &mut TxContext): Coin<FT_TOKEN> {
        coin::split(token, split_amount, ctx)
    }

    // UPDATE METADATA
    public entry fun update_name( treasury_cap: &mut TreasuryCap<FT_TOKEN>,metadata: &mut CoinMetadata<FT_TOKEN>, name: vector<u8>) {
        coin::update_name(treasury_cap, metadata, string::utf8(name));
    }
    public entry fun update_description(treasury_cap: &mut TreasuryCap<FT_TOKEN>,metadata: &mut CoinMetadata<FT_TOKEN>, description: vector<u8>) {
        coin::update_description(treasury_cap, metadata, string::utf8(description));
    }
    public entry fun update_symbol(treasury_cap: &mut TreasuryCap<FT_TOKEN>,metadata: &mut CoinMetadata<FT_TOKEN>, symbol: vector<u8>) {
        coin::update_description(treasury_cap, metadata, string::utf8(symbol));
    }
    public entry fun update_icon_url(treasury_cap: &mut TreasuryCap<FT_TOKEN>,metadata: &mut CoinMetadata<FT_TOKEN>, icon_url: vector<u8>) {
        coin::update_icon_url(treasury_cap, metadata, ascii::string(icon_url));
    }

    // EVENT
    struct UpdateEvent {
        success: bool,
        data: String
    }

    struct TransferEvent has drop,copy {
        from: address,
        to: address,
        amount: u64,
    }

    // GETTER
    public entry fun get_token_name(metadata: &CoinMetadata<FT_TOKEN>): string::String {
        coin::get_name(metadata)
    }
    public entry fun get_token_description(metadata: &CoinMetadata<FT_TOKEN>): string::String {
        coin::get_description(metadata)
    }
    public entry fun get_token_symbol(metadata: &CoinMetadata<FT_TOKEN>) : ascii::String {
        coin::get_symbol(metadata)
    }
    public entry fun get_token_icon_url(metadata: &CoinMetadata<FT_TOKEN>): option::Option<url::Url>  {
        coin::get_icon_url(metadata)
    }
}
