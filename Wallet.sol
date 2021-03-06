
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Wallet {
   constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    // модификатор, который подтверждает сообщения только от владельца кошелька
    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 100);
        tvm.accept();
        _;
    }

    // функция для отправки средств без оплаты комиссии за свой счёт
    function sendValueWithoutCommission(address dest, uint128 value) public pure checkOwnerAndAccept {
        dest.transfer(value, true, 0);  // flag = 0 (forward fee is subtracted from parameter value)
    }

    // функция для отправки средств с оплатой комиссии за свой счёт
    function sendValueWithCommission(address dest, uint128 value) public pure checkOwnerAndAccept {
        dest.transfer(value, true, 1);  //  flag = 1 (sender pays transfer fees separately from contract's balance)
    }

    // функция для отправки всех средств и уничтожения кошелька
    function sendAllValueAndDestroyWallet(address dest) public pure checkOwnerAndAccept {
        dest.transfer(0, true, 160);  //  flag = 160 (send all balance and destroy the contract)
    }
}
