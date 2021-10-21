
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Wallet {
   constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    // модификатор, подтверждающий сообщения, принадлежащие только владельцу кошелька
    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 100);
		tvm.accept();
		_;
	}

    // функция для отправки средств без оплаты комиссии за свой счёт
    function sendValueWithoutCommission(address dest, uint128 value) public pure checkOwnerAndAccept {
        dest.transfer(value, true, 0);
    }
}
