import Vue from 'vue'
import Vuex from 'vuex'
// import VueCookie from 'vue-cookie'
import axios from 'axios'
import router from "./../../router";
Vue.use(Vuex)
// Vue.use(VueCookie)


const state = {
    // token: Vue.cookie.get('Stocky_token'),
    isAuthenticated:false,
    Permissions: null,
    user: {},
    loading: false,
    error: null,
    notifs:0,
};


const getters = {
    isAuthenticated: state => state.isAuthenticated,
    currentUser: state => state.user,
    currentUserPermissions: state => state.Permissions,
    loading: state => state.loading,
    notifs_alert: state => state.notifs,
    error: state => state.error
};

const mutations = {
    setLoading(state, data) {
        state.loading = data;
        state.error = null;
    },
    setError(state, data) {
        state.error = data;
        state.loggedInUser = null;
        state.loading = false;
    },
    clearError(state) {
        state.error = null;
    },
    // setLoginCred(state, payload) {
    //     state.token = payload.token;
    //     // state.isAuthenticated = true;
    // },

    setPermissions(state, Permissions) {
        state.Permissions = Permissions;
        // state.user = user;
    },


    setUser(state, user) {
        state.user = user;
    },

    // SET_AUTHENTICATED(state, isAuthenticated) {
    //     state.isAuthenticated = isAuthenticated;
    // },

    Notifs_alert(state, notifs) {
        state.notifs = notifs;
    },

    logout(state) {
        // state.token = null;
        state.user = null;
        state.Permissions = null;
        // state.isAuthenticated = false;
        // Vue.cookie.delete('Stocky_token');
        state.loggedInUser = null;
        state.loading = false;
        state.error = null;
    },
};

const actions = {

    // setLoginCred(context, payload) {
    //     context.commit('setLoading', true)
    //     context.commit('setLoginCred', payload)
    // },

    async refreshUserPermissions(context) {

        await axios.get("GetUserAuth").then((userAuth) => {
            let Permissions = userAuth.data.permissions
            let user = userAuth.data.user
            let notifs = userAuth.data.notifs

            // context.commit('SET_AUTHENTICATED', true)
            context.commit('setPermissions', Permissions)
            context.commit('setUser', user)
            context.commit('Notifs_alert', notifs)
        }).catch(() => {
            // context.commit('SET_AUTHENTICATED', false)
            context.commit('setPermissions', null)
            context.commit('setUser', null)
            context.commit('Notifs_alert', null)
        });
    },

    logout({ commit }) {

        axios({method:'post',  url: '/logout', baseURL: '' })
          .then((userData) => {
            window.location.href='/login';
        })
    },
};

export default {
    state,
    getters,
    actions,
    mutations
};