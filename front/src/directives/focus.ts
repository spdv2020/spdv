import { Directive } from 'vue'

const directive: Directive = {
  mounted (el: HTMLElement) {
    el.focus()
  }
}

export default directive
