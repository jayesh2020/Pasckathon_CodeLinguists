const initialState = {
    doctors:null,
    selectedDoctor: null,
    error: '',
    questions:null,
    report: {},
    appointment: {}
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
        case 'SET_QUESTIONS':
            return {
                ...state,
                questions: action.payload
            };
        case 'SET_APPOINTMENT':
            return {
                ...state,
                appointment: action.payload
            };
        default:
            return state;
    }
}