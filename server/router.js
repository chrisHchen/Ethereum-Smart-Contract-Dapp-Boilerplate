import { join, exit, topUp, drawback, transfer, getParticipantsAmount, balanceEvent, participantEvent } from './mutual'
export default function(app){
	//pre handler
	app.use( (req, res, next) => {
		if( req ){
			console.log('incoming request~')
			return next()
		}
		next()
	})

	app.post('/mutual/join/:appId', join)
	app.post('/mutual/exit/:appId', exit)
	app.post('/mutual/topUp/:appId', topUp)
	app.post('/mutual/drawback/:appId', drawback)
	app.post('/mutual/transfer/:appId', transfer)
	app.get('/mutual/getParticipantsAmount/:appId', getParticipantsAmount)
	
	balanceEvent()
	participantEvent()
}