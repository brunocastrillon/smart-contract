// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract PaymentStage is Ownable {
    enum Stages {
        CREATION,
        SIGN,
        RUNNING,
        FINISH
    }

    Stages public _stage = Stages.CREATION;

    modifier atStage(Stages stage) {
        require(_stage == stage, "funcao nao pode ser chamada nesse estagio");
        _;
    }

    function setStage(Stages stage) internal {
        _stage = stage;
    }

    function destruct() internal {
        selfdestruct(payable(owner()));
    }
}