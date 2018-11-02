pragma solidity ^0.4.0;

import "./baseauction.sol";

contract TimerAuction is BaseAuction {
    
    string public item;
    uint public auctionEnd;
    address public maxBidder;
    uint public maxBid;
    bool public ended;
    
    event BidAccepted(address bidder, uint bid);
    
    function TimerAuction(uint _durationMinutes, string _item){
        item = _item;
        auctionEnd = now + (_durationMinutes * 1 minutes);
    }
    

    
    function bid() payable{
        require(now < auctionEnd);
        require(msg.value > maxBid);
        
        if(maxBidder != 0){
            maxBidder.transfer(maxBid);
        }
        
        maxBidder = msg.sender;
        maxBid = msg.value;
        
        BidAccepted(maxBidder, maxBid);
    }
    
    function end() ownerOnly{
        //1)check conditions
        require(!ended);
        require(now >= auctionEnd);
        
        //2)update state
        ended = true;
        AuctionComplete(maxBidder, maxBid);
        
        //3)interact with address
        owner.transfer(maxBid);
        
    }
}