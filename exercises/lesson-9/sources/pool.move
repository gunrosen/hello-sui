/// A flash loan that works for any Coin type
module lesson9::flash_lender {
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};
    use sui::transfer;

    struct FlashLender<phantom T> has key {
        id: UID,
        /// borrowable amount
        to_lend: Balance<T>,
        fee: u64,
    }
    const DEFAULT_FEE_DIVISOR:u64 = 100;
    /// ERROR
    const EAdminOnly: u64 = 1;
     /// Allowed values are: [0-100)
    const EWrongFee: u64 = 2;
    const ELoanFundNotEnough: u64 = 3;
    const ERepayNotEnough:u64 = 4;
    const EWrongFlashLenderId: u64 = 5;
    const EInsufficientFund: u64 = 6;

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
    public fun new<T>(to_lend: Balance<T>, fee: u64, ctx: &mut TxContext): AdminCap {
        assert!(0 <= fee && fee <= 100, EWrongFee);
        let flash_lender = FlashLender {
            id: object::new(ctx),
            to_lend: to_lend,
            fee: fee, 
        };
        let flash_lender_id = object::id(&flash_lender);
        // let coin = coin::from_balance(to_lend, ctx);
        // transfer::transfer(coin, tx_context::sender(ctx));
        transfer::share_object(flash_lender);
        let admin_cap = AdminCap {
            id: object::new(ctx),
            flash_lender_id: flash_lender_id
        };
        admin_cap
    }

    /// The same with `new` function but transfer `AdminCap` to caller
    public entry fun create<T>(to_lend: Coin<T>, fee: u64, ctx: &mut TxContext) {
        assert!(0 <= fee && fee <= 100, EWrongFee);
        let balance = coin::into_balance(to_lend);

        let flash_lender = FlashLender {
            id: object::new(ctx),
            to_lend: balance,
            fee: fee, 
        };
         let flash_lender_id = object::id(&flash_lender);
        transfer::share_object(flash_lender);
        let admin_cap = AdminCap {
            id: object::new(ctx),
            flash_lender_id: flash_lender_id
        };
        transfer::transfer(admin_cap, tx_context::sender(ctx))
    }

   /// Request a loan with `amount`
   /// Make sure call `repay` to lender in current transaction
   /// Abort if `amount` higher than amount of `lender` 's borrowable amount
    public fun loan<T>(
        self: &mut FlashLender<T>, amount: u64, ctx: &mut TxContext
    ): (Coin<T>, Receipt<T>) {
        let to_lend = &mut self.to_lend;
        let lendable_amount = balance::value(to_lend);
        assert!(lendable_amount >= amount,ELoanFundNotEnough);
        let loan = coin::take(to_lend, amount, ctx);
        let loan_amount = coin::value(&loan);
        let repay_amount = loan_amount + loan_amount * self.fee / DEFAULT_FEE_DIVISOR;
        let receipt = Receipt{
            flash_lender_id: object::id(self),
            repay_amount
        };
        (loan, receipt)
    }

   /// Repay a loan from `receipt` to `lender` with `payment` amount
   /// Abort when repay amount invalid or `lender` is not `FlashLender`
    public fun repay<T>(self: &mut FlashLender<T>, payment: Coin<T>, receipt: Receipt<T>) {
        let Receipt{flash_lender_id, repay_amount} = receipt;
        assert!(coin::value(&payment) >= repay_amount, ERepayNotEnough); // More payment accepted as tips for lender
        assert!(object::id(self) == flash_lender_id, EWrongFlashLenderId);
        // update back to_lend
        coin::put(&mut self.to_lend, payment);
    }

    /// `self` withdrawal
    public fun withdraw<T>(self: &mut FlashLender<T>, admin_cap: &AdminCap, amount: u64, ctx: &mut TxContext): Coin<T> {
        check_admin(self, admin_cap);
        
        let to_lend = &mut self.to_lend;
        assert!(balance::value(to_lend) > amount, EInsufficientFund);
        coin::take(to_lend, amount, ctx)
    }

    // Only owner of `AdminCap` for `self` can deposit
    public entry fun deposit<T>(self: &mut FlashLender<T>, admin_cap: &AdminCap, coin: Coin<T>) {
        check_admin(self, admin_cap);
        let to_lend = &mut self.to_lend;
        coin::put(to_lend, coin);
    }

    /// Owner can update fee
    public entry fun update_fee<T>(self: &mut FlashLender<T>, admin_cap: &AdminCap, new_fee: u64) {
        check_admin(self, admin_cap);
        self.fee = new_fee;
    }

    fun check_admin<T>(self: &FlashLender<T>, admin_cap: &AdminCap) {
        assert!(object::borrow_id(self) == &admin_cap.flash_lender_id, EAdminOnly);
    }


    /// Return the current fee for `self`
    public fun fee<T>(self: &FlashLender<T>): u64 {
        self.fee
    }

    /// returns max borrowable from `self`
    public fun max_loan<T>(self: &FlashLender<T>): u64 {
        balance::value(&self.to_lend)
    }

    /// Return amount that `self` has to repay
    public fun repay_amount<T>(self: &Receipt<T>): u64 {
        self.repay_amount
    }

    /// Return Id of `self`
    public fun flash_lender_id<T>(self: &Receipt<T>): ID {
        self.flash_lender_id
    }
}