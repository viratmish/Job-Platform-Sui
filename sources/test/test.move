#[test_only]
module freelancer_platform::tests {
    use freelancer_platform::platform;
    use std::vector;
    use sui::test_scenario;

    #[test]
    fun test_create_freelancer() {
        let scenario = test_scenario::begin(&mut ctx());
        {
            let name = vector::utf8(b"John Doe");
            let skills = vector::empty<vector<u8>>();
            vector::push_back(&mut skills, vector::utf8(b"Web Development"));
            vector::push_back(&mut skills, vector::utf8(b"UI/UX Design"));
            let description = vector::utf8(b"Experienced web developer with expertise in React and Angular.");

            let freelancer = platform::create_freelancer(name, skills, description, &mut scenario.ctx);
            assert!(platform::get_freelancer(&freelancer).name == string::utf8(b"John Doe"), 0);
            assert!(vector::length(&platform::get_freelancer(&freelancer).skills) == 2, 1);
            assert!(platform::get_freelancer(&freelancer).profile_description == string::utf8(b"Experienced web developer with expertise in React and Angular."), 2);
        };
        test_scenario::end(scenario);
    }

    #[test]
    fun test_update_freelancer() {
        let scenario = test_scenario::begin(&mut ctx());
        {
            let name = vector::utf8(b"John Doe");
            let skills = vector::empty<vector<u8>>();
            vector::push_back(&mut skills, vector::utf8(b"Web Development"));
            let description = vector::utf8(b"Experienced web developer.");

            let freelancer = platform::create_freelancer(name, skills, description, &mut scenario.ctx);
            platform::update_freelancer_name(&mut freelancer, vector::utf8(b"Jane Smith"));
            platform::update_freelancer_skills(&mut freelancer, vector::empty<vector<u8>>());
            platform::update_freelancer_description(&mut freelancer, vector::utf8(b"UI/UX Designer"));

            assert!(platform::get_freelancer(&freelancer).name == string::utf8(b"Jane Smith"), 0);
            assert!(vector::is_empty(&platform::get_freelancer(&freelancer).skills), 1);
            assert!(platform::get_freelancer(&freelancer).profile_description == string::utf8(b"UI/UX Designer"), 2);
        };
        test_scenario::end(scenario);
    }

    #[test]
    fun test_delete_freelancer() {
        let scenario = test_scenario::begin(&mut ctx());
        {
            let name = vector::utf8(b"John Doe");
            let skills = vector::empty<vector<u8>>();
            let description = vector::utf8(b"Experienced web developer.");

            let freelancer = platform::create_freelancer(name, skills, description, &mut scenario.ctx);
            platform::delete_freelancer(freelancer);
            // Add assertions or additional tests as needed
        };
        test_scenario::end(scenario);
    }

    #[test]
    #[expected_failure(abort_code = sui::test_scenario::EK_UNWRAP_ERR)]
    fun test_get_deleted_freelancer() {
        let scenario = test_scenario::begin(&mut ctx());
        {
            let name = vector::utf8(b"John Doe");
            let skills = vector::empty<vector<u8>>();
            let description = vector::utf8(b"Experienced web developer.");

            let freelancer = platform::create_freelancer(name, skills, description, &mut scenario.ctx);
            platform::delete_freelancer(freelancer);
            // This line should fail since the freelancer object has been deleted
            let _ = platform::get_freelancer(&freelancer);
        };
        test_scenario::end(scenario);
    }

    #[test_only]
    fun ctx() : &mut test_scenario::Context {
        &mut test_scenario::begin(&sui::test_scenario::begin_for_addr(sui::addresses()))
    }
}