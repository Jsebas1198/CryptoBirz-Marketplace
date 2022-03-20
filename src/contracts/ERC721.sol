// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


import './ERC165.sol';

import './interfaces/IERC721.sol';

/* 
    Para crear la funion minting tokens (la funcion que crear los tokens de los NFTs)
    a. NFTs deben de estar direccionados a una direccion(address)
    b. Debemos de tener rastro de los tokens
    c. Debemos d etener un seguimiento de los tokens de la direccion que pertenece al dueno y los ids de los tokens
    d. Debemos de tener seguimiento de cuantos tokens un dueno tiene
    e. Crear los eventos y emitirlos con la funcion emit hacia un transfer log-contract address, ahi es donde estan siendo creados 
    con su id

*/

//Este contrato esta importado en ERC721Enumerable 

contract ERC721 is ERC165, IERC721{ 


    /* lo que deba de ser private se mantiene private, la seguridad es importante */

    /*Mapeamos los tokens id a los duenos */

    /*La funcion mapping crear un hash table que es array que asocia valores que pasan por un hash */
    mapping  (uint256 => address) private _tokenOwner;

    /*Mapeamos cuantos tokens tiene un dueno */

    mapping (  address => uint256 ) private _OwnedTokensCount;

    //mapea de los tokensids a las direcciones aprobadas

    mapping (uint256 => address) private _tokenApprovals;


//hay que hacer que el constructor ejecute todas las funciones del contrato de ERC721, ERC721Enumerable y ERC721Metadata
      constructor (){

        _registerInterface(bytes4(keccak256('balanceOf(bytes4)')^
        keccak256('ownerOf(bytes4)')^keccak256('transferFrom(bytes4)')));
    }



//Para mostrar el balance del dueño

    function balanceOf(address _owner) public view override returns (uint256){

        require(_owner != address(0), 'ERC721: Creando el token en la direcion inexistente o 0');

        return _OwnedTokensCount[_owner];

    }

//Para saber quien es el dueno de los NFTs

    function ownerOf(uint256 _tokenId) public view override returns (address){

            address owner = _tokenOwner[_tokenId];

            require(owner != address(0), 'ERC721: Creando el token en la direcion inexistente o 0');

            return owner;


    }


/* Esta funcion verifica si el tokenId existe, ingresa al mapeo del tokenowner, no deberia de existir  */
    function _exists(uint256 tokenId) internal view returns(bool){

        address owner = _tokenOwner [tokenId];
        return owner != address(0);
    }

    function _mint (address to, uint256 tokenId) internal virtual
    {
/*Requerimos que la direccion no sea 0 */
        require(to != address(0), 'ERC721: Creando el token en la direcion inexistente o 0');
/*Queremos asegurarnos que el token creado no exista antes */
        require(!_exists(tokenId), 'ERC721: El token ya existe');

/*Agregamos una nueva direccion con su tokenId */
         _tokenOwner[tokenId]=to;

//Hacemos seguimiento de cada direcccion que esta siendo minting y le sumamos uno al contador
         _OwnedTokensCount[to] += 1;

         emit Transfer(address(0), to, tokenId);

        
    }


    function _transferFrom(address _from, address _to, uint256 _tokenId) internal{

        require(_to != address(0),'ERROR - No se puede trnaferir a la direccion 0');
        
        require( ownerOf(_tokenId) == _from,'Direccion incorrecta');

        _OwnedTokensCount[_from] -= 1;

        _OwnedTokensCount[_to] += 1;

        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);



    }

     function transferFrom(address _from, address _to, uint256 _tokenId) override public{

         require (isApprovedOrOwner(msg.sender,_tokenId ));
            _transferFrom(_from, _to, _tokenId);

     }


//Hay que ver y comparar el archivo de ERC721.sol que se encuentra en el archivo de node_modelus =>openzepplin
//y revisar la funcion isApprovedOrOwner y tratar de adaptarla a nuestro codigo
 
    function aprrove (address _to, uint256 tokenId) public{

            address owner = ownerOf(tokenId);
            require (_to != owner,'No es el dueno del token');
            require(msg.sender == owner,'El que quiere hacer este llamado no es el dueno del token');

            _tokenApprovals[tokenId]=_to;
            emit Approval(owner,_to,tokenId);

        }

     


      function isApprovedOrOwner (address spender, uint256 tokenId) internal view returns (bool){
            
            require(_exists(tokenId),'El token no existe');
            address owner = ownerOf(tokenId);

            return(spender == owner);

      }



}