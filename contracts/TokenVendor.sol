// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./Token.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenVendor is Ownable {
    Token _token;
    uint256 public _parity = 100; // - 100 tkn = 1 eth

    event PurchasedToken(address buyer, uint256 ethAmount, uint256 tknAmount);
    event SoldToken(address vendedor, uint256 tknAmount, uint256 ethAmount);

    constructor(address tokenAddress) {
        _token = Token(tokenAddress);
    }

    modifier onlyValidAmountOfETH()
    {
        require(msg.value > 0, "quantidade de ETH insuficiente");
        _;
    }

    modifier onlyValidAmountOfTKN()
    {
        uint256 vendorBalance = _token.balanceOf(address(this));
        require(vendorBalance > 0, "quantidade de TKN insuficiente");
        _;
    }

    modifier onlyValidTokenBalance(uint amount)
    {
        uint256 userBalance = _token.balanceOf(msg.sender);
        require(userBalance >= amount,"saldo inferior a quantidade de tokens que desaja vender");
        _;
    }

    modifier onlyValidBalance()
    {
        uint256 saldoDono = address(this).balance;
        require(saldoDono > 0, "sem saldo para saque");
        _;
    }

    function buy( )
        public
        payable
        onlyValidAmountOfETH()
        onlyValidAmountOfTKN()
        returns (uint256)
    {
        // require(msg.value > 0, "quantidade de ETH insuficiente");

        uint256 amountToBuy = msg.value * _parity;
        uint256 vendorBalance = _token.balanceOf(address(this));

        require(vendorBalance >= amountToBuy, "saldo do distribuidor insuficiente");

        (bool sent) = _token.transfer(msg.sender, amountToBuy);
        require(sent, "falha ao transferir tokens");

         emit PurchasedToken(msg.sender, msg.value, amountToBuy);

         return amountToBuy;
    }

    function sell
    (
        uint256 amount
    )
        public
        onlyValidAmountOfTKN()
        onlyValidTokenBalance(amount)
    {
        // require(quantidade > 0, "quantidade insuficiente");

        // uint256 userBalance = _token.balanceOf(msg.sender);
        // require(userBalance >= amount,"saldo inferior a quantidade de tokens que desaja vender");

        uint256 amountOfETHToTransfer = amount / _parity;
        uint256 ownerETHBalance = address(this).balance;
        require(ownerETHBalance >= amountOfETHToTransfer, "Distribuidor nao possui fundos suficiente para aceitar sua requisicao");

        (bool sent) = _token.transferFrom(msg.sender, address(this), amount);
        require(sent, "falha ao transferir TKN do usuario para o distribuidor");

        (sent,) = msg.sender.call{value: amountOfETHToTransfer}("");
        require(sent, "Failed to send ETH to the user");        
    }

    function withdraw()
        public
        onlyOwner
        onlyValidBalance()
    {
        // uint256 saldoDono = address(this).balance;
        // require(saldoDono > 0, "sem saldo para saque");

        (bool sent,) = msg.sender.call{value: address(this).balance}("");
        require(sent, "falha ao realizar saque");
    }    
}