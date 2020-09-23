const initalState = {
  appointments: null,
};

export default (state = initalState, action) => {
  switch (action.type) {
    case 'DOC_GET_APPOINTMENTS':
      return {
        ...state,
        appointments: action.payload,
      };
    default:
      return state;
  }
};
