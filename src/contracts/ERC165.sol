// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import './interfaces/IERC165.sol';

contract ERC165 is IERC165 {

    mapping (bytes4 => bool) private _supportedInterfaces;

  
    //Para quitar el error del abtract, importamo la funcion de IERC165 como en el remix

    function supportsInterface(bytes4 interfaceID) external view override returns (bool){
            return _supportedInterfaces[interfaceID];

    }

    function _registerInterface(bytes4 interfaceId) internal {

        require (interfaceId != 0xffffffff,'Interfaz no disponible');

        _supportedInterfaces[interfaceId]=true;
    }



}