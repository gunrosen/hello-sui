module tokens::TOKEN {
    use sui::coin::{Self, Coin, TreasuryCap, CoinMetadata};
    use std::option;
    use sui::url;
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use std::string;
    
    struct TOKEN has drop {}

   fun init(witness: TOKEN, ctx: &mut TxContext){ 
        let (treasury_cap, metadata) = coin::create_currency<TOKEN>(
            witness,
            14,
            b"HULK",
            b"HULK Token", 
            b"This is an example token", 
            option::some(url::new_unsafe_from_bytes(b"https://youtube.com")),
            ctx
        );
        // public_transfer: cho phep dung o ngoai model, de token nay co the thanh toan o nhieu game khac nhau
        transfer::public_transfer(metadata, tx_context::sender(ctx));
        transfer::public_transfer(treasury_cap, tx_context::sender(ctx));


    }

    public entry fun mint(treasury_cap: &mut TreasuryCap<TOKEN>, amount: u64, receiver: address, ctx: &mut TxContext){
        coin::mint_and_transfer(treasury_cap,amount, receiver, ctx );
    }

    public entry fun burn(treasury_cap: &mut TreasuryCap<TOKEN>,coin: Coin<TOKEN>){
        coin::burn(treasury_cap,coin);
    }

    public entry fun transfer_ownership(treasury_cap: TreasuryCap<TOKEN>, metadata: CoinMetadata<TOKEN>, receiver: address){
         transfer::public_transfer(metadata, receiver);
        transfer::public_transfer(treasury_cap, receiver);
    }

    public entry fun transfer_treasury_cap(treasury_cap: TreasuryCap<TOKEN>, receiver: address){
         transfer::public_transfer(treasury_cap, receiver);
    }

    public entry fun transfer_coin_owner(metadata: CoinMetadata<TOKEN>, receiver: address){
         transfer::public_transfer(metadata, receiver);
    }

    public entry fun update_name(treasury_cap: &mut TreasuryCap<TOKEN>, metadata:&mut  CoinMetadata<TOKEN>, new_name: string::String){
        coin::update_name<TOKEN>(treasury_cap, metadata, new_name);
    }

}