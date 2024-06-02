# JobPlatform Module README

## Overview

The JobPlatform module is a blockchain-based platform that enables developers to create and manage their professional profiles, referred to as DevCards. Users can create, update, and manage their DevCards, which include information such as their name, title, years of experience, technologies they work with, and contact information. DevCards can also include optional descriptions and portfolio links.

## Module Components

### Constants

- ERROR_NOT_THE_OWNER: u64 = 0 - Error code for unauthorized actions.
- ERROR_INSUFFICENT_FUNDS: u64 = 1 - Error code for insufficient funds during transactions.
- ERROR_MIN_CARD_COST: u64 = 2 - Error code for the minimum cost requirement for creating a card.

### Structures

1. *DevCard*
   - Attributes:
     - id: UID
     - name: String
     - owner: address
     - title: String
     - img_url: Url
     - description: Option<String>
     - years_of_experience: u8
     - technologies: String
     - portfolio: Option<String>
     - contact: String
     - open_to_work: bool

2. *DevCardCap*
   - Attributes:
     - id: UID
     - card: ID

3. *DevHub*
   - Attributes:
     - id: UID
     - owner: address
     - counter: u64
     - cards: ObjectTable<address, DevCard>

4. *DevHubCap*
   - Attributes:
     - id: UID
     - to: ID

5. *Events*
   - *CardCreated*
     - Attributes:
       - id: ID
       - name: String
       - owner: address
       - title: String
       - contact: String
   - *DescriptionUpdated*
     - Attributes:
       - name: String
       - owner: address
       - new_description: String
   - *PortfolioUpdated*
     - Attributes:
       - name: String
       - owner: address
       - new_portfolio: String

### Functions

1. *init*
   - Initializes the DevHub and assigns the initial owner.

2. *create_card*
   - Creates a new DevCard.
   - Parameters:
     - devhub: &mut DevHub
     - name: String
     - title: String
     - img_url: vector<u8>
     - years_of_experience: u8
     - technologies: String
     - contact: String
     - payment: Coin<SUI>
     - ctx: &mut TxContext
   - Returns:
     - DevCardCap

3. *update_card_description*
   - Updates the description of a DevCard.
   - Parameters:
     - cap: &DevCardCap
     - devhub: &mut DevHub
     - new_description: String
     - ctx: &mut TxContext

4. *update_portfolio*
   - Updates the portfolio link of a DevCard.
   - Parameters:
     - cap: &DevCardCap
     - devhub: &mut DevHub
     - new_portfolio: String
     - ctx: &mut TxContext

5. *deactive_card*
   - Deactivates a DevCard, setting open_to_work to false.
   - Parameters:
     - cap: &DevCardCap
     - devhub: &mut DevHub
     - ctx: &mut TxContext

6. *remove*
   - Removes a DevCard from the DevHub.
   - Parameters:
     - cap: &DevCardCap
     - devhub: &mut DevHub
     - ctx: &mut TxContext

7. *get_card_info*
   - Retrieves information about a DevCard.
   - Parameters:
     - devhub: &DevHub
     - ctx: &mut TxContext
   - Returns:
     - `(
          String,
          address,
          String,
          Url,
          Option<String>,
          u8,
          String,
          Option<String>,
          String,
          bool,
       )`

## Dependency

- This DApp relies on the Sui blockchain framework for its smart contract functionality.
- Ensure you have the Move compiler installed and configured to the appropriate framework (e.g., framework/devnet for Devnet or framework/testnet for Testnet).

toml
Sui = { git = "https://github.com/MystenLabs/sui.git", subdir = "crates/sui-framework/packages/sui-framework", rev = "framework/devnet" }


## Installation and Deployment

Follow these steps to deploy and use the Freelancer Platform smart contract:

1. *Move Compiler Installation:*
   Ensure you have the Move compiler installed. Refer to the [Sui documentation](https://docs.sui.io/) for installation instructions.

2. *Compile the Smart Contract:*
   Configure the Sui dependency to match your chosen framework (framework/devnet or framework/testnet), then build the contract.

   bash
   sui move build
   

3. *Deployment:*
   Deploy the compiled smart contract to your chosen blockchain platform using the Sui command-line interface.

   bash
   sui client publish --gas-budget 100000000 --json
   

## Usage

### Initial Setup

1. Initialize the DevHub by calling the init function.

### Managing DevCards

1. *Creating a DevCard:*
   - Call the create_card function with the required parameters.
   - Ensure that the payment amount meets the minimum card cost requirement.

2. *Updating a DevCard Description:*
   - Call the update_card_description function with the new description.

3. *Updating a DevCard Portfolio:*
   - Call the update_portfolio function with the new portfolio link.

4. *Deactivating a DevCard:*
   - Call the deactive_card function to mark the card as not open to work.

5. *Removing a DevCard:*
   - Call the remove function to delete the card from the DevHub.

6. *Retrieving DevCard Information:*
   - Call the get_card_info function to obtain details about a DevCard.

## Error Handling

- Ensure to handle the specific error codes ERROR_NOT_THE_OWNER, ERROR_INSUFFICENT_FUNDS, and ERROR_MIN_CARD_COST appropriately in your application logic.

## Events

- Listen for the CardCreated, DescriptionUpdated, and PortfolioUpdated events to track changes and actions within the platform.

By following this guide, developers can effectively utilize the JobPlatform module to manage their professional profiles on the blockchain.