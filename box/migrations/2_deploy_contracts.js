require('dotenv-safe').config()
const Rocks = artifacts.require("Rocks")
const Scissors = artifacts.require("Scissors")
const Papers = artifacts.require("Papers")
const Stars = artifacts.require("Stars")
const Game = artifacts.require("Game")
const TronWeb = require('tronweb')
let rocks, scissors, papers, stars

const tronWeb = new TronWeb({
  fullNode: 'https://api.trongrid.io',
  solidityNode: 'https://api.trongrid.io',
  eventServer: 'https://api.trongrid.io',
  privateKey: process.env.PRIVATE_KEY_MAINNET,
})

module.exports = deployer => {
  // Without set immediate it doesn't deploy the first contract properly for no reason
  setImmediate(async () => {
    papers = await deployer.deploy(Papers)
    scissors = await deployer.deploy(Scissors)
    rocks = await deployer.deploy(Rocks)
    stars = await deployer.deploy(Stars)

    const game = await deployer.deploy(
      Game,
      rocks.address,
      scissors.address,
      papers.address,
      stars.address,
    )

    const p = await tronWeb.contract().at(papers.address)
    const s = await tronWeb.contract().at(scissors.address)
    const r = await tronWeb.contract().at(rocks.address)
    const st = await tronWeb.contract().at(stars.address)

    await p.addMinter(game.address).send()
    await s.addMinter(game.address).send()
    await r.addMinter(game.address).send()
    await st.addMinter(game.address).send()
  })
}
