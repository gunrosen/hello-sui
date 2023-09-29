module basic::DEMO {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    struct Wallet has key {
        id : UID,
        balance: u128,
        name: vector<u8>
    }


    fun init(ctx: &mut TxContext){
        let wallet = Wallet {
            id: object::new(ctx),
            balance: 1_000_000_000,
            name: b"hulk19",
        };
        // Transfer ownership of wallet to sender (who call is function)
        transfer::transfer(wallet, tx_context::sender(ctx));
    }


    public entry fun create_wallet(ctx: &mut TxContext){
        let wallet = Wallet {
            id: object::new(ctx),
            balance: 1_000_000_000,
            name: b"hulk19",
        };
        // Transfer ownership of wallet to sender (who call is function)
        transfer::transfer(wallet, tx_context::sender(ctx));
    }

    // public, private, public entry, friend (object model access)


    public entry fun change_balance(wallet: &mut Wallet){
        let subtractAmount: u128 = 500_000_000;
        wallet.balance = wallet.balance - subtractAmount;
    }

}