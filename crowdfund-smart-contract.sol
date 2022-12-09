// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

contract Crowdfunding {
    // List of existing projects
    Project[] private projects;

    // Event that will be emitted whenever a new project is started
    event ProjectStarted(
        address contractAddress,
        address projectStarter,
        uint256 deadline,
        uint256 goalAmount,
        string uniqueId
    );

    /** @dev Function to start a new project.
     * @param amountToRaise Project goal in wei
     */
    function startProject(
        address payable feesTaker,
        uint256 amountToRaise,
        uint256 deadline,
        string calldata uniqueId
    ) external {
        Project newProject = new Project(
            payable(msg.sender),
            feesTaker,
            deadline,
            amountToRaise,
            uniqueId
        );
        projects.push(newProject);
        emit ProjectStarted(
            address(newProject),
            msg.sender,
            deadline,
            amountToRaise,
            uniqueId
        );
    }
}

contract Project {
    // Data structures
    enum State {
        Fundraising,
        Expired,
        Successful
    }

    // State variables
    address payable public feesTaker;
    address payable public creator;
    uint256 public amountGoal; // required to reach at least this much, else everyone gets refund
    uint256 public completeAt;
    uint256 public currentBalance;
    uint256 public raiseBy;
    string public uniqueId;
    // uint256 public cc =  block.timestamp;

    State public state = State.Fundraising; // initialize on create
    mapping(address => uint256) public contributions;

    // Event that will be emitted whenever funding will be received
    event FundingReceived(
        address contributor,
        uint256 amount,
        uint256 currentTotal
    );
    // Event that will be emitted whenever the project starter has received the funds
    event CreatorPaid(address recipient);

    event Expired(State state);

    // Modifier to check current state
    modifier inState(State _state) {
        require(state == _state);
        _;
    }

    // Modifier to check if the function caller is the project creator
    modifier isCreator() {
        require(msg.sender == creator);
        _;
    }

    constructor(
        address payable projectStarter,
        address payable feeAddress,
        uint256 fundRaisingDeadline,
        uint256 goalAmount,
        string memory uid
    ) {
        creator = projectStarter;
        feesTaker = feeAddress;
        amountGoal = goalAmount;
        raiseBy = fundRaisingDeadline;
        currentBalance = 0;
        uniqueId = uid;
    }
}
