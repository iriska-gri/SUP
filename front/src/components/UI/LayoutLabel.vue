<template>
<!-- 'pb-2' -->
    <div class="d-flex flex-column">
        <h4
            :class="[disabled?'label-select-disabled':'label-select', 'pb-0']"
        >
            {{ title }}
        </h4>
        <slot></slot>
    </div>
</template>

<script>
export default {
    name: "layout-label",

    props: {
        title: {
            type: String,
        },
        disabled:{
            type: Boolean,
            
        }
    },
   
};
</script>

<style lang="scss" scoped>
    @import "@/utils/colors.scss";
    .label-select .label-select-disabled {
        font-size: 1em;
    }
    .label-select {
        color: var(--v-btns-base);
        font-size: 1em;
    }
    .label-select-disabled {
        color: var(--v-active-base);
        font-size: 1em;
        
    }

    
</style>