<template>

    <MyIco
      @click="toggleTheme"
      icons = 'mdi-lightbulb-outline'/>


</template>

<script>
export default {
    name: "toggle-theme",

 

    methods: {
      toggleTheme() {
        this.$vuetify.theme.dark = !this.$vuetify.theme.dark;
        localStorage.theme = this.$vuetify.theme.dark       
      }
    },

    mounted() {
    if (localStorage.theme != null) {
      this.$vuetify.theme.dark =  JSON.parse(localStorage.theme)
    }
    
   
    },
}
</script>

<style>

</style>