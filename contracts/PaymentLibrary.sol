// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// library DateToSecondsLib {
//     uint256 constant _minute = 60;
//     uint256 constant _Hour = 3600;
//     uint256 constant _day = 86400;
//     uint256 constant _week = 604800;
//     uint256 constant _month = 2592000; // - mes com 30 dias
//     uint256 constant _year = 31536000;
//     uint256 constant _leapYear = 31622400;
// }

library DateLib {
    struct DateTime {
        uint16 Year;
        uint16 Month;
        uint16 Day;
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
}

// library StageLib {

// }