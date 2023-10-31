// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

/// Basic `Marketplace` implementation. Supports listing of any assets,
/// and does not have constraints.
///
/// Makes use of `sui::dynamic_object_field` module by attaching `Listing`
/// objects as fields to the `Marketplace` object; as well as stores and
/// merges user profits as dynamic object fields (ofield).
///
/// Rough illustration of the dynamic field architecture for listings:
/// ```
///             /--->Listing--->Item
/// (Marketplace)--->Listing--->Item
///             \--->Listing--->Item
/// ```
///
/// Profits storage is also attached to the `Marketplace` (indexed by `address`):
/// ```
///                   /--->Coin<COIN>
/// (Marketplace<COIN>)--->Coin<COIN>
///                   \--->Coin<COIN>
/// ```
/// 
/// https://github.com/MystenLabs/sui/blob/main/sui_programmability/examples/nfts/sources/marketplace.move
/// https://github.com/sui-foundation/sui-move-intro-course/blob/main/unit-four/example_projects/marketplace/sources/marketplace.move
/// 
module marketplace::market {
     use sui::object::{Self, ID, UID};
     use sui::coin::{Self, Coin};

    /// A shared `Marketplace`. Can be created by anyone using the
    /// `create` function. One instance of `Marketplace` accepts
    /// only one type of Coin - `COIN` for all its listings.
    struct Marketplace<phantom COIN> has key {
        id: UID,
        items: Bag,
        payments: Table<address, Coin<COIN>>
    }
}