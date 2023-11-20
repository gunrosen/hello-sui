/// A flash loan that works for any Coin type
module lesson9::flash_lender {
    struct FlashLender<phantom T> has key {
        id: UID,
        /// borrowable amount
        to_lend: Balance<T>,
        fee: u64,
    }


    /// This struct has not key and store, it is not transferable and store. It also has not drop, using `repay` to delete it
    struct Receipt<phantom T> {
        flash_lender_id: ID,
        repay_amount: u64
    }

    /// In case `FlashLender` has ID `flash_lender_id`. 
    /// Initially, it assigns to creator of `FlashLender`
    /// And have only one `AdminCap` for lender
    struct AdminCap has key, store {
        id: UID,
        flash_lender_id: ID,
    }

    // === Creating a flash lender ===

    /// Create `FlashLender` and share to make `to_lend`
    /// Anyone has to repay the money and fee before transaction ended
    public fun new<T>(to_lend: Balance<T>, fee: u64, ctx: &mut TxContext): AdminCap {}

    /// The same with `new` function but transfer `AdminCap` to caller
    public entry fun create<T>(to_lend: Coin<T>, fee: u64, ctx: &mut TxContext) {}

   /// Request a loan with `amount`
   /// Make sure call `repay` to lender in current transaction
   /// Abort if `amount` higher than amount of `lender` 's borrowable amount
    public fun loan<T>(
        self: &mut FlashLender<T>, amount: u64, ctx: &mut TxContext
    ): (Coin<T>, Receipt<T>) {
    }

   /// Repay a loan from `receipt` to `lender` with `payment` amount
   /// Abort when repay amount invalid or `lender` is not `FlashLender`
    public fun repay<T>(self: &mut FlashLender<T>, payment: Coin<T>, receipt: Receipt<T>) {}

    /// `self` withdrawal
    public fun withdraw<T>(self: &mut FlashLender<T>, admin_cap: &AdminCap, amount: u64, ctx: &mut TxContext): Coin<T> {}

    // Only owner of `AdminCap` for `self` can deposit
    public entry fun deposit<T>(self: &mut FlashLender<T>, admin_cap: &AdminCap, coin: Coin<T>) {
    }

    /// Owner can update fee
    public entry fun update_fee<T>(self: &mut FlashLender<T>, admin_cap: &AdminCap, new_fee: u64) {}

    fun check_admin<T>(self: &FlashLender<T>, admin_cap: &AdminCap) {
        assert!(object::borrow_id(self) == &admin_cap.flash_lender_id, EAdminOnly);
    }


    /// Return the current fee for `self`
    public fun fee<T>(self: &FlashLender<T>): u64 {}

    /// returns max borrowable from `self`
    public fun max_loan<T>(self: &FlashLender<T>): u64 {}

    /// Return amount that `self` has to repay
    public fun repay_amount<T>(self: &Receipt<T>): u64 {}

    /// Return Id of `self`
    public fun flash_lender_id<T>(self: &Receipt<T>): ID {}
}