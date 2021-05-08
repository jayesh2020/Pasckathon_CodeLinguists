import { firestore } from '../firebase/firebase';

export const getAppointments = (uid) => async (dispatch) => {
  firestore
    .doc(`Patients/${uid}`)
    .collection('Appointments')
    .get()
    .then((querySnapshot) => {
      console.log(querySnapshot);
      const data = querySnapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
      }));
      console.log(data);
      dispatch({
        type: 'GET_APPOINTMENTS',
        payload: data,
      });
    });
};

export const getTests = (uid) => async (dispatch) => {
  firestore
    .doc(`Patients/${uid}`)
    .collection('Tests')
    .get()
    .then((querySnapshot) => {
      console.log(querySnapshot);
      const data = querySnapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
      }));
      console.log(data);
      dispatch({
        type: 'GET_TESTS',
        payload: data,
      });
    });
}

export const getReports = (uid) => async dispatch => {
    firestore.doc(`Patients/${uid}`).collection('Reports')
    .get()
    .then(querySnapshot => {
        console.log(querySnapshot);
        const data = querySnapshot.docs.map(doc => (
            {
                id: doc.id,
                ...doc.data()
            }
        ));
        console.log(data);
        dispatch({
            type: 'GET_REPORTS',
            payload: data
        });
    });
    
}


export const setCurrentReport = ({report}) => async dispatch => {
    dispatch({
        type:'SET_CURRENT_REPORT',
        payload: report
    });
}

export const clearCurrentReport = () => async dispatch => {
    dispatch({
        type: 'CLEAR_CURRENT_REPORT'
    });
}
