import React, { useEffect, useRef, useState } from "react";
import { DropTargetMonitor, useDrag, useDrop, XYCoord } from "react-dnd";
import styled from "styled-components";

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

type ItemProps = {
  index: number;
  item: { name: string; quantity: number };
  moveItem: (dragId: number, hoverId: number) => void;
};

export const Item: React.FC<ItemProps> = ({ index, moveItem, item }) => {
  const ref = useRef<HTMLDivElement>(null);

  const [imageUrl, setImageUrl] = useState();

  useEffect(() => {
    import(`assets/images/${item.name}.png`).then((value) => {
      setImageUrl(value.default);
    });
  }, [item.name]);

  const [, drop] = useDrop({
    accept: "item",
    hover(item: any, monitor: DropTargetMonitor) {
      if (!ref.current) {
        return;
      }
      const dragIndex = item.index;
      const hoverIndex = index;

      // Don't replace items with themselves
      if (dragIndex === hoverIndex) {
        return;
      }

      // Determine rectangle on screen
      const hoverBoundingRect = ref.current?.getBoundingClientRect();

      // Get horizontal middle
      const hoverMiddleX =
        (hoverBoundingRect.right - hoverBoundingRect.left) / 2;

      // Determine mouse position
      const clientOffset = monitor.getClientOffset();

      const hoverClientX = (clientOffset as XYCoord).x - hoverBoundingRect.left;

      if (dragIndex > hoverIndex && hoverClientX > hoverMiddleX) {
        return;
      }

      if (dragIndex > hoverIndex && hoverClientX < hoverMiddleX) {
        return;
      }

      // Time to actually perform the action
      moveItem(dragIndex, hoverIndex);

      item.index = hoverIndex;
    },
  });

  const [{ isDragging }, drag] = useDrag({
    item: { type: "item", index },
    collect: (monitor) => ({
      isDragging: monitor.isDragging(),
    }),
  });

  const opacity = isDragging ? 0.5 : 1;
  drag(drop(ref));

  return (
    <StyledItem
      ref={ref}
      style={{
        opacity,
        backgroundImage: `url('${imageUrl}')`,
      }}
    >
      <Quantity>{item.quantity}</Quantity>
    </StyledItem>
  );
};
