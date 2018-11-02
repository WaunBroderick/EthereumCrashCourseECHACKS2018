pragma solidity ^0.4.0;
contract Escrow{
    
    enum state {AWAITING_PAYMENT, AWAITIN_DELIVERY, COMPLETE, REFUNDED}
    state public currentState
    
    address public buyer;
    address public seller;
    address public arbiter;
    
    modifier buyerOnly() {
        require(msg.sender == buyer || msg.sender == arbiter);
        _;
    }
    
    modifier sellerOnly(){
        require(msg.sender == seller || msg.sender == arbiter);
        _;
    }
    
    modifier inState(State expectedState){
        require(currentState == expectedState);
        _;
    }
    
    function Escrow(address _buyer, address _seller, address _arbiter){
        buyer = _buyer;
        seller = _seller;
        arbiter = _arbiter;
    }
    
    function confirmPayment() buyerOnly inState(state.AWAITING_PAYMENT)payable{
        require(msg.sender = buyer);
    }
    
    function confirmDelivery() buyerOnly inState(state.AWAITING_DELIVERY){
        seller.send(this.balance);
        currentState = state.COMPLETE;
    }
    
    function refundBuyer() sellerOnly inState(state.AWAITING_DELIVERY){
        buyer.send(this.balance);
        currentState = State.REFUNDED;
        
    }
}