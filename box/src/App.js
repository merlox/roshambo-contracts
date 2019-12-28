import React, { useState, useEffect } from 'react'
import { render } from 'react-dom'
import TronWeb from 'tronweb'

const myAddress = "TNiVeT2TUDaKX1cjH6ejsj79aR2m1FUwJ8"
const contractAddress = "TWFE5dzwT1PkNfMWhJGWNDC1YsqGVibuj6"

const rockAddress = "TVhUVnqndNEK1dZwVLKYFW9QBunn9PH1N2"
const scissorAddress = "TFvXeAioWKiqfuKBStRy9eoCPs7swiA1Wf"
const paperAddress = "TF5fvxHpp6NXfVPdR7Wcx1iZ6arTJ9cxpj"
const starAddress = "TJwTrXpd9edoXJwb5hWtim2sJoZHsp8EEW"

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
      setError("No league data found for that index")
    }

    setLeagueData({
      rocks: parseInt(l[0]._hex),
      scissors: parseInt(l[1]._hex),
      papers: parseInt(l[2]._hex),
      stars: parseInt(l[3]._hex),
    })
  }

  const initContract = async () => {
    const con = await tronWeb.contract().at(contractAddress)
    setContract(con)
  }

  const tryMint = async () => {
    const paperContract = await tronWeb.contract().at(paperAddress)
    await paperContract.mint(myAddress).send()
    const map = await paperContract.getAllUserTokens(myAddress).call()
  }

  const tryBurn = async () => {
    const paperContract = await tronWeb.contract().at(paperAddress)
    await paperContract.burn(2).send()
    const map = await paperContract.getAllUserTokens(myAddress).call()
  }

  useEffect(() => {
    initContract()
    tryBurn()
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
        </div>
      )}
      <button type="button" onClick={() => {
        getLeague()
      }}>Get league</button>
    </div>
  )
}

render(<App />, document.querySelector('#root'))
