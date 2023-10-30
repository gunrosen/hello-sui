module lession6::hero_game {
    use sui::object::{Self, UID, ID};
    use std::string::{Self, String};
    use sui::tx_context::{Self, TxContext};
    use std::option::{Self, Option};
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use sui::transfer;

    // Errors
    const ENotAdmin: u64 = 0;
    const EWonMonster: u64 = 1;

    // add ability
    struct Hero has key, store{
        id: UID,
        name: String,
        hp: u64,
        experience: u64,
        attack: u64,
        armor: Option<Armor>,
        sword: Option<Sword>,
        game_id: ID,
    }

    // add ability
    struct Sword has key, store{
        id: UID,
        attack: u64,
        strength: u64,
        game_id: ID,
    }

    // add ability
    struct Armor has key, store{
        id: UID, 
        defense: u64,
        game_id: ID,
    }

    // add ability
    struct Monster has key, store{
        id: UID,
        hp: u64,
        strength: u64,
        game_id: ID,
    }

    struct GameInfo has key{
        id: UID,
        admin: address
    }

    // init new game
    fun init(ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);
        // Immutable object, 
        transfer::transfer(
            GameInfo{
                id : object::new(ctx),
                admin: sender
        },
            sender
        );
    }

    // CREATION
    fun create_hero(game: &GameInfo, payment: Coin<SUI>, ctx: &mut TxContext) : Hero {
        let value = coin::value(&payment);
        let hero = Hero {
            id: object::new(ctx),
            name: string::utf8(b"hero"),
            hp: value,
            attack: value,
            experience: 0,
            armor:  option::none(),
            sword:  option::none(),
            game_id: get_game_id(game),
        };
        transfer::public_transfer(payment, game.admin);
        hero
    }
    fun create_sword(game: &GameInfo, payment: Coin<SUI>, ctx: &mut TxContext): Sword {
        let value = coin::value(&payment);
        let sword = Sword {
            id: object::new(ctx),
            attack: value,
            strength: value / 2,
            game_id: get_game_id(game),
        };
        transfer::public_transfer(payment, game.admin);
        sword
    } 
    fun create_armor(game: &GameInfo, payment: Coin<SUI>, ctx: &mut TxContext): Armor {
        let value = coin::value(&payment);
        let armor = Armor {
            id: object::new(ctx),
            defense: value / 3,
            game_id: get_game_id(game),
        };
        transfer::public_transfer(payment, game.admin);
        armor
    }

    // admin only: create monster, fight to hero
    fun create_monter(game: &GameInfo, hp: u64, strength: u64, ctx: &mut TxContext): Monster{
        assert!( tx_context::sender(ctx) == game.admin, ENotAdmin);
        let monster = Monster{
            id: object::new(ctx),
            hp,
            strength,
            game_id: get_game_id(game),
        };
        monster
    }

    // level up
    fun level_up_hero(hero: &mut Hero) {
        hero.hp = hero.hp + 10;
        hero.experience = hero.experience +1;
    }
    fun level_up_sword(sword: &mut Sword) {
        sword.attack = sword.attack + 10;
        sword.strength = sword.strength + 5;
    }
    fun level_up_armor(armor: &mut Armor) {
        armor.defense = armor.defense + 6;
    }

    // monster/hero fight
    // Check hp, strength of hero, monster
    // minus hp by attack strength, who lose HP first will be loser
    public entry fun attack_monster(game: &GameInfo, hero: &mut Hero, monster: Monster, ctx: &mut TxContext) {
        let Monster {id: monster_id, hp: monster_hp, strength: _, game_id: _} = monster;
        let hero_damage =  get_hero_damage(hero);
        while(monster_hp > hero_damage){
            monster_hp = monster_hp - hero_damage;
            assert!(hero_damage >= monster_hp, EWonMonster);
        };
        hero.hp = hero_damage;
        hero.experience = hero.experience + 1;

        if (option::is_some(&hero.sword)){
            level_up_sword(option::borrow_mut(&mut hero.sword))
        };
        object::delete(monster_id);
    }

    // HELPERS
    public fun get_game_id(game_info: &GameInfo) : ID {
        object::id(game_info)
    }
    public fun get_hero_damage(hero: &Hero): u64{
     if (hero.hp == 0) return 0;
        let sword_damage = if (option::is_some(&hero.sword)) {
            get_sword_damage(option::borrow(&hero.sword))
        } else {
            0
        };
        (hero.experience * hero.hp) + sword_damage
    }

    public fun get_sword_damage(sword: &Sword): u64 {
        sword.attack
    }

    public fun hero_strength(hero: &Hero): u64{
        let armor_strength = if (option::is_some(&hero.armor)){
            (option::borrow(&hero.armor)).defense
        } else 0;
        hero.experience * 10 + armor_strength
    }
}