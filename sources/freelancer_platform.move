module freelancer_platform::platform {
    use std::string::{String, utf8};
    use std::vector;
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    /// Struct representing a freelancer
    struct Freelancer has key, store {
        id: UID,
        name: String,
        skills: vector<String>,
        profile_description: String,
    }

    /// Struct representing a client
    struct Client has key, store {
        id: UID,
        name: String,
        contact_info: String,
        company: String,
    }

    /// Struct representing a job posting
    struct JobPosting has key, store {
        id: UID,
        title: String,
        description: String,
        budget: u64,
        client: UID,
    }

    /// Struct representing a proposal
    struct Proposal has key, store {
        id: UID,
        freelancer: UID,
        job_posting: UID,
        proposal_text: String,
        proposed_price: u64,
    }

    /// Struct representing a project
    struct Project has key, store {
        id: UID,
        freelancer: UID,
        job_posting: UID,
        agreed_price: u64,
        is_completed: bool,
    }

    /// Function to create a new freelancer profile
    public fun create_freelancer(name: vector<u8>, skills: vector<vector<u8>>, profile_description: vector<u8>, ctx: &mut TxContext): Freelancer {
        let name_str = utf8::bytes_to_string(name);
        let skills_str = vector::map(&skills, |skill| utf8::bytes_to_string(skill));
        let profile_description_str = utf8::bytes_to_string(profile_description);

        Freelancer {
            id: object::new(ctx),
            name: name_str,
            skills: skills_str,
            profile_description: profile_description_str,
        }
    }

    /// Function to get a freelancer by ID
    public fun get_freelancer(freelancer: &Freelancer): &Freelancer {
        freelancer
    }

    /// Function to update a freelancer's name
    public fun update_freelancer_name(freelancer: &mut Freelancer, new_name: vector<u8>) {
        freelancer.name = utf8::bytes_to_string(new_name);
    }

    /// Function to update a freelancer's skills
    public fun update_freelancer_skills(freelancer: &mut Freelancer, new_skills: vector<vector<u8>>) {
        freelancer.skills = vector::map(&new_skills, |skill| utf8::bytes_to_string(skill));
    }

    /// Function to update a freelancer's profile description
    public fun update_freelancer_description(freelancer: &mut Freelancer, new_description: vector<u8>) {
        freelancer.profile_description = utf8::bytes_to_string(new_description);
    }

    /// Function to delete a freelancer
    public fun delete_freelancer(freelancer: Freelancer) {
        object::delete(freelancer.id);
    }

    /// Function to create a new client
    public fun create_client(name: vector<u8>, contact_info: vector<u8>, company: vector<u8>, ctx: &mut TxContext): Client {
        Client {
            id: object::new(ctx),
            name: utf8::bytes_to_string(name),
            contact_info: utf8::bytes_to_string(contact_info),
            company: utf8::bytes_to_string(company),
        }
    }

    /// Function to create a new job posting
    public fun create_job_posting(title: vector<u8>, description: vector<u8>, budget: u64, client: &Client, ctx: &mut TxContext): JobPosting {
        JobPosting {
            id: object::new(ctx),
            title: utf8::bytes_to_string(title),
            description: utf8::bytes_to_string(description),
            budget,
            client: object::uid_to_inner(&client.id),
        }
    }

    /// Function to create a new proposal
    public fun create_proposal(freelancer: &Freelancer, job_posting: &JobPosting, proposal_text: vector<u8>, proposed_price: u64, ctx: &mut TxContext): Proposal {
        Proposal {
            id: object::new(ctx),
            freelancer: object::uid_to_inner(&freelancer.id),
            job_posting: object::uid_to_inner(&job_posting.id),
            proposal_text: utf8::bytes_to_string(proposal_text),
            proposed_price,
        }
    }

    /// Function to create a new project
    public fun create_project(freelancer: &Freelancer, job_posting: &JobPosting, agreed_price: u64, ctx: &mut TxContext): Project {
        Project {
            id: object::new(ctx),
            freelancer: object::uid_to_inner(&freelancer.id),
            job_posting: object::uid_to_inner(&job_posting.id),
            agreed_price,
            is_completed: false,
        }
    }

    /// Function to complete a project
    public fun complete_project(project: &mut Project) {
        project.is_completed = true;
    }

    /// Function to get a client by ID
    public fun get_client(client: &Client): &Client {
        client
    }

    /// Function to get a job posting by ID
    public fun get_job_posting(job_posting: &JobPosting): &JobPosting {
        job_posting
    }

    /// Function to get a proposal by ID
    public fun get_proposal(proposal: &Proposal): &Proposal {
        proposal
    }

    /// Function to get a project by ID
    public fun get_project(project: &Project): &Project {
        project
    }
}