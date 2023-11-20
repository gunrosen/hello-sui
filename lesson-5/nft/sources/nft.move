module nft::NFT {
    use sui::object::{Self, UID, ID};
    // use sui::coin::{Self, Coin, TreasuryCap, CoinMetadata};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use sui::url::{Self, Url};
    use sui::event;
    
    use std::string::{Self, String};


    // ability store means can store in another model
    struct NFT has key, store {
        id: UID,
        title: String,
        description: String,
        url: Url,
    }

       struct EventMintNFT has copy, drop{
        creator: address,
        id:  ID,
        title: String,
    }


    public entry fun mint(title: vector<u8>, description: vector<u8>, url: vector<u8>, ctx: &mut TxContext){
        let nft = NFT {
            id: object::new(ctx),
            title: string::utf8(title),
            description: string::utf8(description),
            url: url::new_unsafe_from_bytes(url)
        };
        let sender = tx_context::sender(ctx);

        event::emit(EventMintNFT{
            id: object::uid_to_inner(&nft.id),
            creator: sender,
            title: nft.title
        });
        
        transfer::public_transfer(nft, sender);
    }

    public entry fun burn(nft: NFT){
        let NFT{id, title: _, description: _, url: _} = nft;
        object::delete(id);
    }

    // public fun:  call be same module, same contract
    // public entry fun: external call
    public fun get_url(nft: &NFT): &Url {
        &nft.url
    }
} 