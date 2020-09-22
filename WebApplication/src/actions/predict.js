import axios from 'axios';
import { firestore } from '../firebase/firebase';

const predictionsHard = {

};

export const predictDisease = ({fireBaseUrl,uid,fd}) => async (dispatch) => {
  const formData = new FormData();
  formData.append('image', fd);
  try {
    const res = await axios.post('/predict', formData);
    const datei = new Date();
    console.log(datei);
    const data = {
      disease_name: res.data.predictions[0],
      description: '',
      date: datei,
      fireBaseUrl
    };
    const docu = await firestore.doc(`Patients/${uid}`).collection('Tests').add(data);
    console.log(docu);
    dispatch({
      type: 'PREDICT_SUCCESS',
      payload: {
        diseaseName: res.data.predictions[0],
        description: 'alnflsndjlfnsf',
        fireBaseUrl
      },
    });
  } catch (e) {
    console.log(e);
    dispatch({
      type: 'PREDICT_ERROR',
    });
  }
};
