const initialState = {
  diseaseName: '',
  description: '',
  symtoms:null,
  fireBaseUrl: '',
  error: '',
};
export default (state = initialState, action) => {
  switch (action.type) {
    case 'PREDICT_SUCCESS':
      return {
        ...state,
        diseaseName: action.payload.diseaseName,
        description: action.payload.description,
        symtoms: action.payload.symtoms,
        fireBaseUrl: action.payload.fireBaseUrl
      };
    case 'PREDICT_ERROR':
      return {
        error: 'Enter a valid image!',
      };
    default:
      return state;
  }
};
