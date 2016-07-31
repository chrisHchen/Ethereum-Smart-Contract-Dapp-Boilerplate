import Web3 from 'web3'
import { abi, provider, contractAddr, accountAddr, pass } from './abi'

const web3 = new Web3( new Web3.providers.HttpProvider(provider) )
const mutualContract = web3.eth.contract(abi).at(contractAddr)

// web3._extend({
//   property: 'personal',
//   methods: [new web3._extend.Method({
// 	   name: 'unlockAccount',
// 	   call: 'personal_unlockAccount',
// 	   params: 3,
// 	   inputFormatter: [web3._extend.utils.toAddress, web3._extend.utils.isString, web3._extend.utils.isBigNumber],
// 	   outputFormatter: web3._extend.utils.isBoolean
//   })]
// })


const join = ( req, res ) => {
	const participantId = req.body.participantId
	const balance = req.body.balance
	console.log(participantId, balance)

	web3.personal.unlockAccount(accountAddr, pass, 30)

	const txhash  = mutualContract.Join( 
										participantId, 
										balance, 
										{from: web3.eth.coinbase, gas:4000000}
									)
	console.log('transaction join is called~')

	if(txhash){
		res.end('join transaction success')
	}else{
		res.end('join transaction fail')
	}
}

const balanceEvent  = () => {
	const filter = mutualContract.BalanceEvent({ }, {fromBlock: 0, toBlock: 'latest'}, function(error, ret){
		if(error){
			console.log(error)
		}else{
			const { participantId, eventType, money } = ret.args
			console.log('BalanceEvent '+ participantId.toString(), eventType.toString(), money.toString())
		}
	})
}

const participantEvent  = () => {
	mutualContract.ParticipantEvent({ }, {fromBlock:0, toBlock:"latest"}).watch( function(error, ret){
		if(error){
			console.log(error)
		}else{
			const { participantId, eventType, currentParticipants } = ret.args
			console.log('ParticipantEvent '+ participantId.toString(), eventType.toString(), currentParticipants.toString() )
		}
	})
}

const filterPending = (res) => {
	const filter = web3.eth.filter('pending')
	filter.watch(function (error, log) {
  	console.log(log)
	})
}

export { join, balanceEvent, participantEvent, filterPending }