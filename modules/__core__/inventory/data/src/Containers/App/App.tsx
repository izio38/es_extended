import React, { useCallback, useEffect, useMemo, useState } from "react";
import { DndProvider } from "react-dnd";
import { TouchBackend } from "react-dnd-touch-backend";
import styled from "styled-components";
import { Item } from "../../components/Item";
import update from "immutability-helper";
import { PlayerTarget } from "../../components/PlayerTarget";
import { RangeSelectorModal } from "../../components/RangeSelectorModal";
import { playerInventoryMock } from "../../mocks/player-inventory-mock";
import { nearPlayersMock } from "../../mocks/near-players.mock";
import { useIsBrowser } from "../../hooks/useIsBrowser";
import { useNuiQuery } from "../../hooks/useNuiQuery";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { ItemPreview } from "../../components/ItemPreview";

const Container = styled.div`
  display: flex;
  flex-direction: row;
  padding: 5px;
`;

const Header = styled.div`
  height: 5vh;
  color: white;
  display: flex;
  justify-content: center;
  border-bottom: solid 1px rgba(60, 60, 60, 0.9);
  padding-top: 4px;
  padding-bottom: 4px;
`;

const InventoryInformations = styled.div`
  height: 8vh;
  border-bottom: solid 1px rgba(60, 60, 60, 0.9);
  padding-top: 4px;
  padding-bottom: 4px;
  color: white;
  display: flex;
  justify-content: center;
`;

const ItemsContainer = styled.div`
  display: flex;
  flex-wrap: wrap;

  max-height: 83vh;

  overflow-y: scroll;

  /* Track */
  ::-webkit-scrollbar-track {
    background: rgba(60, 60, 60, 0.9) !important;
  }

  /* Handle */
  ::-webkit-scrollbar-thumb {
    background: orange;
  }

  /* Handle on hover */
  ::-webkit-scrollbar-thumb:hover {
    background: #555;
  }
`;

const InventoryContainerAlone = styled.div`
  background-color: rgba(0, 0, 0, 0.9);
  overflow-y: hidden;
  height: 97vh;
  border-radius: 6px;
  flex-grow: 3;
  margin: 5px;
  flex-basis: 0;
`;

const InventoryContainer = styled.div`
  background-color: rgba(0, 0, 0, 0.9);
  overflow-y: hidden;
  border-radius: 6px;
  height: 97vh;
  flex-grow: 2;
  margin: 5px;
  flex-basis: 0;
`;

const InterractionContainer = styled.div`
  background-color: rgba(0, 0, 0, 0.9);
  max-height: 60vh;
  flex-grow: 1;
  align-self: safe center;
  border-radius: 6px;

  padding-top: 8px;
  padding-bottom: 8px;

  margin-left: 2vw;
  margin-right: 2vw;

  display: flex;
  flex-direction: column;
  align-items: safe center;
  justify-content: safe space-evenly;

  overflow-y: scroll;

  /* Track */
  ::-webkit-scrollbar-track {
    background: rgba(60, 60, 60, 0.9) !important;
  }

  /* Handle */
  ::-webkit-scrollbar-thumb {
    background: orange;
  }

  /* Handle on hover */
  ::-webkit-scrollbar-thumb:hover {
    background: #555;
  }
`;

export type Item = { name: string; quantity: number };

export type Player = { name: string; playerId: string };

const App = () => {
  const [modalMetadata, setModalMetadata] = useState<{
    targetPlayer?: { name: string; playerId: string };
    itemCount?: number;
    item?: { name: string; quantity: number };
    isOpen: boolean;
  }>({ isOpen: false });

  const isBrowser = useIsBrowser();

  const [items, setItems] = useState<Item[]>([]);
  const [nearPlayers, setNearPlayers] = useState<Player[]>([]);

  const [closeQuery] = useNuiQuery("close");
  useNuiEvent(({ data }) => {
    setItems(data.content);
  }, "openSelfInventory");

  // Set default mock values if we're on browser
  useEffect(() => {
    if (isBrowser) {
      setItems(playerInventoryMock.items);
      setNearPlayers(nearPlayersMock);
    }
  }, [isBrowser]);

  // Close on escape
  useEffect(() => {
    const handleEsc = (event: KeyboardEvent) => {
      if (event.key === "Escape") {
        console.log("Close");
        closeQuery();
      }
    };
    window.addEventListener("keydown", handleEsc);

    return () => {
      window.removeEventListener("keydown", handleEsc);
    };
  }, []);

  const moveItem = useCallback(
    (dragIndex: number, hoverIndex: number) => {
      const dragItem = items[dragIndex];
      setItems(
        update(items, {
          $splice: [
            [dragIndex, 1],
            [hoverIndex, 0, dragItem],
          ],
        })
      );
    },
    [items]
  );

  const onItemDropOnPlayerTarget = useCallback(
    (dragItem: any, player: { name: string; playerId: string }) => {
      const item = items[dragItem.index];
      console.log("Drop on Player Target", item, player);

      setModalMetadata({
        targetPlayer: player,
        itemCount: item.quantity,
        item: item,
        isOpen: true,
      });
    },
    [items]
  );

  return (
    <Container>
      <InventoryContainerAlone>
        <Header>
          <h1> John Doe's bag </h1>
        </Header>
        <InventoryInformations>
          {/* @TODO: Personal information here */}
          {/* <span>10/100</span>
          <div>
            <span>1502$</span>
          </div> */}
        </InventoryInformations>
        <ItemsContainer>
          <DndProvider
            backend={TouchBackend}
            options={{ enableMouseEvents: true, enableTouchEvents: false }}
          >
            {items.map((item, index) => (
              <Item
                key={item.name}
                item={item}
                index={index}
                moveItem={moveItem}
              />
            ))}
            <ItemPreview items={items} />
          </DndProvider>
        </ItemsContainer>
      </InventoryContainerAlone>
      {/* Set visibility to hidden when there is no near player */}
      <InterractionContainer
        style={{ visibility: nearPlayers.length > 0 ? "visible" : "hidden" }}
      >
        <DndProvider backend={TouchBackend} options={{}}>
          {nearPlayers.map((nearPlayer) => (
            <PlayerTarget
              key={nearPlayer.playerId}
              onDrop={(item: any) => onItemDropOnPlayerTarget(item, nearPlayer)}
            >
              {nearPlayer.name}
            </PlayerTarget>
          ))}
        </DndProvider>
      </InterractionContainer>
      {/* @TODO: manage source inventory (->/<-) target inventory drag/drop */}
      {/* <InventoryContainer></InventoryContainer> */}
      <RangeSelectorModal
        onClose={() => setModalMetadata({ isOpen: false })}
        onConfirm={(selectedItemCount) => {
          console.log(selectedItemCount);

          setModalMetadata({ isOpen: false });
        }}
        targetPlayer={modalMetadata?.targetPlayer}
        isOpen={modalMetadata?.isOpen}
        itemCount={modalMetadata?.itemCount || -1}
        item={modalMetadata?.item}
      />
    </Container>
  );
};

export default App;
