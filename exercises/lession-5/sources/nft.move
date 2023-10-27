module lesson5::discount_coupon {
    struct DiscountCoupon has key {
        id: UID,
        owner: address,
        discount: u8,
        expiration: u64,
    }

    /// get owner
    public fun owner(coupon: &DiscountCoupon): address {}

    /// get coupon discount
    public fun discount(coupon: &DiscountCoupon): u8 {}

    // mint 1 coupon and transfer coupon to recipient
    public entry fun mint_and_topup(
        coin: coin::Coin<SUI>,
        discount: u8,
        expiration: u64,
        recipient: address,
        ctx: &mut TxContext,
    ) {}

    // transfer coupon to
    public entry fun transfer_coupon(coupon: DiscountCoupon, recipient: address) {}

    // delete coupon
    public fun burn(nft: DiscountCoupon): bool {}

    // User use coupon and then delete it
    public entry fun scan(nft: DiscountCoupon) {
        // ....check information
        burn(nft);
    }
}
