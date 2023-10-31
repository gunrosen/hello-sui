module game_hero::hero_test {

    #[test]
    fun test_slay_monter() {
        // - create hero
        // - create monter
        // - slay
        use sui::coin::{Self};
        use sui::test_scenario;
        use game_hero::hero::{Self, GameInfo, GameAdmin, Hero, Monster};

        let admin = @0xAD111;
        let player = @0x113;

        let scenario_val = test_scenario::begin(admin);
        let scenario = &mut scenario_val;

        test_scenario::next_tx(scenario, admin);
        {
            hero::init_game(test_scenario::ctx(scenario));
        };

        test_scenario::next_tx(scenario, player);
        {
            let game = test_scenario::take_immutable<GameInfo>(scenario);
            let game_ref = &game;
            let coin = coin::mint_for_testing(500, test_scenario::ctx(scenario));
            hero::acquire_hero(game_ref, coin, test_scenario::ctx(scenario));
            test_scenario::return_immutable(game);
        };

         test_scenario::next_tx(scenario, admin);
        {
            let game = test_scenario::take_immutable<GameInfo>(scenario);
            let game_ref = &game;
            let admin_cap = test_scenario::take_from_sender<GameAdmin>(scenario);
            hero::send_monster(game_ref, &mut admin_cap, 10, 10, player, test_scenario::ctx(scenario));
            test_scenario::return_to_sender(scenario, admin_cap);
            test_scenario::return_immutable(game);
        };

         test_scenario::next_tx(scenario, player);
        {
            let game = test_scenario::take_immutable<GameInfo>(scenario);
            let game_ref = &game;
            let hero = test_scenario::take_from_sender<Hero>(scenario);
            let monster = test_scenario::take_from_sender<Monster>(scenario);
            hero::attack(game_ref, &mut hero, monster, test_scenario::ctx(scenario));
            test_scenario::return_to_sender(scenario, hero);
            test_scenario::return_immutable(game);
        };

        test_scenario::end(scenario_val);
    }

    #[test]
    fun test_slay_sea_monter() {
        // - create hero
        // - create sea monter
        // - slay
        use sui::coin::{Self};
        use sui::test_scenario;
        use game_hero::sea_hero::{Self, SeaHeroAdmin, SeaMonster};
        use game_hero::hero::{Self, GameInfo, Hero};
        use sui::balance;

        let admin = @0xAD111;
        let player = @0x113;

        let scenario_val = test_scenario::begin(admin);
        let scenario = &mut scenario_val;

        test_scenario::next_tx(scenario, admin);
        {
            sea_hero::init_game(test_scenario::ctx(scenario));

        };

        test_scenario::next_tx(scenario, player);
        {
            let game = test_scenario::take_immutable<GameInfo>(scenario);
            let game_ref = &game;
            let coin = coin::mint_for_testing(500, test_scenario::ctx(scenario));
            hero::acquire_hero(game_ref, coin, test_scenario::ctx(scenario));
            test_scenario::return_immutable(game);
        };

        test_scenario::next_tx(scenario, admin);
        {
            let game = test_scenario::take_immutable<GameInfo>(scenario);
            let admin_cap = test_scenario::take_from_sender<SeaHeroAdmin>(scenario);
            sea_hero::create_sea_monster(&mut admin_cap, 10, player, test_scenario::ctx(scenario));
            test_scenario::return_to_sender(scenario, admin_cap);
            test_scenario::return_immutable(game);
        };
        
         test_scenario::next_tx(scenario, player);
        {
            let game = test_scenario::take_immutable<GameInfo>(scenario);
            let hero = test_scenario::take_from_sender<Hero>(scenario);
            let monster = test_scenario::take_from_sender<SeaMonster>(scenario);
            let reward = sea_hero::monster_reward(&monster);
            let monster_reward = sea_hero::slay(&mut hero, monster);
            assert!(balance::value(&monster_reward) == reward, 1);

            test_scenario::return_to_sender(scenario, hero);
            // test_scenario::return_to_sender(scenario, monster_reward);
            test_scenario::return_immutable(game);
        };
        test_scenario::end(scenario_val);

    }

    #[test]
    fun test_hero_helper_slay() {
        // - create hero
        // - create hero 2
        // - create sea monter
        // - create help
        // - slay
        use sui::coin::{Self, Coin};
        use sui::test_scenario;
        use game_hero::sea_hero::{Self, SeaHeroAdmin, SeaMonster, VBI_TOKEN};
        use game_hero::hero::{Self, GameInfo, Hero};
        use game_hero::sea_hero_helper::{Self, HelpMeSlayThisMonster};

        let admin = @0xAD111;
        let player = @0x113;

        let scenario_val = test_scenario::begin(admin);
        let scenario = &mut scenario_val;

        test_scenario::next_tx(scenario, admin);
        {
            sea_hero::init_game(test_scenario::ctx(scenario));

        };

        test_scenario::next_tx(scenario, player);
        {
            let game = test_scenario::take_immutable<GameInfo>(scenario);
            let game_ref = &game;
            let coin = coin::mint_for_testing(500, test_scenario::ctx(scenario));
            hero::acquire_hero(game_ref, coin, test_scenario::ctx(scenario));
            test_scenario::return_immutable(game);
        };

        test_scenario::next_tx(scenario, admin);
        {
            let game = test_scenario::take_immutable<GameInfo>(scenario);
            let admin_cap = test_scenario::take_from_sender<SeaHeroAdmin>(scenario);
            sea_hero::create_sea_monster(&mut admin_cap, 10, player, test_scenario::ctx(scenario));

            test_scenario::return_to_sender(scenario, admin_cap);
            test_scenario::return_immutable(game);
        };

        test_scenario::next_tx(scenario, player);
        {
            let hero = test_scenario::take_from_sender<Hero>(scenario);
            let hero_ref = &hero;
            let sea_monster = test_scenario::take_from_sender<SeaMonster>(scenario);
            sea_hero_helper::create_help(sea_monster, 100, player, test_scenario::ctx(scenario));
            let helper_wrapper = test_scenario::take_from_sender<HelpMeSlayThisMonster>(scenario);
            let coin: Coin<VBI_TOKEN> = sea_hero_helper::attack(hero_ref, helper_wrapper, test_scenario::ctx(scenario));
            test_scenario::return_to_sender<Hero>(scenario,hero);
            test_scenario::return_to_sender(scenario, coin);
         
        };

        test_scenario::end(scenario_val);
    }

    #[test]
    fun test_hero_attack_hero() {
        // - create hero
        // - create hero 2
        // - slay 1 vs 2
        // check who will win
 use sui::coin::{Self};
        use sui::test_scenario;
        use game_hero::hero::{Self, GameInfo, Hero};

        let admin = @0xAD111;
        let player = @0x113;

        let scenario_val = test_scenario::begin(admin);
        let scenario = &mut scenario_val;

        test_scenario::next_tx(scenario, admin);
        {
            hero::init_game(test_scenario::ctx(scenario));
        };

        test_scenario::next_tx(scenario, player);
        {
            let game = test_scenario::take_immutable<GameInfo>(scenario);
            let game_ref = &game;
            let coin = coin::mint_for_testing(500, test_scenario::ctx(scenario));
            hero::acquire_hero(game_ref, coin, test_scenario::ctx(scenario));

            let coin_2 = coin::mint_for_testing(100, test_scenario::ctx(scenario));
            hero::acquire_hero(game_ref, coin_2, test_scenario::ctx(scenario));

            let hero1 =  test_scenario::take_from_sender<Hero>(scenario);
            let hero2 =  test_scenario::take_from_sender<Hero>(scenario);

            let hero1_ref_mut = &mut hero1;
            let hero2_ref_mut = &mut hero2;

            hero::p2p_play(game_ref, hero1_ref_mut, hero2_ref_mut,test_scenario::ctx(scenario));

            test_scenario::return_to_sender<Hero>(scenario,hero1);
            test_scenario::return_to_sender<Hero>(scenario,hero2);
            test_scenario::return_immutable(game);
        };


        test_scenario::end(scenario_val);
    }
}