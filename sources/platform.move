module JobPlatform::platform {
  use std::option::{Self, Option};
  use std::string::{Self, String};

  use sui::transfer;
  use sui::object::{Self, UID, ID};
  use sui::tx_context::{Self, TxContext};
  use sui::url::{Self, Url};
  use sui::coin::{Self, Coin};
  use sui::sui::SUI;
  use sui::object_table::{Self, ObjectTable};
  use sui::event;

  const ERROR_NOT_THE_OWNER: u64 = 0;
  const ERROR_INSUFFICENT_FUNDS: u64 = 1;
  const ERROR_MIN_CARD_COST: u64 = 1;

  struct DevCard has key, store{
    id: UID,
    name: String,
    owner: address,
    title: String,
    img_url: Url,
    description: Option<String>,
    years_of_experience: u8,
    technologies: String,
    portfolio: Option<String>,
    contact: String,
    open_to_work: bool,
  }

  struct DevHub has key {
    id: UID,
    owner: address,
    counter: u64,
    cards: ObjectTable<u64, DevCard>,
  }

  struct CardCreated has copy, drop {
    id: ID,
    name: String,
    owner: address,
    title: String,
    contact: String,
  }

  struct DescriptionUpdated has copy, drop{
    name: String,
    owner: address,
    new_description: String,
  }

  struct PortfolioUpdated has copy, drop{
    name: String,
    owner: address,
    new_portfolio: String,
  }

  fun init(ctx: &mut TxContext) {
    transfer::share_object(
      DevHub{
        id: object::new(ctx),
        owner: tx_context::sender(ctx),
        counter: 0,
        cards: object_table::new(ctx)
      }
    );
  }

  public entry fun create_card(
    name: String,
    title: String,
    img_url: vector<u8>,
    years_of_experience: u8,
    technologies: String,
    contact: String,
    payment: Coin<SUI>,
    devhub: &mut DevHub,
    ctx: &mut TxContext,
  ){
    let value = coin::value(&payment);
    assert!(value == ERROR_MIN_CARD_COST, ERROR_INSUFFICENT_FUNDS);
    transfer::public_transfer(payment, devhub.owner);

    devhub.counter = devhub.counter + 1;

    let id = object::new(ctx);

    event::emit(
      CardCreated{
        id: object::uid_to_inner(&id),
        name: name,
        owner: tx_context::sender(ctx),
        title: title,
        contact: contact,
      }
    );

    let devcard = DevCard{
      id: id,
      name: name,
      owner: tx_context::sender(ctx),
      title: title,
      img_url: url::new_unsafe_from_bytes(img_url),
      years_of_experience,
      description: option::none(),
      technologies: technologies,
      portfolio: option::none(),
      contact: contact,
      open_to_work: true,
    };
    object_table::add(&mut devhub.cards, devhub.counter, devcard);
  }

  public entry fun update_card_description(devhub: &mut DevHub, new_description: String, id: u64, ctx: &mut TxContext){
    let user_card = object_table::borrow_mut(&mut devhub.cards, id);
    assert!(tx_context::sender(ctx) == user_card.owner, ERROR_NOT_THE_OWNER);

    let old_value = option::swap_or_fill(&mut user_card.description, new_description);

    event::emit(
      DescriptionUpdated{
        name: user_card.name,
        owner: user_card.owner,
        new_description: new_description,
      }
    );

    _ = old_value;
  }

  // public entry fun update_portfolio(devhub: &mut DevHub, id: u64, new_portfolio: String, ctx: &mut TxContext){
  //   let user_card = object_table::borrow_mut(&mut devhub.cards, id);
  //   assert!(tx_context::sender(ctx) == user_card.owner, ERROR_NOT_THE_OWNER);
  //   user_card.portfolio = string::utf8(new_portfolio);
  // }

  public entry fun update_portfolio(devhub: &mut DevHub, new_portfolio: String, id: u64, ctx: &mut TxContext){
    let user_card = object_table::borrow_mut(&mut devhub.cards, id);
    assert!(tx_context::sender(ctx) == user_card.owner, ERROR_NOT_THE_OWNER);

    let old_value = option::swap_or_fill(&mut user_card.portfolio, new_portfolio);

    event::emit(
      PortfolioUpdated{
        name: user_card.name,
        owner: user_card.owner,
        new_portfolio: new_portfolio,
      }
    );

    _ = old_value;
  }

  public entry fun deactive_card(devhub: &mut DevHub, id: u64, ctx: &mut TxContext){
    let user_card = object_table::borrow_mut(&mut devhub.cards, id);
    assert!(tx_context::sender(ctx) == user_card.owner, ERROR_NOT_THE_OWNER);
    user_card.open_to_work = false;
  }

  public fun get_card_info(devhub: &DevHub, id: u64): (
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
  ){
    let card = object_table::borrow(&devhub.cards, id);
    return(
      card.name,
      card.owner,
      card.title,
      card.img_url,
      card.description,
      card.years_of_experience,
      card.technologies,
      card.portfolio,
      card.contact,
      card.open_to_work,
    )
  }
  
}