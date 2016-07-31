const abi = [{"constant":false,"inputs":[{"name":"participantId","type":"uint64"},{"name":"balance","type":"uint64"}],"name":"Join","outputs":[],"type":"function"},{"constant":false,"inputs":[{"name":"participantId","type":"uint64"}],"name":"Exit","outputs":[],"type":"function"},{"constant":false,"inputs":[{"name":"participantId","type":"uint64"},{"name":"money","type":"uint64"}],"name":"singleTransfer","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":false,"inputs":[{"name":"payeeId","type":"uint64"},{"name":"money","type":"uint64"}],"name":"Transfer","outputs":[],"type":"function"},{"constant":false,"inputs":[{"name":"participantId","type":"uint64"},{"name":"money","type":"uint64"}],"name":"TopUp","outputs":[],"type":"function"},{"constant":false,"inputs":[{"name":"participantId","type":"uint64"},{"name":"money","type":"uint64"}],"name":"Drawback","outputs":[],"type":"function"},{"inputs":[{"name":"insuranceId","type":"uint64"}],"type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"participantId","type":"uint64"},{"indexed":false,"name":"eventType","type":"uint8"},{"indexed":false,"name":"currentParticipants","type":"uint64"}],"name":"ParticipantEvent","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"participantId","type":"uint64[]"},{"indexed":false,"name":"eventType","type":"uint8"},{"indexed":false,"name":"money","type":"uint64"}],"name":"BalanceEvent","type":"event"}]

const provider = 'http://localhost:8545'

const contractAddr = '0x443417765b584c4182718cdc09cde3a029b57625'

const accountAddr = '0x173388a10858dbc7cce5f5b111bc7584909005de'

const pass = 'linxi66fan'

export { abi, provider, contractAddr, accountAddr, pass }