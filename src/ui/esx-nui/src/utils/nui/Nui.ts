import { IEvent } from '../types/Event';

export default {
  send(action: string, props = {}, target: string) {
    window.parent.postMessage({ method: action, data: props }, target)
    console.log(action, props, target)
  }
}

