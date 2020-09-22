import { firestore } from '../firebase/firebase';

export const getDoctors = (uid) => async dispatch => {
    const patient = await firestore.collection('Patients').doc(uid).get();
    const patientData = patient.data();
    console.log(patientData);
    // or get all docs matching the query
    firestore.collection("Doctors")
    .where("city", "==", patientData.city)
    .get()
    .then(querySnapshot => {
        console.log(querySnapshot);
    const data = querySnapshot.docs.map(doc => (
        {
            id: doc.id,
            ...doc.data()
        }
    ));
    dispatch({
        type: 'GET_DOCTORS',
        payload: data
    });
    console.log(data); // array of cities objects
    });
}

export const getDoctor = (uid) => async dispatch => {
    const data = (await firestore.collection('Doctors').doc(uid).get()).data();
    dispatch({
        type: 'SELECTED_DOCTOR',
        payload: data
    });
}