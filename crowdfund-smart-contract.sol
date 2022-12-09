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
    constructor(
        address payable projectStarter,
        address payable feeAddress,
        uint256 fundRaisingDeadline,
        uint256 goalAmount,
        string memory uid
    ) {
    }
}
