module nft::auctiondata {
    use sui::object::{Self, UID, ID};
    use sui::balance::Balance;
    use sui::sui::SUI;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use std::option::{Self, Option};

    friend nft::auction;

     struct BidData has store {
        funds: Balance<SUI>,
        highest_bidder: address
    }

    struct Auction<T: key+ store> has key {
        id: UID,
        owner: address,
        to_sell: Option<T>,
        bid_data: Option<BidData>
    }

    // friend: same address can use 
    public(friend) fun create_auction<T: key+ store>(to_sell: T, ctx: &mut TxContext): Auction<T>{
        Auction<T> {
            id: object::new(ctx),
            to_sell: option::some(to_sell),
            owner: tx_context::sender(ctx),
            bid_data: option::none(),
        }
    }

    public(friend) fun check_auction_owner<T: key+ store>(auction: &Auction<T>): address {
        auction.owner
    }

    public fun transfer<T: key + store> (obj: Auction<T>, receiver: address){
        transfer::transfer(obj, receiver);
    }

}