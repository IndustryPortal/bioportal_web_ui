import Turbo_frame_controller from "./turbo_frame_controller";

// Connects to data-controller="turbo-frame-error"
export default class extends Turbo_frame_controller {

  static targets = ['frame', 'errorMessage']

  hideError(){
    this.#hideError()
  }

  showError(event) {
    let response = event.detail.fetchResponse
    if (!response.succeeded) {
      response = response.response.clone()
      response.text().then(text => {
          this.#displayError(text)
      })

    }
  }

  #displayError(error){
    let el = document.createElement('div')
    el.innerHTML = error

    let styles = el.getElementsByTagName('style')
    Array.from(styles).forEach(e => el.removeChild(e))

    let body = el.getElementsByTagName('body').item(0)
    this.errorMessageTarget.firstElementChild.appendChild(body ? body : el)
    $(this.errorMessageTarget).show()
  }

  #hideError(){
    let child =this.errorMessageTarget.firstElementChild
    let count = this.errorMessageTarget.firstElementChild.childElementCount
    if(count === 2) {
      child.removeChild(child.lastElementChild)
      $(this.errorMessageTarget).hide()
    }
  }
}
