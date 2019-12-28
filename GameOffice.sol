//TODO 

pragma solidity >=0.4.25 <0.6.0;

import "./StarMaster.sol";
import "./cards/RockMaster.sol";
import "./cards/ScissorsMaster.sol";
import "./cards/PaperMaster.sol";
import "./LeagueRegistry.sol";

contract GameOffice {

    event TwoPlayerGameStarted(
        address indexed gamer1,
        address indexed gamer2
    );

    Star private _star; //_coin
    Rock private _rock;
    Scissors private _scissors;
    Paper private _paper;
    LeagueRegistry private _leagueRegistry;
    

    constructor(address _starAddress, address _rockAddress, address _scissorsAddress, address _paperAddress, address _leagueAddress) public {
        _star = Star(_starAddress);
        _rock = Rock(_rockAddress);
        _scissors = Scissors(_scissorsAddress);
        _paper = Paper(_paperAddress);
        _leagueRegistry = LeagueRegistry(_leagueAddress);
    }

    //called from minter role
    function startTwoPlayerGame(address _gamer1, address _gamer2) public returns(bool) {

        require(_star.balanceOf(_gamer1) >= 1);
        require(_star.balanceOf(_gamer2) >= 1);
        
        emit TwoPlayerGameStarted(_gamer1, _gamer2);
    }
    
    //function announceTwoPlayerGameWinner(address _winner, address _loser)
}