const initialState = {
  diseasePredict: true,
  medication: [],
  error: '',
  medDuration: null,
  otherInfo: null,
};

export default (state = initialState, action) => {
  switch (action.type) {
    case 'SET_CONSULT':
      return {
        ...state,
        doctors: action.payload,
      };
    case 'GET_CONSULT_REPORT':
      return {
        ...state,
        report: action.payload,
      };
    default:
      return state;
  }
};
