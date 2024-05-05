module freelancer_platform::platform {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use std::string::{String};
    use std::vector::{Self, Vector};
    use sui::collection::{bag, Bag};

    // Struct representing a freelancer
    struct Freelancer has key, store {
        id: UID,
        name: String,
        skills: Set<String>, // Changed to Set to avoid duplicate skills
        profile_description: String,
    }

    // Struct representing a client
    struct Client has key, store {
        id: UID,
        name: String,
        contact_info: String,
        company: String,
    }

    // Struct representing a job posting
    struct JobPosting has key, store {
        id: UID,
        title: String,
        description: String,
        budget: u64,
        client: UID,
    }

    // Struct representing a proposal
    struct Proposal has key, store {
        id: UID,
        freelancer: UID,
        job_posting: UID,
        proposal_text: String,
        proposed_price: u64,
        is_selected: bool, // Added to track if the proposal is selected by the client
    }

    // Struct representing a project
    struct Project has key, store {
        id: UID,
        freelancer: UID,
        job_posting: UID,
        agreed_price: u64,
        is_completed: bool,
    }

    // Function to create a new freelancer profile
    public fun create_freelancer(name: String, skills: Set<String>, profile_description: String, ctx: &mut TxContext): Freelancer {
        Freelancer {
            id: object::new(ctx),
            name,
            skills,
            profile_description,
        }
    }

    // Function to get a freelancer by ID
    public fun get_freelancer(freelancer_id: UID): Freelancer {
        // Implement logic to retrieve freelancer from storage by ID
        // Return the freelancer
    }

    // Function to update a freelancer's name
    public fun update_freelancer_name(freelancer_id: UID, new_name: String) {
        // Implement logic to update freelancer's name in storage by ID
    }

    // Function to update a freelancer's skills
    public fun update_freelancer_skills(freelancer_id: UID, new_skills: Set<String>) {
        // Implement logic to update freelancer's skills in storage by ID
    }

    // Function to update a freelancer's profile description
    public fun update_freelancer_description(freelancer_id: UID, new_description: String) {
        // Implement logic to update freelancer's profile description in storage by ID
    }

    // Function to delete a freelancer
    public fun delete_freelancer(freelancer_id: UID) {
        // Implement logic to delete freelancer from storage by ID
    }

    // Function to create a new client profile
    public fun create_client(name: String, contact_info: String, company: String, ctx: &mut TxContext): Client {
        Client {
            id: object::new(ctx),
            name,
            contact_info,
            company,
        }
    }

    // Function for a client to post a new job
    public fun post_job(client_id: UID, title: String, description: String, budget: u64, ctx: &mut TxContext): JobPosting {
        JobPosting {
            id: object::new(ctx),
            title,
            description,
            budget,
            client: client_id,
        }
    }

    // Function for a freelancer to submit a proposal
    public fun submit_proposal(freelancer_id: UID, job_posting_id: UID, proposal_text: String, proposed_price: u64, ctx: &mut TxContext): Proposal {
        Proposal {
            id: object::new(ctx),
            freelancer: freelancer_id,
            job_posting: job_posting_id,
            proposal_text,
            proposed_price,
            is_selected: false, // Initially not selected by the client
        }
    }

    // Function for a client to select a proposal
    public fun select_proposal(client
