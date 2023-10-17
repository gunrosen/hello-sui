module nft::Coupon {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    // use sui::coin::{Self, Coin, TreasuryCap, CoinMetadata};
    use nft::NFT::NFT;

    const WrongDiscountValue: u64 = 0;
    
    struct Coupon has key {
        id: UID,
        owner: address,
        discount: u8,
        expiration: u64,
    }

    public fun owner(coupon: &Coupon): address{
        coupon.owner
    }
    
    public entry fun create_coupon(discount: u8, expiration: u64, receiver: address, ctx: &mut TxContext){
        assert!(discount > 0 && discount <= 100, WrongDiscountValue);
        let coupon = Coupon{
            id: object::new(ctx),
            discount,
            expiration,
            owner: tx_context::sender(ctx),
        };
        // NFT::mint()
        transfer::transfer(coupon, receiver);
    }    

    public entry fun burn() {

    }
 
}