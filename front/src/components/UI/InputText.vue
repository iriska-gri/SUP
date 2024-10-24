<template>
    <span
    :class="data?!$vuetify.theme.dark?'font-weight-medium':'inyand2--text':'passiv_text--text '"
    class="inputext inputcolor flex-grow-1 overflow-x-auto rounded-lg px-2 py-1 "
    >
    <slot name="insert"></slot>
    </span>
</template>

<script>
export default {

    name: "InputText",

    props: {
        data:0 
    }
}
</script>


<style lang="scss">
@import "@/utils/colors.scss";

</style>