<template>
<v-row class="h-0">
  <v-col class="flex-col h-100">
  
<DxPieChart
    id="pie"
    :data-source="data"
    palette="Bright"
    @point-click="pointClickHandler($event)"
    @legend-click="legendClickHandler($event)"
    :type="'doughnut'"
    :inner-radius=".4"
    class="flex-col h-100"
  > 
  <DxTitle
      :text="title"
      :font="{size:18}"
    />

    <DxSeries
      argument-field="title"
      value-field="percent"
    >
      <DxLabel
        :visible="true"
        :customize-text="formatLabel"
        format="fixedPoint"
      >
        <DxConnector
          :visible="true"
          :width="0.5"
        />
      </DxLabel>
      <DxSmallValuesGrouping
        :threshold="4.5"
        mode="smallValueThreshold"
      />
    </DxSeries>
    <DxLegend
      horizontal-alignment="center"
      vertical-alignment="bottom"
    />
    <DxExport :enabled="true"
    :file-name="title"
    :printing-enabled="false"
    
    ></DxExport>
  </DxPieChart>
  </v-col>
</v-row>
  
</template>

<script>

import DxPieChart, {
    DxTitle,
  DxSeries,
  DxLabel,
  DxConnector,
  DxSmallValuesGrouping,
  DxLegend,
  DxExport,
} from 'devextreme-vue/pie-chart';


export default {
  name:"work-pie-chart",  
  components: {
    DxTitle,
    DxPieChart,
    DxSeries,
    DxLabel,
    DxConnector,
    DxSmallValuesGrouping,
    DxLegend,
    DxExport,
  },
  props:{
    title:{
        type:String,
        default:""
    },
    data:{
        type:Array,
        default:()=>[]
    }
  },
 

  methods: {
    formatLabel(pointInfo) {
      return `${pointInfo.argumentText}: ${pointInfo.valueText}%`;
    },
      pointClickHandler(e) {
      this.toggleVisibility(e.target);
    },
    legendClickHandler(e) {
      const arg = e.target;
      const item = e.component.getAllSeries()[0].getPointsByArg(arg)[0];

      this.toggleVisibility(item);
    },
    toggleVisibility(item) {
      item.isVisible() ? item.hide() : item.show();
    },
  },
};
</script>

<style>
/* #pie {
  height: 100%;


} */

.dxc-title text, .dxc-legend text {
  fill:  var(--v-btns-base)!important;
}

.dx-export-menu-button rect {
  fill: var(--v-btns-base);

}

.dx-export-menu-button path {
  fill: var(--v-inyand-base)
}

</style>
