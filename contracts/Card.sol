// SPDX-License-Identifier: GPL-v3
pragma solidity =0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract Card is ERC721 {
    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private counter;

    constructor() ERC721("NFT Card", "CARD") {}

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        bytes memory json = abi.encodePacked(
            '{"name":"#',
            tokenId.toString(),
            '", "image":"',
            getImage(tokenId),
            '"}'
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(json)
                )
            );
    }

    function mint() public {
        counter.increment();
        uint256 tokenId = counter.current();
        _safeMint(msg.sender, tokenId);
    }

    function getImage(uint256 tokenId) public view returns (string memory) {
        address addr = ownerOf(tokenId);
        bytes memory svg = abi.encodePacked(
            '<svg viewBox="0 0 640 360" width="640" height="360" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">',
            '<rect fill="#fff" stroke="#000" stroke-width="5" x="3" y="3" width="634" height="354" rx="20" ry="20"></rect>',
            '<path fill="none" stroke="#000" stroke-width="5" d="M 130.001 130.001 C 149.242 130.001 161.266 109.166 151.65 92.5 C 147.182 84.767 138.925 80 130.001 80 C 110.75 80 98.725 100.833 108.35 117.5 C 112.817 125.233 121.067 130.001 130.001 130.001 Z M 180 171.667 C 180 180 171.667 180 171.667 180 L 88.334 180 C 88.334 180 80 180 80 171.667 C 80 163.333 88.334 138.333 130.001 138.333 C 171.667 138.333 180 163.333 180 171.667 Z"></path>',
            '<text fill="#000" style="font-family: Arial; font-size: 48px;" x="220" y="150">',
            getAbbrAddress(addr),
            "</text></svg>"
        );
        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    }

    function getAbbrAddress(address addr) public view returns (string memory) {
        bytes memory alphabet = "0123456789abcdef";
        bytes memory str = new bytes(13);
        str[0] = bytes1(uint8(48)); // "0"
        str[1] = bytes1(uint8(120)); //"x"
        uint256 data = uint256(uint160(addr));
        str[2] = alphabet[
            (data & 0x00_f000_000000000000000000000000000000000000) >> 156
        ];
        str[3] = alphabet[
            (data & 0x00_0f00_000000000000000000000000000000000000) >> 152
        ];
        str[4] = alphabet[
            (data & 0x00_00f0_000000000000000000000000000000000000) >> 148
        ];
        str[5] = alphabet[
            (data & 0x00_000f_000000000000000000000000000000000000) >> 144
        ];
        str[6] = bytes1(uint8(46)); // ".";
        str[7] = bytes1(uint8(46));
        str[8] = bytes1(uint8(46));
        str[9] = alphabet[
            (data & 0x00_000000000000000000000000000000000000_f000) >> 12
        ];
        str[10] = alphabet[
            (data & 0x00_000000000000000000000000000000000000_0f00) >> 8
        ];
        str[11] = alphabet[
            (data & 0x00_000000000000000000000000000000000000_00f0) >> 4
        ];
        str[12] = alphabet[
            data & 0x00_000000000000000000000000000000000000_000f
        ];
        return string(str);
    }
}
