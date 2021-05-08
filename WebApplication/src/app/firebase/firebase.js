import firebase from 'firebase/app';
import 'firebase/firestore';
import 'firebase/auth';
import 'firebase/storage';

var firebaseConfig = {
  apiKey: 'AIzaSyBFTsPCBcPxBzPii-X1aEEGmSrmUmOaxGs',
  authDomain: 'pascathon.firebaseapp.com',
  databaseURL: 'https://pascathon.firebaseio.com',
  projectId: 'pascathon',
  storageBucket: 'pascathon.appspot.com',
  messagingSenderId: '437102869698',
  appId: '1:437102869698:web:b2325541ec3ea85d7f0f5b',
  measurementId: 'G-S1RBQ5K44N',
};

firebase.initializeApp(firebaseConfig);
export const auth = firebase.auth();
export const firestore = firebase.firestore();

export const provider = new firebase.auth.GoogleAuthProvider();
provider.setCustomParameters({
  promt: 'select_account',
});

// Check if user exists if not create a user
export const createUserProfileDocument = async (userAuth) => {
  if (!userAuth) return;

  const { uid, name, email } = userAuth;
  var role;
  const snp = await firestore.doc(`Doctors/${uid}`).get();
  if(!snp.exists){
    role='patient'
  } else {
    role='doctor'
  }
  const userReference = {
    role,
    uid,
    name,
    email,
  };
  return userReference;
};
export const signInWithGoogle = () => {
  auth.signInWithPopup(provider);
};

export const storage = firebase.storage();
