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

export const setCurrentReport = ({appoint}) => async dispatch => {
  dispatch({
      type: 'SET_CURRENT_REPORT',
      payload: appoint
  });
}

export const cancelAppointment = ({appoint}) => async dispatch => {
  const doctor = await (await firestore.doc(`Doctors/${appoint.doctorId}`).get()).data();
  var lis = doctor.appointments[`${appoint.date}`];
  var a = lis.indexOf(appoint.time);
  lis.splice(a,1);
  doctor.appointments[`${appoint.date}`] = lis;
  await firestore.doc(`Doctors/${appoint.doctorId}`).update(doctor);
  var quer_ref = firestore.doc(`Doctors/${appoint.doctorId}`).collection('Appointments').where("time","==",appoint.time).where("date","==",appoint.date);
  quer_ref.get().then(function(querySnapshot) {
    querySnapshot.forEach(function(doc) {
      doc.ref.delete();
    });
  });
  var quer_ref1 = firestore.doc(`Patients/${appoint.patientId}`).collection('Appointments').where("time","==",appoint.time).where("date","==",appoint.date);
  quer_ref1.get().then(function(querySnapshot) {
    querySnapshot.forEach(function(doc) {
      doc.ref.delete();
    });
  });
}
