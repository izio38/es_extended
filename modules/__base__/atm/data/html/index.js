$(function() {
  $('.container').hide();

  window.addEventListener('message', (event) => {
    let msg = event.data

    if (msg.method === 'sendCredentials') {
      document.getElementById('player-name').innerHTML = `Welcome, ${msg.data.playerName}`
      document.getElementById('player-balance').innerHTML = `Balance: $${msg.data.balance}`
    }

    if (msg.method === 'setVisibility') {
      if (msg.visibility) {
        $('.container').show();
      } else if (!msg.visibility) {
        $('.container').hide();
      }
    }
  })
})

const depositMoney = () => {
  const inputAmount = $('#input-amount').val();
  window.parent.postMessage({ action: 'esx.deposit', amount: inputAmount }, '*');
  $.post("http://es_extended/esx:atm:deposit", JSON.stringify({
    amount: inputAmount
  }))
}

const withdrawMoney = () => {
  const inputAmount = $('#input-amount').val();
  window.parent.postMessage({ action: 'esx.withdraw', amount: inputAmount }, '*');
  $.post("http://es_extended/esx:atm:withdraw", JSON.stringify({
    amount: inputAmount
  }))
}


let transferAmount;

const transferMoney = () => {
  // should send both the ID and the amount
  const amount = $('#input-amount').val();
  $('.transfer-modal').css('visibility', 'visible')
  transferAmount = amount
}

const confirmTransfer = () => {
  const playerId = $('#playerid').val()
  $.post("http://es_extended/esx:atm:transfer", JSON.stringify({
    playerId: playerId,
    amount: transferAmount
  }))
  $('.transfer-modal').css('visibility', 'hidden')
}

const cancelTransfer = () => {
  $('.transfer-modal').css('visibility', 'hidden')
}

document.onkeyup = (data) => {
  if (data.which === 27) {
    // will close the atm when ESC is pressed
    $('.container').hide();
    $.post("http://es_extended/esx:atm:close", JSON.stringify({}))
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

setTimeout(() => {
  window.dispatchEvent(
    new MessageEvent("message", {
      data: {
        method: 'setVisibility',
        data: true
      },
    })
  );
}, 1000);

setTimeout(() => {
  window.dispatchEvent(
    new MessageEvent("message", {
      data: {
        method: 'setMessage',
        type: 'withdraw',
        variant: 'error'
      },
    })
  );
}, 1000);
