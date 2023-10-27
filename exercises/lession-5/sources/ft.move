module lesson5::FT_TOKEN {
    use std::option;
    use std::string::{Self, String};
    use sui::url;
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin, TreasuryCap, CoinMetadata};
    use sui::transfer;
    use sui::event;

    struct FT_TOKEN has drop{ }

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
    public entry fun split_token(token: &mut Coin<FT_TOKEN>, split_amount: u64, ctx: &mut TxContext): Coin<FT_TOKEN> {
        coin::split(token, split_amount, ctx)
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

    struct TransferEvent has drop,copy {
        from: address,
        to: address,
        amount: u64,
    }

    // GETTER
    public entry fun get_token_name() {}
    public entry fun get_token_description() {}
    public entry fun get_token_symbol() {}
    public entry fun get_token_icon_url() {}
}
