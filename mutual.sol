contract basictoken {
    /* Public variables of the token */
    string public standard = 'Token 0.1';
    string public name;
    string public symbol;
    uint8 public decimals;
    uint public totalSupply;

    /* This creates an array with all balances */
    mapping (address => uint) public balanceOf;

    /* This generates a public event on the blockchain that will notify clients */
    event Transfer(address indexed from, address indexed to, uint value);

    /* Initializes contract with initial supply tokens to the creator of the contract */
    //function basictoken() {
    function basictoken(uint initialSupply, string tokenName, uint8 decimalUnits, string tokenSymbol) {
        //uint initialSupply = 10000;
        //var tokenName = 'MutualRMB';
        //uint8 decimalUnits = 0;
        //var tokenSymbol = 'M#M';
        //function mutualtoken(uint initialSupply, string tokenName, uint8 decimalUnits, string tokenSymbol) {
        // Give the creator all initial tokens
        balanceOf[msg.sender] = initialSupply;
        // Update total supply
        totalSupply = initialSupply;
        // Set the name for display purposes
        name = tokenName;
        // Set the symbol for display purposes
        symbol = tokenSymbol;
        // Amount of decimals for display purposes
        decimals = decimalUnits;
    }

    /* Send coins */
    function transfer(address _to, uint _value) {
        // Check if the sender has enough
        if (balanceOf[msg.sender] < _value) throw;
        // Check for overflows
        if (balanceOf[_to] + _value < balanceOf[_to]) throw;
        // Subtract from the sender
        balanceOf[msg.sender] -= _value;                    
        // Add the same to the recipient
        balanceOf[_to] += _value;                           
        // Notify anyone listening that this transfer took place
        Transfer(msg.sender, _to, _value);                  
    }

    /* This unnamed function is called whenever someone tries to send ether to it */
    function () {
        // Prevents accidental sending of ether
        throw;    
    }
}

contract mutualtoken is basictoken {
    /* Public variables of the mutual */
    address public creator;
    // # user
    uint public numberOfUsers;
    // account addrs
    mapping(uint => address) public addrdict;
    // mutual account balance, the token is in fact hold in contract
    mapping(address => uint) public mutualbalance;
    mapping(address => bool) public isaddrexist;
    event FundReceived(address useraddr, uint value);
    event FundSentTo(address useraddr, uint value);
    event UserRegistered(address useraddr, uint value, uint blocknumber);
    event UserUnregistered(address useraddr, uint value, uint blocknumber);
    event ClaimPaid(address useraddr, uint value, uint blocknumber);
    uint public testint;

    // constructor
    function mutualtoken() basictoken(10000,
                                        'MUTUALRMB',
                                        0,
                                        'M#M') {
        creator = msg.sender;
        numberOfUsers = 0;
        testint = 900;
    }
    
    // register an new user into the mutual
    function register(address useraddr, uint value) {
        testint++;
        //address useraddr = msg.sender;
        //if (value < 10) throw;
        // the initial value should be no less than 10
        //if (balanceOf[useraddr] < value) throw;
        //addrdict[numberOfUsers++] = useraddr;
        //numberOfUsers++;
        //numberOfActiveUsers++;
        if (isaddrexist[useraddr] == false) {
            //numberOfUsers++;
            addrdict[numberOfUsers++] = address(useraddr); //this line cannot go through
            //add_to_addrdict(numberOfUsers++, useraddr);
            isaddrexist[useraddr] = true;
        }

        balanceOf[useraddr] -= value;
        mutualbalance[useraddr] += value;
        FundReceived(useraddr, value);
        UserRegistered(useraddr, value, block.number);
    }
    
    // unregister
    function unregister(address useraddr) {
        //address useraddr = msg.sender;
        uint value = mutualbalance[useraddr];
        // send remain value from user back
        if (value > 0) {
            //useraddr.send(value);
            //tokenToBeUsed.transfer(useraddr, value);
            // Check for overflows
            if (balanceOf[useraddr] + value < balanceOf[useraddr]) throw;

            mutualbalance[useraddr] = 0;
            balanceOf[useraddr] += value;

            FundSentTo(useraddr, value);
        }
        
        UserUnregistered(useraddr, value, block.number);
    }
    
    // pay for claims
    function payClaim(address benefeciary) {
        // check if the benefeciary is authentic
        if (isaddrexist[benefeciary] == false) throw;
        if (mutualbalance[benefeciary] <= 0) throw;
        
        uint sumvalue = 0;
        for (uint i = 0; i < numberOfUsers; i++) {
            address useraddr = addrdict[i];
            if (useraddr == benefeciary) continue;
            
            if (mutualbalance[useraddr] >= 1) {
                mutualbalance[useraddr] -= 1;
                sumvalue += 1;
            }
        }
        // Check for overflows
        if (balanceOf[benefeciary] + sumvalue < balanceOf[benefeciary]) throw;
        balanceOf[benefeciary] += sumvalue;

        FundSentTo(benefeciary, sumvalue);
        ClaimPaid(benefeciary, sumvalue, block.number);
    }

}