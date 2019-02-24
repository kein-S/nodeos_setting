#include <eosiolib/eosio.hpp>

using namespace eosio;

class [[eosio::contract]] door : public eosio::contract {

public:
  door( eosio::name receiver, eosio::name code, eosio::datastream<const char*> ds ): eosio::contract(receiver, code, ds) {}

  [[eosio::action]]
  void enter(name who) {
    require_auth(who);
    require_recipient(who);
  }

  [[eosio::action]]
  void exit(name who) {
    require_auth(who);
    require_recipient(who);
  }

};

EOSIO_DISPATCH( door, (enter)(exit))
