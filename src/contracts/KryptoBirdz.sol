// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import './ERC721Connector.sol';

contract KryptoBird is ERC721Connector {

    //array para guardar NFTs

    string [] public kryptoBirdz;

    mapping(string => bool) _kryptoBirdzExists;

    function mint (string memory _kryptoBird) public {

      require(!_kryptoBirdzExists[_kryptoBird],'Error - KryptoBird ya existe');
      
       //es anticuado  uint _id=kryptoBirdz.push(_kryptoBird);

       kryptoBirdz.push(_kryptoBird);
       uint _id = kryptoBirdz.length - 1; 

       _mint(msg.sender, _id);

       _kryptoBirdzExists[_kryptoBird]=true;
    }

    constructor ()  ERC721Connector('KryptoBird','KBIRDZ') 
    
    {


    }


}

