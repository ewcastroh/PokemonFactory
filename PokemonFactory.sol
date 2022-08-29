// SPDX-License-Identifier: GPL-3.0
/*
Reto #1
Events en Solidity
Los events (Eventos) en Solidity permiten conectar lo que pasa dentro de la Blockchain con el exterior porque a tráves de un protocolo otras aplicaciones se pueden suscribir a ellos y escuchar todo lo que está pasando en el Smart Contract.
Se usan para:
- Registrar cambios que se hicieron
- Feedback (Retroalimentación)
*/

/*
Reto #2
Requires en Solidity
Los require en Solidity son modificadores de funciones.
Estos permiten hacer validaciones antes de ejecutar una función, de esta forma se puede evitar comportamientos inesperados o que la función sea ejecutada por alguien que no tiene permisos de hacerlo.
*/

pragma solidity >=0.7.0 <0.9.0;

contract PokemonFactory {
    struct Pokemon {
        uint id;
        string name;
        Ability[] abilities;
        Type[] types;
        Type[] weaknesses;
    }

    struct Ability {
        uint id;
        string name;
        string description;
    }

    struct Type {
        uint id;
        string name;
        string description;
    }

    event eventNewPokemon(address author, uint id, string nameNewPokemon, Ability[] _abilities, Type[] _types, Type[] _weaknesses);
    //event eventNewAbility(address author, uint id, string nameNewAbility, descriptionNewAbility);
    //event eventNewType(address author, uint id, string nameNewType, descriptionNewType);

    Pokemon[] private pokemons;
    Ability[] private abilities;
    Type[] private types;

    mapping(uint => address) public pokemonToOwner;
    mapping(address => uint) ownerPokemonCount;

    mapping(uint => address) public abilityToOwner;
    mapping(address => uint) ownerAbilityCount;

    mapping(uint => address) public typeToOwner;
    mapping(address => uint) ownerTypeCount;

    function createAbility(uint _id, string memory _name, string memory _description) public {
        require(_id > 0, "Pokemon ability id shoulbe greater than zero (0).");
        require(
            bytes(_name).length > 2,
            "Pokemon ability name must be more than 2 characters."
        );
        abilities.push(Ability(_id, _name, _description));
        abilityToOwner[_id] = msg.sender;
        ownerAbilityCount[msg.sender]++;

        //emit eventNewAbility(msg.sender, _id, _name, _description);
    }

    function createType(uint _id, string memory _name, string memory _description) public {
        require(_id > 0, "Pokemon type id shoulbe greater than zero (0).");
        require(
            bytes(_name).length > 2,
            "Pokemon type name must be more than 2 characters."
        );
        types.push(Type(_id, _name, _description));
        typeToOwner[_id] = msg.sender;
        ownerTypeCount[msg.sender]++;

        //emit eventNewType(msg.sender, _id, _name, _description);
    }

    function createPokemon(
        uint _id,
        string memory _name,
        uint[] memory _abilities,
        uint[] memory _types,
        uint[] memory _weaknesses
    ) public {
        require(_id > 0, "Pokemon id shoulbe greater than zero (0).");
        require(
            bytes(_name).length > 2,
            "Pokemon name must be more than 2 characters."
        );
		require(
            _abilities.length > 0,
            "Pokemon must have 1 or more Abilities."
        );
        require(_types.length > 0, "Pokemon must have 1 or more Types.");
        require(
            _weaknesses.length > 0,
            "Pokemon must have 1 or more Weaknesses."
        );

        Pokemon storage newPokemon = pokemons.push();
        newPokemon.id = _id;
        newPokemon.name = _name;
        
        for(uint i = 0; i < _abilities.length; i++) {
            Ability memory tempAbility = getAbilityById(_abilities[i]);
            if(tempAbility.id != 0) {
                newPokemon.abilities.push(abilities[tempAbility.id]);
            }
        }

        for(uint i = 0; i < _types.length; i++) {
            if(getTypeById(_types[i]).id != 0) {
                newPokemon.types.push(types[getTypeById(_types[i]).id]);
            }
        }

        for(uint i = 0; i < _weaknesses.length; i++) {
            if(getTypeById(_types[i]).id != 0) {
                newPokemon.weaknesses.push(types[getTypeById(_types[i]).id]);
            }
        }

        pokemonToOwner[_id] = msg.sender;
        ownerPokemonCount[msg.sender]++;

        emit eventNewPokemon(msg.sender, _id, _name, newPokemon.abilities, newPokemon.types, newPokemon.weaknesses);
    }

    function getAbilityById(uint _id) public view returns(Ability memory) {
        Ability memory returnedAbility;
        for(uint i = 0; i < abilities.length; i++) {
            if(abilities[i].id == _id) {
                returnedAbility = abilities[i];
            }
        }
        return returnedAbility;
    }

    function getTypeById(uint _id) public view returns(Type memory) {
        Type memory returnedType;
        for(uint i = 0; i < types.length; i++) {
            if(types[i].id == _id) {
                returnedType = types[i];
            }
        }
        return returnedType;
    }

    function getAllPokemons() public view returns (Pokemon[] memory) {
        return pokemons;
    }

    function getAllAbilities() public view returns (Ability[] memory) {
        return abilities;
    }

    function getAllTypes() public view returns (Type[] memory) {
        return types;
    }

    function getResult() public pure returns (uint product, uint sum) {
        uint a = 1;
        uint b = 2;
        product = a * b;
        sum = a + b;
    }
}
