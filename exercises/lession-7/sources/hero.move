module game_hero::hero {
    use sui::object::{Self, UID, ID};
    use std::string::{Self, String};
    use sui::tx_context::{Self, TxContext};
    use std::option::{Self, Option};
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use sui::transfer;
    use sui::event;

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

    const EWonMonster: u64 = 1;

    struct MonsterSlainEvent has copy, drop {
        slayer_address: address,
        hero: ID,
        monster: ID,
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
        assert!(object::id(game) == hero.game_id, 403);
        assert!(object::id(game) == monter.game_id, 403);
        let Monster { id: monster_id, strength: monster_strength, hp, game_id: _ } = monter;
        let hero_strength = hero_strength(hero);
        let hero_hp = hero.hp;
        let monster_hp = hp;
        while(monster_hp > hero_strength){
            monster_hp = monster_hp - hero_strength;
            assert!(hero_hp >= monster_strength, EWonMonster);
            hero_hp = hero_hp - monster_strength;
        };
        hero.hp = hero_hp;
        hero.experience = hero.experience + hp;
        hero.mana = hero.mana + 5;
        if (option::is_some(&hero.sword)) {
            level_up_sword(option::borrow_mut(&mut hero.sword), 1)
        };

        event::emit(MonsterSlainEvent {
            slayer_address: tx_context::sender(ctx),
            hero: object::uid_to_inner(&hero.id),
            monster: object::uid_to_inner(&monster_id),
            game_id: object::id(game)
        });
        object::delete(monster_id);
    }

    public entry fun p2p_play(game: &GameInfo, hero1: &mut Hero, hero2: &mut Hero, ctx: &TxContext) {

    }

    public fun up_level_hero(hero: &mut Hero) {
        hero.level = hero.level + 1
    }

    public fun hero_strength(hero: &Hero): u64 {
        if (hero.hp == 0) {
            return 0
        };

        let sword_strength = if (option::is_some(&hero.sword)) {
            sword_strength(option::borrow(&hero.sword))
        } else {
            0
        };
        (hero.experience * hero.hp) + sword_strength
    }

    fun level_up_sword(sword: &mut Sword, amount: u64) {
        // up power/strength for sword
         sword.strength = sword.strength + amount
    }

    public fun sword_strength(sword: &Sword): u64 {
        // calculator strength of sword follow magic + strength
        sword.magic + sword.strength
    }

    public fun heal(hero: &mut Hero, potion: Potion) {
        assert!(hero.game_id == potion.game_id, 403);
        // use the potion to heal
        let Potion{id, potency: potency, game_id: _} = potion;
        object::delete(id);
        hero.hp = hero.hp + potency;
    }

    public fun equip_sword(hero: &mut Hero, new_sword: Sword): Option<Sword> {
        // change another sword
         option::swap_or_fill(&mut hero.sword, new_sword)
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
        let sword = create_sword(game, payment, ctx);
        let hero = create_hero(game, sword, ctx);
        transfer::public_transfer(hero, tx_context::sender(ctx));
    }

    public fun create_hero(game: &GameInfo, sword: Sword, ctx: &mut TxContext): Hero {
        assert!(object::id(game) == sword.game_id, 403);
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
        let potency = coin::value(&payment) * 10;
        transfer::public_transfer(
            Potion { id: object::new(ctx), potency, game_id: object::id(game) },
            player
        );
        transfer::public_transfer(payment, game.admin)
    }

    // Admin function
    public entry fun send_monter(game: &GameInfo, admin: &mut GameAdmin, hp: u64, strength: u64, player: address, ctx: &mut TxContext) {
        // send monter to hero to attacks
        assert!(object::id(game) == admin.game_id, 403);
        admin.monster_created = admin.monster_created + 1;
        transfer::transfer(
            Monster { id: object::new(ctx), hp, strength, game_id: object::id(game)},
            player
        )
    }
}