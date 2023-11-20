module lesson5::discount_coupon {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;

    struct DiscountCoupon has key, store {
        id: UID,
        owner: address,
        discount: u8,
        expiration: u64,
    }

    /// get owner
    public fun owner(coupon: &DiscountCoupon): address {
        coupon.owner
    }

    /// get coupon discount
    public fun discount(coupon: &DiscountCoupon): u8 {
        coupon.discount
    }

    // mint 1 coupon and transfer coupon to recipient
    public entry fun mint_and_topup(
        coin: coin::Coin<SUI>,
        discount: u8,
        expiration: u64,
        recipient: address,
        ctx: &mut TxContext,
    ) {
        let coupon = DiscountCoupon {
            id:  object::new(ctx),
            owner: tx_context::sender(ctx),
            discount: 1,
            expiration: 1000,
        };
        transfer::public_transfer(coupon, recipient);
         transfer::public_transfer(coin, recipient);
    }

    // transfer coupon to
    public entry fun transfer_coupon(coupon: DiscountCoupon, recipient: address) {
        transfer::public_transfer(coupon, recipient);
    }

    // delete coupon
    public fun burn(nft: DiscountCoupon): bool {
        let DiscountCoupon{id , owner: _, discount: _, expiration: _} = nft;
        object::delete(id);
        true
    }

    // User use coupon and then delete it
    public entry fun scan(nft: DiscountCoupon) {
        // ....check information
        burn(nft);
    }
}
