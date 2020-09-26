import { firestore } from '../firebase/firebase';

export const doctorOnlineSubmit = ({ currentReport, updateReport }) => async dispatch => {
  console.log("doctoronlinesubmit");
  var newReport = {
    ...currentReport,
    ...updateReport,
    progress: 'c'
  };
  
  await firestore.doc(`Doctors/${currentReport.doctorId}/Reports/${currentReport.id}`).update(newReport);
  const data_ref = firestore.doc(`Patients/${currentReport.patientId}`).collection('Reports').where("diseaseUrl","==",currentReport.diseaseUrl);
  data_ref.get().then(function(querySnapshot) {
    querySnapshot.forEach(function(doc) {
      doc.ref.update(newReport);
    });
  });
  dispatch({
    type: 'CHANGED_REPORT_STATUS',
    payload: newReport
  })
}

export const doctorOnlineSubmit1 = ({ currentAppReport, updateReport }) => async dispatch => {
  console.log("doctroOnlinesubimi1");
  var newReport = {
    ...currentAppReport,
    ...updateReport,
    progress: 'f'
  };
  
  await firestore.doc(`Doctors/${currentAppReport.doctorId}/Appointments/${currentAppReport.id}`).update(newReport);
  const data_ref = firestore.doc(`Patients/${currentAppReport.patientId}`).collection('Appointments').where("diseaseUrl","==",currentAppReport.diseaseUrl);
  data_ref.get().then(function(querySnapshot) {
    querySnapshot.forEach(function(doc) {
      doc.ref.update(newReport);
    });
  });
  //await firestore.doc(`Patients/${currentAppReport.patientId}/Appointments/${currentAppReport.id}`).update({progress: 'f'});
  const data_ref2 =   firestore.doc(`Patients/${currentAppReport.patientId}`).collection("Reports").where("diseaseUrl","==",currentAppReport.diseaseUrl);
  data_ref2.get().then(function(querySnapshot) {
    querySnapshot.forEach(function(doc) {
    doc.ref.update({
        progress: 'f'
    });
    });
  });

  const data_ref1 = firestore.doc(`Doctors/${currentAppReport.doctorId}`).collection('Reports').where("diseaseUrl","==",currentAppReport.diseaseUrl);
    data_ref1.get().then(function(querySnapshot) {
        querySnapshot.forEach(function(doc) {
        doc.ref.update({
            progress: 'f'
        });
        });
    });
  dispatch({
    type: 'CHANGED_REPORT_STATUS_OFFLINE',
    payload: newReport
  })
}
