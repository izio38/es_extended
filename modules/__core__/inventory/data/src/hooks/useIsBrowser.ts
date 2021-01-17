import { useEffect, useState } from "react";

export const useIsBrowser = () => {
  const [isBrowser, setIsBrowser] = useState(false);

  useEffect(() => {
    try {
      setIsBrowser((window as any).nuiTargetGame !== "gta5");
    } catch (error) {
      setIsBrowser(true);
    }
  }, [(window as any).nuiTargetGame]);

  return isBrowser;
};
