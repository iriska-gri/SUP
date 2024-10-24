import Vue from 'vue'
import VueRouter from 'vue-router'


Vue.use(VueRouter)

function pathfunction(path, name,comp, { layout = 'navigation' }={},prop=true) {
  return { path, name, component: () => import(`@/views/${comp}.vue`), meta: { layout }, props: prop}
}


const routes = [
  pathfunction('/', 'Main', 'Main'),
  pathfunction('/projects', 'Projects','Projects'),
  pathfunction('/tasks', 'Tasks','Tasks'),
  pathfunction('/works', 'Works','Works'),
  pathfunction('/assignments', 'Assignments','Assignments'),
  pathfunction('/project/:id', 'Project','Project'),
  pathfunction('/project/:projectid/task/:id', 'Task','Task'),
  pathfunction('/project/:projectid/task/:taskid/work/:id', 'Work','Work'),
  pathfunction('/events', 'Events','Events'),
  pathfunction('/calendar', 'Calendar','Calendar'),
  pathfunction('/documentation', 'Documentation','Documentation'),
  pathfunction('/competence', 'Competence','Competence'),
  pathfunction('/iteration', 'Iteration','Iteration'),
  pathfunction('/dashboard', 'Dashboard','Dashboard'),
  pathfunction('/raport', 'Raport','Raport'),
  pathfunction('/strategy', 'Strategy','Strategy'),
  pathfunction("/auth", "Auth","Auth", {layout:"auth"}),
  pathfunction("/registration", "Registration","Registration", {layout:"auth"})
  // пути писать сюда
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

router.beforeEach((to, from, next) => {
  const publicPages = ["/auth", "/registration"];
  const authRequired = !publicPages.includes(to.path);
  const loggedIn = JSON.parse(localStorage.getItem('status_login'));
  
  if (authRequired && !loggedIn) {  
    // console.log("piznes");
    return next('/auth');
    // return
  }

  if (!authRequired && loggedIn) {
    return next('/');
  }
  
  next();

})

export default router
