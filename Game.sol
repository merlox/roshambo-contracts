pragma solidity >=0.4.25 <0.6.0;
import "./AdminRole.sol";
import "./openZeppelin/token/ERC721/ERC721MetadataMintable.sol";

contract Scissors is ERC721Full, MinterRole {
  uint256 public counter;
  constructor() ERC721Full("Scissors", "Scissors") public {}
  // Create new tokens
  function mint(address _to) public onlyMinter {
    uint256 tokenId = counter;
    // The third parameter, the tokenURI with all the token metadatas is empty for now until some data is added in the future
    mintWithTokenURI(_to, tokenId, "");
    counter++;
    tokensOwned[to].push(tokenId);
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
        userTokens[i] = lastItem;
        userTokens.length--;
        break;
      }
    }
  }
}


contract Rocks is ERC721Full, MinterRole {
  uint256 public counter;
  constructor() ERC721Full("Rocks", "Rocks") public {}
  // Create new tokens
  function mint(address _to) public onlyMinter {
    uint256 tokenId = counter;
    // The third parameter, the tokenURI with all the token metadatas is empty for now until some data is added in the future
    mintWithTokenURI(_to, tokenId, "");
    counter++;
    tokensOwned[to].push(tokenId);
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
        userTokens[i] = lastItem;
        userTokens.length--;
        break;
      }
    }
  }
}


contract Papers is ERC721Full, MinterRole {
  uint256 public counter;
  mapping(address => uint256[]) public tokensOwned;

  constructor() ERC721Full("Papers", "Papers") public {}
  // Create new tokens
  function mint(address _to) public onlyMinter {
    uint256 tokenId = counter;
    // The third parameter, the tokenURI with all the token metadatas is empty for now until some data is added in the future
    mintWithTokenURI(_to, tokenId, "");
    counter++;
    tokensOwned[to].push(tokenId);
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
        userTokens[i] = lastItem;
        userTokens.length--;
        break;
      }
    }
  }
}


contract Game is AdminRole {
  struct LeagueInfo {
      uint256 numberOfRocks;
      uint256 numberOfScissors;
      uint256 numberOfPapers;
      uint256 numberOfStars;
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
    rockToken = _rockToken;
    scissorToken = _scissorsToken;
    paperToken = _paperToken;
    starToken = _starToken;
  }

  function addLeague(uint256 _numberOfRocks, uint256 _numberOfScissors, uint256 _numberOfPapers, uint256 _numberOfStars) public onlyAdmin {
    LeagueInfo memory leagueInfo;
    leagueInfo.numberOfRocks = _numberOfRocks;
    leagueInfo.numberOfScissors = _numberOfScissors;
    leagueInfo.numberOfPapers = _numberOfPapers;
    leagueInfo.numberOfStars = _numberOfStars;
    leagues.push(leagueInfo);
  }

  function getLeagueInfoById(uint256 _leagueId) public view returns(uint256, uint256, uint256, uint256) {
    uint256 rocks = leagues[_leagueId].numberOfRocks;
    uint256 scissors = leagues[_leagueId].numberOfScissors;
    uint256 papers = leagues[_leagueId].numberOfPapers;
    uint256 stars = leagues[_leagueId].numberOfStars;
    return (rocks, scissors, papers, stars);
  }

  // You need to send the msg.value where each card is 10 TRX so if you
  // set the quantity to 20, you must send 200 TRX or more. The remaining
  // will be refunded
  function buyCards(uint256 _quantity) public payable {
    require(msg.value >= _quantity * cardPrice, "You must send the right price price for the amount of cards you want to buy");
    // TODO mint the required tokens for each type alternating
  }
}
