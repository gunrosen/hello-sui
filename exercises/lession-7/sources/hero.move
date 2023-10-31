module game_hero::hero {
     use sui::object::{Self, UID, ID};
    use std::string::{Self, String};
    use sui::tx_context::{Self, TxContext};
    use std::option::{Self, Option};
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use sui::transfer;

    struct Hero has key, store {
        id: UID,
        hp: u64,
        mana: u64,
        level: u8,
        experience: u64,
        sword: Option<Sword>,
        game_id: ID,
    }

    struct Sword has key, store {
        id: UID,
        magic: u64,
        strength: u64,
        game_id: ID,
    }

    struct Potion has key, store {
        id: UID,
        potency: u64,
        game_id: ID,
    }

    struct Armor has key,store {
        id: UID,
        guard: u64,
        game_id: ID,
    }

    struct Monster has key {
        id: UID,
        hp: u64,
        strength: u64,
        game_id: ID,
    }

    struct GameInfo has key {
        id: UID,
        admin: address
    }

    struct GameAdmin has key {
        id: UID,
        monster_created: u64,
        potions_created: u64,
        game_id: ID,
    }

    struct MonsterSlainEvent has copy, drop {
        slayer_address: address,
        hero: ID,
        monter: ID,
        game_id: ID,
    }

    #[allow(unused_function)]
    fun init(ctx: &mut TxContext) {
        // Create a new game with Info & Admin
        let game_info = GameInfo {
            id: object::new(ctx),
            admin: tx_context::sender(ctx),
        };
        let game_admin = GameAdmin {
            id : object::new(ctx),
            monster_created: 0,
            potions_created:0,
            game_id : object::id(&game_info),
        };
        
        transfer::freeze_object(game_info);

        transfer::transfer(
            game_admin,
            tx_context::sender(ctx),
        );
    }

    // --- Gameplay ---
    public entry fun attack(game: &GameInfo, hero: &mut Hero, monter: Monster, ctx: &TxContext) {
        /// Completed this code to hero can attack Monter
        /// after attack, if success hero will up_level hero, up_level_sword and up_level_armor.
    }

    public entry fun p2p_play(game: &GameInfo, hero1: &mut Hero, hero2: &mut Hero, ctx: &TxContext) {

    }

    public fun up_level_hero(hero: &Hero): u64 {
        // calculator strength
    }

    public fun hero_strength(hero: &Hero): u64 {
        hero.strength
    }

    fun level_up_sword(sword: &mut Sword, amount: u64) {
        // up power/strength for sword
    }

    public fun sword_strength(sword: &Sword): u64 {
        // calculator strength of sword follow magic + strength
        sword.magic + sword.strength
    }

    public fun heal(hero: &mut Hero, potion: Potion) {
        // use the potion to heal
        let Potion{id: id, potency: potency, game_id: _} = potion;
        object::delete(id);
        hero.hp = hero.hp + potency;
    }

    public fun equip_sword(hero: &mut Hero, new_sword: Sword): Option<Sword> {
        // change another sword
    }

    // --- Object creation ---
    public fun create_sword(game: &GameInfo, payment: Coin<SUI>, ctx: &mut TxContext): Sword {
        // Create a sword, streight depends on payment amount
        let value = coin::value(&payment);
        let sword = Sword {
            id: object::new(ctx),
            magic: 0,
            strength: value,
            game_id: object::id(game),
        };
        transfer::public_transfer(payment, game.admin);
        sword
    }

    public entry fun acquire_hero(
        game: &GameInfo, payment: Coin<SUI>, ctx: &mut TxContext
    ) {
        // call function create_armor
        // call function create_sword
        // call function create_hero
    }

    public fun create_hero(game: &GameInfo, sword: Sword, ctx: &mut TxContext): Hero {
        let hero = Hero {
            id: object::new(ctx),
            mana: 0,
            experience: 0,
            hp: 100,
            level: 0,
            game_id: object::id(game),
            sword: option::some(sword),
        };

        hero
    }

    public entry fun send_potion(game: &GameInfo, payment: Coin<SUI>, player: address, ctx: &mut TxContext) {
        // send potion to hero, so that hero can healing
    }

    public entry fun send_monter(game: &GameInfo, admin: &mut GameAdmin, hp: u64, strength: u64, player: address, ctx: &mut TxContext) {
        // send monter to hero to attacks
    }
}