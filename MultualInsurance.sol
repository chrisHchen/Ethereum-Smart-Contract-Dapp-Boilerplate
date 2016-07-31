contract MutualInsurance {
    
    /**
     * 当前互助产品唯一标识
     */
    uint64 InsuranceId;
    
    /**
     * 当前人数
     */
    uint64 ParticipantsAmount;
    
    /**
     * 参数人集合
     */
    mapping(uint64 => Participant) participants;
    
    uint64[] participantsIndex;
    
    /**
     * 参与人交易集合
     */
    mapping(uint64 => Transaction[]) transactions;
    
    /**
     * 枚举，金额变动类型，
     *  TopUp：充值
     *  Transfer：交易，即互助
     *  Drawback：退款
     */
    uint8 constant BalanceTopUp = 1;
    uint8 constant BalanceReceive = 2;
    uint8 constant BalanceTransfer = 3;
    uint8 constant BalanceDrawback = 4;
    
    /**
     * 枚举，参与人变动类型，
     *  ParticipantJoin：参加
     *  ParticipantExit：退出
     */
    uint8 constant ParticipantJoin = 1;
    uint8 constant ParticipantExit = 2;
    
    struct Participant {
        uint64 balance;
        uint64 transactionAmount;
    }
    
    struct Transaction {
        uint64 amount;
        uint8 txType;
        uint timestamp;
    }

    event ParticipantEvent(uint64 participantId, uint8 eventType, uint64 currentParticipants);
    event BalanceEvent(uint64[] participantId, uint8 eventType, uint64 money);
    
    function MutualInsurance(uint64 insuranceId) {
        InsuranceId = insuranceId;
    }
    
    /**
     * 新成员加入
     */
    function Join(uint64 participantId, uint64 balance) {
        /*if (participants[participantId].transactionAmount == 0) {
            throw;
        }*/
        var participant = Participant({
            balance: balance,
            transactionAmount: 1
        });
        participants[participantId] = participant;
        transactions[participantId].push(Transaction(balance, BalanceTopUp, now));
        ParticipantsAmount++;
        
        participantsIndex.push(participantId);
        
        ParticipantEvent(participantId, ParticipantJoin, ParticipantsAmount);
        
        var participantIds = new uint64[](1);
        participantIds[0] = participantId;
        BalanceEvent(participantIds, BalanceTopUp, balance);
    }
    
    /**
     * 成员退出
     */
    function Exit(uint64 participantId) {
        if (participants[participantId].transactionAmount == 0) {
            throw;
        }
        
        if (participants[participantId].balance != 0) {
            // drawback
            var participantIds = new uint64[](1);
            participantIds[0] = participantId;
            BalanceEvent(participantIds, BalanceDrawback, participants[participantId].balance);
        }
        
        for (var i = 0; i < ParticipantsAmount; i++) {
            if (participantsIndex[i] == participantId) {
                delete participantsIndex[i];
                break;
            }
        }
        delete participants[participantId];
        delete transactions[participantId];
        
        ParticipantsAmount--;
        
        ParticipantEvent(participantId, ParticipantExit, ParticipantsAmount);
    }
    
    /**
     * 充值
     */
    function TopUp(uint64 participantId, uint64 money) {
        if (participants[participantId].transactionAmount == 0) {
            throw;
        }
        participants[participantId].transactionAmount++;
        participants[participantId].balance += money;
        
        transactions[participantId].push(Transaction({
            amount: money,
            txType: BalanceTopUp,
            timestamp: now
        }));
        
        var participantIds = new uint64[](1);
        participantIds[0] = participantId;
        BalanceEvent(participantIds, BalanceTopUp, money);
    }
    
    /**
     * 退款
     */
    function Drawback(uint64 participantId, uint64 money) {
        /*if (participants[participantId].transactionAmount == 0) {
            throw;
        }*/
        participants[participantId].transactionAmount++;
        participants[participantId].balance -= money;
        
        transactions[participantId].push(Transaction({
            amount: money,
            txType: BalanceDrawback,
            timestamp: now
        }));
        
        var participantIds = new uint64[](1);
        participantIds[0] = participantId;
        BalanceEvent(participantIds, BalanceDrawback, money);
    }
    
    /**
     * 互助
     */
    function Transfer(uint64 payeeId, uint64 money) {
        /*if (participants[payeeId].transactionAmount == 0) {
            throw;
        }*/
        var payers = new uint64[](ParticipantsAmount - 1);
        for (var i = 0; i < ParticipantsAmount; i++) {
            uint64 participantId = participantsIndex[i];
            if (participantId == payeeId) {
                continue;
            }
            
            if (!singleTransfer(participantId, money)) {
                throw;
            }
            payers[i] = participantId;
        }
        
        uint64 receiveMoney = money * (ParticipantsAmount - 1);
        participants[payeeId].balance += receiveMoney;
        participants[payeeId].transactionAmount++;
        transactions[payeeId].push(Transaction({
            amount: receiveMoney,
            txType: BalanceReceive,
            timestamp: now
        }));
        
        var payee = new uint64[](1);
        payee[0] = payeeId;
        BalanceEvent(payee, BalanceReceive, receiveMoney);
        
        BalanceEvent(payers, BalanceTransfer, money);
    }
    
    function singleTransfer(uint64 participantId, uint64 money) returns (bool) {
        if (participants[participantId].balance < money) {
            return false;
        }
        participants[participantId].balance -= money;
        participants[participantId].transactionAmount++;
        
        transactions[participantId].push(Transaction({
            amount: money,
            txType: BalanceTransfer,
            timestamp: now
        }));
        return true;
    }
}