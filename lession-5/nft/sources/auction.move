module nft::auction {
    use sui::object::{Self, UID, ID};
    use sui::balance::Balance;
    use sui::sui::SUI;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use std::option::{Self};
    use nft::auctiondata;

    struct Bid has key {
        id: UID,
        bidder: address,
        auction_id: ID,
        bid: Balance<SUI>
    }

   public fun new_auction<T: key+store>(to_sell: T, ctx: &mut TxContext): ID {
        let auction = auctiondata::create_auction(to_sell, ctx);
        let id = object::id(&auction);
        auctiondata::transfer(auction, tx_context::sender(ctx));
        id
   }

}