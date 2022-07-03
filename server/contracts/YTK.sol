//SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import "./@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./@openzeppelin/contracts/security/Pausable.sol";
import "./@openzeppelin/contracts/access/AccessControl.sol";
import "./@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";

contract YTK is ERC20, Pausable, AccessControl, ERC20Permit {
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    event SetProfile(address userAddress, string name , string email , string rollno);

    constructor() ERC20("YMCAToken", "YTK") ERC20Permit("YMCAToken") {
        _mint(msg.sender , 1000000000);
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    struct User {
        string name;
        string email;
        string rollno;
    }

    mapping(address => User) addressToUser;

    function setUpProfile(address _userAddress , string memory _name , string memory _email , string memory _rollno) public {
        addressToUser[_userAddress].name = _name;
        addressToUser[_userAddress].email = _email;
        addressToUser[_userAddress].rollno = _rollno;
        emit SetProfile(_userAddress,_name , _email,_rollno);
    }

    function getProfile(address _userAddress ) external view returns(User memory) {
        return addressToUser[_userAddress];
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, amount);
    }

    function decimals() public pure override returns(uint8) {
        return 2;
    }
}
