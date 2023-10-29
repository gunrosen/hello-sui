module lesson6::hero_game {
    // add ability
    struct Hero {
        id: UID,
        name: String,
        hp: u64,
        experience: u64,
    }

    // add ability
    struct Sword {
        id: UID,
        attack: u64,
        strenght: u64,
    }

    // add ability
    struct Armor {
        id: UID,
        defense: u64,
    }

    // add ability
    struct Monter {
        id: UID,
        hp: u64,
        strenght: u64,
    }

    struct GameInfo {
        id: UID,
        admin: address
    }

    // init new game
    fun init(ctx: &mut TxContext) {

    }

    // CREATION
    fun create_hero() {}
    fun create_sword() {}
    fun create_armor() {}

    // admin only: create monster, fight to hero
    fun create_monter() {}

    // level up
    fun level_up_hero() {}
    fun level_up_sword() {}
    fun level_up_armor() {}

    // monster/hero fight
    // Check hp, strength of hero, monster
    // minus hp by attack strength, who lose HP first will be loser
    public entry fun attack_monter() {}
}