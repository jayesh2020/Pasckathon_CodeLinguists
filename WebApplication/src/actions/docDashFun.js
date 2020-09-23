import { firestore } from '../firebase/firebase';

export const getAppointments = (uid) => async (dispatch) => {
  firestore
    .doc(`Doctors/${uid}`)
    .collection('Appointments')
    .get()
    .then((querysnapshot) => {
      console.log(querysnapshot);
      const data = querysnapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
      }));
      console.log(data);
      dispatch({
        type: 'DOC_GET_APPOINTMENTS',
        payload: data,
      });
    });
};
