const initalState = {
  appointments: null,
  currentReport: {}
};

export default (state = initalState, action) => {
  switch (action.type) {
    case 'DOC_GET_APPOINTMENTS':
      return {
        ...state,
        appointments: action.payload,
      };
    case 'SET_CURRENT_REPORT':
      return {
        ...state,
        currentReport: action.payload
      };
    case 'CLEAR_REPORT':
      return {
        ...state,
        currentReport: null
      }
    default:
      return state;
  }
};
