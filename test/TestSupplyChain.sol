pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SupplyChain.sol";

contract TestSupplyChain {

 
    // Test for failing conditions in this contracts:
    // https://truffleframework.com/tutorials/testing-for-throws-in-solidity-tests
       
    SupplyChain supply = SupplyChain(DeployedAddresses.SupplyChain());
    uint public initialBalance = 2 ether;
    
    uint    price   = 10000;
    string  name    = "book";
    uint    sku     =0;
    uint    price1  = 20000;
    string  name1   = "chair";
    uint    sku1    =1;

  function () external payable{
    // This will NOT be executed when Ether is sent. \o/
  }
    // buyItem

    // test for failure if user does not send enough funds
    // test for purchasing an item that is not for Sale
    function testForFailureIfUserDoesNotSendEnoughFunds()public {

        bool r;
        supply.addItem(name,price);
       
        (r,)=address(supply).call.value(100)(abi.encodeWithSignature("buyItem(uint256)",sku));
        Assert.isFalse(r, "test for failure if user does not send enough funds");

       
  }
   function testForPurchasingAnItemThatIsNotForSale()public{
        
        bool r;

        (r,)=address(supply).call.value(price)(abi.encodeWithSignature("buyItem(uint256)",sku));

        (r,)=address(supply).call.value(price)(abi.encodeWithSignature("buyItem(uint256)",sku));
        Assert.isFalse(r, "test for purchasing an item that is not for Sale");
    } 

    // shipItem

    // test for calls that are made by not the seller
    // test for trying to ship an item that is not marked Sold
    function testForCallsThatAreMadeByNotTheSeller()public{
        bool r;

        (r,)=address(supply).delegatecall(abi.encodeWithSignature("shipItem(uint256)",sku));
        Assert.isFalse(r, "test for calls that are made by not the seller");

    }
    function testForTryingToShipAnItemThatIsNotMarkedSold()public{

        bool r;
        supply.addItem(name1,price1);

        (r,)=address(supply).call(abi.encodeWithSignature("shipItem(uint256)",sku1));
        Assert.isFalse(r, "test for trying to ship an item that is not marked Sold");

    }
    // receiveItem

    // test calling the function from an address that is not the buyer
    // test calling the function on an item not marked Shipped
    function testCallingTheFunctionFromAnAddressThatIsNotTheBuyer()public{

        bool r;
        
        (r,)=address(supply).call(abi.encodeWithSignature("shipItem(uint256)",sku));
        (r,)=address(supply).delegatecall(abi.encodeWithSignature("receiveItem(uint256)",sku));
        Assert.isFalse(r, "test calling the function from an address that is not the buyer");

    }
    function testCallingTheFunctionOnAnItemNotMarkedShipped()public{

        bool r;

        (r,)=address(supply).call(abi.encodeWithSignature("receiveItem(uint256)",sku1));
        Assert.isFalse(r, "test calling the function on an item not marked Shipped");

    }
}
