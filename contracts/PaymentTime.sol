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
    uint256 constant _originYear = 1970;

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
        uint256 timestamp
    )
        internal
        pure
        returns (DateTime memory dateTime)
    {
        uint256 secondsAccountedFor = 0;
        uint256 buf;
        uint8 i;

        // Year
        dateTime.Year = getYear(timestamp);
        buf = leapYearsBefore(dateTime.Year) - leapYearsBefore(_originYear);

        secondsAccountedFor += _leapYear * buf;
        secondsAccountedFor += _year * (dateTime.Year - _originYear - buf);

        // Month
        uint256 secondsInMonth;
        for (i = 1; i <= 12; i++) {
            secondsInMonth = _day * getDaysInMonth(i, dateTime.Year);
            if (secondsInMonth + secondsAccountedFor > timestamp) {
                dateTime.Month = i;
                break;
            }
            secondsAccountedFor += secondsInMonth;
        }

        for (i = 1; i <= getDaysInMonth(dateTime.Month, dateTime.Year); i++) {
            if (_day + secondsAccountedFor > timestamp) {
                dateTime.Day = i;
                break;
            }
            secondsAccountedFor += _day;
        }
    }    

    function getYear
    (
        uint256 timestamp
    )
        private
        pure
        returns (uint16)
    {
        uint256 secondsAccountedFor = 0;
        uint16 year;
        uint256 numLeapYears;

        // Year
        year = uint16(_originYear + timestamp / _year);
        numLeapYears = leapYearsBefore(year) - leapYearsBefore(_originYear);

        secondsAccountedFor += _leapYear * numLeapYears;
        secondsAccountedFor +=
            _year *
            (year - _originYear - numLeapYears);

        while (secondsAccountedFor > timestamp) {
            if (isLeapYear(uint16(year - 1))) {
                secondsAccountedFor -= _leapYear;
            } else {
                secondsAccountedFor -= _year;
            }
            year -= 1;
        }
        return year;
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

    function leapYearsBefore
    (
        uint256 year
    )
        private
        pure
        returns (uint256)
    {
        uint256 temp = year -= 1;
        return temp / 4 - temp / 100 + temp / 400;
    }

    function getDaysInMonth
    (
        uint8 month,
        uint16 year
    )
        private
        pure
        returns (uint8)
    {
        if (
            month == 1 ||
            month == 3 ||
            month == 5 ||
            month == 7 ||
            month == 8 ||
            month == 10 ||
            month == 12
        ) {
            return 31;
        } else if (month == 4 || month == 6 || month == 9 || month == 11) {
            return 30;
        } else if (isLeapYear(year)) {
            return 29;
        } else {
            return 28;
        }
    }

    function isLeapYear
    (
        uint16 year
    )
        private
        pure
        returns (bool)
    {
        if (year % 4 != 0) {
            return false;
        }
        if (year % 100 != 0) {
            return true;
        }
        if (year % 400 != 0) {
            return false;
        }
        return true;
    }    
}