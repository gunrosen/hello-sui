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

    // has store, can store in other object
    struct Account has key, store {
        id: UID,
        name: vector<u8>,
        balance: u128,
    }

    struct Pool has key {
        id: UID,
        balance: u128,
    }

    // private function
    fun init(ctx: &mut TxContext){ 
        let bank = create_bank(ctx);
        let pool = Pool {
            id: object::new(ctx),
            balance: 0,
        };
        
        let pool2 = Pool {
            id: object::new(ctx),
            balance: 0,
        };

        transfer::share_object(pool);
        transfer::freeze_object(pool2);  // Immutable object: VD: NFT
        transfer::transfer(bank,tx_context::sender(ctx));
    }

    public fun create_bank(ctx: &mut TxContext): Bank {
        Bank{
            id: object::new(ctx),
            name: b"HULK BANK",
            balance: 1_000_000_000_000,
            accounts : vector[],
        }
    }
    // Pass ObjectId of Bank
    // Sender should be owner of Bank
    public entry fun create_account(_: &Bank, name: vector<u8>,ctx: &mut TxContext){
        let account = Account{
            id: object::new(ctx),
            name,
            balance: 0,
        };
        transfer::transfer(account,tx_context::sender(ctx));
    }

    public entry fun delete_account(account : Account){
        let Account{id, name: _, balance: _} = account;
        object::delete(id);
    }

    public entry fun increase_balance(account : &mut Account, amount: u128){
        account.balance + amount;
    }

 

    // READ
    public entry fun view_balance(account: &Account):u128 {
        account.balance
    }
}