import { firestore } from '../firebase/firebase';
import { predictDisease } from './predict';

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

export const setQuest = (formData) => async dispatch => {
    dispatch({
        type: 'SET_QUESTIONS',
        payload: formData
    });
}

export const getDoctor = (uid) => async dispatch => {
    const data = (await firestore.collection('Doctors').doc(uid).get()).data();
    const final = {
        uid,
        ...data
    }
    dispatch({
        type: 'SELECTED_DOCTOR',
        payload: final
    });
}

export const bookAppointment = ({timeSlot, dateOf, report, selectedDoctor}) => async dispatch => {
    const patient = await (await firestore.doc(`Patients/${report.patientId}`).get()).data();
    const ref = firestore.doc(`Doctors/${report.doctorId}`);
    const res = await ref.update(selectedDoctor);
    //console.log(dateOf,timeSlot);
    const data = {
        time: timeSlot,
        date: dateOf,
        ...report
    };
    const data1 = {
        time: timeSlot,
        date: dateOf,
        ...report
    }
    const re = await ref.collection('Appointments').add(data);
    const re1 = await firestore.doc(`Patients/${report.patientId}`).collection('Appointments').add(data1);
    console.log(res);
    console.log(re1);
    console.log(re);
    report.progress = 'e';
    await firestore.doc(`Patients/${report.patientId}/Reports/${report.id}`).update({progress: 'e'});
    const data_ref = firestore.doc(`Doctors/${report.doctorId}`).collection('Reports').where("diseaseUrl","==",report.diseaseUrl);
    data_ref.get().then(function(querySnapshot) {
        querySnapshot.forEach(function(doc) {
        doc.ref.update({
            progress: 'e'
        });
        });
    });
    dispatch({
        type: 'SET_APPOINTMENT',
        payload: data
    });
}

export const generateReport = ({ patientUid, predict, doctorSearch, selectedDoctor }) => async dispatch => {
    const patient = await (await firestore.doc(`Patients/${patientUid}`).get()).data();
    const { questions } = doctorSearch;
    const data = {
        progress: 'a',
        patientId: patientUid,
        doctorId: selectedDoctor.uid,
        doctorUrl: selectedDoctor.profilePic,
        patientProfilePic: patient.profilePic,
        diseasePrediction: predict.diseaseName,
        description: predict.description,
        patientName: patient.name,
        patientNumber: patient.phoneNumber,
        patientEmail: patient.email,
        gender: patient.gender,
        city: patient.city,
        patientHeight: patient.height,
        patientWeight: patient.weight,
        allergies: patient.allergies,
        bloodGroup: patient.bloodGroup,
        duration: questions.duration,
        severity: questions.severity,
        timeOfDay: questions.timeOf,
        prevMed: questions.prevMed,
        bodyPart: questions.bodyPart,
        diseaseUrl: predict.fireBaseUrl
    };
    const data1 = {
        progress: 'a',
        patientId: patientUid,
        doctorId: selectedDoctor.uid,
        doctorUrl: selectedDoctor.profilePic,
        doctorName: selectedDoctor.name,
        doctorEmail: selectedDoctor.email,
        patientProfilePic: patient.profilePic,
        diseasePrediction: predict.diseaseName,
        description: predict.description,
        patientName: patient.name,
        patientNumber: patient.phoneNumber,
        patientEmail: patient.email,
        gender: patient.gender,
        city: patient.city,
        patientHeight: patient.height,
        patientWeight: patient.weight,
        allergies: patient.allergies,
        bloodGroup: patient.bloodGroup,
        duration: questions.duration,
        severity: questions.severity,
        timeOfDay: questions.timeOf,
        prevMed: questions.prevMed,
        bodyPart: questions.bodyPart,
        diseaseUrl: predict.fireBaseUrl
    };
    const res = await firestore.doc(`Doctors/${selectedDoctor.uid}`).collection('Reports').add(data);
    const res1 = await firestore.doc(`Patients/${patientUid}`).collection('Reports').add(data1);
    dispatch({
        type: 'SET_REPORT',
        payload: data1
    });
    console.log(res);
}