// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./PaymentStage.sol";

contract PaymentTime is Ownable, PaymentStage {
    uint256 constant _minute = 60;
    uint256 constant _Hour = 3600;
    uint256 constant _day = 86400;
    uint256 constant _week = 604800;
    uint256 constant _month = 2592000; // - mes com 30 dias
    uint256 constant _year = 31536000;
    uint256 constant _leapYear = 31622400;

    struct DateTime {
        uint16 Year;
        uint8 Month;
        uint8 Day;
    }

    struct Date {
        bool Running;
        bytes32 UnitEnd;
        bytes32 UnitDispersion;
        uint256[] Percents;
        uint8 Duration;
        uint8 Every;
        DateTime Start;
        DateTime End;
        DateTime NextPayment;
    }

    Date private _current;

    modifier timeReady() {
        require(_current.Duration != 0, "Time not set");
        require(_current.Every != 0, "Time not set");
        _;
    }

    modifier payDay() {
        DateTime memory time = parseTimeStamp(block.timestamp);
        require(time.Day == _current.NextPayment.Day, "dia de pagamento invalido");
        require(time.Month == _current.NextPayment.Month, "mes de pagamento invalido");
        require(time.Year == _current.NextPayment.Year, "ano de pagamento invalido");
        _;
    }

    function setLapseds
    (
        uint256[] memory percents,
        uint8 every,
        bytes32 unit
    )
        public
        onlyOwner
        atStage(Stages.CREATION)
    {
        uint total = 0;

        for (uint256 i; i < percents.length; i++) {
            total += (percents[i] / 1e2);
        }

        require(total >=99, "invalid percents");

        _current.UnitDispersion = unit;
        _current.Percents = percents;
        _current.Every = every;
    }

    function setEnd
    (
        uint8 duration,
        bytes32 unit
    )
        public
        onlyOwner
        atStage(Stages.CREATION)
    {
        require(unit == "month" || unit == "year" || unit == "day", "invalid time unit");
        _current.Duration = duration;
        _current.UnitEnd = unit;
    } 

    function getStart()
        public
        view
        atStage(Stages.RUNNING)
        returns (uint16, uint8, uint8)        
    {
        return (_current.Start.Year, _current.Start.Month, _current.Start.Day);
    }

    function getEnd()
        public
        view
        atStage(Stages.RUNNING)
        returns (uint16, uint8, uint8)        
    {
         return (_current.End.Year, _current.End.Month, _current.End.Day);
    }

    function getNextPayment()
        public
        view
        atStage(Stages.RUNNING)
        returns (uint16, uint8, uint8)        
    {
        return (_current.NextPayment.Year, _current.NextPayment.Month, _current.NextPayment.Day);
    }

    function setNextPayment()
        internal
    {
        require(_current.Every != 0, "set lapseds first");

        _current.NextPayment = parseTime(
                                    _current.NextPayment,
                                    _current.Every,
                                    _current.UnitDispersion
                                );
    }

    function getTimePercent()
        internal
        view
        returns (uint256[] memory)
    {
        return _current.Percents;
    }

    function exec()
        internal
        atStage(Stages.RUNNING)
    {
        require(_current.Duration != 0, "end time not set");
        require(_current.Every != 0, "lapseds not set");

        DateTime memory dateTime = parseTimeStamp(block.timestamp);

        _current.Start = dateTime;
        _current.NextPayment = parseTime(dateTime, _current.Every, _current.UnitDispersion);
        _current.Running = true;
    }

    // --

    function parseTimeStamp
    (
        uint256 timeStamp
    )
        internal
        pure
        returns (DateTime memory dt)
    {
        
    }    

    function getYear
    (
        uint256 timeStamp
    )
        private
        pure
    {
        
    }

    function getMonth
    (
        uint256 timeStamp
    )
        private
        pure
        returns (uint8)
    {
        return parseTimeStamp(timeStamp).Month;
    }

    function getDay
    (
        uint256 timeStamp
    )
        private
        pure
        returns (uint8)
    {
        return parseTimeStamp(timeStamp).Day;
    }

    function getHour
    (
        uint256 timeStamp
    )
        private
        pure
        returns (uint8)
    {
        return uint8((timeStamp / 60 / 60) % 24);
    }

    function parseTime
    (
        DateTime memory time,
        uint8 duration,
        bytes32 unit
    )
        private
        pure
        returns(DateTime memory dt)
    {
        
    }
}