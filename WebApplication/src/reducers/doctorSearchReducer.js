const initialState = {
    doctors:null,
    selectedDoctor: null,
    error: ''
};

export default (state = initialState, action) => {
    switch(action.type){
        case 'GET_DOCTORS':
            return {
                ...state,
                doctors: action.payload
            };
        case 'SELECTED_DOCTOR':
            return {
                ...state,
                selectedDoctor: action.payload
            };
        default:
            return state;
    }
}