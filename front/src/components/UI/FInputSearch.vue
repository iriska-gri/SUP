<template>
 <v-col class="pb-3 pt-1 px-1">
    <layout-label
        :title="title"
        :disabled="disabled"
        class="text-nowrap "
    >
        <v-text-field
            @input="$emit('filterreestr')"
            background-color='inputcolor'
            single-line
            solo
            dense
            clearable
            clear-icon="mdi-close"
            v-model="filt"
            hide-details="true"
            :append-outer-icon="appendouter"
            :type="type"
            :disabled="disabled"
        ></v-text-field>
    </layout-label>
 </v-col>
</template>

<script>
export default {
    name: "f-input-search",
    props: {
        field: {
            type: [String, Number],
        },
        type: {
            type: String,
            default: "text",
        },
        title: {
            type: String,
        },
        appendouter:{
            type: String,
            default:""
        },
        disabled: {
            type: Boolean,
            default: false,
        },
    },
    computed: {
        filt: {
            get() {
                return this.$store.getters[`filterslogic/input/${this.field}`];
            },
            set(value) {
                this.$store.dispatch("filterslogic/input/addFilter", { key: this.field, value });
            },
        },
    },
    beforeDestroy() {
        this.$store.dispatch("filterslogic/input/addFilter", { key: this.field, value: '' });
    }
};
</script>

<style lang="scss" scoped>
::v-deep input::-webkit-outer-spin-button,
::v-deep input::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
}
</style>