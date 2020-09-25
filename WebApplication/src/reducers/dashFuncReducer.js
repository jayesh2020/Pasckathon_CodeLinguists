const initialState = {
    appointments: null,
    tests: null,
    reports: null,
    currentReport: {}
}

export default (state= initialState, action) => {
    switch(action.type){
        case 'GET_APPOINTMENTS':
            return {
                ...state,
                appointments: action.payload
            };
        case 'GET_TESTS':
            return {
                ...state,
                tests: action.payload
            }
        case 'GET_REPORTS':
            return {
                ...state,
                reports: action.payload
            }
        case 'SET_CURRENT_REPORT':
            return {
                ...state,
                currentReport: action.payload
            };
        case 'CLEAR_CURRENT_REPORT':
            return {
                ...state,
                currentReport: {}
            };
        default:
            return state;
    }
}