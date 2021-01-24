import { Item } from "../Containers/App/App";

export const hasItemsPositionChanged = (oldItems: Item[], newItems: Item[]) => {
  let hasPositionChanged = false;
  for (let index = 0; index < newItems.length; index++) {
    const element = newItems[index];
    if (!oldItems[index] || element.name !== oldItems[index].name) {
      hasPositionChanged = true;
      break;
    }
  }
  return hasPositionChanged;
};
