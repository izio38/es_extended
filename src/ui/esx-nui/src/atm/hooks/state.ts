import { atom } from 'recoil';

export const atmState = {
  credentials: atom({
    key: 'atmCredentials',
    default: null
  })
}
