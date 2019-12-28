pragma solidity >=0.4.25 <0.6.0;
import "./AdminRole.sol";
import "./openZeppelin/token/ERC721/ERC721MetadataMintable.sol";
import "./openZeppelin/token/ERC721/ERC721Full.sol";

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
  ERC721 public rockToken;
  ERC721 public scissorToken;
  ERC721 public paperToken;
  ERC721 public starToken;

  constructor(
    address _rockToken,
    address _scissorsToken,
    address _paperToken,
    address _starToken
  ) public {
    rockToken = ERC721(_rockToken);
    scissorToken = ERC721(_scissorsToken);
    paperToken = ERC721(_paperToken);
    starToken = ERC721(_starToken);
  }

  function addLeague(uint256 _numberOfRocks, uint256 _numberOfScissors, uint256 _numberOfPapers, uint256 _numberOfStars) public onlyAdmin {
    LeagueInfo memory leagueInfo;
    leagueInfo.maxNumberOfRocks = _numberOfRocks;
    leagueInfo.maxNumberOfScissors = _numberOfScissors;
    leagueInfo.maxNumberOfPapers = _numberOfPapers;
    leagueInfo.maxNumberOfStars = _numberOfStars;
    leagues.push(leagueInfo);
  }

  function getLeagueInfoById(uint256 _leagueId) public view returns(uint256, uint256, uint256, uint256) {
    uint256 rocks = leagues[_leagueId].numberOfRocks;
    uint256 scissors = leagues[_leagueId].numberOfScissors;
    uint256 papers = leagues[_leagueId].numberOfPapers;
    uint256 stars = leagues[_leagueId].numberOfStars;
    return (rocks, scissors, papers, stars);
  }

  function getAvailableTokensForPurchase() public view returns(uint256) {
    LeagueInfo memory currentLeague = leagues[leagues.length - 1];
    return currentLeague.maxNumberOfRocks - currentLeague.currentRocksAvailable + currentLeague.maxNumberOfPapers - currentLeague.currentPapersAvailable + currentLeague.maxNumberOfScissors - currentLeague.currentScissorsAvailable;
  }

  // You need to send the msg.value where each card is 10 TRX so if you
  // set the quantity to 20, you must send 200 TRX or more
  // if you send more than the quantity, you lost that amount
  function buyCards(uint256 _cardsToBuy) public payable {
    require(msg.value >= _cardsToBuy * cardPrice, "You must send the right price price for the amount of cards you want to buy");
    require(leagues.length > 0, "There are no leagues available right now");
    require(getAvailableTokensForPurchase() > 0, "There are no tokens available for purchase on this league anymore");

    LeagueInfo memory currentLeague = leagues[leagues.length - 1];

    uint8 lastId = 0;
    uint256 generatedRocks = 0;
    uint256 generatedPapers = 0;
    uint256 generatedScissors = 0;

    // Mint the required tokens for each type alternating
    for (uint256 i = 0; i < _cardsToBuy.length; i++) {
      if (lastId == 0) {
        // Generate rocks
        if (currentLeague.currentRocksAvailable + generatedRocks < currentLeague.maxNumberOfRocks) {
          rockToken.mint(msg.sender);
          generatedRocks++;
          leagues[leagues.length - 1].currentRocksAvailable++;
        }
      } else if (lastId == 1) {
        // Generate papers
        if (currentLeague.currentPapersAvailable + generatedPapers < currentLeague.maxNumberOfPapers) {
          paperToken.mint(msg.sender);
          generatedPapers++;
          leagues[leagues.length - 1].currentPapersAvailable++;
        }
      } else {
        // Generate scissors
        if (currentLeague.currentScissorsAvailable + generatedScissors < currentLeague.maxNumberOfScissors) {
          scissorToken.mint(msg.sender);
          generatedScissors++;
          leagues[leagues.length - 1].currentScissorsAvailable++;
        }
      }

      if (lastId == 2) lastId = 0;
      else lastId++;
    }
  }
}
