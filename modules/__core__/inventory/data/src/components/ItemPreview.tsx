import React, { FunctionComponent, useEffect, useState } from "react";
import { usePreview } from "react-dnd-preview";
import styled from "styled-components";
import { Item } from "../Containers/App/App";

const StyledItem = styled.div`
  height: 128px;
  width: 128px;
  margin: 10px;

  position: relative;

  background-color: rgba(60, 60, 60, 0.9);

  &:hover {
    cursor: move;
  }
`;

const Quantity = styled.span`
  position: absolute;
  top: -2px;
  right: 2px;
  color: white;
`;

export const ItemPreview: FunctionComponent<{ items: Item[] }> = ({
  items,
}) => {
  const { display, itemType, item, style } = usePreview();

  const [imageUrl, setImageUrl] = useState();
  const [quantity, setQuantity] = useState<number>();

  useEffect(() => {
    if (item) {
      const itemData = items[item.index];

      setQuantity(itemData.quantity);

      import(`assets/images/${itemData.name}.png`).then((value) => {
        setImageUrl(value.default);
      });
    }
  }, [item]);

  if (!display) {
    return null;
  }
  return (
    <StyledItem
      style={{
        backgroundImage: `url('${imageUrl}')`,
        ...style,
      }}
    >
      <Quantity>{quantity}</Quantity>
    </StyledItem>
  );
};
