pragma solidity >0.4.99 <0.6.0;

// Reward Channel contract

interface token {
    function transfer(address _to, uint256 _value) external;
    function balanceOf(address _owner) external view returns (uint balance);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
}


contract GiftChannel {
    address payable owner = msg.sender;

    struct Channel {
        bool started;
        bool rewardSent;
        address recipient;
        uint amount;
        uint timeIntervalInMinutes;
    }

    mapping(bytes32 => Channel) public channels;


    token public tokenReward = token(0xeBc5b45F1c763560bFF823C2ABa85E1935A352d4);


    modifier onlyBy(address _account) {require(msg.sender == _account); _;}

    function() payable  external {}

    function sendGift(bytes32 _channelId, uint _tokenAmount, address _recipient) payable
      public
    {
        tokenReward.transferFrom(msg.sender, address(this), _tokenAmount);
        Channel storage channel = channels[_channelId];
        require(!channel.started);
        channel.started = true;
        channel.amount = _tokenAmount;
        channel.recipient = _recipient;
        channels[_channelId] = channel;
    }

    function withdrawGift(bytes32 _channelId)
      public
    {
        Channel storage channel = channels[_channelId];
        require(channel.recipient == msg.sender);
        require(!channel.rewardSent);
        channel.rewardSent = true;
        tokenReward.transfer(msg.sender, channel.amount);
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