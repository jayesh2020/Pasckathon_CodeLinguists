const initialState = {
    uid: null,
    isAuthenticated: false,
    loading: false,
    error: null,
    user: null
}
export default (state = initialState,action) => {
    switch(action.type) {
        case "REGISTER_SUCCESS":
        case "LOGIN_SUCCESS":
            localStorage.setItem('uid', action.payload.uid);
            return {
                ...state,
                ...action.payload,
                isAuthenticated: true,
                loading: false
            };
        case "REGISTER_FAIL":
        case "AUTH_ERROR":
        case "LOGIN_FAIL":
        case "LOGOUT":
            localStorage.removeItem('token');
            return {
                ...state,
                uid: null,
                isAuthenticated: false,
                loading: false,
                error: action.payload
            };
        case "CLEAR_ERROR":
            return {
                ...state,
                error: null
            };
        case "USER_LOADED":
            return {
                ...state,
                user: action.payload,
                isAuthenticated: true,
                loading: false
            };
        case 'LOAD_USER':
            return {
                ...state,
                uid: action.payload,
                isAuthenticated:true
            };
        case 'SET_USER':
            return {
                ...state,
                user: action.payload
            }
        default:
            return state;
    }
}