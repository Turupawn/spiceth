// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

// Import store internals
import { IStore } from "@latticexyz/store/src/IStore.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { StoreCore } from "@latticexyz/store/src/StoreCore.sol";
import { Bytes } from "@latticexyz/store/src/Bytes.sol";
import { Memory } from "@latticexyz/store/src/Memory.sol";
import { SliceLib } from "@latticexyz/store/src/Slice.sol";
import { EncodeArray } from "@latticexyz/store/src/tightcoder/EncodeArray.sol";
import { FieldLayout } from "@latticexyz/store/src/FieldLayout.sol";
import { Schema } from "@latticexyz/store/src/Schema.sol";
import { EncodedLengths, EncodedLengthsLib } from "@latticexyz/store/src/EncodedLengths.sol";
import { ResourceId } from "@latticexyz/store/src/ResourceId.sol";

struct PlayerData {
  int32 x;
  int32 y;
  uint256 commitment;
  bool isAttacked;
  uint256 attackedAt;
}

library Player {
  // Hex below is the result of `WorldResourceIdLib.encode({ namespace: "app", name: "Player", typeId: RESOURCE_TABLE });`
  ResourceId constant _tableId = ResourceId.wrap(0x74626170700000000000000000000000506c6179657200000000000000000000);

  FieldLayout constant _fieldLayout =
    FieldLayout.wrap(0x0049050004042001200000000000000000000000000000000000000000000000);

  // Hex-encoded key schema of (address)
  Schema constant _keySchema = Schema.wrap(0x0014010061000000000000000000000000000000000000000000000000000000);
  // Hex-encoded value schema of (int32, int32, uint256, bool, uint256)
  Schema constant _valueSchema = Schema.wrap(0x0049050023231f601f0000000000000000000000000000000000000000000000);

  /**
   * @notice Get the table's key field names.
   * @return keyNames An array of strings with the names of key fields.
   */
  function getKeyNames() internal pure returns (string[] memory keyNames) {
    keyNames = new string[](1);
    keyNames[0] = "owner";
  }

  /**
   * @notice Get the table's value field names.
   * @return fieldNames An array of strings with the names of value fields.
   */
  function getFieldNames() internal pure returns (string[] memory fieldNames) {
    fieldNames = new string[](5);
    fieldNames[0] = "x";
    fieldNames[1] = "y";
    fieldNames[2] = "commitment";
    fieldNames[3] = "isAttacked";
    fieldNames[4] = "attackedAt";
  }

  /**
   * @notice Register the table with its config.
   */
  function register() internal {
    StoreSwitch.registerTable(_tableId, _fieldLayout, _keySchema, _valueSchema, getKeyNames(), getFieldNames());
  }

  /**
   * @notice Register the table with its config.
   */
  function _register() internal {
    StoreCore.registerTable(_tableId, _fieldLayout, _keySchema, _valueSchema, getKeyNames(), getFieldNames());
  }

  /**
   * @notice Get x.
   */
  function getX(address owner) internal view returns (int32 x) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(uint160(owner)));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (int32(uint32(bytes4(_blob))));
  }

  /**
   * @notice Get x.
   */
  function _getX(address owner) internal view returns (int32 x) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(uint160(owner)));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (int32(uint32(bytes4(_blob))));
  }

  /**
   * @notice Set x.
   */
  function setX(address owner, int32 x) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(uint160(owner)));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((x)), _fieldLayout);
  }

  /**
   * @notice Set x.
   */
  function _setX(address owner, int32 x) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(uint160(owner)));

    StoreCore.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((x)), _fieldLayout);
  }

  /**
   * @notice Get y.
   */
  function getY(address owner) internal view returns (int32 y) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(uint160(owner)));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 1, _fieldLayout);
    return (int32(uint32(bytes4(_blob))));
  }

  /**
   * @notice Get y.
   */
  function _getY(address owner) internal view returns (int32 y) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(uint160(owner)));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 1, _fieldLayout);
    return (int32(uint32(bytes4(_blob))));
  }

  /**
   * @notice Set y.
   */
  function setY(address owner, int32 y) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(uint160(owner)));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 1, abi.encodePacked((y)), _fieldLayout);
  }

  /**
   * @notice Set y.
   */
  function _setY(address owner, int32 y) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(uint160(owner)));

    StoreCore.setStaticField(_tableId, _keyTuple, 1, abi.encodePacked((y)), _fieldLayout);
  }

  /**
   * @notice Get commitment.
   */
  function getCommitment(address owner) internal view returns (uint256 commitment) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(uint160(owner)));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 2, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get commitment.
   */
  function _getCommitment(address owner) internal view returns (uint256 commitment) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(uint160(owner)));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 2, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set commitment.
   */
  function setCommitment(address owner, uint256 commitment) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(uint160(owner)));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 2, abi.encodePacked((commitment)), _fieldLayout);
  }

  /**
   * @notice Set commitment.
   */
  function _setCommitment(address owner, uint256 commitment) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(uint160(owner)));

    StoreCore.setStaticField(_tableId, _keyTuple, 2, abi.encodePacked((commitment)), _fieldLayout);
  }

  /**
   * @notice Get isAttacked.
   */
  function getIsAttacked(address owner) internal view returns (bool isAttacked) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(uint160(owner)));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 3, _fieldLayout);
    return (_toBool(uint8(bytes1(_blob))));
  }

  /**
   * @notice Get isAttacked.
   */
  function _getIsAttacked(address owner) internal view returns (bool isAttacked) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(uint160(owner)));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 3, _fieldLayout);
    return (_toBool(uint8(bytes1(_blob))));
  }

  /**
   * @notice Set isAttacked.
   */
  function setIsAttacked(address owner, bool isAttacked) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(uint160(owner)));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 3, abi.encodePacked((isAttacked)), _fieldLayout);
  }

  /**
   * @notice Set isAttacked.
   */
  function _setIsAttacked(address owner, bool isAttacked) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(uint160(owner)));

    StoreCore.setStaticField(_tableId, _keyTuple, 3, abi.encodePacked((isAttacked)), _fieldLayout);
  }

  /**
   * @notice Get attackedAt.
   */
  function getAttackedAt(address owner) internal view returns (uint256 attackedAt) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(uint160(owner)));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 4, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get attackedAt.
   */
  function _getAttackedAt(address owner) internal view returns (uint256 attackedAt) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(uint160(owner)));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 4, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set attackedAt.
   */
  function setAttackedAt(address owner, uint256 attackedAt) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(uint160(owner)));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 4, abi.encodePacked((attackedAt)), _fieldLayout);
  }

  /**
   * @notice Set attackedAt.
   */
  function _setAttackedAt(address owner, uint256 attackedAt) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(uint160(owner)));

    StoreCore.setStaticField(_tableId, _keyTuple, 4, abi.encodePacked((attackedAt)), _fieldLayout);
  }

  /**
   * @notice Get the full data.
   */
  function get(address owner) internal view returns (PlayerData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(uint160(owner)));

    (bytes memory _staticData, EncodedLengths _encodedLengths, bytes memory _dynamicData) = StoreSwitch.getRecord(
      _tableId,
      _keyTuple,
      _fieldLayout
    );
    return decode(_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Get the full data.
   */
  function _get(address owner) internal view returns (PlayerData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(uint160(owner)));

    (bytes memory _staticData, EncodedLengths _encodedLengths, bytes memory _dynamicData) = StoreCore.getRecord(
      _tableId,
      _keyTuple,
      _fieldLayout
    );
    return decode(_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function set(address owner, int32 x, int32 y, uint256 commitment, bool isAttacked, uint256 attackedAt) internal {
    bytes memory _staticData = encodeStatic(x, y, commitment, isAttacked, attackedAt);

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(uint160(owner)));

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function _set(address owner, int32 x, int32 y, uint256 commitment, bool isAttacked, uint256 attackedAt) internal {
    bytes memory _staticData = encodeStatic(x, y, commitment, isAttacked, attackedAt);

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(uint160(owner)));

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function set(address owner, PlayerData memory _table) internal {
    bytes memory _staticData = encodeStatic(
      _table.x,
      _table.y,
      _table.commitment,
      _table.isAttacked,
      _table.attackedAt
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(uint160(owner)));

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function _set(address owner, PlayerData memory _table) internal {
    bytes memory _staticData = encodeStatic(
      _table.x,
      _table.y,
      _table.commitment,
      _table.isAttacked,
      _table.attackedAt
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(uint160(owner)));

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Decode the tightly packed blob of static data using this table's field layout.
   */
  function decodeStatic(
    bytes memory _blob
  ) internal pure returns (int32 x, int32 y, uint256 commitment, bool isAttacked, uint256 attackedAt) {
    x = (int32(uint32(Bytes.getBytes4(_blob, 0))));

    y = (int32(uint32(Bytes.getBytes4(_blob, 4))));

    commitment = (uint256(Bytes.getBytes32(_blob, 8)));

    isAttacked = (_toBool(uint8(Bytes.getBytes1(_blob, 40))));

    attackedAt = (uint256(Bytes.getBytes32(_blob, 41)));
  }

  /**
   * @notice Decode the tightly packed blobs using this table's field layout.
   * @param _staticData Tightly packed static fields.
   *
   *
   */
  function decode(
    bytes memory _staticData,
    EncodedLengths,
    bytes memory
  ) internal pure returns (PlayerData memory _table) {
    (_table.x, _table.y, _table.commitment, _table.isAttacked, _table.attackedAt) = decodeStatic(_staticData);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function deleteRecord(address owner) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(uint160(owner)));

    StoreSwitch.deleteRecord(_tableId, _keyTuple);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function _deleteRecord(address owner) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(uint160(owner)));

    StoreCore.deleteRecord(_tableId, _keyTuple, _fieldLayout);
  }

  /**
   * @notice Tightly pack static (fixed length) data using this table's schema.
   * @return The static data, encoded into a sequence of bytes.
   */
  function encodeStatic(
    int32 x,
    int32 y,
    uint256 commitment,
    bool isAttacked,
    uint256 attackedAt
  ) internal pure returns (bytes memory) {
    return abi.encodePacked(x, y, commitment, isAttacked, attackedAt);
  }

  /**
   * @notice Encode all of a record's fields.
   * @return The static (fixed length) data, encoded into a sequence of bytes.
   * @return The lengths of the dynamic fields (packed into a single bytes32 value).
   * @return The dynamic (variable length) data, encoded into a sequence of bytes.
   */
  function encode(
    int32 x,
    int32 y,
    uint256 commitment,
    bool isAttacked,
    uint256 attackedAt
  ) internal pure returns (bytes memory, EncodedLengths, bytes memory) {
    bytes memory _staticData = encodeStatic(x, y, commitment, isAttacked, attackedAt);

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    return (_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Encode keys as a bytes32 array using this table's field layout.
   */
  function encodeKeyTuple(address owner) internal pure returns (bytes32[] memory) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(uint160(owner)));

    return _keyTuple;
  }
}

/**
 * @notice Cast a value to a bool.
 * @dev Boolean values are encoded as uint8 (1 = true, 0 = false), but Solidity doesn't allow casting between uint8 and bool.
 * @param value The uint8 value to convert.
 * @return result The boolean value.
 */
function _toBool(uint8 value) pure returns (bool result) {
  assembly {
    result := value
  }
}
