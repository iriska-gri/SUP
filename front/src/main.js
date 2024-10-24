import Vue from 'vue'
import App from '@/App.vue'
import router from '@/router'
import store from '@/store'
import vuetify from '@/plugins/vuetify'
import NavigationLayout from "@/layouts/NavigationLayout"
import AuthLayout from "@/layouts/AuthLayout"
import setupAxios from "@/utils/setup_jwt"
import {protectWebsocket} from "@/utils/api"
import components from '@/components/UI/index'
// import { BootstrapVue, IconsPlugin } from 'bootstrap-vue'
import 'devextreme/dist/css/dx.light.css';


// Import Bootstrap and BootstrapVue CSS files (order is important)
// import 'bootstrap/dist/css/bootstrap.css'
// import 'bootstrap-vue/dist/bootstrap-vue.css'

// Make BootstrapVue available throughout your project
// Vue.use(BootstrapVue)
// Optionally install the BootstrapVue icon components plugin
// Vue.use(IconsPlugin)

Vue.component("navigation-layout", NavigationLayout)
Vue.component("auth-layout", AuthLayout)
components.forEach((component) => {
  Vue.component(component.name, component);
})
Vue.config.productionTip = false

setupAxios(store);
protectWebsocket.prototype.store = store;
Vue.prototype.$pws = protectWebsocket;

new Vue({
  router,
  store,
  vuetify,
  render: h => h(App)
}).$mount('#app')

export const bus = new Vue()