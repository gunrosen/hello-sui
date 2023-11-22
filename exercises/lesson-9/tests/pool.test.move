module lesson9::pool_test {

    #[test]
    fun test_flash_loan() {
        use sui::coin::{Self};
        use sui::test_scenario;


        let admin = @0xAD111;
        let player = @0x113;

        let scenario_val = test_scenario::begin(admin);
        let scenario = &mut scenario_val;

        test_scenario::next_tx(scenario, admin);
        {
           
        };

        test_scenario::next_tx(scenario, player);
        {
            
        };



        test_scenario::end(scenario_val);
    }
}