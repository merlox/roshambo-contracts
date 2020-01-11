pragma solidity >=0.4.25 <0.6.0;
import "./AdminRole.sol";
import "./openZeppelin/token/ERC721/ERC721MetadataMintable.sol";
import "./openZeppelin/token/ERC721/ERC721Full.sol";

contract IToken {
  function mint(address _to) public;
  function burn(uint256 tokenId) public;
  function getAllUserTokens(address _user) public view returns (uint256[] memory);
}

contract Scissors is ERC721Full, MinterRole, ERC721MetadataMintable {
  uint256 public counter;
  mapping(address => uint256[]) public tokensOwned;

  constructor() ERC721Full("Scissors", "Scissors") public {}
  // Create new tokens
  function mint(address _to) public onlyMinter {
    uint256 tokenId = counter;
    // The third parameter, the tokenURI with all the token metadatas is empty for now until some data is added in the future
    mintWithTokenURI(_to, tokenId, "");
    counter++;
    tokensOwned[_to].push(tokenId);
  }
  // Burn the specified token
  function burn(uint256 tokenId) public {
    address owner = ownerOf(tokenId);
    require(_isApprovedOrOwner(owner, tokenId), "ERC721Burnable: caller is not owner nor approved");
    _burn(tokenId);
    counter--;
    // Find the specific token id and delete it from the array
    uint256[] memory userTokens = tokensOwned[owner];
    for(uint256 i = 0; i < userTokens.length; i++) {
      uint256 tok = userTokens[i];
      if (tok == tokenId) {
        uint256 lastItem = userTokens[userTokens.length - 1];
        tokensOwned[owner][i] = lastItem;
        tokensOwned[owner].length--;
        break;
      }
    }
  }
  // Returns all the user tokens
  function getAllUserTokens(address _user) public view returns (uint256[] memory) {
    return tokensOwned[_user];
  }
}


contract Rocks is ERC721Full, MinterRole, ERC721MetadataMintable {
  uint256 public counter;
  mapping(address => uint256[]) public tokensOwned;

  constructor() ERC721Full("Rocks", "Rocks") public {}
  // Create new tokens
  function mint(address _to) public onlyMinter {
    uint256 tokenId = counter;
    // The third parameter, the tokenURI with all the token metadatas is empty for now until some data is added in the future
    mintWithTokenURI(_to, tokenId, "");
    counter++;
    tokensOwned[_to].push(tokenId);
  }
  // Burn the specified token
  function burn(uint256 tokenId) public {
    address owner = ownerOf(tokenId);
    require(_isApprovedOrOwner(owner, tokenId), "ERC721Burnable: caller is not owner nor approved");
    _burn(tokenId);
    counter--;
    // Find the specific token id and delete it from the array
    uint256[] memory userTokens = tokensOwned[owner];
    for(uint256 i = 0; i < userTokens.length; i++) {
      uint256 tok = userTokens[i];
      if (tok == tokenId) {
        uint256 lastItem = userTokens[userTokens.length - 1];
        tokensOwned[owner][i] = lastItem;
        tokensOwned[owner].length--;
        break;
      }
    }
  }
  // Returns all the user tokens
  function getAllUserTokens(address _user) public view returns (uint256[] memory) {
    return tokensOwned[_user];
  }
}


