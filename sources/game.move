module freelancer_platform::platform {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use std::string::{String, str};
    use std::vector::{Self, Vector};
    use sui::collection::{bag, Bag};

    // Struct representing a freelancer
    struct Freelancer has key, store {
        id: UID,
        name: String,
        skills: Vector<String>,
        profile_description: String,
    }

    // Function to create a new freelancer profile
    public fun create_freelancer(name: String, skills: Vector<String>, profile_description: String, ctx: &mut TxContext): Freelancer {
        Freelancer {
            id: object::new(ctx),
            name,
            skills,
            profile_description,
        }
    }

    // Function to get a freelancer by ID
    public fun get_freelancer(freelancer: &Freelancer): &Freelancer {
        freelancer
    }

    // Function to update a freelancer's name
    public fun update_freelancer_name(freelancer: &mut Freelancer, new_name: String) {
        freelancer.name = new_name;
    }

    // Function to update a freelancer's skills
    public fun update_freelancer_skills(freelancer: &mut Freelancer, new_skills: Vector<String>) {
        freelancer.skills = new_skills;
    }

    // Function to update a freelancer's profile description
    public fun update_freelancer_description(freelancer: &mut Freelancer, new_description: String) {
        freelancer.profile_description = new_description;
    }

    // Function to delete a freelancer
    public fun delete_freelancer(freelancer: Freelancer) {
        object::delete(freelancer.id);
    }

    // Additional CRUD functions for other components
    public fun create_client(name: String, contact_info: String, company: String, ctx: &mut TxContext): Client {
        Client {
            id: object::new(ctx),
            name,
            contact_info,
            company,
        }
    }

    public fun create_job_posting(title: String, description: String, budget: u64, client: UID, ctx: &mut TxContext): JobPosting {
        JobPosting {
            id: object::new(ctx),
            title,
            description,
            budget,
            client,
        }
    }

    public fun create_proposal(freelancer: UID, job_posting: UID, proposal_text: String, proposed_price: u64, ctx: &mut TxContext): Proposal {
        Proposal {
            id: object::new(ctx),
            freelancer,
            job_posting,
            proposal_text,
            proposed_price,
        }
    }

    public fun create_project(freelancer: UID, job_posting: UID, agreed_price: u64, ctx: &mut TxContext): Project {
        Project {
            id: object::new(ctx),
            freelancer,
            job_posting,
            agreed_price,
            is_completed: false,
        }
    }

    public fun complete_project(project: &mut Project) {
        project.is_completed = true;
    }
}
