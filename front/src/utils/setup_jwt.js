import {axiosInstance, updateToken} from '@/utils/api'

const setup = (store) => {

    axiosInstance.interceptors.request.use(
        (config) => {
            const token = store.getters['auth/getToken'];
            // console.log("BOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
            if (token) {
                config.headers["Authorization"] = token;
            }

            return config;
        },
        (error) => {

            return Promise.reject(error);
        }
    )

    axiosInstance.interceptors.response.use(
        (res) => {
            return res;
        },
        async (err) => {

            const originalConfig = err.config;
            const auth = localStorage.getItem("status_login");

            if (auth && err.response) {
                if ((err.response.status === 422 || err.response.status === 403) && !originalConfig._retry) {
                    originalConfig._retry = true;
                    return await updateToken(store, () => axiosInstance(originalConfig))
                }
            }
            
            return Promise.reject(err)
        }
    )
}

export default setup;