contract Papers is ERC721Full, MinterRole, ERC721MetadataMintable {
  uint256 public counter;
  mapping(address => uint256[]) public tokensOwned;

  constructor() ERC721Full("Papers", "Papers") public {}
  // Create new tokens
  function mint(address _to) public onlyMinter {
    uint256 tokenId = counter;
    // The third parameter, the tokenURI with all the token metadatas is empty for now until some data is added in the future
    mintWithTokenURI(_to, tokenId, "");
    counter++;
    tokensOwned[_to].push(tokenId);
  }
  // Burn the specified token
  function burn(uint256 tokenId) public {
    address owner = ownerOf(tokenId);
    require(_isApprovedOrOwner(owner, tokenId), "ERC721Burnable: caller is not owner nor approved");
    _burn(tokenId);
    counter--;
    // Find the specific token id and delete it from the array
    uint256[] memory userTokens = tokensOwned[owner];
    for(uint256 i = 0; i < userTokens.length; i++) {
      uint256 tok = userTokens[i];
      if (tok == tokenId) {
        uint256 lastItem = userTokens[userTokens.length - 1];
        tokensOwned[owner][i] = lastItem;
        tokensOwned[owner].length--;
        break;
      }
    }
  }

  // Returns all the user tokens
  function getAllUserTokens(address _user) public view returns (uint256[] memory) {
    return tokensOwned[_user];
  }
}


contract Stars is ERC721Full, MinterRole, ERC721MetadataMintable {
  uint256 public counter;
  mapping(address => uint256[]) public tokensOwned;

  constructor() ERC721Full("Stars", "Stars") public {}
  // Create new tokens
  function mint(address _to) public onlyMinter {
    uint256 tokenId = counter;
    // The third parameter, the tokenURI with all the token metadatas is empty for now until some data is added in the future
    mintWithTokenURI(_to, tokenId, "");
    counter++;
    tokensOwned[_to].push(tokenId);
  }
  // Burn the specified token
  function burn(uint256 tokenId) public {
    address owner = ownerOf(tokenId);
    require(_isApprovedOrOwner(owner, tokenId), "ERC721Burnable: caller is not owner nor approved");
    _burn(tokenId);
    counter--;
    // Find the specific token id and delete it from the array
    uint256[] memory userTokens = tokensOwned[owner];
    for(uint256 i = 0; i < userTokens.length; i++) {
      uint256 tok = userTokens[i];
      if (tok == tokenId) {
        uint256 lastItem = userTokens[userTokens.length - 1];
        tokensOwned[owner][i] = lastItem;
        tokensOwned[owner].length--;
        break;
      }
    }
  }
  // Returns all the user tokens
  function getAllUserTokens(address _user) public view returns (uint256[] memory) {
    return tokensOwned[_user];
  }
}


