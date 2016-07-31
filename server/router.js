import { join, balanceEvent, participantEvent, filterPending } from './mutual'
export default function(app){
	//pre handler
	app.use( (req, res, next) => {
		if( req ){
			console.log('incoming request~')
			return next()
		}
		next()
	})

	app.post('/mutual/join', join)
	
	balanceEvent()
	participantEvent()
	filterPending()
}