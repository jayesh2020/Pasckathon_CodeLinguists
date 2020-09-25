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

export const bookAppointment = ({selectedDoctor, predict, timeSlot, dateOf, questions,patientUid,doctorUid}) => async dispatch => {
    const patient = await (await firestore.doc(`Patients/${patientUid}`).get()).data();
    const ref = firestore.doc(`Doctors/${doctorUid}`);
    const res = await ref.update(selectedDoctor);
    //console.log(dateOf,timeSlot);
    const data = {
        time: timeSlot,
        date: dateOf,
        patientName: patient.name,
        patientEmail: patient.email,
        patientProfilePic: patient.profilePic,
        diseasePrediction: predict.diseaseName,
        description: predict.description,
        patientId: patientUid,
        doctorId: selectedDoctor.uid,
        patientNumber: patient.phoneNumber,
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
        time: timeSlot,
        date: dateOf,
        doctorName: selectedDoctor.name,
        doctorEmail: selectedDoctor.email,
        doctorProfilePic: selectedDoctor.profilePic,
        diseasePrediction: predict.diseaseName,
        description: predict.description,
        patientId: patientUid,
        doctorId: selectedDoctor.uid,
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
    }
    const re = await ref.collection('Appointments').add(data);
    const re1 = await firestore.doc(`Patients/${patientUid}`).collection('Appointments').add(data1);
    console.log(res);
    console.log(re1);
    console.log(re);
    dispatch({
        type: 'SET_REPORT',
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
    const res = await firestore.doc(`Doctors/${selectedDoctor.uid}`).collection('Reports').add(data);
    const res1 = await firestore.doc(`Patients/${patientUid}`).collection('Reports').add(data);
    dispatch({
        type: 'SET_REPORT',
        payload: data
    });
    console.log(res);
}