
window.addEventListener('message', (event) => {
  let msg = event.data

  if (msg.method == 'sendCredentials') {
    document.getElementById('player-name').innerHTML = `Welcome, ${msg.playerName}`
    document.getElementById('player-balance').innerHTML = `Balance: $${msg.balance}`
  }
})

setTimeout(() => {
  window.dispatchEvent(
    new MessageEvent("message", {
      data: {
        method: 'sendCredentials',
        playerName: 'John Doe',
        balance: 400
      },
    })
  );
}, 1000);
