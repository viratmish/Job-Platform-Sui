# Freelancer Job Platform Smart Contract

This smart contract implements a freelancer platform on the Sui blockchain. It includes functionality to manage freelancers, clients, job postings, proposals, and projects.

## Overview

The Freelancer Platform smart contract allows users to:

- Create and manage freelancer profiles with skills and profile descriptions.
- Create and manage clients with contact information and company names.
- Create job postings with titles, descriptions, and budgets.
- Submit proposals for job postings and manage accepted proposals.
- Manage projects, including creating, tracking, and completing projects.

## Features

- **Freelancer Management:**
  - Create a new freelancer profile with details such as name, skills, and profile description.
  - Update the name, skills, or profile description of a freelancer.
  - Delete a freelancer profile.

- **Client Management:**
  - Create new client profiles with contact information and company details.

- **Job Postings:**
  - Create job postings with title, description, budget, and associated client.
  - Retrieve job postings by ID.

- **Proposals:**
  - Submit proposals for job postings, specifying the freelancer, job posting, proposal text, and proposed price.
  - Retrieve proposals by ID.

- **Projects:**
  - Create projects when a proposal is accepted, linking freelancers with job postings.
  - Complete projects to indicate successful delivery.

## Dependency

- This DApp relies on the Sui blockchain framework for its smart contract functionality.
- Ensure you have the Move compiler installed and configured to the appropriate framework (e.g., `framework/devnet` for Devnet or `framework/testnet` for Testnet).

```bash
Sui = { git = "https://github.com/MystenLabs/sui.git", subdir = "crates/sui-framework/packages/sui-framework", rev = "framework/devnet" }
```

## Installation and Deployment

Follow these steps to deploy and use the Freelancer Platform smart contract:

1. **Move Compiler Installation:**
   Ensure you have the Move compiler installed. Refer to the [Sui documentation](https://docs.sui.io/) for installation instructions.

2. **Compile the Smart Contract:**
   Configure the Sui dependency to match your chosen framework (`framework/devnet` or `framework/testnet`), then build the contract.

   ```bash
   sui move build
   ```

3. **Deployment:**
   Deploy the compiled smart contract to your chosen blockchain platform using the Sui command-line interface.

   ```bash
   sui client publish --gas-budget 100000000 --json
   ```

## Notes and Considerations

- **Gas Budget:** Ensure sufficient gas for operations such as creating, updating, or deleting objects in the Sui blockchain.
- **Error Handling:** Implement error handling for cases such as freelancer not found, job posting not found, etc.
- **Access Control:** Consider adding access control mechanisms to restrict certain operations to authorized users.
- **Event Emission:** Implement events to emit notifications for important actions, such as when a freelancer profile is created, or a project is completed.

## Additional Information

For further information on the Sui blockchain and the Move programming language, refer to the [Sui documentation](https://docs.sui.io/).

