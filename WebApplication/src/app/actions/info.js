import { firestore } from '../firebase/firebase';

export const setPersonalInfo = (formData) => async dispatch => {
    dispatch({
        type: 'SET_PERSONAL_INFO',
        payload: formData
    });
}

export const setPatientInfo = (formData) => async dispatch => {
    dispatch({
        type: 'SET_PATIENT_INFO',
        payload: formData
    });
}

export const setDoctorInfo = (formData) => async dispatch => {
    dispatch({
        type: 'SET_DOCTOR_INFO',
        payload: formData
    });
}

export const setPatientUser = ({data,uid}) => async dispatch => {
    console.log(uid);
    const userReference =  firestore.doc(`Patients/${uid}`);
    const snapShot =  await userReference.get();
    //console.log(snapShot);
    if(!snapShot.exists){
        try {
            await userReference.set({
              ...data
            })
          } catch (error) {
             console.log(error)
          }
    }
    
    dispatch({
        type: 'PATIENT_REGISTER'
    })
}

export const setDoctorUser = ({data,uid}) => async dispatch => {
    console.log(uid);
    const userReference =  firestore.doc(`Doctors/${uid}`);
    const snapShot =  await userReference.get();
    //console.log(snapShot);
    if(!snapShot.exists){
        try {
            await userReference.set({
              ...data
            })
          } catch (error) {
             console.log(error)
          }
    }
    
    dispatch({
        type: 'DOCTOR_REGISTER'
    })
}