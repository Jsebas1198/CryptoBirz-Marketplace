// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';

contract ERC721Enumerable is IERC721Enumerable,ERC721 {

    uint256[] private _allTokens;

//mapeo del tokenid a su posiccion
    mapping(uint256 => uint256) private _allTokensIndex;

//mapeo  del dueno para ver todos sus tokens, es un array debido a que es una lista
mapping (address => uint256[]) private  _ownedTokens;

//mapeo de los indices de los ids de los tokens del dueno

mapping (uint256 => uint256) private _ownedTokensIndex;


 constructor (){

        _registerInterface(bytes4(keccak256('tokenByIndex(bytes4)')^
        keccak256('tokenOfOwnerByIndex(bytes4)')^keccak256('totalSupply(bytes4)')));
    }


        function _mint (address to, uint256 tokenId) internal override (ERC721){

                super._mint(to, tokenId);

                //queremos crear una funcion para:
                //A. agregar los tokens al dueno
                //B. Agreegar los tokens a nuestro total de tokens


                _addTokensToAllTokenEnumeration(tokenId);

                _addTokensToOwnerEnumeration(to, tokenId);
            }


        //agrega tokens al _allTokens array y agrega la posicion al _allTokensIndex
        function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
                _allTokensIndex[tokenId]= _allTokens.length;
                 _allTokens.push(tokenId);


        }


//Agregamos los indices de los tokens que posee el dueno y agrega los tokens aal dueno
        function _addTokensToOwnerEnumeration(address to, uint256  tokenId) private {

            _ownedTokensIndex[tokenId]=_ownedTokens[to].length;
            _ownedTokens[to].push(tokenId);

        }

function tokenByIndex(uint256 index) public view override returns (uint256){
require (index  < totalSupply(), 'El indice global esta fuera de rango');
    return _allTokens[index];
}

function tokenOfOwnerByIndex(address owner, uint256  index) public view override returns(uint256){
require(index < balanceOf(owner),'el indice del dueno esta fuera de rango');
return  _ownedTokens[owner][index];
}


        //regresa la cantidad total de los _allTokens array
        function totalSupply() public view override returns (uint256){
                return _allTokens.length;
        }


    


}