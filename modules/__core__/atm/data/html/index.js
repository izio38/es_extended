
window.addEventListener('message', (event) => {
  let msg = event.data

  if (msg.method == 'sendCredentials') {
    document.getElementById('player-name').innerHTML = `Welcome, ${msg.data.playerName}`
    document.getElementById('player-balance').innerHTML = `Balance: $${msg.data.balance}`
  }

})

const depositMoney = () => {
  console.log("I just deposited money")

  $.post("http://es_extended/esx:atm:close", JSON.stringify({
    amount: inputAmount
  }))
}

const withdrawMoney = () => {
  console.log("I have taken money away from my balance :(")
  $.post("http://es_extended/esx:atm:withdraw", JSON.stringify({
    amount: inputAmount
  }))
}

const transferMoney = () => {
  // should send both the ID and the amount
  $.post("http://es_extended/esx:atm:transfer", JSON.stringify({
    playerId: playerId,
    amount: inputAmount
  }))
}

document.onkeyup = (data) => {
  if (data.which == 27) {
    // will close the atm when ESC is pressed
  }
}



setTimeout(() => {
  window.dispatchEvent(
    new MessageEvent("message", {
      data: {
        method: 'sendCredentials',
        data: {
          playerName: 'John Doe',
          balance: 400
        }
      },
    })
  );
}, 1000);


