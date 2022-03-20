// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IERC721 {
   
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

 
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

    
     //este evento esta comentado porque todavia no la desarrollamos en el contrato de ERC721
    //event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);


    function balanceOf(address _owner) external view returns (uint256);


    function ownerOf(uint256 _tokenId) external view returns (address);


    //Esta funcion esta comentada porque todavia no la desarrollamos en el contrato de ERC721
    //function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable;


    //Esta funcion esta comentada porque todavia no la desarrollamos en el contrato de ERC721
    //function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;


    function transferFrom(address _from, address _to, uint256 _tokenId) external;

 

    //Esta funcion esta comentada porque todavia no la desarrollamos en el contrato de ERC721
    //function approve(address _approved, uint256 _tokenId) external payable;

    

    //Esta funcion esta comentada porque todavia no la desarrollamos en el contrato de ERC721
   // function setApprovalForAll(address _operator, bool _approved) external;



    //Esta funcion esta comentada porque todavia no la desarrollamos en el contrato de ERC721
    //function getApproved(uint256 _tokenId) external view returns (address);

   

    //Esta funcion esta comentada porque todavia no la desarrollamos en el contrato de ERC721
    //function isApprovedForAll(address _owner, address _operator) external view returns (bool);
}