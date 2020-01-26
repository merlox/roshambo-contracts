import React, { useState, useEffect } from 'react'
import { render } from 'react-dom'
import TronWeb from 'tronweb'

const myAddress = "TNiVeT2TUDaKX1cjH6ejsj79aR2m1FUwJ8"
console.log('Game contract', GAME_CONTRACT)
const gameAddress = GAME_CONTRACT

window.tronWeb = new TronWeb({
  fullNode: 'https://api.shasta.trongrid.io',
  solidityNode: 'https://api.shasta.trongrid.io',
  eventServer: 'https://api.shasta.trongrid.io',
  privateKey: PRIVATE_KEY_SHASTA,
})
window.tronWeb.defaultAddress = {
  hex: window.tronWeb.address.toHex(myAddress),
  base58: myAddress
}

function App (props) {
  const [contract, setContract] = useState(null)
  const [rocks, setRocks] = useState(null)
  const [papers, setPapers] = useState(null)
  const [scissors, setScissors] = useState(null)
  const [stars, setStars] = useState(null)
  const [leagueId, setLeagueId] = useState(null)
  const [leagueData, setLeagueData] = useState(null)
  const [error, setError] = useState(null)
  const [cardsToBuy, setCardsToBuy] = useState(null)

  const deployLeague = async () => {
    setError(null)
    if (!rocks) alert("The rocks can't be zero")
    if (!papers) alert("The papers can't be zero")
    if (!scissors) alert("The scissors can't be zero")
    if (!stars) alert("The stars can't be zero")
    try {
      console.log('Adding a league...')
      await contract.addLeague(rocks, scissors, papers, stars).send()
      console.log('League added!')
    } catch (e) {
      console.log('Error', e)
    }
  }

  const getLeague = async () => {
    setError(null)
    console.log('Gettin league...')
    let l
    try {
      l = await contract.getLeagueInfoById(leagueId).call()
    } catch (e) {
      return setError("No league data found for that index")
    }
    setLeagueData({
      rocks: parseInt(l[0]._hex),
      scissors: parseInt(l[1]._hex),
      papers: parseInt(l[2]._hex),
      stars: parseInt(l[3]._hex),
      currentRocks: parseInt(l[4]._hex),
      currentPapers: parseInt(l[5]._hex),
      currentScissors: parseInt(l[6]._hex),
    })
  }

  const initContract = async () => {
    const con = await tronWeb.contract().at(gameAddress)
    setContract(con)
  }

  const buyCards = async () => {
    // Each card is 10 trx
    const cost = tronWeb.toSun(10) * cardsToBuy
    console.log("Buying cards... cost is:", cost)
    try {
      await contract.buyCards(cardsToBuy).send({
        callValue: cost
      })
    } catch (e) {
      return console.log("Error", e)
    }
    console.log("Cards purchased successfully!")
  }

  useEffect(() => {
    initContract()
  }, [])

  return (
    <div>
      <h1>Leagues</h1>
      <div>{error}</div>
      <h2>Deploy a new league</h2>
      <form onSubmit={e => {
        e.preventDefault()
        deployLeague()
      }}>
        <input type="number" placeholder="Number of rocks..." onChange={e => {
          setRocks(e.target.value)
        }}/>
        <input type="number" placeholder="Number of papers..." onChange={e => {
          setPapers(e.target.value)
        }}/>
        <input type="number" placeholder="Number of scissors..." onChange={e => {
          setScissors(e.target.value)
        }}/>
        <input type="number" placeholder="Number of stars..." onChange={e => {
          setStars(e.target.value)
        }}/>
        <button type="submit">Deploy new league</button>
      </form>
      <hr/>
      <h2>Get league</h2>
      <input type="number" placeholder="League ID..." onChange={e => {
        setLeagueId(e.target.value)
      }}/>
      {!leagueData ? null : (
        <div>
          <p>Rocks: {leagueData.rocks}</p>
          <p>Papers: {leagueData.papers}</p>
          <p>Scissors: {leagueData.scissors}</p>
          <p>Stars: {leagueData.stars}</p>
          <p>Current rocks: {leagueData.currentRocks}</p>
          <p>Current papers: {leagueData.currentPapers}</p>
          <p>Current scissors: {leagueData.currentScissors}</p>
        </div>
      )}
      <button type="button" onClick={() => {
        getLeague()
      }}>Get League</button>
      <h2>Buy cards</h2>
      <input type="number" placeholder="How many..." onChange={e => {
        setCardsToBuy(e.target.value)
      }}/>
      <button type="button" onClick={() => {
        buyCards()
      }}>Buy Cards</button>
    </div>
  )
}

render(<App />, document.querySelector('#root'))