contract Game is AdminRole {
  event SeeValue(uint256 val, string des);
  event Msg(string des);

  struct LeagueInfo {
      uint256 maxNumberOfRocks;
      uint256 maxNumberOfScissors;
      uint256 maxNumberOfPapers;
      uint256 maxNumberOfStars;
      uint256 currentRocksAvailable; // These are 0 by default
      uint256 currentPapersAvailable;
      uint256 currentScissorsAvailable;
      uint256 currentStarsAvailable;
  }
  //LeagueId => LeagueInfo
  LeagueInfo[] public leagues;
  uint256 public cardPrice = 10 trx; // Each card costs 10 TRX
  IToken public rockToken;
  IToken public scissorToken;
  IToken public paperToken;
  IToken public starToken;
  address payable public owner;

  constructor(
    address _rockToken,
    address _scissorsToken,
    address _paperToken,
    address _starToken
  ) public {
    rockToken = IToken(_rockToken);
    scissorToken = IToken(_scissorsToken);
    paperToken = IToken(_paperToken);
    starToken = IToken(_starToken);
    owner = msg.sender;
  }

  function addLeague(uint256 _numberOfRocks, uint256 _numberOfScissors, uint256 _numberOfPapers, uint256 _numberOfStars) public onlyAdmin {
    LeagueInfo memory leagueInfo;
    leagueInfo.maxNumberOfRocks = _numberOfRocks;
    leagueInfo.maxNumberOfScissors = _numberOfScissors;
    leagueInfo.maxNumberOfPapers = _numberOfPapers;
    leagueInfo.maxNumberOfStars = _numberOfStars;
    leagues.push(leagueInfo);
  }

  function getLeagueInfoById(uint256 _leagueId) public view returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
    return (
      leagues[_leagueId].maxNumberOfRocks,
      leagues[_leagueId].maxNumberOfScissors,
      leagues[_leagueId].maxNumberOfPapers,
      leagues[_leagueId].maxNumberOfStars,
      leagues[_leagueId].currentRocksAvailable,
      leagues[_leagueId].currentPapersAvailable,
      leagues[_leagueId].currentScissorsAvailable);
  }

  // Returns the in use papers, rocks and scissors or throws if no league exists
  function getLatestLeagueInfo() public view returns (uint256, uint256, uint256) {
    require(leagues.length > 0, "There are no leagues available right now");
    LeagueInfo memory currentLeague = leagues[leagues.length - 1];
    return (
      currentLeague.currentRocksAvailable,
      currentLeague.currentPapersAvailable,
      currentLeague.currentScissorsAvailable
    );
  }

  function getAvailableTokensForPurchase() public view returns(uint256) {
    LeagueInfo memory currentLeague = leagues[leagues.length - 1];
    return currentLeague.maxNumberOfRocks - currentLeague.currentRocksAvailable + currentLeague.maxNumberOfPapers - currentLeague.currentPapersAvailable + currentLeague.maxNumberOfScissors - currentLeague.currentScissorsAvailable;
  }

  function buyRocks(uint256 _cardsToBuy) public payable {
    require(msg.value >= _cardsToBuy * cardPrice, "You must send the right price price for the amount of cards you want to buy");
    require(leagues.length > 0, "There are no leagues available right now");
    require(leagues[leagues.length - 1].currentRocksAvailable < leagues[leagues.length - 1].maxNumberOfRocks, "No rocks available for purchase in this league anymore");

    for (uint256 i = 0; i < _cardsToBuy; i++) {
      rockToken.mint(msg.sender);
      leagues[leagues.length - 1].currentRocksAvailable++;
    }
  }

  function buyPapers(uint256 _cardsToBuy) public payable {
    require(msg.value >= _cardsToBuy * cardPrice, "You must send the right price price for the amount of cards you want to buy");
    require(leagues.length > 0, "There are no leagues available right now");
    require(leagues[leagues.length - 1].currentPapersAvailable < leagues[leagues.length - 1].maxNumberOfPapers, "No papers available for purchase in this league anymore");

    for (uint256 i = 0; i < _cardsToBuy; i++) {
      paperToken.mint(msg.sender);
      leagues[leagues.length - 1].currentPapersAvailable++;
    }
  }

  function buyScissors(uint256 _cardsToBuy) public payable {
    require(msg.value >= _cardsToBuy * cardPrice, "You must send the right price price for the amount of cards you want to buy");
    require(leagues.length > 0, "There are no leagues available right now");
    require(leagues[leagues.length - 1].currentScissorsAvailable < leagues[leagues.length - 1].maxNumberOfScissors, "No scissors available for purchase in this league anymore");

    for (uint256 i = 0; i < _cardsToBuy; i++) {
      scissorToken.mint(msg.sender);
      leagues[leagues.length - 1].currentScissorsAvailable++;
    }
  }

  // You need to send the msg.value where each card is 10 TRX so if you
  // set the quantity to 20, you must send 200 TRX or more
  // if you send more than the quantity, you lost that amount
  function buyCards(uint256 _cardsToBuy) public payable {
    require(msg.value >= _cardsToBuy * cardPrice, "You must send the right price price for the amount of cards you want to buy");
    require(leagues.length > 0, "There are no leagues available right now");
    require(getAvailableTokensForPurchase() > 0, "There are no tokens available for purchase on this league anymore");

    emit Msg("1");

    uint8 lastId = 0;
    // Mint the required tokens for each type alternating
    for (uint256 i = 0; i < _cardsToBuy; i++) {
      emit Msg("2");
      if (lastId == 0) {
        emit Msg("3");
        if (leagues[leagues.length - 1].currentRocksAvailable < leagues[leagues.length - 1].maxNumberOfRocks) {
          mintRocks();
          emit Msg("4");
        } else if (leagues[leagues.length - 1].currentPapersAvailable < leagues[leagues.length - 1].maxNumberOfPapers) {
          mintPapers();
          emit Msg("5");
        } else if (leagues[leagues.length - 1].currentScissorsAvailable < leagues[leagues.length - 1].maxNumberOfScissors) {
          mintScissors();
          emit Msg("6");
        } else {
          emit Msg("7");
          // No more cards available anymore
          break;
        }
      } else if (lastId == 1) {
        emit Msg("8");
        if (leagues[leagues.length - 1].currentPapersAvailable < leagues[leagues.length - 1].maxNumberOfPapers) {
          mintPapers();
          emit Msg("9");
        } else if (leagues[leagues.length - 1].currentRocksAvailable < leagues[leagues.length - 1].maxNumberOfRocks) {
          mintRocks();
          emit Msg("10");
        } else if (leagues[leagues.length - 1].currentScissorsAvailable < leagues[leagues.length - 1].maxNumberOfScissors) {
          mintScissors();
          emit Msg("11");
        } else {
          // No more cards available anymore
          emit Msg("12");
          break;
        }
      } else {
        emit Msg("13");
        if (leagues[leagues.length - 1].currentScissorsAvailable < leagues[leagues.length - 1].maxNumberOfScissors) {
          mintScissors();
          emit Msg("14");
        } else if (leagues[leagues.length - 1].currentPapersAvailable < leagues[leagues.length - 1].maxNumberOfPapers) {
          mintPapers();
          emit Msg("15");
        } else if (leagues[leagues.length - 1].currentRocksAvailable < leagues[leagues.length - 1].maxNumberOfRocks) {
          mintRocks();
          emit Msg("16");
        } else {
          // No more cards available anymore
          emit Msg("17");
          break;
        }
      }
      emit Msg("18");
      if (lastId == 2) lastId = 0;
      else lastId++;
    }
  }

  // Returns the array of owned card for each type
  function getMyCards() public view returns(uint256[] memory, uint256[] memory, uint256[] memory) {
    uint256[] memory rocks = rockToken.getAllUserTokens(msg.sender);
    uint256[] memory papers = paperToken.getAllUserTokens(msg.sender);
    uint256[] memory scissors = scissorToken.getAllUserTokens(msg.sender);
    return (rocks, papers, scissors);
  }

  function mintRocks() internal {
    rockToken.mint(msg.sender);
    leagues[leagues.length - 1].currentRocksAvailable++;
  }

  function mintPapers() internal {
    paperToken.mint(msg.sender);
    leagues[leagues.length - 1].currentPapersAvailable++;
  }

  function mintScissors() internal {
    scissorToken.mint(msg.sender);
    leagues[leagues.length - 1].currentScissorsAvailable++;
  }

  function deleteCard(address _user, string memory _cardType) public onlyAdmin returns (bool) {
    if (keccak256(abi.encode(_cardType)) == keccak256(abi.encode("Rock"))) {
      uint256[] memory userRocks = rockToken.getAllUserTokens(_user);
      if (userRocks.length > 0) {
        rockToken.burn(userRocks[0]);
        return true;
      } else {
        return false;
      }
    } else if (keccak256(abi.encode(_cardType)) == keccak256(abi.encode("Paper"))) {
      uint256[] memory userPapers = paperToken.getAllUserTokens(_user);
      if (userPapers.length > 0) {
        paperToken.burn(userPapers[0]);
        return true;
      } else {
        return false;
      }
    } else if (keccak256(abi.encode(_cardType)) == keccak256(abi.encode("Scissors"))) {
      uint256[] memory userScissors = scissorToken.getAllUserTokens(_user);
      if (userScissors.length > 0) {
        scissorToken.burn(userScissors[0]);
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  function extractFunds() public {
    require(msg.sender == owner);
    owner.transfer(address(this).balance);
  }
}
