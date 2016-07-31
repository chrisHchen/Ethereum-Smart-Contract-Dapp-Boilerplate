import Web3 from 'web3'
import { abi, provider, contractAddr, accountAddr, pass, notifyUrl } from './abi'

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

//join
const join = ( req, res ) => {
	const participantId = req.body.participantId
	const balance = req.body.balance
	const appId = req.params.appId

	console.log(participantId, balance, appId)

	web3.personal.unlockAccount(accountAddr, pass, 30)

	const txhash  = mutualContract.Join( 
										participantId, 
										balance, 
										{from: web3.eth.coinbase, gas:4000000}
									)
	console.log('transaction Join is called~')

	if(txhash){
		res.end('Join success~')
	}else{
		res.end('Join failed!')
	}
}

//exit
const exit = (req, res) => {
	const participantId = req.body.participantId
	const money = req.body.money
	web3.personal.unlockAccount(accountAddr, pass, 30)

	const txhash  = mutualContract.Exit( 
										participantId,
										{from: web3.eth.coinbase, gas:4000000}
									)
	console.log('transaction Exit is called~')
	if(txhash){
		res.end('Exit success~')
	}else{
		res.end('Exit failed!')
	}
}

//topup
const topUp = (req, res) => {
	const participantId = req.body.participantId
	web3.personal.unlockAccount(accountAddr, pass, 30)

	const txhash  = mutualContract.TopUp( 
										participantId,
										money,
										{from: web3.eth.coinbase, gas:4000000}
									)
	console.log('transaction topUp is called~')
	if(txhash){
		res.end('topUp success~')
	}else{
		res.end('topUp failed!')
	}
}

//Drawback
const drawback = (req, res) => {
	const participantId = req.body.participantId
	web3.personal.unlockAccount(accountAddr, pass, 30)

	const txhash  = mutualContract.Drawback( 
										participantId,
										money,
										{from: web3.eth.coinbase, gas:4000000}
									)
	console.log('transaction drawback is called~')
	if(txhash){
		res.end('drawback success~')
	}else{
		res.end('drawback failed!')
	}
}

//Transfer
const transfer = (req, res) => {
	const participantId = req.body.participantId
	web3.personal.unlockAccount(accountAddr, pass, 30)

	const txhash  = mutualContract.Transfer( 
										participantId,
										money,
										{from: web3.eth.coinbase, gas:4000000}
									)
	console.log('transaction transfer is called~')
	if(txhash){
		res.end('transfer success~')
	}else{
		res.end('transfer failed!')
	}
}

const getParticipantsAmount = (req, res) => {
	//to be done
	console.log('getParticipantsAmount is called~')
	return res.end(mutualContract.ParticipantsAmount)
}

const balanceEvent  = () => {
	const filter = mutualContract.BalanceEvent({ }, 'pending', function(error, ret){
		if(error){
			console.log(error)
		}else{
			const { participantId, eventType, money } = ret.args
			console.log('BalanceEvent '+ participantId.toString(), eventType.toString(), money.toString())
			console.log('balanceEvent notify sent to: ' + notifyUrl)
		}
	})
}

const participantEvent  = () => {
	mutualContract.ParticipantEvent({ },  'pending').watch( function(error, ret){
		if(error){
			console.log(error)
		}else{
			const { participantId, eventType, currentParticipants } = ret.args
			console.log('ParticipantEvent '+ participantId.toString(), eventType.toString(), currentParticipants.toString() )
			console.log('participantEvent notify sent to: ' + notifyUrl)
		}
	})
}

// const filterPending = (res) => {
// 	const filter = web3.eth.filter('pending')
// 	filter.watch(function (error, log) {
//   	console.log(log)
// 	})
// }

export { join, exit, topUp, drawback, transfer, getParticipantsAmount, balanceEvent, participantEvent }