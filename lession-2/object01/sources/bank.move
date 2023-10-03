// object01 is address
// HULK is name of name of module
module object01::HULK {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    struct Bank has key{
        id: UID,
        name: vector<u8>,
        balance: u128,
        accounts: vector<Account>
    }

    struct Account has key, store {
        id: UID,
        name: vector<u8>,
        balance: u128,
    }

    // private function
    fun init(ctx: &mut TxContext){ 
        let bank = create_bank(ctx);
        transfer::transfer(bank,tx_context::sender(ctx));
    }

    public fun create_bank(ctx: &mut TxContext) :Bank {
        Bank{
            id: object::new(ctx),
            name: b"hulk_account",
            balance: 1_000_000,
            accounts : vector[],
        };
    }

    public entry fun initAccount(ctx: &mut TxContext){
        let account = Bank{
            id: object::new(ctx),
            name: b"hulk_account",
            balance: 1_000_000,
        };

    }
}