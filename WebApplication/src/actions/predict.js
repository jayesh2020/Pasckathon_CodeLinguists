import axios from 'axios';

const predictionsHard = {

};

export const predictDisease = (fd) => async (dispatch) => {
  const formData = new FormData();
  formData.append('image', fd);
  try {
    const res = await axios.post('/predict', formData);
    
    dispatch({
      type: 'PREDICT_SUCCESS',
      payload: {
        diseaseName: res.data.predictions[0],
        description: 'alnflsndjlfnsf',
      },
    });
  } catch (e) {
    console.log(e);
    dispatch({
      type: 'PREDICT_ERROR',
    });
  }
};
