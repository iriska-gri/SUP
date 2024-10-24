<template>
  <component

    :is="layout"
    :class="!$vuetify.theme.dark?'auchlight':'auchdark'"
  ><router-view/></component>
</template>

<script>

export default {
  name: 'App',


  computed: {
    layout(){
      if(this.$route.meta.layout) return this.$route.meta.layout + "-layout"
    }
  }
};
</script>
<style lang="scss">
@import "@/utils/colors.scss";
::-webkit-scrollbar {
    width: 1px;
    height: 6px;
}
/* Track */
::-webkit-scrollbar-track {
   
    -webkit-border-radius: 6px;
    border-radius: 6px;
}
/* Handle */
::-webkit-scrollbar-thumb {
    -webkit-border-radius: 6px;
    border-radius: 6px;
    background: var(--v-scrollbar-base);
  
}
::-webkit-scrollbar-thumb:window-inactive {
    background: var(--v-scrollbar-base); 
}

// .theme--dark .v-icon {
//     color: white !important;
// }

.theme--dark input {
  color: white !important;
}

.theme--light.v-sheet, .v-expansion-panel-header {

  color: var(--v-texthead-base)!important;
}


.auchlight {
    background: rgb(2,0,36)!important;
    background: linear-gradient(333deg, rgba(2,0,36,1) 0%, rgba(9,9,121,1) 35%, rgba(0,212,255,1) 100%)!important;
}

.auchdark {
    background:rgb(162,88,35)!important;
    background: linear-gradient(143deg, rgba(162,88,35) 0%, rgba(119,71,43,1) 27%, rgba(2,0,36,1) 97%)!important;
}

.h1 {
  font-family: "Roboto", sans-serif;
}

input[type=number]::-webkit-inner-spin-button,
input[type=number]::-webkit-outer-spin-button {
opacity: 1;
}

.text-last-center {
  text-align-last: center
}

.peace {
  color: var(--v-inyand2-base)!important;
  
}

.textsize .v-text-field__slot {
  margin-bottom: -5px!important;
}

.v-card__title {
  color: var(--v-card_title-base)
}


a:hover { text-decoration: none !important; }

.bg1 {
  background: goldenrod;
}

.bg2 {
  background: rgb(66, 32, 218);
}

.bg3 {
  background: rgb(32, 218, 72);
}

.bg4 {
  background: rgb(218, 54, 32);
}

.bg5 {
  background: rgb(150, 32, 218);
}

.bg6 {
  background: rgb(32, 106, 218);
}

.bg7 {
  background: rgb(52, 226, 101);
}

.bg8 {
  background: rgb(72, 79, 92);
}

.bg9 {
  background: rgb(180, 231, 147);
}

.bg10 {
  background: rgb(240, 243, 45);
}
  .main-block-content > div {
        height: 100%;
    }


    .h-100 {
      height: 100%;
    }

    .w-100 {
      max-width: 100%!important;
    }


.grow-table {
    display: flex;
    flex-direction: column;
    overflow-y: auto;
        }

.flex-static_row {
  flex: 0 0 auto;
  display: flex  !important;
  flex-direction: row;
  flex-wrap: wrap;
}

.flex-row {
  display: flex !important;
  flex-direction: row;
  flex-wrap: wrap;
}

.flex-col {
  display: flex !important;
  flex-direction: column;
}
.justify-content-end {
  justify-content: end;
}


.pointer{
  cursor: pointer;
}

.vh-100 {
  min-height: 100vh;
}

.w-50 {
  width: 50%;
}

.text-nowrap {
    white-space: nowrap;
}

.text-inyand {
  color:  var(--v-inyand2-base)!important;
}

.justify-content-center {
  justify-content: center;
}

.border-bottom-0 {
  border-bottom: 0px solid black!important;
} 
// ------------------------------------ Стилизация кнопок активных и в спокойном состоянии начало 
.relax_item {
  color:  var(--v-inyand2-base)!important;
  border: 1px solid var(--v-lines_border-base);
  background: var(--v-main_theme-base);
  border-radius: 5px;
}
.select_item {
  color:  var(--v-btns-base)!important;
  border: 1px solid var(--v-select_lines_border-base);
  border-radius: 5px;
}
.v-tab:before {
  background: var(--v-btns-base)!important;
}
.v-tab--active.v-tab:not(:focus)::before {
    opacity: 0;
    background: none!important;
}

.unip {
    font-size: 0.875rem!important;
}

.align-items-center {
  align-items: center;
}

.v-stepper__step__step .v-icon.v-icon {
    font-size: 0.7rem!important;
}

@media (min-width: 1904px) {
  .k {
    background: red;
  }

}
@media (max-width: 1903px) {
  .k {
    background: rgb(0, 81, 255);
  }

}

@media (max-width: 1264px) {
  .k {
    background: rgb(24, 105, 41);
  }

}

@media (max-width: 960px) {
  .k {
    background: rgb(178, 180, 33);
  }

}

@media (max-width: 600px) {
  .k {
    background: rgb(33, 163, 180);
  }

}

.h-0 {
  height: 0px;
}
.v-label, .v-input {
  font-size:  0.9rem!important;
}

.v-input__append-inner .v-icon {
    font-size: 14px!important;

}
.v-data-table-header__icon {
    font-size: 7px!important;
}

.gantPosition {
  position:fixed!important;
  z-index:10;
  bottom:90px;
  width:85%;
  right:12px;
}
</style>

