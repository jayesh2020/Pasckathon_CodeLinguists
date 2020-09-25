import { firestore } from '../firebase/firebase';

export const doctorOnlineSubmit = ({ currentReport, updateReport }) => async dispatch => {
  const newReport = {
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
