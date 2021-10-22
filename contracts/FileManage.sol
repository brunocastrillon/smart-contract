// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

contract FileManage {
    struct File {
        string Content;
        string Hash;
        string Name;
        string Description;
        string Type;
        uint DateTime;
    }
    mapping(address => File[]) _files;

    event fileAdded(address sender, string name);

    constructor() { }

    modifier onlyValidInformation
    (
        string memory fileContent,
        string memory fileHash,
        string memory fileName
    )
    {
        bytes memory fileContentTemp = bytes(fileContent);
        bytes memory fileHashTemp = bytes(fileHash);
        bytes memory fileNameTemp = bytes(fileName);

        bool informacaoValida = fileContentTemp.length == 0 || fileHashTemp.length == 0 || fileNameTemp.length == 0;
        require(!informacaoValida, 'informacao invalida');
        _;
    }

    function add
    (
        string memory fileContent,
        string memory fileHash,
        string memory fileName,
        string memory fileDescription,
        string memory fileType,
        uint dateTime
    )
        public
        onlyValidInformation(fileContent, fileHash, fileName)
    {
        _files[msg.sender].push(File({
            Content: fileContent,
            Hash: fileHash,
            Name: fileName,
            Description: fileDescription,
            Type: fileType,
            DateTime: dateTime
        }));

        emit fileAdded(msg.sender, fileName);
    }

    function read
    (
        uint index
    )
        public
        view
        returns
        (
            string memory fileContent,
            string memory fileHash,
            string memory fileName,
            string memory fileDescription,
            string memory fileType,
            uint dateTime
        )
    {
        File memory file = _files[msg.sender][index];
        return (
            file.Content,
            file.Hash,
            file.Name,
            file.Description,
            file.Type,
            file.DateTime
        );
    }

    function total()
        public
        view
        returns (uint)
    {
        return _files[msg.sender].length;
    }
}