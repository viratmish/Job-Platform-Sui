module JobPlatform::platform {
  use std::option::{Self, Option};
  use std::string::{String};

  use sui::transfer;
  use sui::object::{Self, UID, ID};
  use sui::tx_context::{Self, TxContext, sender};
  use sui::url::{Self, Url};
  use sui::coin::{Self, Coin};
  use sui::sui::SUI;
  use sui::object_table::{Self, ObjectTable};
  use sui::event;

  const ERROR_NOT_THE_OWNER: u64 = 0;
  const ERROR_INSUFFICENT_FUNDS: u64 = 1;
  const ERROR_MIN_CARD_COST: u64 = 2;

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

  struct DevCardCap has key, store {
    id: UID,
    card: ID
  }

  struct DevHub has key {
    id: UID,
    owner: address,
    counter: u64,
    cards: ObjectTable<address, DevCard>,
  }

  struct DevHubCap has key {
    id: UID,
    to: ID
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
    let id_ = object::new(ctx);
    let inner_ = object::uid_to_inner(&id_);
    transfer::share_object(
      DevHub{
        id: id_,
        owner: tx_context::sender(ctx),
        counter: 0,
        cards: object_table::new(ctx)
      }
    );

    transfer::transfer(DevHubCap{id:object::new(ctx), to:inner_}, sender(ctx));
  }

  public fun create_card(
    devhub: &mut DevHub,
    name: String,
    title: String,
    img_url: vector<u8>,
    years_of_experience: u8,
    technologies: String,
    contact: String,
    payment: Coin<SUI>,
    ctx: &mut TxContext,
  ) : DevCardCap {
    let value = coin::value(&payment);
    assert!(value == ERROR_MIN_CARD_COST, ERROR_INSUFFICENT_FUNDS);
    transfer::public_transfer(payment, devhub.owner);

    devhub.counter = devhub.counter + 1;

    let id = object::new(ctx);
    let inner_ = object::uid_to_inner(&id);

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
    object_table::add(&mut devhub.cards, sender(ctx), devcard);

    DevCardCap {
      id: object::new(ctx),
      card: inner_
    }
  }

  public entry fun update_card_description(cap: &DevCardCap, devhub: &mut DevHub, new_description: String, ctx: &mut TxContext){
    let user_card = object_table::borrow_mut(&mut devhub.cards, sender(ctx));
    assert!(object::id(user_card) == cap.card, ERROR_NOT_THE_OWNER);

    event::emit(
      DescriptionUpdated{
        name: user_card.name,
        owner: user_card.owner,
        new_description: new_description,
      }
    );
  }

  public entry fun update_portfolio(cap: &DevCardCap, devhub: &mut DevHub, new_portfolio: String, ctx: &mut TxContext){
    let user_card = object_table::borrow_mut(&mut devhub.cards, sender(ctx));
    assert!(object::id(user_card) == cap.card, ERROR_NOT_THE_OWNER);

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

  public fun deactive_card(cap: &DevCardCap, devhub: &mut DevHub, ctx: &mut TxContext){
    let user_card = object_table::borrow_mut(&mut devhub.cards, sender(ctx));
    assert!(object::id(user_card) == cap.card, ERROR_NOT_THE_OWNER);
    user_card.open_to_work = false;
  }

  public fun remove(cap: &DevCardCap, devhub: &mut DevHub, ctx: &mut TxContext) {
    let user_card = object_table::remove(&mut devhub.cards, sender(ctx));
    let DevCard {
      id,
      name: _,
      owner: _,
      title: _,
      img_url: _,
      description: _,
      years_of_experience: _,
      technologies: _,
      portfolio: _,
      contact: _,
      open_to_work: _
    } = user_card;

    assert!(object::uid_to_inner(&id) == cap.card, ERROR_NOT_THE_OWNER);
    object::delete(id);
  }
  
  public fun get_card_info(devhub: &DevHub, ctx: &mut TxContext): (
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
  ) {
    let card = object_table::borrow(&devhub.cards, sender(ctx));
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



public fun get_card_count(devhub: &DevHub, ctx: &mut TxContext) : (u64) {
    return devhub.counter;
}

public fun get_card_owner(cap: &DevCardCap, devhub: &DevHub, ctx: &mut TxContext) : (address) {
    let user_card = object_table::borrow(&devhub.cards, sender(ctx));
    assert!(object::id(user_card) == cap.card, ERROR_NOT_THE_OWNER);
    return user_card.owner;
}

public fun get_card_by_name(devhub: &DevHub, name: String, ctx: &mut TxContext) : (Option<DevCard>) {
    let cards = &devhub.cards;
    for card in object_table::iter(cards) {
        if card.name == name {
            return Some(card);
        }
    }
    None // Card not found
}

public fun get_cards_by_experience(devhub: &DevHub, experience: u8, ctx: &mut TxContext) : (Vec<DevCard>) {
    let mut matching_cards = Vec::new();
    let cards = &devhub.cards;
    for card in object_table::iter(cards) {
        if card.years_of_experience == experience {
            matching_cards.push(card);
        }
    }
    matching_cards
}


}