pragma solidity >0.4.99 <0.6.0;

// Token Swap contract

interface token {
    function transfer(address _to, uint256 _value) external;
    function balanceOf(address _owner) external view returns (uint balance);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
}


contract TokenSwap {
    address payable owner = msg.sender;
    token public tokenReward = token(0xeBc5b45F1c763560bFF823C2ABa85E1935A352d4);

    modifier onlyBy(address _account) {require(msg.sender == _account); _;}
    
    event Swap(address indexed sender, address indexed recipient, uint tokenAmount, uint etherAmount);


    function() payable  external {}

    function swap(address _sender, address _recipient, uint _tokenAmount, uint _etherAmount) payable
      onlyBy(owner)
      public
    {
        tokenReward.transferFrom(_sender, address(this), _tokenAmount);
        msg.sender.transfer(_etherAmount); 
        emit Swap(_sender, _recipient, _tokenAmount, _etherAmount) ; 
    }

    function withdraw()
      onlyBy(owner)
      public
    {   
        owner.transfer(address(this).balance);
    }

    function withdrawTokens() onlyBy(owner) public {
        uint tokenBalance = tokenReward.balanceOf(address(this));

        tokenReward.transfer(owner, tokenBalance);
    }

    function destroy() onlyBy(owner) public {
        selfdestruct(address(this));
    }
}