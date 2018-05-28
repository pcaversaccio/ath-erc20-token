pragma solidity ^0.4.18;

/**
 * @title Safe Math contract
 * 
 * @dev prevents overflow when working with uint256 addition ans substraction
 */
contract SafeMath {
    function safeAdd(uint256 a, uint256 b) public pure returns (uint256 c) {
        c = a + b;
        require(c >= a);
    }

    function safeSub(uint256 a, uint256 b) public pure returns (uint256 c) {
        require(b <= a);
        c = a - b;
    }
}

/**
 * @title ERC Token Standard #20 Interface 
 *
 * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
 * @dev https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts/token/ERC20
 */
contract ERC20Interface {

    function totalSupply() public view returns (uint256);
    function balanceOf(address who) public view returns (uint256);
    function allowance(address owner, address spender) public view returns (uint256);

    function transfer(address to, uint256 value) public returns (bool);
    function approve(address spender, uint256 value) public returns (bool);
    function transferFrom(address from, address to, uint256 value) public returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @title Owned contract
 *
 * @dev Implements ownership 
 */
contract Ownable {
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() public {
        owner = msg.sender;
    }

    function transferOwnership(address newOwner) public {
        require(msg.sender == owner);
        require(newOwner != address(0));

        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

/**
 * @title The ATH Token Contract
 *
 * @dev The ATH Token is an ERC20 Token
 * @dev https://github.com/ethereum/EIPs/issues/20
 */
contract ATHToken is ERC20Interface, Ownable, SafeMath {

    /* 
     * The maximum number of tokens will be known after the ICO.
     * 30 Millions with 18 decimals is currently a placeholder. 
     * TODO: PROD - Set to the real value when go productive
    */
    uint256 constant public MAX_SUPPLY = 30 * 1000 * 1000 * (10 ** uint256(decimals));
    string public constant symbol = "ATH";
    string public constant name = "ALETHENA Token";
    uint8 public constant decimals = 18;
    
    uint256 public totalSupply = 0;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    /* 
     * Vesting requirement. Locks the funds for a defined set of token holders (addresses). 
     * absolute timestamp in epoche unix time seconds to lock the tokens.
     */
    mapping(address => uint256) timeLocked;
    bool initDone = false;

    event Mint(address indexed to, uint256 amount);
    
    constructor() public {

    }

    function init() public returns (bool) {
        require(msg.sender == owner);
        require(initDone == false);

        initDone = true;

        uint8 maxVested = 20; //TODO: PROD - Set to the real value when go productive
        address[] memory lockedAddresses = new address[](maxVested);
        uint256[] memory lockedTokens = new uint256[](maxVested);
        uint256[] memory lockTime = new uint256[](maxVested);

        // TODO: === START: Whole section needs to be replaced when go PROD ===
        // --- testrpc 9th and 10th address in 'testrpc -s equility'
        uint8 counter = 0;
        lockedAddresses[counter] = address(0xCc0a8b7603c787da0A648bDf57959fd7cfa32d40); //9th address
        lockedTokens[counter] = 1000;
        lockTime[counter] = 1651066149; //2022-04-27T13:29:09+00:00

        counter = counter + 1;
        lockedAddresses[counter] = address(0xA45222ff65b41E4E503fAaB6B786Ac129Fc09f18); //10th address
        lockedTokens[counter] = 3000;
        lockTime[counter] = 1493299749; //2017-04-27T13:29:09+00:00

        // --- start: 18 temporary entries (to test about out of gas) ---
        counter = counter + 1;
        lockedAddresses[counter] = address(0x5521a68D4F8253fC44BFb1490249369b3E299A4A);
        lockedTokens[counter] = 3000;
        lockTime[counter] = 1493299749;

        counter = counter + 1;
        lockedAddresses[counter] = address(0x6F46CF5569AEfA1acC1009290c8E043747172d89);
        lockedTokens[counter] = 3000;
        lockTime[counter] = 1493299749;

        counter = counter + 1;
        lockedAddresses[counter] = address(0x90e63c3d53E0Ea496845b7a03ec7548B70014A91);
        lockedTokens[counter] = 3000;
        lockTime[counter] = 1493299749;

        counter = counter + 1;
        lockedAddresses[counter] = address(0x53d284357ec70cE289D6D64134DfAc8E511c8a3D);
        lockedTokens[counter] = 3000;
        lockTime[counter] = 1493299749;

        counter = counter + 1;
        lockedAddresses[counter] = address(0xfE9e8709d3215310075d67E3ed32A380CCf451C8);
        lockedTokens[counter] = 3000;
        lockTime[counter] = 1493299749;

        counter = counter + 1;
        lockedAddresses[counter] = address(0xF27daFf52c38b2c373Ad2B9392652DdF433303c4);
        lockedTokens[counter] = 3000;
        lockTime[counter] = 1493299749;

        counter = counter + 1;
        lockedAddresses[counter] = address(0x3D2e397F94e415D7773E72e44D5B5338a99E77d9);
        lockedTokens[counter] = 3000;
        lockTime[counter] = 1493299749;

        counter = counter + 1;
        lockedAddresses[counter] = address(0xb8487eeD31Cf5C559BF3f4eDD166b949553D0d11);
        lockedTokens[counter] = 3000;
        lockTime[counter] = 1493299749;

        counter = counter + 1;
        lockedAddresses[counter] = address(0x74660414dFae86b196452497A4332bD0E6611e82);
        lockedTokens[counter] = 3000;
        lockTime[counter] = 1493299749;

        counter = counter + 1;
        lockedAddresses[counter] = address(0x1b3cB81E51011b549d78bf720b0d924ac763A7C2);
        lockedTokens[counter] = 3000;
        lockTime[counter] = 1493299749;

        counter = counter + 1;
        lockedAddresses[counter] = address(0x6F52730DBA7B02beeFcAF0D6998c9AE901Ea04f9);
        lockedTokens[counter] = 3000;
        lockTime[counter] = 1493299749;

        counter = counter + 1;
        lockedAddresses[counter] = address(0x5FfC99B5B23c5aB8f463F6090342879c286a29bE);
        lockedTokens[counter] = 3000;
        lockTime[counter] = 1493299749;

        counter = counter + 1;
        lockedAddresses[counter] = address(0xfCA70E67b3f93f679992Cd36323eEB5a5370C8e4);
        lockedTokens[counter] = 3000;
        lockTime[counter] = 1493299749;

        counter = counter + 1;
        lockedAddresses[counter] = address(0x51f9C432A4e59aC86282D6ADaB4c2EB8919160EB);
        lockedTokens[counter] = 3000;   
        lockTime[counter] = 1493299749;

        counter = counter + 1;
        lockedAddresses[counter] = address(0x847Ed5f2e5DdE85Ea2B685EdAB5f1f348fB140eD);
        lockedTokens[counter] = 3000;
        lockTime[counter] = 1493299749;

        counter = counter + 1;
        lockedAddresses[counter] = address(0x900d0881A2E85A8E4076412AD1CeFbE2D39c566c);
        lockedTokens[counter] = 3000;
        lockTime[counter] = 1493299749;

        counter = counter + 1;
        lockedAddresses[counter] = address(0xf1ce0A98eFbFA3f8EbEC2399847b7D88294A634e);
        lockedTokens[counter] = 3000;
        lockTime[counter] = 1493299749;

        counter = counter + 1;
        lockedAddresses[counter] = address(0xf1ce0a98efbFa3f8ebec2399847b7D88294a634F);
        lockedTokens[counter] = 3000;
        lockTime[counter] = 1493299749;
        // --- end 18 temporary entries ---
        // TODO: === END: Whole section needs to be replaced when go PROD ===

        counter = counter + 1;
        require(maxVested == counter); //make sure nobody gets lost. 

        require(mint(lockedAddresses, lockedTokens));

        for(uint256 i = 0; i<maxVested; i++) {
            timeLocked[lockedAddresses[i]] = lockTime[i];
        }

        return true;
    }

    /**
     * @dev This contract does not accept ETH
     */
    function() public payable {
        revert();
    }

    // ---- ERC20 START ----
    function totalSupply() public view returns (uint256) {
        return totalSupply;
    }

    function balanceOf(address who) public view returns (uint256) {
        return balances[who];
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(!isLocked(msg.sender));

        balances[msg.sender] = safeSub(balances[msg.sender], value);
        balances[to] = safeAdd(balances[to], value);
        emit Transfer(msg.sender, to, value);
        return true;
    }

    /**
    * Beware that changing an allowance with this method brings the risk that someone may use both the old
    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
    */
    function approve(address spender, uint256 value) public returns (bool) {
        allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(!isLocked(from));

        balances[from] = safeSub(balances[from], value);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], value);
        balances[to] = safeAdd(balances[to], value);
        emit Transfer(from, to, value);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return allowed[owner][spender];
    }
    // ---- ERC20 END ----

    // ---- EXTENDED FUNCTIONALITY START ----
    /**
     * @dev Increase the amount of tokens that an owner allowed to a spender.
     */
    function increaseApproval(address spender, uint256 addedValue) public returns (bool success) {
        allowed[msg.sender][spender] = safeAdd(allowed[msg.sender][spender], addedValue);
        emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
        return true;
    }

    /**
     * @dev Decrease the amount of tokens that an owner allowed to a spender.
     */
    function decreaseApproval(address spender, uint256 subtractedValue) public returns (bool success) {
        uint256 oldValue = allowed[msg.sender][spender];
        if (subtractedValue > oldValue) {
            allowed[msg.sender][spender] = 0;
        } else {
            allowed[msg.sender][spender] = safeSub(oldValue, subtractedValue);
        }

        emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
        return true;
    }
    
    /**
     * @dev Same functionality as transfer. Accepts an array of recipients and values. Can be used to save gas.
     * @dev both arrays requires to have the same length
     */
    function transferArray(address[] tos, uint256[] values) public returns (bool) {
        require(tos.length == values.length);

        for (uint256 i = 0; i < tos.length; i++) {
            require(transfer(tos[i], values[i]));
        }

        return true;
    }
    // ---- EXTENDED FUNCTIONALITY END ----

    // ---- MINT START ----
    /**
     * @dev Bulk mint function to save gas. 
     * @dev both arrays requires to have the same length
     */
    function mint(address[] recipients, uint256[] tokens) public returns (bool) {
        require(msg.sender == owner);
        require(initDone);
        require(recipients.length == tokens.length);

        for (uint256 i = 0; i < recipients.length; i++) {

            address recipient = recipients[i];
            uint256 token = tokens[i];

            totalSupply = safeAdd(totalSupply, token);
            require(totalSupply <= MAX_SUPPLY);

            balances[recipient] = safeAdd(balances[recipient], token);

            emit Mint(recipient, token);
            emit Transfer(address(0), recipient, token);
        }

        return true;
    }

    function isMintDone() public view returns (bool) {
        return totalSupply == MAX_SUPPLY;
    }
    // ---- MINT END ---- 

    // ---- VESTING / TIME LOCKING START ----
    
    /**
     * @dev Returns true if the address is locked (vesting period).
     * @dev Returns false if there is no vesting or if the vesting period is expired.
     * @dev As log the address is locked (true) the specific token holder is not allowed/able to transfer his tokens!
     */
    function isLocked(address tokenHolder) public view returns (bool) {
        uint256 lockedTime = timeLocked[tokenHolder];

        //If the value is 0, then there is no entry in the mapping timeLocked
        if(lockedTime == 0) {
            return false;
        }

        //If the contract function can tolerate a 30-second drift in time, it is safe to use block.timestamp
        //As long the lockedTime is bigger than the current time, it's locked. 
        return lockedTime > block.timestamp;
    }
    
    /**
     * @dev Returns the locking time in epoche unix time seconds
     * @dev If return 0 no locking time was set. 
     */
    function lockTime(address tokenHolder) public view returns (uint256) {
        return timeLocked[tokenHolder];
    }

    // ---- VESTING / TIME LOCKING END ----
}