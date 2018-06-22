pragma solidity ^0.4.23;

import "../imports/EscrowToken.sol";

contract Organization is EscrowToken  {
    modifier isOrganizationAdmin(address _org) {
        require(orgs[_org].isAdmin[msg.sender]);
        _;
    }

    ///Creation of Organization
    function formOrganization(bytes32 _details)
    validDetail(_details) public {
        Organization storage o = orgs[msg.sender];
        require(o.details == bytes32(0));
        o.details = _details;
        o.isAdmin[msg.sender] = true;
    }

    function modifyOrganization(
        address _org,
        bytes32 _details
    ) isOrganizationAdmin(_org) validDetail(_details) public {
        orgs[_org].details = _details;
    }
    //Administration of Organization
    function setOrgAdminStatus(
        address _org,
        address _admin,
        bool _status
    ) isOrganizationAdmin(_org) public {
        orgs[_org].isAdmin[_admin] = _status;
    }

    //Organization Project Creation & Maintainence
    function createProject(
        address _org,
        bytes32 _details
    ) isOrganizationAdmin(_org) validDetail(_details) public returns(uint256){
        Organization storage o = orgs[_org];
        uint256 projectID = o.projects.length++;
        o.projects[projectID].details = _details;
        o.projects[projectID].isAdmin[msg.sender] = true;
        return projectID;
    }



    function distributeToProject(
        address _org,
        uint256 _project,
        uint256 _amount
    ) isOrganizationAdmin(_org) public {
        Organization storage o = orgs[_org];
        require(o.contributionTotal >= _amount);
        o.contributionTotal = o.contributionTotal.sub(_amount);
        o.childContributions = o.childContributions.add(_amount);
        Project storage p = o.projects[_project];
        p.contributionTotal = p.contributionTotal.add(_amount);
        p.contributionOf[msg.sender] = _amount;
    }
}