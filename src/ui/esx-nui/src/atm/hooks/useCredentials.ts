import { useRecoilValue } from 'recoil';
import {atmState} from "./state";
import {Credentials} from "../types/Credentials";

interface CredentialsHook {
  credentials: Credentials | null;
}

export const useCredentials = (): CredentialsHook => {
  const credentials = useRecoilValue(atmState.credentials);
  return { credentials }
}
