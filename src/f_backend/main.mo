import Trie "mo:base/Trie";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Array "mo:base/Array";
actor{
  public type Person = {
    name : Text;
    birthday : Text;
    phone : Text;
    sex : Text;
  };
  stable var persons : Trie.Trie<Nat,Person> = Trie.empty();
  stable var next : Nat = 0;

  private func key(x:Nat) : Trie.Key<Nat>  {
    return {
      key = x;
      hash = Hash.hash(x);
    };
  };
  
  public func createAccount(p : Person) : async () {
    next += 1;
    let id = next;
    let (newPersons, existing) = Trie.put(
    persons,
    key(id),
    Nat.equal,
    p);
    switch(existing) {
      case (null) {
        persons := newPersons;
      };
      case (?v) {
        return;
      };
    };
    return;
  };

  public func readAccount() : async [Person] {
    let f = func(key : Nat, val : Person) : Person{
      return val;
    };
    return Trie.toArray(persons, f);
  };

  public func updateAccount(id : Nat, person : Person) : async () {
    let result = Trie.find(
      persons,key(id),Nat.equal
    );
    switch(result) {
      case (null) return;
      case (?v) {
        persons := Trie.replace(
          persons,key(id),Nat.equal,?person
        ).0;
      };  
    };
    return;
  };

  public func deleteAccount(id : Nat) : async () {
    let result = Trie.find(
      persons,key(id),Nat.equal
    );
    switch(result) {
      case (null) return;
      case (?v) {
        persons := Trie.replace(
          persons,key(id),Nat.equal,null
        ).0;
      };  
    };
    return;
  };  
  public func print_next(): async Nat{
    return next;
  }
};
