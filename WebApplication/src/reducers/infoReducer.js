const initialState = {
    role: '',
    patientInfo:null,
    doctorInfo: null,
    personalInfo:null
}

export default (state=initialState,action) => {
    switch(action.type){
        case 'SET_PERSONAL_INFO': 
            return {
                ...state,
                personalInfo: action.payload
            };
        case 'SET_PATIENT_INFO':
            return {
                ...state,
                role: 'patient',
                patientInfo: action.payload
            };
        case 'SET_DOCTOR_INFO':
            return {
                ...state,
                role: 'doctor',
                doctorInfo: action.payload
            };
        case 'RESET_STATE':
            return {
                role: '',
                patientInfo:null,
                personalInfo:null,
                doctorInfo:null
            };
        default:
            return state;
    }
}