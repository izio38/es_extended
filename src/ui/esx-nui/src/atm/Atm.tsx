import React from 'react';
import Nui from "../utils/nui/Nui";
import styles from './Atm.module.css';
import {useCredentials} from "./hooks/useCredentials";

const Atm = () => {

  const { credentials } = useCredentials()

  return (
    <div className={styles.atmContainer}>
      <div className={styles.header}>
        <h2>Bank: {credentials?.bank.toUpperCase()}</h2>
        <h2>Christopher{credentials?.name}</h2>
        <h2>Current balance: ${credentials?.balance}</h2>
      </div>
    </div>
  )
}

export default Atm;
