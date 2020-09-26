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

export const getReports = (uid) => async (dispatch) => {
  firestore
    .doc(`Doctors/${uid}`)
    .collection('Reports')
    .get()
    .then((querysnapshot) => {
      console.log(querysnapshot);
      const data = querysnapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
      }));
      console.log(data);
      dispatch({
        type: 'DOC_GET_REPORTS',
        payload: data,
      });
    });
};

export const setCurrentReport = ({report}) => async dispatch => {
  dispatch({
      type: 'SET_CURRENT_REPORT',
      payload: report
  });
}

export const changeProgress = ({report,status}) => async dispatch => {
  
  report.progress = status;
  await firestore.doc(`Doctors/${report.doctorId}/Reports/${report.id}`).update({progress: status});
  const data_ref = firestore.doc(`Patients/${report.patientId}`).collection('Reports').where("diseaseUrl","==",report.diseaseUrl);
  data_ref.get().then(function(querySnapshot) {
    querySnapshot.forEach(function(doc) {
      doc.ref.update({
        progress: status
      });
    });
  });
  dispatch({
    type: 'CHANGED_REPORT_STATUS',
    payload: report
  })
}

export const clearCurrentReport = () => async dispatch => {
  dispatch({
    type: 'CLEAR_CURRENT_REPORT'
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


export const clearCurrentAppReport = () => async dispatch => {
  dispatch({
    type: 'CLEAR_CURRENT_APP_REPORT'
  });
}
export const setCurrentAppReport = ({appoint}) => async dispatch => {
  dispatch({
      type: 'SET_CURRENT_APP_REPORT',
      payload: appoint
  });
}
