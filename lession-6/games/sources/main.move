module games::hulk_game {
    use std::string::{Self, String};
    use std::option::{Self, Option};
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use sui::event::{Self};

    const ERROR: u64 = 0;
    const ERROR_MONSTER_WON: u64 = 1;

    struct Hero has key, store {
        id: UID,
        name: String,
        hp: u64,
        experience: u64,
        armor: Option<Armor>,
        sword: Option<Sword>,
        game_id: ID,
    }

    struct Armor has key, store {
        id: UID,
        durability: u64,
        game_id: ID,
    }

    struct Sword has key, store {
        id: UID,
        damage: u64,
        speed: u64,
        game_id: ID,
    }

    struct GameInfo has key {
        id: UID,
        admin: address
    }

    struct GameAdmin has key {
        id: UID,
        game_id: ID,
        heros: u64,
        monsters: u64,
    }

    struct Monster has key, store {
        id: UID,
        hp: u64,
        game_id: ID,
    }

    struct EventAttack has copy, drop{
        attacker: address,
        hero: ID,
        monster: ID,
        game_id: ID,
    }

    fun init(ctx: &mut TxContext){
        new_game(ctx);
    }

    fun new_game(ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);
        let id = object::new(ctx);
        let game_id = object::uid_to_inner(&id);

        // Immutable object, 
        transfer::freeze_object(
            GameInfo{
                id,
                admin: sender
        });

        transfer::transfer(
            GameAdmin {
                id: object::new(ctx),
                game_id: game_id,
                heros: 0,
                monsters: 0,
            },
            sender
        );
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

    public fun get_sword_damage(sword: &Sword): u64{
        sword.damage + sword.speed
    }



    public fun create_sword(game: &GameInfo, payment: Coin<SUI>, ctx: &mut TxContext): Sword{
        let value = coin::value(&payment);
        assert!(value >=1,  ERROR);

        let damage = (value * 2);
        let speed = (value  * 3);

        // Transfer coin from buyer to admin
        transfer::public_transfer(payment, game.admin);

        Sword {
            id: object::new(ctx),
            damage,
            speed,
            game_id: get_game_id(game) 
        }
    }

        public fun create_armor(game: &GameInfo, payment: Coin<SUI>, ctx: &mut TxContext): Armor{
        let value = coin::value(&payment);
        assert!(value >=1,  ERROR);

        let durability = value * 2;

        // Transfer coin from buyer to admin
        transfer::public_transfer(payment, game.admin);

        Armor {
            id: object::new(ctx),
            durability,
            game_id: get_game_id(game) 
        }
    }

    public fun create_hero(game: &GameInfo, name: String, sword: Sword, armor: Armor, ctx: &mut TxContext): Hero {
        Hero {
            id: object::new(ctx),
            name,
            hp: 100,
            experience: 0,
            sword: option::some(sword),
            armor: option::some(armor),
            game_id: get_game_id(game),
        }
    }
    
    // Admin creates monster
    public entry fun create_monster(admin: &mut GameAdmin, game: &GameInfo, hp: u64, player: address,ctx: &mut TxContext) {
        admin.monsters = admin.monsters + 1;
        transfer::transfer(
            Monster{
                id: object::new(ctx),
                hp, 
                game_id: get_game_id(game)
            },
            player
        );
    }

    fun level_up_sword(sword: &mut Sword, amount: u64){
        sword.damage + amount;
    }

       fun level_up_armor(armor: &mut Armor, amount: u64){
        armor.durability + amount;
    }



    public fun get_game_id(game_info: &GameInfo) : ID {
        object::id(game_info)
    }

    public entry fun attack(game: &GameInfo, hero: &mut Hero, monster: Monster, ctx: &mut TxContext){
        let Monster {id: monster_id, hp: monster_hp, game_id: _} = monster;
        let hero_damage =  get_hero_damage(hero);

        while(monster_hp > hero_damage){
            monster_hp = monster_hp - hero_damage;
            assert!(hero_damage >= monster_hp, ERROR_MONSTER_WON);
            hero_damage = hero_damage - monster_hp;
        };
        hero.hp = hero_damage;
        hero.experience = hero.experience + 1;

        if (option::is_some(&hero.sword)){
            level_up_sword(option::borrow_mut(&mut hero.sword), 2)
        };
       
        event::emit(EventAttack{
            attacker: tx_context::sender(ctx),
            hero: object::uid_to_inner(&hero.id),
            monster:  object::uid_to_inner(&monster_id),
            game_id: get_game_id(game)
        });
         object::delete(monster_id);
    }
}