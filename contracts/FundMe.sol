// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

// Get the latest ETH/USD price from chainlink price feed

// IMPORTANT: This contract has been updated to use the Goerli testnet
// Please see: https://docs.chain.link/docs/get-the-latest-price/
// For more information

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe {
    // safe math是一个库，库的作用直接使用 uint256 类型，并且自动继承了SafeMathChainlink 库中的安全数学函数
    using SafeMathChainlink for uint256;

    //映射地址和数字类型
    mapping(address => uint256) public addressToAmountFunded;
    // 创建地址数组funders
    address[] public funders;
    //定义地址类型owner
    address public owner;

    //constructor在一个合约中只能用一次用于初始化合约一些值
    constructor() public {
        //初始化合约的拥有者
        owner = msg.sender;
    }

    function fund() public payable {
        //定义一个uint类型并且赋值一个数
        uint256 minimumUSD = 50 * 10**18;
        //果然发送者发送eth小于minimumUSD则报错回滚
        require(
            getConversionRate(msg.value) >= minimumUSD,
            "You need to spend more ETH!"
        );
        //当前交易发送者发送的以太币数量加到 addressToAmountFunded 映射中与当前发送者地址关联的值上
        addressToAmountFunded[msg.sender] += msg.value;
        //将该发送者的地址添加进入数组funders
        funders.push(msg.sender);
    }

    //getVersion() 函数用于查询指定地址的预言机合约的版本号，并返回该版本号
    //实现了对 AggregatorV3Interface 接口
    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
        return priceFeed.version();
    }
    //获得AggregatorV3Interface接口，调用latestRoundData函数获取最新的answer数据并且返回
    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        // ETH/USD rate in 18 digit
        return uint256(answer * 10000000000);
    }

    // getConversionRate() 函数用于计算给定以太币数量的等值美元金额，并返回该金额
    function getConversionRate(uint256 ethAmount)
        public
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        //将计算得到的等值美元金额返回作为函数的结果
        return ethAmountInUsd;
    }

    //检查当前消息发送者（msg.sender）是否是合约的所有者（owner）只有当条件满足时，被修饰的函数才会继续执行。
    modifier onlyOwner() {
        require(msg.sender == owner);
        //占位符
        _;
    }

    //withdraw 函数允许合约的所有者从合约中提取所有存储的以太币，并将存储映射中的所有值重置为零
    function withdraw() public payable onlyOwner {
        msg.sender.transfer(address(this).balance);
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            //这行代码将存储映射 addressToAmountFunded 中与当前迭代地址关联的值重置为零
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        //回滚funders数组
        funders = new address[](0);
    }
}

//学习心得
//1：在 Solidity 中，库（library）是一种特殊的合约，它不像普通合约那样可以独立存在
//，而是用来提供可重用的代码片段或功能。库可以包含函数、状态变量和数据类型，但它们不能包含存储数据或被继承。


//2：require是一种用于验证条件的语法结构--require(condition, errorMessage);
//condition是布尔表达式，后面是字符串来表达当布尔判断为错时输出
//require 的作用是在函数执行过程中检查条件是否满足，如果条件不满足，则立即终止函数的执行，并撤销所有对状态的更改
//如果如果 require 的条件判断为 true，则程序会继续执行


//3：在 Solidity 中，可以通过在元组解构语法中使用逗号 , 来表示留空--(, int256 answer, , , ) = priceFeed.latestRoundData();
//该表达式只中包括了预言机返回的最新数据。在这个特定的代码中，虽然有一个元组返回，但实际上只需要其中的第二个值


//4：modifier修饰符的主要用例是在执行函数之前自动检查条件。如果函数不满足修饰符要求，则会抛出异常，并且函数执行停止
//_; 是一个特殊的占位符，通常用于修饰器（modifier）中，表示被修饰的函数的实际执行位置
//pragma solidity ^0.8.0;
// contract MyContract {
//     address public owner;
//     modifier onlyOwner() {
//         require(msg.sender == owner, "Only owner can call this function");
//         _;  // 控制权转移给被修饰的函数
//     }
//     constructor() {
//         owner = msg.sender;
//     }
//     function changeOwner(address _newOwner) public onlyOwner {
//         owner = _newOwner;
//     }
// }
//onlyOwner 修饰器用于限制只有合约的所有者可以调用被修饰的函数。修饰器中的 
//_ 表示被修饰的函数的实际执行位置，即在条件检查通过后，控制权会转移给 changeOwner 函数，使其能够继续执行其余的代码