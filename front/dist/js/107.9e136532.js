"use strict";(self["webpackChunkfront"]=self["webpackChunkfront"]||[]).push([[107],{54634:function(t,e,i){i.d(e,{Z:function(){return h}});var s=function(){var t=this,e=t.$createElement,i=t._self._c||e;return i("v-col",{staticClass:"pb-3 pt-1 px-1"},[i("layout-label",{staticClass:"text-nowrap ",attrs:{title:t.title,disabled:t.disabled}},[i("v-text-field",{attrs:{"background-color":"inputcolor","single-line":"",solo:"",dense:"",clearable:"","clear-icon":"mdi-close","hide-details":"true","append-outer-icon":t.appendouter,type:t.type,disabled:t.disabled},on:{input:function(e){return t.$emit("filterreestr")}},model:{value:t.filt,callback:function(e){t.filt=e},expression:"filt"}})],1)],1)},a=[],l={name:"f-input-search",props:{field:{type:[String,Number]},type:{type:String,default:"text"},title:{type:String},appendouter:{type:String,default:""},disabled:{type:Boolean,default:!1}},computed:{filt:{get(){return this.$store.getters[`filterslogic/input/${this.field}`]},set(t){this.$store.dispatch("filterslogic/input/addFilter",{key:this.field,value:t})}}},beforeDestroy(){this.$store.dispatch("filterslogic/input/addFilter",{key:this.field,value:""})}},r=l,n=i(43736),o=i(43453),c=i.n(o),d=i(60266),u=i(17808),p=(0,n.Z)(r,s,a,!1,null,"33e3ee79",null),h=p.exports;c()(p,{VCol:d.Z,VTextField:u.Z})},95107:function(t,e,i){i.r(e),i.d(e,{default:function(){return S}});var s=function(){var t=this,e=t.$createElement,i=t._self._c||e;return i("v-container",{staticClass:"flex-col h-100 w-100 projects",attrs:{fluid:""}},[i("v-row",{staticClass:"flex-grow-0"},[i("v-col",{staticClass:"pa-0"},[i("filters-bar",{staticClass:"pa-1 pb-3",attrs:{header:t.pagetitle},on:{sendData:t.updateData,clear:t.clear},scopedSlots:t._u([{key:"filterslist",fn:function(){return[i("f-input-search",{attrs:{field:"name",title:"Название"}}),i("f-daterange",{attrs:{field:"datestart__gte",title:"Срок начала с:"}}),i("f-daterange",{attrs:{field:"datestart__lte",title:"Срок начала до:"}}),i("f-daterange",{attrs:{field:"dateend__gte",title:"Срок окончания c:"}}),i("f-daterange",{attrs:{field:"dateend__lte",title:"Срок окончания до:"}}),i("f-multi-select",{attrs:{title:"Статус задачи",field:"task__status",disabled:!1}}),i("f-input-search",{attrs:{field:"responsible",title:"Ответственный"}})]},proxy:!0}])})],1)],1),i("v-row",{staticClass:"mt-0 "},[i("v-col",{staticClass:"flex-col pa-1"},[i("v-card",{staticClass:"flex-grow-1"},[i("v-data-table",{staticClass:"grow-table",attrs:{"fixed-header":!0,"disable-pagination":!0,"hide-default-footer":"",headers:t.into_project?t.childHeaders:t.headers,items:t.into_project?t.childList:t.parentList},on:{"dblclick:row":t.clickRow},scopedSlots:t._u([{key:"item.link",fn:function(e){var s=e.item;return[!t.into_project&&s.all>0?i("v-icon",{on:{click:function(e){return e.stopPropagation(),t.toChild(s)}}},[t._v("mdi-chevron-right")]):t.into_project?i("v-icon",{on:{click:function(e){return e.stopPropagation(),t.backParent.apply(null,arguments)}}},[t._v("mdi-chevron-left")]):t._e()]}},t.into_project?{key:"item.id",fn:function(e){var i=e.item;return[t._v(" "+t._s(t.projectid)+"-"+t._s(t.taskid)+"-"+t._s(i.id)+" ")]}}:{key:"item.id",fn:function(e){var i=e.item;return[t._v(" "+t._s(i.parent.id)+"-"+t._s(i.id)+" ")]}},{key:"item.dateend",fn:function(e){var i=e.item;return[t._v(" "+t._s(t.timediff(i.dateend))+" ")]}},{key:"item.lastchanged",fn:function(e){var i=e.item;return[t._v(" "+t._s(t.formatDate(i.lastchanged))+" ")]}},{key:"item.bars",fn:function(e){var s=e.item;return[i("div",{staticClass:"d-flex align-center"},["completed"in s&&s.all>0?[i("v-progress-linear",{staticStyle:{width:"80%"},attrs:{value:s.completed/s.all*100,height:"10","buffer-value":"100"}}),i("div",{staticClass:"ps-2"},[t._v(t._s(s.completed+"/"+s.all))])]:i("div",{staticClass:"mx-auto"},[5==s.status__id?i("v-icon",{staticStyle:{color:"green"}},[t._v("fa-solid fa-square-check")]):t._e()],1),t.superuser?i("v-menu",{attrs:{"offset-x":"",left:""},scopedSlots:t._u([{key:"activator",fn:function(e){var s=e.on,a=e.attrs;return[i("div",t._g(t._b({staticClass:"ms-2 dots-vertical"},"div",a,!1),s),[i("v-icon",[t._v("mdi-dots-vertical")])],1)]}}],null,!0)},[i("v-list",[i("v-list-item",[i("v-list-item-title",[t._v("Удалить")])],1)],1)],1):i("div",{staticStyle:{width:"32px"}}),i("div",{staticClass:"ps-2 dots-vertical",on:{click:function(e){return e.stopPropagation(),t.menu.apply(null,arguments)}}})],2)]}}],null,!0)})],1)],1)],1)],1)},a=[],l=i(30381),r=i.n(l),n=i(20629),o=i(43958),c=i(54634);i(45296);const{mapMutations:d,mapActions:u}=(0,n._p)("filterslogic"),p=(0,n._p)("globalstore");var h={components:{FiltersBar:o.Z,FInputSearch:c.Z},data:()=>({model:"",search:"",ws:null,projectid:null,taskid:null,superuser:!1,childHeaders:[{text:" ",value:"link"},{text:"Код",value:"id"},{text:"Название",value:"name"},{text:"Ответственный",value:"responsible.sn"},{text:"Срок",value:"dateend"},{text:"Статус",value:"status.name"}],headers:[{text:" ",value:"link"},{text:"Код",value:"id"},{text:"Название",value:"name"},{text:"Ответственный",value:"responsible.sn"},{text:"Срок",value:"dateend"},{text:"Статус",value:"status.name"},{text:"Изменено",value:"lastchanged"},{text:"Выполнение",value:"bars"}],into_project:!1,pagetitle:"",menu:!1,childList:[],parentList:[]}),methods:{...p.mapMutations(["set_assign_id"]),...d(["setFields"]),...u(["clear","getFilters","addFilter","activefilters"]),...p.mapGetters(["getassign_id"]),timediff(t){return r()(t).isValid()?r()(t).locale("ru").fromNow():"Не установлен"},formatDate(t){return t&&r()(t).isValid()?r()(t).format("DD.MM.YYYY"):""},build(t){this.into_project?this.childList=t.child:t.payload.length>0?(t.payload.forEach((t=>{t["completed"]=t.task_work.filter((t=>5==t.status.id)).length,t["all"]=t.task_work.length})),this.parentList=t.payload):this.parentList=[]},async updateData(){let t=await this.activefilters();for(let e of Object.keys(t))if(["task__status__in"].includes(e)){let i=[];t[e].forEach((t=>{i.push(t.id)})),t["status__in"]=i,delete t[e]}this.into_project=!1,this.ws.send({action:"getfilter",payload:t})},find_rp(t){const e=t.find((t=>2==t.role.id));return void 0==e?"Не назначен":e.user.sn},update(){console.log("UPDATE")},titler(t=""){"/projects"==this.$route.path?this.pagetitle=this.into_project?`${t}: Задачи`:"Проекты":"/tasks"==this.$route.path?this.pagetitle=this.into_project?`${t}: Работы`:"Задачи":"/works"==this.$route.path?this.pagetitle=this.into_project?`${t}: Поручения`:"Работы":this.pagetitle="Поручения"},toChild(t){this.projectid=t.parent.id,this.taskid=t.id,this.into_project=!0,this.titler(t.name),this.childList=t.task_work},backParent(){this.into_project=!1,this.titler()},clickRow(t,e){let i=this.$route.path,s={"/projects":[{name:"Task",col:"id"},{name:"Project",col:"id"}],"/tasks":[{name:"Work",col:"id"},{name:"Task",col:"id"}],"/works":[{name:"Work",col:"parent"},{name:"Work",col:"id"}],"/assignments":[{name:"Work",col:"parent"},{name:"Work",col:"parent"}]},a=this.into_project?0:1;console.log("новый роут-----",e.item);e.item[s[i][a].col];0==a?this.$router.push({path:`/project/${this.projectid}/task/${this.taskid}/work/${e.item.id}`}):this.$router.push({path:`/project/${e.item.parent.id}/task/${e.item.id}`})},wsconnect(){this.ws=new this.$pws,this.ws.start(`/reestr${this.$route.path}`),this.ws.addEvent("onmessage",(t=>{const e=JSON.parse(t.data);console.log(e,"dataonmess");try{this[e.action](e)}catch(i){console.log(i)}}))}},watch:{$route(t,e){this.ws.stop(),this.into_project=!1,this.childList=[],this.parentList=[],this.titler(),this.wsconnect()}},mounted(){this.superuser=this.$store.getters["auth/getSuperUser"],this.setFields({task__status:{module:"mult"}}),this.getFilters([{task__status:{name:"task__status",sort:"id",related_name:"name"}}],!0).then((async t=>{console.log(t,"data")})),this.wsconnect(),this.titler()},destroyed(){this.ws.stop()}},f=h,m=i(43736),_=i(43453),v=i.n(_),g=i(34145),k=i(60266),w=i(82118),y=i(50629),b=i(4324),x=i(65808),j=i(54525),$=i(79500),C=i(44568),Z=i(29592),V=i(11713),L=(0,m.Z)(f,s,a,!1,null,"4788330e",null),S=L.exports;v()(L,{VCard:g.Z,VCol:k.Z,VContainer:w.Z,VDataTable:y.Z,VIcon:b.Z,VList:x.Z,VListItem:j.Z,VListItemTitle:$.V9,VMenu:C.Z,VProgressLinear:Z.Z,VRow:V.Z})}}]);
//# sourceMappingURL=107.9e136532.js.map