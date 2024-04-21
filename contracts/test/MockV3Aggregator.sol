// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV2V3Interface.sol";

/**
 * @title MockV3Aggregator
 * @notice Based on the FluxAggregator contract
 * @notice Use this contract when you need to test
 * other contract's ability to read data from an
 * aggregator contract, but how the aggregator got
 * its answer is unimportant
 */
 
contract MockV3Aggregator is AggregatorV2V3Interface {
    uint256 public constant override version = 0;
    uint8 public override decimals;//用于表示价格的小数位数
    int256 public override latestAnswer;// 表示 Chainlink 价格聚合器的最新价格答案
    uint256 public override latestTimestamp;// 表示 Chainlink 价格聚合器报告的最新价格答案对应的时间戳
    uint256 public override latestRound;
    //表示 Chainlink 价格聚合器中的最新轮次（或周期）
    //。每次更新价格答案时，都会创建一个新的轮次。latestRound 提供了当前轮次的编号

    //创建三个映射getAnswer，getTimestamp，getStartedAt
    mapping(uint256 => int256) public override getAnswer;
    mapping(uint256 => uint256) public override getTimestamp;
    mapping(uint256 => uint256) private getStartedAt;

    //初始化_decimals，_initialAnswer
    constructor(uint8 _decimals, int256 _initialAnswer) public {
        decimals = _decimals;
        updateAnswer(_initialAnswer);
    }
    //latestAnswer: 保存最新的价格答案。
    //latestTimestamp: 保存当前区块的时间戳。
    //latestRound: 自增，表示最新的轮次。
    //getAnswer[latestRound]: 将最新轮次的答案存储在映射 getAnswer 中。
    //getTimestamp[latestRound]: 将最新轮次的时间戳存储在映射 getTimestamp 中。
    //getStartedAt[latestRound]: 将最新轮次的开始时间存储在映射 getStartedAt 中。
    function updateAnswer(int256 _answer) public {
        latestAnswer = _answer;
        latestTimestamp = block.timestamp;
        latestRound++;
        getAnswer[latestRound] = _answer;
        getTimestamp[latestRound] = block.timestamp;
        getStartedAt[latestRound] = block.timestamp;
    }

    function updateRoundData(
        uint80 _roundId,
        int256 _answer,
        uint256 _timestamp,
        uint256 _startedAt
    ) public {
        latestRound = _roundId;
        latestAnswer = _answer;
        latestTimestamp = _timestamp;
        getAnswer[latestRound] = _answer;
        getTimestamp[latestRound] = _timestamp;
        getStartedAt[latestRound] = _startedAt;
    }

    function getRoundData(uint80 _roundId)
        external
        view
        override
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        return (
            _roundId,
            getAnswer[_roundId],
            getStartedAt[_roundId],
            getTimestamp[_roundId],
            _roundId
        );
    }

    function latestRoundData()
        external
        view
        override
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        return (
            uint80(latestRound),
            getAnswer[latestRound],
            getStartedAt[latestRound],
            getTimestamp[latestRound],
            uint80(latestRound)
        );
    }

    function description() external view override returns (string memory) {
        return "v0.6/tests/MockV3Aggregator.sol";
    }
}

// MockOracle
// Function signatures, event signatures, log topics
