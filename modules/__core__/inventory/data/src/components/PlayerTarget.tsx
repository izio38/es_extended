import React, { useMemo, useRef } from "react";
import { useDrop } from "react-dnd";

import styled from "styled-components";

const StyledPlayerTarget = styled.div`
  width: 80%;
  padding-top: 4px;
  padding-bottom: 4px;
  line-height: 32px;
  font-size: 32px;
  border: solid 1px grey;
  border-radius: 4px;
  color: orange;
  text-align: center;
  margin: auto;
  margin-top: 8px;
  margin-bottom: 8px;
`;

type PlayerTargetProps = {
  onDrop: (item: any) => void;
};

export const PlayerTarget: React.FC<PlayerTargetProps> = ({
  children,
  onDrop,
}) => {
  const [{ isOver }, drop] = useDrop({
    accept: "item",
    drop: onDrop,
    collect: (monitor) => ({
      isOver: monitor.isOver(),
      canDrop: monitor.canDrop(),
    }),
  });

  const style: React.CSSProperties = useMemo(() => {
    return {
      backgroundColor: isOver ? "orange" : "initial",
      color: isOver ? "white" : "orange",
    };
  }, [isOver]);

  return (
    <StyledPlayerTarget style={style} ref={drop}>
      {children}
    </StyledPlayerTarget>
  );
};
