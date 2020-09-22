const initialState = {
    appointments: null,
    tests: null
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
        default:
            return state;
    }
}