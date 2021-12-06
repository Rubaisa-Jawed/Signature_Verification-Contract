//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
contract VerifySignature {
    function MessageHash(address _to, uint _amount, string memory _message, uint _nonce) public pure returns (bytes32){
        return keccak256(abi.encodePacked(_to,_amount,_message,_nonce));
    }

    function EthSignedMessageHash(bytes32 _messageHash) public pure returns (bytes32){
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash));
    }
    
    function SplitSignature(bytes memory sig) public pure returns(bytes32 r, bytes32 s, uint8 v ){
        require(sig.length == 65, "Invalid signature Length");
        assembly{
            r := mload(add(sig,32))
            s := mload(add(sig,64))
            v := byte(0,mload(add(sig,96)))
        }
    }
    
    function recoverSigner(bytes32 _ethSignedMessageHash,bytes memory _signature) public pure returns(address){
        (bytes32 r, bytes32 s, uint8 v) = SplitSignature(_signature);
        return ecrecover(_ethSignedMessageHash, v, r, s);
    }
    
    function verify(address _signer, address _to, uint _amount, string memory _message,uint _nonce, bytes memory signature) public pure returns (bool){
        bytes32 messageHash = MessageHash(_to, _amount, _message, _nonce);
        bytes32 ethSignedMessageHash = EthSignedMessageHash(messageHash);
        return recoverSigner(ethSignedMessageHash, signature) == _signer;
    }

}