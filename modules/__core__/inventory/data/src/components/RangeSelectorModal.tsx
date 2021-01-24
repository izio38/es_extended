import React, { useEffect, useState } from "react";
import InputRange from "react-input-range";
import { Button, Modal } from "semantic-ui-react";
import styled from "styled-components";
import "styles/input-range.scss";

type RangeSelectorModalProps = {
  targetPlayer?: { distance: number; playerId: string };
  itemCount: number;
  item?: { name: string; quantity: number };
  isOpen: boolean;
  onClose: () => void;
  onConfirm: (selectedValue: number) => void;
};

export const RangeSelectorModal: React.FC<RangeSelectorModalProps> = ({
  item,
  itemCount,
  targetPlayer,
  isOpen,
  onClose,
  onConfirm,
}) => {
  const [selectedValue, setSelectedValue] = useState<number>(1);

  useEffect(() => setSelectedValue(1), [isOpen]);

  if (!isOpen) {
    return null;
  }

  return (
    <Modal
      size="small"
      closeOnDimmerClick={false}
      closeIcon
      open={isOpen}
      onClose={onClose}
    >
      <Modal.Header>
        Give x{selectedValue} {item?.name} to {targetPlayer?.playerId} (
        {targetPlayer?.distance} meters)
      </Modal.Header>
      <Modal.Content>
        {itemCount > 1 ? (
          <InputRange
            maxValue={itemCount}
            minValue={1}
            value={selectedValue}
            onChange={(value) => setSelectedValue(value as number)}
          />
        ) : null}
      </Modal.Content>
      <Modal.Actions>
        <Button
          disabled={!selectedValue || selectedValue > itemCount}
          primary
          onClick={() => onConfirm(selectedValue)}
        >
          Confirm
        </Button>
      </Modal.Actions>
    </Modal>
  );
};
